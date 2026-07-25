import 'package:cloud_firestore/cloud_firestore.dart';

// Accès Firestore pour le profil public et le graphe follower/following.
//
// Modèle de données :
//   users/{uid}                        { displayName, email, avatarEmoji,
//                                         streak, achievementsCount,
//                                         createdAt }
//   users/{uid}/following/{autreUid}   { since: Timestamp }
//   users/{uid}/followers/{autreUid}   { since: Timestamp }
//
// follow()/unfollow() écrivent des deux côtés (fan-out) en une seule
// opération atomique, car Firestore n'a pas de relations natives.

class ProfilPublic {
  final String uid;
  final String displayName;
  final String email;
  final String avatarEmoji;
  final int streak;
  final int achievementsCount;
  final int coins;

  const ProfilPublic({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.avatarEmoji,
    required this.streak,
    required this.achievementsCount,
    this.coins = 0,
  });

  factory ProfilPublic.depuisDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final donnees = doc.data() ?? {};
    return ProfilPublic(
      uid: doc.id,
      displayName: donnees['displayName'] as String? ?? 'Sans nom',
      email: donnees['email'] as String? ?? '',
      avatarEmoji: donnees['avatarEmoji'] as String? ?? '👤',
      streak: donnees['streak'] as int? ?? 0,
      achievementsCount: donnees['achievementsCount'] as int? ?? 0,
      coins: donnees['coins'] as int? ?? 0,
    );
  }
}

class SocialService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _utilisateurs =>
      _db.collection('users');

  // À appeler après connexion/inscription, puis à chaque ouverture du
  // compte : garde le profil public à jour avec les valeurs locales (Hive)
  // actuelles, pour que les abonnés voient un streak/score récents.
  Future<void> synchroniserProfil({
    required String uid,
    required String displayName,
    required String email,
    required String avatarEmoji,
    required int streak,
    required int achievementsCount,
    int coins = 0,
  }) {
    return _utilisateurs.doc(uid).set({
      'displayName': displayName,
      'email': email,
      'emailLower': email.toLowerCase(),
      'avatarEmoji': avatarEmoji,
      'streak': streak,
      'achievementsCount': achievementsCount,
      'coins': coins,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<ProfilPublic?> profil(String uid) async {
    final doc = await _utilisateurs.doc(uid).get();
    if (!doc.exists) return null;
    return ProfilPublic.depuisDocument(doc);
  }

  Stream<int> nombreAbonnes(String uid) => _utilisateurs
      .doc(uid)
      .collection('followers')
      .snapshots()
      .map((s) => s.size);

  Stream<int> nombreAbonnements(String uid) => _utilisateurs
      .doc(uid)
      .collection('following')
      .snapshots()
      .map((s) => s.size);

  Stream<List<String>> abonnesUids(String uid) => _utilisateurs
      .doc(uid)
      .collection('followers')
      .snapshots()
      .map((s) => s.docs.map((d) => d.id).toList());

  Stream<List<String>> abonnementsUids(String uid) => _utilisateurs
      .doc(uid)
      .collection('following')
      .snapshots()
      .map((s) => s.docs.map((d) => d.id).toList());

  Future<bool> estAbonne({required String moi, required String autre}) async {
    final doc = await _utilisateurs
        .doc(moi)
        .collection('following')
        .doc(autre)
        .get();
    return doc.exists;
  }

  Future<void> suivre({required String moi, required String autre}) async {
    if (moi == autre) return;

    final lot = _db.batch();
    final maintenant = {'since': FieldValue.serverTimestamp()};

    lot.set(
      _utilisateurs.doc(moi).collection('following').doc(autre),
      maintenant,
    );
    lot.set(
      _utilisateurs.doc(autre).collection('followers').doc(moi),
      maintenant,
    );

    await lot.commit();
  }

  Future<void> neplusSuivre({required String moi, required String autre}) async {
    final lot = _db.batch();

    lot.delete(_utilisateurs.doc(moi).collection('following').doc(autre));
    lot.delete(_utilisateurs.doc(autre).collection('followers').doc(moi));

    await lot.commit();
  }

  // Recherche par correspondance exacte de l'adresse e-mail (pas de
  // recherche floue côté client avec Firestore seul).
  Future<ProfilPublic?> chercherParEmail(String email) async {
    final resultat = await _utilisateurs
        .where('emailLower', isEqualTo: email.trim().toLowerCase())
        .limit(1)
        .get();

    if (resultat.docs.isEmpty) return null;
    return ProfilPublic.depuisDocument(resultat.docs.first);
  }

  // Classement local : moi + les personnes que je suis, triés par série
  // puis par succès. Pas de scoring serveur — juste une lecture ponctuelle
  // des profils publics déjà synchronisés par chacun.
  Future<List<ProfilPublic>> classementAmis(String moi) async {
    final abonnements = await abonnementsUids(moi).first;
    final uids = {moi, ...abonnements};

    final profils = await Future.wait(uids.map(profil));
    final trouves = profils.whereType<ProfilPublic>().toList();

    trouves.sort((a, b) {
      final parStreak = b.streak.compareTo(a.streak);
      if (parStreak != 0) return parStreak;
      return b.achievementsCount.compareTo(a.achievementsCount);
    });

    return trouves;
  }

  // Supprime le profil public et nettoie les abonnements de [uid]. Limite
  // connue : les entrées "following" d'autres utilisateurs qui pointent
  // encore vers [uid], et les entrées de la sous-collection "followers" de
  // [uid] lui-même, ne peuvent être supprimées que par l'abonné concerné
  // (voir firestore.rules — écriture réservée à {autreId}) : elles
  // deviennent orphelines mais sans effet, puisque profil() renvoie null
  // pour un uid supprimé et que l'UI filtre déjà les profils introuvables
  // (voir CompteScreen._afficherListe).
  Future<void> supprimerProfil(String uid) async {
    final suivis = await abonnementsUids(uid).first;

    for (final autre in suivis) {
      await neplusSuivre(moi: uid, autre: autre);
    }

    await _utilisateurs.doc(uid).delete();
  }
}
