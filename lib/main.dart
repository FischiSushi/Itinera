import 'dart:async';
import 'dart:math';
import 'dart:ui' show PlatformDispatcher;

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:pdfx/pdfx.dart';
import 'firebase_options.dart';
import 'lecons_grammaire_data.dart';
import 'screens/compte_screen.dart';
import 'latin/erreurs_declinaison.dart';
import 'screens/generateur_declinaison_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/parametres_screen.dart';
import 'screens/points_faibles_screen.dart';
import 'screens/speed_declinaison_screen.dart';
import 'services/duel_service.dart';
import 'services/notification_service.dart';
import 'vocabulaire_data.dart';
import 'widgets/graphique_activite.dart';

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
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
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
    final data = box.get(mot.latin);

    if (data != null) {
      try {
        mot.fsrsCard = fsrs.Card.fromMap(Map<String, dynamic>.from(data));
      } catch (_) {
        // altes Datenformat (statut/prochaineRevision/intervalle) —
        // kein Crash, das Wort startet einfach wieder als neue Karte
      }
    }
  }

  unawaited(NotificationService().reprogrammerSiActif());

  runApp(const LateinApp());
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

const articlesBoutique = [
  ArticleBoutique(id: 'avatar_hibou', nom: 'Hibou sage', emoji: '🦉', prix: 50),
  ArticleBoutique(id: 'avatar_temple', nom: 'Temple', emoji: '🏛️', prix: 100),
  ArticleBoutique(id: 'avatar_aigle', nom: 'Aigle', emoji: '🦅', prix: 150),
  ArticleBoutique(id: 'avatar_louve', nom: 'Louve', emoji: '🐺', prix: 200),
  ArticleBoutique(
    id: 'avatar_gladiateur',
    nom: 'Gladiateur',
    emoji: '⚔️',
    prix: 250,
  ),
  ArticleBoutique(
    id: 'avatar_legionnaire',
    nom: 'Légionnaire',
    emoji: '🛡️',
    prix: 300,
  ),
  ArticleBoutique(
    id: 'avatar_empereur',
    nom: 'Empereur',
    emoji: '👑',
    prix: 400,
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

class Succes {
  final String id;
  final String titre;
  final String description;
  final IconData icone;
  final int recompense;
  final bool Function() estDebloque;

  const Succes({
    required this.id,
    required this.titre,
    required this.description,
    required this.icone,
    required this.estDebloque,
    this.recompense = 20,
  });
}

int _motsApprisTotal() =>
    vocabulaire.where((mot) => mot.fsrsCard.lastReview != null).length;

final List<Succes> succesDisponibles = [
  Succes(
    id: 'premier_mot',
    titre: 'Premier pas',
    description: 'Apprends ton premier mot',
    icone: Icons.emoji_events,
    estDebloque: () => _motsApprisTotal() >= 1,
  ),
  Succes(
    id: 'mots_50',
    titre: 'Apprenti',
    description: '50 mots appris',
    icone: Icons.school,
    estDebloque: () => _motsApprisTotal() >= 50,
  ),
  Succes(
    id: 'mots_200',
    titre: 'Érudit',
    description: '200 mots appris',
    icone: Icons.school,
    recompense: 40,
    estDebloque: () => _motsApprisTotal() >= 200,
  ),
  Succes(
    id: 'mots_500',
    titre: 'Savant',
    description: '500 mots appris',
    icone: Icons.school,
    recompense: 60,
    estDebloque: () => _motsApprisTotal() >= 500,
  ),
  Succes(
    id: 'mots_tous',
    titre: 'Magister',
    description: 'Tous les mots appris',
    icone: Icons.workspace_premium,
    recompense: 100,
    estDebloque: () =>
        vocabulaire.isNotEmpty && _motsApprisTotal() == vocabulaire.length,
  ),
  Succes(
    id: 'serie_3',
    titre: 'Sur la lancée',
    description: '3 jours de suite',
    icone: Icons.local_fire_department,
    estDebloque: () => streakActuel() >= 3,
  ),
  Succes(
    id: 'serie_7',
    titre: 'Une semaine',
    description: '7 jours de suite',
    icone: Icons.local_fire_department,
    recompense: 30,
    estDebloque: () => streakActuel() >= 7,
  ),
  Succes(
    id: 'serie_30',
    titre: 'Habitude romaine',
    description: '30 jours de suite',
    icone: Icons.local_fire_department,
    recompense: 80,
    estDebloque: () => streakActuel() >= 30,
  ),
  Succes(
    id: 'pomodoro_1',
    titre: 'Premier sprint',
    description: 'Termine un Pomodoro',
    icone: Icons.local_cafe,
    estDebloque: () => pomodorosTermines() >= 1,
  ),
  Succes(
    id: 'pomodoro_10',
    titre: 'Concentré',
    description: '10 Pomodoros terminés',
    icone: Icons.local_cafe,
    recompense: 40,
    estDebloque: () => pomodorosTermines() >= 10,
  ),
  Succes(
    id: 'mot_perso',
    titre: 'Lexicographe',
    description: 'Ajoute ton premier mot',
    icone: Icons.add_circle,
    estDebloque: () {
      final box = Hive.box('vocabBox');
      return ((box.get(_customVocabKey) as List?) ?? []).isNotEmpty;
    },
  ),
  Succes(
    id: 'coins_100',
    titre: 'Petit trésor',
    description: 'Amasse 100 deniers',
    icone: Icons.savings,
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
      return AlertDialog(
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
      return AlertDialog(
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
    mot.fsrsCard = fsrs.Card(cardId: mot.latin.hashCode);
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
      return AlertDialog(
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
      return AlertDialog(
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
    builder: (context) {
      return SafeArea(
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
// DIRECTION DE RÉVISION
// ============================================================

const directionLatinVersFrancais = 'latin_vers_francais';
const directionFrancaisVersLatin = 'francais_vers_latin';

Future<String?> choisirDirection(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sens de la révision',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

String? niveauDifficulte(Vocabulaire mot) {
  final difficulte = mot.fsrsCard.difficulty;

  if (difficulte == null) return null;

  if (difficulte < 4) return niveauFacile;
  if (difficulte < 7) return niveauMoyen;

  return niveauDifficile;
}

List<Vocabulaire> vocabulairePourNiveau(String niveau) {
  return vocabulaire.where((mot) => niveauDifficulte(mot) == niveau).toList();
}

Future<void> choisirEtReviserParDifficulte(BuildContext context) async {
  final facile = vocabulairePourNiveau(niveauFacile);
  final moyen = vocabulairePourNiveau(niveauMoyen);
  final difficile = vocabulairePourNiveau(niveauDifficile);

  final niveau = await showModalBottomSheet<String>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Réviser par difficulté',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.sentiment_satisfied,
                color: Colors.green,
              ),
              title: const Text('Facile'),
              trailing: Text('${facile.length}'),
              enabled: facile.isNotEmpty,
              onTap: () => Navigator.pop(context, niveauFacile),
            ),
            ListTile(
              leading: const Icon(
                Icons.sentiment_neutral,
                color: Colors.orange,
              ),
              title: const Text('Moyen'),
              trailing: Text('${moyen.length}'),
              enabled: moyen.isNotEmpty,
              onTap: () => Navigator.pop(context, niveauMoyen),
            ),
            ListTile(
              leading: const Icon(
                Icons.sentiment_very_dissatisfied,
                color: Colors.red,
              ),
              title: const Text('Difficile'),
              trailing: Text('${difficile.length}'),
              enabled: difficile.isNotEmpty,
              onTap: () => Navigator.pop(context, niveauDifficile),
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );

  if (niveau == null || !context.mounted) return;

  final mots = vocabulairePourNiveau(niveau);

  await demarrerRevision(context, mots);
}

Future<void> choisirJeu(BuildContext context, List<Vocabulaire> mots) async {
  final jeu = await showModalBottomSheet<String>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Jeux',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

Widget statTile({
  required IconData icone,
  required String valeur,
  required String label,
  Color? couleur,
}) {
  final accent = couleur ?? accentViolet;

  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: surfaceWidget,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icone, color: accent),
          const SizedBox(height: 6),
          Text(
            valeur,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: texteClair,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: texteAttenue),
          ),
        ],
      ),
    ),
  );
}

// Badge monétaire "deniers" (denarius) — pas de portrait (aucun asset
// image dans le projet), juste un médaillon stylisé.
Widget badgeDeniers(int montant, {double rayon = 12}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.diamond, size: rayon * 2, color: orAntique),
      const SizedBox(width: 6),
      Text(
        '$montant denier${montant == 1 ? '' : 's'}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ],
  );
}

// ============================================================
// APP
// ============================================================

class LateinApp extends StatelessWidget {
  const LateinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

// ============================================================
// ÉCRAN DES UNITÉS
// ============================================================

class UniteScreen extends StatefulWidget {
  const UniteScreen({super.key});

  @override
  State<UniteScreen> createState() => _UniteScreenState();
}

class _UniteScreenState extends State<UniteScreen> {
  bool _actionsOuvertes = true;

  final ScrollController _scrollControllerUnites = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollControllerUnites.addListener(_replierReviserAuScroll);
  }

  @override
  void dispose() {
    _scrollControllerUnites.removeListener(_replierReviserAuScroll);
    _scrollControllerUnites.dispose();
    super.dispose();
  }

  // Referme automatiquement le bloc « Réviser » dès qu'on fait défiler la
  // liste des unités, pour libérer de la place à l'écran.
  void _replierReviserAuScroll() {
    if (_actionsOuvertes && _scrollControllerUnites.position.pixels > 10) {
      setState(() => _actionsOuvertes = false);
    }
  }

  List<String> get unites =>
      vocabulaire.map((mot) => mot.unite).toSet().toList();

  int compterARevoir() {
    final maintenant = DateTime.now().toUtc();

    return vocabulaire.where((mot) {
      return mot.fsrsCard.due.isBefore(maintenant);
    }).length;
  }

  int compterNouveaux() {
    return vocabulaire.where((mot) {
      return mot.fsrsCard.lastReview == null;
    }).length;
  }

  List<Vocabulaire> vocabulaireARevoir() {
    final maintenant = DateTime.now().toUtc();

    return vocabulaire.where((mot) {
      return !mot.fsrsCard.due.isAfter(maintenant);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulaire latin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RechercheScreen(),
                ),
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Ajouter un mot'),
        onPressed: () async {
          final ajoute = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AjouterVocabulaireScreen(),
            ),
          );

          if (ajoute == true) {
            setState(() {});
            if (context.mounted) verifierSuccesEtNotifier(context);
          }
        },
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () =>
                      setState(() => _actionsOuvertes = !_actionsOuvertes),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Réviser',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: _actionsOuvertes ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.expand_more),
                      ),
                    ],
                  ),
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 220),
                  crossFadeState: _actionsOuvertes
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox(width: double.infinity),
                  secondChild: Column(
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          statTile(
                            icone: Icons.refresh,
                            valeur: '${compterARevoir()}',
                            label: 'à revoir',
                          ),
                          const SizedBox(width: 12),
                          statTile(
                            icone: Icons.fiber_new,
                            valeur: '${compterNouveaux()}',
                            label: 'nouveaux',
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.refresh),
                          title: const Text('Révision du jour'),
                          subtitle: Text('${compterARevoir()} cartes à revoir'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            final cartesARevoir = vocabulaireARevoir();

                            if (cartesARevoir.isEmpty) return;

                            final direction = await choisirDirection(context);

                            if (direction == null || !context.mounted) return;

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return VocabulaireScreen(
                                    vocabulaire: cartesARevoir,
                                    startIndex: 0,
                                    direction: direction,
                                  );
                                },
                              ),
                            );
                            setState(() {});
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.shuffle),
                          title: const Text('Session mélangée'),
                          subtitle: Text(
                            '${vocabulaireARevoir().length} cartes, toutes unités mélangées',
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            final cartesMelangees = vocabulaireARevoir()
                              ..shuffle();

                            if (cartesMelangees.isNotEmpty) {
                              final direction = await choisirDirection(context);

                              if (direction == null || !context.mounted) return;

                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return VocabulaireScreen(
                                      vocabulaire: cartesMelangees,
                                      startIndex: 0,
                                      direction: direction,
                                    );
                                  },
                                ),
                              );
                              setState(() {});
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.tune),
                          title: const Text('Réviser par difficulté'),
                          subtitle: const Text(
                            'Uniquement les mots faciles, moyens ou difficiles',
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            await choisirEtReviserParDifficulte(context);
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              controller: _scrollControllerUnites,
              padding: const EdgeInsets.all(16),

              itemCount: unites.length,

              itemBuilder: (context, index) {
                final unite = unites[index];

                final maintenant = DateTime.now().toUtc();

                final nombreVocabulaire = vocabulaire
                    .where((mot) => mot.unite == unite)
                    .length;

                final nombreARevoir = vocabulaire
                    .where(
                      (mot) =>
                          mot.unite == unite &&
                          !mot.fsrsCard.due.isAfter(maintenant),
                    )
                    .length;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),

                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),

                    leading: CircleAvatar(
                      backgroundColor: accentViolet,
                      foregroundColor: texteClair,
                      child: Text('$index'),
                    ),

                    title: Text(
                      nomAffiche(unite),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      '$nombreVocabulaire mots · $nombreARevoir à revoir',
                    ),

                    trailing: const Icon(Icons.arrow_forward_ios),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return VocabulaireListeScreen(unite: unite);
                          },
                        ),
                      );
                    },

                    onLongPress: () async {
                      await gererUnite(context, unite);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// AJOUTER UN MOT
// ============================================================

class AjouterVocabulaireScreen extends StatefulWidget {
  const AjouterVocabulaireScreen({super.key});

  @override
  State<AjouterVocabulaireScreen> createState() =>
      _AjouterVocabulaireScreenState();
}

class _AjouterVocabulaireScreenState extends State<AjouterVocabulaireScreen> {
  final _formKey = GlobalKey<FormState>();

  final _latinController = TextEditingController();
  final _francaisController = TextEditingController();
  final _etymologieController = TextEditingController();

  late TextEditingController _uniteController;
  late TextEditingController _categorieController;

  @override
  void dispose() {
    _latinController.dispose();
    _francaisController.dispose();
    _etymologieController.dispose();
    super.dispose();
  }

  void _soumettre() {
    if (!_formKey.currentState!.validate()) return;

    ajouterVocabulairePersonnalise(
      latin: _latinController.text.trim(),
      francais: _francaisController.text.trim(),
      unite: _uniteController.text.trim(),
      categorie: _categorieController.text.trim(),
      etymologie: _etymologieController.text,
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final unitesExistantes = vocabulaire
        .map((mot) => mot.unite)
        .toSet()
        .toList();

    final categoriesExistantes = vocabulaire
        .map((mot) => mot.categorie)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un mot')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              TextFormField(
                controller: _latinController,
                decoration: const InputDecoration(labelText: 'Latin'),
                validator: (valeur) => (valeur == null || valeur.trim().isEmpty)
                    ? 'Champ requis'
                    : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _francaisController,
                decoration: const InputDecoration(labelText: 'Français'),
                validator: (valeur) => (valeur == null || valeur.trim().isEmpty)
                    ? 'Champ requis'
                    : null,
              ),

              const SizedBox(height: 16),

              Autocomplete<String>(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return unitesExistantes;
                  }

                  return unitesExistantes.where(
                    (unite) => unite.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ),
                  );
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      _uniteController = controller;

                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Unité',
                          helperText: 'Existante ou nouvelle',
                        ),
                        validator: (valeur) =>
                            (valeur == null || valeur.trim().isEmpty)
                            ? 'Champ requis'
                            : null,
                      );
                    },
              ),

              const SizedBox(height: 16),

              Autocomplete<String>(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return categoriesExistantes;
                  }

                  return categoriesExistantes.where(
                    (categorie) => categorie.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ),
                  );
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      _categorieController = controller;

                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Catégorie',
                          helperText: 'Existante ou nouvelle',
                        ),
                        validator: (valeur) =>
                            (valeur == null || valeur.trim().isEmpty)
                            ? 'Champ requis'
                            : null,
                      );
                    },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _etymologieController,
                decoration: const InputDecoration(
                  labelText: 'Étymologie (optionnel)',
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _soumettre,
                child: const Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// STATISTIQUES
// ============================================================

class StatistiquesScreen extends StatefulWidget {
  const StatistiquesScreen({super.key});

  @override
  State<StatistiquesScreen> createState() => _StatistiquesScreenState();
}

class _StatistiquesScreenState extends State<StatistiquesScreen> {
  @override
  Widget build(BuildContext context) {
    final maintenant = DateTime.now().toUtc();

    final totalMots = vocabulaire.length;

    final totalARevoir = vocabulaire
        .where((mot) => !mot.fsrsCard.due.isAfter(maintenant))
        .length;

    final totalNouveaux = vocabulaire
        .where((mot) => mot.fsrsCard.lastReview == null)
        .length;

    final totalAppris = totalMots - totalNouveaux;

    final unites = vocabulaire.map((mot) => mot.unite).toSet().toList();

    final totalLecons = construireParcoursComplet().length;
    final leconsTerminees = construireParcoursComplet()
        .where(leconEstCompletee)
        .length;

    final succesTotal = succesDisponibles.length;
    final succesTermines = succesDebloques().length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Réinitialiser toute la progression',
            onPressed: () async {
              final reinitialise = await confirmerReinitialisation(context);
              if (reinitialise) setState(() {});
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          Row(
            children: [
              statTile(
                icone: Icons.school,
                valeur: '$totalMots',
                label: 'mots au total',
              ),
              const SizedBox(width: 12),
              statTile(
                icone: Icons.check_circle,
                valeur: '$totalAppris',
                label: 'déjà appris',
              ),
              const SizedBox(width: 12),
              statTile(
                icone: Icons.refresh,
                valeur: '$totalARevoir',
                label: 'à revoir',
              ),
            ],
          ),

          const SizedBox(height: 20),

          GraphiqueActivite(revisionsParJour: historiqueRevisions()),

          const SizedBox(height: 28),

          const Text(
            'Progression par unité',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          for (final unite in unites) ...[
            _barreProgressionUnite(unite),
            const SizedBox(height: 12),
          ],

          const SizedBox(height: 16),

          const Text(
            'Leçons de grammaire',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceWidget,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Parcours terminé',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('$leconsTerminees / $totalLecons'),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: totalLecons == 0
                        ? 0
                        : leconsTerminees / totalLecons,
                    minHeight: 8,
                    backgroundColor: fond,
                    valueColor: const AlwaysStoppedAnimation(accentViolet),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Succès',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events, color: orAntique),
              title: Text('$succesTermines / $succesTotal débloqués'),
              subtitle: const Text('Voir tous les succès'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SuccesScreen(),
                  ),
                );
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _barreProgressionUnite(String unite) {
    final motsDeCetteUnite = vocabulaire
        .where((mot) => mot.unite == unite)
        .toList();

    final apprisDeCetteUnite = motsDeCetteUnite
        .where((mot) => mot.fsrsCard.lastReview != null)
        .length;

    final total = motsDeCetteUnite.length;
    final pourcentage = total == 0 ? 0.0 : apprisDeCetteUnite / total;

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: surfaceWidget,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Expanded(
                child: Text(
                  nomAffiche(unite),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text('$apprisDeCetteUnite / $total'),
            ],
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),

            child: LinearProgressIndicator(
              value: pourcentage,
              minHeight: 8,
              backgroundColor: fond,
              valueColor: const AlwaysStoppedAnimation(accentViolet),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// RECHERCHE
// ============================================================

Future<bool> afficherDetailVocabulaire(
  BuildContext context,
  Vocabulaire mot,
) async {
  final supprime = await showModalBottomSheet<bool>(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mot.latin,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${mot.categorie} · ${nomAffiche(mot.unite)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(mot.francais, style: const TextStyle(fontSize: 18)),
            if (mot.etymologie != null) ...[
              const SizedBox(height: 16),
              Text(
                'Étymologie',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SelectableText(mot.etymologie!),
            ],
            const SizedBox(height: 24),
            TextButton.icon(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: const Text(
                'Supprimer ce mot',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                final confirme = await confirmerSuppression(context, mot);

                if (confirme && context.mounted) {
                  Navigator.pop(context, true);
                }
              },
            ),
          ],
        ),
      );
    },
  );

  return supprime ?? false;
}

class RechercheScreen extends StatefulWidget {
  const RechercheScreen({super.key});

  @override
  State<RechercheScreen> createState() => _RechercheScreenState();
}

class _RechercheScreenState extends State<RechercheScreen> {
  String recherche = '';

  @override
  Widget build(BuildContext context) {
    final resultats = chercherDansVocabulaire(recherche);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: texteClair),
          decoration: InputDecoration(
            hintText: 'Rechercher un mot...',
            hintStyle: TextStyle(color: texteClair.withValues(alpha: 0.6)),
            border: InputBorder.none,
          ),
          onChanged: (valeur) {
            setState(() {
              recherche = valeur;
            });
          },
        ),
      ),
      body: ListView.builder(
        itemCount: resultats.length,
        itemBuilder: (context, index) {
          final mot = resultats[index];

          return ListTile(
            title: Text(
              mot.latin,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${mot.categorie} · ${nomAffiche(mot.unite)}\n${mot.francais}',
            ),
            onTap: () async {
              final supprime = await afficherDetailVocabulaire(context, mot);

              if (supprime) setState(() {});
            },
          );
        },
      ),
    );
  }
}

// ============================================================
// LISTE DER VOKABELN EINER UNITÉ
// ============================================================

class VocabulaireListeScreen extends StatefulWidget {
  final String unite;

  const VocabulaireListeScreen({super.key, required this.unite});

  @override
  State<VocabulaireListeScreen> createState() => _VocabulaireListeScreenState();
}

class _VocabulaireListeScreenState extends State<VocabulaireListeScreen> {
  String get unite => widget.unite;

  @override
  Widget build(BuildContext context) {
    final maintenant = DateTime.now().toUtc();

    final vocabulaireDeCetteUnite = vocabulaire
        .where((mot) => mot.unite == unite)
        .toList();

    final dueDeCetteUnite = vocabulaireDeCetteUnite
        .where((mot) => !mot.fsrsCard.due.isAfter(maintenant))
        .toList();

    final categories = <String>[];
    final motsParCategorie = <String, List<Vocabulaire>>{};

    for (final mot in vocabulaireDeCetteUnite) {
      if (!motsParCategorie.containsKey(mot.categorie)) {
        categories.add(mot.categorie);
        motsParCategorie[mot.categorie] = [];
      }
      motsParCategorie[mot.categorie]!.add(mot);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(nomAffiche(unite)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Réviser les cartes dues (${dueDeCetteUnite.length})',
            onPressed: dueDeCetteUnite.isEmpty
                ? null
                : () => demarrerRevision(context, dueDeCetteUnite),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_fill),
            tooltip: 'Réviser toute l\'unité',
            onPressed: vocabulaireDeCetteUnite.isEmpty
                ? null
                : () => demarrerRevision(context, vocabulaireDeCetteUnite),
          ),
          IconButton(
            icon: const Icon(Icons.extension),
            tooltip: 'Jeux (choix multiple, association)',
            onPressed: vocabulaireDeCetteUnite.isEmpty
                ? null
                : () => choisirJeu(context, vocabulaireDeCetteUnite),
          ),
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),

        itemCount: categories.length,

        itemBuilder: (context, indexCategorie) {
          final categorie = categories[indexCategorie];
          final motsDeCetteCategorie = motsParCategorie[categorie]!;
          final dueDeCetteCategorie = motsDeCetteCategorie
              .where((mot) => !mot.fsrsCard.due.isAfter(maintenant))
              .toList();

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,

            child: ExpansionTile(
              title: Text(
                categorie,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                '${motsDeCetteCategorie.length} mots · ${dueDeCetteCategorie.length} à revoir',
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip:
                        'Réviser les cartes dues (${dueDeCetteCategorie.length})',
                    onPressed: dueDeCetteCategorie.isEmpty
                        ? null
                        : () => demarrerRevision(context, dueDeCetteCategorie),
                  ),
                  IconButton(
                    icon: const Icon(Icons.play_circle_outline),
                    tooltip: 'Réviser cette catégorie',
                    onPressed: () =>
                        demarrerRevision(context, motsDeCetteCategorie),
                  ),
                  const Icon(Icons.expand_more),
                ],
              ),

              children: motsDeCetteCategorie.map((mot) {
                final index = vocabulaireDeCetteUnite.indexOf(mot);

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),

                  title: Text(
                    mot.latin,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(mot.francais),

                  trailing: const Icon(Icons.arrow_forward_ios),

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) {
                          return VocabulaireScreen(
                            vocabulaire: vocabulaireDeCetteUnite,
                            startIndex: index,
                          );
                        },
                      ),
                    );
                  },

                  onLongPress: () async {
                    final supprime = await confirmerSuppression(context, mot);

                    if (supprime) setState(() {});
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// VOKABELTRAINER
// ============================================================

class VocabulaireScreen extends StatefulWidget {
  final List<Vocabulaire> vocabulaire;
  final int startIndex;
  final String direction;

  const VocabulaireScreen({
    super.key,
    required this.vocabulaire,
    required this.startIndex,
    this.direction = directionLatinVersFrancais,
  });

  @override
  State<VocabulaireScreen> createState() {
    return _VocabulaireScreenState();
  }
}

class _VocabulaireScreenState extends State<VocabulaireScreen> {
  late int aktuellerIndex;

  bool antwortSichtbar = false;

  @override
  void initState() {
    super.initState();

    aktuellerIndex = widget.startIndex;
  }

  void naechsteKarte() {
    setState(() {
      aktuellerIndex = (aktuellerIndex + 1) % widget.vocabulaire.length;

      antwortSichtbar = false;
    });
  }

  void vorherigeKarte() {
    setState(() {
      aktuellerIndex--;

      if (aktuellerIndex < 0) {
        aktuellerIndex = widget.vocabulaire.length - 1;
      }

      antwortSichtbar = false;
    });
  }

  void antwortUmschalten() {
    setState(() {
      antwortSichtbar = !antwortSichtbar;
    });
  }

  void carteEvaluee(String evaluation) {
    final carte = widget.vocabulaire[aktuellerIndex];

    final rating = switch (evaluation) {
      'again' => fsrs.Rating.again,
      'hard' => fsrs.Rating.hard,
      'good' => fsrs.Rating.good,
      _ => fsrs.Rating.easy,
    };

    final result = scheduler.reviewCard(carte.fsrsCard, rating);
    carte.fsrsCard = result.card;

    Hive.box('vocabBox').put(carte.latin, carte.fsrsCard.toMap());
    registrerActiviteDuJour();
    enregistrerRevisionDuJour();

    if (rating == fsrs.Rating.good || rating == fsrs.Rating.easy) {
      ajouterCoins(1);
    }

    verifierSuccesEtNotifier(context);

    naechsteKarte();
  }

  void afficherEtymologie(String etymologie) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Étymologie',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SelectableText(etymologie),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final aktuelleVokabel = widget.vocabulaire[aktuellerIndex];

    final estLatinVersFrancais = widget.direction == directionLatinVersFrancais;

    final question = estLatinVersFrancais
        ? aktuelleVokabel.latin
        : aktuelleVokabel.francais;

    final reponse = estLatinVersFrancais
        ? aktuelleVokabel.francais
        : aktuelleVokabel.latin;

    return Scaffold(
      appBar: AppBar(title: const Text('Révision')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            // KARTE
            Stack(
              children: [
                Card(
                  elevation: 5,

                  child: SizedBox(
                    width: double.infinity,
                    height: 300,

                    child: Padding(
                      padding: const EdgeInsets.all(24),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Text(
                            aktuelleVokabel.categorie.toUpperCase(),

                            style: const TextStyle(
                              color: Colors.grey,
                              letterSpacing: 1.5,
                            ),
                          ),

                          const SizedBox(height: 24),

                          Text(
                            question,

                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 30),

                          if (antwortSichtbar)
                            Text(
                              reponse,

                              textAlign: TextAlign.center,

                              style: const TextStyle(fontSize: 23),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (aktuelleVokabel.etymologie != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      icon: const Icon(Icons.info_outline, color: texteClair),
                      onPressed: () {
                        afficherEtymologie(aktuelleVokabel.etymologie!);
                      },
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 35),

            // ANTWORT
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: antwortUmschalten,

                child: Text(
                  antwortSichtbar
                      ? 'Masquer la réponse'
                      : 'Afficher la réponse',
                ),
              ),
            ),

            const SizedBox(height: 15),

            const SizedBox(height: 25),

            if (antwortSichtbar)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // AGAIN
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        carteEvaluee('again');
                      },
                      child: const Text('À revoir'),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // HARD
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        carteEvaluee('hard');
                      },
                      child: const Text('Difficile'),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // GOOD
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        carteEvaluee('good');
                      },
                      child: const Text('Bien'),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // EASY
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        carteEvaluee('easy');
                      },
                      child: const Text('Facile'),
                    ),
                  ),
                ],
              ),

            // NAVIGATION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                IconButton(
                  onPressed: vorherigeKarte,

                  icon: const Icon(Icons.arrow_back, color: texteClair),
                ),

                TextButton(
                  onPressed: naechsteKarte,

                  child: const Text('Suivant →'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// JEU : CHOIX MULTIPLE
// ============================================================

class QuizChoixMultipleScreen extends StatefulWidget {
  final List<Vocabulaire> vocabulaire;
  final String direction;

  const QuizChoixMultipleScreen({
    super.key,
    required this.vocabulaire,
    required this.direction,
  });

  @override
  State<QuizChoixMultipleScreen> createState() =>
      _QuizChoixMultipleScreenState();
}

class _QuizChoixMultipleScreenState extends State<QuizChoixMultipleScreen> {
  late List<Vocabulaire> questions;
  int index = 0;
  int score = 0;
  List<String> options = [];
  String? optionChoisie;

  @override
  void initState() {
    super.initState();
    questions = List.of(widget.vocabulaire)..shuffle();
    genererOptions();
  }

  String texteQuestion(Vocabulaire mot) =>
      widget.direction == directionLatinVersFrancais ? mot.latin : mot.francais;

  String texteReponse(Vocabulaire mot) =>
      widget.direction == directionLatinVersFrancais ? mot.francais : mot.latin;

  void genererOptions() {
    final motActuel = questions[index];
    final bonneReponse = texteReponse(motActuel);

    final distracteurs =
        widget.vocabulaire
            .where((m) => m != motActuel)
            .map(texteReponse)
            .where((r) => r != bonneReponse)
            .toSet()
            .toList()
          ..shuffle();

    options = [bonneReponse, ...distracteurs.take(3)]..shuffle();
    optionChoisie = null;
  }

  void repondre(String option) {
    if (optionChoisie != null) return;

    setState(() {
      optionChoisie = option;

      if (option == texteReponse(questions[index])) {
        score++;
      }
    });
  }

  void suivant() {
    if (index + 1 >= questions.length) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Quiz terminé'),
            content: Text('$score / ${questions.length} bonnes réponses'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Terminer'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      index++;
      genererOptions();
    });
  }

  Widget boutonOption(String option, String bonneReponse) {
    Color? couleur;

    if (optionChoisie != null) {
      if (option == bonneReponse) {
        couleur = Colors.green;
      } else if (option == optionChoisie) {
        couleur = Colors.red;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: couleur,
            foregroundColor: texteClair,
            disabledForegroundColor: texteClair.withValues(alpha: 0.8),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () => repondre(option),
          child: Text(option, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final motActuel = questions[index];
    final bonneReponse = texteReponse(motActuel);

    return Scaffold(
      appBar: AppBar(
        title: Text('Choix multiple (${index + 1}/${questions.length})'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Text('Score : $score', style: const TextStyle(color: texteAttenue)),

            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  texteQuestion(motActuel),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            for (final option in options) boutonOption(option, bonneReponse),

            if (optionChoisie != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    optionChoisie == bonneReponse
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: optionChoisie == bonneReponse
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      optionChoisie == bonneReponse
                          ? 'Correct !'
                          : 'Faux — la bonne réponse était : $bonneReponse',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: optionChoisie == bonneReponse
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const Spacer(),

            if (optionChoisie != null)
              ElevatedButton(
                onPressed: suivant,
                child: Text(
                  index + 1 >= questions.length ? 'Terminer' : 'Suivant',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// JEU : ASSOCIATION
// ============================================================

class JeuAssociationScreen extends StatefulWidget {
  final List<Vocabulaire> vocabulaire;
  final String direction;

  const JeuAssociationScreen({
    super.key,
    required this.vocabulaire,
    required this.direction,
  });

  @override
  State<JeuAssociationScreen> createState() => _JeuAssociationScreenState();
}

class _JeuAssociationScreenState extends State<JeuAssociationScreen> {
  static const _tailleGroupe = 6;

  late List<Vocabulaire> tousLesMots;
  int indexGroupe = 0;

  late List<Vocabulaire> groupeActuel;
  late List<String> questionsMelangees;
  late List<String> reponsesMelangees;

  String? questionSelectionnee;
  String? reponseSelectionnee;
  final Set<String> questionsTrouvees = {};
  final Set<String> reponsesTrouvees = {};

  bool erreurEnCours = false;
  bool? dernierResultatCorrect;

  @override
  void initState() {
    super.initState();
    tousLesMots = List.of(widget.vocabulaire)..shuffle();
    demarrerGroupe();
  }

  String texteQuestion(Vocabulaire mot) =>
      widget.direction == directionLatinVersFrancais ? mot.latin : mot.francais;

  String texteReponse(Vocabulaire mot) =>
      widget.direction == directionLatinVersFrancais ? mot.francais : mot.latin;

  void demarrerGroupe() {
    final debut = indexGroupe * _tailleGroupe;
    final fin = (debut + _tailleGroupe).clamp(0, tousLesMots.length);

    groupeActuel = tousLesMots.sublist(debut, fin);
    questionsMelangees = groupeActuel.map(texteQuestion).toList()..shuffle();
    reponsesMelangees = groupeActuel.map(texteReponse).toList()..shuffle();

    questionSelectionnee = null;
    reponseSelectionnee = null;
    questionsTrouvees.clear();
    reponsesTrouvees.clear();
  }

  void selectionnerQuestion(String question) {
    if (erreurEnCours || questionsTrouvees.contains(question)) return;

    setState(() {
      questionSelectionnee = question;
      tenterAssociation();
    });
  }

  void selectionnerReponse(String reponse) {
    if (erreurEnCours || reponsesTrouvees.contains(reponse)) return;

    setState(() {
      reponseSelectionnee = reponse;
      tenterAssociation();
    });
  }

  void tenterAssociation() {
    if (questionSelectionnee == null || reponseSelectionnee == null) return;

    final mot = groupeActuel.firstWhere(
      (m) => texteQuestion(m) == questionSelectionnee,
    );

    final correct = texteReponse(mot) == reponseSelectionnee;

    dernierResultatCorrect = correct;

    if (correct) {
      questionsTrouvees.add(questionSelectionnee!);
      reponsesTrouvees.add(reponseSelectionnee!);
      questionSelectionnee = null;
      reponseSelectionnee = null;
    } else {
      erreurEnCours = true;
    }

    Future.delayed(Duration(milliseconds: correct ? 700 : 600), () {
      if (!mounted) return;

      setState(() {
        if (!correct) {
          questionSelectionnee = null;
          reponseSelectionnee = null;
          erreurEnCours = false;
        }
        dernierResultatCorrect = null;
      });
    });
  }

  Color? couleurBouton({
    required String texte,
    required bool trouve,
    required bool selectionne,
  }) {
    if (trouve) return Colors.green.withValues(alpha: 0.4);
    if (selectionne && erreurEnCours) return Colors.red;
    if (selectionne) return accentViolet;
    return null;
  }

  Widget boutonMot({
    required String texte,
    required bool trouve,
    required bool selectionne,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: couleurBouton(
              texte: texte,
              trouve: trouve,
              selectionne: selectionne,
            ),
            foregroundColor: texteClair,
            disabledForegroundColor: texteClair.withValues(alpha: 0.8),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          ),
          onPressed: trouve ? null : onTap,
          child: Text(
            texte,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupeTermine = questionsTrouvees.length == groupeActuel.length;
    final dernierGroupe =
        (indexGroupe + 1) * _tailleGroupe >= tousLesMots.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Association (groupe ${indexGroupe + 1}/'
          '${(tousLesMots.length / _tailleGroupe).ceil()})',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Text(
              'Trouvées : ${questionsTrouvees.length} / ${groupeActuel.length}',
              style: const TextStyle(color: texteAttenue),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        for (final question in questionsMelangees)
                          boutonMot(
                            texte: question,
                            trouve: questionsTrouvees.contains(question),
                            selectionne: question == questionSelectionnee,
                            onTap: () => selectionnerQuestion(question),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        for (final reponse in reponsesMelangees)
                          boutonMot(
                            texte: reponse,
                            trouve: reponsesTrouvees.contains(reponse),
                            selectionne: reponse == reponseSelectionnee,
                            onTap: () => selectionnerReponse(reponse),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (dernierResultatCorrect != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      dernierResultatCorrect!
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: dernierResultatCorrect!
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      dernierResultatCorrect!
                          ? 'Bonne paire !'
                          : 'Mauvaise paire',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: dernierResultatCorrect!
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

            if (groupeTermine)
              ElevatedButton(
                onPressed: () {
                  if (dernierGroupe) {
                    Navigator.pop(context);
                    return;
                  }

                  setState(() {
                    indexGroupe++;
                    demarrerGroupe();
                  });
                },
                child: Text(dernierGroupe ? 'Terminer' : 'Groupe suivant'),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// GRAMMAIRE : DONNÉES DE DÉCLINAISON
// ============================================================

class Declinaison {
  final String titre;
  final String exempleLatin;
  final String exempleFrancais;
  final Map<String, String> singulier;
  final Map<String, String> pluriel;

  const Declinaison({
    required this.titre,
    required this.exempleLatin,
    required this.exempleFrancais,
    required this.singulier,
    required this.pluriel,
  });
}

const casLatins = [
  'Nominatif',
  'Vocatif',
  'Accusatif',
  'Génitif',
  'Datif',
  'Ablatif',
];

final List<Declinaison> declinaisons = [
  const Declinaison(
    titre: '1re déclinaison (thème en -a)',
    exempleLatin: 'puella, -ae',
    exempleFrancais: 'f. — jeune fille',
    singulier: {
      'Nominatif': 'puella',
      'Vocatif': 'puella',
      'Accusatif': 'puellam',
      'Génitif': 'puellae',
      'Datif': 'puellae',
      'Ablatif': 'puella',
    },
    pluriel: {
      'Nominatif': 'puellae',
      'Vocatif': 'puellae',
      'Accusatif': 'puellas',
      'Génitif': 'puellarum',
      'Datif': 'puellis',
      'Ablatif': 'puellis',
    },
  ),
  const Declinaison(
    titre: '2e déclinaison (masculin, thème en -o)',
    exempleLatin: 'dominus, -i',
    exempleFrancais: 'm. — maître',
    singulier: {
      'Nominatif': 'dominus',
      'Vocatif': 'domine',
      'Accusatif': 'dominum',
      'Génitif': 'domini',
      'Datif': 'domino',
      'Ablatif': 'domino',
    },
    pluriel: {
      'Nominatif': 'domini',
      'Vocatif': 'domini',
      'Accusatif': 'dominos',
      'Génitif': 'dominorum',
      'Datif': 'dominis',
      'Ablatif': 'dominis',
    },
  ),
  const Declinaison(
    titre: '2e déclinaison (neutre, thème en -o)',
    exempleLatin: 'bellum, -i',
    exempleFrancais: 'n. — guerre',
    singulier: {
      'Nominatif': 'bellum',
      'Vocatif': 'bellum',
      'Accusatif': 'bellum',
      'Génitif': 'belli',
      'Datif': 'bello',
      'Ablatif': 'bello',
    },
    pluriel: {
      'Nominatif': 'bella',
      'Vocatif': 'bella',
      'Accusatif': 'bella',
      'Génitif': 'bellorum',
      'Datif': 'bellis',
      'Ablatif': 'bellis',
    },
  ),
  const Declinaison(
    titre: '3e déclinaison (thème consonantique)',
    exempleLatin: 'rex, regis',
    exempleFrancais: 'm. — roi',
    singulier: {
      'Nominatif': 'rex',
      'Vocatif': 'rex',
      'Accusatif': 'regem',
      'Génitif': 'regis',
      'Datif': 'regi',
      'Ablatif': 'rege',
    },
    pluriel: {
      'Nominatif': 'reges',
      'Vocatif': 'reges',
      'Accusatif': 'reges',
      'Génitif': 'regum',
      'Datif': 'regibus',
      'Ablatif': 'regibus',
    },
  ),
  const Declinaison(
    titre: '3e déclinaison (neutre, thème consonantique)',
    exempleLatin: 'corpus, corporis',
    exempleFrancais: 'n. — corps',
    singulier: {
      'Nominatif': 'corpus',
      'Vocatif': 'corpus',
      'Accusatif': 'corpus',
      'Génitif': 'corporis',
      'Datif': 'corpori',
      'Ablatif': 'corpore',
    },
    pluriel: {
      'Nominatif': 'corpora',
      'Vocatif': 'corpora',
      'Accusatif': 'corpora',
      'Génitif': 'corporum',
      'Datif': 'corporibus',
      'Ablatif': 'corporibus',
    },
  ),
  const Declinaison(
    titre: '3e déclinaison (thème en -i, masc./fém.)',
    exempleLatin: 'civis, civis',
    exempleFrancais: 'm./f. — citoyen',
    singulier: {
      'Nominatif': 'civis',
      'Vocatif': 'civis',
      'Accusatif': 'civem',
      'Génitif': 'civis',
      'Datif': 'civi',
      'Ablatif': 'cive',
    },
    pluriel: {
      'Nominatif': 'cives',
      'Vocatif': 'cives',
      'Accusatif': 'cives',
      'Génitif': 'civium',
      'Datif': 'civibus',
      'Ablatif': 'civibus',
    },
  ),
  const Declinaison(
    titre: '4e déclinaison (thème en -u)',
    exempleLatin: 'manus, -us',
    exempleFrancais: 'f. — main',
    singulier: {
      'Nominatif': 'manus',
      'Vocatif': 'manus',
      'Accusatif': 'manum',
      'Génitif': 'manus',
      'Datif': 'manui',
      'Ablatif': 'manu',
    },
    pluriel: {
      'Nominatif': 'manus',
      'Vocatif': 'manus',
      'Accusatif': 'manus',
      'Génitif': 'manuum',
      'Datif': 'manibus',
      'Ablatif': 'manibus',
    },
  ),
  const Declinaison(
    titre: '4e déclinaison (neutre, thème en -u)',
    exempleLatin: 'cornu, -us',
    exempleFrancais: 'n. — corne',
    singulier: {
      'Nominatif': 'cornu',
      'Vocatif': 'cornu',
      'Accusatif': 'cornu',
      'Génitif': 'cornus',
      'Datif': 'cornu',
      'Ablatif': 'cornu',
    },
    pluriel: {
      'Nominatif': 'cornua',
      'Vocatif': 'cornua',
      'Accusatif': 'cornua',
      'Génitif': 'cornuum',
      'Datif': 'cornibus',
      'Ablatif': 'cornibus',
    },
  ),
  const Declinaison(
    titre: '5e déclinaison (thème en -e)',
    exempleLatin: 'dies, diei',
    exempleFrancais: 'm./f. — jour',
    singulier: {
      'Nominatif': 'dies',
      'Vocatif': 'dies',
      'Accusatif': 'diem',
      'Génitif': 'diei',
      'Datif': 'diei',
      'Ablatif': 'die',
    },
    pluriel: {
      'Nominatif': 'dies',
      'Vocatif': 'dies',
      'Accusatif': 'dies',
      'Génitif': 'dierum',
      'Datif': 'diebus',
      'Ablatif': 'diebus',
    },
  ),
  const Declinaison(
    titre: '2e déclinaison (masculin en -er, radical stable)',
    exempleLatin: 'puer, pueri',
    exempleFrancais: 'm. — garçon, enfant',
    singulier: {
      'Nominatif': 'puer',
      'Vocatif': 'puer',
      'Accusatif': 'puerum',
      'Génitif': 'pueri',
      'Datif': 'puero',
      'Ablatif': 'puero',
    },
    pluriel: {
      'Nominatif': 'pueri',
      'Vocatif': 'pueri',
      'Accusatif': 'pueros',
      'Génitif': 'puerorum',
      'Datif': 'pueris',
      'Ablatif': 'pueris',
    },
  ),
  const Declinaison(
    titre: '2e déclinaison (masculin en -er, radical qui perd son -e-)',
    exempleLatin: 'ager, agri',
    exempleFrancais: 'm. — champ, territoire',
    singulier: {
      'Nominatif': 'ager',
      'Vocatif': 'ager',
      'Accusatif': 'agrum',
      'Génitif': 'agri',
      'Datif': 'agro',
      'Ablatif': 'agro',
    },
    pluriel: {
      'Nominatif': 'agri',
      'Vocatif': 'agri',
      'Accusatif': 'agros',
      'Génitif': 'agrorum',
      'Datif': 'agris',
      'Ablatif': 'agris',
    },
  ),
  const Declinaison(
    titre: '2e déclinaison (masculin en -ir, exception : vir)',
    exempleLatin: 'vir, viri',
    exempleFrancais: 'm. — homme, mari',
    singulier: {
      'Nominatif': 'vir',
      'Vocatif': 'vir',
      'Accusatif': 'virum',
      'Génitif': 'viri',
      'Datif': 'viro',
      'Ablatif': 'viro',
    },
    pluriel: {
      'Nominatif': 'viri',
      'Vocatif': 'viri',
      'Accusatif': 'viros',
      'Génitif': 'virorum',
      'Datif': 'viris',
      'Ablatif': 'viris',
    },
  ),
  const Declinaison(
    titre: '3e déclinaison (neutre AREAL, thème en -i)',
    exempleLatin: 'mare, maris',
    exempleFrancais: 'n. — mer',
    singulier: {
      'Nominatif': 'mare',
      'Vocatif': 'mare',
      'Accusatif': 'mare',
      'Génitif': 'maris',
      'Datif': 'mari',
      'Ablatif': 'mari',
    },
    pluriel: {
      'Nominatif': 'maria',
      'Vocatif': 'maria',
      'Accusatif': 'maria',
      'Génitif': 'marium',
      'Datif': 'maribus',
      'Ablatif': 'maribus',
    },
  ),
  const Declinaison(
    titre: '4e déclinaison (formes combinées avec la 2e déclinaison)',
    exempleLatin: 'domus, -us',
    exempleFrancais: 'f. — maison',
    singulier: {
      'Nominatif': 'domus',
      'Vocatif': 'domus',
      'Accusatif': 'domum',
      'Génitif': 'domus',
      'Datif': 'domui',
      'Ablatif': 'domo',
    },
    pluriel: {
      'Nominatif': 'domus',
      'Vocatif': 'domus',
      'Accusatif': 'domus (ou domos)',
      'Génitif': 'domuum (ou domorum)',
      'Datif': 'domibus',
      'Ablatif': 'domibus',
    },
  ),
];

// ============================================================
// CONJUGAISONS : LES 5 MODÈLES, INDICATIF PRÉSENT
// ============================================================

class Conjugaison {
  final String titre;
  final String tempsPrimitifs;
  final String traduction;
  final Map<String, String> present;
  final Map<String, String>? imparfait;

  const Conjugaison({
    required this.titre,
    required this.tempsPrimitifs,
    required this.traduction,
    required this.present,
    this.imparfait,
  });
}

const personnesLatines = [
  'je',
  'tu',
  'il / elle',
  'nous',
  'vous',
  'ils / elles',
];

final List<Conjugaison> conjugaisons = [
  const Conjugaison(
    titre: '1re conjugaison',
    tempsPrimitifs: 'amo, amas, amare, amavi, amatum',
    traduction: 'aimer',
    present: {
      'je': 'amo',
      'tu': 'amas',
      'il / elle': 'amat',
      'nous': 'amamus',
      'vous': 'amatis',
      'ils / elles': 'amant',
    },
    imparfait: {
      'je': 'amabam',
      'tu': 'amabas',
      'il / elle': 'amabat',
      'nous': 'amabamus',
      'vous': 'amabatis',
      'ils / elles': 'amabant',
    },
  ),
  const Conjugaison(
    titre: '2e conjugaison',
    tempsPrimitifs: 'moneo, mones, monere, monui, monitum',
    traduction: 'avertir',
    present: {
      'je': 'moneo',
      'tu': 'mones',
      'il / elle': 'monet',
      'nous': 'monemus',
      'vous': 'monetis',
      'ils / elles': 'monent',
    },
    imparfait: {
      'je': 'monebam',
      'tu': 'monebas',
      'il / elle': 'monebat',
      'nous': 'monebamus',
      'vous': 'monebatis',
      'ils / elles': 'monebant',
    },
  ),
  const Conjugaison(
    titre: '3e conjugaison',
    tempsPrimitifs: 'mitto, mittis, mittere, misi, missum',
    traduction: 'envoyer',
    present: {
      'je': 'mitto',
      'tu': 'mittis',
      'il / elle': 'mittit',
      'nous': 'mittimus',
      'vous': 'mittitis',
      'ils / elles': 'mittunt',
    },
    imparfait: {
      'je': 'mittebam',
      'tu': 'mittebas',
      'il / elle': 'mittebat',
      'nous': 'mittebamus',
      'vous': 'mittebatis',
      'ils / elles': 'mittebant',
    },
  ),
  const Conjugaison(
    titre: '4e conjugaison',
    tempsPrimitifs: 'capio, capis, capere, cepi, captum',
    traduction: 'prendre',
    present: {
      'je': 'capio',
      'tu': 'capis',
      'il / elle': 'capit',
      'nous': 'capimus',
      'vous': 'capitis',
      'ils / elles': 'capiunt',
    },
    imparfait: {
      'je': 'capiebam',
      'tu': 'capiebas',
      'il / elle': 'capiebat',
      'nous': 'capiebamus',
      'vous': 'capiebatis',
      'ils / elles': 'capiebant',
    },
  ),
  const Conjugaison(
    titre: '5e conjugaison',
    tempsPrimitifs: 'audio, audis, audire, audivi, auditum',
    traduction: 'écouter, entendre',
    present: {
      'je': 'audio',
      'tu': 'audis',
      'il / elle': 'audit',
      'nous': 'audimus',
      'vous': 'auditis',
      'ils / elles': 'audiunt',
    },
    imparfait: {
      'je': 'audiebam',
      'tu': 'audiebas',
      'il / elle': 'audiebat',
      'nous': 'audiebamus',
      'vous': 'audiebatis',
      'ils / elles': 'audiebant',
    },
  ),
];

Widget tableauConjugaison(Conjugaison conj) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            conj.titre,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          Text(
            '${conj.tempsPrimitifs} « ${conj.traduction} »',
            style: const TextStyle(color: texteAttenue),
          ),

          const SizedBox(height: 12),

          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.3),
              1: FlexColumnWidth(1),
            },

            children: [
              for (final personne in personnesLatines)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        personne,
                        style: const TextStyle(color: texteAttenue),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(conj.present[personne]!),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget tableauImparfait(Conjugaison conj) {
  final imparfait = conj.imparfait;
  if (imparfait == null) return const SizedBox.shrink();

  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            conj.titre,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          Text(
            '${conj.tempsPrimitifs} « ${conj.traduction} »',
            style: const TextStyle(color: texteAttenue),
          ),

          const SizedBox(height: 12),

          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.3),
              1: FlexColumnWidth(1),
            },

            children: [
              for (final personne in personnesLatines)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        personne,
                        style: const TextStyle(color: texteAttenue),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(imparfait[personne]!),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

// ============================================================
// GRAMMAIRE : ÉCRAN D'ACCUEIL
// ============================================================

class GrammaireScreen extends StatelessWidget {
  const GrammaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grammaire')),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.rule),
              title: const Text('Morphologie'),
              subtitle: const Text('Reconnaître le cas et le nombre'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MorphologieScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Déclinaisons'),
              subtitle: const Text('Tableaux de référence des 5 déclinaisons'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeclinaisonsScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Stammtrainer (verbes)'),
              subtitle: const Text('Reconnaître les radicaux des verbes'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StammTrainerScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.auto_awesome_mosaic),
              title: const Text('Générateur de déclinaisons'),
              subtitle: const Text('Choisis un nom, vois son tableau complet et teste-toi'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GenerateurDeclinaisonScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.bolt),
              title: const Text('Déclinaison rapide'),
              subtitle: const Text('30 secondes, le plus de bonnes réponses possible'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SpeedDeclinaisonScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.insights),
              title: const Text('Points faibles'),
              subtitle: const Text('Tes confusions les plus fréquentes, et de la pratique ciblée'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PointsFaiblesScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// GRAMMAIRE : TABLEAUX DE DÉCLINAISON
// ============================================================

class DeclinaisonsScreen extends StatelessWidget {
  const DeclinaisonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Déclinaisons')),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          for (final decl in declinaisons) ...[
            tableauDeclinaison(decl),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

Widget tableauDeclinaison(Declinaison decl) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            decl.titre,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          Text(
            '${decl.exempleLatin} — ${decl.exempleFrancais}',
            style: const TextStyle(color: texteAttenue),
          ),

          const SizedBox(height: 12),

          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.3),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
            },

            children: [
              const TableRow(
                children: [
                  SizedBox(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      'Singulier',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      'Pluriel',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              for (final cas in casLatins)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        cas,
                        style: const TextStyle(color: texteAttenue),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(decl.singulier[cas]!),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(decl.pluriel[cas]!),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

// ============================================================
// GRAMMAIRE : MORPHOLOGIE (JEU)
// ============================================================

class MorphologieScreen extends StatefulWidget {
  const MorphologieScreen({super.key});

  @override
  State<MorphologieScreen> createState() => _MorphologieScreenState();
}

class _MorphologieScreenState extends State<MorphologieScreen> {
  static const _totalQuestions = 20;

  final _rng = Random();

  int index = 0;
  int score = 0;

  late Declinaison declinaisonActuelle;
  late String formeActuelle;
  late String reponseCorrecte;
  List<String> options = [];
  String? optionChoisie;

  @override
  void initState() {
    super.initState();
    genererQuestion();
  }

  void genererQuestion() {
    declinaisonActuelle = declinaisons[_rng.nextInt(declinaisons.length)];

    final cas = casLatins[_rng.nextInt(casLatins.length)];
    final singulier = _rng.nextBool();

    formeActuelle = singulier
        ? declinaisonActuelle.singulier[cas]!
        : declinaisonActuelle.pluriel[cas]!;

    reponseCorrecte = '$cas ${singulier ? 'singulier' : 'pluriel'}';

    final autresCombinaisons = <String>[];

    for (final c in casLatins) {
      for (final estSingulier in [true, false]) {
        final combinaison = '$c ${estSingulier ? 'singulier' : 'pluriel'}';

        if (combinaison == reponseCorrecte) continue;

        final forme = estSingulier
            ? declinaisonActuelle.singulier[c]!
            : declinaisonActuelle.pluriel[c]!;

        // Exclure les formes identiques (syncrétisme, ex. "dies" au
        // nominatif et vocatif, singulier et pluriel) pour éviter qu'une
        // réponse tout aussi correcte soit comptée comme fausse.
        if (forme == formeActuelle) continue;

        autresCombinaisons.add(combinaison);
      }
    }

    autresCombinaisons.shuffle(_rng);

    options = [reponseCorrecte, ...autresCombinaisons.take(3)]..shuffle(_rng);
    optionChoisie = null;
  }

  void repondre(String option) {
    if (optionChoisie != null) return;

    if (option != reponseCorrecte) {
      final cible = reponseCorrecte.split(' ');
      final confondu = option.split(' ');
      enregistrerErreurDeclinaison(
        casCible: cible[0],
        plurielCible: cible[1] == 'pluriel',
        casConfondu: confondu[0],
        plurielConfondu: confondu[1] == 'pluriel',
      );
    }

    setState(() {
      optionChoisie = option;

      if (option == reponseCorrecte) score++;
    });
  }

  void suivant() {
    if (index + 1 >= _totalQuestions) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Terminé'),
            content: Text('$score / $_totalQuestions bonnes réponses'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Terminer'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      index++;
      genererQuestion();
    });
  }

  Widget boutonOption(String option) {
    Color? couleur;

    if (optionChoisie != null) {
      if (option == reponseCorrecte) {
        couleur = Colors.green;
      } else if (option == optionChoisie) {
        couleur = Colors.red;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: couleur,
            foregroundColor: texteClair,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () => repondre(option),
          child: Text(option, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Morphologie (${index + 1}/$_totalQuestions)'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Text('Score : $score', style: const TextStyle(color: texteAttenue)),

            const SizedBox(height: 8),

            Text(
              declinaisonActuelle.titre,
              textAlign: TextAlign.center,
              style: const TextStyle(color: texteAttenue, fontSize: 12),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  formeActuelle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Quel cas et quel nombre ?',
              textAlign: TextAlign.center,
              style: TextStyle(color: texteAttenue),
            ),

            const SizedBox(height: 24),

            for (final option in options) boutonOption(option),

            if (optionChoisie != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    optionChoisie == reponseCorrecte
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: optionChoisie == reponseCorrecte
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      optionChoisie == reponseCorrecte
                          ? 'Correct !'
                          : 'Faux — la bonne réponse était : $reponseCorrecte',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: optionChoisie == reponseCorrecte
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const Spacer(),

            if (optionChoisie != null)
              ElevatedButton(
                onPressed: suivant,
                child: Text(
                  index + 1 >= _totalQuestions ? 'Terminer' : 'Suivant',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// GRAMMAIRE : STAMMTRAINER (VERBES)
// ============================================================

class StammTrainerScreen extends StatefulWidget {
  const StammTrainerScreen({super.key});

  @override
  State<StammTrainerScreen> createState() => _StammTrainerScreenState();
}

class _StammTrainerScreenState extends State<StammTrainerScreen> {
  static const _labelsStamms = {
    0: 'présent',
    3: 'parfait',
    4: 'supin / participe parfait',
  };

  final _rng = Random();

  late List<Vocabulaire> verbes;
  late int totalQuestions;

  int index = 0;
  int score = 0;

  late Vocabulaire verbeActuel;
  late List<String> segmentsActuels;
  late int indexCible;
  late String reponseCorrecte;
  List<String> options = [];
  String? optionChoisie;

  @override
  void initState() {
    super.initState();

    verbes = vocabulaire
        .where(
          (mot) =>
              mot.categorie == 'Verbes' && mot.latin.split(',').length >= 4,
        )
        .toList();

    totalQuestions = verbes.length < 20 ? verbes.length : 20;

    if (verbes.isNotEmpty) genererQuestion();
  }

  List<String> segmentsDe(Vocabulaire mot) =>
      mot.latin.split(',').map((s) => s.trim()).toList();

  void genererQuestion() {
    verbeActuel = verbes[_rng.nextInt(verbes.length)];
    segmentsActuels = segmentsDe(verbeActuel);

    final indicesValides = _labelsStamms.keys
        .where((i) => i < segmentsActuels.length)
        .toList();

    indexCible = indicesValides[_rng.nextInt(indicesValides.length)];
    reponseCorrecte = segmentsActuels[indexCible];

    final distracteurs =
        verbes
            .where((mot) => mot != verbeActuel)
            .map(segmentsDe)
            .where((segments) => indexCible < segments.length)
            .map((segments) => segments[indexCible])
            .where((segment) => segment != reponseCorrecte)
            .toSet()
            .toList()
          ..shuffle(_rng);

    options = [reponseCorrecte, ...distracteurs.take(3)]..shuffle(_rng);
    optionChoisie = null;
  }

  void repondre(String option) {
    if (optionChoisie != null) return;

    setState(() {
      optionChoisie = option;

      if (option == reponseCorrecte) score++;
    });
  }

  void suivant() {
    if (index + 1 >= totalQuestions) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Terminé'),
            content: Text('$score / $totalQuestions bonnes réponses'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Terminer'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      index++;
      genererQuestion();
    });
  }

  Widget boutonOption(String option) {
    Color? couleur;

    if (optionChoisie != null) {
      if (option == reponseCorrecte) {
        couleur = Colors.green;
      } else if (option == optionChoisie) {
        couleur = Colors.red;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: couleur,
            foregroundColor: texteClair,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () => repondre(option),
          child: Text(option, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  String get texteMasque {
    return segmentsActuels
        .asMap()
        .entries
        .map((e) => e.key == indexCible ? '___' : e.value)
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    if (verbes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Stammtrainer')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Pas assez de verbes avec formes complètes dans le '
              'vocabulaire pour ce jeu.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Stammtrainer (${index + 1}/$totalQuestions)'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Text('Score : $score', style: const TextStyle(color: texteAttenue)),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      texteMasque,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      verbeActuel.francais,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: texteAttenue),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Quelle est la forme du ${_labelsStamms[indexCible]} ?',
              textAlign: TextAlign.center,
              style: const TextStyle(color: texteAttenue),
            ),

            const SizedBox(height: 24),

            for (final option in options) boutonOption(option),

            if (optionChoisie != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    optionChoisie == reponseCorrecte
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: optionChoisie == reponseCorrecte
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      optionChoisie == reponseCorrecte
                          ? 'Correct !'
                          : 'Faux — la bonne réponse était : $reponseCorrecte',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: optionChoisie == reponseCorrecte
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const Spacer(),

            if (optionChoisie != null)
              ElevatedButton(
                onPressed: suivant,
                child: Text(
                  index + 1 >= totalQuestions ? 'Terminer' : 'Suivant',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PLUS (bibliothèque des sections restantes)
// ============================================================

class PlusScreen extends StatefulWidget {
  const PlusScreen({super.key});

  @override
  State<PlusScreen> createState() => _PlusScreenState();
}

class _PlusScreenState extends State<PlusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plus')),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_cafe),
              title: const Text('Minuteur cozy'),
              subtitle: const Text('Pomodoro pour rester concentré'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PomodoroScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events),
              title: const Text('Succès'),
              subtitle: Text(
                '${succesDebloques().length}/${succesDisponibles.length} débloqués',
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SuccesScreen()),
                );
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.storefront),
              title: const Text('Boutique'),
              subtitle: badgeDeniers(coins(), rayon: 10),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BoutiqueScreen(),
                  ),
                );
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.auto_stories),
              title: const Text('Grammaire'),
              subtitle: const Text('Apprendre la grammaire latine'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GrammaireScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.format_quote),
              title: const Text('Phrases & proverbes'),
              subtitle: const Text(
                'Des expressions latines utiles dans la vraie vie',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LocutionsScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Exercices'),
              subtitle: const Text('Pratiquer le latin'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TexteListeScreen(
                      textes: exercicesTraduction,
                      titre: 'Exercices de traduction',
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              subtitle: const Text('Rappels, sauvegarde de la progression'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ParametresScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const _CarteNachhilfe(),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// Petite carte promo : Luna donne des cours particuliers
// ------------------------------------------------------------

class _CarteNachhilfe extends StatelessWidget {
  const _CarteNachhilfe();

  static const _rose = Color(0xFFC2185B);
  static const _roseTexte = Color(0xFF8E2456);
  static const _roseFond = Color(0xFFFFE1F0);
  static const _roseBordure = Color(0xFFFF8FC7);
  static const _rosePuce = Color(0xFFFFC1E3);

  static const _email = 'majerusluna@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _roseFond,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: _roseBordure, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('💕', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                const Text(
                  'Cours particuliers avec Luna',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _rose,
                  ),
                ),
                const SizedBox(width: 2),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: _rose, size: 20),
                  tooltip: 'À propos de Luna',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AProposLunaScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Je donne des cours en luxembourgeois, français, anglais et '
              'allemand.',
              style: TextStyle(color: _roseTexte, height: 1.4),
            ),
            const SizedBox(height: 8),
            const Text(
              '15–20 €/heure — gratuit pour celles et ceux qui n\'en ont '
              'pas les moyens.',
              style: TextStyle(
                color: _roseTexte,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'N\'hésite pas à me contacter si ça t\'intéresse 💌',
              style: TextStyle(color: _roseTexte, height: 1.4),
            ),
            const SizedBox(height: 14),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                await Clipboard.setData(const ClipboardData(text: _email));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Adresse e-mail copiée 💌')),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _rosePuce,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.mail_outline, color: _rose, size: 18),
                    SizedBox(width: 8),
                    Text(
                      _email,
                      style: TextStyle(
                        color: _rose,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// À propos de Luna + lien vers le journal du concours
// Henri Kugener
// ------------------------------------------------------------

class AProposLunaScreen extends StatelessWidget {
  const AProposLunaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('À propos de Luna')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('👋💕', style: TextStyle(fontSize: 28)),
          const SizedBox(height: 16),
          const Text(
            'Salut ! Je m\'appelle Luna, je suis en 3e (troisième) au LCD.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'J\'ai programmé cette application moi-même, parce que '
            'j\'adore le latin et que je voulais un outil qui m\'aide à '
            'réviser — et qui puisse aussi être utile à d\'autres élèves.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'Avec deux camarades, j\'ai remporté le Concours Henri '
            'Kugener 🏆 : nous avons rédigé un journal sur les femmes et '
            'l\'amour dans la Rome antique.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.newspaper),
              title: const Text('Notre journal (on a gagné !) 🏆'),
              subtitle: const Text(
                'Lunae, Annae Devaeque — les femmes et l\'amour dans la '
                'Rome antique',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JournalHenriKugenerScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

const _cheminJournalHenriKugener = 'assets/henri_kugener/limited_edition.pdf';

class JournalHenriKugenerScreen extends StatefulWidget {
  const JournalHenriKugenerScreen({super.key});

  @override
  State<JournalHenriKugenerScreen> createState() =>
      _JournalHenriKugenerScreenState();
}

class _JournalHenriKugenerScreenState extends State<JournalHenriKugenerScreen> {
  late final PdfControllerPinch _controleur;

  @override
  void initState() {
    super.initState();
    _controleur = PdfControllerPinch(
      document: PdfDocument.openAsset(_cheminJournalHenriKugener),
    );
  }

  @override
  void dispose() {
    _controleur.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lunae, Annae Devaeque')),
      body: PdfViewPinch(controller: _controleur),
    );
  }
}

// ============================================================
// NAVIGATION PRINCIPALE
// ============================================================

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;

  late final List<Widget> _ecrans = [
    const AccueilScreen(),
    const UniteScreen(),
    const TextesHubScreen(),
    const StatistiquesScreen(),
    const PlusScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _ecrans),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.route), label: 'Parcours'),
          NavigationDestination(
            icon: Icon(Icons.menu_book),
            label: 'Vocabulaire',
          ),
          NavigationDestination(
            icon: Icon(Icons.import_contacts),
            label: 'Textes',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Stats',
          ),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: 'Plus'),
        ],
      ),
    );
  }
}

// ============================================================
// MINUTEUR COZY (POMODORO)
// ============================================================

const _couleurCozy = Color(0xFFE0A458);
const _fondCozy = Color(0xFF1E1912);

const _dureeTravailMinKey = 'pomodoroDureeTravailMin';
const _dureePauseMinKey = 'pomodoroDureePauseMin';

class _TassePainter extends CustomPainter {
  final double remplissage;
  final Color couleurTasse;
  final Color couleurCafe;

  _TassePainter({
    required this.remplissage,
    required this.couleurTasse,
    required this.couleurCafe,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final largeurCorps = size.width * 0.7;
    final hauteurCorps = size.height * 0.8;
    final gauche = (size.width - largeurCorps) / 2;
    final haut = size.height * 0.06;

    final corps = RRect.fromLTRBAndCorners(
      gauche,
      haut,
      gauche + largeurCorps,
      haut + hauteurCorps,
      topLeft: const Radius.circular(10),
      topRight: const Radius.circular(10),
      bottomLeft: const Radius.circular(30),
      bottomRight: const Radius.circular(30),
    );

    final traitTasse = Paint()
      ..color = couleurTasse
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    // Café, rempli du bas vers le haut selon la progression.
    canvas.save();
    canvas.clipRRect(corps);

    final hauteurCafe = hauteurCorps * remplissage.clamp(0.0, 1.0);

    canvas.drawRect(
      Rect.fromLTWH(
        gauche,
        haut + hauteurCorps - hauteurCafe,
        largeurCorps,
        hauteurCafe,
      ),
      Paint()..color = couleurCafe,
    );

    canvas.restore();

    // Anse de la tasse.
    final anse = Rect.fromLTWH(
      gauche + largeurCorps - 10,
      haut + hauteurCorps * 0.2,
      size.width * 0.24,
      hauteurCorps * 0.5,
    );
    canvas.drawArc(anse, -1.4, 2.8, false, traitTasse);

    // Contour de la tasse, par-dessus le café.
    canvas.drawRRect(corps, traitTasse);
  }

  @override
  bool shouldRepaint(covariant _TassePainter oldDelegate) =>
      oldDelegate.remplissage != remplissage;
}

// État global du minuteur : vit en dehors du widget pour continuer à
// tourner (et ne pas se réinitialiser) même si on quitte cet écran.
class PomodoroEtat extends ChangeNotifier {
  static const _dureePauseLongue = 15 * 60;

  int dureeTravail;
  int dureePause;

  late int secondesRestantes;
  late int secondesTotalPhase;
  bool enPause = false;
  bool enCours = false;
  int cyclesTermines = 0;

  Timer? _minuteur;

  PomodoroEtat()
    : dureeTravail = _chargerDureeMinutes(_dureeTravailMinKey, 25) * 60,
      dureePause = _chargerDureeMinutes(_dureePauseMinKey, 5) * 60 {
    secondesRestantes = dureeTravail;
    secondesTotalPhase = dureeTravail;
  }

  static int _chargerDureeMinutes(String cle, int defaut) {
    final box = Hive.box('vocabBox');
    return (box.get(cle) as int?) ?? defaut;
  }

  void definirDurees({required int travailMinutes, required int pauseMinutes}) {
    final box = Hive.box('vocabBox');
    box.put(_dureeTravailMinKey, travailMinutes);
    box.put(_dureePauseMinKey, pauseMinutes);

    dureeTravail = travailMinutes * 60;
    dureePause = pauseMinutes * 60;

    if (!enCours) {
      secondesRestantes = enPause ? dureePause : dureeTravail;
      secondesTotalPhase = secondesRestantes;
    }

    notifyListeners();
  }

  void demarrer() {
    if (enCours) return;

    enCours = true;

    _minuteur = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondesRestantes > 0) {
        secondesRestantes--;
      } else {
        _terminerPhase();
      }
      notifyListeners();
    });

    notifyListeners();
  }

  void mettreEnPause() {
    _minuteur?.cancel();
    enCours = false;
    notifyListeners();
  }

  void reinitialiser() {
    _minuteur?.cancel();

    enCours = false;
    enPause = false;
    secondesRestantes = dureeTravail;
    secondesTotalPhase = dureeTravail;

    notifyListeners();
  }

  void _terminerPhase() {
    _minuteur?.cancel();

    if (!enPause) {
      cyclesTermines++;
      enregistrerPomodoroTermine();
      ajouterCoins(10);
      verifierNouveauxSucces();
    }

    final prochainePause = !enPause;
    final pauseLongue = prochainePause && cyclesTermines % 4 == 0;

    final duree = prochainePause
        ? (pauseLongue ? _dureePauseLongue : dureePause)
        : dureeTravail;

    enPause = prochainePause;
    secondesRestantes = duree;
    secondesTotalPhase = duree;
    enCours = false;
  }
}

final pomodoroEtat = PomodoroEtat();

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _dernierCyclesTermines = pomodoroEtat.cyclesTermines;

  @override
  void initState() {
    super.initState();
    pomodoroEtat.addListener(_surMiseAJour);
  }

  @override
  void dispose() {
    pomodoroEtat.removeListener(_surMiseAJour);
    super.dispose();
  }

  void _surMiseAJour() {
    if (!mounted) return;

    if (pomodoroEtat.cyclesTermines != _dernierCyclesTermines) {
      _dernierCyclesTermines = pomodoroEtat.cyclesTermines;
      verifierSuccesEtNotifier(context);
    }

    setState(() {});
  }

  Future<void> _ouvrirReglages() async {
    int travail = (pomodoroEtat.dureeTravail / 60).round();
    int pause = (pomodoroEtat.dureePause / 60).round();

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Durées',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _ligneStepper(
                      label: 'Concentration',
                      valeur: travail,
                      onMoins: () {
                        setSheetState(() {
                          travail = (travail - 5).clamp(5, 90);
                        });
                      },
                      onPlus: () {
                        setSheetState(() {
                          travail = (travail + 5).clamp(5, 90);
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    _ligneStepper(
                      label: 'Pause',
                      valeur: pause,
                      onMoins: () {
                        setSheetState(() {
                          pause = (pause - 5).clamp(5, 30);
                        });
                      },
                      onPlus: () {
                        setSheetState(() {
                          pause = (pause + 5).clamp(5, 30);
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _couleurCozy,
                          foregroundColor: _fondCozy,
                        ),
                        onPressed: () {
                          pomodoroEtat.definirDurees(
                            travailMinutes: travail,
                            pauseMinutes: pause,
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Appliquer'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _ligneStepper({
    required String label,
    required int valeur,
    required VoidCallback onMoins,
    required VoidCallback onPlus,
  }) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
        IconButton(
          onPressed: onMoins,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        SizedBox(
          width: 56,
          child: Text(
            '$valeur min',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          onPressed: onPlus,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }

  String get texteTemps {
    final s = pomodoroEtat.secondesRestantes;
    final minutes = (s ~/ 60).toString().padLeft(2, '0');
    final secondes = (s % 60).toString().padLeft(2, '0');
    return '$minutes:$secondes';
  }

  @override
  Widget build(BuildContext context) {
    final progression =
        1 - (pomodoroEtat.secondesRestantes / pomodoroEtat.secondesTotalPhase);

    return Scaffold(
      backgroundColor: _fondCozy,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Minuteur cozy'),
        actions: [
          IconButton(
            onPressed: pomodoroEtat.enCours ? null : _ouvrirReglages,
            icon: const Icon(Icons.tune),
            tooltip: 'Choisir la durée',
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              pomodoroEtat.enPause ? Icons.local_cafe : Icons.menu_book,
              size: 40,
              color: _couleurCozy,
            ),

            const SizedBox(height: 12),

            Text(
              pomodoroEtat.enPause ? 'Pause' : 'Concentration',
              style: const TextStyle(
                fontSize: 18,
                color: texteAttenue,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              texteTemps,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: texteClair,
              ),
            ),

            const SizedBox(height: 16),

            CustomPaint(
              size: const Size(220, 240),
              painter: _TassePainter(
                remplissage: progression.clamp(0, 1).toDouble(),
                couleurTasse: _couleurCozy,
                couleurCafe: const Color(0xFF6F4423),
              ),
            ),

            const SizedBox(height: 32),

            Text(
              '🍅 ${pomodoroEtat.cyclesTermines} session(s) terminée(s) aujourd\'hui',
              style: const TextStyle(color: texteAttenue),
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 32,
                  onPressed: pomodoroEtat.reinitialiser,
                  icon: const Icon(Icons.replay, color: texteAttenue),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _couleurCozy,
                    foregroundColor: _fondCozy,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(24),
                  ),
                  onPressed: pomodoroEtat.enCours
                      ? pomodoroEtat.mettreEnPause
                      : pomodoroEtat.demarrer,
                  child: Icon(
                    pomodoroEtat.enCours ? Icons.pause : Icons.play_arrow,
                    size: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SUCCÈS
// ============================================================

class SuccesScreen extends StatefulWidget {
  const SuccesScreen({super.key});

  @override
  State<SuccesScreen> createState() => _SuccesScreenState();
}

class _SuccesScreenState extends State<SuccesScreen> {
  @override
  void initState() {
    super.initState();
    verifierNouveauxSucces();
  }

  @override
  Widget build(BuildContext context) {
    final debloques = succesDebloques();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Succès'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: badgeDeniers(coins())),
          ),
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: succesDisponibles.length,

        itemBuilder: (context, index) {
          final succes = succesDisponibles[index];
          final debloque = debloques.contains(succes.id);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(
              leading: Icon(
                debloque ? succes.icone : Icons.lock,
                color: debloque ? accentViolet : texteAttenue,
              ),

              title: Text(
                succes.titre,
                style: TextStyle(
                  color: debloque ? texteClair : texteAttenue,
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(succes.description),

              trailing: debloque
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : (succes.recompense > 0
                        ? badgeDeniers(succes.recompense, rayon: 10)
                        : null),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// BOUTIQUE
// ============================================================

class BoutiqueScreen extends StatefulWidget {
  const BoutiqueScreen({super.key});

  @override
  State<BoutiqueScreen> createState() => _BoutiqueScreenState();
}

class _BoutiqueScreenState extends State<BoutiqueScreen> {
  void acheter(ArticleBoutique article) {
    final reussi = acheterArticle(article);

    final message = reussi
        ? '${article.nom} acheté !'
        : 'Pas assez de deniers pour ${article.nom}.';

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final possedes = avatarsPossedes();
    final equipe = avatarEquipe();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boutique'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: badgeDeniers(coins())),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          if (gelsDeSerie() > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                '🧊 ${gelsDeSerie()} gel(s) de série en réserve — '
                'protège ta série un jour manqué',
                style: const TextStyle(color: texteAttenue),
              ),
            ),

          for (final article in articlesBoutique) ...[
            Card(
              child: ListTile(
                leading: Text(
                  article.emoji,
                  style: const TextStyle(fontSize: 28),
                ),

                title: Text(article.nom),

                subtitle: Text(
                  article.estAvatar
                      ? 'Avatar cosmétique'
                      : 'Protège ta série un jour manqué',
                ),

                trailing: article.estAvatar && possedes.contains(article.emoji)
                    ? (equipe == article.emoji
                          ? const Chip(label: Text('Équipé'))
                          : ElevatedButton(
                              onPressed: () {
                                equiperAvatar(article.emoji);
                                setState(() {});
                              },
                              child: const Text('Équiper'),
                            ))
                    : ElevatedButton(
                        onPressed: () => acheter(article),
                        child: Text('${article.prix} deniers'),
                      ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

// ============================================================
// SÉLECTEUR D'UNITÉ (change quel parcours de leçons est affiché)
// ============================================================

// Vol. I/II/III du manuel correspondent chacun à une année de collège.
const _anneesParVolume = {
  'Vol. I': 'Sixième',
  'Vol. II': 'Cinquième',
  'Vol. III': 'Quatrième / Troisième',
};

String _volumeDe(String unite) => unite.split(' – ').first;

String _anneeDe(String unite) =>
    _anneesParVolume[_volumeDe(unite)] ?? _volumeDe(unite);

// Supprime toute une "année" (un volume) d'un coup : utile pour retirer un
// volume erroné ou créé par mégarde (ex. via l'ajout de vocabulaire libre),
// qu'on ne peut pas gérer unité par unité puisqu'il n'a pas de vraies
// unités. On réutilise supprimerVocabulaire pour que chaque mot soit
// proprement retiré (blacklist des mots seedés, retrait du vocabulaire
// personnalisé, remise à zéro de la progression FSRS).
void supprimerVolume(String volume) {
  final mots = vocabulaire
      .where((mot) => _volumeDe(mot.unite) == volume)
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
      return AlertDialog(
        title: const Text('Supprimer cette année ?'),
        content: Text(
          'Tous les mots de « ${_anneesParVolume[volume] ?? volume} » et '
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
      );
    },
  );

  if (confirme == true) {
    supprimerVolume(volume);
    return true;
  }

  return false;
}

class SelecteurUniteScreen extends StatefulWidget {
  const SelecteurUniteScreen({super.key});

  @override
  State<SelecteurUniteScreen> createState() => _SelecteurUniteScreenState();
}

class _SelecteurUniteScreenState extends State<SelecteurUniteScreen> {
  @override
  Widget build(BuildContext context) {
    // Une entrée par année (Vol. I/II/III), pas par unité précise : les
    // leçons de toutes les unités d'une même année s'enchaînent dans un
    // seul chemin, l'une en dessous de l'autre.
    final volumes = vocabulaire
        .map((mot) => _volumeDe(mot.unite))
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Choisir une année')),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: volumes.length,

        itemBuilder: (context, index) {
          final volume = volumes[index];
          final nombreLecons = construireParcoursComplet()
              .where((lecon) => _volumeDe(lecon.unite) == volume)
              .length;
          // Seuls les volumes qui ne font pas partie du programme officiel
          // (Vol. I/II/III) peuvent être supprimés — typiquement une entrée
          // créée par erreur via l'ajout de vocabulaire libre.
          final estSupprimable = !_anneesParVolume.containsKey(volume);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: accentViolet,
                foregroundColor: texteClair,
                child: Text('$index'),
              ),
              title: Text(
                _anneesParVolume[volume] ?? volume,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                nombreLecons > 0
                    ? '$nombreLecons leçon(s) de grammaire'
                    : estSupprimable
                    ? 'Bientôt disponible · appui long pour supprimer'
                    : 'Bientôt disponible',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccueilScreen(unite: volume),
                  ),
                );
              },
              onLongPress: estSupprimable
                  ? () async {
                      final supprime = await confirmerSuppressionVolume(
                        context,
                        volume,
                      );
                      if (supprime) setState(() {});
                    }
                  : null,
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// PARCOURS DE LEÇONS : ÉCRAN DU CHEMIN
// ============================================================

class AccueilScreen extends StatefulWidget {
  // Un préfixe de volume (ex. 'Vol. I'), pas une unité précise : toutes
  // les leçons de toutes les unités de cette année s'enchaînent dans un
  // seul et même chemin, l'une en dessous de l'autre.
  final String unite;

  const AccueilScreen({super.key, this.unite = 'Vol. I'});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  Future<void> _ouvrirLecon(Lecon lecon) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LeconDetailScreen(lecon: lecon)),
    );

    setState(() {});
  }

  Future<void> _afficherPopupLecon(Lecon lecon, bool complete) async {
    final demarrer = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fermer',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: surfaceWidget,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: complete
                          ? accentViolet
                          : accentViolet.withValues(alpha: 0.2),
                    ),
                    child: Icon(
                      lecon.icone,
                      size: 30,
                      color: complete ? Colors.white : accentViolet,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    lecon.titre,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lecon.sousTitre,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: texteAttenue, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(complete ? 'Revoir' : 'Commencer'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
            child: child,
          ),
        );
      },
    );

    if (demarrer == true) {
      await _ouvrirLecon(lecon);
    }
  }

  static const _motifZigzag = [0.0, 0.55, 0.8, 0.55, 0.0, -0.55, -0.8, -0.55];

  double _decalage(int index) => _motifZigzag[index % _motifZigzag.length];

  // Petit point rouge sur l'avatar dès qu'un défi attend une réponse, pour
  // qu'on le remarque sans avoir à ouvrir l'écran Compte.
  Widget _avatarCompteAvecBadge() {
    const avatar = CircleAvatar(
      radius: 18,
      backgroundColor: Color(0x269F7AEA),
      child: Icon(Icons.account_circle, color: accentViolet),
    );

    final utilisateur = firebaseDisponible
        ? FirebaseAuth.instance.currentUser
        : null;

    if (utilisateur == null) return avatar;

    return StreamBuilder<List<Defi>>(
      stream: DuelService().defisRecus(utilisateur.uid),
      builder: (context, snap) {
        if ((snap.data?.length ?? 0) == 0) return avatar;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            avatar,
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: fond, width: 2),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final parcours = construireParcoursComplet()
        .where((lecon) => _volumeDe(lecon.unite) == widget.unite)
        .toList();
    final leconsTermineesVolume = parcours.where(leconEstCompletee).length;
    final streak = streakActuel();

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CompteScreen()),
            );
            setState(() {});
          },
          child: _avatarCompteAvecBadge(),
        ),
        actions: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: streak > 0 ? couleurStreak(streak) : texteAttenue,
              ),
              const SizedBox(width: 4),
              Text(
                '$streak',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 16),
          badgeDeniers(coins()),
          const SizedBox(width: 16),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _anneeDe(widget.unite).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: accentViolet,
                    letterSpacing: 1.2,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelecteurUniteScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.swap_horiz, size: 18),
                    label: const Text('Changer d\'année'),
                  ),
                ),
                if (parcours.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: leconsTermineesVolume / parcours.length,
                            minHeight: 8,
                            backgroundColor: surfaceWidget,
                            valueColor: const AlwaysStoppedAnimation(
                              accentViolet,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '$leconsTermineesVolume/${parcours.length} leçons',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: texteAttenue,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          if (parcours.isEmpty)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'Pas encore de leçons de grammaire pour cette unité — '
                    'bientôt disponible.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: texteAttenue),
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 32),

                itemCount: parcours.length,

                itemBuilder: (context, index) {
                  final lecon = parcours[index];
                  final complete = leconEstCompletee(lecon);
                  // Pas de verrouillage séquentiel : toutes les leçons
                  // sont accessibles directement, pour naviguer vite
                  // pendant la relecture/l'ajout de contenu.
                  final deverrouille = index >= 0;

                  final decalage = _decalage(index);
                  final nouvelleUnite =
                      index == 0 || lecon.unite != parcours[index - 1].unite;

                  return Column(
                    children: [
                      if (nouvelleUnite)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: texteAttenue.withValues(alpha: 0.4),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  lecon.unite.split(' – ').last,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: texteAttenue,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: texteAttenue.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 168,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment(decalage, -0.4),
                              child: _NoeudAnime(
                                index: index,
                                enfant: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: deverrouille
                                      ? () =>
                                            _afficherPopupLecon(lecon, complete)
                                      : null,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 76,
                                        height: 76,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: complete
                                              ? accentViolet
                                              : surfaceWidget.withValues(
                                                  alpha: deverrouille ? 1 : 0.5,
                                                ),
                                          border: Border.all(
                                            color: deverrouille
                                                ? accentViolet
                                                : Colors.transparent,
                                            width: 3,
                                          ),
                                        ),
                                        child: Icon(
                                          deverrouille
                                              ? lecon.icone
                                              : Icons.lock,
                                          size: 32,
                                          color: deverrouille
                                              ? (complete
                                                    ? Colors.white
                                                    : accentViolet)
                                              : texteAttenue,
                                        ),
                                      ),

                                      if (complete)
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                        ),

                                      const SizedBox(height: 6),

                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 170,
                                        ),
                                        child: Text(
                                          lecon.titre,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: deverrouille
                                                ? texteClair
                                                : texteAttenue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _NoeudAnime extends StatefulWidget {
  final int index;
  final Widget enfant;

  const _NoeudAnime({required this.index, required this.enfant});

  @override
  State<_NoeudAnime> createState() => _NoeudAnimeState();
}

class _NoeudAnimeState extends State<_NoeudAnime> {
  bool visible = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 60 * widget.index), () {
      if (mounted) setState(() => visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: visible ? 1 : 0.4,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 280),
        child: widget.enfant,
      ),
    );
  }
}

// ============================================================
// PARCOURS DE LEÇONS : DÉTAIL D'UNE LEÇON
// ============================================================

class LeconDetailScreen extends StatefulWidget {
  final Lecon lecon;

  const LeconDetailScreen({super.key, required this.lecon});

  @override
  State<LeconDetailScreen> createState() => _LeconDetailScreenState();
}

class _LeconDetailScreenState extends State<LeconDetailScreen> {
  static const _etapeExplication = 0;
  static const _etapeExercices = 1;
  static const _etapeFiche = 2;

  int etape = _etapeExplication;

  int indexQuestion = 0;
  int score = 0;
  String? optionChoisie;
  List<String> optionsMelangees = [];

  late final TextEditingController controleurSaisie;
  bool aValideSaisie = false;
  bool saisieCorrecte = false;

  @override
  void initState() {
    super.initState();
    controleurSaisie = TextEditingController();
    _preparerExercice();
  }

  @override
  void dispose() {
    controleurSaisie.dispose();
    super.dispose();
  }

  void _preparerExercice() {
    final exercice = widget.lecon.exercices![indexQuestion];

    optionsMelangees = switch (exercice) {
      QuestionLecon q => List.of(q.options)..shuffle(),
      ExerciceSaisie _ => [],
    };
  }

  void repondre(String option) {
    if (optionChoisie != null) return;

    final exercice = widget.lecon.exercices![indexQuestion] as QuestionLecon;

    setState(() {
      optionChoisie = option;

      if (option == exercice.reponseCorrecte) {
        score++;
      }
    });
  }

  void validerSaisie(ExerciceSaisie exercice) {
    if (aValideSaisie) return;

    final reponse = normaliserReponse(controleurSaisie.text);
    final correcte = exercice.reponsesAcceptees
        .map(normaliserReponse)
        .contains(reponse);

    setState(() {
      aValideSaisie = true;
      saisieCorrecte = correcte;

      if (correcte) score++;
    });
  }

  void suivantExercice() {
    if (indexQuestion + 1 >= widget.lecon.exercices!.length) {
      final reussite = score / widget.lecon.exercices!.length >= 0.7;

      if (reussite) {
        marquerLeconCompletee(widget.lecon.id);
        verifierSuccesEtNotifier(context);
      }

      setState(() {
        etape = _etapeFiche;
      });

      return;
    }

    setState(() {
      indexQuestion++;
      optionChoisie = null;
      aValideSaisie = false;
      saisieCorrecte = false;
      controleurSaisie.clear();
      _preparerExercice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lecon.titre)),
      body: switch (etape) {
        _etapeExercices => _construireExercice(context),
        _etapeFiche => _construireFiche(context),
        _ => _construireExplication(context),
      },
    );
  }

  Widget _construireExplication(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: widget.lecon.explication!(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => etape = _etapeExercices),
              child: const Text('Passer aux exercices'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _construireExercice(BuildContext context) {
    final exercice = widget.lecon.exercices![indexQuestion];
    final total = widget.lecon.exercices!.length;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Question ${indexQuestion + 1}/$total · Score : $score',
            style: const TextStyle(color: texteAttenue),
          ),

          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                exercice.question,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          switch (exercice) {
            QuestionLecon q => _corpsExerciceChoixMultiple(q, total),
            ExerciceSaisie s => _corpsExerciceSaisie(s, total),
          },
        ],
      ),
    );
  }

  Widget _corpsExerciceChoixMultiple(QuestionLecon question, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final option in optionsMelangees) ...[
          _boutonOptionLecon(option, question.reponseCorrecte),
          const SizedBox(height: 12),
        ],

        if (optionChoisie != null) ...[
          const SizedBox(height: 8),
          _ligneResultatExercice(
            correcte: optionChoisie == question.reponseCorrecte,
            texte: optionChoisie == question.reponseCorrecte
                ? 'Correct !'
                : 'Faux — la bonne réponse était : ${question.reponseCorrecte}',
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: suivantExercice,
            child: Text(
              indexQuestion + 1 >= total ? 'Voir la fiche' : 'Suivant',
            ),
          ),
        ],
      ],
    );
  }

  Widget _corpsExerciceSaisie(ExerciceSaisie exercice, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (exercice.indice != null) ...[
          Text(
            exercice.indice!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: texteAttenue,
            ),
          ),
          const SizedBox(height: 12),
        ],

        TextField(
          controller: controleurSaisie,
          readOnly: aValideSaisie,
          textAlign: TextAlign.center,
          autofocus: true,
          onSubmitted: (_) => validerSaisie(exercice),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: aValideSaisie,
            fillColor: aValideSaisie
                ? (saisieCorrecte ? Colors.green : Colors.red).withValues(
                    alpha: 0.15,
                  )
                : null,
          ),
        ),

        const SizedBox(height: 16),

        if (!aValideSaisie)
          ElevatedButton(
            onPressed: () => validerSaisie(exercice),
            child: const Text('Vérifier'),
          )
        else ...[
          _ligneResultatExercice(
            correcte: saisieCorrecte,
            texte: saisieCorrecte
                ? 'Correct !'
                : 'Faux — la bonne réponse était : '
                      '${exercice.reponsesAcceptees.first}',
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: suivantExercice,
            child: Text(
              indexQuestion + 1 >= total ? 'Voir la fiche' : 'Suivant',
            ),
          ),
        ],
      ],
    );
  }

  Widget _ligneResultatExercice({
    required bool correcte,
    required String texte,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          correcte ? Icons.check_circle : Icons.cancel,
          color: correcte ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            texte,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: correcte ? Colors.green : Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _boutonOptionLecon(String option, String reponseCorrecte) {
    Color? couleur;

    if (optionChoisie != null) {
      if (option == reponseCorrecte) {
        couleur = Colors.green;
      } else if (option == optionChoisie) {
        couleur = Colors.red;
      }
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: couleur,
          foregroundColor: texteClair,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () => repondre(option),
        child: Text(option, textAlign: TextAlign.center),
      ),
    );
  }

  Widget _construireFiche(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.lecon.fiche!(context),
                if (widget.lecon.uniteRecommandees.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Vocabulaire recommandé pour t\'entraîner',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: accentViolet,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final unite in widget.lecon.uniteRecommandees)
                    Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.menu_book),
                        title: Text(nomAffiche(unite)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VocabulaireListeScreen(unite: unite),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Terminer la leçon'),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// PHRASES & PROVERBES
// ============================================================

class Locution {
  final String latin;
  final String francais;
  final String contexte;

  const Locution({
    required this.latin,
    required this.francais,
    required this.contexte,
  });
}

const List<Locution> locutions = [
  Locution(
    latin: 'Carpe diem',
    francais: 'Cueille le jour',
    contexte: 'Profite de l\'instant présent (Horace).',
  ),
  Locution(
    latin: 'Alea jacta est',
    francais: 'Le sort en est jeté',
    contexte: 'Attribué à Jules César en franchissant le Rubicon.',
  ),
  Locution(
    latin: 'Veni, vidi, vici',
    francais: 'Je suis venu, j\'ai vu, j\'ai vaincu',
    contexte: 'Jules César, après une victoire éclair.',
  ),
  Locution(
    latin: 'Errare humanum est',
    francais: 'L\'erreur est humaine',
    contexte: 'Se dit pour excuser une faute.',
  ),
  Locution(
    latin: 'In vino veritas',
    francais: 'La vérité est dans le vin',
    contexte: 'L\'ivresse fait dire ce qu\'on pense vraiment.',
  ),
  Locution(
    latin: 'Tempus fugit',
    francais: 'Le temps fuit',
    contexte: 'Le temps passe vite, souvent gravé sur les horloges.',
  ),
  Locution(
    latin: 'Memento mori',
    francais: 'Souviens-toi que tu vas mourir',
    contexte: 'Rappel de la condition mortelle, pour relativiser.',
  ),
  Locution(
    latin: 'Cave canem',
    francais: 'Attention au chien',
    contexte: 'Inscription retrouvée à l\'entrée de maisons romaines.',
  ),
  Locution(
    latin: 'Cogito ergo sum',
    francais: 'Je pense, donc je suis',
    contexte: 'Descartes, formulé en latin.',
  ),
  Locution(
    latin: 'Homo homini lupus',
    francais: 'L\'homme est un loup pour l\'homme',
    contexte: 'Sur la cruauté des hommes entre eux.',
  ),
  Locution(
    latin: 'Mens sana in corpore sano',
    francais: 'Un esprit sain dans un corps sain',
    contexte: 'Souvent citée à propos du sport.',
  ),
  Locution(
    latin: 'Nulla dies sine linea',
    francais: 'Pas un jour sans une ligne',
    contexte: 'Pratiquer un peu chaque jour vaut mieux que rien.',
  ),
  Locution(
    latin: 'Dura lex, sed lex',
    francais: 'La loi est dure, mais c\'est la loi',
    contexte: 'On doit respecter la loi même si elle est sévère.',
  ),
  Locution(
    latin: 'Nemo propheta in patria',
    francais: 'Nul n\'est prophète en son pays',
    contexte: 'On est rarement reconnu par les siens.',
  ),
  Locution(
    latin: 'Repetita juvant',
    francais: 'Les répétitions aident',
    contexte: 'Répéter aide à apprendre — utile pour réviser !',
  ),
  Locution(
    latin: 'Festina lente',
    francais: 'Hâte-toi lentement',
    contexte: 'Il faut agir vite mais avec soin.',
  ),
  Locution(
    latin: 'Sic transit gloria mundi',
    francais: 'Ainsi passe la gloire du monde',
    contexte: 'Sur le caractère éphémère du succès.',
  ),
  Locution(
    latin: 'Ad astra',
    francais: 'Vers les étoiles',
    contexte: 'Viser haut, souvent complété en « per aspera ad astra ».',
  ),
];

class LocutionsScreen extends StatelessWidget {
  const LocutionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phrases & proverbes')),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: locutions.length,

        itemBuilder: (context, index) {
          final locution = locutions[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,

            child: ExpansionTile(
              title: Text(
                locution.latin,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locution.francais,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        locution.contexte,
                        style: const TextStyle(color: texteAttenue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// TEXTES LATINS (LECTURES) ET EXERCICES DE THÈME
// ============================================================
//
// Séparé exprès du système de leçons (Parcours) : ce sont des textes
// suivis, pas des points de grammaire isolés. Pensé pour être relié plus
// tard au vocabulaire (mot du texte -> fiche de vocabulaire), une fois la
// question de licence d'un dictionnaire latin-français réglée.

class ParagrapheTexte {
  final String texte;
  final String? glose;

  const ParagrapheTexte({required this.texte, this.glose});
}

class MotAConnaitre {
  final String latin;
  final String francais;
  final String? etymologie;

  const MotAConnaitre({
    required this.latin,
    required this.francais,
    this.etymologie,
  });
}

class Texte {
  final String id;
  final String titre;
  final String unite;
  final List<ParagrapheTexte> paragraphes;
  final List<MotAConnaitre> motsAConnaitre;
  final List<String> banqueDeMots;

  const Texte({
    required this.id,
    required this.titre,
    required this.unite,
    required this.paragraphes,
    this.motsAConnaitre = const [],
    this.banqueDeMots = const [],
  });
}

final List<Texte> lectures = [
  Texte(
    id: 'lectio_1',
    titre: 'Lectio 1 : De Ledona puella Gallica',
    unite: 'Vol. I – Unité 1',
    paragraphes: const [
      ParagrapheTexte(
        texte: 'Ledona puella Gallica est. Ledonae patria Gallia est.',
      ),
      ParagrapheTexte(
        texte: 'Puella magna est et oculos claros et comam pullam habet.',
        glose:
            'oculos = les yeux (acc.) · comam pullam = une chevelure '
            'brune · habet = a',
      ),
      ParagrapheTexte(
        texte: 'Fibulas amat et tunicam fibulis saepe ornat.',
        glose: 'amat = elle aime · ornat = elle décore',
      ),
      ParagrapheTexte(
        texte: 'Puella cum familiā in Arduennā silvā habitat.',
        glose: 'habitat = habite',
      ),
      ParagrapheTexte(
        texte: 'Familiae fama bona est nam Treveri magnam gloriam habent.',
        glose: 'Treveri = les Trévires (nom.) · habent = ont',
      ),
      ParagrapheTexte(
        texte:
            'Sed nunc copiae Romanae ad Ledonae terram veniunt et '
            'advenae ita puellae novam fortunam dant.',
        glose: 'veniunt = viennent · dant = donnent',
      ),
    ],
    motsAConnaitre: const [
      MotAConnaitre(
        latin: 'puella, ae, f.',
        francais: 'jeune fille',
        etymologie: 'pucelle',
      ),
      MotAConnaitre(
        latin: 'patria, ae, f.',
        francais: 'patrie',
        etymologie: 'patriotisme, patriote / ESP. et IT. patria / PORT. patria',
      ),
      MotAConnaitre(
        latin: 'bonus, a, um',
        francais: 'bon',
        etymologie: 'bonus, bonté / PORT. bom / IT. buono / ESP. bueno',
      ),
      MotAConnaitre(
        latin: 'fama, ae, f.',
        francais: '1. bruit qui court, rumeur — 2. renommée, réputation',
        etymologie: 'fameux, infâme, mal famé / PORT. fama / ANGL. famous',
      ),
      MotAConnaitre(
        latin: 'magnus, a, um',
        francais: 'grand',
        etymologie: 'magnanime, magnifique / Karolus Magnus - Charlemagne',
      ),
      MotAConnaitre(
        latin: 'novus, a, um',
        francais: 'nouveau',
        etymologie: 'novice / PORT. novo / ESP. nuevo / IT. nuovo',
      ),
      MotAConnaitre(
        latin: 'advena, ae, m.',
        francais: 'étranger',
        etymologie: 'advenir / ESP. advenir / ALL. Advent',
      ),
      MotAConnaitre(
        latin: 'fortuna, ae, f.',
        francais: '1. sort, destin — 2. hasard — 3. chance, fortune',
        etymologie:
            'fortuit, fortuité, la roue de la fortune / ANGL. fortuite / '
            'IT., PORT. et ESP. fortuna',
      ),
      MotAConnaitre(latin: 'nam', francais: 'car, en effet'),
    ],
  ),
  Texte(
    id: 'lectio_2',
    titre: 'Lectio 2 : De Vesta Vestalibusque',
    unite: 'Vol. I – Unité 1',
    paragraphes: const [
      ParagrapheTexte(
        texte:
            'Sunt feminae quae Vestae deae vitam dant. Feminae Vestales '
            'virgines vocantur.',
        glose:
            'quae = qui · dant = donnent · vocantur = sont appelées · '
            'Vestales virgines = jeunes filles vierges consacrées à Vesta',
      ),
      ParagrapheTexte(
        texte:
            'Vesta familiae dea est, nam perpetuae domus flammae curam '
            'habet.',
        glose:
            'perpetuae domus (gén. sg.) = de la maison éternelle · '
            'habet = a',
      ),
      ParagrapheTexte(
        texte: 'Perpetuam Romae flammam quoque curat. Ita patriae dea est.',
        glose: 'curat = prend soin de (+ acc.)',
      ),
      ParagrapheTexte(
        texte: 'Graeci deam Hestiam vocabant.',
        glose: 'Graeci (nom.) = les Grecs · vocabant = appelaient',
      ),
      ParagrapheTexte(
        texte: 'Puella, quae Vestae vovetur et sacram flammam curat,',
        glose: 'quae = qui · vovetur = est vouée',
      ),
      ParagrapheTexte(
        texte:
            'per totam vitam casta esse et in sacrā Vestae aede vivere '
            'debet.',
        glose:
            'totam = toute · casta = chaste · esse = être · aede '
            '(abl. f.) = temple · vivere = vivre · debet = doit',
      ),
      ParagrapheTexte(
        texte: 'Amulius ita putat : « Si Rheam Silviam Vestae voveo,',
        glose: 'putat = pense · voveo = je voue',
      ),
      ParagrapheTexte(
        texte: 'Rhea familiam habere numquam potest.',
        glose: 'habere = avoir · potest = peut',
      ),
      ParagrapheTexte(
        texte:
            'Familia mea bonam fortunam et magnam famam ita habet, nam '
            'semper regnare potest. »',
        glose: 'habet = a · regnare = régner · potest = peut',
      ),
    ],
    motsAConnaitre: const [
      MotAConnaitre(
        latin: 'de + abl.',
        francais: '(ici, et dans les titres en général) de ; au sujet de',
        etymologie: 'de facto',
      ),
      MotAConnaitre(
        latin: 'femina, ae, f.',
        francais: 'femme',
        etymologie: 'féminin, féminité / ROUM. femeia',
      ),
      MotAConnaitre(
        latin: 'vita, ae, f.',
        francais: 'vie',
        etymologie:
            'vital, vitalité / IT. vita / ESP. et PORT. vida / ad vitam '
            'aetérnam',
      ),
      MotAConnaitre(latin: 'Roma, ae, f.', francais: 'Rome'),
      MotAConnaitre(
        latin: 'quoque',
        francais:
            'aussi (ALL. auch), également (se place après le mot qu\'il '
            'souligne)',
        etymologie: 'Tu quoque, fili mi.',
      ),
      MotAConnaitre(
        latin: 'per + acc.',
        francais: '(ici) pendant (CCT) ; à travers, par (CCL)',
        etymologie: 'persévérer, perpétuer',
      ),
      MotAConnaitre(
        latin: 'numquam',
        francais: 'ne...jamais, jamais...ne',
        etymologie: 'ESP. et PORT. nunca',
      ),
      MotAConnaitre(
        latin: 'meus, a, um',
        francais: 'mon',
        etymologie: 'PORT. meu',
      ),
      MotAConnaitre(
        latin: 'semper',
        francais: 'toujours',
        etymologie: 'sempiternel / PORT. sempre / ESP. siempre',
      ),
    ],
  ),
  Texte(
    id: 'lectio_3',
    titre: 'Lectio 3 : De silvā agróque',
    unite: 'Vol. I – Unité 2',
    paragraphes: const [
      ParagrapheTexte(
        texte:
            'Ledona in silvā ambulat et multas feras videt: lupos, '
            'cervos aprósque.',
        glose: 'videt = elle voit',
      ),
      ParagrapheTexte(
        texte:
            'Prope ripam fluvii cerva fetus ad aquam ducit, sed lupus '
            'feras videt et vorat.',
        glose:
            'fetus (acc. pl.) = ses petits · ducit = elle mène · '
            'vorat = il dévore',
      ),
      ParagrapheTexte(
        texte:
            'Lupus silvam relinquit et in agrum venit; sed servi lupum '
            'magno animo ex agris pellunt.',
        glose:
            'relinquit = il quitte · venit = il vient · pellunt = ils '
            'chassent',
      ),
      ParagrapheTexte(
        texte: 'Treverórum servi cum equis et arátris in agris laborant.',
        glose:
            'arátris (abl. pl. de arátrum, i, n.) = avec des charrues · '
            'laborant = ils travaillent',
      ),
      ParagrapheTexte(
        texte: 'Drúidae in silvis semper sunt, nam deos deasque ibi colunt.',
        glose: 'colunt = ils honorent, ils vénèrent',
      ),
      ParagrapheTexte(
        texte: 'Puélla viris sacris gratiam dat neque silvárum umbram timet.',
        glose:
            'gratiam dat = elle témoigne de la reconnaissance · '
            'timet = elle craint',
      ),
      ParagrapheTexte(
        texte:
            'Sed Románi silvas non amant, quia in silvis pugnáre '
            'difficile est.',
        glose: 'pugnáre = combattre · difficile = difficile',
      ),
    ],
    motsAConnaitre: const [
      MotAConnaitre(latin: '-que', francais: 'et (enclitique, soudé au mot)'),
      MotAConnaitre(
        latin: 'equus, i, m.',
        francais: 'cheval',
        etymologie: 'équitation, équestre',
      ),
      MotAConnaitre(
        latin: 'ex / e + abl.',
        francais: 'hors de, de ; à partir de',
        etymologie: 'exporter / ex nihilo nihil',
      ),
      MotAConnaitre(
        latin: 'murus, i, m. / muri, orum, m. pl.',
        francais: 'mur / remparts, murailles',
        etymologie: 'mur, mural / intra muros, extra muros',
      ),
      MotAConnaitre(
        latin: 'ager, agri, m.',
        francais: 'champ ; territoire',
        etymologie: 'agricole, agriculture, agraire',
      ),
      MotAConnaitre(
        latin: 'fera, ae, f.',
        francais: 'bête sauvage',
        etymologie: 'ESP. fiera',
      ),
      MotAConnaitre(
        latin: 'prope + acc.',
        francais: 'près de (choses)',
        etymologie: 'ROUM. aproape',
      ),
      MotAConnaitre(latin: 'ripa, ae, f.', francais: 'rive, rivage'),
      MotAConnaitre(
        latin: 'lupus, i, m. / lupa, ae, f.',
        francais: 'loup / louve',
        etymologie: 'ESP. et PORT. lobo, loba',
      ),
      MotAConnaitre(
        latin: 'in + acc.',
        francais: 'dans, en, sur (lieu où l\'on va)',
        etymologie: 'in memoriam',
      ),
      MotAConnaitre(
        latin: 'servus, i, m.',
        francais: 'esclave',
        etymologie: 'servitude, servile, asservir',
      ),
      MotAConnaitre(
        latin: 'animus, i, m.',
        francais: '1. esprit 2. âme 3. courage',
        etymologie: 'animosité / mens sana in córpore sano',
      ),
      MotAConnaitre(
        latin: 'aper, apri, m.',
        francais: 'sanglier',
        etymologie: 'ALL. Wildschwein',
      ),
      MotAConnaitre(
        latin: 'cervus, i, m.',
        francais: 'cerf',
        etymologie: 'ALL. Hirsch',
      ),
    ],
  ),
  Texte(
    id: 'lectio_4',
    titre: 'Lectio 4 : De Rhea Sílvia, Romanórum matre',
    unite: 'Vol. I – Unité 2',
    paragraphes: const [
      ParagrapheTexte(
        texte: 'Sed Rheae Sílviae fortuna mutat, nam Mars deus Rheam amat.',
        glose: 'mutat = change',
      ),
      ParagrapheTexte(
        texte: 'Ita Rhea liberos, Rómulum Remúmque, gignit: gemélli sunt.',
        glose: 'gignit = elle met au monde, elle fait naître',
      ),
      ParagrapheTexte(
        texte:
            'Amúlius autem malus dóminus est et gemellos timet, nam Rheae '
            'família magnam glóriam habet.',
      ),
      ParagrapheTexte(
        texte: 'Amúlius servum vocat et gemellos ad flúvii aquam portat.',
        glose: 'vocat = il appelle · portat = il porte',
      ),
      ParagrapheTexte(
        texte: 'Servus autem gemellos non necat, sed prope ripam relinquit.',
        glose: 'necat = il tue',
      ),
      ParagrapheTexte(
        texte: 'Lupa gemellos ibi invenit et servat.',
        glose: 'invenit = elle trouve · servat = elle sauve, elle protège',
      ),
      ParagrapheTexte(
        texte:
            'Post multos annos, Faústulus pastor gemellos in agris invenit '
            'et magno ánimo educat.',
        glose: 'pastor = le berger · educat = il éduque, il élève',
      ),
      ParagrapheTexte(
        texte:
            'Tum Rómulus et Remus, jam viri, novum locum super Palatínum '
            'quaerunt.',
        glose: 'jam viri = déjà des hommes · quaerunt = ils cherchent',
      ),
      ParagrapheTexte(
        texte:
            'Ibi Rómulus novam pátriam condit et primos muros super '
            'Palatínum aedíficat: ita Roma nunc pópuli Románi pátria est.',
        glose: 'aedíficat = il construit, il bâtit · nunc = maintenant',
      ),
    ],
    motsAConnaitre: const [
      MotAConnaitre(
        latin: 'gemélli, órum, m. pl.',
        francais: 'jumeaux',
        etymologie: 'gémellaire, gémeaux / ESP. gemelos',
      ),
      MotAConnaitre(
        latin: 'líberi, órum, m. pl.',
        francais: 'enfants (fils et filles)',
      ),
      MotAConnaitre(
        latin: 'dóminus, i, m.',
        francais: 'maître',
        etymologie: 'dominical / ESP. et PORT. domingo',
      ),
      MotAConnaitre(
        latin: 'malus, a, um',
        francais: 'mauvais, méchant',
        etymologie: 'un malus, la malice',
      ),
      MotAConnaitre(
        latin: 'flúvius, i, m.',
        francais: 'fleuve',
        etymologie: 'fluvial, effluve',
      ),
      MotAConnaitre(
        latin: 'pópulus, i, m.',
        francais: 'peuple',
        etymologie: 'senátus populúsque Románus (SPQR)',
      ),
      MotAConnaitre(latin: 'autem', francais: 'or, mais, quant à'),
      MotAConnaitre(
        latin: 'tum, tunc',
        francais: 'alors',
        etymologie: 'ROUM. atunci',
      ),
      MotAConnaitre(
        latin: 'post + acc.',
        francais: 'après [CCT] ; derrière [CCL]',
        etymologie: 'postérieur, postériorité, postérité',
      ),
      MotAConnaitre(
        latin: 'super + acc.',
        francais: 'au-dessus de, au-delà de',
        etymologie: 'super (interjection), Superman',
      ),
      MotAConnaitre(
        latin: 'murus, i, m. / muri, orum, m. pl.',
        francais: 'mur / remparts, murailles',
      ),
    ],
  ),
];

// Exercices 1.8 et 1.10 : thèmes (français -> latin) à traduire soi-même,
// avec la banque de mots du manuel. Pas de corrigé fabriqué ici : le
// manuel n'en fournit pas, et inventer une "solution" latine non
// vérifiée risquerait d'induire en erreur plutôt que d'aider.
final List<Texte> exercicesTraduction = [
  Texte(
    id: 'exercice_1_8',
    titre: 'Exercice 1.8 : De la ruine de Troie à la fondation de Rome',
    unite: 'Vol. I – Unité 1',
    paragraphes: const [
      ParagrapheTexte(
        texte:
            '1. Après la ruine de Troie, le jeune prince Énée put prendre '
            'la fuite de sa patrie, en compagnie de son père, Anchise, et '
            'de son fils Iule-Ascagne. Il emmena avec lui les Pénates, '
            'les divinités tutélaires de [sa] patrie.',
      ),
      ParagrapheTexte(
        texte:
            '2. Quand la fortune eut emmené Énée loin de sa patrie, elle '
            'le conduisit vers l\'Afrique, chez la reine Élissa, une '
            'belle femme qui avait trouvé une nouvelle patrie à Carthage.',
      ),
      ParagrapheTexte(
        texte:
            '3. Or, Énée ne pouvait rester pour toujours en Afrique, '
            'puisque c\'était en Italie qu\'il devait fonder une nouvelle '
            'patrie.',
      ),
      ParagrapheTexte(
        texte:
            '4. Après avoir rencontré le roi Latinus, Énée épousa '
            'Lavinia, la fille de celui-ci, et leur fils, Ascagne, était '
            'destiné à fonder la colonie d\'Albe-la-Longue non loin de la '
            'future Rome.',
      ),
      ParagrapheTexte(
        texte:
            '5. Grâce au bon sort que les dieux leur réservaient, '
            'Iule-Ascagne et sa famille régnaient ainsi pendant de '
            'longues années dans [leur] nouvelle patrie.',
      ),
      ParagrapheTexte(
        texte:
            '6. Mais, pour pouvoir monter sur le trône, un des '
            'descendants lointains d\'Énée, le méchant Amulius, avait '
            'fait tuer les fils de son frère Numitor et voué Rhea '
            'Silvia, la fille de celui-ci, à la déesse Vesta.',
      ),
      ParagrapheTexte(
        texte:
            '7. Rhea Silvia devait ainsi servir la déesse du foyer '
            'pendant [toute sa] vie dans l\'ombre du temple de la déesse '
            'et ne pouvait pas avoir de famille.',
      ),
      ParagrapheTexte(
        texte:
            '8. Mais le sort de Rome n\'était pas tel et Rhea Silvia, '
            'aimée de Mars, fit naître des jumeaux.',
      ),
      ParagrapheTexte(
        texte:
            '9. Lorsqu\'une louve trouva les jumeaux de Rhea Silvia, '
            'abandonnés dans les eaux d\'un fleuve, elle leur donna son '
            'lait dans l\'ombre d\'un arbre.',
      ),
      ParagrapheTexte(
        texte:
            '10. Ignorant la cause de leur abandon, le berger Faustulus '
            'éleva les garçons comme un père pendant de longues années.',
      ),
      ParagrapheTexte(
        texte:
            '11. Quand ils eurent l\'âge de régner, Romulus et Remus '
            'vengèrent leur grand-père et revendiquèrent leur juste '
            'place dans le destin de Rome.',
      ),
      ParagrapheTexte(
        texte:
            '12. Après que Romulus eut vu douze vautours dans le ciel, '
            'il fonda [sa] nouvelle patrie près du Tibre, sur le mont '
            'Palatin.',
      ),
    ],
    banqueDeMots: const [
      'Troja',
      'Aeneas, ae, m. (1re décl., nominatif en -as)',
      'fuga (fuite)',
      '(nova) patria',
      '(bona) fortuna',
      'Africa',
      'regina, ae, f. (reine)',
      'Élissa',
      'femina',
      'Italia',
      'filia',
      'colonia',
      'Rhea Silvia',
      'dea',
      'Vesta',
      'vita',
      'umbra (ombre)',
      'familia',
      'Roma',
      'lupa (louve)',
      'aqua (eau)',
      'causa',
      'ad + acc.',
      'in + abl.',
      'per + acc.',
    ],
  ),
  Texte(
    id: 'exercice_1_10',
    titre: 'Exercice 1.10 : L\'étranger et la reine — Énée et Élissa',
    unite: 'Vol. I – Unité 1',
    paragraphes: const [
      ParagrapheTexte(
        texte:
            'Élissa, une femme célèbre, mène (agit) [sa] vie en Afrique '
            'dans une grande abondance. Grâce au soin des jeunes filles '
            'et des femmes de [sa] patrie, elle est bientôt (mox) reine '
            '(regina, ae, f.) et accueille (accipit) un étranger, Énée '
            '(Aeneas, ae, m.). La terre de Troie est la patrie de '
            'l\'étranger, mais il vient (venit) vers l\'Afrique grâce à '
            'une étoile (stella, ae, f.) et vit (vivit) maintenant en '
            'Afrique. Il aime (amat) la bonne reine et raconte (narrat) '
            '[sa] vie à la famille de la reine. Mais le destin appelle '
            '(vocat) Énée vers l\'Italie, où (ubi) il fonde (condit) une '
            'nouvelle patrie.',
      ),
    ],
    banqueDeMots: const [
      'agit (mène)',
      'mox (bientôt)',
      'regina, ae, f. (reine)',
      'accipit (accueille)',
      'Aeneas, ae, m.',
      'venit (vient)',
      'stella, ae, f. (étoile)',
      'vivit (vit)',
      'amat (aime)',
      'narrat (raconte)',
      'vocat (appelle)',
      'ubi (où)',
      'condit (fonde)',
    ],
  ),
  Texte(
    id: 'exercice_2_7',
    titre: 'Exercice 2.7 : Thème — traduis les mots soulignés',
    unite: 'Vol. I – Unité 2',
    paragraphes: const [
      ParagrapheTexte(
        texte: '1. Les années apportent de nouveaux soucis au peuple gaulois.',
      ),
      ParagrapheTexte(
        texte: '2. Les femmes attachent [leurs] tuniques grâce à des fibules.',
      ),
      ParagrapheTexte(
        texte:
            '3. Romains, vous ne craignez pas la forêt des Ardennes car '
            'vous êtes en compagnie de [votre] famille.',
      ),
      ParagrapheTexte(
        texte:
            '4. À la fois les jeunes filles et les garçons combattent '
            'avec grand courage contre les aléas de [leur] sort et ne '
            'restent pas dans l\'ombre sacrée.',
      ),
    ],
    banqueDeMots: const [
      'annus, i, m. (année)',
      'cura, ae, f. (souci)',
      'populus, i, m. (peuple)',
      'femina, ae, f. (femme)',
      'tunica, ae, f. (tunique)',
      'fibula, ae, f. (fibule)',
      'Romani, orum, m. pl.',
      'Arduenna silva (la forêt des Ardennes)',
      'timeo, es, ere (craindre)',
      'familia, ae, f.',
      'puella, ae, f.',
      'puer, i, m.',
      'pugno, as, are (combattre)',
      'magnus animus (grand courage)',
      'fortuna, ae, f. (sort)',
      'sacer, sacra, sacrum (sacré)',
      'umbra, ae, f. (ombre)',
      'et ... et ... (à la fois ... et ...)',
      'neque / nec (et ... ne ... pas)',
    ],
  ),
  Texte(
    id: 'exercice_2_8',
    titre: 'Exercice 2.8 : L\'éducation chez les Romains',
    unite: 'Vol. I – Unité 2',
    paragraphes: const [
      ParagrapheTexte(
        texte:
            '1. Au temps des Romains, les enfants étaient d\'abord éduqués '
            'par leurs parents.',
      ),
      ParagrapheTexte(
        texte:
            '2. Les Romains pensaient en effet : « Il est important '
            'd\'honorer les valeurs familiales, de respecter les dieux et '
            'de combattre avec grand courage.',
      ),
      ParagrapheTexte(
        texte:
            '3. Mère et père apprendront donc aux enfants la piété '
            'filiale et le respect des dieux.',
      ),
      ParagrapheTexte(
        texte:
            '4. Ensuite le père apprendra à [ses] garçons à lire et à '
            'écrire, ainsi qu\'à avoir du courage dans les combats. »',
      ),
      ParagrapheTexte(
        texte:
            '5. Dès l\'apparition des premières écoles, le litterátor '
            'cultivait l\'esprit des enfants âgés de 7 à 11 ans en leur '
            'apprenant à lire, à écrire et à calculer.',
      ),
      ParagrapheTexte(
        texte:
            '6. Le grammáticus instruisait ensuite en grammaire et en '
            'littérature les garçons âgés de 12 à 15 ans, avant que le '
            'rhetor n\'apprenne l\'art oratoire aux garçons âgés de 15 à '
            '17 ans.',
      ),
      ParagrapheTexte(
        texte:
            '7. Ô garçons, vous deviendrez de bons Romains si vous rendez '
            'toujours grâce aux dieux !',
      ),
    ],
    banqueDeMots: const [
      'Romani, orum, m. pl.',
      'liberi, orum, m. pl.',
      'deus, i, m.',
      'animus, i, m.',
      'puer, i, m.',
    ],
  ),
  Texte(
    id: 'exercice_2_9',
    titre: 'Exercice 2.9 : Romulus, désigné premier roi de Rome par les dieux',
    unite: 'Vol. I – Unité 2',
    paragraphes: const [
      ParagrapheTexte(
        texte:
            '1. Après que Romulus et Remus eurent décidé de fonder une '
            'ville nouvelle non loin d\'Albe, les jumeaux ne purent '
            'définir qui d\'entre eux serait le maître, et une querelle '
            'éclata à [cet] endroit, sur le futur territoire de Rome.',
      ),
      ParagrapheTexte(
        texte:
            '2. Comme on ne pouvait en effet désigner l\'homme le plus '
            'capable ni par le courage, ni par le nombre d\'années, ils '
            'prièrent les dieux de leur apprendre qui devait être le '
            'premier roi des Romains.',
      ),
      ParagrapheTexte(
        texte:
            '3. Afin de connaître la volonté des dieux, les jumeaux '
            'firent donc appel à la divination, car même des esclaves '
            'savaient qu\'il ne fallait négliger ni les dieux ni les avis '
            'des dieux.',
      ),
      ParagrapheTexte(
        texte:
            '4. Seuls les dieux pouvaient décider qui serait le maître '
            'd\'une ville destinée à exister pendant de longues années et '
            'à dominer tous les autres peuples.',
      ),
      ParagrapheTexte(
        texte:
            '5. Les augures, des prêtres chargés de savoir si les dieux '
            'étaient favorables ou non à un projet envisagé par les '
            'Romains, allaient donc « prendre les auspices » et observer '
            'le vol des oiseaux dans le ciel au-dessus d\'un périmètre '
            'bien défini, appelé l\'enceinte sacrée.',
      ),
      ParagrapheTexte(
        texte:
            '6. Avec [leurs] amis, les jumeaux choisirent ainsi chacun '
            'une colline pour l\'observation : le Palatin revint à '
            'Romulus, l\'Aventin à Remus.',
      ),
      ParagrapheTexte(
        texte:
            '7. Remus fut alors le premier à voir six vautours dans la '
            'partie du ciel définie.',
      ),
      ParagrapheTexte(
        texte:
            '8. À peine eut-il annoncé le nombre de vautours que Romulus '
            'en vit douze de son côté.',
      ),
      ParagrapheTexte(
        texte:
            '9. L\'un et l\'autre furent salués rois par [leurs] amis. '
            '« Puisque tu as obtenu le présage des dieux le premier, les '
            'dieux te désignent, toi, Remus, en tant que roi », dirent '
            'les uns, alors que les autres revendiquèrent : « C\'est toi, '
            'Romulus, que les dieux désignent comme roi, parce qu\'ils '
            't\'ont envoyé deux fois six vautours. »',
      ),
      ParagrapheTexte(
        texte:
            '10. Selon l\'historien Tite-Live, « la tradition la plus '
            'répandue » rapporte que Remus, supportant mal sa défaite et '
            'ne voulant pas accepter le jugement divin, jugea ridicules '
            'les murs symboliques tracés sur le sol par Romulus et, '
            'd\'un saut, il les enjamba.',
      ),
      ParagrapheTexte(
        texte:
            '11. Rendu furieux par cet acte, Romulus tua Remus et '
            'construisit pour [son] peuple, le peuple romain, les '
            'premiers murs de Rome sur le Palatin.',
        glose:
            'Compléments du passif (complément d\'agent) : ici, par '
            '[leurs] amis / par Romulus — construits avec a(b) + abl.',
      ),
    ],
    banqueDeMots: const [
      'Romulus, i, m.',
      'Remus, i, m.',
      'Alba, ae, f. (Albe)',
      'gemelli, orum, m. pl.',
      'dominus, i, m.',
      'locus, i, m.',
      'ager, agri, m.',
      'vir, viri, m.',
      'animus, i, m.',
      'numerus, i, m. (nombre)',
      'annus, i, m.',
      'deus, i, m. (pl. dei / di)',
      'Romani, orum, m. pl.',
      'servus, i, m.',
      'populus, i, m.',
      'Palatinus, i, m.',
      'Aventinus, i, m.',
      'primus, a, um',
      'amicus, i, m.',
      'murus, i, m.',
      'Roma, ae, f.',
      'post + acc.',
      'super + acc.',
      'haud procul a(b) + abl. (non loin de)',
      'in + acc.',
      'ad + acc.',
      'per + acc.',
      'a(b) + abl.',
      'cum + abl.',
    ],
  ),
];

class TextesHubScreen extends StatelessWidget {
  const TextesHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Textes latins')),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('Textes du manuel'),
              subtitle: const Text('Lectio 1 & 2, glosées'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TexteListeScreen(
                      textes: lectures,
                      titre: 'Textes du manuel',
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.edit_note),
              title: const Text('Mes textes'),
              subtitle: const Text(
                'Tes propres textes latins, à analyser et traduire',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MesTextesScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TexteListeScreen extends StatelessWidget {
  final List<Texte> textes;
  final String titre;

  const TexteListeScreen({
    super.key,
    required this.textes,
    required this.titre,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titre)),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: textes.length,

        itemBuilder: (context, index) {
          final texte = textes[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                texte.titre,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(nomAffiche(texte.unite)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TexteDetailScreen(texte: texte),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class TexteDetailScreen extends StatelessWidget {
  final Texte texte;

  const TexteDetailScreen({super.key, required this.texte});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(texte.titre)),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          for (final paragraphe in texte.paragraphes) ...[
            Text(
              paragraphe.texte,
              style: const TextStyle(fontSize: 17, height: 1.5),
            ),
            if (paragraphe.glose != null) ...[
              const SizedBox(height: 4),
              Text(
                paragraphe.glose!,
                style: const TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: texteAttenue,
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],

          if (texte.banqueDeMots.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'Banque de mots',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: accentViolet,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final mot in texte.banqueDeMots) Chip(label: Text(mot)),
              ],
            ),
          ],

          if (texte.motsAConnaitre.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              'Mots à connaître',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: accentViolet,
              ),
            ),
            const SizedBox(height: 8),
            for (final mot in texte.motsAConnaitre)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mot.latin,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(mot.francais),
                      if (mot.etymologie != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          mot.etymologie!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: texteAttenue,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

// ============================================================
// MES TEXTES : ÉCRANS
// ============================================================

class MesTextesScreen extends StatefulWidget {
  const MesTextesScreen({super.key});

  @override
  State<MesTextesScreen> createState() => _MesTextesScreenState();
}

class _MesTextesScreenState extends State<MesTextesScreen> {
  Future<void> _supprimer(MonTexte texte) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer ce texte ?'),
          content: Text('« ${texte.titre} » sera définitivement supprimé.'),
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
        );
      },
    );

    if (confirme == true) {
      supprimerMonTexte(texte.id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final textes = mesTextes();

    return Scaffold(
      appBar: AppBar(title: const Text('Mes textes')),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Ajouter un texte'),
        onPressed: () async {
          final ajoute = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AjouterTexteScreen()),
          );

          if (ajoute == true) setState(() {});
        },
      ),

      body: textes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Pas encore de texte. Ajoute ton premier texte latin à '
                  'analyser !',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: texteAttenue),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: textes.length,

              itemBuilder: (context, index) {
                final texte = textes[index];
                final nombreMots = texte.texte
                    .split(RegExp(r'\s+'))
                    .where((m) => m.isNotEmpty)
                    .length;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      texte.titre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '$nombreMots mots · ${texte.tags.length} annoté(s)',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _supprimer(texte),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AnalyseTexteScreen(texteId: texte.id),
                        ),
                      );
                      setState(() {});
                    },
                  ),
                );
              },
            ),
    );
  }
}

class AjouterTexteScreen extends StatefulWidget {
  const AjouterTexteScreen({super.key});

  @override
  State<AjouterTexteScreen> createState() => _AjouterTexteScreenState();
}

class _AjouterTexteScreenState extends State<AjouterTexteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _texteController = TextEditingController();

  @override
  void dispose() {
    _titreController.dispose();
    _texteController.dispose();
    super.dispose();
  }

  void _soumettre() {
    if (!_formKey.currentState!.validate()) return;

    ajouterMonTexte(_titreController.text.trim(), _texteController.text.trim());
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un texte')),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titreController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (valeur) => (valeur == null || valeur.trim().isEmpty)
                    ? 'Champ requis'
                    : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _texteController,
                decoration: const InputDecoration(
                  labelText: 'Texte latin',
                  alignLabelWithHint: true,
                ),
                maxLines: 12,
                minLines: 6,
                validator: (valeur) => (valeur == null || valeur.trim().isEmpty)
                    ? 'Champ requis'
                    : null,
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _soumettre,
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fonctions grammaticales proposées pour le marquage (mêmes catégories que
// la leçon "Les fonctions dans la phrase") + leur abréviation d'affichage.
const _fonctionsDisponibles = [
  'Sujet',
  'COD',
  'COI',
  'CN',
  'CC de temps',
  'CC de lieu',
  'CC de manière',
  'CC de cause',
  'CC de moyen',
  'Apostrophe',
  'Attribut du sujet',
  'Apposition',
  'Autre',
];

const _abreviationsFonctions = {
  'Sujet': 'S',
  'COD': 'COD',
  'COI': 'COI',
  'CN': 'CN',
  'CC de temps': 'CCT',
  'CC de lieu': 'CCL',
  'CC de manière': 'CCM',
  'CC de cause': 'CCC',
  'CC de moyen': 'CCMoy',
  'Apostrophe': 'Apostr.',
  'Attribut du sujet': 'Attr.',
  'Apposition': 'Appos.',
  'Autre': '?',
};

String _motSansPonctuation(String mot) {
  return mot.replaceAll(RegExp('^[.,;:!?«»"\'()]+|[.,;:!?«»"\'()]+\$'), '');
}

class AnalyseTexteScreen extends StatefulWidget {
  final String texteId;

  const AnalyseTexteScreen({super.key, required this.texteId});

  @override
  State<AnalyseTexteScreen> createState() => _AnalyseTexteScreenState();
}

class _AnalyseTexteScreenState extends State<AnalyseTexteScreen> {
  late MonTexte _texte;

  @override
  void initState() {
    super.initState();
    _texte = mesTextes().firstWhere((t) => t.id == widget.texteId);
  }

  String? _fonctionPour(int index) {
    for (final tag in _texte.tags) {
      if (tag.index == index) return tag.fonction;
    }
    return null;
  }

  void _definirFonction(int index, String mot, String? fonction) {
    final nouveauxTags = _texte.tags.where((t) => t.index != index).toList();

    if (fonction != null) {
      nouveauxTags.add(TagMot(index: index, mot: mot, fonction: fonction));
    }

    setState(() {
      _texte = MonTexte(
        id: _texte.id,
        titre: _texte.titre,
        texte: _texte.texte,
        tags: nouveauxTags,
      );
    });

    mettreAJourTagsTexte(_texte.id, nouveauxTags);
  }

  Future<void> _ouvrirActionsMot(int index, String motBrut) async {
    final motPropre = _motSansPonctuation(motBrut);
    final fonctionActuelle = _fonctionPour(index);

    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    motPropre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Chercher le mot'),
                onTap: () => Navigator.pop(context, 'chercher'),
              ),
              ListTile(
                leading: const Icon(Icons.label_outline),
                title: const Text('Marquer sa fonction'),
                subtitle: fonctionActuelle != null
                    ? Text('Actuellement : $fonctionActuelle')
                    : null,
                onTap: () => Navigator.pop(context, 'fonction'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (!mounted || action == null) return;

    if (action == 'chercher') {
      await _chercherMot(motPropre);
    } else if (action == 'fonction') {
      await _choisirFonction(index, motPropre, fonctionActuelle);
    }
  }

  Future<void> _choisirFonction(int index, String mot, String? actuelle) async {
    const retirer = '__retirer__';

    final choix = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Fonction de « $mot »',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final fonction in _fonctionsDisponibles)
                      ListTile(
                        title: Text(fonction),
                        trailing: actuelle == fonction
                            ? const Icon(Icons.check, color: accentViolet)
                            : null,
                        onTap: () => Navigator.pop(context, fonction),
                      ),
                    if (actuelle != null)
                      ListTile(
                        leading: const Icon(Icons.close, color: Colors.red),
                        title: const Text('Retirer le marquage'),
                        onTap: () => Navigator.pop(context, retirer),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (choix == null) return;

    _definirFonction(index, mot, choix == retirer ? null : choix);
  }

  Future<void> _chercherMot(String mot) async {
    final resultatsClasse = chercherDansVocabulaire(mot);

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mot,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (resultatsClasse.isNotEmpty) ...[
                  const Text(
                    'Dans ton vocabulaire de classe :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: accentViolet,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final v in resultatsClasse)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text('${v.latin} — ${v.francais}'),
                    ),
                ] else ...[
                  const Text(
                    'Aucune correspondance trouvée.',
                    style: TextStyle(color: texteAttenue),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter à mon vocabulaire'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AjouterVocabulaireScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final segments = RegExp(
      r'\S+|\s+',
    ).allMatches(_texte.texte).map((m) => m[0]!).toList();

    var indexMot = 0;
    final spans = <InlineSpan>[];

    for (final segment in segments) {
      if (segment.trim().isEmpty) {
        spans.add(
          TextSpan(text: segment, style: const TextStyle(fontSize: 17)),
        );
        continue;
      }

      final indexActuel = indexMot;
      indexMot++;
      final fonction = _fonctionPour(indexActuel);

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: GestureDetector(
            onTap: () => _ouvrirActionsMot(indexActuel, segment),
            child: Text(
              fonction != null
                  ? '$segment${_abreviationsFonctions[fonction] ?? ''}'
                  : segment,
              style: TextStyle(
                fontSize: 17,
                height: 1.6,
                decoration: fonction != null ? TextDecoration.underline : null,
                decorationColor: accentViolet,
                color: fonction != null ? accentViolet : texteClair,
                fontWeight: fonction != null ? FontWeight.bold : null,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_texte.titre)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text.rich(
          TextSpan(children: spans, style: const TextStyle(height: 1.6)),
        ),
      ),
    );
  }
}
