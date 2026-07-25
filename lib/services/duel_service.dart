import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:itinera/vocabulaire_data.dart';

// Défis entre amis : un mini-quiz à 10 mots, joué par les deux personnes à
// des moments différents. Le contenu (les mots) est figé dans le document
// au moment de la création, pour que les deux joueurs répondent exactement
// aux mêmes questions même si leur vocabulaire personnalisé diffère.
//
// Modèle Firestore : voir firestore.rules pour les règles d'accès.
//   duels/{defiId} { fromUid, fromNom, fromAvatar, toUid, toNom, toAvatar,
//                    mots: [{latin, francais}], scoreFrom, scoreTo,
//                    statut: 'en_attente' | 'termine', creeLe, termineLe }

class MotDefi {
  final String latin;
  final String francais;

  const MotDefi({required this.latin, required this.francais});

  Map<String, String> versMap() => {'latin': latin, 'francais': francais};

  factory MotDefi.depuisMap(Map map) => MotDefi(
        latin: map['latin'] as String,
        francais: map['francais'] as String,
      );
}

class Defi {
  final String id;
  final String fromUid;
  final String fromNom;
  final String fromAvatar;
  final String toUid;
  final String toNom;
  final String toAvatar;
  final List<MotDefi> mots;
  final int scoreFrom;
  final int? scoreTo;
  final String statut;
  final DateTime? termineLe;

  const Defi({
    required this.id,
    required this.fromUid,
    required this.fromNom,
    required this.fromAvatar,
    required this.toUid,
    required this.toNom,
    required this.toAvatar,
    required this.mots,
    required this.scoreFrom,
    required this.scoreTo,
    required this.statut,
    required this.termineLe,
  });

  bool get termine => statut == 'termine';

  String adversaireNom(String moi) => moi == fromUid ? toNom : fromNom;
  String adversaireAvatar(String moi) => moi == fromUid ? toAvatar : fromAvatar;
  int monScore(String moi) => moi == fromUid ? scoreFrom : (scoreTo ?? 0);
  int scoreAdversaire(String moi) => moi == fromUid ? (scoreTo ?? 0) : scoreFrom;

  factory Defi.depuisDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final donnees = doc.data() ?? {};
    final motsBruts = (donnees['mots'] as List?) ?? [];

    return Defi(
      id: doc.id,
      fromUid: donnees['fromUid'] as String? ?? '',
      fromNom: donnees['fromNom'] as String? ?? 'Sans nom',
      fromAvatar: donnees['fromAvatar'] as String? ?? '👤',
      toUid: donnees['toUid'] as String? ?? '',
      toNom: donnees['toNom'] as String? ?? 'Sans nom',
      toAvatar: donnees['toAvatar'] as String? ?? '👤',
      mots: motsBruts.map((m) => MotDefi.depuisMap(m as Map)).toList(),
      scoreFrom: donnees['scoreFrom'] as int? ?? 0,
      scoreTo: donnees['scoreTo'] as int?,
      statut: donnees['statut'] as String? ?? 'en_attente',
      termineLe: (donnees['termineLe'] as Timestamp?)?.toDate(),
    );
  }
}

// Tire [n] mots au hasard dans le vocabulaire global pour servir de contenu
// à un défi (indépendant du vocabulaire personnalisé de chacun).
List<MotDefi> tirerMotsDefi({int n = 10}) {
  final tirage = List.of(vocabulaire)..shuffle();

  return tirage
      .take(n)
      .map((mot) => MotDefi(latin: mot.latin, francais: mot.francais))
      .toList();
}

class DuelService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _defis => _db.collection('duels');

  Future<String> creerDefi({
    required String moi,
    required String monNom,
    required String monAvatar,
    required String adversaire,
    required String nomAdversaire,
    required String avatarAdversaire,
    required List<MotDefi> mots,
    required int monScore,
  }) async {
    final doc = await _defis.add({
      'fromUid': moi,
      'fromNom': monNom,
      'fromAvatar': monAvatar,
      'toUid': adversaire,
      'toNom': nomAdversaire,
      'toAvatar': avatarAdversaire,
      'mots': mots.map((m) => m.versMap()).toList(),
      'scoreFrom': monScore,
      'scoreTo': null,
      'statut': 'en_attente',
      'creeLe': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  Future<void> repondreDefi({required String defiId, required int monScore}) {
    return _defis.doc(defiId).update({
      'scoreTo': monScore,
      'statut': 'termine',
      'termineLe': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Defi>> defisRecus(String moi) => _defis
      .where('toUid', isEqualTo: moi)
      .where('statut', isEqualTo: 'en_attente')
      .snapshots()
      .map((s) => s.docs.map(Defi.depuisDocument).toList());

  Stream<List<Defi>> defisEnvoyes(String moi) => _defis
      .where('fromUid', isEqualTo: moi)
      .where('statut', isEqualTo: 'en_attente')
      .snapshots()
      .map((s) => s.docs.map(Defi.depuisDocument).toList());

  // Future plutôt que Stream : évite de fusionner deux flux (envoyé/reçu)
  // pour un simple historique consulté ponctuellement (pull-to-refresh).
  Future<List<Defi>> historiqueDefis(String moi) async {
    final envoyes = await _defis
        .where('fromUid', isEqualTo: moi)
        .where('statut', isEqualTo: 'termine')
        .get();

    final recus = await _defis
        .where('toUid', isEqualTo: moi)
        .where('statut', isEqualTo: 'termine')
        .get();

    final tous = [
      ...envoyes.docs.map(Defi.depuisDocument),
      ...recus.docs.map(Defi.depuisDocument),
    ];

    tous.sort((a, b) {
      final dateA = a.termineLe ?? DateTime.fromMillisecondsSinceEpoch(0);
      final dateB = b.termineLe ?? DateTime.fromMillisecondsSinceEpoch(0);
      return dateB.compareTo(dateA);
    });

    return tous;
  }
}
