import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'design/palette.dart';
import 'design/widgets.dart';
import 'firebase_options.dart';
import 'screens/jeu_association_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/quiz_choix_multiple_screen.dart';
import 'screens/vocabulaire_screen.dart';
import 'services/notification_service.dart';
import 'lecons_grammaire_data.dart';
import 'vocabulaire_data.dart';

final scheduler = fsrs.Scheduler();

// Passe à true si Firebase.initializeApp() réussit dans main(). Tant que
// lib/firebase_options.dart contient encore ses valeurs factices (avant que
// l'utilisateur ait lancé `flutterfire configure`, voir FIREBASE_SETUP.md),
// cette variable reste false et CompteScreen affiche un message d'attente
// au lieu de planter — le reste de l'app (tout ce qui est local/Hive)
// continue de fonctionner normalement.
bool firebaseDisponible = false;

// ============================================================
// THEME
// ============================================================

const fond = Color(0xFF121218);
const surfaceWidget = Color(0xFF232230);
const accentViolet = Color(0xFF9F7AEA);
const texteClair = Color(0xFFF2F0F7);
const texteAttenue = Color(0xFFB4AEC4);
const orAntique = Color(0xFFC9A24B);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseDisponible = true;

    // Désactivé en debug pour ne pas polluer Crashlytics avec du bruit de
    // développement — actif dès qu'une version release tourne sur un
    // appareil réel.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      !kDebugMode,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (erreur, pile) {
      FirebaseCrashlytics.instance.recordError(erreur, pile, fatal: true);
      return true;
    };
  } catch (_) {
    // Pas encore configuré (voir FIREBASE_SETUP.md) — l'app continue sans
    // le compte en ligne, tout le reste (vocabulaire, grammaire, etc.)
    // fonctionne comme avant.
    firebaseDisponible = false;
  }

  await Hive.initFlutter();

  await Hive.openBox('vocabBox');

  final box = Hive.box('vocabBox');

  final vocabPersonnalise = box.get(_customVocabKey) as List?;

  if (vocabPersonnalise != null) {
    for (final item in vocabPersonnalise) {
      final donnees = Map<String, dynamic>.from(item as Map);

      vocabulaire.add(
        Vocabulaire(
          latin: donnees['latin'] as String,
          francais: donnees['francais'] as String,
          unite: donnees['unite'] as String,
          categorie: donnees['categorie'] as String,
          etymologie: donnees['etymologie'] as String?,
        ),
      );
    }
  }

  final motsSupprimes = Set<String>.from(
    (box.get(_motsSupprimesKey) as List?) ?? [],
  );

  if (motsSupprimes.isNotEmpty) {
    vocabulaire.removeWhere((mot) => motsSupprimes.contains(cleDuMot(mot)));
  }

  for (final mot in vocabulaire) {
    final donneeLatinVersFrancais = box.get(
      '${mot.latin}::$directionLatinVersFrancais',
    );
    final donneeFrancaisVersLatin = box.get(
      '${mot.latin}::$directionFrancaisVersLatin',
    );

    if (donneeLatinVersFrancais != null) {
      _chargerCarte(mot, directionLatinVersFrancais, donneeLatinVersFrancais);
    } else {
      // Migration : progression enregistrée avant que les deux sens de
      // révision soient indépendants — récupérée côté Latin → Français
      // (le sens par défaut) ; Français → Latin repart de zéro.
      final ancienneDonnee = box.get(mot.latin);
      if (ancienneDonnee != null) {
        _chargerCarte(mot, directionLatinVersFrancais, ancienneDonnee);
      }
    }

    if (donneeFrancaisVersLatin != null) {
      _chargerCarte(mot, directionFrancaisVersLatin, donneeFrancaisVersLatin);
    }
  }

  unawaited(NotificationService().reprogrammerSiActif());

  chargerTemaSauvegarde();

  runApp(const LateinApp());
}

void _chargerCarte(Vocabulaire mot, String direction, dynamic donnee) {
  try {
    mot.definirCarte(
      direction,
      fsrs.Card.fromMap(Map<String, dynamic>.from(donnee)),
    );
  } catch (_) {
    // altes Datenformat (statut/prochaineRevision/intervalle) —
    // kein Crash, das Wort startet einfach wieder als neue Karte
  }
}

// ============================================================
// STREAK
// ============================================================

const _streakCountKey = 'streakCount';
const _streakLastDateKey = 'streakLastDate';

String _cleDuJour(DateTime date) => '${date.year}-${date.month}-${date.day}';

void registrerActiviteDuJour() {
  final box = Hive.box('vocabBox');
  final aujourdHui = DateTime.now();
  final cleAujourdHui = _cleDuJour(aujourdHui);
  final derniereCle = box.get(_streakLastDateKey) as String?;

  if (derniereCle == cleAujourdHui) return;

  final cleHier = _cleDuJour(aujourdHui.subtract(const Duration(days: 1)));
  final cleAvantHier = _cleDuJour(aujourdHui.subtract(const Duration(days: 2)));
  final streakActuelValeur = (box.get(_streakCountKey) as int?) ?? 0;

  int nouveauStreak;

  if (derniereCle == cleHier) {
    nouveauStreak = streakActuelValeur + 1;
  } else if (derniereCle == cleAvantHier && consommerGelDeSerie()) {
    nouveauStreak = streakActuelValeur + 1;
  } else {
    nouveauStreak = 1;
  }

  box.put(_streakCountKey, nouveauStreak);
  box.put(_streakLastDateKey, cleAujourdHui);
}

int streakActuel() {
  final box = Hive.box('vocabBox');
  final derniereCle = box.get(_streakLastDateKey) as String?;

  if (derniereCle == null) return 0;

  final aujourdHui = DateTime.now();
  final cleHier = _cleDuJour(aujourdHui.subtract(const Duration(days: 1)));

  if (derniereCle != _cleDuJour(aujourdHui) && derniereCle != cleHier) {
    return 0;
  }

  return (box.get(_streakCountKey) as int?) ?? 0;
}

// ============================================================
// HISTORIQUE DES RÉVISIONS
// ============================================================

const _historiqueRevisionsKey = 'historiqueRevisions';

void enregistrerRevisionDuJour() {
  final box = Hive.box('vocabBox');
  final cle = _cleDuJour(DateTime.now());

  final historique = Map<String, dynamic>.from(
    (box.get(_historiqueRevisionsKey) as Map?) ?? {},
  );

  historique[cle] = ((historique[cle] as int?) ?? 0) + 1;
  box.put(_historiqueRevisionsKey, historique);
}

// Nombre de révisions par jour sur les [jours] derniers jours (aujourd'hui
// inclus), du plus ancien au plus récent — dernier élément = aujourd'hui.
List<int> historiqueRevisions({int jours = 14}) {
  final box = Hive.box('vocabBox');

  final historique = Map<String, dynamic>.from(
    (box.get(_historiqueRevisionsKey) as Map?) ?? {},
  );

  final aujourdHui = DateTime.now();

  return [
    for (int i = jours - 1; i >= 0; i--)
      (historique[_cleDuJour(aujourdHui.subtract(Duration(days: i)))]
              as int?) ??
          0,
  ];
}

// ============================================================
// POMODORO
// ============================================================

const _pomodorosTerminesKey = 'pomodorosTermines';

int pomodorosTermines() {
  final box = Hive.box('vocabBox');
  return (box.get(_pomodorosTerminesKey) as int?) ?? 0;
}

void enregistrerPomodoroTermine() {
  final box = Hive.box('vocabBox');
  box.put(_pomodorosTerminesKey, pomodorosTermines() + 1);
}

// ============================================================
// PIÈCES
// ============================================================

const _coinsKey = 'coins';

int coins() {
  final box = Hive.box('vocabBox');
  return (box.get(_coinsKey) as int?) ?? 0;
}

void ajouterCoins(int montant) {
  final box = Hive.box('vocabBox');
  box.put(_coinsKey, coins() + montant);
}

bool depenserCoins(int montant) {
  if (coins() < montant) return false;

  final box = Hive.box('vocabBox');
  box.put(_coinsKey, coins() - montant);

  return true;
}

// ============================================================
// BOUTIQUE
// ============================================================

class ArticleBoutique {
  final String id;
  final String nom;
  // Historiquement un vrai emoji ; peut aussi être un identifiant
  // 'chatpfp:N' résolu en image par AvatarGlyphe (voir widgets/avatar_glyphe.dart)
  // pour les têtes de chat achetables.
  final String emoji;
  final int prix;
  final bool estAvatar;

  const ArticleBoutique({
    required this.id,
    required this.nom,
    required this.emoji,
    required this.prix,
    this.estAvatar = true,
  });
}

// Seuls des avatars "chat" (deux planches fournies par l'utilisateur,
// recadrées par AvatarGlyphe) sont proposés — les anciens avatars emoji
// (hibou, temple, aigle...) ont été retirés à la demande de l'utilisateur.
const articlesBoutique = [
  ArticleBoutique(
    id: 'avatar_chat_coeur',
    nom: 'Chat câlin',
    emoji: 'chatpfp:0',
    prix: 60,
  ),
  ArticleBoutique(
    id: 'avatar_chat_etoile',
    nom: 'Chat émerveillé',
    emoji: 'chatpfp:7',
    prix: 90,
  ),
  ArticleBoutique(
    id: 'avatar_chat_lune',
    nom: 'Chat rêveur',
    emoji: 'chatpfp:13',
    prix: 120,
  ),
  ArticleBoutique(
    id: 'avatar_chat_pelote',
    nom: 'Chat en boule',
    emoji: 'chatpfp:22',
    prix: 190,
  ),
  ArticleBoutique(
    id: 'avatar_chat_sauvage',
    nom: 'Chat sauvage',
    emoji: 'chatpfp:27',
    prix: 220,
  ),
  ArticleBoutique(
    id: 'avatar_chat_classique',
    nom: 'Chat classique',
    emoji: 'chatpfp:37',
    prix: 260,
  ),
  ArticleBoutique(
    id: 'avatar_chat_photographe',
    nom: 'Chat photographe',
    emoji: 'chatlecons:1',
    prix: 150,
  ),
  ArticleBoutique(
    id: 'avatar_chat_yinyang',
    nom: 'Chat yin-yang',
    emoji: 'chatlecons:2',
    prix: 180,
  ),
  ArticleBoutique(
    id: 'avatar_chat_musicien',
    nom: 'Chat mélomane',
    emoji: 'chatlecons:4',
    prix: 230,
  ),
  ArticleBoutique(
    id: 'avatar_chat_minimal',
    nom: 'Chat minimal',
    emoji: 'chatlecons:5',
    prix: 130,
  ),
  ArticleBoutique(
    id: 'gel_serie',
    nom: 'Gel de série',
    emoji: '🧊',
    prix: 30,
    estAvatar: false,
  ),
];

const _avatarsPossedesKey = 'avatarsPossedes';
const _avatarEquipeKey = 'avatarEquipe';
const _gelsDeSerieKey = 'gelsDeSerie';

// ============================================================
// APPARENCE
// ============================================================

const _fondEtoileActifKey = 'fondEtoileActif';

// Activé par défaut : le fond étoilé du Parcours était déjà l'état "normal"
// avant que ce réglage n'existe, donc une valeur par défaut à true ne
// change rien pour qui ne touche jamais ce bouton.
bool fondEtoileActif() {
  final box = Hive.box('vocabBox');
  return (box.get(_fondEtoileActifKey) as bool?) ?? true;
}

void definirFondEtoileActif(bool actif) {
  final box = Hive.box('vocabBox');
  box.put(_fondEtoileActifKey, actif);
}

Set<String> avatarsPossedes() {
  final box = Hive.box('vocabBox');
  return Set<String>.from((box.get(_avatarsPossedesKey) as List?) ?? []);
}

String avatarEquipe() {
  final box = Hive.box('vocabBox');
  return (box.get(_avatarEquipeKey) as String?) ?? '👤';
}

// avatarEquipe() renvoie soit l'emoji par défaut ('👤'), soit l'id d'un
// ArticleBoutique acheté (ex. 'avatar_hibou') : il faut le résoudre en
// emoji avant de l'afficher.
String emojiAvatarEquipe() {
  final equipe = avatarEquipe();
  for (final article in articlesBoutique) {
    if (article.id == equipe) return article.emoji;
  }
  return equipe;
}

void equiperAvatar(String id) {
  final box = Hive.box('vocabBox');
  box.put(_avatarEquipeKey, id);
}

int gelsDeSerie() {
  final box = Hive.box('vocabBox');
  return (box.get(_gelsDeSerieKey) as int?) ?? 0;
}

bool consommerGelDeSerie() {
  final actuel = gelsDeSerie();

  if (actuel <= 0) return false;

  final box = Hive.box('vocabBox');
  box.put(_gelsDeSerieKey, actuel - 1);

  return true;
}

bool acheterArticle(ArticleBoutique article) {
  if (!depenserCoins(article.prix)) return false;

  final box = Hive.box('vocabBox');

  if (article.estAvatar) {
    final possedes = avatarsPossedes()..add(article.emoji);
    box.put(_avatarsPossedesKey, possedes.toList());
  } else {
    box.put(_gelsDeSerieKey, gelsDeSerie() + 1);
  }

  return true;
}

// ============================================================
// SUCCÈS
// ============================================================

// Regroupement des succès à l'écran (voir SuccesScreen) : la vocabulaire au
// sens strict n'est qu'une partie de l'app, les leçons de grammaire, la
// régularité et le reste méritent chacun leur section plutôt que d'être
// noyés dans une seule longue liste.
const categorieVocabulaire = 'Vocabulaire';
const categorieLecons = 'Leçons';
const categorieSerie = 'Série';
const categorieDivers = 'Divers';

const categoriesSucces = [
  categorieVocabulaire,
  categorieLecons,
  categorieSerie,
  categorieDivers,
];

class Succes {
  final String id;
  final String titre;
  final String description;
  final IconData icone;
  final String categorie;
  final int recompense;
  final bool Function() estDebloque;

  const Succes({
    required this.id,
    required this.titre,
    required this.description,
    required this.icone,
    required this.categorie,
    required this.estDebloque,
    this.recompense = 20,
  });
}

int _motsApprisTotal() => vocabulaire.where((mot) => !mot.estNouveau).length;

int _leconsTermineesTotal() =>
    construireParcoursComplet().where(leconEstCompletee).length;

final List<Succes> succesDisponibles = [
  Succes(
    id: 'premier_mot',
    titre: 'Premier pas',
    description: 'Apprends ton premier mot',
    icone: Icons.emoji_events,
    categorie: categorieVocabulaire,
    estDebloque: () => _motsApprisTotal() >= 1,
  ),
  Succes(
    id: 'mots_50',
    titre: 'Apprenti',
    description: '50 mots appris',
    icone: Icons.school,
    categorie: categorieVocabulaire,
    estDebloque: () => _motsApprisTotal() >= 50,
  ),
  Succes(
    id: 'mots_200',
    titre: 'Érudit',
    description: '200 mots appris',
    icone: Icons.school,
    categorie: categorieVocabulaire,
    recompense: 40,
    estDebloque: () => _motsApprisTotal() >= 200,
  ),
  Succes(
    id: 'mots_500',
    titre: 'Savant',
    description: '500 mots appris',
    icone: Icons.school,
    categorie: categorieVocabulaire,
    recompense: 60,
    estDebloque: () => _motsApprisTotal() >= 500,
  ),
  Succes(
    id: 'mots_tous',
    titre: 'Magister verborum',
    description: 'Tous les mots appris',
    icone: Icons.workspace_premium,
    categorie: categorieVocabulaire,
    recompense: 100,
    estDebloque: () =>
        vocabulaire.isNotEmpty && _motsApprisTotal() == vocabulaire.length,
  ),
  Succes(
    id: 'mot_perso',
    titre: 'Lexicographe',
    description: 'Ajoute ton premier mot',
    icone: Icons.add_circle,
    categorie: categorieVocabulaire,
    estDebloque: () {
      final box = Hive.box('vocabBox');
      return ((box.get(_customVocabKey) as List?) ?? []).isNotEmpty;
    },
  ),
  Succes(
    id: 'lecon_1',
    titre: 'Premier chapitre',
    description: 'Termine ta première leçon de grammaire',
    icone: Icons.menu_book,
    categorie: categorieLecons,
    estDebloque: () => _leconsTermineesTotal() >= 1,
  ),
  Succes(
    id: 'lecons_10',
    titre: 'Sur la bonne voie',
    description: '10 leçons de grammaire terminées',
    icone: Icons.menu_book,
    categorie: categorieLecons,
    recompense: 30,
    estDebloque: () => _leconsTermineesTotal() >= 10,
  ),
  Succes(
    id: 'lecons_25',
    titre: 'Grammairien',
    description: '25 leçons de grammaire terminées',
    icone: Icons.menu_book,
    categorie: categorieLecons,
    recompense: 50,
    estDebloque: () => _leconsTermineesTotal() >= 25,
  ),
  Succes(
    id: 'lecons_50',
    titre: 'Latiniste confirmé',
    description: '50 leçons de grammaire terminées',
    icone: Icons.menu_book,
    categorie: categorieLecons,
    recompense: 70,
    estDebloque: () => _leconsTermineesTotal() >= 50,
  ),
  Succes(
    id: 'lecons_toutes',
    titre: 'Magister grammaticus',
    description: 'Tout le parcours de grammaire terminé',
    icone: Icons.workspace_premium,
    categorie: categorieLecons,
    recompense: 100,
    estDebloque: () {
      final total = construireParcoursComplet().length;
      return total > 0 && _leconsTermineesTotal() == total;
    },
  ),
  Succes(
    id: 'serie_3',
    titre: 'Sur la lancée',
    description: '3 jours de suite',
    icone: Icons.local_fire_department,
    categorie: categorieSerie,
    estDebloque: () => streakActuel() >= 3,
  ),
  Succes(
    id: 'serie_7',
    titre: 'Une semaine',
    description: '7 jours de suite',
    icone: Icons.local_fire_department,
    categorie: categorieSerie,
    recompense: 30,
    estDebloque: () => streakActuel() >= 7,
  ),
  Succes(
    id: 'serie_30',
    titre: 'Habitude romaine',
    description: '30 jours de suite',
    icone: Icons.local_fire_department,
    categorie: categorieSerie,
    recompense: 80,
    estDebloque: () => streakActuel() >= 30,
  ),
  Succes(
    id: 'pomodoro_1',
    titre: 'Premier sprint',
    description: 'Termine un Pomodoro',
    icone: Icons.local_cafe,
    categorie: categorieDivers,
    estDebloque: () => pomodorosTermines() >= 1,
  ),
  Succes(
    id: 'pomodoro_10',
    titre: 'Concentré',
    description: '10 Pomodoros terminés',
    icone: Icons.local_cafe,
    categorie: categorieDivers,
    recompense: 40,
    estDebloque: () => pomodorosTermines() >= 10,
  ),
  Succes(
    id: 'coins_100',
    titre: 'Petit trésor',
    description: 'Amasse 100 deniers',
    icone: Icons.savings,
    categorie: categorieDivers,
    recompense: 0,
    estDebloque: () => coins() >= 100,
  ),
];

const _succesDebloquesKey = 'succesDebloques';

Set<String> succesDebloques() {
  final box = Hive.box('vocabBox');
  return Set<String>.from((box.get(_succesDebloquesKey) as List?) ?? []);
}

List<Succes> verifierNouveauxSucces() {
  final debloques = succesDebloques();
  final nouveaux = <Succes>[];

  for (final succes in succesDisponibles) {
    if (debloques.contains(succes.id)) continue;

    if (succes.estDebloque()) {
      debloques.add(succes.id);
      if (succes.recompense > 0) ajouterCoins(succes.recompense);
      nouveaux.add(succes);
    }
  }

  if (nouveaux.isNotEmpty) {
    final box = Hive.box('vocabBox');
    box.put(_succesDebloquesKey, debloques.toList());
  }

  return nouveaux;
}

void verifierSuccesEtNotifier(BuildContext context) {
  final nouveaux = verifierNouveauxSucces();

  for (final succes in nouveaux) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🏆 Succès débloqué : ${succes.titre}'
          '${succes.recompense > 0 ? ' (+${succes.recompense} deniers)' : ''}',
        ),
        backgroundColor: accentViolet,
      ),
    );
  }
}

// ============================================================
// VOCABULAIRE PERSONNALISÉ
// ============================================================

const _customVocabKey = 'customVocab';

void ajouterVocabulairePersonnalise({
  required String latin,
  required String francais,
  required String unite,
  required String categorie,
  String? etymologie,
}) {
  final nouveauMot = Vocabulaire(
    latin: latin,
    francais: francais,
    unite: unite,
    categorie: categorie,
    etymologie: (etymologie == null || etymologie.trim().isEmpty)
        ? null
        : etymologie.trim(),
  );

  vocabulaire.add(nouveauMot);

  final box = Hive.box('vocabBox');

  final vocabPersonnalise = List<Map>.from(
    (box.get(_customVocabKey) as List?) ?? [],
  );

  vocabPersonnalise.add({
    'latin': nouveauMot.latin,
    'francais': nouveauMot.francais,
    'unite': nouveauMot.unite,
    'categorie': nouveauMot.categorie,
    'etymologie': nouveauMot.etymologie,
  });

  box.put(_customVocabKey, vocabPersonnalise);
}

const _motsSupprimesKey = 'motsSupprimes';

String cleDuMot(Vocabulaire mot) =>
    '${mot.latin}|${mot.unite}|${mot.categorie}';

void supprimerVocabulaire(Vocabulaire mot) {
  final box = Hive.box('vocabBox');

  final motsSupprimes = List<String>.from(
    (box.get(_motsSupprimesKey) as List?) ?? [],
  );

  motsSupprimes.add(cleDuMot(mot));
  box.put(_motsSupprimesKey, motsSupprimes);

  final vocabPersonnalise = List<Map>.from(
    (box.get(_customVocabKey) as List?) ?? [],
  );

  vocabPersonnalise.removeWhere((item) {
    final donnees = Map<String, dynamic>.from(item);
    return donnees['latin'] == mot.latin &&
        donnees['unite'] == mot.unite &&
        donnees['categorie'] == mot.categorie;
  });

  box.put(_customVocabKey, vocabPersonnalise);
  box.delete(mot.latin);

  vocabulaire.remove(mot);
}

// ============================================================
// MES TEXTES (textes personnels à analyser/traduire)
// ============================================================

class TagMot {
  final int index; // position du mot dans le texte tokenisé
  final String mot;
  final String fonction;

  const TagMot({
    required this.index,
    required this.mot,
    required this.fonction,
  });

  Map<String, dynamic> versMap() => {
    'index': index,
    'mot': mot,
    'fonction': fonction,
  };

  static TagMot depuisMap(Map map) => TagMot(
    index: map['index'] as int,
    mot: map['mot'] as String,
    fonction: map['fonction'] as String,
  );
}

class MonTexte {
  final String id;
  final String titre;
  final String texte;
  final List<TagMot> tags;

  const MonTexte({
    required this.id,
    required this.titre,
    required this.texte,
    this.tags = const [],
  });
}

const _mesTextesKey = 'mesTextes';

List<MonTexte> mesTextes() {
  final box = Hive.box('vocabBox');
  final liste = (box.get(_mesTextesKey) as List?) ?? [];

  return liste.map((item) {
    final donnees = Map<String, dynamic>.from(item as Map);
    final tagsBruts = (donnees['tags'] as List?) ?? [];

    return MonTexte(
      id: donnees['id'] as String,
      titre: donnees['titre'] as String,
      texte: donnees['texte'] as String,
      tags: tagsBruts
          .map((t) => TagMot.depuisMap(Map<String, dynamic>.from(t as Map)))
          .toList(),
    );
  }).toList();
}

void _sauvegarderMesTextes(List<MonTexte> textes) {
  final box = Hive.box('vocabBox');

  box.put(
    _mesTextesKey,
    textes
        .map(
          (t) => {
            'id': t.id,
            'titre': t.titre,
            'texte': t.texte,
            'tags': t.tags.map((tag) => tag.versMap()).toList(),
          },
        )
        .toList(),
  );
}

MonTexte ajouterMonTexte(String titre, String texte) {
  final nouveau = MonTexte(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    titre: titre,
    texte: texte,
  );

  final textes = mesTextes()..add(nouveau);
  _sauvegarderMesTextes(textes);

  return nouveau;
}

void mettreAJourTagsTexte(String id, List<TagMot> tags) {
  final textes = mesTextes();
  final index = textes.indexWhere((t) => t.id == id);
  if (index == -1) return;

  textes[index] = MonTexte(
    id: textes[index].id,
    titre: textes[index].titre,
    texte: textes[index].texte,
    tags: tags,
  );

  _sauvegarderMesTextes(textes);
}

void supprimerMonTexte(String id) {
  final textes = mesTextes()..removeWhere((t) => t.id == id);
  _sauvegarderMesTextes(textes);
}

// Recherche dans le vocabulaire de classe (même logique que RechercheScreen).
List<Vocabulaire> chercherDansVocabulaire(String mot) {
  final requete = mot.trim().toLowerCase();
  if (requete.isEmpty) return [];

  return vocabulaire.where((v) {
    return v.latin.toLowerCase().contains(requete) ||
        v.francais.toLowerCase().contains(requete);
  }).toList();
}

Future<bool> confirmerSuppression(BuildContext context, Vocabulaire mot) async {
  final confirme = await showDialog<bool>(
    context: context,
    builder: (context) {
      return FeuilleDesign(
        child: AlertDialog(
          title: const Text('Supprimer ce mot ?'),
          content: Text('« ${mot.latin} » sera définitivement supprimé.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Supprimer'),
            ),
          ],
        ),
      );
    },
  );

  if (confirme == true) {
    supprimerVocabulaire(mot);
    return true;
  }

  return false;
}

// ============================================================
// UNITÉS : RENOMMAGE ET RÉINITIALISATION
// ============================================================

const _renommageUnitesKey = 'renommageUnites';

Map<String, String> renommageUnites() {
  final box = Hive.box('vocabBox');
  return Map<String, String>.from((box.get(_renommageUnitesKey) as Map?) ?? {});
}

String nomAffiche(String unite) => renommageUnites()[unite] ?? unite;

void renommerUnite(String unite, String nouveauNom) {
  final box = Hive.box('vocabBox');
  final renommages = renommageUnites();

  final nom = nouveauNom.trim();

  if (nom.isEmpty || nom == unite) {
    renommages.remove(unite);
  } else {
    renommages[unite] = nom;
  }

  box.put(_renommageUnitesKey, renommages);
}

Future<void> renommerUniteDialog(BuildContext context, String unite) async {
  final controleur = TextEditingController(text: nomAffiche(unite));

  final nouveauNom = await showDialog<String>(
    context: context,
    builder: (context) {
      return FeuilleDesign(
        child: AlertDialog(
          title: const Text('Renommer cette unité'),
          content: TextField(
            controller: controleur,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Nom affiché'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controleur.text),
              child: const Text('Renommer'),
            ),
          ],
        ),
      );
    },
  );

  if (nouveauNom != null) {
    renommerUnite(unite, nouveauNom);
  }
}

void reinitialiserProgression({String? unite}) {
  final box = Hive.box('vocabBox');

  final mots = unite == null
      ? vocabulaire
      : vocabulaire.where((mot) => mot.unite == unite).toList();

  for (final mot in mots) {
    mot.definirCarte(
      directionLatinVersFrancais,
      fsrs.Card(cardId: mot.latin.hashCode),
    );
    mot.definirCarte(
      directionFrancaisVersLatin,
      fsrs.Card(cardId: mot.latin.hashCode),
    );
    box.delete('${mot.latin}::$directionLatinVersFrancais');
    box.delete('${mot.latin}::$directionFrancaisVersLatin');
    box.delete(mot.latin);
  }
}

Future<bool> confirmerReinitialisation(
  BuildContext context, {
  String? unite,
}) async {
  final confirme = await showDialog<bool>(
    context: context,
    builder: (context) {
      return FeuilleDesign(
        child: AlertDialog(
          title: const Text('Réinitialiser la progression ?'),
          content: Text(
            unite == null
                ? 'Toute ta progression (tous les mots, toutes les unités) '
                      'sera remise à zéro. Cette action est irréversible.'
                : 'La progression de « ${nomAffiche(unite)} » sera remise à '
                      'zéro. Cette action est irréversible.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Réinitialiser'),
            ),
          ],
        ),
      );
    },
  );

  if (confirme == true) {
    reinitialiserProgression(unite: unite);
    return true;
  }

  return false;
}

void supprimerUnite(String unite) {
  final mots = vocabulaire.where((mot) => mot.unite == unite).toList();

  for (final mot in mots) {
    supprimerVocabulaire(mot);
  }

  renommerUnite(unite, '');
}

Future<bool> confirmerSuppressionUnite(
  BuildContext context,
  String unite,
) async {
  final confirme = await showDialog<bool>(
    context: context,
    builder: (context) {
      return FeuilleDesign(
        child: AlertDialog(
          title: const Text('Supprimer cette unité ?'),
          content: Text(
            'Tous les mots de « ${nomAffiche(unite)} » et leur progression '
            'seront supprimés définitivement. Cette action est irréversible.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Supprimer'),
            ),
          ],
        ),
      );
    },
  );

  if (confirme == true) {
    supprimerUnite(unite);
    return true;
  }

  return false;
}

Future<void> gererUnite(BuildContext context, String unite) async {
  final action = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: designBlanc,
    builder: (context) {
      return FeuilleDesign(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Renommer'),
                onTap: () => Navigator.pop(context, 'renommer'),
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt),
                title: const Text('Réinitialiser la progression'),
                onTap: () => Navigator.pop(context, 'reinitialiser'),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Supprimer cette unité',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => Navigator.pop(context, 'supprimer'),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (action == 'renommer' && context.mounted) {
    await renommerUniteDialog(context, unite);
  } else if (action == 'reinitialiser' && context.mounted) {
    await confirmerReinitialisation(context, unite: unite);
  } else if (action == 'supprimer' && context.mounted) {
    await confirmerSuppressionUnite(context, unite);
  }
}

// ============================================================
// VOLUMES (Vol. I/II/III — regroupement d'unités par année scolaire)
// ============================================================

// Vol. I/II/III du manuel correspondent chacun à une année de collège.
const anneesParVolume = {
  'Vol. I': 'Sixième',
  'Vol. II': 'Cinquième',
  'Vol. III': 'Quatrième / Troisième',
};

String volumeDe(String unite) => unite.split(' – ').first;

String anneeDe(String unite) =>
    anneesParVolume[volumeDe(unite)] ?? volumeDe(unite);

// Supprime toute une "année" (un volume) d'un coup : utile pour retirer un
// volume erroné ou créé par mégarde (ex. via l'ajout de vocabulaire libre),
// qu'on ne peut pas gérer unité par unité puisqu'il n'a pas de vraies
// unités. On réutilise supprimerVocabulaire pour que chaque mot soit
// proprement retiré (blacklist des mots seedés, retrait du vocabulaire
// personnalisé, remise à zéro de la progression FSRS).
void supprimerVolume(String volume) {
  final mots = vocabulaire
      .where((mot) => volumeDe(mot.unite) == volume)
      .toList();

  for (final mot in mots) {
    supprimerVocabulaire(mot);
  }

  for (final unite in mots.map((mot) => mot.unite).toSet()) {
    renommerUnite(unite, '');
  }
}

Future<bool> confirmerSuppressionVolume(
  BuildContext context,
  String volume,
) async {
  final confirme = await showDialog<bool>(
    context: context,
    builder: (context) {
      return FeuilleDesign(
        child: AlertDialog(
          title: const Text('Supprimer cette année ?'),
          content: Text(
            'Tous les mots de « ${anneesParVolume[volume] ?? volume} » et '
            'leur progression seront supprimés définitivement. Cette action '
            'est irréversible.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Supprimer'),
            ),
          ],
        ),
      );
    },
  );

  if (confirme == true) {
    supprimerVolume(volume);
    return true;
  }

  return false;
}

// ============================================================
// DIRECTION DE RÉVISION
// ============================================================
// Constantes directionLatinVersFrancais/directionFrancaisVersLatin
// définies dans vocabulaire_data.dart (portées par le modèle Vocabulaire).

Future<String?> choisirDirection(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: designBlanc,
    builder: (context) {
      return FeuilleDesign(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sens de la révision',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: designNoir,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.arrow_forward),
                title: const Text('Latin → Français'),
                onTap: () {
                  Navigator.pop(context, directionLatinVersFrancais);
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_back),
                title: const Text('Français → Latin'),
                onTap: () {
                  Navigator.pop(context, directionFrancaisVersLatin);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> demarrerRevision(
  BuildContext context,
  List<Vocabulaire> mots,
) async {
  final direction = await choisirDirection(context);

  if (direction == null || !context.mounted) return;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return VocabulaireScreen(
          vocabulaire: mots,
          startIndex: 0,
          direction: direction,
        );
      },
    ),
  );
}

// ============================================================
// RÉVISION PAR DIFFICULTÉ
// ============================================================

const niveauFacile = 'facile';
const niveauMoyen = 'moyen';
const niveauDifficile = 'difficile';

// La difficulté FSRS dépend du sens de révision (reconnaître un mot n'a
// pas la même difficulté que le produire), donc il faut préciser lequel.
String? niveauDifficulte(Vocabulaire mot, String direction) {
  final difficulte = mot.carte(direction).difficulty;

  if (difficulte == null) return null;

  if (difficulte < 4) return niveauFacile;
  if (difficulte < 7) return niveauMoyen;

  return niveauDifficile;
}

List<Vocabulaire> vocabulairePourNiveau(String niveau, String direction) {
  return vocabulaire
      .where((mot) => niveauDifficulte(mot, direction) == niveau)
      .toList();
}

Future<void> choisirEtReviserParDifficulte(BuildContext context) async {
  final direction = await choisirDirection(context);
  if (direction == null || !context.mounted) return;

  final facile = vocabulairePourNiveau(niveauFacile, direction);
  final moyen = vocabulairePourNiveau(niveauMoyen, direction);
  final difficile = vocabulairePourNiveau(niveauDifficile, direction);

  final niveau = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: designBlanc,
    builder: (context) {
      return FeuilleDesign(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Réviser par difficulté',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: designNoir,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.green,
                ),
                title: const Text('Facile'),
                trailing: Text(
                  '${facile.length}',
                  style: TextStyle(color: designNoir),
                ),
                enabled: facile.isNotEmpty,
                onTap: () => Navigator.pop(context, niveauFacile),
              ),
              ListTile(
                leading: const Icon(
                  Icons.sentiment_neutral,
                  color: Colors.orange,
                ),
                title: const Text('Moyen'),
                trailing: Text(
                  '${moyen.length}',
                  style: TextStyle(color: designNoir),
                ),
                enabled: moyen.isNotEmpty,
                onTap: () => Navigator.pop(context, niveauMoyen),
              ),
              ListTile(
                leading: const Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                ),
                title: const Text('Difficile'),
                trailing: Text(
                  '${difficile.length}',
                  style: TextStyle(color: designNoir),
                ),
                enabled: difficile.isNotEmpty,
                onTap: () => Navigator.pop(context, niveauDifficile),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      );
    },
  );

  if (niveau == null || !context.mounted) return;

  final mots = vocabulairePourNiveau(niveau, direction);

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return VocabulaireScreen(
          vocabulaire: mots,
          startIndex: 0,
          direction: direction,
        );
      },
    ),
  );
}

Future<void> choisirJeu(BuildContext context, List<Vocabulaire> mots) async {
  final jeu = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: designBlanc,
    builder: (context) {
      return FeuilleDesign(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Jeux',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: designNoir,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.quiz),
                title: const Text('Choix multiple'),
                onTap: () => Navigator.pop(context, 'choix_multiple'),
              ),
              ListTile(
                leading: const Icon(Icons.join_full),
                title: const Text('Association'),
                onTap: () => Navigator.pop(context, 'association'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      );
    },
  );

  if (jeu == null || !context.mounted) return;

  final direction = await choisirDirection(context);

  if (direction == null || !context.mounted) return;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        if (jeu == 'choix_multiple') {
          return QuizChoixMultipleScreen(
            vocabulaire: mots,
            direction: direction,
          );
        }

        return JeuAssociationScreen(vocabulaire: mots, direction: direction);
      },
    ),
  );
}

Color couleurStreak(int jours) {
  if (jours >= 30) return Colors.amber.shade700;
  if (jours >= 14) return Colors.red;
  if (jours >= 7) return Colors.deepOrange;
  if (jours >= 3) return Colors.orange;
  return Colors.grey.shade400;
}

// ============================================================
// APP
// ============================================================

class LateinApp extends StatelessWidget {
  const LateinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: temaActifNotifier,
      builder: (context, _) => _buildApp(context),
    );
  }

  Widget _buildApp(BuildContext context) {
    return MaterialApp(
      // La clé doit être ici, pas plus bas dans l'arbre (ex. sur `home`) :
      // le Navigator interne de MaterialApp garde son historique de routes
      // comme état persistant, indépendant des rebuilds de ses ancêtres —
      // il ne redérive PAS sa route initiale depuis `home` à chaque build.
      // Il faut donc démonter tout MaterialApp (Navigator compris) pour
      // qu'un changement de thème redémarre proprement la navigation avec
      // les couleurs à jour partout.
      key: ValueKey(temaActifNotifier.value.nom),
      debugShowCheckedModeBanner: false,
      title: 'Itinera',

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: fond,

        colorScheme: const ColorScheme.dark(
          surface: surfaceWidget,
          onSurface: texteClair,
          primary: accentViolet,
          onPrimary: texteClair,
          secondary: accentViolet,
          onSecondary: texteClair,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: texteClair,
          elevation: 0,
        ),

        cardTheme: CardThemeData(
          color: surfaceWidget,
          elevation: 6,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),

        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: surfaceWidget,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        ),
      ),

      home: const _EcranDemarrage(),
    );
  }
}

class _EcranDemarrage extends StatefulWidget {
  const _EcranDemarrage();

  @override
  State<_EcranDemarrage> createState() => _EcranDemarrageState();
}

class _EcranDemarrageState extends State<_EcranDemarrage> {
  late bool _onboardingVu = onboardingTermine();

  @override
  Widget build(BuildContext context) {
    if (_onboardingVu) return const MainNavigationScreen();

    return OnboardingScreen(
      onTermine: () => setState(() => _onboardingVu = true),
    );
  }
}
