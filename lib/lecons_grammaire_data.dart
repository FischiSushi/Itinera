import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'grammaire_tableaux_data.dart';
import 'main.dart';
import 'vocabulaire_data.dart';
import 'screens/declinaisons_screen.dart' show tableauDeclinaison;
import 'screens/grammaire_screen.dart' show tableauConjugaison, tableauImparfait;

// ============================================================
// PARCOURS DE LEÇONS : DONNÉES
// ============================================================

sealed class ExerciceLecon {
  const ExerciceLecon();

  String get question;
}

class QuestionLecon extends ExerciceLecon {
  @override
  final String question;
  final List<String> options;
  final String reponseCorrecte;

  const QuestionLecon({
    required this.question,
    required this.options,
    required this.reponseCorrecte,
  });
}

// Exercice à réponse libre (saisie clavier), corrigé automatiquement.
class ExerciceSaisie extends ExerciceLecon {
  @override
  final String question;
  final List<String> reponsesAcceptees;
  final String? indice;

  const ExerciceSaisie({
    required this.question,
    required this.reponsesAcceptees,
    this.indice,
  });
}

// Normalise une réponse saisie pour la comparaison : espaces, casse et
// accents de prononciation pédagogiques (Rómae -> romae) ignorés.
String normaliserReponse(String texte) {
  const accents = {
    'á': 'a',
    'à': 'a',
    'â': 'a',
    'ä': 'a',
    'é': 'e',
    'è': 'e',
    'ê': 'e',
    'ë': 'e',
    'í': 'i',
    'ì': 'i',
    'î': 'i',
    'ï': 'i',
    'ó': 'o',
    'ò': 'o',
    'ô': 'o',
    'ö': 'o',
    'ú': 'u',
    'ù': 'u',
    'û': 'u',
    'ü': 'u',
    'ý': 'y',
  };

  var resultat = texte.trim().toLowerCase();

  accents.forEach((accentue, simple) {
    resultat = resultat.replaceAll(accentue, simple);
  });

  resultat = resultat.replaceAll(RegExp(r'[.!?,;:]+$'), '').trim();

  return resultat.replaceAll(RegExp(r'\s+'), ' ');
}

// Un "parcours guidé" alterne de courts blocs de lecture avec des
// vérifications rapides (non notées, juste formatives), plutôt que de tout
// lire d'un bloc avant d'attaquer le quiz noté (voir Lecon.etapes).
sealed class EtapeLecon {
  const EtapeLecon();
}

class EtapeTexte extends EtapeLecon {
  final List<Widget> Function(BuildContext) contenu;

  const EtapeTexte(this.contenu);
}

class EtapeVerification extends EtapeLecon {
  final ExerciceLecon exercice;

  const EtapeVerification(this.exercice);
}

class Lecon {
  final String id;
  final String titre;
  final String sousTitre;
  final IconData icone;

  // À quelle unité (au sens du vocabulaire, ex. "Vol. I – Unité 1") cette
  // leçon de grammaire appartient — permet un parcours distinct par unité.
  final String unite;

  final List<Widget> Function(BuildContext)? explication;
  final List<ExerciceLecon>? exercices;
  final Widget Function(BuildContext)? fiche;

  // Si présent, remplace l'écran d'explication par un parcours guidé qui
  // alterne lecture et vérifications rapides — voir EtapeLecon. Le quiz
  // noté (exercices) et la fiche restent inchangés et suivent le parcours
  // guidé normalement.
  final List<EtapeLecon>? etapes;

  // Unités de vocabulaire recommandées pour aller avec ce point de
  // grammaire (accessibles librement, pas verrouillées).
  final List<String> uniteRecommandees;

  const Lecon({
    required this.id,
    required this.titre,
    required this.sousTitre,
    required this.icone,
    this.unite = 'Vol. I – Unité 1',
    this.explication,
    this.exercices,
    this.fiche,
    this.etapes,
    this.uniteRecommandees = const [],
  });
}

const _leconsCompleteesKey = 'leconsCompletees';

Set<String> leconsCompletees() {
  final box = Hive.box('vocabBox');
  return Set<String>.from((box.get(_leconsCompleteesKey) as List?) ?? []);
}

void marquerLeconCompletee(String id) {
  final box = Hive.box('vocabBox');
  final completees = leconsCompletees()..add(id);
  box.put(_leconsCompleteesKey, completees.toList());
}

bool leconEstCompletee(Lecon lecon) {
  return leconsCompletees().contains(lecon.id);
}

// ------------------------------------------------------------
// Petits widgets réutilisés dans les explications de leçons
// ------------------------------------------------------------

Widget _titreExplication(String texte) {
  return Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(
      texte,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: accentViolet,
      ),
    ),
  );
}

Widget _paragrapheExplication(String texte) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(texte, style: const TextStyle(fontSize: 15, height: 1.5)),
  );
}

Widget _tableauRolesCas(List<List<String>> lignes) {
  return Table(
    border: TableBorder.all(color: texteAttenue.withValues(alpha: 0.3)),
    columnWidths: const {
      0: FlexColumnWidth(1),
      1: FlexColumnWidth(1.6),
      2: FlexColumnWidth(1.3),
    },
    children: [
      const TableRow(
        children: [
          Padding(
            padding: EdgeInsets.all(6),
            child: Text('Cas', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.all(6),
            child: Text('Rôle', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.all(6),
            child: Text(
              'Question',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      for (final ligne in lignes)
        TableRow(
          children: [
            Padding(padding: const EdgeInsets.all(6), child: Text(ligne[0])),
            Padding(padding: const EdgeInsets.all(6), child: Text(ligne[1])),
            Padding(padding: const EdgeInsets.all(6), child: Text(ligne[2])),
          ],
        ),
    ],
  );
}

// ------------------------------------------------------------
// Vocabulaire recommandé par leçon (réparti simplement en 3 tiers,
// en attendant un étiquetage plus précis par point de grammaire)
// ------------------------------------------------------------

List<String> _unitesRecommandeesTranche(int debut, int fin) {
  final toutes = vocabulaire.map((mot) => mot.unite).toSet().toList();

  return toutes.sublist(
    debut.clamp(0, toutes.length),
    fin.clamp(0, toutes.length),
  );
}

// ------------------------------------------------------------
// Leçon 1 : Qu'est-ce qu'un cas ?
// ------------------------------------------------------------

final Lecon _leconCasIntro = Lecon(
  id: 'cas_intro',
  titre: 'Qu\'est-ce qu\'un cas ?',
  sousTitre: 'Nominatif, accusatif, génitif, datif, ablatif',
  icone: Icons.help_outline,
  uniteRecommandees: _unitesRecommandeesTranche(0, 8),
  explication: (context) => [
    _paragrapheExplication(
      'En français, c\'est l\'ordre des mots qui indique qui fait quoi.\n'
      '« Le loup mange l\'agneau » ne veut pas dire la même chose que '
      '« L\'agneau mange le loup ».',
    ),
    _paragrapheExplication(
      'En latin, ce n\'est pas la position du mot qui compte, mais sa '
      'terminaison (la fin du mot). Chaque terminaison indique le rôle '
      'du mot dans la phrase : sujet, complément, possession...\n\n'
      'Cette terminaison s\'appelle un cas. Changer les terminaisons '
      's\'appelle décliner un mot, et l\'ensemble de ses terminaisons '
      'possibles s\'appelle sa déclinaison.',
    ),
    _paragrapheExplication(
      'C\'est pourquoi l\'ordre des mots est très libre en latin : '
      '« Lupus agnum vorat » et « Agnum lupus vorat » veulent dire '
      'exactement la même chose (Le loup dévore l\'agneau), grâce aux '
      'terminaisons -us et -um.',
    ),
    _titreExplication('Les cas et leur rôle'),
    _tableauRolesCas([
      ['Nominatif', 'le sujet, qui fait l\'action', 'qui est-ce qui ?'],
      ['Vocatif', 'pour appeler quelqu\'un', 'ô ... !'],
      ['Accusatif', 'le complément d\'objet direct', 'qui ? quoi ?'],
      ['Génitif', 'la possession', 'de qui ? de quoi ?'],
      ['Datif', 'le complément d\'objet indirect', 'à qui ? à quoi ?'],
      ['Ablatif', 'le moyen, la manière, le lieu', 'par/avec/dans quoi ?'],
    ]),
    _titreExplication('Un même mot, tous les cas'),
    _paragrapheExplication(
      'Voici « lupus » (le loup) décliné dans une phrase à chaque cas :\n\n'
      '• Nominatif — Lupus currit.\n   Le loup court.\n\n'
      '• Vocatif — Ô lupe, ubi es ?\n   Ô loup, où es-tu ?\n\n'
      '• Accusatif — Puer lupum videt.\n   Le garçon voit le loup.\n\n'
      '• Génitif — Cauda lupi longa est.\n   La queue du loup est longue.\n\n'
      '• Datif — Puer cibum lupo dat.\n   Le garçon donne de la nourriture au loup.\n\n'
      '• Ablatif — Puella cum lupo ambulat.\n   La fille se promène avec le loup.',
    ),
  ],
  etapes: [
    EtapeTexte(
      (context) => [
        _paragrapheExplication(
          'En français, c\'est l\'ordre des mots qui indique qui fait quoi.\n'
          '« Le loup mange l\'agneau » ne veut pas dire la même chose que '
          '« L\'agneau mange le loup ».',
        ),
      ],
    ),
    EtapeTexte(
      (context) => [
        _paragrapheExplication(
          'En latin, ce n\'est pas la position du mot qui compte, mais sa '
          'terminaison (la fin du mot). Chaque terminaison indique le rôle '
          'du mot dans la phrase : sujet, complément, possession...\n\n'
          'Cette terminaison s\'appelle un cas. Changer les terminaisons '
          's\'appelle décliner un mot, et l\'ensemble de ses terminaisons '
          'possibles s\'appelle sa déclinaison.',
        ),
      ],
    ),
    EtapeTexte(
      (context) => [
        _paragrapheExplication(
          'C\'est pourquoi l\'ordre des mots est très libre en latin : '
          '« Lupus agnum vorat » et « Agnum lupus vorat » veulent dire '
          'exactement la même chose (Le loup dévore l\'agneau), grâce aux '
          'terminaisons -us et -um.',
        ),
      ],
    ),
    EtapeTexte(
      (context) => [
        _titreExplication('Les cas et leur rôle'),
        _tableauRolesCas([
          ['Nominatif', 'le sujet, qui fait l\'action', 'qui est-ce qui ?'],
          ['Vocatif', 'pour appeler quelqu\'un', 'ô ... !'],
          ['Accusatif', 'le complément d\'objet direct', 'qui ? quoi ?'],
          ['Génitif', 'la possession', 'de qui ? de quoi ?'],
          ['Datif', 'le complément d\'objet indirect', 'à qui ? à quoi ?'],
          ['Ablatif', 'le moyen, la manière, le lieu', 'par/avec/dans quoi ?'],
        ]),
      ],
    ),
    const EtapeVerification(
      QuestionLecon(
        question:
            'Quel cas exprime le sujet de la phrase, celui qui fait l\'action ?',
        options: ['Nominatif', 'Accusatif', 'Génitif', 'Datif'],
        reponseCorrecte: 'Nominatif',
      ),
    ),
    const EtapeVerification(
      QuestionLecon(
        question:
            'Quel cas est utilisé pour le complément d\'objet direct (COD) ?',
        options: ['Nominatif', 'Accusatif', 'Datif', 'Ablatif'],
        reponseCorrecte: 'Accusatif',
      ),
    ),
    const EtapeVerification(
      QuestionLecon(
        question: 'Quel cas exprime la possession (« de qui ? de quoi ? ») ?',
        options: ['Génitif', 'Accusatif', 'Vocatif', 'Ablatif'],
        reponseCorrecte: 'Génitif',
      ),
    ),
    EtapeTexte(
      (context) => [
        _titreExplication('Un même mot, tous les cas'),
        _paragrapheExplication(
          'Voici « lupus » (le loup) décliné dans une phrase à chaque cas :\n\n'
          '• Nominatif — Lupus currit.\n   Le loup court.\n\n'
          '• Vocatif — Ô lupe, ubi es ?\n   Ô loup, où es-tu ?\n\n'
          '• Accusatif — Puer lupum videt.\n   Le garçon voit le loup.\n\n'
          '• Génitif — Cauda lupi longa est.\n   La queue du loup est longue.\n\n'
          '• Datif — Puer cibum lupo dat.\n   Le garçon donne de la nourriture au loup.\n\n'
          '• Ablatif — Puella cum lupo ambulat.\n   La fille se promène avec le loup.',
        ),
      ],
    ),
    const EtapeVerification(
      QuestionLecon(
        question:
            'Dans « Puer lupum videt » (Le garçon voit le loup), '
            'quel est le rôle de « lupum » ?',
        options: [
          'Sujet (nominatif)',
          'COD (accusatif)',
          'Possession (génitif)',
          'COI (datif)',
        ],
        reponseCorrecte: 'COD (accusatif)',
      ),
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'Quel cas exprime le sujet de la phrase, celui qui fait l\'action ?',
      options: ['Nominatif', 'Accusatif', 'Génitif', 'Datif'],
      reponseCorrecte: 'Nominatif',
    ),
    QuestionLecon(
      question: 'Quel cas répond à la question « à qui ? » ou « à quoi ? »',
      options: ['Ablatif', 'Datif', 'Génitif', 'Nominatif'],
      reponseCorrecte: 'Datif',
    ),
    QuestionLecon(
      question: 'Quel cas exprime la possession (« de qui ? de quoi ? ») ?',
      options: ['Génitif', 'Accusatif', 'Vocatif', 'Ablatif'],
      reponseCorrecte: 'Génitif',
    ),
    QuestionLecon(
      question:
          'Quel cas est utilisé pour le complément d\'objet direct (COD) ?',
      options: ['Nominatif', 'Accusatif', 'Datif', 'Ablatif'],
      reponseCorrecte: 'Accusatif',
    ),
    QuestionLecon(
      question:
          'Quel cas exprime le moyen ou la manière (« par quoi ? avec quoi ? ») ?',
      options: ['Ablatif', 'Génitif', 'Nominatif', 'Vocatif'],
      reponseCorrecte: 'Ablatif',
    ),
    QuestionLecon(
      question:
          'Dans « Puer lupum videt » (Le garçon voit le loup), '
          'quel est le rôle de « lupum » ?',
      options: [
        'Sujet (nominatif)',
        'COD (accusatif)',
        'Possession (génitif)',
        'COI (datif)',
      ],
      reponseCorrecte: 'COD (accusatif)',
    ),
    QuestionLecon(
      question:
          'Dans « Cauda lupi longa est » (La queue du loup est longue), '
          'quel est le rôle de « lupi » ?',
      options: [
        'Sujet (nominatif)',
        'COD (accusatif)',
        'Possession (génitif)',
        'Moyen (ablatif)',
      ],
      reponseCorrecte: 'Possession (génitif)',
    ),
    QuestionLecon(
      question:
          'Quel cas sert à interpeller ou appeler quelqu\'un directement ?',
      options: ['Vocatif', 'Nominatif', 'Datif', 'Ablatif'],
      reponseCorrecte: 'Vocatif',
    ),
  ],
  fiche: (context) => _tableauRolesCas([
    ['Nominatif', 'le sujet, qui fait l\'action', 'qui est-ce qui ?'],
    ['Vocatif', 'pour appeler quelqu\'un', 'ô ... !'],
    ['Accusatif', 'le complément d\'objet direct', 'qui ? quoi ?'],
    ['Génitif', 'la possession', 'de qui ? de quoi ?'],
    ['Datif', 'le complément d\'objet indirect', 'à qui ? à quoi ?'],
    ['Ablatif', 'le moyen, la manière, le lieu', 'par/avec/dans quoi ?'],
  ]),
);

// ------------------------------------------------------------
// Leçon 2 : 1ère déclinaison
// ------------------------------------------------------------

final Lecon _leconDeclinaison1 = Lecon(
  id: 'decl_1',
  titre: '1ère déclinaison',
  sousTitre: 'puella, -ae — les mots en -a',
  icone: Icons.looks_one,
  uniteRecommandees: _unitesRecommandeesTranche(8, 16),
  explication: (context) => [
    _paragrapheExplication(
      'Maintenant que tu connais le rôle de chaque cas, voici comment ils '
      's\'expriment concrètement.\n\n'
      'Les noms latins se répartissent en 5 groupes de terminaisons, '
      'appelés déclinaisons. La 1ère déclinaison regroupe surtout des noms '
      'féminins terminés par -a au nominatif singulier, comme puella '
      '(la jeune fille).',
    ),
    _titreExplication('Les terminaisons'),
    tableauDeclinaison(declinaisons[0]),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Le génitif singulier (ici puellae) permet toujours de reconnaître '
      'la déclinaison d\'un mot : c\'est pourquoi le dictionnaire indique '
      'toujours les deux formes, « puella, -ae ».',
    ),
  ],
  etapes: [
    EtapeTexte(
      (context) => [
        _paragrapheExplication(
          'Maintenant que tu connais le rôle de chaque cas, voici comment '
          'ils s\'expriment concrètement.\n\n'
          'Les noms latins se répartissent en 5 groupes de terminaisons, '
          'appelés déclinaisons. La 1ère déclinaison regroupe surtout des '
          'noms féminins terminés par -a au nominatif singulier, comme '
          'puella (la jeune fille).',
        ),
      ],
    ),
    EtapeTexte(
      (context) => [
        _titreExplication('Les terminaisons'),
        tableauDeclinaison(declinaisons[0]),
      ],
    ),
    const EtapeVerification(
      QuestionLecon(
        question: 'Quel est le nominatif singulier de puella (le mot de base) ?',
        options: ['puella', 'puellam', 'puellae', 'puellas'],
        reponseCorrecte: 'puella',
      ),
    ),
    const EtapeVerification(
      QuestionLecon(
        question:
            'Quel est le génitif singulier de puella (utilisé dans le dictionnaire) ?',
        options: ['puella', 'puellam', 'puellae', 'puellis'],
        reponseCorrecte: 'puellae',
      ),
    ),
    EtapeTexte(
      (context) => [
        _paragrapheExplication(
          'Le génitif singulier (ici puellae) permet toujours de '
          'reconnaître la déclinaison d\'un mot : c\'est pourquoi le '
          'dictionnaire indique toujours les deux formes, « puella, -ae ».',
        ),
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quel est le nominatif singulier de puella (le mot de base) ?',
      options: ['puella', 'puellam', 'puellae', 'puellas'],
      reponseCorrecte: 'puella',
    ),
    QuestionLecon(
      question: 'Quel est l\'accusatif singulier de puella ?',
      options: ['puella', 'puellam', 'puellae', 'puellarum'],
      reponseCorrecte: 'puellam',
    ),
    QuestionLecon(
      question:
          'Quel est le génitif singulier de puella (utilisé dans le dictionnaire) ?',
      options: ['puella', 'puellam', 'puellae', 'puellis'],
      reponseCorrecte: 'puellae',
    ),
    QuestionLecon(
      question: 'Quel est le datif singulier de rosa (la rose) ?',
      options: ['rosa', 'rosam', 'rosae', 'rosarum'],
      reponseCorrecte: 'rosae',
    ),
    QuestionLecon(
      question: 'Quel est l\'ablatif singulier de rosa ?',
      options: ['rosa', 'rosam', 'rosae', 'rosis'],
      reponseCorrecte: 'rosa',
    ),
    QuestionLecon(
      question: 'Quel est le nominatif pluriel de puella ?',
      options: ['puella', 'puellae', 'puellas', 'puellarum'],
      reponseCorrecte: 'puellae',
    ),
    QuestionLecon(
      question: 'Quel est le génitif pluriel de rosa ?',
      options: ['rosae', 'rosarum', 'rosis', 'rosas'],
      reponseCorrecte: 'rosarum',
    ),
    QuestionLecon(
      question: 'Quel est l\'accusatif pluriel de puella ?',
      options: ['puellae', 'puellas', 'puellarum', 'puellis'],
      reponseCorrecte: 'puellas',
    ),
    QuestionLecon(
      question:
          'Quel est le datif pluriel de rosa (identique à l\'ablatif pluriel) ?',
      options: ['rosae', 'rosarum', 'rosis', 'rosas'],
      reponseCorrecte: 'rosis',
    ),
    ExerciceSaisie(
      question: 'Décline flamma (la flamme) au génitif singulier.',
      reponsesAcceptees: ['flammae'],
      indice: 'Le génitif singulier de la 1ère déclinaison se termine en -ae.',
    ),
    ExerciceSaisie(
      question: 'Décline Vesta à l\'accusatif singulier.',
      reponsesAcceptees: ['Vestam'],
    ),
    ExerciceSaisie(
      question:
          'Décline « bona dea » (la bonne déesse) à l\'accusatif singulier. '
          'L\'adjectif s\'accorde avec le nom.',
      reponsesAcceptees: ['bonam deam'],
    ),
    ExerciceSaisie(
      question: 'Décline silva (la forêt) au nominatif pluriel.',
      reponsesAcceptees: ['silvae'],
    ),
    ExerciceSaisie(
      question: 'Décline fortuna (la fortune) au génitif pluriel.',
      reponsesAcceptees: ['fortunarum'],
      indice: 'Le génitif pluriel de la 1ère déclinaison se termine en -arum.',
    ),
  ],
  fiche: (context) => tableauDeclinaison(declinaisons[0]),
);

// ------------------------------------------------------------
// Leçon 3 : 2e déclinaison
// ------------------------------------------------------------

final Lecon _leconDeclinaison2 = Lecon(
  id: 'decl_2',
  titre: '2e déclinaison',
  sousTitre: 'dominus / bellum / puer / ager / vir',
  icone: Icons.looks_two,
  unite: 'Vol. I – Unité 2',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'La 2e déclinaison regroupe deux groupes principaux :\n'
      '• les masculins en -us, comme dominus, -i (le maître)\n'
      '• les neutres en -um, comme bellum, -i (la guerre)',
    ),
    _titreExplication('Masculin (dominus)'),
    tableauDeclinaison(declinaisons[1]),
    const SizedBox(height: 16),
    _titreExplication('Neutre (bellum)'),
    tableauDeclinaison(declinaisons[2]),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Règle importante à retenir pour TOUS les neutres, à toutes les '
      'déclinaisons : le nominatif, le vocatif et l\'accusatif sont '
      'toujours identiques. Et au pluriel, ces trois cas se terminent '
      'toujours par -a.',
    ),
    _titreExplication('Les noms et adjectifs en -er'),
    _paragrapheExplication(
      'En plus des mots en -us, la 2e déclinaison comprend des noms et '
      'adjectifs qui ont un nominatif (et un vocatif) singulier en -er. '
      'À tous les autres cas, ils se déclinent exactement comme dominus. '
      'Deux cas de figure :\n\n'
      '• le radical garde son -e- partout : puer, púeri (le garçon) → '
      'génitif púeri, accusatif púerum...\n'
      '• le radical perd son -e- partout sauf au nominatif/vocatif '
      'singulier : ager, agri (le champ) → génitif agri (pas « ageri »), '
      'accusatif agrum...\n\n'
      'Le génitif singulier indiqué dans le dictionnaire permet de '
      'savoir tout de suite dans quel cas on se trouve.',
    ),
    _titreExplication('puer, pueri'),
    tableauDeclinaison(declinaisons[9]),
    const SizedBox(height: 16),
    _titreExplication('ager, agri (radical qui perd son -e-)'),
    tableauDeclinaison(declinaisons[10]),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Les adjectifs suivent le même schéma : miser, mísera, míserum '
      '(malheureux) se décline comme puer ; pulcher, pulchra, pulchrum '
      '(beau) et sacer, sacra, sacrum (sacré) se déclinent comme ager, '
      'mais seulement au masculin — le féminin (pulchra) et le neutre '
      '(pulchrum) suivent leurs déclinaisons habituelles (1re et 2e '
      'neutre), sans perdre de -e-, puisqu\'il n\'y en avait pas.',
    ),
    _titreExplication('vir, viri — une exception à part'),
    tableauDeclinaison(declinaisons[11]),
    _paragrapheExplication(
      'vir (l\'homme, le mari) ne se termine ni en -us ni en -er au '
      'nominatif, mais suit par ailleurs exactement le modèle de puer '
      '(le radical vir- ne change pas).',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'Quel est le génitif singulier de dominus (utilisé dans le dictionnaire) ?',
      options: ['domini', 'dominum', 'domino', 'dominus'],
      reponseCorrecte: 'domini',
    ),
    QuestionLecon(
      question: 'Quel est le vocatif singulier de dominus (pour l\'appeler) ?',
      options: ['dominus', 'domine', 'domini', 'domino'],
      reponseCorrecte: 'domine',
    ),
    QuestionLecon(
      question: 'Quel est l\'accusatif singulier de dominus ?',
      options: ['dominus', 'domine', 'dominum', 'domino'],
      reponseCorrecte: 'dominum',
    ),
    QuestionLecon(
      question: 'Quel est le nominatif pluriel de dominus ?',
      options: ['domini', 'dominos', 'dominorum', 'dominis'],
      reponseCorrecte: 'domini',
    ),
    QuestionLecon(
      question:
          'Quel est l\'accusatif singulier de bellum (neutre — rappelle-toi la règle) ?',
      options: ['bellum', 'belli', 'bello', 'bella'],
      reponseCorrecte: 'bellum',
    ),
    QuestionLecon(
      question: 'Quel est le nominatif pluriel de bellum ?',
      options: ['bellum', 'belli', 'bella', 'bellorum'],
      reponseCorrecte: 'bella',
    ),
    QuestionLecon(
      question:
          'Quel est l\'accusatif pluriel de bellum (identique à un autre cas) ?',
      options: ['bellum', 'bella', 'bellorum', 'bellis'],
      reponseCorrecte: 'bella',
    ),
    QuestionLecon(
      question: 'Quel est le génitif pluriel de dominus ?',
      options: ['domini', 'dominorum', 'dominis', 'dominos'],
      reponseCorrecte: 'dominorum',
    ),
    QuestionLecon(
      question: 'Quel est l\'ablatif singulier de bellum ?',
      options: ['bello', 'belli', 'bellum', 'bellis'],
      reponseCorrecte: 'bello',
    ),
    QuestionLecon(
      question:
          'Quel est le génitif singulier de puer (utilisé dans le dictionnaire) ?',
      options: ['puer', 'pueri', 'puero', 'puerum'],
      reponseCorrecte: 'pueri',
    ),
    QuestionLecon(
      question:
          'Quel est le génitif singulier de ager (utilisé dans le dictionnaire, attention au radical) ?',
      options: ['ageri', 'agri', 'agro', 'agrum'],
      reponseCorrecte: 'agri',
    ),
    QuestionLecon(
      question: 'Quel est l\'accusatif singulier de ager ?',
      options: ['ager', 'agri', 'agrum', 'agro'],
      reponseCorrecte: 'agrum',
    ),
    QuestionLecon(
      question:
          'Pourquoi ager perd-il son -e- au génitif (agri) alors que puer le garde (pueri) ?',
      options: [
        'C\'est propre au radical de chaque mot : il faut le retenir par le génitif',
        'Ager est neutre, pas puer',
        'Ager est toujours au pluriel',
        'C\'est une règle générale à tous les mots en -er',
      ],
      reponseCorrecte:
          'C\'est propre au radical de chaque mot : il faut le retenir par le génitif',
    ),
    QuestionLecon(
      question: 'Quel est le nominatif pluriel de vir ?',
      options: ['vir', 'viri', 'virum', 'virorum'],
      reponseCorrecte: 'viri',
    ),
    QuestionLecon(
      question:
          'vir (l\'homme) se décline comme quel autre mot de cette leçon ?',
      options: ['dominus', 'bellum', 'puer', 'ager'],
      reponseCorrecte: 'puer',
    ),
    ExerciceSaisie(
      question:
          'Décline miser puer (le malheureux garçon) au génitif singulier.',
      reponsesAcceptees: ['miseri pueri'],
      indice: 'miser se décline comme puer : le radical garde son -e-.',
    ),
    ExerciceSaisie(
      question:
          'Décline pulcher ager (le beau champ) à l\'accusatif singulier.',
      reponsesAcceptees: ['pulchrum agrum'],
      indice:
          'pulcher et ager perdent tous les deux leur -e- hors du nominatif/vocatif.',
    ),
  ],
  fiche: (context) => Column(
    children: [
      tableauDeclinaison(declinaisons[1]),
      const SizedBox(height: 16),
      tableauDeclinaison(declinaisons[2]),
      const SizedBox(height: 16),
      tableauDeclinaison(declinaisons[9]),
      const SizedBox(height: 16),
      tableauDeclinaison(declinaisons[10]),
      const SizedBox(height: 16),
      tableauDeclinaison(declinaisons[11]),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : La phrase simple et la phrase complexe
// ------------------------------------------------------------

final Lecon _leconPhraseSimpleComplexe = Lecon(
  id: 'phrase_simple_complexe',
  titre: 'La phrase simple et complexe',
  sousTitre: 'Juxtaposition, coordination, subordination',
  icone: Icons.call_split,
  unite: 'Vol. I – Unité 2',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'La phrase est l\'unité maximale de l\'analyse grammaticale : elle '
      'commence par une majuscule et se termine par une ponctuation '
      'forte (. ! ?). Son pivot est le verbe : une phrase contient au '
      'moins un verbe conjugué, mais elle peut en comporter plusieurs. '
      'Chaque partie de la phrase qui contient un verbe conjugué '
      's\'appelle une proposition.',
    ),
    _titreExplication('La phrase simple'),
    _paragrapheExplication(
      'Une phrase simple ne contient qu\'un seul verbe conjugué : c\'est '
      'une proposition indépendante à elle seule.\n\n'
      'Ex. : Puella cantat. (La jeune fille chante.) → 1 phrase simple.',
    ),
    _titreExplication('La phrase complexe'),
    _paragrapheExplication(
      'Une phrase complexe contient au moins deux verbes conjugués, donc '
      'au moins deux propositions. Elles peuvent être reliées de trois '
      'façons :',
    ),
    _paragrapheExplication(
      '1. Par juxtaposition : les propositions sont simplement placées '
      'l\'une à côté de l\'autre, séparées par une virgule, un '
      'point-virgule ou deux-points, sans mot de liaison.\n'
      'Ex. : Puella cantat, puer ludit. (La jeune fille chante, le '
      'garçon joue.)',
    ),
    _paragrapheExplication(
      '2. Par coordination : les propositions sont reliées par une '
      'conjonction de coordination (mais, ou, et, donc, or, ni, car — en '
      'latin, notamment et, -que, nec/neque).\n'
      'Ex. : Dominus servum vocat et servus venit. (Le maître appelle '
      'l\'esclave et l\'esclave vient.)',
    ),
    _paragrapheExplication(
      '3. Par subordination : une proposition (la subordonnée) dépend '
      'd\'une autre (la principale) et ne peut pas exister seule, '
      'introduite par une conjonction de subordination (quand, parce '
      'que, puisque...). Tu apprendras les conjonctions de subordination '
      'latines plus tard dans ton apprentissage.',
    ),
    _titreExplication('Une curiosité : la scriptio continua'),
    _paragrapheExplication(
      'Dans l\'Antiquité, les Romains n\'utilisaient ni espace entre les '
      'mots ni ponctuation (à l\'exception du point) : c\'est la scriptio '
      'continua. C\'est en partie pour cela que le latin s\'appuie autant '
      'sur des mots de liaison (et, -que, nec, sed, nam...) pour '
      'structurer la phrase à l\'oral comme à l\'écrit.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'Combien de verbes conjugués (au minimum) contient une phrase complexe ?',
      options: ['0', '1', '2', '3'],
      reponseCorrecte: '2',
    ),
    QuestionLecon(
      question:
          'Comment appelle-t-on chaque partie d\'une phrase complexe, contenant un verbe conjugué ?',
      options: [
        'une proposition',
        'un cas',
        'une déclinaison',
        'une conjonction',
      ],
      reponseCorrecte: 'une proposition',
    ),
    QuestionLecon(
      question:
          '« Puella cantat, puer ludit. » : ces deux propositions sont reliées par...',
      options: ['juxtaposition', 'coordination', 'subordination', 'aucun lien'],
      reponseCorrecte: 'juxtaposition',
    ),
    QuestionLecon(
      question:
          '« Dominus servum vocat et servus venit. » : ces deux propositions sont reliées par...',
      options: ['juxtaposition', 'coordination', 'subordination', 'aucun lien'],
      reponseCorrecte: 'coordination',
    ),
    QuestionLecon(
      question:
          'Quel signe de ponctuation NE relie PAS des propositions par juxtaposition ?',
      options: [
        'le point d\'interrogation',
        'la virgule',
        'le point-virgule',
        'les deux-points',
      ],
      reponseCorrecte: 'le point d\'interrogation',
    ),
    QuestionLecon(
      question:
          'Comment appelle-t-on l\'écriture latine antique, sans espace entre les mots ni ponctuation ?',
      options: [
        'la scriptio continua',
        'l\'oratio recta',
        'la lingua latina',
        'le cursus honorum',
      ],
      reponseCorrecte: 'la scriptio continua',
    ),
    QuestionLecon(
      question:
          'Dans une phrase reliée par subordination, comment appelle-t-on la proposition qui ne peut pas exister seule ?',
      options: [
        'la subordonnée',
        'la principale',
        'l\'indépendante',
        'l\'apposition',
      ],
      reponseCorrecte: 'la subordonnée',
    ),
  ],
  fiche: (context) => _paragrapheExplication(
    'Phrase simple = 1 verbe conjugué = 1 proposition indépendante.\n\n'
    'Phrase complexe = 2 verbes conjugués (ou plus) = 2 propositions '
    '(ou plus), reliées par :\n'
    '1. juxtaposition ( , ; : sans mot de liaison)\n'
    '2. coordination (et, -que, nec/neque, sed, nam...)\n'
    '3. subordination (proposition principale + subordonnée)',
  ),
);

// ------------------------------------------------------------
// Leçon : Les conjonctions de coordination et, -que, neque
// ------------------------------------------------------------

final Lecon _leconConjonctions = Lecon(
  id: 'conj_et_que',
  titre: 'Les conjonctions et, -que, neque',
  sousTitre: 'Coordonner deux mots, groupes ou propositions',
  icone: Icons.link,
  unite: 'Vol. I – Unité 2',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Les conjonctions de coordination unissent des mots, des groupes '
      'de mots ou des propositions de même nature et de même fonction.',
    ),
    _titreExplication('L\'union sans négation : et / -que'),
    _paragrapheExplication(
      'et se place avant le second élément coordonné, comme en français.\n'
      'Ex. : dominus et filius (le maître et le fils).\n\n'
      '-que est enclitique : il se soude à la fin du premier mot de '
      'l\'élément qu\'il coordonne (jamais au premier élément de la '
      'phrase).\n'
      'Ex. : dominus filiusque (le maître et le fils).',
    ),
    _titreExplication('L\'union avec négation : neque / nec'),
    _paragrapheExplication(
      '« et ... ne ... pas » se dit toujours neque (ou nec) : l\'emploi '
      'de non après et ou -que est incorrect en latin. On trouve le plus '
      'souvent neque devant une voyelle, nec devant une consonne.\n'
      'Ex. : Dormit nec servos audit. (Il dort et n\'entend pas les '
      'esclaves.)\n\n'
      'nec/neque ... nec/neque ... signifie « ni ... ni ... ne ».\n'
      'Ex. : Nec dominus neque amicus venit. (Ni le maître ni l\'ami ne '
      'viennent.)',
    ),
    _titreExplication('Coordonner trois éléments ou plus'),
    _paragrapheExplication(
      'Dans une énumération de plusieurs termes (3 ou plus), on peut '
      'utiliser et ou -que :\n'
      '• et se répète devant chaque terme coordonné ;\n'
      '• -que se soude uniquement au dernier terme et ne se répète pas.\n'
      'Ex. : dominus et filius et servus = dominus, filius servusque '
      '(le maître, le fils et l\'esclave).',
    ),
    _titreExplication('Insistance : et... et...'),
    _paragrapheExplication(
      'Répété devant chaque terme coordonné, et marque une insistance : '
      '« à la fois... et... », « aussi bien... que... ».\n'
      'Ex. : Et dominus et servus... (À la fois le maître et l\'esclave...)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'Quelle conjonction de coordination latine « et » se soude au mot qu\'elle coordonne ?',
      options: ['et', '-que', 'sed', 'nam'],
      reponseCorrecte: '-que',
    ),
    QuestionLecon(
      question: '« Dominus filiusque » signifie...',
      options: [
        'Le maître et le fils',
        'Le maître du fils',
        'Ni le maître ni le fils',
        'Le maître, ou le fils',
      ],
      reponseCorrecte: 'Le maître et le fils',
    ),
    QuestionLecon(
      question: 'Comment dit-on toujours « et ... ne ... pas » en latin ?',
      options: ['et non', 'neque (nec)', '-que non', 'sed non'],
      reponseCorrecte: 'neque (nec)',
    ),
    QuestionLecon(
      question: 'Devant une consonne, on préfère en général...',
      options: ['neque', 'nec', 'et', '-que'],
      reponseCorrecte: 'nec',
    ),
    QuestionLecon(
      question: '« Nec dominus neque amicus venit » signifie...',
      options: [
        'Ni le maître ni l\'ami ne viennent',
        'Le maître et l\'ami viennent',
        'Le maître vient, mais pas l\'ami',
        'L\'ami du maître vient',
      ],
      reponseCorrecte: 'Ni le maître ni l\'ami ne viennent',
    ),
    QuestionLecon(
      question:
          'Dans une énumération de 3 termes ou plus reliés par -que, combien de fois -que apparaît-il ?',
      options: [
        'Une seule fois, sur le dernier terme',
        'Sur chaque terme',
        'Jamais, seulement et',
        'Sur le premier terme seulement',
      ],
      reponseCorrecte: 'Une seule fois, sur le dernier terme',
    ),
    QuestionLecon(
      question:
          'Que marque « et » répété devant chaque terme coordonné (et... et...) ?',
      options: [
        'une insistance',
        'une négation',
        'une question',
        'une subordination',
      ],
      reponseCorrecte: 'une insistance',
    ),
    ExerciceSaisie(
      question: 'Traduis « la jeune fille et le loup » en utilisant et.',
      reponsesAcceptees: ['puella et lupus'],
    ),
    ExerciceSaisie(
      question:
          'Traduis « la jeune fille et le loup » en utilisant -que (soudé au second mot).',
      reponsesAcceptees: ['puella lupusque'],
      indice: '-que se soude à la fin du mot qu\'il coordonne.',
    ),
    ExerciceSaisie(
      question: 'Traduis « ni la jeune fille ni le loup » avec nec ... nec.',
      reponsesAcceptees: ['nec puella nec lupus', 'neque puella neque lupus'],
    ),
  ],
  fiche: (context) => _paragrapheExplication(
    'et = et (devant le 2e élément)\n'
    '-que = et (soudé à la fin du 1er mot du 2e élément)\n'
    'neque / nec = et ... ne ... pas\n'
    'nec/neque ... nec/neque ... = ni ... ni ... ne\n'
    'et ... et ... = à la fois ... et ...\n'
    'Énumération ≥ 3 termes : et se répète ; -que ne se soude qu\'au dernier terme.',
  ),
);

// ------------------------------------------------------------
// Leçon : Les fonctions dans la phrase
// ------------------------------------------------------------

final Lecon _leconFonctionsPhrase = Lecon(
  id: 'fonctions_phrase',
  titre: 'Les fonctions dans la phrase',
  sousTitre: 'Sujet, COD, COI, CN, compléments circonstanciels...',
  icone: Icons.account_tree_outlined,
  explication: (context) => [
    _paragrapheExplication(
      'Avant de décliner un mot, il faut savoir quel rôle — quelle '
      'fonction — il joue dans la phrase. C\'est ce rôle qui déterminera '
      'plus tard son cas en latin.',
    ),
    _titreExplication('Les fonctions liées au verbe'),
    _paragrapheExplication(
      'Le verbe est le point de départ de l\'analyse : il exprime '
      'l\'action. Pour que la phrase ait un sens, il manque deux '
      'informations :\n\n'
      '• le sujet : qui fait l\'action ? Le sujet détermine la '
      'terminaison du verbe.\n'
      'Ex. : L\'ennemi tombe. / Les ennemis tombent. / Nous tombons.\n\n'
      '• l\'objet : sur qui ou sur quoi s\'applique l\'action ? '
      'L\'objet complète le verbe, il dépend de lui.',
    ),
    _paragrapheExplication(
      'Il existe deux types de compléments d\'objet :\n\n'
      '• le complément d\'objet direct (COD), rattaché directement au '
      'verbe (voir qqn / voir qqch) ;\n'
      '• le complément d\'objet indirect (COI), rattaché « indirectement » '
      'au verbe par les prépositions « à » ou « de » (penser à qqn / à '
      'qqch). En latin, on considère aussi la préposition « pour » : '
      '« pour qui », « dans l\'intérêt de qui » l\'action est faite.',
    ),
    _titreExplication('Cas particulier : l\'apostrophe'),
    _paragrapheExplication(
      'L\'apostrophe désigne la personne (ou la chose) à laquelle on '
      's\'adresse. On la trouve donc avec des verbes à l\'impératif ou à '
      'la 2e personne.\n\n'
      'Ex. : Marcus, écoute le maître ! / Venez, les enfants !',
    ),
    _titreExplication('Cas particulier : l\'attribut du sujet'),
    _paragrapheExplication(
      'Compare : « Publius chante une chanson » (une chanson = COD) et '
      '« Publius est chanteur » (chanteur = attribut du sujet).\n\n'
      'L\'attribut du sujet exprime une caractéristique du sujet. Il est '
      'rattaché au sujet par l\'intermédiaire du verbe « être » et de '
      'verbes comme « paraître, sembler, demeurer, rester, naître, '
      'vivre, devenir, mourir, tomber (amoureux, malade) ». Ces verbes '
      'sont appelés verbes attributifs.',
    ),
    _titreExplication('Une fonction liée au nom : le complément du nom (CN)'),
    _paragrapheExplication(
      'Ex. : Le livre de Pierre a disparu. → le livre de qui ? de Pierre.\n\n'
      'Le complément du nom « complète » un nom. Il se rattache le plus '
      'souvent au nom par la préposition « de ». Il marque principalement '
      'l\'appartenance.',
    ),
    _titreExplication(
      'Des fonctions « libres » : les compléments circonstanciels',
    ),
    _paragrapheExplication(
      'Ces fonctions indiquent les circonstances de l\'action :\n\n'
      '• CCT (temps) — quand ? Ex. : Tullia part le matin.\n'
      '• CCL (lieu) — où ? Ex. : Tullia reste à la maison.\n'
      '• CCM (manière) — comment ? Ex. : Quintus travaille bien.\n'
      '• CCC (cause) — pourquoi ? Ex. : Quintus pleure parce qu\'il a mal.\n'
      '• CC de moyen — avec quoi ? au moyen de quoi ? Le moyen est '
      'toujours un être inanimé (une chose), introduit par : au moyen '
      'de, de, grâce à, par, avec.',
    ),
    _titreExplication('Cas particulier : l\'apposition'),
    _paragrapheExplication(
      'Ex. : Rome, la capitale de l\'Italie, est une ville magnifique. '
      '→ Rome = la capitale (de l\'Italie).\n\n'
      'L\'apposition se rattache à un nom auquel elle apporte une '
      'information supplémentaire. L\'apposition et le nom indiquent la '
      'même réalité, et ont donc la même fonction — et en latin, le même '
      'cas.',
    ),
    _titreExplication('Fonction ↔ cas en latin'),
    _paragrapheExplication(
      'Chaque fonction correspond à un cas latin précis — retrouve ce '
      'tableau dans la fiche de cette leçon.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'Dans « Puella Romam amat » (La jeune fille aime Rome), quelle '
          'est la fonction de « puella » ?',
      options: ['Sujet', 'COD', 'COI', 'CN'],
      reponseCorrecte: 'Sujet',
    ),
    QuestionLecon(
      question:
          'Dans « Puella Romam amat » (La jeune fille aime Rome), quelle '
          'est la fonction de « Romam » ?',
      options: ['Sujet', 'COD', 'COI', 'Apostrophe'],
      reponseCorrecte: 'COD',
    ),
    QuestionLecon(
      question:
          'Dans « Puella deae fidem habet » (La jeune fille fait '
          'confiance à la déesse), quelle est la fonction de « deae » ?',
      options: ['COD', 'COI', 'CN', 'Attribut du sujet'],
      reponseCorrecte: 'COI',
    ),
    QuestionLecon(
      question:
          'Dans « Puellae patriae fama magna est » (La renommée de la '
          'patrie de la jeune fille est grande), quelle est la fonction '
          'de « puellae » ?',
      options: ['CN', 'COD', 'COI', 'Apostrophe'],
      reponseCorrecte: 'CN',
    ),
    QuestionLecon(
      question:
          'Dans « Puella, ambula ! » (Jeune fille, marche !), quelle est '
          'la fonction de « puella » ?',
      options: ['Sujet', 'Apostrophe', 'COD', 'Attribut du sujet'],
      reponseCorrecte: 'Apostrophe',
    ),
    QuestionLecon(
      question:
          'Dans « Puella laeta est » (La jeune fille est joyeuse), '
          'quelle est la fonction de « laeta » (joyeuse) ?',
      options: ['COD', 'CN', 'Attribut du sujet', 'Apostrophe'],
      reponseCorrecte: 'Attribut du sujet',
    ),
    QuestionLecon(
      question:
          'Dans « Vesta, dea bona, Romae flammam curat » (Vesta, bonne '
          'déesse, prend soin de la flamme à Rome), quelle est la '
          'fonction de « dea bona » ?',
      options: ['CN', 'Apposition', 'COI', 'Sujet'],
      reponseCorrecte: 'Apposition',
    ),
    QuestionLecon(
      question:
          'Quelle préposition latine peut, en plus de « à » et « de », '
          'introduire un complément d\'objet indirect (« pour qui ? ») ?',
      options: ['pour', 'avec', 'dans', 'par'],
      reponseCorrecte: 'pour',
    ),
  ],
  fiche: (context) => _tableauRolesCas([
    ['Nominatif', 'Sujet ou attribut du sujet', 'qui est-ce qui ?'],
    ['Vocatif', 'Apostrophe', 'ô ... !'],
    ['Accusatif', 'COD ou attribut du COD', 'qui ? quoi ?'],
    ['Génitif', 'Complément du nom (CN)', 'de qui ? de quoi ?'],
    ['Datif', 'COI (à, de, pour)', 'à qui ? à quoi ?'],
    ['Ablatif', 'CC de moyen ou de manière', 'par/avec/dans quoi ?'],
  ]),
);

// ------------------------------------------------------------
// Leçon : Le verbe être (esse)
// ------------------------------------------------------------

final Lecon _leconVerbeEtre = Lecon(
  id: 'verbe_etre',
  titre: 'Le verbe être : sum, es, est...',
  sousTitre: 'Indicatif et infinitif présents, emplois de esse',
  icone: Icons.psychology_outlined,
  explication: (context) => [
    _titreExplication('Le sujet du verbe'),
    _paragrapheExplication(
      'Sauf pour insister, le latin ne connaît pas de pronom personnel '
      'sujet, puisque les terminaisons -o/m, -s, -t, -mus, -tis, -nt '
      'renseignent déjà sur la personne.\n\n'
      'Ex. : Cogito, ergo sum. → Je pense, donc je suis.\n'
      'Boni discipuli estis. → Vous êtes de bons élèves.\n\n'
      'MAIS, pour insister :\n'
      'Ego in Italiā fui. → Moi, j\'ai été en Italie.\n'
      'Vos bene laboratis. → Vous, vous travaillez bien.',
    ),
    _titreExplication('Indicatif et infinitif présents de esse'),
    _paragrapheExplication(
      'sum, es, est, sumus, estis, sunt — je suis, tu es, il/elle est, '
      'nous sommes, vous êtes, ils/elles sont.\n\n'
      'Infinitif présent : esse (« être »).\n\n'
      'Dans le lexique, esse se présente sous cette forme, avec ses '
      'temps primitifs : sum, es, esse, fui, – « être ».',
    ),
    _titreExplication('Les emplois de esse'),
    _paragrapheExplication(
      '1. En général, le verbe esse est accompagné d\'un attribut du '
      'sujet et se traduit par « être ».\n'
      'Ex. : Puella est pulchra. (La jeune fille est belle.)\n'
      'Gallia est magna. (La Gaule est grande.)\n'
      'Vesta dea est. (Vesta est une déesse.)',
    ),
    _paragrapheExplication(
      '2. « est » ou « sunt » employés SANS attribut et placés DEVANT '
      'le sujet se traduisent par « il y a » (ALL. Es gibt ; ANGL. '
      'there is/are).\n'
      'Ex. : Est puella in silvā. (Il y a une jeune fille dans la '
      'forêt.) ≠ Puella in silvā est. (La jeune fille est dans la '
      'forêt.)\n'
      'Sunt puellae in Galliā. (Il y a des jeunes filles en Gaule.) ≠ '
      'Puellae in Galliā sunt. (Les jeunes filles sont en Gaule.)',
    ),
  ],
  exercices: const [
    ExerciceSaisie(
      question: 'Comment dit-on « je suis » en latin ?',
      reponsesAcceptees: ['sum'],
    ),
    ExerciceSaisie(
      question: 'Comment dit-on « tu es » en latin ?',
      reponsesAcceptees: ['es'],
    ),
    ExerciceSaisie(
      question: 'Comment dit-on « vous êtes » en latin ?',
      reponsesAcceptees: ['estis'],
    ),
    ExerciceSaisie(
      question:
          'Quelle est la 3e personne du pluriel de esse au présent '
          '(« ils/elles sont ») ?',
      reponsesAcceptees: ['sunt'],
    ),
    QuestionLecon(
      question: 'Que signifie « Copiae Gallicae bonae sunt » ?',
      options: [
        'Les troupes gauloises sont bonnes.',
        'Il y a de bonnes troupes gauloises.',
        'Les Gaulois ont de bonnes troupes.',
        'Les troupes sont en Gaule.',
      ],
      reponseCorrecte: 'Les troupes gauloises sont bonnes.',
    ),
    QuestionLecon(
      question: 'Que signifie « Sunt bonae copiae in Galliā » ?',
      options: [
        'Les troupes sont bonnes en Gaule.',
        'Il y a de bonnes troupes en Gaule.',
        'Les bonnes troupes sont gauloises.',
        'La Gaule a de bonnes troupes.',
      ],
      reponseCorrecte: 'Il y a de bonnes troupes en Gaule.',
    ),
    QuestionLecon(
      question: 'Que signifie « Puellae tunica nova est » ?',
      options: [
        'La tunique de la jeune fille est neuve.',
        'Il y a une nouvelle tunique pour la jeune fille.',
        'La jeune fille a une tunique.',
        'La jeune fille est nouvelle.',
      ],
      reponseCorrecte: 'La tunique de la jeune fille est neuve.',
    ),
    QuestionLecon(
      question: 'Que signifie « Est nova fama de copiis Romanis » ?',
      options: [
        'La renommée des troupes romaines est nouvelle.',
        'Il y a une nouvelle rumeur au sujet des troupes romaines.',
        'Les troupes romaines sont nouvelles.',
        'La renommée romaine est ancienne.',
      ],
      reponseCorrecte:
          'Il y a une nouvelle rumeur au sujet des troupes romaines.',
    ),
    QuestionLecon(
      question:
          'Quand « est » ou « sunt » sont placés devant le sujet, sans '
          'attribut, comment les traduit-on généralement ?',
      options: ['être', 'avoir', 'il y a', 'devenir'],
      reponseCorrecte: 'il y a',
    ),
    QuestionLecon(
      question: 'Dans « Puella est pulchra », quel est l\'emploi de « est » ?',
      options: [
        'Il y a (sans attribut)',
        'Avec un attribut du sujet (« être »)',
        'Verbe attributif seul',
        'Apostrophe',
      ],
      reponseCorrecte: 'Avec un attribut du sujet (« être »)',
    ),
    QuestionLecon(
      question:
          'Pourquoi le latin n\'utilise-t-il presque jamais de pronom '
          'personnel sujet (je, tu, il...) ?',
      options: [
        'Parce que la terminaison du verbe indique déjà la personne',
        'Parce que le latin n\'a pas de pronoms',
        'Parce que c\'est toujours sous-entendu par le contexte',
        'Parce que le sujet est toujours au génitif',
      ],
      reponseCorrecte:
          'Parce que la terminaison du verbe indique déjà la personne',
    ),
    QuestionLecon(
      question:
          'Dans « Ego in Italiā fui », pourquoi le pronom « Ego » (moi) '
          'est-il exprimé alors que ce n\'est en général pas nécessaire ?',
      options: [
        'Pour insister',
        'Parce que c\'est une question',
        'Parce que le verbe est à l\'infinitif',
        'Par erreur',
      ],
      reponseCorrecte: 'Pour insister',
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _titreExplication('Indicatif présent de esse'),
      Table(
        border: TableBorder.all(color: texteAttenue.withValues(alpha: 0.3)),
        columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1.4)},
        children: const [
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'sum',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(padding: EdgeInsets.all(6), child: Text('je suis')),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'es',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(padding: EdgeInsets.all(6), child: Text('tu es')),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'est',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(padding: EdgeInsets.all(6), child: Text('il / elle est')),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'sumus',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(padding: EdgeInsets.all(6), child: Text('nous sommes')),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'estis',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(padding: EdgeInsets.all(6), child: Text('vous êtes')),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  'sunt',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(6),
                child: Text('ils / elles sont'),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Infinitif présent : esse (« être »).\n'
        'Temps primitifs (lexique) : sum, es, esse, fui.',
      ),
      _paragrapheExplication(
        '2 emplois de esse :\n\n'
        '• avec un attribut du sujet → « être » (Puella est pulchra).\n\n'
        '• est/sunt seuls, placés avant le sujet, sans attribut → '
        '« il y a » (Est puella in silvā = Il y a une jeune fille dans '
        'la forêt).',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : La place des mots dans la phrase latine
// ------------------------------------------------------------

final Lecon _leconOrdreMots = Lecon(
  id: 'ordre_mots',
  titre: 'La place des mots dans la phrase latine',
  sousTitre: 'Un ordre libre, mais pas anarchique',
  icone: Icons.swap_horiz,
  explication: (context) => [
    _paragrapheExplication(
      'L\'ordre des mots en latin est libre, dans des limites bien '
      'définies. En effet, le latin regroupe souvent les mots ayant un '
      'lien grammatical et logique. Voici les regroupements les plus '
      'usuels :',
    ),
    _paragrapheExplication(
      '1. le sujet en tête de proposition\n'
      'Ex. : Ledona in Galliā est.\n\n'
      '2. l\'adjectif épithète devant le nom auquel il se rapporte\n'
      'Ex. : pulchra patria.\n'
      'Exceptions : les déterminants (ou adjectifs) possessifs '
      '(patria mea) ; les adjectifs qualificatifs formés sur des noms '
      'propres (puella Gallica ; senatus populusque Romanus, SPQR).\n\n'
      '3. le complément du nom (CN) — devant le nom auquel il se '
      'rapporte, ou entre l\'adjectif épithète et le nom\n'
      'Ex. : puellae patria ; pulchra puellae patria.\n\n'
      '4. la préposition devant le nom\n'
      'Ex. : in Galliā.\n\n'
      '5. le verbe à la fin de la proposition\n'
      'Ex. : in Galliā est.\n\n'
      '6. l\'apposition derrière le nom auquel elle se rapporte\n'
      'Ex. : Gallia, pulchra patria.',
    ),
    _paragrapheExplication(
      'En combinant toutes ces règles :\n'
      'Ledona in Galliā, pulchrā puellae patriā, est.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Où se place généralement le sujet dans une phrase latine ?',
      options: [
        'En tête de la proposition',
        'À la fin',
        'Juste après le verbe',
        'N\'importe où, sans règle',
      ],
      reponseCorrecte: 'En tête de la proposition',
    ),
    QuestionLecon(
      question:
          'Où se place l\'adjectif épithète par rapport au nom qu\'il '
          'qualifie ?',
      options: [
        'Devant le nom',
        'Derrière le nom',
        'Toujours après le verbe',
        'Toujours au génitif',
      ],
      reponseCorrecte: 'Devant le nom',
    ),
    QuestionLecon(
      question:
          'Quelle est l\'exception à cette règle pour les déterminants '
          'possessifs (mon, ta, son...) ?',
      options: [
        'Ils se placent derrière le nom',
        'Ils se placent devant le verbe',
        'Ils n\'existent pas en latin',
        'Ils précèdent toujours l\'adjectif',
      ],
      reponseCorrecte: 'Ils se placent derrière le nom',
    ),
    QuestionLecon(
      question: 'Où se place le verbe dans une proposition latine classique ?',
      options: [
        'À la fin',
        'En tête',
        'Juste après le sujet',
        'Avant la préposition',
      ],
      reponseCorrecte: 'À la fin',
    ),
    QuestionLecon(
      question:
          'Où se place la préposition par rapport au nom qu\'elle introduit ?',
      options: [
        'Devant le nom',
        'Derrière le nom',
        'Entre l\'adjectif et le nom',
        'À la fin de la phrase',
      ],
      reponseCorrecte: 'Devant le nom',
    ),
    QuestionLecon(
      question:
          'Où se place l\'apposition par rapport au nom auquel elle se '
          'rapporte ?',
      options: [
        'Derrière ce nom',
        'Devant ce nom',
        'En tête de phrase',
        'Elle n\'a pas de place fixe',
      ],
      reponseCorrecte: 'Derrière ce nom',
    ),
    QuestionLecon(
      question:
          'Dans « pulchra puellae patria » (la belle patrie de la jeune '
          'fille), où se situe le complément du nom « puellae » ?',
      options: [
        'Entre l\'adjectif épithète et le nom',
        'Après le nom',
        'En tête de la phrase',
        'Avant l\'adjectif',
      ],
      reponseCorrecte: 'Entre l\'adjectif épithète et le nom',
    ),
  ],
  fiche: (context) => _tableauRolesCas([
    ['1', 'Sujet', 'en tête de proposition'],
    ['2', 'Adjectif épithète', 'devant le nom'],
    ['3', 'Complément du nom', 'devant le nom, ou entre l\'épithète et le nom'],
    ['4', 'Préposition', 'devant le nom'],
    ['5', 'Verbe', 'à la fin de la proposition'],
    ['6', 'Apposition', 'derrière le nom'],
  ]),
);

// ------------------------------------------------------------
// Leçon : Comment analyser une phrase pour la traduire
// ------------------------------------------------------------

final Lecon _leconMethodeAnalyse = Lecon(
  id: 'methode_analyse',
  titre: 'Comment analyser une phrase pour la traduire',
  sousTitre: 'La méthode, étape par étape',
  icone: Icons.checklist,
  explication: (context) => [
    _paragrapheExplication(
      'Tu connais maintenant les fonctions, les cas et l\'ordre des mots. '
      'Voici comment t\'en servir, dans l\'ordre, pour analyser puis '
      'traduire n\'importe quelle phrase latine.',
    ),
    _titreExplication('1. Repérer le verbe'),
    _paragrapheExplication(
      'Le verbe est souvent à la fin de la proposition. Sa terminaison '
      'indique la personne et le nombre (donc, souvent, le sujet — même '
      'sans pronom exprimé).',
    ),
    _titreExplication('2. Chercher le sujet'),
    _paragrapheExplication(
      'Cherche un nominatif qui s\'accorde avec le verbe. S\'il n\'y en a '
      'pas, le sujet est sous-entendu dans la terminaison du verbe '
      '(« il/elle », « ils/elles »).',
    ),
    _titreExplication('3. Chercher les compléments d\'objet'),
    _paragrapheExplication(
      'Un accusatif sans préposition est souvent un COD. Un datif, ou un '
      'accusatif/ablatif avec préposition, est souvent un COI ou un CC.',
    ),
    _titreExplication('4. Chercher le complément du nom'),
    _paragrapheExplication(
      'Un génitif se rattache toujours à un nom (jamais au verbe) : '
      'cherche de quel nom il dépend.',
    ),
    _titreExplication('5. Chercher les compléments circonstanciels'),
    _paragrapheExplication(
      'Un ablatif seul (moyen, manière) ou avec préposition (lieu, '
      'temps...), ou un accusatif avec préposition de direction : ce '
      'sont des CC.',
    ),
    _titreExplication('6. Vérifier les cas particuliers'),
    _paragrapheExplication(
      'Un vocatif ? C\'est une apostrophe. Un nom au nominatif après '
      '« être » ou un verbe attributif ? C\'est un attribut du sujet. '
      'Un nom qui renomme un autre nom, au même cas ? C\'est une '
      'apposition.',
    ),
    _titreExplication('7. Traduire dans l\'ordre naturel'),
    _paragrapheExplication(
      'Traduis chaque groupe, puis reconstruis la phrase en français '
      'dans l\'ordre sujet - verbe - compléments : ne traduis jamais '
      'mot à mot dans l\'ordre latin !',
    ),
    _titreExplication('Exemple complet'),
    _paragrapheExplication(
      '« Puella cum familiā in Arduennā silvā habitat. »\n\n'
      '1. Verbe : habitat (elle habite, 3e pers. sg.)\n'
      '2. Sujet : puella (nominatif) — la jeune fille\n'
      '3-4. Pas de COD ni de CN ici.\n'
      '5. CC de lieu : « cum familiā » (avec sa famille), '
      '« in Arduennā silvā » (dans la forêt des Ardennes)\n\n'
      '→ Traduction naturelle : « La jeune fille habite avec sa famille '
      'dans la forêt des Ardennes. »',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'Quelle est la toute première étape de l\'analyse d\'une phrase '
          'latine ?',
      options: [
        'Repérer le verbe',
        'Traduire le premier mot',
        'Chercher le complément du nom',
        'Compter les syllabes',
      ],
      reponseCorrecte: 'Repérer le verbe',
    ),
    QuestionLecon(
      question:
          'Si aucun nominatif n\'apparaît dans la phrase, comment '
          'connaît-on quand même le sujet ?',
      options: [
        'Grâce à la terminaison du verbe',
        'Le sujet est toujours « Roma »',
        'On ne peut pas le savoir',
        'Il faut regarder le génitif',
      ],
      reponseCorrecte: 'Grâce à la terminaison du verbe',
    ),
    QuestionLecon(
      question: 'À quel nom un génitif se rattache-t-il toujours ?',
      options: [
        'À un autre nom, jamais au verbe',
        'Toujours au verbe',
        'Toujours au sujet',
        'À rien, il est libre',
      ],
      reponseCorrecte: 'À un autre nom, jamais au verbe',
    ),
    QuestionLecon(
      question:
          'Dans « Puella cum familiā in Arduennā silvā habitat », quel '
          'est le verbe ?',
      options: ['habitat', 'puella', 'familiā', 'silvā'],
      reponseCorrecte: 'habitat',
    ),
    QuestionLecon(
      question:
          'Dans la même phrase, quelle est la fonction de « in Arduennā '
          'silvā » ?',
      options: ['CC de lieu', 'COD', 'Sujet', 'Complément du nom'],
      reponseCorrecte: 'CC de lieu',
    ),
    QuestionLecon(
      question:
          'Un nom au nominatif juste après le verbe « être » : de quelle '
          'fonction particulière s\'agit-il ?',
      options: ['Attribut du sujet', 'Apostrophe', 'Apposition', 'COD'],
      reponseCorrecte: 'Attribut du sujet',
    ),
    QuestionLecon(
      question:
          'Une fois chaque groupe traduit, dans quel ordre reconstruit-on '
          'la phrase en français ?',
      options: [
        'Sujet - verbe - compléments',
        'Exactement l\'ordre latin, mot à mot',
        'Toujours en commençant par le verbe',
        'Dans l\'ordre alphabétique',
      ],
      reponseCorrecte: 'Sujet - verbe - compléments',
    ),
    QuestionLecon(
      question:
          'Un nom qui en renomme un autre, au même cas que lui : quelle '
          'est cette fonction ?',
      options: ['Apposition', 'CN', 'COI', 'CC de moyen'],
      reponseCorrecte: 'Apposition',
    ),
  ],
  fiche: (context) => _paragrapheExplication(
    '1. Verbe (souvent à la fin)\n'
    '2. Sujet (nominatif, ou sous-entendu dans le verbe)\n'
    '3. COD / COI (accusatif seul / datif ou préposition)\n'
    '4. Complément du nom (génitif, rattaché à un nom)\n'
    '5. Compléments circonstanciels (ablatif ou préposition)\n'
    '6. Cas particuliers (vocatif = apostrophe, attribut, apposition)\n'
    '7. Traduire chaque groupe puis reconstruire en français dans '
    'l\'ordre sujet - verbe - compléments.',
  ),
);

// ------------------------------------------------------------
// Leçon : Les noms neutres de la 2e déclinaison
// ------------------------------------------------------------

final Lecon _leconNeutre2eDecl = Lecon(
  id: 'neutre_2e_decl',
  titre: 'Les noms neutres de la 2e déclinaison',
  sousTitre: 'oppidum / bellum — le troisième genre',
  icone: Icons.crop_square,
  unite: 'Vol. I – Unité 3',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Le latin possède 3 genres : masculin, féminin et neutre.\n\n'
      'Il n\'y a pas de noms neutres à la 1re déclinaison : ils sont '
      'féminins (puella, ae, f.) et parfois masculins (nauta, ae, m. — '
      'le marin).\n\n'
      'Les noms de la 2e déclinaison, eux, sont masculins (lupus, i, m.) '
      'ou neutres (oppidum, i, n. — la place forte). Quelques-uns sont '
      'féminins (Aegyptus, i, f.).',
    ),
    _titreExplication('La règle des neutres'),
    _paragrapheExplication(
      'Pour les noms neutres de la 2e déclinaison, la terminaison est '
      '-um au singulier et -a au pluriel.\n\n'
      'Règle valable pour TOUS les neutres, à toutes les déclinaisons : '
      'le nominatif, le vocatif et l\'accusatif ont toujours la même '
      'forme. Aux autres cas (génitif, datif, ablatif), les neutres se '
      'déclinent exactement comme lupus.',
    ),
    _titreExplication('oppidum, i, n. (= bellum, i, n.)'),
    tableauDeclinaison(declinaisons[2]),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Combien de genres le latin possède-t-il ?',
      options: ['2', '3', '4', '5'],
      reponseCorrecte: '3',
    ),
    QuestionLecon(
      question: 'La 1re déclinaison comprend-elle des noms neutres ?',
      options: [
        'Non, jamais',
        'Oui, tous les noms en -a sont neutres',
        'Oui, mais seulement au pluriel',
        'Oui, la moitié d\'entre eux',
      ],
      reponseCorrecte: 'Non, jamais',
    ),
    QuestionLecon(
      question:
          'Quelle est la terminaison des neutres de la 2e déclinaison au singulier ?',
      options: ['-us', '-um', '-a', '-i'],
      reponseCorrecte: '-um',
    ),
    QuestionLecon(
      question:
          'Quelle est la terminaison des neutres de la 2e déclinaison au pluriel ?',
      options: ['-us', '-um', '-a', '-orum'],
      reponseCorrecte: '-a',
    ),
    QuestionLecon(
      question:
          'Pour TOUS les neutres (à toutes les déclinaisons), quels cas ont toujours la même forme ?',
      options: [
        'Nominatif, vocatif, accusatif',
        'Génitif, datif, ablatif',
        'Nominatif et génitif seulement',
        'Tous les cas sont différents',
      ],
      reponseCorrecte: 'Nominatif, vocatif, accusatif',
    ),
    QuestionLecon(
      question: 'Quel est le génitif singulier de oppidum ?',
      options: ['oppidum', 'oppidi', 'oppido', 'oppida'],
      reponseCorrecte: 'oppidi',
    ),
    QuestionLecon(
      question: 'Quel est le nominatif pluriel de oppidum ?',
      options: ['oppidum', 'oppidi', 'oppida', 'oppidorum'],
      reponseCorrecte: 'oppida',
    ),
    ExerciceSaisie(
      question: 'Décline templum (le temple, neutre) à l\'accusatif pluriel.',
      reponsesAcceptees: ['templa'],
      indice: 'Neutre : nom./voc./acc. pluriel se terminent toujours en -a.',
    ),
    ExerciceSaisie(
      question: 'Décline bellum au datif singulier.',
      reponsesAcceptees: ['bello'],
      indice: 'Aux autres cas, les neutres se déclinent comme lupus.',
    ),
  ],
  fiche: (context) => tableauDeclinaison(declinaisons[2]),
);

// ------------------------------------------------------------
// Leçon : Les adjectifs de la 1re classe
// ------------------------------------------------------------

final Lecon _leconAdjectifs1reClasse = Lecon(
  id: 'adj_1re_classe',
  titre: 'Les adjectifs de la 1re classe',
  sousTitre: 'bonus, bona, bonum — et les adjectifs substantivés',
  icone: Icons.style,
  unite: 'Vol. I – Unité 3',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'L\'adjectif latin s\'accorde en genre, en nombre et en cas avec '
      'le nom auquel il se rapporte. Comme en français, il peut être :\n\n'
      '• épithète : Bonus puer adest. (Le bon garçon est là.)\n'
      '• attribut : Puer bonus est. (Le garçon est bon.)',
    ),
    _titreExplication('Trois déclinaisons pour un seul adjectif'),
    _paragrapheExplication(
      'Les adjectifs de la 1re classe suivent, au masculin et au neutre, '
      'la déclinaison des noms de la 2e déclinaison (lupus, i, m. et '
      'oppidum, i, n.), et au féminin, celle de la 1re déclinaison '
      '(puella, ae, f.) :\n\n'
      'masculin : bon-us → se décline comme lupus\n'
      'féminin : bon-a → se décline comme puella\n'
      'neutre : bon-um → se décline comme oppidum',
    ),
    _paragrapheExplication(
      'Le radical de l\'adjectif s\'obtient en enlevant la terminaison '
      '-a au nominatif féminin singulier.\n\n'
      'bonus, bona, bonum → radical bon-\n'
      'pulcher, pulchra, pulchrum → radical pulchr-\n'
      'miser, misera, miserum → radical miser-',
    ),
    _titreExplication('L\'adjectif substantivé'),
    _paragrapheExplication(
      'Lorsqu\'un adjectif est employé seul, sans nom qu\'il accompagne, '
      'on dit qu\'il est substantivé : il a alors la valeur d\'un nom, '
      'masculin, féminin ou neutre.',
    ),
    _paragrapheExplication(
      'Les emplois les plus fréquents :\n\n'
      'bonus = un homme bon · boni = les gens de bien\n'
      'multi = beaucoup de gens · multae = beaucoup de femmes\n'
      'propinqui = les proches parents · nostri = les nôtres\n\n'
      'Au neutre :\n'
      'bonum = le bien · bona = les biens\n'
      'malum = le mal · mala = les maux\n'
      'multa = beaucoup (de choses) · cuncta = toutes les choses',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'Au masculin, un adjectif de la 1re classe (comme bonus) se décline comme...',
      options: ['puella', 'lupus', 'oppidum', 'dominus et puella à la fois'],
      reponseCorrecte: 'lupus',
    ),
    QuestionLecon(
      question:
          'Au féminin, un adjectif de la 1re classe (comme bona) se décline comme...',
      options: ['puella', 'lupus', 'oppidum', 'vir'],
      reponseCorrecte: 'puella',
    ),
    QuestionLecon(
      question:
          'Au neutre, un adjectif de la 1re classe (comme bonum) se décline comme...',
      options: ['puella', 'lupus', 'oppidum', 'ager'],
      reponseCorrecte: 'oppidum',
    ),
    QuestionLecon(
      question:
          'Comment obtient-on le radical d\'un adjectif de la 1re classe ?',
      options: [
        'En enlevant -a au nominatif féminin singulier',
        'En enlevant -us au nominatif masculin singulier',
        'En enlevant -um au nominatif neutre',
        'En gardant le mot tel quel',
      ],
      reponseCorrecte: 'En enlevant -a au nominatif féminin singulier',
    ),
    QuestionLecon(
      question: 'Qu\'appelle-t-on un adjectif « substantivé » ?',
      options: [
        'Un adjectif employé seul, avec la valeur d\'un nom',
        'Un adjectif toujours au pluriel',
        'Un adjectif qui n\'a pas de féminin',
        'Un adjectif emprunté au grec',
      ],
      reponseCorrecte: 'Un adjectif employé seul, avec la valeur d\'un nom',
    ),
    QuestionLecon(
      question: 'Que signifie « boni » (adjectif substantivé) ?',
      options: ['les gens de bien', 'le bien', 'les biens', 'un homme bon'],
      reponseCorrecte: 'les gens de bien',
    ),
    QuestionLecon(
      question:
          'Que signifie « bona » (adjectif substantivé, neutre pluriel) ?',
      options: [
        'les biens',
        'une bonne chose',
        'les gens de bien',
        'beaucoup de femmes',
      ],
      reponseCorrecte: 'les biens',
    ),
    QuestionLecon(
      question: 'Que signifie « multi » (adjectif substantivé) ?',
      options: [
        'beaucoup de gens',
        'beaucoup de choses',
        'les proches parents',
        'les nôtres',
      ],
      reponseCorrecte: 'beaucoup de gens',
    ),
    ExerciceSaisie(
      question:
          'Décline « pulchra puella » (la belle jeune fille) à l\'accusatif pluriel.',
      reponsesAcceptees: ['pulchras puellas'],
      indice: 'pulchra suit puella, donc la 1re déclinaison.',
    ),
    ExerciceSaisie(
      question:
          'Décline « magnum oppidum » (la grande place forte) au génitif singulier.',
      reponsesAcceptees: ['magni oppidi'],
    ),
  ],
  fiche: (context) => _paragrapheExplication(
    'masculin (-us) → décline comme lupus\n'
    'féminin (-a) → décline comme puella\n'
    'neutre (-um) → décline comme oppidum\n\n'
    'Radical = nominatif féminin singulier moins -a.\n\n'
    'Adjectifs substantivés fréquents :\n'
    'boni (les gens de bien) · bona (les biens)\n'
    'mali (les méchants) · mala (les maux)\n'
    'multi (beaucoup de gens) · multa (beaucoup de choses)\n'
    'nostri (les nôtres) · propinqui (les proches parents)',
  ),
);

// ------------------------------------------------------------
// Leçon : Le verbe latin
// ------------------------------------------------------------

final Lecon _leconVerbeLatin = Lecon(
  id: 'verbe_latin',
  titre: 'Le verbe latin',
  sousTitre: 'Temps primitifs, 5 conjugaisons, indicatif présent',
  icone: Icons.play_circle_outline,
  unite: 'Vol. I – Unité 3',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('Les temps primitifs'),
    _paragrapheExplication(
      'Les verbes latins se présentent avec 5 formes, appelées temps '
      'primitifs : amo, as, are, avi, atum « aimer ». Elles indiquent '
      'les trois radicaux nécessaires pour former tous les modes et '
      'tous les temps du latin :\n\n'
      '• amo, as, are → le radical du présent (ou infectum) : ama-\n'
      '• amavi → le radical du passé (ou perfectum) : amav-\n'
      '• amatum → le radical du supin : amat-',
    ),
    _paragrapheExplication(
      'Certains verbes, dont « être » et ses composés, n\'ont pas de '
      'supin : sum, es, esse, fui, Ø.',
    ),
    _titreExplication('Les 5 modèles de conjugaison'),
    _paragrapheExplication(
      'conjugaisons — verbes en — modèles\n\n'
      '1re — -o, -as, -are — amo, as, are, avi, atum « aimer »\n'
      '2e — -eo, -es, -ere — moneo, es, ere, monui, monitum « avertir »\n'
      '3e — -o, -is, -ere — mitto, is, ere, misi, missum « envoyer »\n'
      '4e — -io, -is, -ere — capio, is, ere, cepi, captum « prendre »\n'
      '5e — -io, -is, -ire — audio, is, ire, audivi, auditum « écouter »',
    ),
    _paragrapheExplication(
      'Aux 1re, 2e et 5e conjugaisons, le radical se termine par une '
      'voyelle longue et stable (amā-, monē-, audī- — il suffit '
      'd\'enlever -re à l\'infinitif).\n\n'
      'Aux 3e et 4e conjugaisons, en -ĕre, le radical de la 3e se '
      'termine par une consonne (mitt-), celui de la 4e par la voyelle '
      '-i (capi-).',
    ),
    _titreExplication('L\'indicatif présent'),
    _paragrapheExplication(
      'Comme en français, l\'indicatif présent énonce un fait ou une '
      'action du présent, ou un fait général / une vérité générale.\n\n'
      'Sauf pour insister, le latin ne connaît pas de pronom personnel '
      'sujet (je, tu, il...), puisque les terminaisons -o/m, -s, -t, '
      '-mus, -tis, -nt renseignent déjà sur la personne.',
    ),
    for (final conj in conjugaisons) ...[
      tableauConjugaison(conj),
      const SizedBox(height: 12),
    ],
  ],
  exercices: const [
    QuestionLecon(
      question:
          'Combien de temps primitifs présente un verbe latin comme amo, as, are, avi, atum ?',
      options: ['3', '4', '5', '6'],
      reponseCorrecte: '5',
    ),
    QuestionLecon(
      question: 'Que donne le radical du présent (amo, as, are) ?',
      options: ['ama-', 'amav-', 'amat-', 'am-'],
      reponseCorrecte: 'ama-',
    ),
    QuestionLecon(
      question: 'Quel verbe très courant n\'a pas de supin ?',
      options: ['amo', 'sum', 'audio', 'mitto'],
      reponseCorrecte: 'sum',
    ),
    QuestionLecon(
      question:
          'À quelle conjugaison appartient un verbe en -o, -is, -ere comme mitto ?',
      options: ['1re', '2e', '3e', '4e'],
      reponseCorrecte: '3e',
    ),
    QuestionLecon(
      question:
          'À quelle conjugaison appartient un verbe en -io, -is, -ire comme audio ?',
      options: ['2e', '3e', '4e', '5e'],
      reponseCorrecte: '5e',
    ),
    QuestionLecon(
      question:
          'Quelle terminaison de l\'indicatif présent correspond à « nous » ?',
      options: ['-t', '-mus', '-tis', '-nt'],
      reponseCorrecte: '-mus',
    ),
    QuestionLecon(
      question:
          'Pourquoi le latin utilise-t-il rarement un pronom sujet (je, tu...) ?',
      options: [
        'Les terminaisons du verbe indiquent déjà la personne',
        'Le latin n\'a pas de pronoms',
        'C\'est une règle sans raison particulière',
        'Seuls les verbes à l\'impératif en ont besoin',
      ],
      reponseCorrecte: 'Les terminaisons du verbe indiquent déjà la personne',
    ),
    QuestionLecon(
      question: 'Quelle est la forme de « nous envoyons » (mittere) ?',
      options: ['mittimus', 'mittitis', 'mittunt', 'mittimur'],
      reponseCorrecte: 'mittimus',
    ),
    QuestionLecon(
      question: 'Quelle est la forme de « ils prennent » (capere) ?',
      options: ['capiunt', 'capitis', 'capimus', 'capiet'],
      reponseCorrecte: 'capiunt',
    ),
    ExerciceSaisie(
      question:
          'Conjugue amare à la 2e personne du singulier de l\'indicatif présent (tu aimes).',
      reponsesAcceptees: ['amas'],
    ),
    ExerciceSaisie(
      question:
          'Conjugue audire à la 3e personne du pluriel de l\'indicatif présent (ils écoutent).',
      reponsesAcceptees: ['audiunt'],
    ),
  ],
  fiche: (context) => Column(
    children: [
      for (final conj in conjugaisons) ...[
        tableauConjugaison(conj),
        const SizedBox(height: 12),
      ],
    ],
  ),
);

// ------------------------------------------------------------
// Tableau générique à colonnes multiples (composés de esse,
// particules interrogatives...)
// ------------------------------------------------------------

Widget _tableauColonnes(List<String> entetes, List<List<String>> lignes) {
  return Table(
    border: TableBorder.all(color: texteAttenue.withValues(alpha: 0.3)),
    columnWidths: {
      for (var i = 0; i < entetes.length; i++)
        i: FlexColumnWidth(i == 0 ? 0.8 : 1),
    },
    children: [
      TableRow(
        children: [
          for (final entete in entetes)
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                entete,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      for (final ligne in lignes)
        TableRow(
          children: [
            for (final cellule in ligne)
              Padding(padding: const EdgeInsets.all(6), child: Text(cellule)),
          ],
        ),
    ],
  );
}

// ------------------------------------------------------------
// Leçon : Le verbe esse et ses composés
// ------------------------------------------------------------

final Lecon _leconEsseComposes = Lecon(
  id: 'esse_composes',
  titre: 'Le verbe esse et ses composés',
  sousTitre: 'absum, adsum, praesum, possum...',
  icone: Icons.merge_type,
  unite: 'Vol. I – Unité 4',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Le verbe être apparaît dans de nombreux composés en latin. Pour '
      'connaître la morphologie de ces composés, il est indispensable '
      'de bien connaître la conjugaison de esse : sum, es, est, sumus, '
      'estis, sunt.',
    ),
    _titreExplication('Des prépositions qui deviennent préverbes'),
    _paragrapheExplication(
      'a(b) + abl. = « loin de »\n'
      'ad + acc. = « près de »\n'
      'prae + abl. = « devant »\n'
      'pro + abl. = « pour » (ALL. für)\n\n'
      'On appelle composés de esse les verbes qui se composent d\'un '
      'préfixe — qui devient préverbe et qui, par ailleurs, peut servir '
      'de préposition — et du verbe esse.',
    ),
    _titreExplication('Les composés de esse'),
    _tableauColonnes(
      ['préverbe', 'verbe composé', 'construction', 'traduction'],
      [
        [
          'ab-',
          'absum, abes, abesse, afui',
          'a(b) + abl.',
          'je suis absent, je suis loin de',
        ],
        [
          'ad-',
          'adsum, ades, adesse, adfui',
          'datif',
          'je suis présent à, j\'assiste à, j\'aide qqn',
        ],
        [
          'de-',
          'desum, dees, deesse, defui',
          'datif',
          'je manque à, je fais défaut à',
        ],
        [
          'inter-',
          'intersum, interes, interesse, interfui',
          'datif',
          'je suis parmi, je participe à',
        ],
        [
          'ob-',
          'obsum, obes, obesse, obfui',
          'datif',
          'je m\'oppose à, je nuis à',
        ],
        [
          'prae-',
          'praesum, praees, praeesse, praefui',
          'datif',
          'je préside à, je commande à',
        ],
        [
          'super-',
          'supersum, superes, superesse, superfui',
          'datif',
          'je survis à, je subsiste à',
        ],
        [
          'pro- / prod-',
          'prosum, prodes, prodesse, profui',
          'datif',
          'je profite à, je suis utile à',
        ],
        [
          'pos- / pot-',
          'possum, potes, posse, potui',
          'infinitif',
          'je peux (+ infinitif)',
        ],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Note bene : au contact du radical du verbe, le préfixe peut '
      'subir des changements (ex. : ob- devient parfois of-, com-...).',
    ),
    _titreExplication('Deux verbes au radical variable'),
    _paragrapheExplication(
      'Pour prodesse et posse, le radical change en fonction de la '
      'lettre qui suit :\n\n'
      'PROD-ESSE : prod- + voyelle, pro- + consonne\n'
      'POS-SE : pos- + consonne, pot- + voyelle\n\n'
      'Ex. : prosum, prodes, prodest, prosumus, prodestis, prosunt.\n'
      'Ex. : possum, potes, potest, possumus, potestis, possunt.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'Un composé de esse se forme avec quel élément en plus de esse ?',
      options: ['un préverbe', 'un adjectif', 'un adverbe', 'un second verbe'],
      reponseCorrecte: 'un préverbe',
    ),
    QuestionLecon(
      question:
          'Quelle construction demande la majorité des composés de esse ?',
      options: ['le datif', 'l\'accusatif', 'le génitif', 'l\'ablatif seul'],
      reponseCorrecte: 'le datif',
    ),
    QuestionLecon(
      question: 'absum se construit avec...',
      options: ['a(b) + ablatif', 'le datif', 'l\'accusatif', 'l\'infinitif'],
      reponseCorrecte: 'a(b) + ablatif',
    ),
    QuestionLecon(
      question: 'Que signifie praesum (+ datif) ?',
      options: [
        'je préside à, je commande à',
        'je suis absent de',
        'je manque à',
        'je profite à',
      ],
      reponseCorrecte: 'je préside à, je commande à',
    ),
    QuestionLecon(
      question: 'Que signifie desum (+ datif) ?',
      options: [
        'je manque à, je fais défaut à',
        'je suis présent à',
        'je survis à',
        'je peux',
      ],
      reponseCorrecte: 'je manque à, je fais défaut à',
    ),
    QuestionLecon(
      question: 'Que signifie intersum (+ datif) ?',
      options: [
        'je suis parmi, je participe à',
        'je m\'oppose à',
        'je suis absent de',
        'je préside à',
      ],
      reponseCorrecte: 'je suis parmi, je participe à',
    ),
    QuestionLecon(
      question: 'possum se construit avec...',
      options: ['un infinitif', 'le datif', 'a(b) + ablatif', 'l\'accusatif'],
      reponseCorrecte: 'un infinitif',
    ),
    QuestionLecon(
      question:
          'Dans prodesse, quand utilise-t-on le radical pro- (et non prod-) ?',
      options: [
        'devant une consonne',
        'devant une voyelle',
        'toujours',
        'jamais',
      ],
      reponseCorrecte: 'devant une consonne',
    ),
    QuestionLecon(
      question:
          'Dans posse, quand utilise-t-on le radical pot- (et non pos-) ?',
      options: [
        'devant une voyelle',
        'devant une consonne',
        'toujours',
        'jamais',
      ],
      reponseCorrecte: 'devant une voyelle',
    ),
    ExerciceSaisie(
      question:
          'Conjugue possum à la 3e personne du singulier de l\'indicatif présent (il peut).',
      reponsesAcceptees: ['potest'],
      indice: 'pot- devant une voyelle.',
    ),
    ExerciceSaisie(
      question:
          'Conjugue prosum à la 1re personne du pluriel de l\'indicatif présent (nous profitons à).',
      reponsesAcceptees: ['prosumus'],
      indice: 'pro- devant une consonne (s).',
    ),
  ],
  fiche: (context) => _tableauColonnes(
    ['préverbe', 'verbe composé', 'construction', 'traduction'],
    [
      [
        'ab-',
        'absum, abes, abesse, afui',
        'a(b) + abl.',
        'être absent, loin de',
      ],
      ['ad-', 'adsum, ades, adesse, adfui', 'datif', 'être présent à, aider'],
      ['de-', 'desum, dees, deesse, defui', 'datif', 'manquer à'],
      [
        'inter-',
        'intersum, interes, interesse, interfui',
        'datif',
        'participer à',
      ],
      ['ob-', 'obsum, obes, obesse, obfui', 'datif', 's\'opposer à, nuire à'],
      [
        'prae-',
        'praesum, praees, praeesse, praefui',
        'datif',
        'présider à, commander',
      ],
      [
        'super-',
        'supersum, superes, superesse, superfui',
        'datif',
        'survivre à',
      ],
      [
        'pro- / prod-',
        'prosum, prodes, prodesse, profui',
        'datif',
        'profiter à, être utile',
      ],
      ['pos- / pot-', 'possum, potes, posse, potui', 'infinitif', 'pouvoir'],
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : L'interrogation simple (totale et partielle)
// ------------------------------------------------------------

final Lecon _leconInterrogationSimple = Lecon(
  id: 'interrogation_simple',
  titre: 'L\'interrogation simple',
  sousTitre: 'Totale (-ne, nonne, num) et partielle (ubi, quo, cur)',
  icone: Icons.quiz,
  unite: 'Vol. I – Unité 4',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Il existe deux types d\'interrogations simples en latin : '
      'l\'interrogation totale, qui porte sur toute la phrase et '
      'attend une réponse par oui ou par non, et l\'interrogation '
      'partielle, qui porte sur un seul élément de la phrase (le lieu, '
      'la cause...) et attend une réponse précise.',
    ),
    _titreExplication('L\'interrogation totale : trois particules'),
    _tableauColonnes(
      ['particule', 'explication', 'traduction', 'réponse(s)'],
      [
        [
          '-ne...?',
          'introduit une vraie question, se soude au mot sur lequel porte la question (en tête de phrase)',
          'Est-ce que... ? (ou inversion)',
          'OUI / NON',
        ],
        [
          'Nonne...?',
          'introduit une question négative (en tête de phrase)',
          'Est-ce que... ne... pas ? (ou inversion)',
          'OUI / SI !',
        ],
        [
          'Num...?',
          'introduit une question rhétorique (en tête de phrase)',
          'Est-ce que par hasard ? Est-ce que vraiment ? (ou inversion)',
          'NON !',
        ],
      ],
    ),
    _paragrapheExplication(
      'Une particule enclitique (comme -ne) est un mot atone — non '
      'accentué — qui se lie au mot tonique — accentué — qui le '
      'précède et forme un tout avec lui.\n\n'
      'Nonne et Num attendent en réalité une réponse déjà connue de '
      'celui qui pose la question (questions orientées ou '
      'rhétoriques) : Nonne suppose « oui », Num suppose « non ».',
    ),
    _titreExplication(
      'L\'interrogation partielle : les adverbes interrogatifs',
    ),
    _tableauColonnes(
      ['particule', 'explication', 'traduction'],
      [
        [
          'Ubi...?',
          'interroge sur le LIEU (où l\'on est)',
          'Où est-ce que... ? (ou inversion)',
        ],
        [
          'Quo...?',
          'interroge sur le LIEU (où l\'on va)',
          'Où est-ce que... ? (ou inversion)',
        ],
        [
          'Cur...?',
          'interroge sur la CAUSE',
          'Pourquoi est-ce que... ? (ou inversion)',
        ],
      ],
    ),
    _titreExplication('Comment répondre aux questions simples ?'),
    _paragrapheExplication(
      'Le latin n\'a pas de mot pour répondre « oui » ou « non ». Pour '
      'dire oui/si, on répète le verbe à la forme affirmative, ou le '
      'mot sur lequel porte l\'interrogation, ou on répond par un '
      'adverbe : ita / sic (« c\'est ainsi, oui »), etiam (« oui »), '
      'vero ou enimvero (« oui, tout à fait »).\n\n'
      'Pour dire non, on répète le verbe à la forme négative, ou on '
      'répond par un adverbe : minime (« pas du tout »).\n\n'
      'D\'autres adverbes pour répondre : profecto (« assurément »), '
      'sane (« assurément, vraiment »), certo (« certes »), nimirum '
      '(« sans doute »), fortasse (« peut-être »).',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'Quelle particule interrogative se soude (enclitique) au mot sur lequel porte la question ?',
      options: ['-ne', 'Nonne', 'Num', 'Cur'],
      reponseCorrecte: '-ne',
    ),
    QuestionLecon(
      question:
          'Quelle particule introduit une question qui attend la réponse « oui » ?',
      options: ['Nonne', 'Num', '-ne', 'Cur'],
      reponseCorrecte: 'Nonne',
    ),
    QuestionLecon(
      question:
          'Quelle particule introduit une question rhétorique qui attend la réponse « non » ?',
      options: ['Num', 'Nonne', '-ne', 'Ubi'],
      reponseCorrecte: 'Num',
    ),
    QuestionLecon(
      question:
          'Si on répond « SI ! » (contredire une négation) à une question introduite par Nonne, que signifie cette réponse ?',
      options: ['OUI', 'NON', 'Peut-être', 'Je ne sais pas'],
      reponseCorrecte: 'OUI',
    ),
    QuestionLecon(
      question: 'Ubi...? interroge sur...',
      options: [
        'le lieu où l\'on est',
        'le lieu où l\'on va',
        'la cause',
        'le temps',
      ],
      reponseCorrecte: 'le lieu où l\'on est',
    ),
    QuestionLecon(
      question: 'Quo...? interroge sur...',
      options: [
        'le lieu où l\'on va',
        'le lieu où l\'on est',
        'la cause',
        'la manière',
      ],
      reponseCorrecte: 'le lieu où l\'on va',
    ),
    QuestionLecon(
      question: 'Cur...? interroge sur...',
      options: ['la cause', 'le lieu', 'le temps', 'la manière'],
      reponseCorrecte: 'la cause',
    ),
    QuestionLecon(
      question: 'Comment le latin répond-il « oui » à une question ?',
      options: [
        'Il n\'y a pas de mot : on répète le verbe (ou le mot interrogé) ou on emploie un adverbe',
        'Avec le mot ita uniquement, toujours seul',
        'Il n\'existe aucun moyen de répondre oui',
        'En répétant la question',
      ],
      reponseCorrecte:
          'Il n\'y a pas de mot : on répète le verbe (ou le mot interrogé) ou on emploie un adverbe',
    ),
    QuestionLecon(
      question: 'Quel adverbe signifie « pas du tout » ?',
      options: ['minime', 'etiam', 'sane', 'fortasse'],
      reponseCorrecte: 'minime',
    ),
    QuestionLecon(
      question: 'Quel adverbe signifie « peut-être » ?',
      options: ['fortasse', 'profecto', 'certo', 'nimirum'],
      reponseCorrecte: 'fortasse',
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['particule', 'traduction', 'réponse(s)'],
        [
          ['-ne...?', 'Est-ce que... ?', 'OUI / NON'],
          ['Nonne...?', 'Est-ce que... ne... pas ?', 'OUI / SI !'],
          ['Num...?', 'Est-ce que par hasard ?', 'NON !'],
          ['Ubi...?', 'Où est-ce que... ? (lieu où l\'on est)', '—'],
          ['Quo...?', 'Où est-ce que... ? (lieu où l\'on va)', '—'],
          ['Cur...?', 'Pourquoi est-ce que... ?', '—'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : L'indicatif imparfait actif
// ------------------------------------------------------------

final Lecon _leconImparfaitActif = Lecon(
  id: 'imparfait_actif',
  titre: 'L\'indicatif imparfait actif',
  sousTitre: 'Suffixe -ba-, les 5 conjugaisons, esse et ses composés',
  icone: Icons.auto_stories,
  unite: 'Vol. I – Unité 5',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'L\'indicatif imparfait latin présente, en principe, les mêmes '
      'usages qu\'en français (description d\'une situation ou d\'une '
      'habitude dans le passé, action inachevée...) et se traduit donc '
      'par le même temps verbal en français.',
    ),
    _titreExplication('La formation de l\'imparfait'),
    _paragrapheExplication(
      'Un verbe à l\'imparfait se compose du radical du présent, du '
      'suffixe -ba- et des terminaisons -m, -s, -t, -mus, -tis, -nt.\n\n'
      'Attention : aux 3e, 4e et 5e conjugaisons, une voyelle d\'ajout '
      '-e- s\'intercale entre le radical et le suffixe -ba-.',
    ),
    _titreExplication('Les 5 modèles de conjugaison'),
    for (final conj in conjugaisons) ...[
      tableauImparfait(conj),
      const SizedBox(height: 12),
    ],
    _titreExplication('La conjugaison de esse et de ses composés'),
    _paragrapheExplication(
      'Il faut bien connaître l\'imparfait de esse : eram, eras, erat, '
      'eramus, eratis, erant.\n\n'
      'Les formes verbales de l\'imparfait des composés correspondent à '
      'l\'imparfait de esse auquel vient s\'ajouter un préfixe : '
      'adsum → aderam, absum → aberam, desum → deeram, intersum → '
      'intereram, obsum → oberam, praesum → praeeram, supersum → '
      'supereram.',
    ),
    _paragrapheExplication(
      'Attention à posse et prodesse, dont le radical varie selon la '
      'lettre qui suit (pos-/pot- et pro-/prod-, comme au présent).',
    ),
    _tableauColonnes(
      ['personne', 'esse', 'posse', 'prodesse'],
      [
        ['je', 'eram', 'poteram', 'proderam'],
        ['tu', 'eras', 'poteras', 'proderas'],
        ['il / elle', 'erat', 'poterat', 'proderat'],
        ['nous', 'eramus', 'poteramus', 'proderamus'],
        ['vous', 'eratis', 'poteratis', 'proderatis'],
        ['ils / elles', 'erant', 'poterant', 'proderant'],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quel suffixe caractérise l\'indicatif imparfait actif ?',
      options: ['-ba-', '-bi-', '-be-', '-b-'],
      reponseCorrecte: '-ba-',
    ),
    QuestionLecon(
      question: 'Sur quel radical l\'imparfait est-il construit ?',
      options: [
        'le radical du présent',
        'le radical du parfait',
        'le radical du supin',
        'l\'infinitif complet',
      ],
      reponseCorrecte: 'le radical du présent',
    ),
    QuestionLecon(
      question:
          'Quelle voyelle d\'ajout apparaît aux 3e, 4e et 5e conjugaisons, '
          'entre le radical et le suffixe -ba- ?',
      options: ['-e-', '-i-', '-a-', '-o-'],
      reponseCorrecte: '-e-',
    ),
    QuestionLecon(
      question: 'Quelle est la forme de « nous envoyions » (mittere) ?',
      options: ['mittebamus', 'mittimus', 'miserimus', 'mittebimus'],
      reponseCorrecte: 'mittebamus',
    ),
    QuestionLecon(
      question:
          'Quelle est la forme de « ils prenaient » (capere, avec voyelle '
          'd\'ajout) ?',
      options: ['capiebant', 'capiunt', 'ceperunt', 'capient'],
      reponseCorrecte: 'capiebant',
    ),
    QuestionLecon(
      question: 'Quelle est la forme de « j\'étais » (esse, imparfait) ?',
      options: ['eram', 'sum', 'fui', 'ero'],
      reponseCorrecte: 'eram',
    ),
    QuestionLecon(
      question:
          'Comment se forme l\'imparfait des composés de esse (adsum, '
          'absum, intersum...) ?',
      options: [
        'préfixe + imparfait de esse',
        'ce sont des formes irrégulières à apprendre une par une',
        'la même forme qu\'au présent',
        'préfixe + infinitif de esse',
      ],
      reponseCorrecte: 'préfixe + imparfait de esse',
    ),
    QuestionLecon(
      question:
          'Que devient le radical pos- de posse devant une voyelle, comme '
          'à l\'imparfait (poteram) ?',
      options: ['pot-', 'pos-', 'pod-', 'po-'],
      reponseCorrecte: 'pot-',
    ),
    ExerciceSaisie(
      question:
          'Conjugue amare à la 3e personne du pluriel de l\'indicatif '
          'imparfait (ils aimaient).',
      reponsesAcceptees: ['amabant'],
    ),
    ExerciceSaisie(
      question:
          'Conjugue posse à la 1re personne du singulier de l\'indicatif '
          'imparfait (je pouvais).',
      reponsesAcceptees: ['poteram'],
      indice: 'pot- devant une voyelle.',
    ),
  ],
  fiche: (context) => Column(
    children: [
      for (final conj in conjugaisons) ...[
        tableauImparfait(conj),
        const SizedBox(height: 12),
      ],
      _tableauColonnes(
        ['personne', 'esse', 'posse', 'prodesse'],
        [
          ['je', 'eram', 'poteram', 'proderam'],
          ['tu', 'eras', 'poteras', 'proderas'],
          ['il / elle', 'erat', 'poterat', 'proderat'],
          ['nous', 'eramus', 'poteramus', 'proderamus'],
          ['vous', 'eratis', 'poteratis', 'proderatis'],
          ['ils / elles', 'erant', 'poterant', 'proderant'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : La proposition infinitive : l'ACI
// ------------------------------------------------------------

final Lecon _leconACI = Lecon(
  id: 'aci',
  titre: 'La proposition infinitive : l\'ACI',
  sousTitre: 'Accusativus Cum Infinitivo, concordance des temps',
  icone: Icons.chat_bubble,
  unite: 'Vol. I – Unité 5',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Essaie de traduire spontanément : Romani dicunt barbaros esse '
      'saevos (cruels).\n\n'
      'Ta traduction comporte sans doute deux verbes, donc deux '
      'propositions : une principale (« Les Romains disent »), et une '
      'subordonnée complétive introduite par « que » (« que les '
      'barbares sont cruels »).',
    ),
    _paragrapheExplication(
      'Mais en latin, cette subordonnée n\'est introduite par aucun mot '
      '(pas d\'équivalent de « que ») : son sujet (barbaros) est à '
      'l\'accusatif, son verbe (esse) est à l\'infinitif, et son '
      'attribut (saevos) est lui aussi à l\'accusatif.',
    ),
    _titreExplication('Qu\'est-ce que l\'ACI ?'),
    _paragrapheExplication(
      'Cette proposition subordonnée s\'appelle la proposition '
      'infinitive, ou ACI (Accusativus Cum Infinitivo, « accusatif '
      'avec infinitif »). Elle n\'est introduite par aucun mot '
      'subordonnant.',
    ),
    _titreExplication('Le sujet et l\'attribut de l\'ACI'),
    _paragrapheExplication(
      'En principe, l\'ACI a toujours un sujet exprimé à l\'accusatif, '
      'et son verbe est à l\'infinitif. S\'il y a un attribut du sujet, '
      'il se met également à l\'accusatif.\n\n'
      'Exemple : Je pense que ton fils est présent.\n'
      '→ Puto [filium tuum adesse].',
    ),
    _titreExplication('Le verbe introducteur'),
    _paragrapheExplication(
      'Les verbes de parole (dire), de pensée (croire, penser) et de '
      'perception (voir, savoir) sont suivis d\'un ACI en latin, comme '
      'en français d\'une subordonnée en « que ».',
    ),
    _paragrapheExplication(
      'Quelques verbes de volonté ou de souhait se construisent aussi '
      'avec l\'ACI :\n\n'
      'jubeo, es, ere, jussi, jussum + ACI : « ordonner que »\n'
      'cupio, is, ere, cupivi/cupii, cupitum + ACI : « désirer que »\n\n'
      'Attention, en français, ces deux verbes sont suivis du '
      'subjonctif !',
    ),
    _paragrapheExplication(
      'Il faut parfois transformer la phrase française pour lui donner '
      'un deuxième sujet exprimé. Par exemple, pour « César ordonne aux '
      'Romains de combattre contre les barbares », on dira plutôt '
      '« César ordonne que les Romains combattent contre les '
      'barbares », que l\'on traduit alors par jubere + ACI.',
    ),
    _titreExplication('Exception : les verbes à sujet identique'),
    _paragrapheExplication(
      'Certains verbes (volo, nolo, malo, cupio et scio) se '
      'construisent avec l\'infinitif seul, sans sujet exprimé à '
      'l\'accusatif, quand le sujet de la subordonnée est le même que '
      'celui de la principale (S1 = S2).\n\n'
      'Ex. : Cupio [amicum meum adesse], « je désire que mon ami soit '
      'présent » (S1 ≠ S2, sujet à l\'accusatif) ; mais Cupio adesse, '
      '« je désire être présent » (S1 = S2, infinitif seul, sans '
      'accusatif).',
    ),
    _titreExplication('La concordance des temps'),
    _paragrapheExplication(
      'Quand l\'action de la subordonnée se déroule en même temps que '
      'celle de la principale, ce rapport de temps s\'appelle la '
      'simultanéité. En latin, on utilise alors l\'infinitif présent.\n\n'
      'En français, il faut appliquer la concordance des temps '
      '(consecutio temporum) : le temps de la subordonnée dépend du '
      'temps du verbe introducteur.',
    ),
    _tableauColonnes(
      ['verbe introducteur', 'subordonnée française (simultanéité)'],
      [
        [
          'temps du présent\n(indicatif présent, futur, impératif)',
          'indicatif (ou subjonctif) présent',
        ],
        [
          'temps du passé\n(imparfait, parfait, plus-que-parfait)',
          'indicatif (ou subjonctif) imparfait',
        ],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Remarque : en français, le subjonctif imparfait est surtout '
      'utilisé à la 3e personne du singulier ; pour les autres '
      'personnes, on emploie plutôt le subjonctif présent, même après '
      'un verbe introducteur au passé.',
    ),
    _titreExplication(
      'Les trois temps de l\'infinitif : antériorité, simultanéité, '
      'postériorité',
    ),
    _paragrapheExplication(
      'Le latin possède trois temps à l\'infinitif, qui expriment le '
      'rapport de temps entre la subordonnée et la principale : '
      'l\'infinitif parfait (antériorité, l\'action de la subordonnée '
      'est antérieure à celle de la principale), l\'infinitif présent '
      '(simultanéité) et l\'infinitif futur (postériorité, l\'action de '
      'la subordonnée est postérieure à celle de la principale). Le '
      'français applique dans tous les cas la concordance des temps.',
    ),
    _tableauColonnes(
      ['infinitif latin', 'rapport', 'si Puto... (« je crois »)', 'si Putabam... (« je croyais »)'],
      [
        [
          'venisse (parfait)',
          'antériorité',
          'que ton fils est venu',
          'que ton fils était venu',
        ],
        [
          'venire (présent)',
          'simultanéité',
          'que ton fils vient',
          'que ton fils venait',
        ],
        [
          'venturum esse (futur)',
          'postériorité',
          'que ton fils viendra',
          'que ton fils viendrait',
        ],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Comment appelle-t-on la proposition infinitive latine ?',
      options: [
        'l\'ACI (Accusativus Cum Infinitivo)',
        'le supin',
        'la proposition relative',
        'le gérondif',
      ],
      reponseCorrecte: 'l\'ACI (Accusativus Cum Infinitivo)',
    ),
    QuestionLecon(
      question: 'Dans l\'ACI, à quel cas est le sujet ?',
      options: ['l\'accusatif', 'le nominatif', 'le datif', 'le génitif'],
      reponseCorrecte: 'l\'accusatif',
    ),
    QuestionLecon(
      question: 'Dans l\'ACI, à quel mode est le verbe ?',
      options: ['l\'infinitif', 'le subjonctif', 'l\'indicatif', 'l\'impératif'],
      reponseCorrecte: 'l\'infinitif',
    ),
    QuestionLecon(
      question:
          'Quel mot, présent dans la traduction française, n\'apparaît pas '
          'dans la phrase latine ?',
      options: ['« que »', 'le sujet', 'le verbe', 'l\'attribut'],
      reponseCorrecte: '« que »',
    ),
    QuestionLecon(
      question: 'Quels types de verbes introduisent un ACI en latin ?',
      options: [
        'les verbes de parole, de pensée et de perception',
        'seulement les verbes de mouvement',
        'seulement les verbes d\'ordre',
        'tous les verbes sans exception',
      ],
      reponseCorrecte: 'les verbes de parole, de pensée et de perception',
    ),
    QuestionLecon(
      question: 'Que signifie jubeo, es, ere + ACI ?',
      options: ['ordonner que', 'désirer que', 'savoir que', 'voir que'],
      reponseCorrecte: 'ordonner que',
    ),
    QuestionLecon(
      question:
          'En français, jubere et cupere + ACI se traduisent par un verbe '
          'suivi de...',
      options: [
        'que + subjonctif',
        'que + indicatif',
        'de + infinitif',
        'un infinitif seul',
      ],
      reponseCorrecte: 'que + subjonctif',
    ),
    QuestionLecon(
      question:
          'Quels verbes se construisent avec l\'infinitif seul (sans '
          'accusatif) quand le sujet de la subordonnée est le même que '
          'celui de la principale ?',
      options: [
        'volo, nolo, malo, cupio, scio',
        'dico, puto, video, credo',
        'sum et ses composés',
        'tous les verbes de perception',
      ],
      reponseCorrecte: 'volo, nolo, malo, cupio, scio',
    ),
    QuestionLecon(
      question: 'Quel infinitif exprime la simultanéité dans l\'ACI ?',
      options: [
        'l\'infinitif présent',
        'l\'infinitif parfait',
        'l\'infinitif futur',
        'le supin',
      ],
      reponseCorrecte: 'l\'infinitif présent',
    ),
    QuestionLecon(
      question: 'Quel infinitif exprime l\'antériorité dans l\'ACI ?',
      options: [
        'l\'infinitif parfait',
        'l\'infinitif présent',
        'l\'infinitif futur',
        'le supin',
      ],
      reponseCorrecte: 'l\'infinitif parfait',
    ),
    QuestionLecon(
      question:
          'Si le verbe introducteur est au passé (ex. putabam, « je '
          'croyais »), comment se traduit un infinitif présent qui '
          'exprime la simultanéité ?',
      options: [
        'par un imparfait',
        'par un présent',
        'par un futur',
        'par un passé composé',
      ],
      reponseCorrecte: 'par un imparfait',
    ),
    ExerciceSaisie(
      question:
          'Dans « Puto filium tuum adesse » (« Je pense que ton fils est '
          'présent »), à quel cas est « filium tuum » ? (un mot)',
      reponsesAcceptees: ['accusatif'],
    ),
    ExerciceSaisie(
      question:
          'Dans la même phrase, à quel mode est « adesse » ? (un mot)',
      reponsesAcceptees: ['infinitif'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'ACI : sujet à l\'accusatif + verbe à l\'infinitif (+ attribut à '
        'l\'accusatif s\'il y en a un). Sauf si S1 = S2 avec volo, nolo, '
        'malo, cupio, scio : infinitif seul, sans accusatif.',
      ),
      _tableauColonnes(
        ['verbe introducteur', 'subordonnée française'],
        [
          ['temps du présent', 'indicatif/subjonctif présent'],
          ['temps du passé', 'indicatif/subjonctif imparfait'],
        ],
      ),
      const SizedBox(height: 12),
      _tableauColonnes(
        ['infinitif latin', 'rapport', 'traduction'],
        [
          ['parfait', 'antériorité', 'passé (ex. est venu)'],
          ['présent', 'simultanéité', 'même temps que la principale'],
          ['futur', 'postériorité', 'futur/conditionnel'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les emplois de esse
// ------------------------------------------------------------

final Lecon _leconEmploisEsse = Lecon(
  id: 'emplois_esse',
  titre: 'Les emplois de esse',
  sousTitre: 'Attribut, « il y a », le datif possessif',
  icone: Icons.savings,
  unite: 'Vol. I – Unité 6',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('Je me rappelle'),
    _paragrapheExplication(
      '1. esse employé avec un attribut du sujet se traduit par « être » '
      'en français.\n'
      'Ex. : Galli saepe saevi sunt. (Les Gaulois sont souvent cruels.)\n\n'
      '2. esse signifiant « il y a ». Employé sans attribut, placé '
      'devant le sujet et conjugué à la 3e personne du singulier ou du '
      'pluriel, esse se traduit par « il y a, il y avait, il y eut, il '
      'y aura... ».\n'
      'Ex. : Est pulchrum templum in foro. (Il y a un beau temple sur '
      'le forum.)\n'
      'Erant multi populi in Italiā. (Il y avait beaucoup de peuples '
      'en Italie.)',
    ),
    _titreExplication(
      'esse employé avec un complément au datif : le dativus possessivus',
    ),
    _paragrapheExplication(
      'esse suivi d\'un datif exprime la possession.\n\n'
      'Ex. : Multae fibulae puellis sunt. (littéralement : De nombreuses '
      'fibules sont/appartiennent aux jeunes filles.)',
    ),
    _paragrapheExplication(
      'Cette structure typique du latin se traduit littéralement par '
      '« être » ou « appartenir à qqn ». Il est souvent préférable de '
      'transformer la phrase française et d\'utiliser la tournure plus '
      'idiomatique « avoir » ou « posséder ».\n\n'
      'Ex. : Multae fibulae puellis sunt. → Les jeunes filles ont '
      'beaucoup de fibules.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'Quel est le premier emploi de esse, quand il est accompagné '
          'd\'un attribut du sujet ?',
      options: [
        'il se traduit par « être »',
        'il se traduit par « il y a »',
        'il se traduit par « avoir »',
        'il ne se traduit pas',
      ],
      reponseCorrecte: 'il se traduit par « être »',
    ),
    QuestionLecon(
      question:
          'Comment traduit-on « est » ou « sunt » placés devant le sujet, '
          'sans attribut ?',
      options: ['il y a', 'être', 'avoir', 'devenir'],
      reponseCorrecte: 'il y a',
    ),
    QuestionLecon(
      question: 'Le datif possessif (esse + datif) exprime...',
      options: [
        'la possession',
        'le lieu où l\'on est',
        'la comparaison',
        'la cause',
      ],
      reponseCorrecte: 'la possession',
    ),
    QuestionLecon(
      question:
          'Que signifie littéralement « Multae fibulae puellis sunt » ?',
      options: [
        'De nombreuses fibules sont/appartiennent aux jeunes filles',
        'Les jeunes filles sont dans la forêt',
        'Il y a des jeunes filles',
        'Les fibules sont belles',
      ],
      reponseCorrecte:
          'De nombreuses fibules sont/appartiennent aux jeunes filles',
    ),
    QuestionLecon(
      question:
          'Quelle traduction idiomatique préfère-t-on souvent pour le '
          'datif possessif, plutôt que « être » ou « appartenir à » ?',
      options: [
        'avoir / posséder',
        'aller / venir',
        'vouloir / pouvoir',
        'dire / penser',
      ],
      reponseCorrecte: 'avoir / posséder',
    ),
    QuestionLecon(
      question: 'À quel cas est mis le possesseur dans le datif possessif ?',
      options: ['le datif', 'l\'accusatif', 'le génitif', 'l\'ablatif'],
      reponseCorrecte: 'le datif',
    ),
    QuestionLecon(
      question:
          'Comment traduirais-tu le plus naturellement « Puellae tunica '
          'nova est » ?',
      options: [
        'La jeune fille a une tunique neuve.',
        'Il y a une tunique pour la jeune fille.',
        'La tunique est nouvelle.',
        'La jeune fille est neuve.',
      ],
      reponseCorrecte: 'La jeune fille a une tunique neuve.',
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Les trois emplois de esse :\n\n'
        '• esse + attribut du sujet → « être »\n'
        '• esse devant le sujet, sans attribut → « il y a / il y avait »\n'
        '• esse + datif → datif possessif, « avoir / posséder »',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : La voix passive
// ------------------------------------------------------------

final Lecon _leconVoixPassive = Lecon(
  id: 'voix_passive',
  titre: 'La voix passive',
  sousTitre: 'Terminaisons, infinitif passif, complément d\'agent',
  icone: Icons.cruelty_free,
  unite: 'Vol. I – Unité 6',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('Qu\'est-ce que la voix passive ?'),
    _paragrapheExplication(
      'À la voix active, le sujet fait l\'action exprimée par le verbe. '
      'Mais à la voix passive, le sujet ne fait pas l\'action, il la '
      'subit. Il n\'est pas actif (il n\'agit pas) mais passif.\n\n'
      'Voix active : Romani januas aperiunt. (Les Romains ouvrent les '
      'portes.) → le sujet fait l\'action.\n'
      'Voix passive : Januae aperiuntur. (Les portes sont ouvertes.) → '
      'le sujet subit l\'action.',
    ),
    _titreExplication('La transformation passive'),
    _paragrapheExplication(
      'En français comme en latin :\n\n'
      '• Le COD (l\'accusatif, en latin) de la phrase active devient le '
      'sujet (le nominatif) de la phrase passive.\n'
      '• Le sujet (le nominatif) de la phrase active devient un '
      'complément dans la phrase passive.\n'
      '• Le verbe prend la forme passive.\n\n'
      'Ex. : Romani januas aperiunt. → Januae a Romanis aperiuntur.\n'
      '(Les Romains ouvrent les portes. → Les portes sont ouvertes par '
      'les Romains.)',
    ),
    _paragrapheExplication(
      'En principe, seul un verbe qui se construit avec un accusatif '
      'peut être transformé au passif (comme, en français, seuls les '
      'verbes transitifs directs, suivis d\'un COD, admettent la '
      'tournure passive).',
    ),
    _titreExplication('La morphologie : le passif des temps du présent'),
    _paragrapheExplication(
      'Pour former le passif des temps conjugués du présent (indicatif '
      'présent, imparfait, futur simple, subjonctif présent et '
      'imparfait), il suffit de remplacer la terminaison personnelle '
      'active par la terminaison personnelle passive.',
    ),
    _tableauColonnes(
      ['terminaison active', 'terminaison passive'],
      [
        ['-o / -m', '-or / -r'],
        ['-s', '-ris'],
        ['-t', '-tur'],
        ['-mus', '-mur'],
        ['-tis', '-mini'],
        ['-nt', '-ntur'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('L\'indicatif présent passif des 5 conjugaisons'),
    _tableauColonnes(
      ['pers.', '1re', '2e', '3e', '4e', '5e'],
      [
        ['je', 'amor', 'moneor', 'mittor', 'capior', 'audior'],
        ['tu', 'amaris', 'moneris', 'mitteris', 'caperis', 'audiris'],
        ['il / elle', 'amatur', 'monetur', 'mittitur', 'capitur', 'auditur'],
        ['nous', 'amamur', 'monemur', 'mittimur', 'capimur', 'audimur'],
        ['vous', 'amamini', 'monemini', 'mittimini', 'capimini', 'audimini'],
        [
          'ils / elles',
          'amantur',
          'monentur',
          'mittuntur',
          'capiuntur',
          'audiuntur',
        ],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'La même substitution de terminaison s\'applique à l\'imparfait '
      '(ex. : amabam → amabar, « j\'étais aimé »), au futur simple et '
      'aux subjonctifs présent et imparfait.',
    ),
    _titreExplication('Cas particulier : le passif de mittis et de capis'),
    _paragrapheExplication(
      'Devant -r-, un -i- bref se transforme en -e- : mittis (« tu '
      'envoies ») → mitteris (« tu es envoyé »), capis (« tu prends ») '
      '→ caperis (« tu es pris »).\n\n'
      'Mais à la 5e conjugaison, le -i- est long et ne change pas : '
      'audis → audiris (« tu es écouté »).',
    ),
    _titreExplication('L\'infinitif présent passif'),
    _paragrapheExplication(
      'Pour former le passif de l\'infinitif présent, on remplace la '
      'terminaison active par la terminaison passive :\n\n'
      '• radical long + -re → -ri, aux 1re, 2e et 5e conjugaisons '
      '(amare → amari, monere → moneri, audire → audiri).\n'
      '• -ere → -i, aux 3e et 4e conjugaisons (mittere → mitti, capere '
      '→ capi).',
    ),
    _titreExplication('Le complément du passif'),
    _paragrapheExplication(
      'Le sujet d\'un verbe à la voix passive ne fait pas l\'action, il '
      'la subit. L\'action est donc faite par quelqu\'un ou quelque '
      'chose d\'autre, appelé le complément du passif. En français, ce '
      'complément est introduit par « par ».\n\n'
      'En latin, on distingue deux cas selon qu\'il s\'agit d\'un être '
      'animé ou inanimé :\n\n'
      '• a(b) + ablatif, s\'il s\'agit d\'une personne (être animé).\n'
      '• l\'ablatif seul (sans préposition), s\'il s\'agit d\'une chose '
      '(être inanimé).\n\n'
      'Ex. : Dei a Romanis timentur. (Les dieux sont craints par les '
      'Romains.)\n'
      'Lupus gladio interficitur. (Le loup est tué par l\'épée.)',
    ),
    _titreExplication('L\'emploi de l\'infinitif passif'),
    _paragrapheExplication(
      'L\'infinitif passif s\'utilise surtout dans deux cas :\n\n'
      '• comme complément d\'un verbe suivi de l\'infinitif (verbe '
      'modal ou semi-auxiliaire, comme posse ou debere).\n'
      'Ex. : Treveri vinci non possunt. (Les Trévires ne peuvent pas '
      'être vaincus.)\n\n'
      '• dans la proposition infinitive (ACI).\n'
      'Ex. : Ledona putat Treveros a Romanis timeri. (Ledona pense que '
      'les Trévires sont craints des Romains.)',
    ),
    _paragrapheExplication(
      'Nota bene : esse et ses composés n\'ont pas de voix passive, '
      'puisque ce sont des verbes intransitifs (sans complément à '
      'l\'accusatif).',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'À la voix passive, le sujet du verbe...',
      options: [
        'subit l\'action',
        'fait l\'action',
        'n\'existe pas',
        'est toujours au génitif',
      ],
      reponseCorrecte: 'subit l\'action',
    ),
    QuestionLecon(
      question:
          'Dans la transformation passive, que devient le COD (accusatif) '
          'de la phrase active ?',
      options: [
        'le sujet (nominatif) de la phrase passive',
        'le complément du passif',
        'l\'attribut du sujet',
        'il disparaît',
      ],
      reponseCorrecte: 'le sujet (nominatif) de la phrase passive',
    ),
    QuestionLecon(
      question:
          'Quelle terminaison passive correspond à la terminaison active '
          '-t ?',
      options: ['-tur', '-ris', '-mur', '-ntur'],
      reponseCorrecte: '-tur',
    ),
    QuestionLecon(
      question:
          'Quelle terminaison passive correspond à la terminaison active '
          '-mus ?',
      options: ['-mur', '-mini', '-tur', '-ntur'],
      reponseCorrecte: '-mur',
    ),
    QuestionLecon(
      question: 'Quelle est la forme de « il est envoyé » (mittere) ?',
      options: ['mittitur', 'mittiris', 'mittuntur', 'mittimur'],
      reponseCorrecte: 'mittitur',
    ),
    QuestionLecon(
      question:
          'Devant -r-, que devient le -i- bref de la 3e et de la 4e '
          'conjugaison (ex. capis → caperis) ?',
      options: ['-e-', '-a-', '-o-', '-u-'],
      reponseCorrecte: '-e-',
    ),
    QuestionLecon(
      question: 'Quel est l\'infinitif présent passif de mittere ?',
      options: ['mitti', 'mittiri', 'mittari', 'mittere'],
      reponseCorrecte: 'mitti',
    ),
    QuestionLecon(
      question: 'Quel est l\'infinitif présent passif de amare ?',
      options: ['amari', 'amare', 'ami', 'amatur'],
      reponseCorrecte: 'amari',
    ),
    QuestionLecon(
      question:
          'Quelle construction exprime le complément d\'agent quand il '
          's\'agit d\'une personne (être animé) ?',
      options: [
        'a(b) + ablatif',
        'l\'ablatif seul',
        'l\'accusatif',
        'le datif',
      ],
      reponseCorrecte: 'a(b) + ablatif',
    ),
    QuestionLecon(
      question:
          'Quelle construction exprime le complément d\'agent quand il '
          's\'agit d\'une chose (être inanimé), comme « Lupus gladio '
          'interficitur » ?',
      options: [
        'l\'ablatif seul',
        'a(b) + ablatif',
        'l\'accusatif',
        'le génitif',
      ],
      reponseCorrecte: 'l\'ablatif seul',
    ),
    QuestionLecon(
      question: 'Pourquoi esse et ses composés n\'ont-ils pas de voix passive ?',
      options: [
        'ce sont des verbes intransitifs',
        'ils n\'ont pas de présent',
        'ils sont toujours au passif',
        'ils n\'ont pas d\'infinitif',
      ],
      reponseCorrecte: 'ce sont des verbes intransitifs',
    ),
    ExerciceSaisie(
      question:
          'Conjugue amare à la 1re personne du singulier de l\'indicatif '
          'présent passif (je suis aimé).',
      reponsesAcceptees: ['amor'],
    ),
    ExerciceSaisie(
      question:
          'Conjugue capere à la 2e personne du singulier de l\'indicatif '
          'présent passif (tu es pris).',
      reponsesAcceptees: ['caperis'],
      indice: 'Le -i- bref devient -e- devant -r-.',
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['terminaison active', 'terminaison passive'],
        [
          ['-o / -m', '-or / -r'],
          ['-s', '-ris'],
          ['-t', '-tur'],
          ['-mus', '-mur'],
          ['-tis', '-mini'],
          ['-nt', '-ntur'],
        ],
      ),
      const SizedBox(height: 12),
      _tableauColonnes(
        ['pers.', '1re', '2e', '3e', '4e', '5e'],
        [
          ['je', 'amor', 'moneor', 'mittor', 'capior', 'audior'],
          ['tu', 'amaris', 'moneris', 'mitteris', 'caperis', 'audiris'],
          ['il / elle', 'amatur', 'monetur', 'mittitur', 'capitur', 'auditur'],
          ['nous', 'amamur', 'monemur', 'mittimur', 'capimur', 'audimur'],
          [
            'vous',
            'amamini',
            'monemini',
            'mittimini',
            'capimini',
            'audimini',
          ],
          [
            'ils / elles',
            'amantur',
            'monentur',
            'mittuntur',
            'capiuntur',
            'audiuntur',
          ],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Infinitif passif : radical long + -re → -ri (1re, 2e, 5e) ; '
        '-ere → -i (3e, 4e).\n\n'
        'Complément d\'agent : a(b) + ablatif (être animé) / ablatif '
        'seul (être inanimé).',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Mihi adeste ! Le passif en français
// ------------------------------------------------------------

final Lecon _leconPassifFrancais = Lecon(
  id: 'passif_francais',
  titre: 'Mihi adeste ! Le passif en français',
  sousTitre: 'Le mécanisme de la transformation passive, méthode en 3 étapes',
  icone: Icons.auto_fix_high,
  unite: 'Vol. I – Unité 6',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('Le mécanisme de la transformation passive'),
    _paragrapheExplication(
      'À la voix active, le sujet fait l\'action exprimée par le verbe. '
      'Mais à la voix passive, le sujet ne fait pas l\'action, il la '
      'subit.\n\n'
      'Ex. : Les jeunes lisent beaucoup de livres. (le sujet fait '
      'l\'action)\n'
      '→ Beaucoup de livres sont lus par les jeunes. (le sujet subit '
      'l\'action, il ne la fait pas lui-même)',
    ),
    _paragrapheExplication(
      '• Le COD de la phrase active devient le sujet de la phrase '
      'passive.\n'
      '• Le sujet de la phrase active devient un complément dans la '
      'phrase passive, introduit par « par ».\n'
      '• Le verbe prend la forme passive « être + participe passé ».',
    ),
    _titreExplication(
      'Une méthode pratique en 3 étapes pour mettre un verbe au passif',
    ),
    _paragrapheExplication(
      '1. Mettre l\'auxiliaire « être » au mode, au temps et à la '
      'personne voulus.\n'
      '2. Mettre le verbe au participe passé.\n'
      '3. Accorder le participe passé avec le sujet.',
    ),
    _paragrapheExplication(
      'Exemple : louer, imparfait passif, ils (les bons élèves).\n\n'
      '1. l\'auxiliaire « être » se met à l\'imparfait : ils étaient\n'
      '2. participe passé du verbe « louer » : loué\n'
      '3. accorder avec le sujet : ils étaient loués',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Que devient le COD de la phrase active à la voix passive ?',
      options: [
        'le sujet de la phrase passive',
        'le complément d\'agent',
        'l\'attribut',
        'il disparaît',
      ],
      reponseCorrecte: 'le sujet de la phrase passive',
    ),
    QuestionLecon(
      question:
          'Par quel mot le complément d\'agent est-il généralement '
          'introduit en français ?',
      options: ['par', 'de', 'à', 'pour'],
      reponseCorrecte: 'par',
    ),
    QuestionLecon(
      question: 'Quelle est la 1re étape de la méthode en 3 étapes ?',
      options: [
        'mettre l\'auxiliaire « être » au mode, au temps et à la '
            'personne voulus',
        'accorder le participe passé avec le sujet',
        'mettre le verbe au participe passé',
        'trouver le complément d\'agent',
      ],
      reponseCorrecte:
          'mettre l\'auxiliaire « être » au mode, au temps et à la '
          'personne voulus',
    ),
    QuestionLecon(
      question: 'Quelle est la dernière étape de la méthode en 3 étapes ?',
      options: [
        'accorder le participe passé avec le sujet',
        'mettre l\'auxiliaire « être »',
        'mettre le verbe au participe passé',
        'traduire le complément d\'agent',
      ],
      reponseCorrecte: 'accorder le participe passé avec le sujet',
    ),
    ExerciceSaisie(
      question:
          'Mets « louer » au passif, à l\'imparfait, pour le sujet '
          '« elle » (accorde le participe passé).',
      reponsesAcceptees: ['elle etait louee', 'elle était louée'],
      indice: '1. être à l\'imparfait 2. participe passé 3. accord',
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        '1. auxiliaire « être » au mode/temps/personne voulus\n'
        '2. verbe au participe passé\n'
        '3. accorder le participe passé avec le sujet',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : La troisième déclinaison
// ------------------------------------------------------------

final Lecon _leconDeclinaison3 = Lecon(
  id: 'decl_3',
  titre: 'La troisième déclinaison',
  sousTitre: 'civis, mare, rex, corpus : radicaux variables',
  icone: Icons.pets,
  unite: 'Vol. I – Unité 7',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'La 3e déclinaison constitue l\'ensemble nominal le plus riche et '
      'le plus varié de la langue latine. Contrairement aux 1re et 2e '
      'déclinaisons, les noms ont des radicaux variables, et les formes '
      'de nominatif sont très variées. Il faut donc bien retenir le '
      'vocabulaire (nominatif ET génitif) pour ne pas se tromper.',
    ),
    _paragrapheExplication(
      'Les noms de la troisième déclinaison ont le génitif singulier en '
      '-is. C\'est en enlevant cette terminaison qu\'on obtient le '
      'radical auquel s\'ajoutent les autres terminaisons.',
    ),
    _titreExplication(
      'Masculins et féminins : parisyllabiques et imparisyllabiques',
    ),
    _paragrapheExplication(
      'Si le nombre de syllabes est identique au nominatif et au '
      'génitif, le nom fait partie de la catégorie des parisyllabiques '
      '(civis, 2 syllabes ; civis, 2 syllabes). Sinon, il fait partie '
      'des imparisyllabiques (rex, 1 syllabe ; regis, 2 syllabes).',
    ),
    tableauDeclinaison(declinaisons[5]),
    const SizedBox(height: 12),
    tableauDeclinaison(declinaisons[3]),
    const SizedBox(height: 12),
    _titreExplication('Les noms neutres : repérer les « AREAL »'),
    _paragrapheExplication(
      'En principe, les noms neutres se déclinent comme corpus. Mais il '
      'faut retenir une exception : les noms neutres dont le nominatif '
      'se termine en -ar, -e ou -al (on les appelle, pour mieux les '
      'retenir, les « neutres AREAL »). Ceux-ci ont des terminaisons '
      'spécifiques : l\'ablatif singulier en -i, le nominatif/vocatif/'
      'accusatif pluriel en -ia, et le génitif pluriel en -ium.',
    ),
    tableauDeclinaison(declinaisons[4]),
    const SizedBox(height: 12),
    tableauDeclinaison(declinaisons[12]),
    const SizedBox(height: 12),
    _titreExplication('Une méthode pratique'),
    _paragrapheExplication(
      'Pour les noms masculins ou féminins, il faut compter les '
      'syllabes du nominatif et du génitif : identiques → '
      'parisyllabique (modèle civis) ; différentes → imparisyllabique '
      '(modèle rex).\n\n'
      'Pour les noms neutres, il faut repérer les « AREAL » : '
      'nominatif en -ar, -e ou -al → modèle mare ; sinon → modèle '
      'corpus.',
    ),
    _titreExplication('Les cas particuliers'),
    _paragrapheExplication(
      'Les « faux parisyllabiques » : un petit nombre de noms '
      'masculins et féminins parisyllabiques ont malgré tout un '
      'génitif pluriel en -um, comme le type imparisyllabique. C\'est '
      'le cas d\'une liste de noms constituée des habitants d\'une '
      'maisonnée : mater, matris (mère) → matrum ; pater, patris '
      '(père) → patrum ; frater, fratris (frère) → fratrum ; juvenis, '
      'is (jeune homme) → juvenum ; senex, is (vieillard) → senum ; '
      'canis, is (chien) → canum.',
    ),
    _paragrapheExplication(
      'Les « faux imparisyllabiques » : certains noms monosyllabiques, '
      'dont le radical se termine par deux consonnes, ont perdu au '
      'nominatif la voyelle -i caractéristique des radicaux vocaliques '
      '(urbs < *urbis). Ce sont donc d\'anciens parisyllabiques, dont '
      'le génitif pluriel est en -ium : urbs, urbis (ville) → urbium ; '
      'fons, fontis (source) → fontium ; gens, gentis (famille, '
      'peuple) → gentium ; mens, mentis (esprit) → mentium ; mons, '
      'montis (montagne) → montium ; pars, partis (partie) → partium.',
    ),
    _paragrapheExplication(
      'Parmi les parisyllabiques, certains noms ont gardé les anciennes '
      'formes en -i, avec l\'accusatif en -im et l\'ablatif en -i : '
      'quelques noms géographiques en -is (Tiberis, le Tibre) et '
      'quelques noms féminins (febris, fièvre ; puppis, poupe ; '
      'securis, hache ; sitis, soif ; turris, tour ; tussis, toux ; '
      'vis, violence).\n\n'
      'Retiens en particulier le nom défectif vis, f. (« force, '
      'violence »), dont le radical est différent au pluriel : vires, '
      'virium.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quelle est la terminaison du génitif singulier de la 3e déclinaison ?',
      options: ['-is', '-ae', '-i', '-us'],
      reponseCorrecte: '-is',
    ),
    QuestionLecon(
      question: 'Comment obtient-on le radical d\'un nom de la 3e déclinaison ?',
      options: [
        'en enlevant la terminaison -is du génitif',
        'en enlevant la terminaison du nominatif',
        'en ajoutant -is au nominatif',
        'le radical est toujours identique au nominatif',
      ],
      reponseCorrecte: 'en enlevant la terminaison -is du génitif',
    ),
    QuestionLecon(
      question:
          'Un nom qui a le même nombre de syllabes au nominatif et au '
          'génitif (comme civis, civis) est dit...',
      options: [
        'parisyllabique',
        'imparisyllabique',
        'défectif',
        'neutre AREAL',
      ],
      reponseCorrecte: 'parisyllabique',
    ),
    QuestionLecon(
      question:
          'Un nom qui a un nombre de syllabes différent au nominatif et '
          'au génitif (comme rex, regis) est dit...',
      options: [
        'imparisyllabique',
        'parisyllabique',
        'défectif',
        'neutre AREAL',
      ],
      reponseCorrecte: 'imparisyllabique',
    ),
    QuestionLecon(
      question:
          'Quelles terminaisons caractérisent le nominatif des « neutres '
          'AREAL » ?',
      options: ['-ar, -e, -al', '-us, -a, -um', '-is, -es', '-x, -s'],
      reponseCorrecte: '-ar, -e, -al',
    ),
    QuestionLecon(
      question: 'Quel est le génitif pluriel du modèle mare (neutre AREAL) ?',
      options: ['marium', 'marum', 'mareorum', 'marorum'],
      reponseCorrecte: 'marium',
    ),
    QuestionLecon(
      question:
          'Quel est le génitif pluriel du modèle corpus (neutre standard) ?',
      options: ['corporum', 'corporium', 'corpusum', 'corporarum'],
      reponseCorrecte: 'corporum',
    ),
    QuestionLecon(
      question:
          'Que sont les « faux parisyllabiques », comme pater ou mater ?',
      options: [
        'des parisyllabiques dont le génitif pluriel est en -um, comme '
            'les imparisyllabiques',
        'des imparisyllabiques dont le génitif pluriel est en -ium',
        'des noms neutres AREAL',
        'des noms défectifs',
      ],
      reponseCorrecte:
          'des parisyllabiques dont le génitif pluriel est en -um, comme '
          'les imparisyllabiques',
    ),
    QuestionLecon(
      question:
          'Que sont les « faux imparisyllabiques », comme urbs ou mons ?',
      options: [
        'd\'anciens parisyllabiques monosyllabiques, dont le génitif '
            'pluriel est en -ium',
        'des parisyllabiques dont le génitif pluriel est en -um',
        'des noms neutres AREAL',
        'des noms de la 2e déclinaison',
      ],
      reponseCorrecte:
          'd\'anciens parisyllabiques monosyllabiques, dont le génitif '
          'pluriel est en -ium',
    ),
    QuestionLecon(
      question:
          'Quelle particularité présente le nom défectif vis, f. (force, '
          'violence) ?',
      options: [
        'son radical est différent au pluriel (vires, virium)',
        'il n\'a pas de pluriel',
        'il ne se décline qu\'au génitif',
        'il est neutre',
      ],
      reponseCorrecte: 'son radical est différent au pluriel (vires, virium)',
    ),
    ExerciceSaisie(
      question: 'Quel est le radical de rex, regis (le roi) ?',
      reponsesAcceptees: ['reg-', 'reg'],
    ),
    ExerciceSaisie(
      question: 'Quel est le génitif pluriel de civis, is (le citoyen) ?',
      reponsesAcceptees: ['civium'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        '• Comme civis : les parisyllabiques (même nombre de syllabes '
        'au nom. et au gén.).\n'
        '• Comme rex : les imparisyllabiques (nombre de syllabes '
        'différent).\n'
        '• Comme corpus : les neutres réguliers.\n'
        '• Comme mare : les neutres AREAL (nominatif en -ar, -e, -al).\n\n'
        'Exceptions au génitif pluriel :\n'
        '• pater, mater, frater, juvenis, senex, canis → -um\n'
        '• urbs, fons, gens, mens, mons, pars (monosyllabiques) → -ium',
      ),
      tableauDeclinaison(declinaisons[5]),
      const SizedBox(height: 12),
      tableauDeclinaison(declinaisons[3]),
      const SizedBox(height: 12),
      tableauDeclinaison(declinaisons[4]),
      const SizedBox(height: 12),
      tableauDeclinaison(declinaisons[12]),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : L'indicatif parfait
// ------------------------------------------------------------

final Lecon _leconIndicatifParfait = Lecon(
  id: 'indicatif_parfait',
  titre: 'L\'indicatif parfait',
  sousTitre: 'Formation, 5 types de radicaux, traduction',
  icone: Icons.emoji_events,
  unite: 'Vol. I – Unité 7',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Le terme perfectum vient du verbe perficio, is, ere, -feci, '
      '-fectum, et signifie « faire complètement, achever ». Le '
      'parfait est donc le temps de l\'action achevée.',
    ),
    _titreExplication('La morphologie du parfait'),
    _paragrapheExplication(
      'La 4e forme des temps primitifs correspond à la 1re personne du '
      'singulier du verbe à l\'indicatif parfait. On en déduit le '
      'radical du perfectum (ou radical du passé) en enlevant la '
      'terminaison -i.\n\n'
      'Ex. : amo, as, are, amavi, amatum → radical du perfectum : amav-',
    ),
    _paragrapheExplication(
      'Formation du parfait : radical du perfectum + terminaisons -i, '
      '-isti, -it, -imus, -istis, -erunt.',
    ),
    _tableauColonnes(
      ['pers.', 'amare (amav-)', 'mittere (mis-)'],
      [
        ['je', 'amavi', 'misi'],
        ['tu', 'amavisti', 'misisti'],
        ['il / elle', 'amavit', 'misit'],
        ['nous', 'amavimus', 'misimus'],
        ['vous', 'amavistis', 'misistis'],
        ['ils / elles', 'amaverunt', 'miserunt'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'La formation du parfait des verbes irréguliers, comme esse et '
      'ses composés, est identique à celle des verbes réguliers : sum, '
      'es, esse, fui → fui, fuisti, fuit... ; possum, potui → potui, '
      'potuisti... ; prosum, profui → profui...',
    ),
    _titreExplication('Les 5 types de formation du parfait'),
    _paragrapheExplication(
      'Le radical du parfait des verbes de la 1re conjugaison est '
      'généralement en -v- (amavi), mais il existe des exceptions, '
      'comme les parfaits à redoublement (ex. : sto, stare, steti).\n\n'
      'Le radical du parfait des verbes de la 2e conjugaison est '
      'souvent en -u- (monui), mais on trouve également des parfaits '
      'en -s- (ex. : maneo, mansi).\n\n'
      'Le radical du parfait des verbes de la 5e conjugaison est '
      'souvent en -v- à voyelle longue (audivi), mais on trouve aussi '
      'des parfaits syncopés à voyelle longue seule (audii).\n\n'
      'Le radical du parfait des verbes des 3e et 4e conjugaisons est '
      'très différent d\'un verbe à l\'autre : il faut l\'apprendre '
      'avec le vocabulaire.',
    ),
    _paragrapheExplication(
      'On distingue ainsi 5 types de formation du parfait latin : les '
      'radicaux en -v, en -u, en -s, à redoublement, et à voyelle '
      'longue.',
    ),
    _titreExplication('Quelques particularités de la conjugaison au parfait'),
    _paragrapheExplication(
      '• À la 3e personne du pluriel, on trouve souvent la terminaison '
      '-ere au lieu de -erunt (fuere pour fuerunt).\n\n'
      '• Les parfaits en -avi, -evi, -ivi et -ovi peuvent être syncopés '
      '(le -v- et même -vi- ou -ve- disparaissent) : scivit ou sciit ; '
      'audivit ou audiit.\n\n'
      '• Le latin possède des verbes qui n\'existent qu\'au temps du '
      'parfait et que le français traduit par un présent, comme '
      'memini, « je me souviens ».',
    ),
    _titreExplication('La traduction du parfait'),
    _paragrapheExplication(
      'Un parfait latin peut être traduit par trois temps français : le '
      'passé simple, le passé antérieur ou le passé composé. L\'emploi '
      'du temps en français dépend du contexte.',
    ),
    _tableauColonnes(
      ['contexte', 'temps français'],
      [
        ['discours direct, action terminée', 'passé composé'],
        [
          'récit : actions soudaines, ponctuelles ou une succession '
              'd\'actions terminées',
          'passé simple',
        ],
        [
          'subordonnée circonstancielle de temps introduite par '
              'postquam (« après que »), antériorité',
          'passé antérieur (ou plus-que-parfait si la principale est '
              'au passé composé)',
        ],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Que signifie perfectum ?',
      options: [
        'faire complètement, achever',
        'commencer',
        'répéter',
        'continuer'
      ],
      reponseCorrecte: 'faire complètement, achever',
    ),
    QuestionLecon(
      question:
          'Comment obtient-on le radical du perfectum à partir des temps '
          'primitifs ?',
      options: [
        'en enlevant la terminaison -i de la 4e forme',
        'en enlevant la terminaison -re de l\'infinitif',
        'en ajoutant -i au radical du présent',
        'le radical du perfectum est toujours identique au présent',
      ],
      reponseCorrecte: 'en enlevant la terminaison -i de la 4e forme',
    ),
    QuestionLecon(
      question:
          'Quelles sont les terminaisons de l\'indicatif parfait actif ?',
      options: [
        '-i, -isti, -it, -imus, -istis, -erunt',
        '-o, -s, -t, -mus, -tis, -nt',
        '-m, -s, -t, -mus, -tis, -nt',
        '-am, -es, -et, -emus, -etis, -ent',
      ],
      reponseCorrecte: '-i, -isti, -it, -imus, -istis, -erunt',
    ),
    QuestionLecon(
      question: 'Quelle est la 3e personne du singulier de mittere au parfait ?',
      options: ['misit', 'mittit', 'miserat', 'mittet'],
      reponseCorrecte: 'misit',
    ),
    QuestionLecon(
      question:
          'Comment se forme le parfait des verbes irréguliers comme '
          'esse ?',
      options: [
        'de la même façon que les verbes réguliers',
        'il n\'existe pas de parfait pour esse',
        'avec une terminaison spéciale, différente des autres verbes',
        'seulement au singulier',
      ],
      reponseCorrecte: 'de la même façon que les verbes réguliers',
    ),
    QuestionLecon(
      question: 'Quels sont les 5 types de radicaux du parfait latin ?',
      options: [
        'en -v, en -u, en -s, à redoublement, à voyelle longue',
        'en -o, -e, -i, -a, -u',
        'présent, imparfait, futur, parfait, plus-que-parfait',
        'actif, passif, déponent, semi-déponent, défectif',
      ],
      reponseCorrecte: 'en -v, en -u, en -s, à redoublement, à voyelle longue',
    ),
    QuestionLecon(
      question:
          'Quelle terminaison de 3e pers. du pluriel trouve-t-on parfois '
          'à la place de -erunt ?',
      options: ['-ere', '-unt', '-ent', '-erint'],
      reponseCorrecte: '-ere',
    ),
    QuestionLecon(
      question:
          'Comment traduit-on l\'indicatif parfait latin dans un discours '
          'direct, pour une action terminée ?',
      options: ['par un passé composé', 'par un passé simple', 'par un imparfait', 'par un présent'],
      reponseCorrecte: 'par un passé composé',
    ),
    QuestionLecon(
      question:
          'Comment traduit-on généralement l\'indicatif parfait latin '
          'dans un récit, pour des actions soudaines ou une succession '
          'd\'actions ?',
      options: ['par un passé simple', 'par un passé composé', 'par un imparfait', 'par un futur'],
      reponseCorrecte: 'par un passé simple',
    ),
    QuestionLecon(
      question:
          'Dans une subordonnée introduite par postquam (« après que »), '
          'exprimant l\'antériorité, comment traduit-on le parfait '
          'latin ?',
      options: [
        'par un passé antérieur',
        'par un passé composé',
        'par un imparfait',
        'par un conditionnel',
      ],
      reponseCorrecte: 'par un passé antérieur',
    ),
    ExerciceSaisie(
      question: 'Conjugue amare à la 1re personne du singulier de l\'indicatif parfait (j\'ai aimé).',
      reponsesAcceptees: ['amavi'],
    ),
    ExerciceSaisie(
      question:
          'Conjugue mittere à la 3e personne du pluriel de l\'indicatif '
          'parfait (ils ont envoyé).',
      reponsesAcceptees: ['miserunt', 'misere'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Parfait = radical du perfectum (4e temps primitif − -i) + -i, '
        '-isti, -it, -imus, -istis, -erunt.',
      ),
      _tableauColonnes(
        ['contexte', 'temps français'],
        [
          ['discours direct', 'passé composé'],
          ['récit', 'passé simple'],
          ['postquam + parfait', 'passé antérieur'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : L'infinitif parfait et l'ACI
// ------------------------------------------------------------

final Lecon _leconInfinitifParfaitACI = Lecon(
  id: 'infinitif_parfait_aci',
  titre: 'L\'infinitif parfait et l\'ACI',
  sousTitre: 'Formation, antériorité dans la proposition infinitive',
  icone: Icons.nightlight_round,
  unite: 'Vol. I – Unité 7',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Dans une phrase comme « Nicéros se retourna vers son compagnon, '
      'et vit qu\'il s\'était déshabillé et avait posé ses vêtements '
      'sur le bord de la route », le verbe vidit (« il vit ») introduit '
      'une proposition infinitive (ACI), et les verbes latins exuisse '
      'et posuisse sont à l\'infinitif parfait.',
    ),
    _titreExplication('La formation de l\'infinitif parfait'),
    _paragrapheExplication(
      'L\'infinitif parfait se forme ainsi : radical du perfectum + '
      '-isse.',
    ),
    _tableauColonnes(
      ['infinitif parfait', 'traduction'],
      [
        ['amavisse', 'avoir aimé'],
        ['monuisse', 'avoir averti'],
        ['misisse', 'avoir envoyé'],
        ['fuisse', 'avoir été'],
        ['potuisse', 'avoir pu'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Tu trouveras surtout l\'infinitif parfait dans la proposition '
      'infinitive (ACI).\n\n'
      'Ex. : Scio [filium tuum venisse]. (Je sais que ton fils est '
      'venu.)\n'
      'Sciebam [filium tuum venisse]. (Je savais que ton fils était '
      'venu.)',
    ),
    _titreExplication('L\'antériorité dans l\'ACI'),
    _paragrapheExplication(
      'Quand l\'action de la subordonnée se déroule avant l\'action de '
      'la principale, ce rapport de temps est appelé l\'antériorité '
      '(en latin, ante signifie « avant »). Pour exprimer l\'antériorité '
      'dans l\'ACI, le latin utilise l\'infinitif parfait.',
    ),
    _paragrapheExplication(
      'En français, il faut appliquer la concordance des temps. '
      'N\'oublie pas qu\'en français, le subjonctif s\'utilise après des '
      'verbes de volonté (ordonner que) et de souhait (désirer que).',
    ),
    _tableauColonnes(
      ['verbe introducteur', 'subordonnée française (antériorité)'],
      [
        ['temps du présent (ex. scio, « je sais »)', 'passé composé'],
        [
          'temps du passé (ex. sciebam, « je savais »)',
          'plus-que-parfait',
        ],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Comment se forme l\'infinitif parfait ?',
      options: [
        'radical du perfectum + -isse',
        'radical du présent + -isse',
        'radical du perfectum + -re',
        'radical du supin + -isse',
      ],
      reponseCorrecte: 'radical du perfectum + -isse',
    ),
    QuestionLecon(
      question: 'Quel est l\'infinitif parfait de amare (radical amav-) ?',
      options: ['amavisse', 'amare', 'amavi', 'amaturum esse'],
      reponseCorrecte: 'amavisse',
    ),
    QuestionLecon(
      question: 'Quel est l\'infinitif parfait de esse (radical fu-) ?',
      options: ['fuisse', 'esse', 'fui', 'futurum esse'],
      reponseCorrecte: 'fuisse',
    ),
    QuestionLecon(
      question: 'Dans quel type de construction trouve-t-on surtout l\'infinitif parfait ?',
      options: [
        'la proposition infinitive (ACI)',
        'la proposition relative',
        'le supin',
        'l\'impératif',
      ],
      reponseCorrecte: 'la proposition infinitive (ACI)',
    ),
    QuestionLecon(
      question: 'Quel rapport de temps l\'infinitif parfait exprime-t-il dans l\'ACI ?',
      options: ['l\'antériorité', 'la simultanéité', 'la postériorité', 'aucun rapport de temps'],
      reponseCorrecte: 'l\'antériorité',
    ),
    QuestionLecon(
      question:
          'Si le verbe introducteur est au présent (ex. scio, « je '
          'sais »), comment se traduit un infinitif parfait exprimant '
          'l\'antériorité ?',
      options: ['par un passé composé', 'par un présent', 'par un imparfait', 'par un futur'],
      reponseCorrecte: 'par un passé composé',
    ),
    QuestionLecon(
      question:
          'Si le verbe introducteur est au passé (ex. sciebam, « je '
          'savais »), comment se traduit un infinitif parfait exprimant '
          'l\'antériorité ?',
      options: ['par un plus-que-parfait', 'par un passé composé', 'par un présent', 'par un futur'],
      reponseCorrecte: 'par un plus-que-parfait',
    ),
    ExerciceSaisie(
      question: 'Quel est l\'infinitif parfait de mittere (radical mis-) ?',
      reponsesAcceptees: ['misisse'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Infinitif parfait : radical du perfectum + -isse. Dans l\'ACI, '
        'il exprime l\'antériorité (l\'action de la subordonnée '
        'précède celle de la principale).',
      ),
      _tableauColonnes(
        ['verbe introducteur', 'subordonnée française'],
        [
          ['temps du présent', 'passé composé'],
          ['temps du passé', 'plus-que-parfait'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les adjectifs de la 2e classe
// ------------------------------------------------------------

final Lecon _leconAdjectifs2eClasse = Lecon(
  id: 'adj_2e_classe',
  titre: 'Les adjectifs de la 2e classe',
  sousTitre: 'fortis, e — felix, felicis — acer, acris, acre',
  icone: Icons.diamond,
  unite: 'Vol. I – Unité 8',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('Je me rappelle'),
    _paragrapheExplication(
      'Les adjectifs de la 1re classe sont regroupés en 3 types : bonus, '
      'bona, bonum ; miser, misera, miserum ; pulcher, pulchra, '
      'pulchrum. L\'adjectif s\'accorde en genre, nombre et cas avec le '
      'nom auquel il se rapporte. S\'il ne détermine pas un nom, il est '
      'substantivé, utilisé comme un nom.',
    ),
    _titreExplication('Les 3 types d\'adjectifs de la 2e classe'),
    _paragrapheExplication(
      'Les adjectifs de la 2e classe se présentent dans le lexique avec '
      'une, deux ou trois formes différentes au nominatif, selon qu\'ils '
      'distinguent ou non des formes différentes pour le masculin, le '
      'féminin et le neutre :\n\n'
      '• 1 forme au nominatif (les 3 genres confondus), comme felix, '
      'felicis (heureux) : le radical se déduit du génitif, felic-.\n\n'
      '• 2 formes différentes au nominatif, comme fortis, e (courageux) '
      ': fortis au masculin et au féminin, forte au neutre. Le radical '
      'est fort-.\n\n'
      '• 3 formes différentes au nominatif, comme acer, acris, acre '
      '(vif, ardent) : acer au masculin, acris au féminin, acre au '
      'neutre. Le radical se déduit du féminin, acr-.',
    ),
    _paragrapheExplication(
      'La plupart des adjectifs de la 2e classe suivent la 3e '
      'déclinaison :\n\n'
      '• des noms parisyllabiques au masculin et au féminin (modèle '
      'civis), mais ils ont un ablatif singulier en -i (et non -e comme '
      'le nom civis).\n'
      '• des noms AREAL au neutre.\n\n'
      'On obtient leur radical en enlevant la terminaison -is au '
      'génitif singulier, ou -is au féminin singulier.',
    ),
    _titreExplication('Le type fortis, e'),
    _tableauColonnes(
      ['cas', 'm. / f.', 'n.'],
      [
        ['nom. (sg.)', 'fortis', 'forte'],
        ['acc. (sg.)', 'fortem', 'forte'],
        ['gén. (sg.)', 'fortis', 'fortis'],
        ['dat. (sg.)', 'forti', 'forti'],
        ['abl. (sg.)', 'forti', 'forti'],
        ['nom. (pl.)', 'fortes', 'fortia'],
        ['acc. (pl.)', 'fortes', 'fortia'],
        ['gén. (pl.)', 'fortium', 'fortium'],
        ['dat./abl. (pl.)', 'fortibus', 'fortibus'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Les adjectifs en -ax, -ex, -ix, -ox (type felix)'),
    _paragrapheExplication(
      'Ces adjectifs n\'ont qu\'une forme au nominatif pour les 3 '
      'genres, mais se déclinent comme le type fortis (radical déduit '
      'du génitif). Ex. : ferox, ferocis (farouche, radical feroc-).',
    ),
    _titreExplication('Les adjectifs en -ns, -ntis (type ingens)'),
    _paragrapheExplication(
      'Ex. : ingens, ingentis (énorme, immense). Ces adjectifs ont '
      'l\'ablatif singulier en -i ou -e.',
    ),
    _titreExplication(
      'Exceptions : les adjectifs imparisyllabiques (type consul/scelus)',
    ),
    _paragrapheExplication(
      'Quelques adjectifs (dives, pauper, vetus, juvenis, princeps) ne '
      'suivent pas le modèle civis/mare, mais se déclinent comme les '
      'noms imparisyllabiques consul et scelus : ablatif singulier en '
      '-e (et non -i) et génitif pluriel en -um (et non -ium).',
    ),
    _tableauColonnes(
      ['cas', 'm. / f. (pauper)', 'n. (pauper)'],
      [
        ['nom. (sg.)', 'pauper', 'pauper'],
        ['acc. (sg.)', 'pauperem', 'pauper'],
        ['gén. (sg.)', 'pauperis', 'pauperis'],
        ['dat. (sg.)', 'pauperi', 'pauperi'],
        ['abl. (sg.)', 'paupere', 'paupere'],
        ['nom. (pl.)', 'pauperes', 'paupera'],
        ['acc. (pl.)', 'pauperes', 'paupera'],
        ['gén. (pl.)', 'pauperum', 'pauperum'],
        ['dat./abl. (pl.)', 'pauperibus', 'pauperibus'],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'Combien de formes différentes felix, felicis a-t-il au '
          'nominatif ?',
      options: ['1', '2', '3', '4'],
      reponseCorrecte: '1',
    ),
    QuestionLecon(
      question:
          'Combien de formes différentes fortis, e a-t-il au nominatif ?',
      options: ['2', '1', '3', '4'],
      reponseCorrecte: '2',
    ),
    QuestionLecon(
      question:
          'Combien de formes différentes acer, acris, acre a-t-il au '
          'nominatif ?',
      options: ['3', '1', '2', '4'],
      reponseCorrecte: '3',
    ),
    QuestionLecon(
      question:
          'Pour un adjectif comme felix, felicis, à partir de quelle '
          'forme déduit-on le radical ?',
      options: ['le génitif', 'le nominatif masculin', 'le féminin', 'le neutre pluriel'],
      reponseCorrecte: 'le génitif',
    ),
    QuestionLecon(
      question:
          'Pour un adjectif comme acer, acris, acre, à partir de quelle '
          'forme déduit-on le radical ?',
      options: ['le féminin', 'le masculin', 'le neutre', 'le génitif pluriel'],
      reponseCorrecte: 'le féminin',
    ),
    QuestionLecon(
      question:
          'Quelle est la principale différence entre un adjectif comme '
          'fortis (2e classe) et un nom comme civis, à l\'ablatif '
          'singulier ?',
      options: [
        'l\'adjectif a -i, le nom civis a -e',
        'l\'adjectif a -e, le nom civis a -i',
        'il n\'y a aucune différence',
        'l\'adjectif n\'a pas d\'ablatif',
      ],
      reponseCorrecte: 'l\'adjectif a -i, le nom civis a -e',
    ),
    QuestionLecon(
      question: 'Quel est le génitif pluriel de fortis, e ?',
      options: ['fortium', 'fortum', 'fortorum', 'fortarum'],
      reponseCorrecte: 'fortium',
    ),
    QuestionLecon(
      question:
          'Quels adjectifs se déclinent comme les noms imparisyllabiques '
          'consul/scelus, avec un ablatif singulier en -e et un génitif '
          'pluriel en -um ?',
      options: [
        'dives, pauper, vetus, juvenis, princeps',
        'fortis, omnis, nobilis',
        'felix, ferox',
        'ingens, differens',
      ],
      reponseCorrecte: 'dives, pauper, vetus, juvenis, princeps',
    ),
    QuestionLecon(
      question: 'Quel est l\'ablatif singulier de pauper (exception) ?',
      options: ['paupere', 'pauperi', 'pauperis', 'pauperum'],
      reponseCorrecte: 'paupere',
    ),
    QuestionLecon(
      question: 'Quel est le génitif pluriel de pauper (exception) ?',
      options: ['pauperum', 'pauperium', 'paupericorum', 'pauperorum'],
      reponseCorrecte: 'pauperum',
    ),
    ExerciceSaisie(
      question:
          'Quel est le radical de ferox, ferocis (farouche) ? (à partir '
          'du génitif)',
      reponsesAcceptees: ['feroc-', 'feroc'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        '3 types au nominatif : 1 forme (felix, felicis), 2 formes '
        '(fortis, e), 3 formes (acer, acris, acre).\n\n'
        'La plupart suivent le modèle civis/mare (mais ablatif '
        'singulier en -i pour les adjectifs m./f.).\n\n'
        'Exceptions (comme consul/scelus, abl. sg. -e, gén. pl. -um) : '
        'dives, pauper, vetus, juvenis, princeps.',
      ),
      _tableauColonnes(
        ['cas', 'm. / f.', 'n.'],
        [
          ['nom. (sg.)', 'fortis', 'forte'],
          ['gén. (sg.)', 'fortis', 'fortis'],
          ['abl. (sg.)', 'forti', 'forti'],
          ['nom. (pl.)', 'fortes', 'fortia'],
          ['gén. (pl.)', 'fortium', 'fortium'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Le participe présent actif
// ------------------------------------------------------------

final Lecon _leconParticipePresentActif = Lecon(
  id: 'participe_present_actif',
  titre: 'Le participe présent actif',
  sousTitre: 'Formation « mixte », traduction, apposition au sujet',
  icone: Icons.bolt,
  unite: 'Vol. I – Unité 8',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Le participe présent latin s\'accorde en genre, nombre et cas '
      'avec le nom auquel il se rapporte. Il exprime toujours une '
      'action simultanée au(x) verbe(s) conjugué(s) de la phrase, et '
      'peut exprimer d\'autres circonstances, comme la cause.',
    ),
    _titreExplication('La formation du participe présent actif'),
    _paragrapheExplication(
      'Radical du présent + -ns, -ntis, avec la voyelle d\'ajout -e- '
      'aux 3e, 4e et 5e conjugaisons. Les terminaisons sont celles des '
      'adjectifs de la 2e classe, sauf à l\'ablatif singulier : -e.',
    ),
    _paragrapheExplication(
      'Le participe présent actif se caractérise donc par une '
      'formation « mixte » :\n\n'
      '• ablatif singulier (m./f./n.) en -e\n'
      '• nominatif/vocatif/accusatif pluriel (neutre) en -ia\n'
      '• génitif pluriel (m./f./n.) en -ium',
    ),
    _titreExplication('pugnans, -ntis « combattant »'),
    _tableauColonnes(
      ['cas', 'm. / f.', 'n.'],
      [
        ['nom. (sg.)', 'pugnans', 'pugnans'],
        ['acc. (sg.)', 'pugnantem', 'pugnans'],
        ['gén. (sg.)', 'pugnantis', 'pugnantis'],
        ['dat. (sg.)', 'pugnanti', 'pugnanti'],
        ['abl. (sg.)', 'pugnante', 'pugnante'],
        ['nom. (pl.)', 'pugnantes', 'pugnantia'],
        ['acc. (pl.)', 'pugnantes', 'pugnantia'],
        ['gén. (pl.)', 'pugnantium', 'pugnantium'],
        ['dat./abl. (pl.)', 'pugnantibus', 'pugnantibus'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('La traduction du participe présent actif'),
    _paragrapheExplication(
      'En français, pour alléger la syntaxe, on peut remplacer le '
      'participe présent par la tournure « qui + simultanéité » (ceci '
      'ne vaut pas pour le participe présent utilisé comme verbe de '
      'l\'ablatif absolu, que tu apprendras plus tard).\n\n'
      'Par ailleurs, derrière des verbes exprimant la perception (voir, '
      'entendre, écouter...), le français utilise un infinitif là où '
      'le latin utilise le participe présent.\n\n'
      'Ex. : Video puerum ludentem. (Je vois l\'enfant qui joue / Je '
      'vois l\'enfant jouer.)',
    ),
    _titreExplication('Le participe présent, apposition au sujet'),
    _paragrapheExplication(
      'Comme le participe parfait passif, le participe présent actif '
      'peut être utilisé comme apposition au sujet. Une traduction '
      'littérale en français est alors possible, avec un gérondif '
      '(« en » + participe présent).\n\n'
      'Ex. : Bene pugnantes, milites a ducibus laudabantur. (Combattant '
      'bien / En combattant bien, les soldats étaient loués par leurs '
      'chefs.)\n'
      'Iter per Italiam facientes, pulchras urbes vidimus. (En faisant '
      'route à travers l\'Italie, nous avons vu de belles villes.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Comment se forme le participe présent actif ?',
      options: [
        'radical du présent + -ns, -ntis',
        'radical du perfectum + -ns, -ntis',
        'radical du présent + -ndus, -nda, -ndum',
        'radical du supin + -ns, -ntis',
      ],
      reponseCorrecte: 'radical du présent + -ns, -ntis',
    ),
    QuestionLecon(
      question:
          'Quelle est la particularité du participe présent à l\'ablatif '
          'singulier, par rapport aux autres adjectifs de la 2e classe ?',
      options: [
        'il se termine en -e (au lieu de -i)',
        'il se termine en -i (comme les autres)',
        'il n\'a pas d\'ablatif singulier',
        'il se termine en -o',
      ],
      reponseCorrecte: 'il se termine en -e (au lieu de -i)',
    ),
    QuestionLecon(
      question: 'Quelle action le participe présent exprime-t-il toujours ?',
      options: [
        'une action simultanée au(x) verbe(s) conjugué(s)',
        'une action antérieure',
        'une action postérieure',
        'une action achevée',
      ],
      reponseCorrecte: 'une action simultanée au(x) verbe(s) conjugué(s)',
    ),
    QuestionLecon(
      question: 'Quel est le génitif pluriel de pugnans, -ntis ?',
      options: ['pugnantium', 'pugnantum', 'pugnantorum', 'pugnansium'],
      reponseCorrecte: 'pugnantium',
    ),
    QuestionLecon(
      question:
          'Derrière un verbe de perception (voir, entendre...), que '
          'utilise le français là où le latin utilise le participe '
          'présent ?',
      options: ['un infinitif', 'un gérondif', 'un subjonctif', 'un supin'],
      reponseCorrecte: 'un infinitif',
    ),
    QuestionLecon(
      question:
          'Quand le participe présent est apposé au sujet, quelle '
          'traduction littérale est possible en français ?',
      options: [
        'un gérondif (« en » + participe présent)',
        'un infinitif',
        'un subjonctif',
        'un supin',
      ],
      reponseCorrecte: 'un gérondif (« en » + participe présent)',
    ),
    ExerciceSaisie(
      question:
          'Forme le participe présent (nominatif singulier) de amare '
          '(radical ama-).',
      reponsesAcceptees: ['amans'],
    ),
    ExerciceSaisie(
      question:
          'Forme le participe présent (nominatif singulier) de mittere '
          '(radical mitt-, avec voyelle d\'ajout).',
      reponsesAcceptees: ['mittens'],
      indice: 'La 3e conjugaison prend la voyelle d\'ajout -e-.',
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Participe présent actif = radical du présent (+ voyelle '
        'd\'ajout -e- aux 3e/4e/5e conj.) + -ns, -ntis.\n\n'
        'Formation mixte : abl. sg. en -e ; nom./voc./acc. pl. (n.) en '
        '-ia ; gén. pl. en -ium.',
      ),
      _tableauColonnes(
        ['cas', 'm. / f.', 'n.'],
        [
          ['nom. (sg.)', 'pugnans', 'pugnans'],
          ['abl. (sg.)', 'pugnante', 'pugnante'],
          ['nom. (pl.)', 'pugnantes', 'pugnantia'],
          ['gén. (pl.)', 'pugnantium', 'pugnantium'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Le comparatif et le superlatif
// ------------------------------------------------------------

final Lecon _leconComparatifSuperlatif = Lecon(
  id: 'comparatif_superlatif',
  titre: 'Le comparatif et le superlatif',
  sousTitre: 'Formation régulière et irrégulière, sens et traductions',
  icone: Icons.military_tech,
  unite: 'Vol. I – Unité 8',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('La morphologie du comparatif'),
    _paragrapheExplication(
      'Radical de l\'adjectif + -ior, -ior, -ius. Le comparatif se '
      'décline comme l\'adjectif dives de la 2e classe (c\'est-à-dire '
      'comme le type imparisyllabique, avec exception) : ablatif '
      'singulier en -e, nominatif/vocatif/accusatif neutre pluriel en '
      '-a, génitif pluriel en -um.',
    ),
    _tableauColonnes(
      ['cas', 'm. / f. (fortior)', 'n. (fortius)'],
      [
        ['nom. (sg.)', 'fortior', 'fortius'],
        ['acc. (sg.)', 'fortiorem', 'fortius'],
        ['gén. (sg.)', 'fortioris', 'fortioris'],
        ['dat. (sg.)', 'fortiori', 'fortiori'],
        ['abl. (sg.)', 'fortiore', 'fortiore'],
        ['nom. (pl.)', 'fortiores', 'fortiora'],
        ['acc. (pl.)', 'fortiores', 'fortiora'],
        ['gén. (pl.)', 'fortiorum', 'fortiorum'],
        ['dat./abl. (pl.)', 'fortioribus', 'fortioribus'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('La morphologie du superlatif'),
    _paragrapheExplication(
      '1. La formation régulière : radical de l\'adjectif + -issimus, '
      '-issima, -issimum. Le superlatif se décline comme un adjectif de '
      'la 1re classe (bonus, a, um). Contrairement à l\'italien, où le '
      'superlatif est formé régulièrement en -issimo/a, le français '
      'n\'en retient que quelques rares formes : richissime, rarissime, '
      'illustrissime, excellentissime, etc.\n\n'
      '2. Les adjectifs en -er ont un superlatif en -errimus, -errima, '
      '-errimum : on remplace -er par -errimus (ex. : acer → '
      'acerrimus).\n\n'
      '3. Cinq adjectifs en -ilis (facilis, difficilis, similis, '
      'dissimilis, humilis) ont un superlatif en -illimus, -illima, '
      '-illimum : on remplace -ilis par -illimus.',
    ),
    _titreExplication('Les comparatifs et superlatifs irréguliers'),
    _paragrapheExplication(
      'Quelques adjectifs forment des comparatifs et superlatifs '
      'irréguliers, à apprendre par cœur. Heureusement, ces formes '
      'latines sont faciles à retenir, car elles rappellent des mots '
      'français que tu connais bien.',
    ),
    _tableauColonnes(
      ['adjectif', 'comparatif', 'superlatif'],
      [
        ['bonus, a, um (bon)', 'melior, ior, ius (meilleur)', 'optimus, a, um (le meilleur)'],
        ['malus, a, um (mauvais)', 'pejor, jor, jus (pire)', 'pessimus, a, um (le pire)'],
        ['magnus, a, um (grand)', 'major, jor, jus (plus grand)', 'maximus, a, um (le plus grand)'],
        ['parvus, a, um (petit)', 'minor, or, us (plus petit)', 'minimus, a, um (le plus petit)'],
        [
          'propinquus, a, um (proche)',
          'propior, ior, ius (plus proche)',
          'proximus, a, um (le plus proche)',
        ],
        [
          'multi, ae, a (nombreux)',
          'plures, es, a (génitif irrégulier : plurium)',
          'plurimi, ae, a (les plus nombreux)',
        ],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Le sens et les traductions du comparatif'),
    _paragrapheExplication(
      '1. Le comparatif employé avec un complément introduit une '
      'subordonnée de comparaison qui, le plus souvent, est elliptique '
      '(le verbe est sous-entendu). Le complément, introduit par la '
      'conjonction quam, n\'est donc qu\'un nom ou un pronom qui se met '
      'au cas voulu par la subordonnée elliptique.\n'
      'Ex. : Paulus superbior est quam Petrus (est). (Paul est plus '
      'orgueilleux que Pierre.)\n\n'
      'Un comparatif au nominatif ou à l\'accusatif peut aussi avoir un '
      'complément à l\'ablatif (ablatif de comparaison).\n'
      'Ex. : Paulus superbior est Petro. (même sens.)\n\n'
      'Si le complément est un verbe, celui-ci est fréquemment exprimé.\n'
      'Ex. : Melior es quam putas. (Tu es meilleur que tu ne le '
      'penses.)',
    ),
    _paragrapheExplication(
      '2. Le comparatif employé seul (sans complément) a, selon le '
      'contexte, des sens différents : ASSEZ, TROP ou '
      'PARTICULIÈREMENT + adjectif.\n'
      'Ex. : Paulus superbior est. (Paul est assez / trop / '
      'particulièrement orgueilleux.)\n\n'
      '3. Pour exprimer le comparatif d\'infériorité, le latin utilise '
      'la tournure minus + adjectif... quam, qui se traduit par '
      '« moins + adjectif... que ».\n'
      'Ex. : Minus egregius fuisti quam pater. (Tu as été moins '
      'remarquable que ton père.)\n\n'
      '4. Pour exprimer le comparatif d\'égalité, le latin utilise la '
      'tournure tam + adjectif... quam, qui se traduit par « aussi + '
      'adjectif... que ».\n'
      'Ex. : Tam egregius fuisti quam pater. (Tu as été aussi '
      'remarquable que ton père.)',
    ),
    _titreExplication('Le sens et les traductions du superlatif'),
    _paragrapheExplication(
      '1. Un superlatif employé avec un complément est un superlatif '
      'relatif, dont le complément est exprimé soit au génitif, soit '
      'avec e(x) + ablatif.\n'
      'Ex. : Fortissimus omnium / ex omnibus erat. (Il était le plus '
      'courageux de tous.)\n\n'
      'Nota bene : selon le contexte, le complément peut être '
      'sous-entendu.\n'
      'Ex. : Libertas maximum bonum est. (La liberté est le plus grand '
      'bien.)\n\n'
      '2. Le superlatif employé seul est, le plus souvent, un '
      'superlatif absolu et se traduit par « très + adjectif ».\n'
      'Ex. : Publius maximus est. (Publius est très grand.)\n\n'
      '3. Pour exprimer le superlatif d\'infériorité, le latin utilise '
      'la tournure minime + adjectif, qui se traduit par « le moins + '
      'adjectif » ou « très peu + adjectif ».\n'
      'Ex. : Socii minime fortes fuerunt in saeva pugna. (Les alliés '
      'furent très peu courageux dans la bataille féroce.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Comment se forme le comparatif ?',
      options: [
        'radical de l\'adjectif + -ior, -ior, -ius',
        'radical de l\'adjectif + -issimus, -issima, -issimum',
        'radical de l\'adjectif + -errimus',
        'radical du présent + -ns, -ntis',
      ],
      reponseCorrecte: 'radical de l\'adjectif + -ior, -ior, -ius',
    ),
    QuestionLecon(
      question: 'Comme quel type d\'adjectif le comparatif se décline-t-il ?',
      options: [
        'comme dives (type imparisyllabique)',
        'comme bonus (1re classe)',
        'comme fortis (type civis)',
        'il ne se décline pas',
      ],
      reponseCorrecte: 'comme dives (type imparisyllabique)',
    ),
    QuestionLecon(
      question: 'Quelle est la formation régulière du superlatif ?',
      options: [
        'radical de l\'adjectif + -issimus, -issima, -issimum',
        'radical de l\'adjectif + -ior, -ior, -ius',
        'radical de l\'adjectif + -ns, -ntis',
        'radical du perfectum + -issimus',
      ],
      reponseCorrecte: 'radical de l\'adjectif + -issimus, -issima, -issimum',
    ),
    QuestionLecon(
      question: 'Quel est le superlatif de acer (adjectif en -er) ?',
      options: ['acerrimus', 'acrissimus', 'acerissimus', 'acrilimus'],
      reponseCorrecte: 'acerrimus',
    ),
    QuestionLecon(
      question:
          'Quel est le superlatif de facilis (un des 5 adjectifs en '
          '-ilis) ?',
      options: ['facillimus', 'facilissimus', 'faciliorissimus', 'facerrimus'],
      reponseCorrecte: 'facillimus',
    ),
    QuestionLecon(
      question: 'Quel est le comparatif irrégulier de bonus ?',
      options: ['melior, ior, ius', 'pejor, jor, jus', 'major, jor, jus', 'optimus, a, um'],
      reponseCorrecte: 'melior, ior, ius',
    ),
    QuestionLecon(
      question: 'Quel est le superlatif irrégulier de magnus ?',
      options: ['maximus, a, um', 'major, jor, jus', 'minimus, a, um', 'optimus, a, um'],
      reponseCorrecte: 'maximus, a, um',
    ),
    QuestionLecon(
      question:
          'Quelle conjonction introduit le complément d\'un comparatif '
          '(« que ») ?',
      options: ['quam', 'ut', 'quod', 'cum'],
      reponseCorrecte: 'quam',
    ),
    QuestionLecon(
      question:
          'Quelle tournure exprime le comparatif d\'infériorité (« moins '
          '... que ») ?',
      options: ['minus + adjectif... quam', 'tam + adjectif... quam', 'minime + adjectif', 'magis + adjectif'],
      reponseCorrecte: 'minus + adjectif... quam',
    ),
    QuestionLecon(
      question:
          'Quelle tournure exprime le comparatif d\'égalité (« aussi ... '
          'que ») ?',
      options: ['tam + adjectif... quam', 'minus + adjectif... quam', 'minime + adjectif', 'quam + adjectif'],
      reponseCorrecte: 'tam + adjectif... quam',
    ),
    QuestionLecon(
      question:
          'Comment traduit-on généralement un comparatif employé seul, '
          'sans complément ?',
      options: [
        'par assez / trop / particulièrement + adjectif',
        'toujours par « plus » + adjectif',
        'par un superlatif',
        'il ne se traduit pas',
      ],
      reponseCorrecte: 'par assez / trop / particulièrement + adjectif',
    ),
    QuestionLecon(
      question: 'Comment traduit-on un superlatif employé seul (superlatif absolu) ?',
      options: ['par très + adjectif', 'par le plus + adjectif + de', 'par plus + adjectif', 'par assez + adjectif'],
      reponseCorrecte: 'par très + adjectif',
    ),
    QuestionLecon(
      question:
          'Quelle tournure exprime le superlatif d\'infériorité (« le '
          'moins... » / « très peu... ») ?',
      options: ['minime + adjectif', 'minus + adjectif... quam', 'tam + adjectif', 'maxime + adjectif'],
      reponseCorrecte: 'minime + adjectif',
    ),
    QuestionLecon(
      question:
          'Un superlatif relatif (avec complément) exprime son '
          'complément par quels moyens ?',
      options: [
        'le génitif ou e(x) + ablatif',
        'quam + nominatif',
        'l\'accusatif seul',
        'le datif',
      ],
      reponseCorrecte: 'le génitif ou e(x) + ablatif',
    ),
    ExerciceSaisie(
      question: 'Quel est le comparatif (m./f., nominatif singulier) de fortis (courageux) ?',
      reponsesAcceptees: ['fortior'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Comparatif : radical + -ior, -ior, -ius (décliné comme dives).\n'
        'Superlatif : radical + -issimus, -issima, -issimum (décliné '
        'comme bonus) ; -errimus pour les adjectifs en -er ; -illimus '
        'pour facilis, difficilis, similis, dissimilis, humilis.',
      ),
      _tableauColonnes(
        ['adjectif', 'comparatif', 'superlatif'],
        [
          ['bonus', 'melior, ior, ius', 'optimus, a, um'],
          ['malus', 'pejor, jor, jus', 'pessimus, a, um'],
          ['magnus', 'major, jor, jus', 'maximus, a, um'],
          ['parvus', 'minor, or, us', 'minimus, a, um'],
          ['propinquus', 'propior, ior, ius', 'proximus, a, um'],
          ['multi', 'plures, es, a', 'plurimi, ae, a'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'minus + adj... quam = moins... que\n'
        'tam + adj... quam = aussi... que\n'
        'minime + adj = le moins / très peu + adj\n'
        'superlatif seul = très + adj (superlatif absolu)',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Le supin et le participe parfait passif
// ------------------------------------------------------------

final Lecon _leconSupinPPP = Lecon(
  id: 'supin_ppp',
  titre: 'Le supin et le participe parfait passif',
  sousTitre: 'La 5e forme des temps primitifs, le PPP (radical + -us, -a, -um)',
  icone: Icons.workspace_premium,
  unite: 'Vol. I – Unité 9',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('Le supin'),
    _paragrapheExplication(
      'La 5e forme des temps primitifs est appelée le supin. Le supin '
      'est invariable.\n\n'
      'Ex. : amo, as, are, amavi, amatum → amatum est le supin.',
    ),
    _paragrapheExplication(
      'Après un verbe de mouvement (comme venire), le supin exprime le '
      'but.\n\n'
      'Ex. : Milites veniunt pugnatum. (Les soldats viennent pour '
      'combattre.)\n'
      'Romam petimus amicos visum. (Nous gagnons Rome pour voir nos '
      'amis.)',
    ),
    _titreExplication('Quelques remarques'),
    _paragrapheExplication(
      'Certains verbes n\'ont pas de supin (comme esse et ses '
      'composés). Il faut donc bien mémoriser les temps primitifs !',
    ),
    _paragrapheExplication(
      'En observant les temps primitifs des verbes déjà appris, on '
      'constate certaines habitudes :\n\n'
      '• 1re conjugaison : le supin est souvent en -atum (amatum).\n'
      '• 2e conjugaison : le supin est souvent en -itum (monitum), mais '
      'il existe des exceptions (manere, mansum ; respondere, '
      'responsum ; tenere, tentum ; videre, visum).\n'
      '• 5e conjugaison : le supin est souvent en -itum (auditum), mais '
      'il existe des exceptions (venire, ventum ; invenire, inventum).\n'
      '• Les 3e et 4e conjugaisons connaissent des formations diverses '
      '(ducere, ductum ; facere, factum ; capere, captum).',
    ),
    _titreExplication('Le participe parfait passif (PPP)'),
    _paragrapheExplication(
      'Le participe parfait passif correspond au participe passé '
      'français, mais il n\'a pas tout à fait les mêmes emplois. On '
      'peut le traduire par la forme « simple » (aimé, averti, envoyé) '
      'ou la forme « développée » (ayant été aimé, ayant été averti).',
    ),
    _paragrapheExplication(
      'Le PPP s\'obtient à partir du radical du supin. On obtient le '
      'radical du supin en lui enlevant la terminaison -um. On obtient '
      'le participe parfait passif en ajoutant -us, -a, -um au radical '
      'du supin. Le PPP se décline comme bonus, a, um.\n\n'
      'Ex. : amatum → amat- → amatus, a, um',
    ),
    _tableauColonnes(
      ['conjugaison', 'supin', 'PPP'],
      [
        ['1re', 'amatum', 'amatus, a, um'],
        ['2e', 'monitum', 'monitus, a, um'],
        ['3e', 'missum', 'missus, a, um'],
        ['4e', 'captum', 'captus, a, um'],
        ['5e', 'auditum', 'auditus, a, um'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Emploi du PPP : le participe apposé'),
    _paragrapheExplication(
      'Le participe parfait apposé se traduit par la forme « simple ». '
      'Il fonctionne comme un adjectif et s\'accorde donc en genre, '
      'nombre et cas avec le nom auquel il se rapporte.\n\n'
      'Ex. : consul auditus (le consul averti).',
    ),
    _paragrapheExplication(
      'Le PPP est un participe parfait PASSIF : de même que le verbe '
      'conjugué au passif, il peut avoir un complément du passif. '
      'N\'oublie pas de distinguer le complément d\'agent (a[b] + '
      'ablatif) et le complément de moyen (ablatif sans préposition).',
    ),
    _titreExplication('À quoi faut-il faire attention ?'),
    _paragrapheExplication(
      'Le participe et le mot auquel il se rapporte peuvent être '
      'éloignés l\'un de l\'autre. La place des mots en latin est '
      'certes plus libre qu\'en français, mais le latin aime former des '
      'ensembles grammaticalement et lexicalement liés : il intercale '
      'donc entre le mot et son PPP les éléments qui en dépendent.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quelle forme des temps primitifs est appelée le supin ?',
      options: ['la 5e forme', 'la 1re forme', 'la 3e forme', 'la 4e forme'],
      reponseCorrecte: 'la 5e forme',
    ),
    QuestionLecon(
      question: 'Le supin est...',
      options: ['invariable', 'variable en genre', 'variable en cas', 'variable en nombre'],
      reponseCorrecte: 'invariable',
    ),
    QuestionLecon(
      question: 'Que exprime le supin après un verbe de mouvement ?',
      options: ['le but', 'la cause', 'le moyen', 'le temps'],
      reponseCorrecte: 'le but',
    ),
    QuestionLecon(
      question: 'Quels verbes n\'ont pas de supin ?',
      options: ['esse et ses composés', 'tous les verbes de la 1re conjugaison', 'les verbes déponents', 'aucun verbe'],
      reponseCorrecte: 'esse et ses composés',
    ),
    QuestionLecon(
      question: 'Comment obtient-on le radical du supin ?',
      options: [
        'en enlevant la terminaison -um',
        'en enlevant la terminaison -i',
        'en ajoutant -us',
        'en gardant le mot tel quel',
      ],
      reponseCorrecte: 'en enlevant la terminaison -um',
    ),
    QuestionLecon(
      question: 'Comment obtient-on le participe parfait passif (PPP) ?',
      options: [
        'en ajoutant -us, -a, -um au radical du supin',
        'en ajoutant -ns, -ntis au radical du présent',
        'en ajoutant -isse au radical du perfectum',
        'en ajoutant -ior au radical de l\'adjectif',
      ],
      reponseCorrecte: 'en ajoutant -us, -a, -um au radical du supin',
    ),
    QuestionLecon(
      question: 'Comme quel adjectif le PPP se décline-t-il ?',
      options: ['bonus, a, um', 'fortis, e', 'dives, divitis', 'felix, felicis'],
      reponseCorrecte: 'bonus, a, um',
    ),
    QuestionLecon(
      question: 'Quel est le PPP de mittere (supin missum) ?',
      options: ['missus, a, um', 'mittens, -ntis', 'misisse', 'mittendus, a, um'],
      reponseCorrecte: 'missus, a, um',
    ),
    QuestionLecon(
      question:
          'Comment se traduit le participe parfait apposé (par ex. '
          'consul auditus) ?',
      options: [
        'par la forme simple (le consul averti)',
        'toujours par la forme développée (ayant été averti)',
        'par un infinitif',
        'il ne se traduit pas',
      ],
      reponseCorrecte: 'par la forme simple (le consul averti)',
    ),
    QuestionLecon(
      question:
          'Quelle construction exprime le complément d\'agent du PPP, '
          'quand il s\'agit d\'une personne ?',
      options: ['a(b) + ablatif', 'l\'ablatif seul', 'l\'accusatif', 'le datif'],
      reponseCorrecte: 'a(b) + ablatif',
    ),
    ExerciceSaisie(
      question: 'Quel est le PPP de amare (supin amatum) ?',
      reponsesAcceptees: ['amatus', 'amatus, a, um'],
    ),
    ExerciceSaisie(
      question: 'Quel est le PPP de audire (supin auditum) ?',
      reponsesAcceptees: ['auditus', 'auditus, a, um'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Supin = 5e forme des temps primitifs, invariable, exprime le '
        'but après un verbe de mouvement.\n\n'
        'PPP = radical du supin (− -um) + -us, -a, -um. Se décline '
        'comme bonus.',
      ),
      _tableauColonnes(
        ['conjugaison', 'supin', 'PPP'],
        [
          ['1re', 'amatum', 'amatus, a, um'],
          ['2e', 'monitum', 'monitus, a, um'],
          ['3e', 'missum', 'missus, a, um'],
          ['4e', 'captum', 'captus, a, um'],
          ['5e', 'auditum', 'auditus, a, um'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : L'ablatif absolu (AA)
// ------------------------------------------------------------

final Lecon _leconAblatifAbsolu = Lecon(
  id: 'ablatif_absolu',
  titre: 'L\'ablatif absolu (AA)',
  sousTitre: 'Sujet et participe à l\'ablatif, simultanéité et antériorité',
  icone: Icons.bubble_chart,
  unite: 'Vol. I – Unité 9',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Caesare bellum in Gallia gerente, multi Treveri interficiebantur. '
      '(César menant la guerre en Gaule, de nombreux Trévires étaient '
      'tués.)\n'
      'Indutiomaro victo, Treveri a Germanis auxilium petiverunt. '
      '(Indutiomaros ayant été vaincu, les Trévires demandèrent secours '
      'aux Germains.)',
    ),
    _titreExplication('Qu\'est-ce que l\'ablatif absolu ?'),
    _paragrapheExplication(
      'L\'ablatif absolu (AA) est une construction dont le sujet est à '
      'l\'ablatif et dont le verbe au participe (présent actif ou '
      'parfait passif) est également à l\'ablatif. L\'ablatif absolu '
      'latin équivaut en français à une subordonnée circonstancielle, '
      'le plus souvent de temps (quand, lorsque, après que) ou de cause '
      '(comme, puisque).',
    ),
    _paragrapheExplication(
      'Il faut d\'abord traduire littéralement l\'ablatif absolu (sujet '
      '+ verbe au participe) et ensuite seulement trouver une '
      'traduction plus élégante en français, avec une nuance de temps '
      'ou de cause, parfois même d\'opposition, selon le contexte. '
      'Attention à la concordance des temps en français : le participe '
      'présent exprime la simultanéité, le participe parfait '
      'l\'antériorité.',
    ),
    _tableauColonnes(
      ['participe de l\'AA', 'cause', 'temps'],
      [
        [
          'présent actif → simultanéité',
          'comme, puisque + ind. présent ou imparfait',
          'quand, lorsque + ind. présent, imparfait ou passé simple ; '
              'pendant que, tandis que + ind. présent ou imparfait',
        ],
        [
          'parfait passif → antériorité',
          'comme, puisque + ind. passé composé ou plus-que-parfait',
          'après que + ind. passé composé, passé antérieur ou '
              'plus-que-parfait',
        ],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Romanis victis, socii fugam ceperunt. (Les Romains ayant été '
      'vaincus, les alliés prirent la fuite.)\n'
      '→ Après que les Romains eurent été vaincus, les alliés prirent '
      'la fuite.\n'
      '→ Comme les Romains avaient été vaincus, les alliés prirent la '
      'fuite.\n\n'
      'Romanis vincentibus, hostes fugam ceperunt. (Les Romains '
      'vainquant, les ennemis prirent la fuite.)\n'
      '→ Quand les Romains vainquirent, les ennemis prirent la fuite.\n'
      '→ Comme les Romains vainquaient, les ennemis prirent la fuite.',
    ),
    _titreExplication('À quoi faut-il faire attention ?'),
    _paragrapheExplication(
      '1. Contrairement au français, le latin ne dispose que du '
      'participe présent actif et du participe parfait passif (il n\'a '
      'ni participe présent passif « étant aimé », ni participe passé '
      'actif « ayant aimé »). Le latin possède aussi un participe futur '
      'actif, que tu apprendras plus tard.\n\n'
      'En thème, il faut donc parfois transformer la phrase avant de '
      'pouvoir traduire par un ablatif absolu.\n'
      'Ex. : « Ayant tué l\'esclave, l\'homme prit la fuite. » → il '
      'n\'existe pas de participe passé actif en latin. On transforme : '
      '« L\'esclave ayant été tué, l\'homme prit la fuite. » → Servo '
      'interfecto, vir fugam cepit.',
    ),
    _paragrapheExplication(
      '2. Pour alléger le style, le français évite le passif si '
      'possible. Si le sujet de l\'ablatif absolu est la même personne '
      'que le sujet de la principale, on peut transformer à l\'actif en '
      'français.\n'
      'Ex. : Oppido capto, Romani incolas interfecerunt. (La place '
      'forte ayant été prise, les Romains tuèrent les habitants.) → '
      'Après avoir pris la place forte, les Romains tuèrent les '
      'habitants.\n\n'
      'Mais si ce n\'est pas la même personne, on ne peut pas '
      'transformer à l\'actif.\n'
      'Ex. : Oppido capto, Galli fugam ceperunt. (La place forte ayant '
      'été prise, les Gaulois prirent la fuite. → Après que la place '
      'forte eut été prise, les Gaulois prirent la fuite.)',
    ),
    _paragrapheExplication(
      '3. Le sujet de l\'ablatif absolu ne peut pas avoir de fonction '
      'dans la proposition principale, on aurait sinon un participe '
      'apposé.\n'
      'Ex. : La place forte ayant été prise, les Romains la pillèrent. '
      '→ Les Romains pillèrent la place forte prise. → oppidum captum '
      '(participe apposé, accusatif COD) ≠ oppido capto (ablatif '
      'absolu) !',
    ),
    _paragrapheExplication(
      '4. Le verbe esse n\'ayant pas de participe présent, certains '
      'ablatifs absolus ne comportent que le sujet et l\'attribut, sans '
      'participe exprimé.\n'
      'Ex. : Cicerone consule, Catilina magnam conjurationem fecit. '
      '(Cicéron [étant] consul, Catilina fit une grande conjuration. → '
      'Sous le consulat de Cicéron, Catilina fit une grande '
      'conjuration.)\n'
      'Caesare duce, multi milites Galliam petiverunt. (César [étant] '
      'chef, de nombreux soldats gagnèrent la Gaule. → Sous la '
      'conduite de César, de nombreux soldats gagnèrent la Gaule.)',
    ),
    _titreExplication('Ne pas confondre AA et participe apposé'),
    _paragrapheExplication(
      'Si tu repères un participe (présent actif ou parfait passif) '
      'dans une phrase, il y a deux possibilités :\n\n'
      '• Le participe est un participe apposé : il peut être à tous les '
      'cas, il est apposé à un mot de la phrase (au même cas), et se '
      'traduit par la forme « simple » (amatus « aimé »).\n\n'
      '• Le participe est le verbe de l\'ablatif absolu : il est à '
      'l\'ablatif, un autre mot (souvent à gauche du participe) est '
      'également à l\'ablatif, et l\'ensemble forme une subordonnée '
      'avec un sujet et un verbe. S\'il s\'agit d\'un participe parfait '
      'passif, on traduit par la forme « développée » (amatus « ayant '
      'été aimé »).',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'À quel cas sont le sujet et le participe de l\'ablatif absolu ?',
      options: ['l\'ablatif', 'l\'accusatif', 'le nominatif', 'le datif'],
      reponseCorrecte: 'l\'ablatif',
    ),
    QuestionLecon(
      question: 'Que traduit un ablatif absolu au participe présent actif ?',
      options: ['la simultanéité', 'l\'antériorité', 'la postériorité', 'le but'],
      reponseCorrecte: 'la simultanéité',
    ),
    QuestionLecon(
      question: 'Que traduit un ablatif absolu au participe parfait passif ?',
      options: ['l\'antériorité', 'la simultanéité', 'la postériorité', 'le but'],
      reponseCorrecte: 'l\'antériorité',
    ),
    QuestionLecon(
      question:
          'À quelle(s) nuance(s) équivaut le plus souvent l\'ablatif '
          'absolu en français ?',
      options: [
        'temps ou cause',
        'toujours la comparaison',
        'toujours le lieu',
        'la possession',
      ],
      reponseCorrecte: 'temps ou cause',
    ),
    QuestionLecon(
      question:
          'Pourquoi faut-il parfois transformer une phrase française '
          'avant de la traduire par un ablatif absolu ?',
      options: [
        'le latin n\'a pas de participe passé actif ni de participe '
            'présent passif',
        'le latin n\'a pas de participe du tout',
        'l\'ablatif absolu n\'existe qu\'au singulier',
        'ce n\'est jamais nécessaire',
      ],
      reponseCorrecte:
          'le latin n\'a pas de participe passé actif ni de participe '
          'présent passif',
    ),
    QuestionLecon(
      question:
          'Que peut-on faire, en français, si le sujet de l\'AA est la '
          'même personne que le sujet de la principale ?',
      options: [
        'transformer la phrase à l\'actif',
        'il faut obligatoirement garder le passif',
        'supprimer l\'AA',
        'rien de particulier',
      ],
      reponseCorrecte: 'transformer la phrase à l\'actif',
    ),
    QuestionLecon(
      question:
          'Le sujet de l\'ablatif absolu peut-il avoir une fonction dans '
          'la proposition principale ?',
      options: [
        'non, sinon ce serait un participe apposé',
        'oui, toujours',
        'oui, mais seulement au génitif',
        'oui, mais seulement au pluriel',
      ],
      reponseCorrecte: 'non, sinon ce serait un participe apposé',
    ),
    QuestionLecon(
      question:
          'Pourquoi certains ablatifs absolus (comme Cicerone consule) '
          'ne comportent-ils que le sujet et l\'attribut ?',
      options: [
        'esse n\'a pas de participe présent',
        'esse n\'a pas d\'attribut',
        'c\'est une erreur de copiste',
        'esse ne se conjugue pas',
      ],
      reponseCorrecte: 'esse n\'a pas de participe présent',
    ),
    QuestionLecon(
      question:
          'Dans oppidum captum vs oppido capto, quelle est la '
          'différence ?',
      options: [
        'oppidum captum est un participe apposé (accusatif), oppido '
            'capto est l\'ablatif absolu',
        'ce sont deux formes de l\'ablatif absolu',
        'ce sont deux formes du participe apposé',
        'il n\'y a aucune différence de sens',
      ],
      reponseCorrecte:
          'oppidum captum est un participe apposé (accusatif), oppido '
          'capto est l\'ablatif absolu',
    ),
    ExerciceSaisie(
      question:
          'Dans « Gallis victis, Romani deis gratiam habuerunt », quel '
          'est le sujet de l\'ablatif absolu ? (un mot)',
      reponsesAcceptees: ['gallis'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'AA = sujet à l\'ablatif + participe à l\'ablatif. Participe '
        'présent actif = simultanéité ; participe parfait passif = '
        'antériorité.\n\n'
        'Le sujet de l\'AA ne peut pas avoir de fonction dans la '
        'principale (sinon : participe apposé).',
      ),
      _tableauColonnes(
        ['participe de l\'AA', 'nuance', 'traduction possible'],
        [
          ['présent actif', 'simultanéité', 'quand, comme + présent/imparfait'],
          ['parfait passif', 'antériorité', 'après que + passé composé/antérieur'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : La technique de traduction de l'ablatif absolu
// ------------------------------------------------------------

final Lecon _leconTechniqueTraductionAA = Lecon(
  id: 'technique_traduction_aa',
  titre: 'La technique de traduction de l\'ablatif absolu',
  sousTitre: 'La méthode, étape par étape, en version et en thème',
  icone: Icons.explore,
  unite: 'Vol. I – Unité 9',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('En version (traduire du latin vers le français)'),
    _paragrapheExplication(
      '1. Repère les éléments constitutifs de l\'AA : le sujet (le '
      'groupe sujet) à l\'ablatif ; le participe (présent ou parfait) à '
      'l\'ablatif ; et vérifie si le participe est au présent actif ou '
      'au parfait passif.\n\n'
      '2. Traduis le sujet.\n\n'
      '3. Traduis le participe par son équivalent français : présent '
      'actif (-ant) ; parfait passif (ayant été + participe passé).\n\n'
      '4. Trouve une traduction française plus élégante, en veillant à '
      'mettre en évidence la nuance de temps ou de cause, et à '
      'appliquer correctement la concordance des temps.',
    ),
    _paragrapheExplication(
      'Exemple : Gallis victis, Romani deis gratiam habuerunt.\n\n'
      'AA : Gallis victis → sujet : Gallis → participe : victis '
      '(parfait passif, PPP)\n'
      '→ Les Gaulois ayant été vaincus, les Romains remercièrent les '
      'dieux.\n'
      '→ Après que les Gaulois eurent été vaincus, les Romains '
      'remercièrent les dieux.\n'
      '→ Après avoir vaincu les Gaulois, les Romains remercièrent les '
      'dieux.\n'
      '→ Ayant vaincu les Gaulois, les Romains remercièrent les dieux.',
    ),
    _titreExplication('En thème (traduire du français vers le latin)'),
    _paragrapheExplication(
      '1. Dégage les éléments de la proposition qui constitueront l\'AA '
      ': le sujet ; le verbe.\n\n'
      '2. Demande-toi si l\'action de cette proposition se passe en '
      'même temps que l\'action de la principale (simultanéité = '
      'participe présent actif), ou si elle se passe avant l\'action de '
      'la principale (antériorité = participe parfait passif, PPP).\n\n'
      '3. Transforme la proposition conjonctive de manière à avoir une '
      'proposition participiale en français ; attention, le latin ne '
      'connaît que le participe présent actif et le participe parfait '
      'passif !\n\n'
      '4. Traduis le sujet (et tout ce qui s\'y rapporte, par exemple un '
      'adjectif) en le mettant à l\'ablatif.\n\n'
      '5. Traduis le verbe au participe présent ou parfait, en le '
      'mettant à l\'ablatif.',
    ),
    _paragrapheExplication(
      'Exemple : Après que les Gaulois eurent été vaincus, les Romains '
      'remercièrent les dieux.\n\n'
      '→ sujet = Gaulois ; verbe = eurent été vaincus (passé antérieur '
      'passif = antériorité = participe parfait passif, PPP)\n'
      '→ Transformation : Les Gaulois ayant été vaincus...\n'
      '→ Gallis victis, Romani deis gratiam habuerunt.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'En version, quelle est la 1re étape de la méthode de '
          'traduction de l\'AA ?',
      options: [
        'repérer le sujet et le participe à l\'ablatif, et le type de '
            'participe',
        'traduire directement en français élégant',
        'traduire le participe en premier',
        'chercher le complément d\'agent',
      ],
      reponseCorrecte:
          'repérer le sujet et le participe à l\'ablatif, et le type de '
          'participe',
    ),
    QuestionLecon(
      question:
          'En version, par quoi traduit-on d\'abord le participe '
          'présent actif ?',
      options: ['par -ant', 'par ayant été + participe passé', 'par un infinitif', 'par un subjonctif'],
      reponseCorrecte: 'par -ant',
    ),
    QuestionLecon(
      question:
          'En version, par quoi traduit-on d\'abord le participe '
          'parfait passif ?',
      options: ['par ayant été + participe passé', 'par -ant', 'par un infinitif', 'par un gérondif seul'],
      reponseCorrecte: 'par ayant été + participe passé',
    ),
    QuestionLecon(
      question:
          'En thème, si l\'action de la subordonnée se passe en même '
          'temps que celle de la principale, quel participe utilise-t-on ?',
      options: ['le participe présent actif', 'le participe parfait passif', 'le participe futur', 'aucun participe'],
      reponseCorrecte: 'le participe présent actif',
    ),
    QuestionLecon(
      question:
          'En thème, si l\'action de la subordonnée se passe avant '
          'celle de la principale, quel participe utilise-t-on ?',
      options: ['le participe parfait passif', 'le participe présent actif', 'le participe futur', 'aucun participe'],
      reponseCorrecte: 'le participe parfait passif',
    ),
    QuestionLecon(
      question:
          'En thème, à quel cas faut-il mettre le sujet et le verbe de '
          'l\'AA ?',
      options: ['l\'ablatif', 'l\'accusatif', 'le nominatif', 'le génitif'],
      reponseCorrecte: 'l\'ablatif',
    ),
    QuestionLecon(
      question:
          'Dans « Gallis victis, Romani deis gratiam habuerunt », quel '
          'est le participe de l\'AA ?',
      options: ['victis', 'Gallis', 'Romani', 'habuerunt'],
      reponseCorrecte: 'victis',
    ),
    ExerciceSaisie(
      question:
          'Quelle est la dernière étape (4e) de la méthode « en '
          'version » ? Réponds en un mot-clé : trouver une traduction '
          'plus... ?',
      reponsesAcceptees: ['elegante', 'élégante'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'En version : 1) repérer sujet + participe à l\'ablatif ; 2) '
        'traduire le sujet ; 3) traduire le participe (-ant / ayant été '
        '+ part. passé) ; 4) affiner (temps/cause, concordance).\n\n'
        'En thème : 1) dégager sujet + verbe ; 2) simultanéité (présent '
        'actif) ou antériorité (parfait passif) ; 3) transformer en '
        'proposition participiale ; 4-5) tout mettre à l\'ablatif.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Le pronom-adjectif is, ea, id
// ------------------------------------------------------------

final Lecon _leconPronomIsEaId = Lecon(
  id: 'pronom_is_ea_id',
  titre: 'Le pronom-adjectif is, ea, id',
  sousTitre: 'Rappel, démonstratif — et suus/ejus pour « son, sa, ses »',
  icone: Icons.bookmark,
  unite: 'Vol. I – Unité 10',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Le pronom-adjectif is, ea, id désigne une personne ou une chose '
      'dont on a déjà parlé : c\'est un pronom-adjectif de rappel.',
    ),
    _titreExplication('La morphologie'),
    _tableauColonnes(
      ['cas', 'masculin', 'féminin', 'neutre'],
      [
        ['nom. (sg.)', 'is', 'ea', 'id'],
        ['acc. (sg.)', 'eum', 'eam', 'id'],
        ['gén. (sg.)', 'ejus', 'ejus', 'ejus'],
        ['dat. (sg.)', 'ei', 'ei', 'ei'],
        ['abl. (sg.)', 'eo', 'ea', 'eo'],
        ['nom. (pl.)', 'ei / ii', 'eae', 'ea'],
        ['acc. (pl.)', 'eos', 'eas', 'ea'],
        ['gén. (pl.)', 'eorum', 'earum', 'eorum'],
        ['dat./abl. (pl.)', 'eis / iis', 'eis / iis', 'eis / iis'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Un certain nombre de pronoms-adjectifs en latin ont le génitif '
      'singulier en -ius, le datif singulier en -i, et le nominatif/'
      'accusatif neutre singulier en -d. Pour le reste, ils '
      'fonctionnent principalement comme bonus, a, um.',
    ),
    _titreExplication('is, ea, id employé comme adjectif'),
    _paragrapheExplication(
      'Utilisé comme adjectif, is, ea, id se traduit par l\'adjectif '
      'démonstratif « ce(t)..., cette..., ces... ».\n\n'
      'Ex. : Is puer amicus meus est. (Ce garçon est mon ami.)\n'
      'Optimi filii ei matri sunt. (Cette mère a d\'excellents fils.)',
    ),
    _titreExplication('is, ea, id employé comme pronom'),
    _paragrapheExplication(
      'Utilisé comme pronom, is, ea, id se traduit par le pronom '
      'démonstratif « celui-ci, celle-ci, ceci, ceux-ci, celles-ci, ces '
      'choses-ci/ceci » ou par le pronom personnel « le, la, lui, les, '
      'leur, etc. ».\n\n'
      'Ex. : Eam vidi. (Je l\'ai vue.*)\n'
      'Id scio. (Je sais ceci. Je le sais.)\n'
      'Eos amavimus. (Nous les avons aimés.*)\n\n'
      '* En français, si le COD précède l\'auxiliaire « avoir », tu dois '
      'accorder le participe passé avec le COD !',
    ),
    _titreExplication('La traduction du génitif latin par « son, sa, ses »'),
    _paragrapheExplication(
      'Pour alléger la traduction du génitif ejus, eorum, earum (« de '
      'celui-ci/de lui, de celle-ci/d\'elle, de ceux-ci/d\'eux, de '
      'celles-ci/d\'elles »), on utilise souvent en français l\'adjectif '
      'possessif « son, sa, ses, leur(s) ». Attention : ejus, eorum, '
      'earum ne se rapportent alors jamais au sujet de la même '
      'proposition !',
    ),
    _paragrapheExplication(
      'Le latin connaît aussi l\'adjectif possessif suus, a, um, qui se '
      'décline comme un adjectif de la 1re classe et se rapporte '
      'toujours au sujet de la proposition dans laquelle il se trouve. '
      'On l\'appelle adjectif possessif réfléchi.',
    ),
    _titreExplication('Remarque 1 : la possession souvent sous-entendue'),
    _paragrapheExplication(
      'Le latin sous-entend souvent l\'adjectif possessif, '
      'contrairement au français.\n\n'
      'Ex. : Puella cum familia in Arduenna silva habitat. (La jeune '
      'fille habite dans la forêt des Ardennes avec sa famille.)\n\n'
      'Du français au latin, il n\'est donc pas toujours nécessaire '
      'd\'exprimer la possession par suus, a, um, sauf pour y insister.',
    ),
    _titreExplication('Remarque 2 : suus, a, um substantivé'),
    _paragrapheExplication(
      'Comme tout autre adjectif, suus, a, um peut être substantivé.\n\n'
      'Ex. : Milites sua suosque relinquere debuerunt. (Les soldats '
      'durent abandonner leurs biens et leurs proches.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Que désigne le pronom-adjectif is, ea, id ?',
      options: [
        'une personne ou une chose dont on a déjà parlé',
        'toujours le sujet de la phrase',
        'une question',
        'une quantité',
      ],
      reponseCorrecte: 'une personne ou une chose dont on a déjà parlé',
    ),
    QuestionLecon(
      question: 'Quel est le génitif singulier (les 3 genres) de is, ea, id ?',
      options: ['ejus', 'ei', 'eo', 'id'],
      reponseCorrecte: 'ejus',
    ),
    QuestionLecon(
      question: 'Quel est le datif singulier (les 3 genres) de is, ea, id ?',
      options: ['ei', 'ejus', 'eo', 'is'],
      reponseCorrecte: 'ei',
    ),
    QuestionLecon(
      question: 'Utilisé comme adjectif, is, ea, id se traduit par...',
      options: [
        'un adjectif démonstratif (ce, cette, ces)',
        'un adjectif possessif',
        'un article indéfini',
        'un adjectif numéral',
      ],
      reponseCorrecte: 'un adjectif démonstratif (ce, cette, ces)',
    ),
    QuestionLecon(
      question: 'Utilisé comme pronom, is, ea, id peut se traduire par...',
      options: [
        'un pronom démonstratif ou un pronom personnel (le, la, lui...)',
        'toujours « qui »',
        'un adverbe',
        'une préposition',
      ],
      reponseCorrecte:
          'un pronom démonstratif ou un pronom personnel (le, la, lui...)',
    ),
    QuestionLecon(
      question:
          'Pour traduire « son, sa, ses », quel adjectif utilise-t-on si '
          'le possessif renvoie au sujet de la même proposition ?',
      options: ['suus, a, um', 'ejus', 'eorum', 'is, ea, id'],
      reponseCorrecte: 'suus, a, um',
    ),
    QuestionLecon(
      question:
          'Pour traduire « son, sa, ses », quel pronom utilise-t-on si '
          'le possessif ne renvoie PAS au sujet de la même proposition ?',
      options: ['ejus / eorum / earum (génitif)', 'suus, a, um', 'is, ea, id au nominatif', 'quis, quae, quod'],
      reponseCorrecte: 'ejus / eorum / earum (génitif)',
    ),
    QuestionLecon(
      question:
          'Le latin exprime-t-il toujours la possession par suus, a, um ?',
      options: [
        'non, il la sous-entend souvent, sauf pour insister',
        'oui, systématiquement',
        'non, jamais',
        'seulement au pluriel',
      ],
      reponseCorrecte: 'non, il la sous-entend souvent, sauf pour insister',
    ),
    ExerciceSaisie(
      question: 'Quel est l\'accusatif féminin singulier de is, ea, id ?',
      reponsesAcceptees: ['eam'],
    ),
    ExerciceSaisie(
      question: 'Quel est le génitif pluriel masculin de is, ea, id ?',
      reponsesAcceptees: ['eorum'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['cas', 'masculin', 'féminin', 'neutre'],
        [
          ['nom. (sg.)', 'is', 'ea', 'id'],
          ['acc. (sg.)', 'eum', 'eam', 'id'],
          ['gén. (sg.)', 'ejus', 'ejus', 'ejus'],
          ['dat. (sg.)', 'ei', 'ei', 'ei'],
          ['abl. (sg.)', 'eo', 'ea', 'eo'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        '« son, sa, ses, leur(s) » : suus, a, um si le possesseur est le '
        'sujet de la proposition ; ejus/eorum/earum (génitif) sinon.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Le pronom relatif qui, quae, quod
// ------------------------------------------------------------

final Lecon _leconPronomRelatif = Lecon(
  id: 'pronom_relatif',
  titre: 'Le pronom relatif qui, quae, quod',
  sousTitre: 'Antécédent, accord, le cum d\'accompagnement, l\'adverbe relatif',
  icone: Icons.link,
  unite: 'Vol. I – Unité 10',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Le pronom qui, quae, quod introduit une proposition subordonnée '
      '« reliée » à la proposition principale. On appelle cette '
      'subordonnée « relative », et on appelle « antécédent » (du latin '
      'antecedo, is, ere, « devancer, précéder ») le mot auquel le '
      'pronom relatif se rapporte.',
    ),
    _titreExplication('La morphologie'),
    _tableauColonnes(
      ['cas', 'masculin', 'féminin', 'neutre'],
      [
        ['nom. (sg.)', 'qui', 'quae', 'quod'],
        ['acc. (sg.)', 'quem', 'quam', 'quod'],
        ['gén. (sg.)', 'cujus', 'cujus', 'cujus'],
        ['dat. (sg.)', 'cui', 'cui', 'cui'],
        ['abl. (sg.)', 'quo', 'qua', 'quo'],
        ['nom. (pl.)', 'qui', 'quae', 'quae'],
        ['acc. (pl.)', 'quos', 'quas', 'quae'],
        ['gén. (pl.)', 'quorum', 'quarum', 'quorum'],
        ['dat./abl. (pl.)', 'quibus', 'quibus', 'quibus'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('L\'emploi du pronom relatif'),
    _paragrapheExplication(
      'Le pronom relatif s\'accorde en genre et en nombre avec '
      'l\'antécédent. Il se met au cas voulu par sa fonction dans la '
      'subordonnée relative.\n\n'
      'Ex. : Bellum [quod Caesar in Gallia gessit] difficile fuit. (La '
      'guerre que César mena en Gaule fut difficile.)',
    ),
    _titreExplication('L\'antécédent'),
    _paragrapheExplication(
      'L\'antécédent du pronom relatif peut être :\n\n'
      '1. un nom, un pronom ou un groupe nominal ; si le nom est '
      'déterminé par l\'adjectif is, ea, id, on traduit généralement '
      'celui-ci par l\'article défini « le, la, les, etc. ».\n'
      'Ex. : Is vir qui hostes timet fortis non est. (L\'homme qui '
      'craint les ennemis n\'est pas courageux.)\n'
      'Laudasne eos milites qui semper bene pugnaverunt ? (Loues-tu les '
      'soldats qui ont toujours bien combattu ?)\n\n'
      '2. le pronom is, ea, id, qu\'on traduit par le pronom '
      'démonstratif « celui, celle, ce, etc. ».\n'
      'Ex. : Is qui hostes timet fortis non est. (Celui qui craint les '
      'ennemis n\'est pas courageux.)',
    ),
    _titreExplication('Le cum d\'accompagnement'),
    _paragrapheExplication(
      'Le cum d\'accompagnement se place après le relatif à l\'ablatif '
      'et se soude à lui : quocum, quacum, quibuscum.\n\n'
      'Ex. : Amici quibuscum Ledona oppidum petivit multi erant. (Les '
      'amis avec lesquels Ledona gagna la place forte étaient '
      'nombreux.)\n'
      'Mater quacum verba fecimus curis premitur. (La mère à qui / à '
      'laquelle nous avons parlé est accablée de soucis.)',
    ),
    _titreExplication('La traduction de « dont »'),
    _paragrapheExplication(
      'En français, le pronom relatif « dont » a différentes fonctions '
      'et ne se traduit pas automatiquement par un génitif en latin. Il '
      'est donc indispensable de se rappeler la construction exacte du '
      'verbe latin.\n\n'
      '• Quand « dont » exprime un complément du nom (la ville dont les '
      'habitants...), il correspond bien à un génitif (cujus).\n\n'
      '• Mais selon le verbe, « dont » peut aussi correspondre à un '
      'complément d\'agent (a/ab + ablatif), à un complément de moyen '
      '(ablatif seul), ou à un complément circonstanciel de lieu '
      '(souvent une préposition + ablatif). Il faut donc analyser la '
      'fonction du mot avant de choisir le cas du pronom relatif en '
      'latin.',
    ),
    _titreExplication('L\'adverbe relatif'),
    _paragrapheExplication(
      'Un complément circonstanciel de lieu peut être exprimé par une '
      'préposition suivie du pronom relatif au cas voulu, ou bien par '
      'l\'adverbe relatif, dont la forme est invariable.',
    ),
    _tableauColonnes(
      ['adverbe relatif', 'sens', 'équivalence'],
      [
        ['ubi', 'où', 'in + ablatif du pronom relatif'],
        ['quo', 'où (direction)', 'in + accusatif du pronom relatif'],
        ['unde', 'd\'où', 'e(x)/a(b) + ablatif du pronom relatif'],
        ['qua', 'par où', 'per + accusatif du pronom relatif'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Attention à ne pas confondre la conjonction ubi + indicatif '
      '(« quand, lorsque »), l\'adverbe interrogatif ubi... ? (« où ? ») '
      'et l\'adverbe relatif. D\'ailleurs, quo, unde et qua peuvent '
      'aussi servir d\'adverbes interrogatifs (« où ? d\'où ? par '
      'où ? »).\n\n'
      'Ex. : In eo oppido in quo / ubi copiae sunt liberi tuti non '
      'sunt. (Dans la place forte dans laquelle / où sont les troupes, '
      'les enfants ne sont pas en sécurité.)\n'
      'Eam urbem e qua / unde revertimus amamus. (Nous aimons la ville '
      'de laquelle / d\'où nous revenons.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Que fait le pronom relatif qui, quae, quod ?',
      options: [
        'il introduit une proposition subordonnée relative',
        'il introduit une question',
        'il exprime toujours le but',
        'il remplace un verbe',
      ],
      reponseCorrecte: 'il introduit une proposition subordonnée relative',
    ),
    QuestionLecon(
      question: 'Comment appelle-t-on le mot auquel le pronom relatif se rapporte ?',
      options: ['l\'antécédent', 'le supin', 'le radical', 'l\'attribut'],
      reponseCorrecte: 'l\'antécédent',
    ),
    QuestionLecon(
      question: 'Avec quoi le pronom relatif s\'accorde-t-il en genre et en nombre ?',
      options: ['l\'antécédent', 'le verbe de la principale', 'le sujet de la relative', 'rien, il est invariable'],
      reponseCorrecte: 'l\'antécédent',
    ),
    QuestionLecon(
      question:
          'À quoi le cas du pronom relatif correspond-il, lui ?',
      options: [
        'à sa fonction dans la subordonnée relative',
        'toujours au cas de l\'antécédent',
        'toujours au nominatif',
        'au genre de l\'antécédent',
      ],
      reponseCorrecte: 'à sa fonction dans la subordonnée relative',
    ),
    QuestionLecon(
      question: 'Quel est le génitif singulier (3 genres) de qui, quae, quod ?',
      options: ['cujus', 'cui', 'quo', 'quorum'],
      reponseCorrecte: 'cujus',
    ),
    QuestionLecon(
      question: 'Quel est le datif singulier (3 genres) de qui, quae, quod ?',
      options: ['cui', 'cujus', 'quo', 'quibus'],
      reponseCorrecte: 'cui',
    ),
    QuestionLecon(
      question: 'Comment se forme le cum d\'accompagnement avec le relatif ?',
      options: [
        'le cum se place après le relatif à l\'ablatif et s\'y soude (quocum)',
        'cum se place toujours avant le relatif',
        'le relatif ne peut pas être suivi de cum',
        'cum se place avant le verbe',
      ],
      reponseCorrecte:
          'le cum se place après le relatif à l\'ablatif et s\'y soude (quocum)',
    ),
    QuestionLecon(
      question: '« dont » se traduit-il toujours par un génitif en latin ?',
      options: [
        'non, cela dépend de la construction du verbe',
        'oui, toujours',
        'non, jamais',
        'seulement au pluriel',
      ],
      reponseCorrecte: 'non, cela dépend de la construction du verbe',
    ),
    QuestionLecon(
      question: 'Que signifie l\'adverbe relatif unde ?',
      options: ['d\'où', 'où', 'par où', 'quand'],
      reponseCorrecte: 'd\'où',
    ),
    QuestionLecon(
      question: 'À quelle construction équivaut l\'adverbe relatif quo (« où », direction) ?',
      options: [
        'in + accusatif du pronom relatif',
        'in + ablatif du pronom relatif',
        'per + accusatif du pronom relatif',
        'e(x)/a(b) + ablatif du pronom relatif',
      ],
      reponseCorrecte: 'in + accusatif du pronom relatif',
    ),
    ExerciceSaisie(
      question: 'Quel est l\'accusatif féminin singulier de qui, quae, quod ?',
      reponsesAcceptees: ['quam'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['cas', 'masculin', 'féminin', 'neutre'],
        [
          ['nom. (sg.)', 'qui', 'quae', 'quod'],
          ['acc. (sg.)', 'quem', 'quam', 'quod'],
          ['gén. (sg.)', 'cujus', 'cujus', 'cujus'],
          ['dat. (sg.)', 'cui', 'cui', 'cui'],
          ['abl. (sg.)', 'quo', 'qua', 'quo'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Accord : genre/nombre avec l\'antécédent ; cas selon la '
        'fonction dans la relative. cum + ablatif du relatif se soude '
        '(quocum, quacum, quibuscum).',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Emplois particuliers du pronom relatif qui, quae, quod
// ------------------------------------------------------------

final Lecon _leconEmploisRelatif = Lecon(
  id: 'emplois_relatif',
  titre: 'Emplois particuliers du pronom relatif',
  sousTitre: 'L\'omission de l\'antécédent, le relatif de liaison',
  icone: Icons.repeat,
  unite: 'Vol. I – Unité 10',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('L\'omission de l\'antécédent'),
    _paragrapheExplication(
      'En latin, contrairement au français, l\'antécédent is, ea, id du '
      'pronom relatif est parfois omis, surtout — mais pas seulement — '
      'quand il est au même cas que le relatif. Dans la traduction '
      'française, tu dois le restituer et le traduire par « celui qui, '
      'celle qui, ce qui, etc. ».',
    ),
    _paragrapheExplication(
      'facis quod dicis = facis id quod dicis\n'
      '→ tu fais ce que tu dis\n\n'
      'amas quae facis = amas ea quae facis\n'
      '→ tu aimes [ces →] les choses que tu fais → tu aimes ce que tu '
      'fais',
    ),
    _titreExplication('Le relatif de liaison'),
    _paragrapheExplication(
      'Le relatif de liaison est fréquent dans la littérature latine. '
      'Au début d\'une phrase, il sert à reprendre un élément mentionné '
      'dans la phrase précédente et fait ainsi un lien entre les deux '
      'phrases. On le traduit par la forme équivalente de is, ea, id, '
      'précédée, selon le contexte, d\'une conjonction de coordination.',
    ),
    _paragrapheExplication(
      'Caesar plurima oppida cepit. Quae se defendere non potuerunt.\n'
      '= [Et/Nam] Ea se defendere non potuerunt.\n'
      '(César prit de très nombreuses places fortes. Or elles ne '
      'purent se défendre.)\n\n'
      'Dux militum virtutem laudabat. Quibus verbis factis, dux '
      'milites pugnare jussit.\n'
      '= [Et] eis verbis factis...\n'
      '(Le chef louait le courage des soldats. Et ces mots dits, le '
      'chef ordonna aux soldats de combattre.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'En latin, quand l\'antécédent is, ea, id du pronom relatif '
          'est-il le plus souvent omis ?',
      options: [
        'surtout quand il est au même cas que le relatif',
        'seulement au pluriel',
        'seulement quand l\'antécédent est neutre',
        'il n\'est jamais omis',
      ],
      reponseCorrecte: 'surtout quand il est au même cas que le relatif',
    ),
    QuestionLecon(
      question:
          'Quand l\'antécédent est omis en latin, comment restitue-t-on '
          'le sens en français ?',
      options: [
        'par « celui qui, celle qui, ce qui, etc. »',
        'on ne traduit rien',
        'par un infinitif',
        'par un adverbe',
      ],
      reponseCorrecte: 'par « celui qui, celle qui, ce qui, etc. »',
    ),
    QuestionLecon(
      question: 'Que signifie « facis quod dicis » ?',
      options: [
        'tu fais ce que tu dis',
        'tu dis ce que tu fais',
        'tu fais et tu dis',
        'fais ce qu\'il dit',
      ],
      reponseCorrecte: 'tu fais ce que tu dis',
    ),
    QuestionLecon(
      question: 'À quoi sert le relatif de liaison, en début de phrase ?',
      options: [
        'à reprendre un élément de la phrase précédente, en faisant un '
            'lien entre les deux phrases',
        'à poser une question',
        'à introduire un ablatif absolu',
        'à exprimer le but',
      ],
      reponseCorrecte:
          'à reprendre un élément de la phrase précédente, en faisant un '
          'lien entre les deux phrases',
    ),
    QuestionLecon(
      question: 'Comment traduit-on le relatif de liaison ?',
      options: [
        'par la forme équivalente de is, ea, id, précédée d\'une '
            'conjonction de coordination selon le contexte',
        'toujours par « qui »',
        'toujours par « lequel »',
        'on ne le traduit pas',
      ],
      reponseCorrecte:
          'par la forme équivalente de is, ea, id, précédée d\'une '
          'conjonction de coordination selon le contexte',
    ),
    QuestionLecon(
      question:
          'Dans « Caesar plurima oppida cepit. Quae se defendere non '
          'potuerunt. », par quoi peut-on remplacer Quae ?',
      options: ['[Et/Nam] Ea', 'Is', 'Cujus', 'Qui'],
      reponseCorrecte: '[Et/Nam] Ea',
    ),
    ExerciceSaisie(
      question:
          'Complète : amas quae facis = amas ___ quae facis (restitue '
          'l\'antécédent omis, neutre pluriel).',
      reponsesAcceptees: ['ea'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Antécédent omis (surtout si même cas que le relatif) → '
        'restituer « celui qui / ce qui » en français.\n\n'
        'Relatif de liaison (début de phrase) = forme de is, ea, id + '
        'conjonction de coordination selon le contexte.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : L'indicatif futur
// ------------------------------------------------------------

final Lecon _leconIndicatifFutur = Lecon(
  id: 'indicatif_futur',
  titre: 'L\'indicatif futur',
  sousTitre: '2 groupes de conjugaisons, actif et passif, esse et ses composés',
  icone: Icons.rocket_launch,
  unite: 'Vol. II – Unité 1',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Olim Ledona Mainae dixit : « Maina, tecum manebo et ab inimicis '
      'semper te defendam. Si in magnis periculis me amabis, ad te '
      'quoque veniam et omnes curas meas tibi committam et omnia una '
      'faciemus. Optima amica ad vitam aeternam eris. » (Un jour, '
      'Ledona dit à Maina : « Maina, je resterai avec toi et te '
      'défendrai toujours contre tes ennemis. Si tu m\'aimes dans les '
      'grands dangers, je viendrai aussi chez toi, te confierai tous '
      'mes soucis et nous ferons tout ensemble. Tu seras à jamais ma '
      'meilleure amie. »)',
    ),
    _titreExplication('La formation de l\'indicatif futur'),
    _paragrapheExplication(
      'À l\'indicatif futur, les 5 conjugaisons se divisent en 2 '
      'groupes. La conjugaison du verbe esse et de ses composés est à '
      'part.',
    ),
    _titreExplication('Groupe 1 : les 1re et 2e conjugaisons'),
    _paragrapheExplication(
      'On forme l\'indicatif futur actif des 1re et 2e conjugaisons en '
      'ajoutant -bo, -bis, -bit, -bimus, -bitis et -bunt au radical du '
      'présent.\n\n'
      'On forme l\'indicatif futur passif des 1re et 2e conjugaisons en '
      'ajoutant -bor, -beris, -bitur, -bimur, -bimini et -buntur au '
      'radical du présent.\n\n'
      'Ces formes sont constituées du radical du présent (ama-, mone-) '
      'auquel on ajoute le suffixe -b- ou -bi- et les terminaisons '
      'personnelles de l\'actif (-o, -s, -t, -mus, -tis et -nt) ou du '
      'passif (-or, -ris, -tur, -mur, -mini et -ntur).',
    ),
    _paragrapheExplication(
      'Attention au passif de la 2e personne du singulier : devant -r-, '
      'un -i- bref se transforme en -e- !\n\n'
      'amabis (« tu aimeras ») → *amabi-ris > amabe-ris (« tu seras '
      'aimé »)\n'
      'monebis (« tu avertiras ») → *monebi-ris > monebe-ris (« tu '
      'seras averti »)',
    ),
    _tableauColonnes(
      ['pers.', 'amare actif', 'amare passif', 'monere actif', 'monere passif'],
      [
        ['je', 'amabo', 'amabor', 'monebo', 'monebor'],
        ['tu', 'amabis', 'amaberis', 'monebis', 'moneberis'],
        ['il / elle', 'amabit', 'amabitur', 'monebit', 'monebitur'],
        ['nous', 'amabimus', 'amabimur', 'monebimus', 'monebimur'],
        ['vous', 'amabitis', 'amabimini', 'monebitis', 'monebimini'],
        ['ils / elles', 'amabunt', 'amabuntur', 'monebunt', 'monebuntur'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Groupe 2 : les 3e, 4e et 5e conjugaisons'),
    _paragrapheExplication(
      'On forme l\'indicatif futur actif des 3e, 4e et 5e conjugaisons '
      'en ajoutant -am, -es, -et, -emus, -etis et -ent au radical du '
      'présent.\n\n'
      'On forme l\'indicatif futur passif des 3e, 4e et 5e conjugaisons '
      'en ajoutant -ar, -eris, -etur, -emur, -emini et -entur au '
      'radical du présent.\n\n'
      'Chaque forme se compose du radical du présent auquel on ajoute '
      'le suffixe -a- (à la 1re personne du singulier) ou -e- (aux '
      'autres personnes) et des terminaisons personnelles de l\'actif '
      '(-m, -s, -t, -mus, -tis et -nt) ou du passif (-r, -ris, -tur, '
      '-mur, -mini et -ntur).',
    ),
    _tableauColonnes(
      ['pers.', 'mittere', 'capere', 'audire'],
      [
        ['je', 'mittam', 'capiam', 'audiam'],
        ['tu', 'mittes', 'capies', 'audies'],
        ['il / elle', 'mittet', 'capiet', 'audiet'],
        ['nous', 'mittemus', 'capiemus', 'audiemus'],
        ['vous', 'mittetis', 'capietis', 'audietis'],
        ['ils / elles', 'mittent', 'capient', 'audient'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Le futur du verbe esse et de ses composés'),
    _tableauColonnes(
      ['pers.', 'esse', 'adesse', 'posse'],
      [
        ['je', 'ero', 'adero', 'potero'],
        ['tu', 'eris', 'aderis', 'poteris'],
        ['il / elle', 'erit', 'aderit', 'poterit'],
        ['nous', 'erimus', 'aderimus', 'poterimus'],
        ['vous', 'eritis', 'aderitis', 'poteritis'],
        ['ils / elles', 'erunt', 'aderunt', 'poterunt'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('L\'emploi de l\'indicatif futur'),
    _paragrapheExplication(
      'De même qu\'en français, l\'indicatif futur latin :\n\n'
      '• sert à exprimer une action qui se déroulera dans le futur ;\n'
      '• peut être employé dans une proposition conditionnelle.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'En combien de groupes les 5 conjugaisons se divisent-elles à '
          'l\'indicatif futur ?',
      options: ['2', '3', '5', '1'],
      reponseCorrecte: '2',
    ),
    QuestionLecon(
      question:
          'Quelles terminaisons forment le futur actif des 1re et 2e '
          'conjugaisons ?',
      options: [
        '-bo, -bis, -bit, -bimus, -bitis, -bunt',
        '-am, -es, -et, -emus, -etis, -ent',
        '-o, -s, -t, -mus, -tis, -nt',
        '-i, -isti, -it, -imus, -istis, -erunt',
      ],
      reponseCorrecte: '-bo, -bis, -bit, -bimus, -bitis, -bunt',
    ),
    QuestionLecon(
      question:
          'Quelles terminaisons forment le futur actif des 3e, 4e et 5e '
          'conjugaisons ?',
      options: [
        '-am, -es, -et, -emus, -etis, -ent',
        '-bo, -bis, -bit, -bimus, -bitis, -bunt',
        '-ba-m, -ba-s, -ba-t',
        '-ns, -ntis',
      ],
      reponseCorrecte: '-am, -es, -et, -emus, -etis, -ent',
    ),
    QuestionLecon(
      question:
          'Devant -r-, que devient le -i- bref au passif de la 2e '
          'personne du singulier (ex. amabis → amaberis) ?',
      options: ['-e-', '-a-', '-o-', '-u-'],
      reponseCorrecte: '-e-',
    ),
    QuestionLecon(
      question: 'Quelle est la 1re personne du singulier de esse au futur ?',
      options: ['ero', 'eram', 'fui', 'sum'],
      reponseCorrecte: 'ero',
    ),
    QuestionLecon(
      question:
          'Comment se forme le futur des composés de esse (adsum, '
          'possum...) ?',
      options: [
        'préfixe + futur de esse',
        'ils sont irréguliers et n\'ont pas de futur',
        'comme au présent',
        'préfixe + infinitif de esse',
      ],
      reponseCorrecte: 'préfixe + futur de esse',
    ),
    QuestionLecon(
      question: 'Quelle est la forme de « nous enverrons » (mittere, futur) ?',
      options: ['mittemus', 'mittimus', 'misimus', 'mittebamus'],
      reponseCorrecte: 'mittemus',
    ),
    QuestionLecon(
      question: 'Quelle est la forme de « ils prendront » (capere, futur) ?',
      options: ['capient', 'capiunt', 'ceperunt', 'capiebant'],
      reponseCorrecte: 'capient',
    ),
    ExerciceSaisie(
      question:
          'Conjugue amare à la 1re personne du singulier de l\'indicatif '
          'futur passif (je serai aimé).',
      reponsesAcceptees: ['amabor'],
    ),
    ExerciceSaisie(
      question:
          'Conjugue audire à la 3e personne du pluriel de l\'indicatif '
          'futur actif (ils écouteront).',
      reponsesAcceptees: ['audient'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'futur des 1re et 2e conj. :\n'
        'radical du présent + -bo, -bis, -bit, -bimus, -bitis, -bunt\n'
        'radical du présent + -bor, -beris, -bitur, -bimur, -bimini, '
        '-buntur\n\n'
        'futur des 3e, 4e et 5e conj. :\n'
        'radical du présent + -am, -es, -et, -emus, -etis, -ent\n'
        'radical du présent + -ar, -eris, -etur, -emur, -emini, -entur\n\n'
        'futur de esse + composés : (préfixe +) ero, eris, erit, '
        'erimus, eritis, erunt',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Le futur antérieur et le plus-que-parfait de l'indicatif
// ------------------------------------------------------------

final Lecon _leconFuturAnterieurPPF = Lecon(
  id: 'futur_anterieur_ppf',
  titre: 'Le futur antérieur et le plus-que-parfait de l\'indicatif',
  sousTitre: 'Deux temps bâtis sur le radical du parfait',
  icone: Icons.alarm,
  unite: 'Vol. II – Unité 1',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Le futur antérieur et le plus-que-parfait de l\'indicatif se '
      'forment tous les deux sur le radical du parfait (le radical du '
      'passé).',
    ),
    _titreExplication('L\'indicatif futur antérieur'),
    _paragrapheExplication(
      'Formation : radical du parfait + -ero, -eris, -erit, -erimus, '
      '-eritis, -erint.',
    ),
    _titreExplication('L\'indicatif plus-que-parfait'),
    _paragrapheExplication(
      'Formation : radical du parfait + -eram, -eras, -erat, -eramus, '
      '-eratis, -erant.',
    ),
    _tableauColonnes(
      ['pers.', 'futur antérieur (amav-)', 'plus-que-parfait (amav-)'],
      [
        ['je', 'amavero', 'amaveram'],
        ['tu', 'amaveris', 'amaveras'],
        ['il / elle', 'amaverit', 'amaverat'],
        ['nous', 'amaverimus', 'amaveramus'],
        ['vous', 'amaveritis', 'amaveratis'],
        ['ils / elles', 'amaverint', 'amaverant'],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'Sur quel radical se forment le futur antérieur et le '
          'plus-que-parfait ?',
      options: [
        'le radical du parfait',
        'le radical du présent',
        'le radical du supin',
        'le radical de l\'infinitif',
      ],
      reponseCorrecte: 'le radical du parfait',
    ),
    QuestionLecon(
      question: 'Quel suffixe sert à former le futur antérieur ?',
      options: [
        '-ero, -eris, -erit, -erimus, -eritis, -erint',
        '-eram, -eras, -erat, -eramus, -eratis, -erant',
        '-bo, -bis, -bit, -bimus, -bitis, -bunt',
        '-i, -isti, -it, -imus, -istis, -erunt',
      ],
      reponseCorrecte: '-ero, -eris, -erit, -erimus, -eritis, -erint',
    ),
    QuestionLecon(
      question: 'Quel suffixe sert à former le plus-que-parfait ?',
      options: [
        '-eram, -eras, -erat, -eramus, -eratis, -erant',
        '-ero, -eris, -erit, -erimus, -eritis, -erint',
        '-am, -es, -et, -emus, -etis, -ent',
        '-ba-m, -ba-s, -ba-t',
      ],
      reponseCorrecte: '-eram, -eras, -erat, -eramus, -eratis, -erant',
    ),
    QuestionLecon(
      question: 'Quelle est la 1re personne du singulier de amare au futur antérieur ?',
      options: ['amavero', 'amaveram', 'amabo', 'amavi'],
      reponseCorrecte: 'amavero',
    ),
    QuestionLecon(
      question: 'Quelle est la 1re personne du singulier de amare au plus-que-parfait ?',
      options: ['amaveram', 'amavero', 'amabam', 'amavi'],
      reponseCorrecte: 'amaveram',
    ),
    ExerciceSaisie(
      question:
          'Conjugue audire (radical du parfait audiv-) à la 3e personne '
          'du singulier du futur antérieur.',
      reponsesAcceptees: ['audiverit'],
    ),
    ExerciceSaisie(
      question:
          'Conjugue mittere (radical du parfait mis-) à la 1re personne '
          'du pluriel du plus-que-parfait.',
      reponsesAcceptees: ['miseramus'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Futur antérieur (tous les verbes) : radical du parfait + '
        '-ero, -eris, -erit, -erimus, -eritis, -erint.\n\n'
        'Plus-que-parfait (tous les verbes) : radical du parfait + '
        '-eram, -eras, -erat, -eramus, -eratis, -erant.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : La subordonnée conditionnelle à l'indicatif
// ------------------------------------------------------------

final Lecon _leconSubordonneeConditionnelleIndicatif = Lecon(
  id: 'subordonnee_conditionnelle_indicatif',
  titre: 'La subordonnée conditionnelle à l\'indicatif',
  sousTitre: 'si / nisi, vérité générale et condition dans l\'avenir',
  icone: Icons.rule,
  unite: 'Vol. II – Unité 1',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'La proposition subordonnée conditionnelle à l\'indicatif est '
      'introduite par la conjonction si (« si ») ou nisi (« si... '
      'ne... pas ») et exprime soit une vérité générale, soit une '
      'condition supposée remplie dans l\'avenir.',
    ),
    _titreExplication('1. Le verbe à l\'indicatif présent (vérité générale)'),
    _paragrapheExplication(
      'Ex. : Si dei sunt, boni magnique sunt. (Si les dieux existent, '
      'ils sont bons et grands.)',
    ),
    _tableauColonnes(
      ['', 'dans la subordonnée', 'dans la principale'],
      [
        ['latin et français', 'si + indicatif présent', 'indicatif présent'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication(
      '2. Le verbe à l\'indicatif futur ou futur antérieur (condition '
      'dans l\'avenir)',
    ),
    _paragrapheExplication(
      'Contrairement au latin — qui est sémantiquement plus logique —, '
      'le français utilise l\'indicatif présent après la conjonction '
      '« si ».\n\n'
      'Ex. : Nisi in forum venietis / veneritis, miseri erimus. (Si '
      'vous ne venez pas sur le forum, nous serons malheureux.)',
    ),
    _tableauColonnes(
      ['', 'dans la subordonnée', 'dans la principale'],
      [
        [
          'latin',
          'si + indicatif futur\nou\nsi + indicatif futur antérieur',
          'futur',
        ],
        ['français', 'si + indicatif présent', 'futur simple'],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'Par quelles conjonctions la subordonnée conditionnelle à '
          'l\'indicatif est-elle introduite ?',
      options: ['si / nisi', 'cum / ut', 'quod / quia', 'postquam / dum'],
      reponseCorrecte: 'si / nisi',
    ),
    QuestionLecon(
      question: 'Que signifie nisi ?',
      options: ['si... ne... pas', 'si', 'quand', 'parce que'],
      reponseCorrecte: 'si... ne... pas',
    ),
    QuestionLecon(
      question:
          'Quand la subordonnée conditionnelle exprime une vérité '
          'générale, à quel temps est le verbe (en latin et en '
          'français) ?',
      options: ['indicatif présent', 'indicatif futur', 'indicatif imparfait', 'subjonctif présent'],
      reponseCorrecte: 'indicatif présent',
    ),
    QuestionLecon(
      question:
          'Pour une condition supposée remplie dans l\'avenir, à quel(s) '
          'temps le latin met-il le verbe de la subordonnée ?',
      options: [
        'l\'indicatif futur ou futur antérieur',
        'l\'indicatif présent uniquement',
        'l\'indicatif imparfait',
        'le subjonctif présent',
      ],
      reponseCorrecte: 'l\'indicatif futur ou futur antérieur',
    ),
    QuestionLecon(
      question:
          'Dans ce même cas, quel temps le français utilise-t-il après '
          '« si », contrairement au latin ?',
      options: ['l\'indicatif présent', 'l\'indicatif futur', 'l\'indicatif futur antérieur', 'le subjonctif'],
      reponseCorrecte: 'l\'indicatif présent',
    ),
    QuestionLecon(
      question:
          'Dans ce cas, à quel temps est le verbe de la proposition '
          'principale, en latin comme en français ?',
      options: ['le futur', 'le présent', 'l\'imparfait', 'le passé composé'],
      reponseCorrecte: 'le futur',
    ),
    ExerciceSaisie(
      question:
          'Traduis en un mot le connecteur qui introduit une condition '
          'négative (« si... ne... pas ») en latin.',
      reponsesAcceptees: ['nisi'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['contexte', 'subordonnée (latin)', 'principale'],
        [
          ['vérité générale', 'si + indicatif présent', 'indicatif présent'],
          [
            'condition dans l\'avenir',
            'si + indicatif futur / futur antérieur',
            'futur',
          ],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Piège classique : en français, on garde le présent après « si '
        '», même quand le latin est au futur ou au futur antérieur.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les pronoms-adjectifs démonstratifs hic, iste, ille
// ------------------------------------------------------------

final Lecon _leconDemonstratifsHicIsteIlle = Lecon(
  id: 'demonstratifs_hic_iste_ille',
  titre: 'Les pronoms-adjectifs démonstratifs hic, iste, ille',
  sousTitre: 'Montrer et situer : proche, éloigné, le plus éloigné',
  icone: Icons.touch_app,
  unite: 'Vol. II – Unité 2',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Les pronoms-adjectifs démonstratifs servent à montrer, à situer '
      'dans l\'espace et le temps. Le latin en connaît trois '
      'différents : hic, haec, hoc ; iste, ista, istud et ille, illa, '
      'illud.',
    ),
    _titreExplication('Hic, haec, hoc'),
    _paragrapheExplication(
      'Pronom : celui-ci, celle-ci, ceci — Adjectif : ce... -ci, cet... '
      '-ci, cette... -ci.\n\n'
      'Hic est le pronom-adjectif démonstratif qui désigne ce qui est '
      'le plus rapproché du locuteur, que ce soit dans l\'espace, dans '
      'le temps ou dans la pensée. Il s\'ensuit un lien avec la 1re '
      'personne (je, nous).',
    ),
    _paragrapheExplication(
      'hic liber, « ce livre-ci » = « le livre qui est ici » ou « le '
      'livre que je tiens », ou même « mon livre »\n'
      'hic dies, « ce jour-ci » = « le jour présent »\n'
      'hoc die (abl.) > hodie (adv.), « aujourd\'hui »\n'
      'hoc tempore, « à cette époque-ci » = « à notre époque »\n'
      'haec urbs, « cette ville-ci » = « la ville dans laquelle '
      'j\'habite/nous habitons »',
    ),
    _tableauColonnes(
      ['cas', 'masc. sg.', 'fém. sg.', 'neutre sg.'],
      [
        ['nom.', 'hic', 'haec', 'hoc'],
        ['acc.', 'hunc', 'hanc', 'hoc'],
        ['gén.', 'hujus', 'hujus', 'hujus'],
        ['dat.', 'huic', 'huic', 'huic'],
        ['abl.', 'hoc', 'hac', 'hoc'],
      ],
    ),
    const SizedBox(height: 8),
    _tableauColonnes(
      ['cas', 'masc. pl.', 'fém. pl.', 'neutre pl.'],
      [
        ['nom.', 'hi', 'hae', 'haec'],
        ['acc.', 'hos', 'has', 'haec'],
        ['gén.', 'horum', 'harum', 'horum'],
        ['dat./abl.', 'his', 'his', 'his'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'La déclinaison du pronom hic présente de nombreuses '
      'terminaisons appartenant à la 1re et à la 2e déclinaison, '
      'notamment au pluriel. Au singulier, le génitif est en -jus, le '
      'datif en -i, terminaisons caractéristiques des pronoms-adjectifs '
      '(cf. ejus, cujus et ei, cui). Enfin, on remarque à certaines '
      'formes la présence d\'une particule démonstrative -c, reste '
      'd\'une ancienne particule démonstrative -ce (cf. ecce, « voici »).',
    ),
    _paragrapheExplication(
      'Cette particule -ce peut apparaître sous plusieurs formes : -ce '
      '(hujusce, hosce...) ; -ci quand hic est suivi de la particule '
      'interrogative -ne (hicine, haecine, hocine ?) ; -c (hunc, hanc, '
      'huic, etc.).',
    ),
    _titreExplication('Iste, ista, istud'),
    _paragrapheExplication(
      'Pronom : celui-là, celle-là, cela — Adjectif : ce... -là, cet... '
      '-là, cette... -là.\n\n'
      'Iste désigne ce qui est plus éloigné du locuteur dans l\'espace, '
      'le temps ou la pensée. Il peut donc désigner ce qui est dans le '
      'domaine de l\'interlocuteur : il s\'ensuit un lien avec la 2e '
      'personne (tu, vous). Iste a parfois une valeur péjorative '
      '(connotation négative) — cette valeur provient du domaine de la '
      'justice, où l\'interlocuteur au tribunal est la partie adverse '
      'qu\'on accuse.',
    ),
    _paragrapheExplication(
      'iste liber, « ce livre-là » = « le livre que tu tiens », « ton '
      'livre », ou même « ce (mauvais) livre »\n'
      'ista urbs, « cette ville-là » = « la ville dans laquelle tu '
      'habites / vous habitez », ou même « cette (horrible) ville »',
    ),
    _tableauColonnes(
      ['cas', 'masc. sg.', 'fém. sg.', 'neutre sg.'],
      [
        ['nom.', 'iste', 'ista', 'istud'],
        ['acc.', 'istum', 'istam', 'istud'],
        ['gén.', 'istius', 'istius', 'istius'],
        ['dat.', 'isti', 'isti', 'isti'],
        ['abl.', 'isto', 'ista', 'isto'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'En plus du génitif en -ius et du datif en -i, on retrouve la '
      'particule -d typique des pronoms-adjectifs au neutre (cf. id, '
      'quod). Pour le reste, iste suit les 1re et 2e déclinaisons (le '
      'pluriel se décline comme boni, ae, a).',
    ),
    _titreExplication('Ille, illa, illud'),
    _paragrapheExplication(
      'Pronom : celui-là, celle-là, cela — Adjectif : ce... -là, cet... '
      '-là, cette... -là.\n\n'
      'Ille est le pronom-adjectif démonstratif de l\'objet éloigné : il '
      'désigne ce qui est le plus éloigné du locuteur dans l\'espace, '
      'le temps ou la pensée. Ille a parfois un sens laudatif (< '
      'laudare, « louer »).',
    ),
    _paragrapheExplication(
      'ille liber, « ce livre-là » = « le livre qui est là-bas », ou '
      'même « ce (bon) livre »\n'
      'illa tempora, « ces temps-là » = « ces temps lointains », ou '
      'même « ces temps illustres »\n'
      'Medea illa, « la célèbre Médée »\n'
      'ille imperator, « ce général-là » ou « ce grand général »',
    ),
    _tableauColonnes(
      ['cas', 'masc. sg.', 'fém. sg.', 'neutre sg.'],
      [
        ['nom.', 'ille', 'illa', 'illud'],
        ['acc.', 'illum', 'illam', 'illud'],
        ['gén.', 'illius', 'illius', 'illius'],
        ['dat.', 'illi', 'illi', 'illi'],
        ['abl.', 'illo', 'illa', 'illo'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Le français manque de moyens pour distinguer iste et ille — les '
      'deux se traduisent souvent par « celui-là » ou « ce... -là ». Il '
      'faut ensuite tenter de déceler les nuances exprimées dans le '
      'texte pour trouver une traduction plus appropriée.\n\n'
      'Ille sert à désigner la personne connue et célèbre, que cette '
      'notoriété « éloigne » en quelque sorte ; de là s\'explique son '
      'sens laudatif. Parfois, ille peut aussi servir de pronom de '
      'rappel remplaçant is, ea, id, traduit alors par « celui-ci, lui, '
      'il ».',
    ),
    _paragrapheExplication(
      'Ille est à l\'origine du pronom personnel français : il < ille, '
      'elle < illa, lui < illi, les < illos, leur < illorum, le < '
      'illum, la < illam, etc.',
    ),
    _titreExplication('Opposer deux personnes ou choses déjà nommées'),
    _paragrapheExplication(
      'Hic et ille peuvent servir à opposer deux personnes ou deux '
      'choses déjà nommées dans le texte : de deux personnes ou choses '
      'déjà nommées, hic renvoie à celle nommée en dernier lieu, et '
      'ille à la plus éloignée (nommée en premier).\n\n'
      'Ex. : Haec non dico majora fuerunt in Clodio quam in Milone, sed '
      'in illo maxima, nulla in hoc. (Ces sentiments étaient, je ne dis '
      'pas plus grands chez Clodius que chez Milon, mais extrêmes chez '
      'le premier [Clodius], inexistants chez le second [Milon].)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quel démonstratif désigne ce qui est le plus proche du locuteur ?',
      options: ['hic, haec, hoc', 'iste, ista, istud', 'ille, illa, illud', 'is, ea, id'],
      reponseCorrecte: 'hic, haec, hoc',
    ),
    QuestionLecon(
      question: 'À quelle personne hic établit-il un lien ?',
      options: ['la 1re personne (je, nous)', 'la 2e personne (tu, vous)', 'la 3e personne', 'aucune'],
      reponseCorrecte: 'la 1re personne (je, nous)',
    ),
    QuestionLecon(
      question: 'À quelle personne iste établit-il un lien ?',
      options: ['la 2e personne (tu, vous)', 'la 1re personne', 'la 3e personne', 'aucune'],
      reponseCorrecte: 'la 2e personne (tu, vous)',
    ),
    QuestionLecon(
      question: 'Quelle connotation iste a-t-il parfois ?',
      options: ['péjorative', 'laudative', 'neutre uniquement', 'affectueuse'],
      reponseCorrecte: 'péjorative',
    ),
    QuestionLecon(
      question: 'Quel démonstratif désigne l\'objet le plus éloigné du locuteur ?',
      options: ['ille, illa, illud', 'hic, haec, hoc', 'iste, ista, istud', 'qui, quae, quod'],
      reponseCorrecte: 'ille, illa, illud',
    ),
    QuestionLecon(
      question: 'Quel sens ille a-t-il parfois ?',
      options: ['laudatif (« ce grand/célèbre »)', 'péjoratif', 'interrogatif', 'exclamatif'],
      reponseCorrecte: 'laudatif (« ce grand/célèbre »)',
    ),
    QuestionLecon(
      question: 'Quel est le génitif singulier (3 genres) de ille, illa, illud ?',
      options: ['illius', 'illi', 'illo', 'illud'],
      reponseCorrecte: 'illius',
    ),
    QuestionLecon(
      question: 'De quel pronom démonstratif latin descend le pronom français « il » ?',
      options: ['ille', 'hic', 'iste', 'is'],
      reponseCorrecte: 'ille',
    ),
    QuestionLecon(
      question:
          'Quand hic et ille opposent deux personnes déjà nommées, à '
          'laquelle hic renvoie-t-il ?',
      options: [
        'celle nommée en dernier lieu',
        'celle nommée en premier',
        'toujours au sujet de la phrase',
        'aucune des deux',
      ],
      reponseCorrecte: 'celle nommée en dernier lieu',
    ),
    ExerciceSaisie(
      question: 'Quel est le datif singulier (3 genres) de hic, haec, hoc ?',
      reponsesAcceptees: ['huic'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['', 'hic', 'iste', 'ille'],
        [
          [
            'situe dans le temps/l\'espace',
            'proche du locuteur',
            'plus éloigné du locuteur',
            'le plus éloigné du locuteur',
          ],
          [
            'lien avec le pronom personnel',
            '1re personne (je, nous)',
            '2e personne (tu, vous)',
            'peut servir de rappel, comme is, ea, id',
          ],
          ['connotation', '—', 'péjorative', 'laudative'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les compléments circonstanciels de temps
// ------------------------------------------------------------

final Lecon _leconCCTemps = Lecon(
  id: 'cct_temps',
  titre: 'Les compléments circonstanciels de temps',
  sousTitre: 'La date (ablatif) et la durée ((per +) accusatif)',
  icone: Icons.calendar_month,
  unite: 'Vol. II – Unité 2',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Quando Romulus Romam condidit ? (Quand est-ce que Romulus a '
      'fondé Rome ?)\n'
      'Quam diu Romani ibi vixerunt ? (Pendant combien de temps les '
      'Romains y ont-ils vécu ?)\n\n'
      'Ces questions portent toutes les deux sur le temps, mais de deux '
      'points de vue différents : avec quando, on cherche à connaître '
      'une date, un moment précis ; avec quam diu, on cherche à '
      'connaître une durée. D\'où les deux types de compléments '
      'circonstanciels de temps (CCT) en latin.',
    ),
    _titreExplication('1. La date — Quando ? (« Quand ? À quel moment ? »)'),
    _paragrapheExplication(
      'Ce complément est exprimé à l\'ABLATIF.\n\n'
      'Ex. : illo tempore (à cette époque-là), hac aetate (à notre '
      'époque), sexta hora (à la sixième heure), vere / hieme (au '
      'printemps / en hiver), aestate / autumno (en été / en automne), '
      'septimo mense (le septième mois), nono jam anno (déjà la '
      'neuvième année), tribus (III) post / ante mensibus (trois mois '
      'après / avant).',
    ),
    _titreExplication(
      '2. La durée — Quam diu ? ou Quamdiu ? (« Pendant combien de '
      'temps ? Combien de temps ? »)',
    ),
    _paragrapheExplication(
      'Ce complément est exprimé à l\'ACCUSATIF, souvent précédé de '
      'per.\n\n'
      'Ex. : (per) tres annos (pendant trois ans), (per) totam '
      'aestatem (pendant tout l\'été), (per) cuncta anni tempora '
      '(pendant toutes les saisons de l\'année).',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Que cherche-t-on à connaître avec la question quando ?',
      options: ['une date, un moment précis', 'une durée', 'un lieu', 'une cause'],
      reponseCorrecte: 'une date, un moment précis',
    ),
    QuestionLecon(
      question: 'Que cherche-t-on à connaître avec la question quam diu ?',
      options: ['une durée', 'une date précise', 'un lieu', 'un but'],
      reponseCorrecte: 'une durée',
    ),
    QuestionLecon(
      question: 'À quel cas exprime-t-on la date (quando ?) en latin ?',
      options: ['l\'ablatif', 'l\'accusatif', 'le génitif', 'le datif'],
      reponseCorrecte: 'l\'ablatif',
    ),
    QuestionLecon(
      question: 'À quel cas exprime-t-on la durée (quam diu ?) en latin ?',
      options: [
        'l\'accusatif, souvent précédé de per',
        'l\'ablatif',
        'le génitif',
        'le datif',
      ],
      reponseCorrecte: 'l\'accusatif, souvent précédé de per',
    ),
    QuestionLecon(
      question: 'Que signifie hac aetate ?',
      options: ['à notre époque', 'pendant notre époque', 'de notre époque', 'vers notre époque'],
      reponseCorrecte: 'à notre époque',
    ),
    QuestionLecon(
      question: 'Que signifie (per) tres annos ?',
      options: ['pendant trois ans', 'dans trois ans', 'il y a trois ans', 'en trois ans'],
      reponseCorrecte: 'pendant trois ans',
    ),
    ExerciceSaisie(
      question:
          'Quel cas latin exprime le complément de temps répondant à la '
          'question quando (la date) ? (un mot)',
      reponsesAcceptees: ['ablatif'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['question', 'sens', 'cas latin'],
        [
          ['Quando ?', 'Quand ? À quel moment ?', 'ablatif'],
          [
            'Quam diu ?',
            'Pendant combien de temps ? Combien de temps ?',
            '(per +) accusatif',
          ],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les compléments circonstanciels de lieu
// ------------------------------------------------------------

final Lecon _leconCCLieu = Lecon(
  id: 'cct_lieu',
  titre: 'Les compléments circonstanciels de lieu',
  sousTitre: 'Ubi, quo, unde, qua — et le régime particulier des noms de ville',
  icone: Icons.signpost,
  unite: 'Vol. II – Unité 2',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('Règle générale'),
    _paragrapheExplication(
      'Tu connais déjà deux adverbes interrogatifs portant sur le lieu '
      ': ubi et quo. Voici le tableau complet des adverbes '
      'interrogatifs de lieu.',
    ),
    _tableauColonnes(
      ['adverbe', 'explication', 'traduction'],
      [
        ['Ubi... ?', 'interroge sur le lieu où l\'on est', 'Où est-ce que... ?'],
        ['Quo... ?', 'interroge sur le lieu où l\'on va', 'Où est-ce que... ?'],
        ['Unde... ?', 'interroge sur le lieu d\'où l\'on vient', 'D\'où est-ce que... ?'],
        ['Qua... ?', 'interroge sur le lieu par où l\'on passe', 'Par où est-ce que... ?'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'En général, le latin utilise des prépositions pour exprimer les '
      'compléments de lieu.',
    ),
    _tableauColonnes(
      ['question', 'préposition + cas'],
      [
        ['Ubi ?', 'in + ablatif'],
        ['Quo ?', 'in + accusatif'],
        ['Unde ?', 'ex + ablatif'],
        ['Qua ?', 'per + accusatif'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Or, pour les noms de villes, ainsi que pour domus (la maison), '
      'humus (le sol, la terre) et rus (la campagne), d\'autres règles '
      's\'appliquent.',
    ),
    _titreExplication('Cas particuliers : en réponse à ubi ?'),
    _paragrapheExplication(
      'Les noms de ville au singulier de la 1re déclinaison (comme '
      'Roma, ae, f.) et de la 2e déclinaison (comme Lugdunum, i, n.), '
      'ainsi que domus, us, f. (« la maison »), humus, i, f. (« le sol '
      '») et rus, ruris, n. (« la campagne »), ont conservé un ancien '
      'cas, le locatif, en réponse à la question ubi. Le locatif est en '
      '-ae à la 1re déclinaison, et en -i à la 2e déclinaison et pour '
      'domus/humus/rus.\n\n'
      'Ex. : Romae sum (je suis à Rome), Lugduni sum (je suis à Lyon), '
      'Domi sum (je suis à la maison), Humi (par terre), Ruri sum (je '
      'suis à la campagne).',
    ),
    _paragrapheExplication(
      'Pour les autres noms de ville (au pluriel, ou de la 3e '
      'déclinaison), on a l\'ablatif sans préposition en réponse à '
      'ubi.\n\n'
      'Ex. : Athenis sum (je suis à Athènes), Delphis sum (je suis à '
      'Delphes), Carthagine sum (je suis à Carthage).',
    ),
    _titreExplication('En réponse aux questions quo ? et unde ?'),
    _paragrapheExplication(
      'Les noms de ville et domus/humus/rus s\'utilisent sans '
      'préposition en réponse à quo et unde : au lieu de in + '
      'accusatif, on a l\'accusatif sans préposition en réponse à quo ; '
      'au lieu de ex + ablatif, on a l\'ablatif sans préposition en '
      'réponse à unde.\n\n'
      'Ex. : Romam venio (je vais à Rome) / Roma venio (je viens de '
      'Rome).\n'
      'Domum venio (je viens à la maison) / Domo venio (je viens de la '
      'maison).\n'
      'Rus venio (je viens à la campagne) / Rure venio (je viens de la '
      'campagne).',
    ),
    _titreExplication('En réponse à la question qua ?'),
    _paragrapheExplication(
      'Le latin utilise la préposition per + accusatif pour répondre à '
      'la question qua. Cette règle générale vaut aussi pour les noms '
      'de ville et domus/humus/rus.\n\n'
      'Ex. : Per Italiam iter facio (je passe par l\'Italie). Per '
      'Romam, per Athenas, per Carthaginem (par Rome, par Athènes, par '
      'Carthage).\n\n'
      'En revanche, les moyens de communication (route, porte, pont) '
      'sont à l\'ablatif sans préposition en réponse à la question '
      'qua.\n\n'
      'Ex. : Iter facio via Sacra (je marche par la voie sacrée).',
    ),
    _titreExplication('Le locatif pour les petites îles'),
    _paragrapheExplication(
      'Les petites îles (insula, ae, f.) portent en principe le même '
      'nom que la ville principale qui s\'y trouve : il est donc '
      'logique qu\'elles suivent les mêmes règles que les noms de '
      'ville.\n\n'
      'Ex. : Ithacae sum (je suis à Ithaque, locatif). Lemni sum (je '
      'suis à Lemnos, locatif).\n\n'
      'Ne sont pas considérées comme « petites îles » : Britannia (la '
      'Grande-Bretagne), Corsica (la Corse), Sardinia (la Sardaigne), '
      'Sicilia (la Sicile) et Creta (la Crète) — ces grandes îles '
      'suivent la règle générale (prépositions).',
    ),
    _titreExplication('La proximité'),
    _paragrapheExplication(
      'Ab et ad (emploi de ad avec idée de mouvement) s\'utilisent pour '
      'indiquer la proximité. Voilà pourquoi on trouve ces prépositions '
      'également avec des noms de personnes.\n\n'
      'Ex. : Ad dominum venio (je viens chez mon maître). A domino '
      'venio (je viens de chez mon maître).',
    ),
    _paragrapheExplication(
      'De même, en réponse à la question ubi ?, on trouve les '
      'prépositions suivantes pour exprimer la proximité : apud + '
      'acc., prope + acc., ad + acc. (emploi de ad sans idée de '
      'mouvement).\n\n'
      'Ex. : apud dominum sum (je suis près de mon maître). prope '
      'urbem (près de la ville). pons qui erat ad Genavam (le pont qui '
      'était près de Genève).',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Que signifie l\'adverbe interrogatif unde ?',
      options: [
        'il interroge sur le lieu d\'où l\'on vient',
        'il interroge sur le lieu où l\'on est',
        'il interroge sur le lieu où l\'on va',
        'il interroge sur le lieu par où l\'on passe',
      ],
      reponseCorrecte: 'il interroge sur le lieu d\'où l\'on vient',
    ),
    QuestionLecon(
      question: 'Quelle construction générale répond à la question quo ?',
      options: ['in + accusatif', 'in + ablatif', 'ex + ablatif', 'per + accusatif'],
      reponseCorrecte: 'in + accusatif',
    ),
    QuestionLecon(
      question:
          'Pour un nom de ville de la 1re ou 2e déclinaison au '
          'singulier, quel cas ancien répond à la question ubi ?',
      options: ['le locatif', 'l\'ablatif avec in', 'l\'accusatif', 'le génitif'],
      reponseCorrecte: 'le locatif',
    ),
    QuestionLecon(
      question: 'Quel est le locatif de Roma, ae, f. (« je suis à Rome ») ?',
      options: ['Romae', 'Roma', 'Romam', 'Roman'],
      reponseCorrecte: 'Romae',
    ),
    QuestionLecon(
      question: 'Quel est le locatif de Lugdunum, i, n. (« je suis à Lyon ») ?',
      options: ['Lugduni', 'Lugdunum', 'Lugduno', 'Lugdunorum'],
      reponseCorrecte: 'Lugduni',
    ),
    QuestionLecon(
      question:
          'Pour les noms de ville pluriels ou de 3e déclinaison, '
          'quelle construction répond à ubi ?',
      options: [
        'l\'ablatif sans préposition',
        'le locatif',
        'l\'accusatif sans préposition',
        'in + ablatif',
      ],
      reponseCorrecte: 'l\'ablatif sans préposition',
    ),
    QuestionLecon(
      question:
          'Pour un nom de ville, quelle construction répond à quo, au '
          'lieu de in + accusatif ?',
      options: [
        'l\'accusatif sans préposition',
        'l\'ablatif sans préposition',
        'le locatif',
        'ex + ablatif',
      ],
      reponseCorrecte: 'l\'accusatif sans préposition',
    ),
    QuestionLecon(
      question: 'Quelle préposition répond systématiquement à la question qua ?',
      options: ['per + accusatif', 'in + accusatif', 'ex + ablatif', 'ab + ablatif'],
      reponseCorrecte: 'per + accusatif',
    ),
    QuestionLecon(
      question:
          'À quelle construction font exception les moyens de '
          'communication (route, porte, pont) en réponse à qua ?',
      options: [
        'l\'ablatif sans préposition',
        'per + accusatif',
        'in + accusatif',
        'le locatif',
      ],
      reponseCorrecte: 'l\'ablatif sans préposition',
    ),
    QuestionLecon(
      question: 'Les petites îles suivent la règle...',
      options: [
        'des noms de ville',
        'des grandes îles, avec préposition',
        'des noms communs ordinaires',
        'aucune règle particulière',
      ],
      reponseCorrecte: 'des noms de ville',
    ),
    QuestionLecon(
      question:
          'Quelles prépositions expriment la proximité en réponse à '
          'ubi ?',
      options: [
        'apud, prope, ad + accusatif',
        'in, ex + ablatif',
        'per + accusatif seulement',
        'ab + accusatif',
      ],
      reponseCorrecte: 'apud, prope, ad + accusatif',
    ),
    ExerciceSaisie(
      question: 'Quel est le locatif de domus, us, f. (« je suis à la maison ») ?',
      reponsesAcceptees: ['domi'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['', 'Ubi ?', 'Quo ?', 'Unde ?', 'Qua ?'],
        [
          ['règle générale', 'in + abl.', 'in + acc.', 'ex + abl.', 'per + acc.'],
          [
            'ville (1re/2e décl. sg.), domus/humus/rus',
            'locatif',
            'accusatif seul',
            'ablatif seul',
            'per + acc.',
          ],
          [
            'ville (pl. ou 3e décl.)',
            'ablatif seul',
            'accusatif seul',
            'ablatif seul',
            'per + acc.',
          ],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Proximité (ubi ?) : apud/prope/ad + accusatif. Moyens de '
        'communication (qua ?) : ablatif seul.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : La quatrième déclinaison
// ------------------------------------------------------------

final Lecon _leconDeclinaison4 = Lecon(
  id: 'decl_4',
  titre: 'La quatrième déclinaison',
  sousTitre: 'exercitus, manus, genu — et domus, aux formes mixtes',
  icone: Icons.front_hand,
  unite: 'Vol. II – Unité 3',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Hostes fortium militum exercitum timebant. (Les ennemis '
      'craignaient l\'armée des soldats courageux.)\n'
      'Nauta manus in mari lavat. (Le marin lave [ses] mains dans la '
      'mer.)\n'
      'Marcus Antonius terram genu tangit. (Marc Antoine touche la '
      'terre du genou.)',
    ),
    _paragrapheExplication(
      'Les mots de la 4e déclinaison ont leur génitif singulier en '
      '-us.',
    ),
    _paragrapheExplication(
      'La 4e déclinaison comporte peu de mots dans le lexique latin : '
      'essentiellement des noms masculins, quelques noms féminins en '
      '-us et peu de noms neutres en -u.',
    ),
    _titreExplication('Nom masculin : exercitus, us, m. « l\'armée »'),
    tableauDeclinaison(declinaisons[6]),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'exercitus, us, m. (« l\'armée ») se décline exactement comme '
      'manus ci-dessus : seul le genre change.',
    ),
    _titreExplication('Remarques'),
    _paragrapheExplication(
      'La terminaison du datif et de l\'ablatif pluriel devrait être '
      '-ubus, mais elle a été refaite sur le modèle de la 3e '
      'déclinaison en -(i)bus, par souci d\'harmonisation.',
    ),
    _paragrapheExplication(
      'Certains noms de la 4e déclinaison n\'ont conservé que '
      'l\'ablatif singulier : jussu (+ gén.), « par ordre (de), sur '
      'l\'ordre (de) » ; rogatu (+ gén.), « à la demande (de) » ; natu, '
      '« par l\'âge ».\n\n'
      'Ainsi, major natu se traduit littéralement par « plus grand par '
      'l\'âge » (= plus âgé), et minor natu par « plus petit par '
      'l\'âge » (= plus jeune).',
    ),
    _titreExplication('Nom féminin : manus, us, f. « la main ; la troupe »'),
    _paragrapheExplication(
      'La 4e déclinaison compte aussi quelques noms féminins, comme '
      'manus, qui se décline exactement comme exercitus.',
    ),
    tableauDeclinaison(declinaisons[6]),
    const SizedBox(height: 12),
    _titreExplication('Nom neutre : genu, us, n. « le genou »'),
    tableauDeclinaison(declinaisons[7]),
    const SizedBox(height: 12),
    _titreExplication(
      'Cas particulier : formes combinées avec la deuxième déclinaison',
    ),
    _paragrapheExplication(
      'Certains noms de la 4e déclinaison peuvent présenter des '
      'terminaisons de la deuxième déclinaison, comme c\'est le cas '
      'pour domus, us, f. (« la maison »).',
    ),
    tableauDeclinaison(declinaisons[13]),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Rappel : domus a conservé le locatif, attesté pour quelques '
      'mots seulement.\n\n'
      'Ex. : Domi sum. (Je suis à la maison.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quelle est la terminaison du génitif singulier de la 4e déclinaison ?',
      options: ['-us', '-is', '-i', '-ae'],
      reponseCorrecte: '-us',
    ),
    QuestionLecon(
      question: 'Quels genres trouve-t-on principalement à la 4e déclinaison ?',
      options: [
        'surtout des masculins, quelques féminins, peu de neutres',
        'surtout des féminins',
        'surtout des neutres',
        'uniquement des masculins',
      ],
      reponseCorrecte: 'surtout des masculins, quelques féminins, peu de neutres',
    ),
    QuestionLecon(
      question: 'Quel est le génitif pluriel de exercitus, us, m. ?',
      options: ['exercituum', 'exercitorum', 'exercitus', 'exercituorum'],
      reponseCorrecte: 'exercituum',
    ),
    QuestionLecon(
      question:
          'Pourquoi le datif et l\'ablatif pluriel sont-ils en -(i)bus '
          'et non -ubus ?',
      options: [
        'par harmonisation sur le modèle de la 3e déclinaison',
        'par harmonisation sur le modèle de la 1re déclinaison',
        'c\'est la terminaison d\'origine',
        'aucune raison précise',
      ],
      reponseCorrecte: 'par harmonisation sur le modèle de la 3e déclinaison',
    ),
    QuestionLecon(
      question: 'Que signifie major natu ?',
      options: [
        'plus âgé (littéralement : plus grand par l\'âge)',
        'plus jeune',
        'le plus grand général',
        'le premier-né',
      ],
      reponseCorrecte: 'plus âgé (littéralement : plus grand par l\'âge)',
    ),
    QuestionLecon(
      question: 'Quel est le nominatif/accusatif singulier de genu, us, n. ?',
      options: ['genu', 'genus', 'genua', 'genui'],
      reponseCorrecte: 'genu',
    ),
    QuestionLecon(
      question:
          'Quelle particularité présente domus, us, f. par rapport aux '
          'autres noms de la 4e déclinaison ?',
      options: [
        'elle combine des terminaisons de la 4e et de la 2e déclinaison',
        'elle n\'a pas de pluriel',
        'elle est neutre',
        'elle n\'a pas de génitif',
      ],
      reponseCorrecte: 'elle combine des terminaisons de la 4e et de la 2e déclinaison',
    ),
    QuestionLecon(
      question: 'Quel cas domus a-t-il conservé, comme quelques autres mots ?',
      options: ['le locatif', 'le vocatif', 'un second génitif', 'aucun cas particulier'],
      reponseCorrecte: 'le locatif',
    ),
    ExerciceSaisie(
      question: 'Quel est l\'ablatif singulier de manus, us, f. ?',
      reponsesAcceptees: ['manu'],
    ),
    ExerciceSaisie(
      question: 'Quel est le locatif de domus, us, f. (« je suis à la maison ») ?',
      reponsesAcceptees: ['domi'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      tableauDeclinaison(declinaisons[6]),
      const SizedBox(height: 12),
      tableauDeclinaison(declinaisons[7]),
      const SizedBox(height: 12),
      tableauDeclinaison(declinaisons[13]),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Le pronom-adjectif idem, eadem, idem
// ------------------------------------------------------------

final Lecon _leconPronomIdem = Lecon(
  id: 'pronom_idem',
  titre: 'Le pronom-adjectif idem, eadem, idem',
  sousTitre: '« Le même » : identité et similitude',
  icone: Icons.content_copy,
  unite: 'Vol. II – Unité 3',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Idem consul cunctis legionibus praeest. (Le même consul '
      'commande à toutes les légions. — adjectif)\n'
      'Idem cunctis legionibus praeest. (Le même [homme] commande à '
      'toutes les légions. — pronom)',
    ),
    _titreExplication('La morphologie'),
    _paragrapheExplication(
      'Idem est composé de is, ea, id suivi de la particule -dem '
      '(invariable), et se décline comme is, ea, id. Attention pourtant '
      'aux formes suivantes :\n\n'
      '• le nominatif masculin idem (*is-dem > idem)\n'
      '• le nominatif et l\'accusatif neutres idem (*id-dem > idem)\n'
      '• des formes fréquentes où m devient n devant d : eundem, '
      'eandem (à côté de eumdem, eamdem) ; eorundem, earundem (à côté '
      'de eorumdem, earumdem)',
    ),
    _tableauColonnes(
      ['cas', 'masc. sg.', 'fém. sg.', 'neutre sg.'],
      [
        ['nom.', 'idem', 'eadem', 'idem'],
        ['acc.', 'eundem', 'eandem', 'idem'],
        ['gén.', 'ejusdem', 'ejusdem', 'ejusdem'],
        ['dat.', 'eidem', 'eidem', 'eidem'],
        ['abl.', 'eodem', 'eadem', 'eodem'],
      ],
    ),
    const SizedBox(height: 8),
    _tableauColonnes(
      ['cas', 'masc. pl.', 'fém. pl.', 'neutre pl.'],
      [
        ['nom.', 'eidem', 'eaedem', 'eadem'],
        ['acc.', 'eosdem', 'easdem', 'eadem'],
        ['gén.', 'eorundem', 'earundem', 'eorundem'],
        ['dat./abl.', 'eisdem', 'eisdem', 'eisdem'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Le sens de idem'),
    _paragrapheExplication(
      'Idem marque une identité, une similitude :\n\n'
      '• pronom : « le même (homme), la même (femme), la même (chose) '
      '»\n'
      '• adjectif : « le même, la même, les mêmes »',
    ),
    _titreExplication('Comment bien traduire idem ?'),
    _paragrapheExplication(
      'Afin d\'améliorer ta traduction, tu peux parfois avoir recours '
      'à d\'autres tournures pour traduire idem.\n\n'
      'ego vir fortis idemque philosophus (moi, homme courageux et le '
      'même homme philosophe) → moi, homme courageux et en même temps '
      'philosophe\n\n'
      'audax est idemque prudens (il est audacieux et le même homme '
      'est prévoyant) → il est audacieux et pourtant prévoyant',
    ),
    _paragrapheExplication(
      'Souvent, idem introduit une comparaison : « le même... que » se '
      'dit idem atque / ac (ou idem... qui).\n\n'
      'Ex. : Eosdem libros legi ac/atque (ou quos) frater meus. (J\'ai '
      'lu les mêmes livres que mon frère.)\n'
      'Filius eadem negotia ac (ou quae) pater gessit. (Le fils a fait '
      'les mêmes affaires que son père.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'De quoi idem est-il composé ?',
      options: [
        'is, ea, id + la particule -dem',
        'qui, quae, quod + -dem',
        'hic, haec, hoc + -dem',
        'ipse + -dem',
      ],
      reponseCorrecte: 'is, ea, id + la particule -dem',
    ),
    QuestionLecon(
      question: 'Que signifie idem ?',
      options: ['le même', 'lui-même', 'celui-ci', 'celui-là'],
      reponseCorrecte: 'le même',
    ),
    QuestionLecon(
      question: 'Quel est l\'accusatif féminin singulier de idem, eadem, idem ?',
      options: ['eandem', 'eamdem', 'eadem', 'eidem'],
      reponseCorrecte: 'eandem',
    ),
    QuestionLecon(
      question:
          'Pourquoi trouve-t-on eundem à côté de eumdem à l\'accusatif '
          'masculin singulier ?',
      options: [
        'le m devient fréquemment n devant d',
        'ce sont deux mots différents',
        'l\'un est du pluriel',
        'l\'un est un pronom, l\'autre un adjectif',
      ],
      reponseCorrecte: 'le m devient fréquemment n devant d',
    ),
    QuestionLecon(
      question: 'Comment traduit-on « le même... que » en latin ?',
      options: ['idem atque / ac (ou idem... qui)', 'idem quam', 'idem cum', 'idem quod tantum'],
      reponseCorrecte: 'idem atque / ac (ou idem... qui)',
    ),
    QuestionLecon(
      question: 'Que signifie « idemque prudens » (« et idem prudent ») dans un contexte comme audax est idemque prudens ?',
      options: ['et pourtant prévoyant', 'et jamais prévoyant', 'et très prévoyant', 'et peu prévoyant'],
      reponseCorrecte: 'et pourtant prévoyant',
    ),
    ExerciceSaisie(
      question: 'Quel est le génitif singulier (3 genres) de idem, eadem, idem ?',
      reponsesAcceptees: ['ejusdem'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'idem = is, ea, id + -dem (invariable). Marque une identité, '
        'une similitude (« le même »).\n\n'
        '« le même... que » = idem atque/ac (ou idem... qui).',
      ),
      _tableauColonnes(
        ['cas', 'masc. sg.', 'fém. sg.', 'neutre sg.'],
        [
          ['nom.', 'idem', 'eadem', 'idem'],
          ['acc.', 'eundem', 'eandem', 'idem'],
          ['gén.', 'ejusdem', 'ejusdem', 'ejusdem'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Le pronom-adjectif ipse, ipsa, ipsum
// ------------------------------------------------------------

final Lecon _leconPronomIpse = Lecon(
  id: 'pronom_ipse',
  titre: 'Le pronom-adjectif ipse, ipsa, ipsum',
  sousTitre: '« Moi-même, lui-même... » : insistance et originalité',
  icone: Icons.fingerprint,
  unite: 'Vol. II – Unité 3',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Ipse consul exercitui praefuit. (Le consul lui-même commanda à '
      'l\'armée.)\n'
      'Ipse exercitui praefuit. (Il commanda lui-même à l\'armée.)\n'
      'Ipse exercitui praefuisti. (Tu commandas toi-même à l\'armée.)',
    ),
    _paragrapheExplication(
      'Pourquoi ipse est-il traduit par « lui-même » dans les deux '
      'premiers exemples, et par « toi-même » dans le troisième ? '
      'Parce que ipse s\'accorde en personne avec le sujet du verbe : '
      'praefuit (3e personne) → lui-même ; praefuisti (2e personne) → '
      'toi-même. Ipse renvoie donc à la personne du sujet, exprimée '
      'par la terminaison verbale.',
    ),
    _titreExplication('La morphologie'),
    _tableauColonnes(
      ['cas', 'masc. sg.', 'fém. sg.', 'neutre sg.'],
      [
        ['nom.', 'ipse', 'ipsa', 'ipsum'],
        ['acc.', 'ipsum', 'ipsam', 'ipsum'],
        ['gén.', 'ipsius', 'ipsius', 'ipsius'],
        ['dat.', 'ipsi', 'ipsi', 'ipsi'],
        ['abl.', 'ipso', 'ipsa', 'ipso'],
      ],
    ),
    const SizedBox(height: 8),
    _tableauColonnes(
      ['cas', 'masc. pl.', 'fém. pl.', 'neutre pl.'],
      [
        ['nom.', 'ipsi', 'ipsae', 'ipsa'],
        ['acc.', 'ipsos', 'ipsas', 'ipsa'],
        ['gén.', 'ipsorum', 'ipsarum', 'ipsorum'],
        ['dat./abl.', 'ipsis', 'ipsis', 'ipsis'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'La déclinaison de ipse présente de nombreuses terminaisons '
      'appartenant à la 1re et à la 2e déclinaison, notamment au '
      'pluriel. Le génitif est en -jus, le datif en -i, terminaisons '
      'caractéristiques des pronoms-adjectifs (cf. ejus, cujus, hujus, '
      'istius, illius et ei, cui, huic, isti, illi).',
    ),
    _titreExplication('Le sens de ipse'),
    _paragrapheExplication(
      'Le pronom-adjectif ipse marque une insistance, une originalité '
      ':\n\n'
      '• pronom : « moi-même, toi-même, lui-même, elle-même, '
      'nous-mêmes », etc.\n'
      '• adjectif : « même, lui-même, elle-même », etc.',
    ),
    _titreExplication('« Même » avec ou sans trait d\'union ?'),
    _paragrapheExplication(
      'Il faut mettre un trait d\'union devant « même » si le mot qui '
      'précède est un pronom personnel : moi, toi, soi, lui, elle, '
      'nous, vous, eux, elles (remarque : avec « nous, vous, eux, '
      'elles », il faut mettre « même » au pluriel : nous-mêmes, '
      'vous-mêmes, eux-mêmes, elles-mêmes).\n\n'
      'On ne met pas de trait d\'union dans les autres cas : le jour '
      'même, cela même, ici même...',
    ),
    _titreExplication('Comment bien traduire ipse ?'),
    _paragrapheExplication(
      'Afin d\'améliorer ta traduction, tu peux avoir recours à '
      'd\'autres tournures pour traduire ipse.\n\n'
      'Te ipsum quaerebam. (Je te cherchais [toi-même].) → Je te '
      'cherchais toi précisément.\n'
      'Philippus ipse venit. (Philippe [lui-même] vint.) → Philippe '
      'vint en personne, personnellement.\n'
      'Ipsam vitam patriae dedit. (Il donna à sa patrie [sa vie '
      'elle-même].) → jusqu\'à sa vie.\n'
      'Janua se ipsa aperuit. (La porte s\'ouvrit [elle-même].) → '
      'd\'elle-même, toute seule.\n'
      'in ipso foro (sur la place publique [elle-même]) → en pleine '
      'place publique\n'
      'eo ipso die (ce jour-là [lui-même]) → ce jour-là justement, '
      'précisément\n'
      'sua ipsius manu (avec sa main [de lui-même]) → de sa propre '
      'main',
    ),
    _paragrapheExplication(
      'Ipse (« même », « lui-même ») exprime une insistance, une '
      'originalité, c\'est-à-dire « lui » par opposition à « un autre '
      '» envisagé explicitement ou non. Voilà pourquoi il est parfois '
      'utile de recourir à des tournures comme « justement », « '
      'précisément », « en personne », « propre », pour rendre cette '
      'idée.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Avec quoi ipse s\'accorde-t-il en personne ?',
      options: [
        'le sujet du verbe, exprimé par la terminaison verbale',
        'toujours la 3e personne',
        'l\'antécédent le plus proche',
        'le complément d\'objet',
      ],
      reponseCorrecte: 'le sujet du verbe, exprimé par la terminaison verbale',
    ),
    QuestionLecon(
      question: 'Quel est le génitif singulier (3 genres) de ipse, ipsa, ipsum ?',
      options: ['ipsius', 'ipsi', 'ipso', 'ipsum'],
      reponseCorrecte: 'ipsius',
    ),
    QuestionLecon(
      question: 'Que marque le pronom-adjectif ipse ?',
      options: ['une insistance, une originalité', 'une identité, une similitude', 'une négation', 'une comparaison'],
      reponseCorrecte: 'une insistance, une originalité',
    ),
    QuestionLecon(
      question: 'Faut-il un trait d\'union dans « il vint lui-même » ?',
      options: [
        'oui, car « même » suit un pronom personnel (lui)',
        'non, jamais',
        'seulement au pluriel',
        'seulement à l\'écrit soutenu',
      ],
      reponseCorrecte: 'oui, car « même » suit un pronom personnel (lui)',
    ),
    QuestionLecon(
      question:
          'Comment traduire plus naturellement « Philippus ipse venit '
          '» (« Philippe lui-même vint ») ?',
      options: [
        'Philippe vint en personne.',
        'Philippe vint le même jour.',
        'Philippe et un autre vinrent.',
        'Philippe ne vint pas.',
      ],
      reponseCorrecte: 'Philippe vint en personne.',
    ),
    QuestionLecon(
      question:
          'Que met en avant ipse, quand on dit qu\'il oppose « lui » à '
          '« un autre » ?',
      options: [
        'une insistance sur l\'identité précise de la personne/chose',
        'une comparaison de quantité',
        'une négation',
        'une question',
      ],
      reponseCorrecte: 'une insistance sur l\'identité précise de la personne/chose',
    ),
    ExerciceSaisie(
      question: 'Quel est l\'ablatif féminin singulier de ipse, ipsa, ipsum ?',
      reponsesAcceptees: ['ipsa'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'ipse marque l\'insistance et l\'originalité (« lui-même », '
        'par opposition à un autre) — à distinguer de idem, qui marque '
        'l\'identité et la similitude (« le même »).',
      ),
      _tableauColonnes(
        ['cas', 'masc. sg.', 'fém. sg.', 'neutre sg.'],
        [
          ['nom.', 'ipse', 'ipsa', 'ipsum'],
          ['gén.', 'ipsius', 'ipsius', 'ipsius'],
          ['dat.', 'ipsi', 'ipsi', 'ipsi'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Adjectifs et pronoms interrogatifs / exclamatifs
// ------------------------------------------------------------

final Lecon _leconInterrogatifsExclamatifs = Lecon(
  id: 'interrogatifs_exclamatifs',
  titre: 'Adjectifs et pronoms interrogatifs / exclamatifs',
  sousTitre: 'quis/quid, qui/quae/quod, quam, qualis, quantus',
  icone: Icons.priority_high,
  unite: 'Vol. II – Unité 4',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('Je me rappelle'),
    _paragrapheExplication(
      'Tu as déjà étudié l\'interrogation directe : l\'interrogation '
      'totale (-ne...?, nonne...?, num...?) et l\'interrogation '
      'partielle (ubi...?, quo...?, cur...?).',
    ),
    _titreExplication('Le pronom interrogatif : quis, quae, quid'),
    _paragrapheExplication(
      'Les pronoms interrogatifs servent à interroger sur l\'identité '
      'd\'une personne ou d\'une chose, ainsi que sur la nature d\'une '
      'action.\n\n'
      'Ex. : Quis venit ? (Qui est venu ?) Quid vidisti ? (Qu\'est-ce '
      'que tu as vu ?) Quem vidisti ? (Qui est-ce que tu as vu ?)',
    ),
    _tableauColonnes(
      ['cas', 'masc. sg.', 'fém. sg.', 'neutre sg.'],
      [
        ['nom.', 'quis', 'quae', 'quid'],
        ['acc.', 'quem', 'quam', 'quid'],
        ['gén.', 'cujus', 'cujus', 'cujus'],
        ['dat.', 'cui', 'cui', 'cui'],
        ['abl.', 'quo', 'qua', 'quo'],
      ],
    ),
    const SizedBox(height: 8),
    _paragrapheExplication(
      'Au pluriel, le pronom interrogatif se décline exactement comme '
      'le relatif qui, quae, quod (qui, quae, quae au nominatif, etc.).',
    ),
    _titreExplication('L\'adjectif interrogatif : qui, quae, quod'),
    _paragrapheExplication(
      'Pour s\'informer sur l\'identité ou la qualité, on utilise '
      'l\'adjectif interrogatif, qui s\'accorde en genre et en nombre '
      'avec le nom auquel il se rapporte. La déclinaison de l\'adjectif '
      'interrogatif est identique à celle du relatif qui, quae, quod.\n\n'
      'Ex. : Qui servus venit ? (Quel esclave est venu ?) Quod templum '
      'vidisti ? (Quel temple as-tu vu ?)',
    ),
    _paragrapheExplication(
      'Excepté le pronom interrogatif au nominatif masculin et aux '
      'nominatif/accusatif neutres singuliers (quis ? et quid ?), les '
      'adjectifs et pronoms interrogatifs se déclinent donc comme le '
      'relatif qui, quae, quod. Attention à ne pas confondre :\n\n'
      'pronom interrogatif : Quis venit ? (« Qui est venu ? »)\n'
      'adjectif interrogatif : Qui vir venit ? (« Quel homme est '
      'venu ? »)',
    ),
    _titreExplication('Particularité : le cum d\'accompagnement'),
    _paragrapheExplication(
      'Le cum d\'accompagnement se place après le pronom-adjectif '
      'interrogatif et se soude à lui, comme pour le relatif '
      '(quocum, quibuscum...).\n\n'
      'Ex. : Quibuscum amicis Ledona oppidum petivit ? (À qui as-tu '
      'parlé ? littéralement : Avec quels amis Ledona a-t-elle gagné '
      'la place forte ?)',
    ),
    _titreExplication('Un adverbe interrogatif : quam'),
    _paragrapheExplication(
      'Pour s\'informer sur le degré ou la quantité, on utilise '
      'l\'adverbe interrogatif quam, suivi d\'un adjectif ou d\'un '
      'adverbe (« combien + adj./adv. »). Pour s\'informer sur le '
      'nombre, on utilise quam multi, ae, a ou l\'adverbe invariable '
      'quot.\n\n'
      'Ex. : Quam dives est ? (Combien riche est-il ? = À quel point '
      'est-il riche ?) Quam multi / Quot milites venerunt ? (Combien '
      'de soldats sont venus ?)',
    ),
    _titreExplication('Des adjectifs interrogatifs pour la qualité et la grandeur'),
    _paragrapheExplication(
      'Le latin connaît d\'autres adjectifs interrogatifs :\n\n'
      '• qualis, e ? (« Quelle sorte de ? »)\n'
      '• quantus, a, um ? (« Combien grand ? De quelle grandeur ? »)\n\n'
      'Ex. : Qualis vir es ? (Quelle sorte d\'homme es-tu ?) Quanta est '
      'ejus audacia ? (Quelle est son audace ?)',
    ),
    _titreExplication('L\'emploi exclamatif des adjectifs interrogatifs'),
    _paragrapheExplication(
      'Les adjectifs interrogatifs peuvent s\'employer comme '
      'exclamatifs dans une phrase qui traduit une émotion forte (joie, '
      'contrariété, surprise...) et qui peut se réduire à un simple '
      'groupe nominal au nominatif ou à l\'accusatif. En présence d\'un '
      'verbe, le français ne met pas l\'inversion.\n\n'
      'Ex. : Quem virum ! (Quel homme !) Quam multi milites ! (Combien '
      'de soldats !)\n\n'
      'Qualis artifex pereo ! (Quel artiste périt avec moi ! — '
      'dernières paroles de Néron selon Suétone.)\n'
      'Quanta est audacia ! (Comme ton audace est grande !)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'Sur quoi les pronoms interrogatifs servent-ils à '
          'interroger ?',
      options: [
        'l\'identité d\'une personne/chose, ou la nature d\'une action',
        'uniquement le lieu',
        'uniquement le temps',
        'uniquement la cause',
      ],
      reponseCorrecte:
          'l\'identité d\'une personne/chose, ou la nature d\'une action',
    ),
    QuestionLecon(
      question: 'Quel est le nominatif masculin singulier du pronom interrogatif ?',
      options: ['quis', 'qui', 'quid', 'quod'],
      reponseCorrecte: 'quis',
    ),
    QuestionLecon(
      question: 'Quel est le nominatif/accusatif neutre singulier du pronom interrogatif ?',
      options: ['quid', 'quis', 'quod', 'qua'],
      reponseCorrecte: 'quid',
    ),
    QuestionLecon(
      question:
          'À quelle déclinaison l\'adjectif interrogatif qui, quae, '
          'quod est-il identique ?',
      options: [
        'celle du relatif qui, quae, quod',
        'celle de is, ea, id',
        'celle de hic, haec, hoc',
        'celle de ipse, ipsa, ipsum',
      ],
      reponseCorrecte: 'celle du relatif qui, quae, quod',
    ),
    QuestionLecon(
      question: 'Dans « Quis venit ? », quis est...',
      options: ['un pronom interrogatif', 'un adjectif interrogatif', 'un adverbe', 'une conjonction'],
      reponseCorrecte: 'un pronom interrogatif',
    ),
    QuestionLecon(
      question: 'Dans « Qui vir venit ? », qui est...',
      options: ['un adjectif interrogatif', 'un pronom interrogatif', 'un adverbe', 'une conjonction'],
      reponseCorrecte: 'un adjectif interrogatif',
    ),
    QuestionLecon(
      question: 'Que signifie quam devant un adjectif ou un adverbe ?',
      options: ['combien (+ adj./adv.)', 'où', 'pourquoi', 'quand'],
      reponseCorrecte: 'combien (+ adj./adv.)',
    ),
    QuestionLecon(
      question: 'Que signifie l\'adverbe invariable quot ?',
      options: ['combien (de) — quam multi, ae, a', 'où', 'quel', 'combien grand'],
      reponseCorrecte: 'combien (de) — quam multi, ae, a',
    ),
    QuestionLecon(
      question: 'Que signifie qualis, e ?',
      options: ['quelle sorte de ?', 'combien grand ?', 'combien de ?', 'où ?'],
      reponseCorrecte: 'quelle sorte de ?',
    ),
    QuestionLecon(
      question: 'Que signifie quantus, a, um ?',
      options: ['combien grand ? de quelle grandeur ?', 'quelle sorte de ?', 'combien de fois ?', 'quand ?'],
      reponseCorrecte: 'combien grand ? de quelle grandeur ?',
    ),
    QuestionLecon(
      question:
          'Quand un adjectif interrogatif est employé comme exclamatif '
          'avec un verbe, le français met-il l\'inversion ?',
      options: ['non', 'oui, toujours', 'seulement au pluriel', 'seulement au passé'],
      reponseCorrecte: 'non',
    ),
    ExerciceSaisie(
      question: 'Quel est le génitif singulier (3 genres) du pronom/adjectif interrogatif ?',
      reponsesAcceptees: ['cujus'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Pronom interrogatif quis/quid : identité ou nature d\'une '
        'action. Adjectif interrogatif qui/quae/quod : identité ou '
        'qualité, décliné comme le relatif.\n\n'
        'quam + adj./adv. = combien... quot = quam multi, ae, a\n'
        'qualis, e = quelle sorte de ? quantus, a, um = combien grand ?',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Participe et infinitif futurs
// ------------------------------------------------------------

final Lecon _leconParticipeInfinitifFuturs = Lecon(
  id: 'participe_infinitif_futurs',
  titre: 'Participe et infinitif futurs',
  sousTitre: 'amaturus, a, um — et la postériorité complète dans l\'ACI',
  icone: Icons.flight_takeoff,
  unite: 'Vol. II – Unité 4',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      '« Ave imperator, morituri te salutant. » (Salut empereur, ceux '
      'qui vont mourir te saluent !)',
    ),
    _titreExplication('La formation du participe futur actif'),
    _paragrapheExplication(
      'On obtient le participe futur actif en ajoutant -urus, -ura, '
      '-urum au radical du supin.',
    ),
    _tableauColonnes(
      ['verbe', 'supin', 'participe futur'],
      [
        ['amare', 'amatum', 'amaturus, a, um'],
        ['monere', 'monitum', 'moniturus, a, um'],
        ['mittere', 'missum', 'missurus, a, um'],
        ['capere', 'captum', 'capturus, a, um'],
        ['audire', 'auditum', 'auditurus, a, um'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Les verbes qui n\'ont pas de supin n\'ont donc, en principe, pas '
      'de participe futur. Pourtant, le verbe esse et ses composés en '
      'ont un : futurus, a, um ; profuturus, a, um ; etc.',
    ),
    _titreExplication('Le sens du participe futur'),
    _paragrapheExplication(
      'Le participe futur exprime une idée d\'avenir que le français ne '
      'peut traduire telle quelle, mais qu\'il peut rendre par les '
      'tournures suivantes.\n\n'
      'amaturus, a, um = sur le point d\'aimer / ayant l\'intention '
      'd\'aimer / disposé à aimer / destiné à aimer',
    ),
    _paragrapheExplication(
      'On peut trouver ce participe futur employé comme adjectif, '
      'apposé à un autre mot de la phrase ou comme adjectif '
      'substantivé.\n\n'
      'Ex. : Dux milites pugnaturos laudat. (Le chef loue les soldats '
      'disposés à combattre.)',
    ),
    _paragrapheExplication(
      'De même que les participes présent et parfait, le participe '
      'futur apposé peut être traduit par une subordonnée relative en '
      'français.\n\n'
      'Ex. : Novistine amicos venturos ? (Connais-tu les amis qui vont '
      'venir ?)',
    ),
    _titreExplication('Le participe futur, attribut du sujet'),
    _paragrapheExplication(
      'Le participe futur s\'emploie souvent comme attribut du sujet, '
      'avec le verbe esse conjugué à tous les temps, pour exprimer '
      'l\'intention, la fatalité ou le futur proche.\n\n'
      'amaturus sum (eram, ero...) = j\'ai (j\'avais, j\'aurai...) '
      'l\'intention d\'aimer, je suis (j\'étais, je serai...) disposé/'
      'destiné/sur le point d\'aimer\n'
      'amaturus sum (eram) = je vais (j\'allais) aimer',
    ),
    _paragrapheExplication(
      'Étymologiquement, le mot « aventure » provient du participe '
      'futur du verbe advenire (« arriver ») : en latin vulgaire, '
      'adventura désigne littéralement « les/des choses qui vont '
      'arriver ». Des neutres pluriels en -a ont été réinterprétés en '
      'féminins singuliers de la 1re déclinaison — comme dans une '
      'arme (< arma, orum, « les armes »), une feuille (< folia, orum, '
      '« ensemble de feuilles ») ou une pomme (< poma, orum, « '
      'ensemble de fruits »).',
    ),
    _titreExplication('L\'infinitif futur'),
    _paragrapheExplication(
      'On utilise le participe futur pour former l\'infinitif futur. '
      'Celui-ci est le plus souvent employé dans une proposition '
      'infinitive (ACI), où il apparaît à l\'accusatif et exprime '
      'toujours la postériorité. Selon les exigences de la concordance '
      'des temps en français, on le traduit par un futur simple ou un '
      'conditionnel présent.\n\n'
      'On obtient l\'infinitif futur actif en ajoutant esse au '
      'participe futur actif : amaturum, am, um + esse.',
    ),
    _paragrapheExplication(
      'Le participe futur du verbe esse est futurus, a, um. Son '
      'infinitif futur est donc futurum/futuram/futurum esse (ou '
      'futuros/futuras/futura esse), ou la forme invariable fore '
      '(moins attestée pour les composés du verbe esse).\n\n'
      'Ex. : Putat liberos beatos futuros esse / fore. (Elle pense que '
      'les enfants seront heureux.)\n'
      'Putavit liberos beatos futuros esse / fore. (Elle a pensé que '
      'les enfants seraient heureux.)\n\n'
      'Parmi les composés du verbe esse, seul posse n\'a pas '
      'd\'infinitif futur.',
    ),
    _titreExplication('Le tableau complet des rapports de temps dans l\'ACI'),
    _paragrapheExplication(
      'Tu peux à présent exprimer tous les rapports de temps dans la '
      'proposition infinitive.',
    ),
    _tableauColonnes(
      ['infinitif latin', 'rapport', 'si Puto... (« je crois »)', 'si Putabam... (« je croyais »)'],
      [
        [
          'venisse (parfait)',
          'antériorité',
          'que ton fils est venu',
          'que ton fils était venu',
        ],
        [
          'venire (présent)',
          'simultanéité',
          'que ton fils vient',
          'que ton fils venait',
        ],
        [
          'venturum esse (futur)',
          'postériorité',
          'que ton fils viendra',
          'que ton fils viendrait',
        ],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Comment se forme le participe futur actif ?',
      options: [
        'radical du supin + -urus, -ura, -urum',
        'radical du perfectum + -urus, -ura, -urum',
        'radical du présent + -urus, -ura, -urum',
        'radical du supin + -ns, -ntis',
      ],
      reponseCorrecte: 'radical du supin + -urus, -ura, -urum',
    ),
    QuestionLecon(
      question: 'Quel est le participe futur de mittere (supin missum) ?',
      options: ['missurus, a, um', 'mittens, -ntis', 'misisse', 'missus, a, um'],
      reponseCorrecte: 'missurus, a, um',
    ),
    QuestionLecon(
      question: 'Quel est le participe futur de esse ?',
      options: ['futurus, a, um', 'essens', 'futurum', 'fuisse'],
      reponseCorrecte: 'futurus, a, um',
    ),
    QuestionLecon(
      question:
          'Quel composé de esse n\'a pas d\'infinitif futur ?',
      options: ['posse', 'adesse', 'prodesse', 'praeesse'],
      reponseCorrecte: 'posse',
    ),
    QuestionLecon(
      question:
          'Que traduit-on par « sur le point d\'aimer / ayant '
          'l\'intention d\'aimer / disposé à aimer » ?',
      options: ['amaturus, a, um', 'amans, -ntis', 'amatus, a, um', 'amavisse'],
      reponseCorrecte: 'amaturus, a, um',
    ),
    QuestionLecon(
      question: 'Comment forme-t-on l\'infinitif futur actif ?',
      options: [
        'participe futur actif + esse',
        'participe futur actif + isse',
        'radical du présent + -re',
        'radical du perfectum + -isse',
      ],
      reponseCorrecte: 'participe futur actif + esse',
    ),
    QuestionLecon(
      question: 'Quel rapport de temps l\'infinitif futur exprime-t-il dans l\'ACI ?',
      options: ['la postériorité', 'la simultanéité', 'l\'antériorité', 'aucun rapport de temps'],
      reponseCorrecte: 'la postériorité',
    ),
    QuestionLecon(
      question:
          'Si le verbe introducteur est au présent (ex. puto, « je '
          'crois »), comment se traduit un infinitif futur exprimant la '
          'postériorité ?',
      options: ['par un futur simple', 'par un passé composé', 'par un imparfait', 'par un plus-que-parfait'],
      reponseCorrecte: 'par un futur simple',
    ),
    QuestionLecon(
      question:
          'Si le verbe introducteur est au passé (ex. putabam, « je '
          'croyais »), comment se traduit un infinitif futur exprimant '
          'la postériorité ?',
      options: ['par un conditionnel présent', 'par un futur simple', 'par un passé composé', 'par un présent'],
      reponseCorrecte: 'par un conditionnel présent',
    ),
    QuestionLecon(
      question: 'Quelle est la forme invariable de l\'infinitif futur de esse ?',
      options: ['fore', 'futurum', 'esse', 'futurus'],
      reponseCorrecte: 'fore',
    ),
    ExerciceSaisie(
      question: 'Quel est le participe futur de amare (supin amatum) ?',
      reponsesAcceptees: ['amaturus', 'amaturus, a, um'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        '1. participe apposé : amaturus, a, um = sur le point '
        'd\'aimer / ayant l\'intention d\'aimer / disposé, destiné à '
        'aimer.\n\n'
        '2. attribut du sujet (esse à tous les temps) : amaturus sum '
        '(eram, ero...) = je vais aimer, j\'allais aimer...\n\n'
        '3. infinitif futur (postériorité dans l\'ACI) : amaturum, am, '
        'um + esse.',
      ),
      _tableauColonnes(
        ['infinitif latin', 'rapport', 'traduction'],
        [
          ['parfait', 'antériorité', 'passé (ex. est venu)'],
          ['présent', 'simultanéité', 'même temps que la principale'],
          ['futur', 'postériorité', 'futur/conditionnel'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les pronoms personnels et les adjectifs possessifs
// ------------------------------------------------------------

final Lecon _leconPronomsPersonnelsPossessifs = Lecon(
  id: 'pronoms_personnels_possessifs',
  titre: 'Les pronoms personnels et les adjectifs possessifs',
  sousTitre: 'ego/tu/nos/vos, le réfléchi se, meus/tuus/suus...',
  icone: Icons.groups,
  unite: 'Vol. II – Unité 5',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('Les pronoms personnels des 1re et 2e personnes'),
    _tableauColonnes(
      ['cas', '1re sg.', '1re pl.', '2e sg.', '2e pl.'],
      [
        ['nom.', 'ego', 'nos', 'tu', 'vos'],
        ['voc.', '—', '—', 'tu', 'vos'],
        ['acc.', 'me', 'nos', 'te', 'vos'],
        ['gén.', 'mei', 'nostrum / nostri', 'tui', 'vestrum / vestri'],
        ['dat.', 'mihi', 'nobis', 'tibi', 'vobis'],
        ['abl.', 'me', 'nobis', 'te', 'vobis'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Seuls les pronoms de la 2e personne ont un vocatif. La '
      'préposition cum (« avec ») se place après le pronom personnel '
      'et se soude à lui : mecum, tecum, nobiscum, vobiscum.',
    ),
    _paragrapheExplication(
      'nostrum et vestrum ont un sens partitif (« d\'entre nous/vous, '
      'parmi nous/vous »).\n\n'
      'Ex. : unus nostrum (l\'un d\'entre nous) ; Quis vestrum ? (Qui '
      'd\'entre vous ?)',
    ),
    _paragrapheExplication(
      'nostri et vestri s\'emploient comme compléments au génitif d\'un '
      'verbe ou d\'un adjectif, par exemple avec memor, memoris + '
      'génitif (« qui se souvient de »).\n\n'
      'Ex. : nostri memores (les gens qui se souviennent de nous)',
    ),
    _titreExplication('Le pronom personnel de la 3e personne : se'),
    _paragrapheExplication(
      'Tu connais déjà des pronoms de la 3e personne : le pronom de '
      'rappel is, ea, id et les démonstratifs hic, iste, ille. Le '
      'latin connaît un autre pronom de la 3e personne : le pronom '
      'personnel réfléchi se.',
    ),
    _paragrapheExplication(
      'Le pronom se est un pronom réfléchi : il renvoie au sujet de la '
      'proposition dans laquelle il se trouve. Le pronom réfléchi '
      'n\'existe donc pas au nominatif : il ne peut à la fois être '
      'sujet et renvoyer simultanément au sujet.\n\n'
      'Astuce mnémotechnique : se, sui, sibi renvoient au sujet.',
    ),
    _tableauColonnes(
      ['cas', '3e pers. (sg. et pl., identiques)'],
      [
        ['nom.', '—'],
        ['voc.', '—'],
        ['acc.', 'se'],
        ['gén.', 'sui'],
        ['dat.', 'sibi'],
        ['abl.', 'se'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Le singulier et le pluriel de se sont identiques, comme en '
      'français (« il se lave » et « ils se lavent »).',
    ),
    _titreExplication('Les emplois des pronoms personnels'),
    _paragrapheExplication(
      'Le sujet étant indiqué par la terminaison du verbe, les '
      'nominatifs ego, tu, nos, vos ne s\'emploient que pour insister '
      'sur une personne.\n\n'
      'Ex. : Ego Romanus sum, tu Graecus es.',
    ),
    _paragrapheExplication(
      'On tutoie tout le monde en latin : Ave Caesar, morituri te '
      'salutant.',
    ),
    _paragrapheExplication(
      'Le latin ignore l\'ordre de politesse du français ; il cite les '
      'personnes dans l\'ordre suivant : 1re, 2e, 3e personne.\n\n'
      'Ex. : Ego et pater venimus. (Mon père et moi sommes venus — '
      'littéralement « moi et le père sommes venus ».)',
    ),
    _paragrapheExplication(
      'L\'action réciproque (« les uns les autres ») peut s\'exprimer '
      'par inter nos, inter vos, inter se.\n\n'
      'Ex. : Inter nos laudamus. (Nous nous louons les uns les '
      'autres.)',
    ),
    _titreExplication('Les adjectifs possessifs'),
    _paragrapheExplication(
      'Les adjectifs possessifs se déclinent comme les adjectifs de la '
      '1re classe.',
    ),
    _tableauColonnes(
      ['', 'singulier', 'pluriel'],
      [
        ['1re pers.', 'meus, mea, meum (mon, ma, mes)', 'noster, nostra, nostrum (notre, nos)'],
        ['2e pers.', 'tuus, tua, tuum (ton, ta, tes)', 'vester, vestra, vestrum (votre, vos)'],
        ['3e pers.', 'suus, sua, suum (son, sa, ses)', 'suus, sua, suum (leur, leurs)'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Le vocatif de meus est mi : Tu quoque, mi fili. (Toi aussi, mon '
      'fils.)',
    ),
    _titreExplication('Les emplois des adjectifs possessifs'),
    _paragrapheExplication(
      'Les adjectifs possessifs se placent en général après le nom '
      'qu\'ils déterminent (patria nostra, « notre patrie »), et ne '
      's\'expriment que s\'ils sont nécessaires pour préciser le sens.\n\n'
      'Ex. : Amo patrem. (J\'aime mon père — sous-entendu.) Mater mea '
      'vidit tuam. (Ma mère a vu la tienne.)',
    ),
    _paragrapheExplication(
      'Les adjectifs possessifs expriment parfois une nuance '
      'd\'affection.\n\n'
      'Ex. : Publius noster. (Notre cher Publius.)',
    ),
    _paragrapheExplication(
      'Comme tout autre adjectif, les adjectifs possessifs peuvent '
      'être substantivés. En français, on les traduit par le pronom '
      'possessif (le mien, le tien, le sien...). Il est parfois '
      'nécessaire de préciser le sens des adjectifs substantivés : '
      'mei, orum, m. pl. = les miens = mes amis, ma famille... ; mea, '
      'orum, n. pl. = les miens = mes « choses », mes biens.\n\n'
      'Ex. : Milites sua suosque relinquere debuerunt. (Les soldats '
      'durent abandonner leurs biens et leurs proches.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quel est le génitif singulier de ego ?',
      options: ['mei', 'mihi', 'me', 'nostrum'],
      reponseCorrecte: 'mei',
    ),
    QuestionLecon(
      question: 'Quel est le datif singulier de tu ?',
      options: ['tibi', 'tui', 'te', 'vobis'],
      reponseCorrecte: 'tibi',
    ),
    QuestionLecon(
      question: 'Quels pronoms personnels ont un vocatif ?',
      options: [
        'seulement ceux de la 2e personne',
        'seulement ceux de la 1re personne',
        'tous',
        'aucun',
      ],
      reponseCorrecte: 'seulement ceux de la 2e personne',
    ),
    QuestionLecon(
      question: 'Comment se forme mecum, tecum, nobiscum, vobiscum ?',
      options: [
        'cum se place après le pronom personnel et se soude à lui',
        'cum se place avant le pronom',
        'ce sont des mots indépendants',
        'cum ne s\'utilise jamais avec les pronoms personnels',
      ],
      reponseCorrecte: 'cum se place après le pronom personnel et se soude à lui',
    ),
    QuestionLecon(
      question: 'Que signifie le sens partitif de nostrum/vestrum (ex. unus nostrum) ?',
      options: ['d\'entre nous / vous', 'notre / votre', 'à nous / vous', 'par nous / vous'],
      reponseCorrecte: 'd\'entre nous / vous',
    ),
    QuestionLecon(
      question: 'Pourquoi le pronom réfléchi se n\'a-t-il pas de nominatif ?',
      options: [
        'il ne peut pas être à la fois sujet et renvoyer au sujet',
        'ce n\'est pas un pronom complet',
        'il n\'existe qu\'au pluriel',
        'aucune raison particulière',
      ],
      reponseCorrecte: 'il ne peut pas être à la fois sujet et renvoyer au sujet',
    ),
    QuestionLecon(
      question: 'Le pronom réfléchi se est-il différent au singulier et au pluriel ?',
      options: ['non, il est identique', 'oui, complètement différent', 'seulement au génitif', 'seulement à l\'accusatif'],
      reponseCorrecte: 'non, il est identique',
    ),
    QuestionLecon(
      question: 'Quand emploie-t-on les nominatifs ego, tu, nos, vos ?',
      options: [
        'pour insister sur une personne',
        'systématiquement, comme sujet',
        'jamais',
        'seulement à l\'écrit',
      ],
      reponseCorrecte: 'pour insister sur une personne',
    ),
    QuestionLecon(
      question:
          'Dans quel ordre le latin cite-t-il les personnes (contrairement au français) ?',
      options: ['1re, 2e, 3e personne', '3e, 2e, 1re personne', '2e, 1re, 3e personne', 'aucun ordre précis'],
      reponseCorrecte: '1re, 2e, 3e personne',
    ),
    QuestionLecon(
      question: 'Comment exprime-t-on « les uns les autres » ?',
      options: ['inter nos / vos / se', 'alii... alii', 'quisque', 'uterque'],
      reponseCorrecte: 'inter nos / vos / se',
    ),
    QuestionLecon(
      question: 'Comme quel type d\'adjectif les adjectifs possessifs se déclinent-ils ?',
      options: ['les adjectifs de la 1re classe', 'les adjectifs de la 2e classe', 'les pronoms-adjectifs', 'ils sont invariables'],
      reponseCorrecte: 'les adjectifs de la 1re classe',
    ),
    ExerciceSaisie(
      question: 'Quel est le vocatif singulier de meus (« mon ») ?',
      reponsesAcceptees: ['mi'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['cas', '1re sg.', '2e sg.', '3e (réfléchi)'],
        [
          ['nom.', 'ego', 'tu', '—'],
          ['acc.', 'me', 'te', 'se'],
          ['gén.', 'mei', 'tui', 'sui'],
          ['dat.', 'mihi', 'tibi', 'sibi'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Possessifs : meus/tuus/suus (sg.), noster/vester/suus (pl.), '
        'déclinés comme bonus, a, um.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : L'emploi des réfléchis direct et indirect
// ------------------------------------------------------------

final Lecon _leconReflechisDirectIndirect = Lecon(
  id: 'reflechis_direct_indirect',
  titre: 'L\'emploi des réfléchis direct et indirect',
  sousTitre: 'se/suus : au sujet de la proposition, ou de la principale ?',
  icone: Icons.loop,
  unite: 'Vol. II – Unité 5',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('Le réfléchi direct'),
    _paragrapheExplication(
      'Le maître est fâché parce que l\'esclave a perdu ses '
      'chaussures. → Quelles chaussures l\'esclave a-t-il perdues ? '
      'Les siennes ou celles du maître ? En français, ce n\'est pas '
      'clair. En latin, en revanche, on trouvera calceos suos, s\'il '
      's\'agit des chaussures de l\'esclave, et ejus calceos, s\'il '
      's\'agit des chaussures du maître.',
    ),
    _paragrapheExplication(
      'La même réflexion s\'applique au pronom réfléchi se.\n\n'
      'Ex. : Superbi se laudant, sed eorum cives eos non laudant. (Les '
      'orgueilleux se louent, mais leurs concitoyens ne les louent '
      'pas.)',
    ),
    _paragrapheExplication(
      'Tu connais donc déjà l\'emploi du réfléchi direct, qu\'il soit '
      'pronom ou adjectif possessif : dans une proposition '
      'indépendante, principale ou subordonnée, le pronom réfléchi se '
      'et l\'adjectif possessif réfléchi suus, a, um renvoient au sujet '
      'de la même proposition.',
    ),
    _titreExplication('Je me rappelle'),
    _paragrapheExplication(
      'Pour traduire « son, sa, ses, leur, leurs », le latin utilise '
      ':\n\n'
      '• l\'adjectif possessif suus, a, um, si le possessif renvoie au '
      'sujet de la même proposition ;\n'
      '• le pronom au génitif ejus, eorum, earum, si le possessif ne '
      'renvoie pas au sujet de la même proposition.',
    ),
    _titreExplication('Cas particulier : le réfléchi indirect'),
    _paragrapheExplication(
      'Quintus credit [se esse beatum]. → se = Quintus ? OUI.\n'
      'Quintus credit [eum esse beatum]. → eum = Quintus ? NON.\n'
      'Quintus credit [parentes suos esse beatos]. → parentes suos = '
      'les parents de Quintus ? OUI.\n'
      'Quintus credit [ejus parentes esse beatos]. → ejus parentes = '
      'les parents de Quintus ? NON.',
    ),
    _paragrapheExplication(
      'Dans une proposition subordonnée qui exprime la parole ou la '
      'pensée de quelqu\'un, le pronom réfléchi se et l\'adjectif '
      'possessif réfléchi suus renvoient :\n\n'
      '• ou bien au sujet de la même proposition = réfléchi direct\n'
      '• ou bien au sujet de la proposition principale = réfléchi '
      'indirect',
    ),
    _paragrapheExplication(
      'Parmi les subordonnées qui expriment la parole ou la pensée de '
      'quelqu\'un, tu connais pour l\'instant uniquement la proposition '
      'infinitive (ACI). Tu apprendras encore les subordonnées '
      'complétives introduites par ut (par exemple après un verbe de '
      'souhait ou de volonté), les subordonnées circonstancielles de '
      'but (ut, « pour que » ; ne, « pour que ne pas ») et les '
      'subordonnées interrogatives indirectes.',
    ),
    _titreExplication('Méthode pratique pour le thème'),
    _paragrapheExplication(
      '1. Est-ce que le pronom ou l\'adjectif de la 3e personne '
      'renvoie au sujet de la même proposition ?\n'
      '   → oui : réfléchi (se / suus)\n'
      '   → non : passe à l\'étape 2\n\n'
      '2. Est-ce que la subordonnée est un ACI ?\n'
      '   → non : non réfléchi (is, ea, id / ejus, eorum, earum)\n'
      '   → oui : passe à l\'étape 3\n\n'
      '3. Est-ce que le pronom ou l\'adjectif de la 3e personne '
      'renvoie au sujet de la proposition principale ?\n'
      '   → oui : réfléchi (se / suus) — réfléchi indirect\n'
      '   → non : non réfléchi (is, ea, id / ejus, eorum, earum)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Dans une proposition indépendante, à qui renvoient se et suus ?',
      options: [
        'au sujet de la même proposition',
        'au sujet de la proposition principale',
        'à l\'objet le plus proche',
        'ils ne renvoient à rien de précis',
      ],
      reponseCorrecte: 'au sujet de la même proposition',
    ),
    QuestionLecon(
      question: 'Que signifie « calceos suos » (par opposition à « ejus calceos ») ?',
      options: [
        'ses (propres) chaussures, celles du sujet',
        'les chaussures d\'un autre',
        'des chaussures neuves',
        'les chaussures perdues'
      ],
      reponseCorrecte: 'ses (propres) chaussures, celles du sujet',
    ),
    QuestionLecon(
      question:
          'Dans quel type de subordonnée peut-on rencontrer un réfléchi '
          'indirect ?',
      options: [
        'une subordonnée qui exprime la parole/pensée de quelqu\'un (ex. l\'ACI)',
        'n\'importe quelle subordonnée',
        'seulement les relatives',
        'seulement les subordonnées de temps',
      ],
      reponseCorrecte: 'une subordonnée qui exprime la parole/pensée de quelqu\'un (ex. l\'ACI)',
    ),
    QuestionLecon(
      question:
          'Dans « Quintus credit [se esse beatum] », à qui se renvoie-t-il ?',
      options: ['à Quintus (sujet de la principale)', 'à une autre personne', 'à personne en particulier', 'au sujet de l\'ACI seulement'],
      reponseCorrecte: 'à Quintus (sujet de la principale)',
    ),
    QuestionLecon(
      question: 'Qu\'appelle-t-on le « réfléchi indirect » ?',
      options: [
        'se/suus qui renvoie au sujet de la proposition principale (et non de sa propre subordonnée)',
        'se/suus qui renvoie toujours au sujet de sa propre proposition',
        'un pronom qui ne renvoie à rien',
        'is, ea, id employé seul',
      ],
      reponseCorrecte:
          'se/suus qui renvoie au sujet de la proposition principale (et non de sa propre subordonnée)',
    ),
    QuestionLecon(
      question:
          'Dans la méthode pratique pour le thème, quelle est la 1re '
          'question à se poser ?',
      options: [
        'le pronom/adjectif renvoie-t-il au sujet de la même proposition ?',
        'la subordonnée est-elle un ACI ?',
        'le verbe est-il au passé ou au présent ?',
        'le sujet est-il au singulier ou au pluriel ?',
      ],
      reponseCorrecte: 'le pronom/adjectif renvoie-t-il au sujet de la même proposition ?',
    ),
    ExerciceSaisie(
      question:
          'Dans « Pater putat liberos suos beatos esse » (Le père '
          'pense que ses enfants sont heureux), suos renvoie-t-il au '
          'sujet de l\'ACI ou à celui de la principale (pater) ? '
          'Réponds par « aci » ou « principale ».',
      reponsesAcceptees: ['principale'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Réfléchi direct : se/suus renvoie au sujet de sa propre '
        'proposition.\n\n'
        'Réfléchi indirect (dans une subordonnée de parole/pensée, ex. '
        'ACI) : se/suus peut aussi renvoyer au sujet de la '
        'principale.\n\n'
        'Sinon : non réfléchi, is/ea/id ou ejus/eorum/earum.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les adjectifs numéraux (cardinaux et ordinaux)
// ------------------------------------------------------------

final Lecon _leconAdjectifsNumeraux = Lecon(
  id: 'adjectifs_numeraux',
  titre: 'Les adjectifs numéraux (cardinaux et ordinaux)',
  sousTitre: 'unus/duo/tres, mille et milia, les multiplicatifs',
  icone: Icons.numbers,
  unite: 'Vol. II – Unité 5',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('Je me rappelle'),
    _tableauColonnes(
      ['chiffre', 'cardinal', 'ordinal'],
      [
        ['I', 'unus, a, um', 'primus, a, um'],
        ['II', 'duo, ae, o', 'secundus, a, um'],
        ['III', 'tres, tres, tria', 'tertius, a, um'],
        ['IV', 'quattuor', 'quartus, a, um'],
        ['V', 'quinque', 'quintus, a, um'],
        ['VI', 'sex', 'sextus, a, um'],
        ['VII', 'septem', 'septimus, a, um'],
        ['VIII', 'octo', 'octavus, a, um'],
        ['IX', 'novem', 'nonus, a, um'],
        ['X', 'decem', 'decimus, a, um'],
        ['C', 'centum', 'centesimus, a, um'],
        ['M', 'mille', 'millesimus, a, um'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Mille et mil(l)ia'),
    _paragrapheExplication(
      'Comme en français, le chiffre mille est invariable en latin.\n\n'
      'Ex. : Mille milites adsunt. (Mille soldats sont là.) Cum mille '
      'militibus veniet. (Il viendra avec mille soldats.)',
    ),
    _paragrapheExplication(
      'Or, quand il s\'agit de plusieurs milliers, le latin utilise le '
      'nom mil(l)ia, ium, n. pl. (« milliers ») suivi du génitif '
      'pluriel.\n\n'
      'Ex. : Duo milia militum adsunt. (Deux mille soldats, '
      'littéralement deux milliers de soldats, sont là.) Patria duobus '
      'milibus fortium militum gratiam habet. (La patrie témoigne de '
      'la reconnaissance à deux mille soldats courageux.)',
    ),
    _tableauColonnes(
      ['nombre', 'construction'],
      [
        ['1000', 'mille (invariable)'],
        ['2000 = deux milliers de...', 'duo mil(l)ia + génitif'],
        ['n × 1000 = n milliers de...', 'n mil(l)ia + génitif'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Les adjectifs cardinaux'),
    _paragrapheExplication(
      'Les adjectifs cardinaux sont invariables, sauf unus, duo et '
      'tres (employés seuls ou en composition).',
    ),
    _tableauColonnes(
      ['cas', 'unus, a, um', 'duo, duae, duo', 'tres, tres, tria'],
      [
        ['nom.', 'unus / una / unum', 'duo / duae / duo', 'tres / tres / tria'],
        ['acc.', 'unum / unam / unum', 'duo(s) / duas / duo', 'tres / tres / tria'],
        ['gén.', 'unius', 'duorum / duarum / duorum', 'trium'],
        ['dat./abl.', 'uni / uno-a-o', 'duobus / duabus / duobus', 'tribus'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Quelques particularités'),
    _paragrapheExplication(
      '• Unus a un pluriel (uni, unae, una) employé avec les noms sans '
      'singulier. Unus est issu de oinos, comparable au gotique ains, '
      'à l\'origine de l\'allemand eins.\n\n'
      '• Ambo, « les deux, tous les deux », se décline comme duo. Ces '
      'formes irrégulières en -o (duo, ambo) proviennent d\'un ancien '
      'duel : certaines langues anciennes ne distinguent pas seulement '
      'le singulier et le pluriel, mais ont une déclinaison spéciale '
      'pour « deux » !\n\n'
      '• Les adjectifs cardinaux sont invariables de quattuor à '
      'centum ; les centaines, à partir de ducenti, se déclinent comme '
      'boni, ae, a.',
    ),
    _titreExplication('Les adjectifs ordinaux'),
    _paragrapheExplication(
      'Les adjectifs ordinaux se déclinent comme les adjectifs de la '
      '1re classe (bonus, a, um). Le latin emploie toujours l\'adjectif '
      'ordinal pour marquer le rang, l\'heure et la date.\n\n'
      'Ex. : Philippus quintus (Philippe V, se lit « cinq »). prima '
      'hora (à la première heure = au lever du soleil, à l\'aube). '
      'ante diem sextum Kalendas Martias (le 6e jour avant les calendes '
      'de mars).',
    ),
    _titreExplication('Les multiplicatifs'),
    _paragrapheExplication(
      'Ce sont des adverbes qui indiquent combien de fois quelque '
      'chose s\'est produit : semel (« une fois »), bis (« deux fois '
      '»), ter (« trois fois »), quater (« quatre fois »).\n\n'
      'À partir de « cinq fois », la particule -iens (ou -ies) indique '
      'combien de fois quelque chose s\'est produit : quinquiens '
      '(« cinq fois »), sexiens, septiens, octiens, noviens, deciens, '
      'viciens (« vingt fois »), triciens, centiens, milliens.',
    ),
    _paragrapheExplication(
      'Ex. : Bis ovans triumphavi. (Deux fois j\'ai triomphé avec les '
      'honneurs de l\'ovation.) Tres egi curules triumphos et '
      'appellatus sum vicies et semel (XXI) imperator. (Trois fois '
      'j\'ai obtenu les honneurs du grand triomphe, et j\'ai été '
      'acclamé imperator vingt et une fois.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quels adjectifs cardinaux sont variables (contrairement aux autres) ?',
      options: ['unus, duo, tres', 'quattuor, quinque, sex', 'centum, mille', 'primus, secundus, tertius'],
      reponseCorrecte: 'unus, duo, tres',
    ),
    QuestionLecon(
      question: 'Le chiffre mille est-il variable en latin ?',
      options: ['non, il est invariable', 'oui, il se décline comme bonus', 'oui, mais seulement au pluriel', 'seulement au génitif'],
      reponseCorrecte: 'non, il est invariable',
    ),
    QuestionLecon(
      question: 'Comment exprime-t-on « deux mille soldats » en latin ?',
      options: [
        'duo milia militum (deux milliers + génitif)',
        'duo mille milites',
        'duo milites mille',
        'mille duo militum',
      ],
      reponseCorrecte: 'duo milia militum (deux milliers + génitif)',
    ),
    QuestionLecon(
      question: 'Quel est le génitif singulier (3 genres) de unus, a, um ?',
      options: ['unius', 'uni', 'uno', 'unum'],
      reponseCorrecte: 'unius',
    ),
    QuestionLecon(
      question: 'Comme quel adjectif duo se décline-t-il, entre autres ?',
      options: ['ambo', 'unus', 'tres', 'mille'],
      reponseCorrecte: 'ambo',
    ),
    QuestionLecon(
      question:
          'À partir de quel nombre les adjectifs cardinaux redeviennent-ils '
          'variables (déclinés comme boni, ae, a) ?',
      options: ['ducenti (200)', 'quattuor (4)', 'centum (100)', 'mille (1000)'],
      reponseCorrecte: 'ducenti (200)',
    ),
    QuestionLecon(
      question: 'Comme quel type d\'adjectif les adjectifs ordinaux se déclinent-ils ?',
      options: ['les adjectifs de la 1re classe (bonus, a, um)', 'les adjectifs de la 2e classe', 'ils sont invariables', 'les pronoms-adjectifs'],
      reponseCorrecte: 'les adjectifs de la 1re classe (bonus, a, um)',
    ),
    QuestionLecon(
      question: 'Pour quoi le latin emploie-t-il toujours l\'adjectif ordinal ?',
      options: ['le rang, l\'heure et la date', 'la quantité', 'la comparaison', 'la cause'],
      reponseCorrecte: 'le rang, l\'heure et la date',
    ),
    QuestionLecon(
      question: 'Que signifie l\'adverbe multiplicatif bis ?',
      options: ['deux fois', 'une fois', 'trois fois', 'dix fois'],
      reponseCorrecte: 'deux fois',
    ),
    QuestionLecon(
      question:
          'À partir de « cinq fois », quelle particule indique combien '
          'de fois quelque chose s\'est produit ?',
      options: ['-iens (ou -ies)', '-esimus', '-plex', '-arius'],
      reponseCorrecte: '-iens (ou -ies)',
    ),
    ExerciceSaisie(
      question: 'Comment dit-on « trois fois » en latin (multiplicatif) ?',
      reponsesAcceptees: ['ter'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Cardinaux invariables sauf unus/duo/tres (variables) et les '
        'centaines à partir de ducenti.\n\n'
        'mille = invariable ; n milliers = n mil(l)ia + génitif.\n\n'
        'Ordinaux = déclinés comme bonus, a, um ; utilisés pour rang, '
        'heure, date.\n\n'
        'Multiplicatifs : semel, bis, ter, quater, puis quinquiens... '
        '(-iens/-ies).',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : La cinquième déclinaison
// ------------------------------------------------------------

final Lecon _leconDeclinaison5 = Lecon(
  id: 'decl_5',
  titre: 'La cinquième déclinaison',
  sousTitre: 'res, rei, f. — et l\'étonnante histoire du mot « rien »',
  icone: Icons.inventory_2,
  unite: 'Vol. II – Unité 6',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Les noms ayant le nominatif en -es et le génitif en -ei suivent '
      'la 5e déclinaison.',
    ),
    _titreExplication('Le modèle : res, rei, f. « la chose »'),
    _tableauColonnes(
      ['cas', 'singulier', 'pluriel'],
      [
        ['nom.', 'res', 'res'],
        ['voc.', 'res', 'res'],
        ['acc.', 'rem', 'res'],
        ['gén.', 'rei', 'rerum'],
        ['dat.', 'rei', 'rebus'],
        ['abl.', 're', 'rebus'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Mot à sens multiples, res fait partie de nombreuses '
      'expressions : res familiaris (le patrimoine, les biens de '
      'famille), res militaris (l\'art militaire, les affaires '
      'militaires), res novae (une révolution, des changements '
      'politiques), res secundae/adversae (le bonheur/le malheur, la '
      'prospérité/l\'adversité).\n\n'
      'Le nom composé respublica (ou res publica), « l\'État, la chose '
      'publique, la République », se décline aussi (que l\'on écrive '
      'respublica ou res publica) : au génitif, reipublicae.',
    ),
    _titreExplication('Le genre des noms de la 5e déclinaison'),
    _paragrapheExplication(
      'Les mots de la 5e déclinaison sont féminins, sauf dies, diei, '
      'm. (« jour ») et meridies, -diei, m. (« midi »).\n\n'
      'Attention, dies est féminin au singulier au sens de « date, jour '
      'fixé ».\n\n'
      'Ex. : die dicta (au jour dit / au jour fixé).',
    ),
    _titreExplication('L\'histoire étonnante du mot « rien »'),
    _paragrapheExplication(
      'Rien, ce n\'est pas rien, c\'est... quelque chose ! Étonnant ? '
      'Pas pour le latiniste qui reconnaît l\'origine du mot ! C\'est '
      'bien res, à l\'accusatif rem, qui a donné « rien » en français. '
      'On retrouve ce sens de « chose » dans certaines expressions un '
      'peu vieillies, comme « Y a-t-il rien de plus beau ? » ou dans '
      'des contextes négatifs, comme « rester sans rien faire », '
      'c\'est-à-dire « rester sans faire la moindre chose ».',
    ),
    _paragrapheExplication(
      'Ce n\'est donc qu\'avec la négation « ne » que « rien » désigne '
      'l\'absence de quelque chose. Il en est de même avec « ne... pas '
      '» où « pas » signifie littéralement « le pas » (ALL. der '
      'Schritt).\n\n'
      'Enfin, dans l\'usage courant à l\'oral, il arrive que les '
      'locuteurs laissent « ne » de côté, car ils ont oublié le sens '
      'originel du mot « rien » et associent avec lui une idée '
      'négative ; ce qui fait sourire le latiniste, car '
      'étymologiquement, ceux qui oublient « ne » disent le contraire '
      'de ce qu\'ils veulent dire.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quelles terminaisons caractérisent la 5e déclinaison ?',
      options: [
        'nominatif en -es, génitif en -ei',
        'nominatif en -us, génitif en -us',
        'nominatif en -is, génitif en -is',
        'nominatif en -a, génitif en -ae',
      ],
      reponseCorrecte: 'nominatif en -es, génitif en -ei',
    ),
    QuestionLecon(
      question: 'Quel est le génitif singulier de res, rei, f. ?',
      options: ['rei', 'res', 'rem', 'rerum'],
      reponseCorrecte: 'rei',
    ),
    QuestionLecon(
      question: 'Quel est l\'accusatif singulier de res, rei, f. ?',
      options: ['rem', 'res', 'rei', 're'],
      reponseCorrecte: 'rem',
    ),
    QuestionLecon(
      question: 'Que signifie res novae ?',
      options: [
        'une révolution, des changements politiques',
        'les affaires militaires',
        'le patrimoine',
        'le bonheur',
      ],
      reponseCorrecte: 'une révolution, des changements politiques',
    ),
    QuestionLecon(
      question: 'De quel genre sont les noms de la 5e déclinaison, en général ?',
      options: ['féminin', 'masculin', 'neutre', 'cela dépend du nominatif'],
      reponseCorrecte: 'féminin',
    ),
    QuestionLecon(
      question: 'Quels sont les deux noms masculins exceptionnels de la 5e déclinaison ?',
      options: ['dies et meridies', 'res et spes', 'fides et acies', 'facies et species'],
      reponseCorrecte: 'dies et meridies',
    ),
    QuestionLecon(
      question: 'Quel mot latin, à l\'accusatif rem, a donné « rien » en français ?',
      options: ['res', 'nihil', 'nemo', 'nullus'],
      reponseCorrecte: 'res',
    ),
    QuestionLecon(
      question: 'Sans négation, que pouvait signifier « rien » (comme dans « Y a-t-il rien de plus beau ? ») ?',
      options: ['quelque chose', 'toujours une absence', 'un lieu', 'un moment'],
      reponseCorrecte: 'quelque chose',
    ),
    ExerciceSaisie(
      question: 'Quel est l\'ablatif singulier de res, rei, f. ?',
      reponsesAcceptees: ['re'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['cas', 'singulier', 'pluriel'],
        [
          ['nom.', 'res', 'res'],
          ['acc.', 'rem', 'res'],
          ['gén.', 'rei', 'rerum'],
          ['dat.', 'rei', 'rebus'],
          ['abl.', 're', 'rebus'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Féminins, sauf dies/meridies (masc.). rem (accusatif de res) '
        '→ « rien » en français.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les subjonctifs présent et imparfait
// ------------------------------------------------------------

final Lecon _leconSubjonctifPresentImparfait = Lecon(
  id: 'subjonctif_present_imparfait',
  titre: 'Les subjonctifs présent et imparfait',
  sousTitre: 'Voyelle caractéristique -i-/-e-/-a-, puis -re-/-se-',
  icone: Icons.tune,
  unite: 'Vol. II – Unité 6',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('Le subjonctif présent'),
    _paragrapheExplication(
      'On ajoute les terminaisons personnelles actives -m, -s, -t, '
      '-mus, -tis, -nt ou passives -r, -ris, -tur, -mur, -mini, -ntur '
      'au radical de l\'infectum, suivi de la voyelle caractéristique '
      ':\n\n'
      '• -i- pour esse et ses composés (à l\'actif uniquement)\n'
      '• -e- pour les verbes de la 1re conjugaison\n'
      '• -a- pour les verbes des autres conjugaisons',
    ),
    _tableauColonnes(
      ['pers.', 'esse (-i-)', 'amare, actif (-e-)', 'amare, passif (-e-)'],
      [
        ['je', 'sim', 'amem', 'amer'],
        ['tu', 'sis', 'ames', 'ameris'],
        ['il / elle', 'sit', 'amet', 'ametur'],
        ['nous', 'simus', 'amemus', 'amemur'],
        ['vous', 'sitis', 'ametis', 'amemini'],
        ['ils / elles', 'sint', 'ament', 'amentur'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Attention, à la 1re conjugaison, le -a- du radical « disparaît '
      '» par contraction : amem vient de *ama-e-m.',
    ),
    _tableauColonnes(
      ['pers.', 'mittere, actif (-a-)', 'mittere, passif (-a-)'],
      [
        ['je', 'mittam', 'mittar'],
        ['tu', 'mittas', 'mittaris'],
        ['il / elle', 'mittat', 'mittatur'],
        ['nous', 'mittamus', 'mittamur'],
        ['vous', 'mittatis', 'mittamini'],
        ['ils / elles', 'mittant', 'mittantur'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Le subjonctif imparfait'),
    _paragrapheExplication(
      'On ajoute les terminaisons personnelles actives ou passives au '
      'radical de l\'infectum, suivi du suffixe -re- ou -se-.\n\n'
      'Pour simplifier, tu peux retenir l\'astuce suivante : on ajoute '
      'les terminaisons personnelles actives/passives à l\'infinitif '
      'présent !',
    ),
    _tableauColonnes(
      ['pers.', 'amare, actif', 'amare, passif', 'esse'],
      [
        ['je', 'amarem', 'amarer', 'essem'],
        ['tu', 'amares', 'amareris', 'esses'],
        ['il / elle', 'amaret', 'amaretur', 'esset'],
        ['nous', 'amaremus', 'amaremur', 'essemus'],
        ['vous', 'amaretis', 'amaremini', 'essetis'],
        ['ils / elles', 'amarent', 'amarentur', 'essent'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Qui l\'eût cru ? Le subjonctif imparfait ne s\'utilise plus '
      'beaucoup en français, sauf à la 3e personne du singulier. On '
      'utilise plus fréquemment le subjonctif présent dans les autres '
      'cas.',
    ),
    _paragrapheExplication(
      'Le subjonctif imparfait français à la 3e personne du singulier '
      'ressemble au passé simple, mais prend toujours un accent '
      'circonflexe et la terminaison -t.\n\n'
      'Ex. : il loua → qu\'il louât ; il finit → qu\'il finît ; il prit '
      '→ qu\'il prît ; il vint → qu\'il vînt ; il s\'en alla → qu\'il '
      's\'en allât.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quelle voyelle caractérise le subjonctif présent des verbes de la 1re conjugaison ?',
      options: ['-e-', '-i-', '-a-', '-o-'],
      reponseCorrecte: '-e-',
    ),
    QuestionLecon(
      question: 'Quelle voyelle caractérise le subjonctif présent des verbes des autres conjugaisons (2e à 5e) ?',
      options: ['-a-', '-e-', '-i-', '-u-'],
      reponseCorrecte: '-a-',
    ),
    QuestionLecon(
      question: 'Quelle voyelle caractérise le subjonctif présent de esse (à l\'actif) ?',
      options: ['-i-', '-e-', '-a-', '-o-'],
      reponseCorrecte: '-i-',
    ),
    QuestionLecon(
      question: 'Quelle est la 1re personne du singulier du subjonctif présent de esse ?',
      options: ['sim', 'sum', 'sem', 'essem'],
      reponseCorrecte: 'sim',
    ),
    QuestionLecon(
      question: 'Quelle est la 1re personne du singulier du subjonctif présent de amare ?',
      options: ['amem', 'amo', 'amarem', 'amam'],
      reponseCorrecte: 'amem',
    ),
    QuestionLecon(
      question: 'Comment se forme le subjonctif imparfait ?',
      options: [
        'radical de l\'infectum + -re-/-se- + terminaisons (= infinitif présent + terminaisons)',
        'radical du perfectum + -isse-',
        'radical du présent + voyelle caractéristique -e-/-a-/-i-',
        'participe futur + esse',
      ],
      reponseCorrecte:
          'radical de l\'infectum + -re-/-se- + terminaisons (= infinitif présent + terminaisons)',
    ),
    QuestionLecon(
      question: 'Quelle est la 1re personne du singulier du subjonctif imparfait de amare ?',
      options: ['amarem', 'amem', 'amabam', 'amavissem'],
      reponseCorrecte: 'amarem',
    ),
    QuestionLecon(
      question: 'En français, à quelle personne le subjonctif imparfait s\'utilise-t-il encore couramment ?',
      options: ['la 3e personne du singulier', 'la 1re personne du singulier', 'toutes les personnes également', 'il ne s\'utilise plus du tout'],
      reponseCorrecte: 'la 3e personne du singulier',
    ),
    ExerciceSaisie(
      question: 'Conjugue mittere à la 3e personne du singulier du subjonctif présent actif.',
      reponsesAcceptees: ['mittat'],
    ),
    ExerciceSaisie(
      question: 'Conjugue esse à la 1re personne du pluriel du subjonctif imparfait.',
      reponsesAcceptees: ['essemus'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Subjonctif présent : radical infectum + voyelle (-i- esse, '
        '-e- 1re conj., -a- autres) + terminaisons.\n\n'
        'Subjonctif imparfait : infinitif présent + terminaisons '
        '(actives ou passives).',
      ),
      _tableauColonnes(
        ['pers.', 'sim (esse)', 'amem (amare)', 'amarem (imparfait)'],
        [
          ['je', 'sim', 'amem', 'amarem'],
          ['tu', 'sis', 'ames', 'amares'],
          ['il', 'sit', 'amet', 'amaret'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les complétives au subjonctif
// ------------------------------------------------------------

final Lecon _leconCompletivesSubjonctif = Lecon(
  id: 'completives_subjonctif',
  titre: 'Les complétives au subjonctif',
  sousTitre: 'Volonté (ut/ne), crainte (ne/ne non), événement (ut/ut non)',
  icone: Icons.gavel,
  unite: 'Vol. II – Unité 6',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Caesar statuit ut exercitus in Gallia maneat / ne exercitus '
      'Galliam relinquat. (César décide que son armée reste en Gaule / '
      'que son armée ne quitte pas la Gaule.)\n\n'
      'Hoc anno agricolae timent ne pluat / ne non pluat. (Cette '
      'année-ci, les paysans craignent qu\'il ne pleuve / qu\'il ne '
      'pleuve pas.)\n\n'
      'Saepe accidit ut cibus incolis desit. (Il arrive souvent que la '
      'nourriture manque aux habitants.)',
    ),
    _titreExplication('Qu\'est-ce qu\'une subordonnée complétive ?'),
    _paragrapheExplication(
      'On appelle subordonnées complétives des propositions qui '
      'complètent un verbe et ont ainsi la fonction de complément '
      'd\'objet. Les verbes de pensée, de parole et de perception sont '
      'suivis en latin d\'une proposition complétive qui est infinitive '
      '(ACI). Les complétives étudiées ici se mettent au subjonctif, '
      'après certains types de verbes.',
    ),
    _titreExplication('1. Les complétives introduites par ut + subj. / ne + subj.'),
    _paragrapheExplication(
      'Les verbes de volonté, souhait, prière, effort sont suivis de '
      'la conjonction ut + subjonctif. La négation est ne + '
      'subjonctif.',
    ),
    _tableauColonnes(
      ['verbe', 'conj.', 'sens'],
      [
        ['imperare (+ dat.)', 'ut', 'ordonner (à qqn) que / de'],
        ['orare (+ acc.)', 'ut', 'prier (qqn) que / de'],
        ['petere (ab + abl.)', 'ut', 'demander (à qqn) que / de'],
        ['rogare (+ acc.)', 'ut', 'demander (à qqn) que / de'],
        ['optare', 'ut', 'souhaiter que'],
        ['statuere', 'ut', 'décider que'],
        ['suadere (+ dat.)', 'ut', 'conseiller (à qqn) que / de'],
        ['curare', 'ut', 'prendre soin que/de, veiller à ce que/à'],
        ['efficere / facere', 'ut', 'faire en sorte que / de'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Particularités : les verbes de volonté et de souhait se '
      'construisent en principe avec ut + subjonctif, mais il existe '
      'des exceptions :\n\n'
      '• jubere + ACI, « ordonner que » (par opposition à imperare '
      'ut).\n'
      '• cupere + ACI, « désirer que » (si sujet 1 ≠ sujet 2) ; cupere '
      '+ infinitif, « désirer » (si sujet 1 = sujet 2).\n'
      '• statuere + ACI ou ut + subj., « décider que » (si sujet 1 ≠ '
      'sujet 2) ; statuere + infinitif, « décider de » (si sujet 1 = '
      'sujet 2).',
    ),
    _paragrapheExplication(
      'Pour alléger le style, le français préfère remplacer le '
      'subjonctif par l\'infinitif, si possible.\n\n'
      'Ex. : Suadeo tibi ut bonos audias, ne malos audias. (Je te '
      'conseille d\'écouter les gens de bien, de ne pas écouter les '
      'méchants.)',
    ),
    _titreExplication('2. Les complétives introduites par ne + subj. / ne non + subj.'),
    _paragrapheExplication(
      'Les verbes de crainte sont suivis de la conjonction ne + '
      'subjonctif. La négation est ne non + subjonctif.\n\n'
      'timere ne, metuere ne = craindre, redouter, avoir peur que '
      '(ne) / de.\n\n'
      'Ex. : Timeo ne inimicus veniat. (Je crains que mon ennemi (ne) '
      'vienne.) Timeo ne non amicus veniat. (Je crains que mon ami ne '
      'vienne pas.)',
    ),
    _paragrapheExplication(
      'Il existe en français un « ne » dit explétif — il « remplit » '
      'la proposition (du latin explere, « remplir »). Son emploi ne '
      'modifie pas la phrase positive en une phrase négative. Hérité '
      'du latin, il s\'utilise, surtout à l\'écrit, pour « l\'élégance '
      '» de la proposition, mais ne change pas le sens de l\'énoncé. Ce '
      '« ne » explétif tend à disparaître en français : « Je crains '
      'que mon ennemi ne vienne » et « Je crains que mon ennemi '
      'vienne » ont le même sens.',
    ),
    _titreExplication('3. Les complétives introduites par ut + subj. / ut non + subj.'),
    _paragrapheExplication(
      'Les verbes exprimant l\'événement sont suivis de la conjonction '
      'ut + subjonctif. La négation est ut non + subjonctif.\n\n'
      'accidit ut = il arrive que (événement imprévu, souvent négatif)\n'
      'contingit ut = il arrive que (événement le plus souvent heureux)\n'
      'evenit ut = il arrive que (événement quelconque)',
    ),
    _paragrapheExplication(
      'Ex. : Beatum cui contingit ut sapientiam adsequi possit. '
      '(Heureux celui à qui il arrive qu\'il puisse atteindre la '
      'sagesse.) Accidit ut aegrotes. (Il arrive que tu sois malade.) '
      'Accidit ut non valeas. (Il arrive que tu ne te portes pas '
      'bien.)',
    ),
    _titreExplication('La concordance des temps'),
    _paragrapheExplication(
      'Le même principe de concordance des temps qu\'en français '
      's\'applique dans les subordonnées complétives au subjonctif, en '
      'français et en latin : si le verbe de la principale est à un '
      'temps du présent, le verbe de la subordonnée se met au '
      'subjonctif présent (simultanéité) ; si le verbe de la principale '
      'est à un temps du passé, le verbe de la subordonnée se met au '
      'subjonctif imparfait.\n\n'
      'Ex. : Opto ut veniat. (Je souhaite qu\'il vienne.) Optabam ut '
      'veniret. (Je souhaitais qu\'il vînt — en français courant, « '
      'qu\'il vienne ».)',
    ),
    _paragrapheExplication(
      'D\'autres rapports de temps peuvent être exprimés : pour '
      'l\'antériorité, le latin emploie le subjonctif parfait si le '
      'verbe principal est au présent, et le subjonctif plus-que-parfait '
      'si le verbe principal est au passé. Le latin connaît même une '
      'tournure permettant d\'exprimer la postériorité à l\'aide d\'un '
      '« subjonctif futur », mais on ne le trouve que dans les '
      'interrogations indirectes.',
    ),
    _titreExplication('L\'emploi du réfléchi et du non réfléchi'),
    _paragrapheExplication(
      'Dans les propositions subordonnées complétives, le pronom '
      'réfléchi se et l\'adjectif possessif réfléchi suus renvoient ou '
      'bien au sujet de la même proposition (réfléchi direct), ou bien '
      'au sujet de la proposition principale (réfléchi indirect) — la '
      'même règle que pour l\'ACI.',
    ),
    _titreExplication('Un quatrième type : quominus / quin'),
    _paragrapheExplication(
      'Parmi les complétives au subjonctif, il existe un quatrième '
      'type : les propositions introduites par ne, quin ou quominus. Ce '
      'type de subordonnée complète des verbes exprimant l\'empêchement '
      ': impedire ne (« empêcher que/de »), obstare ne (« faire '
      'obstacle à ce que »), recusare ne (« refuser que/de »).',
    ),
    _paragrapheExplication(
      'La conjonction utilisée diffère selon que la principale est '
      'affirmative, négative ou interrogative :\n\n'
      '• principale affirmative : conjonction ne. Ex. : Impedit ne '
      'veniam. (Il m\'empêche de venir.)\n\n'
      '• principale négative ou interrogative : conjonction quin ou '
      'quominus. Ex. : Nihil obstat quin sis beatus. (Rien n\'empêche '
      'que tu sois heureux.)',
    ),
    _titreExplication('Quelle fonction pour la subordonnée complétive ?'),
    _paragrapheExplication(
      'La subordonnée complétive complète un verbe et peut prendre '
      'toutes les fonctions liées au verbe (sujet, COD, COI). Les '
      'subordonnées complétives de ce chapitre ont le plus souvent la '
      'fonction COD, comme la proposition infinitive — mais d\'autres '
      'fonctions sont possibles.\n\n'
      'Ex. : Numquam evenit ut philosophi non dissentiant. (Il '
      'n\'arrive jamais que des philosophes ne soient pas d\'avis '
      'différents.) — ici, la complétive est sujet de evenit (compare '
      ': Id numquam accidit/evenit, « Cela n\'arrive jamais »).\n\n'
      'En français, la subordonnée complétive peut même avoir la '
      'fonction COI (avec des verbes comme « veiller à ce que, se '
      'réjouir de ce que... »).',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quels verbes sont suivis de ut + subjonctif (négation ne) ?',
      options: [
        'les verbes de volonté, souhait, prière, effort',
        'les verbes de crainte',
        'les verbes d\'événement',
        'les verbes de perception',
      ],
      reponseCorrecte: 'les verbes de volonté, souhait, prière, effort',
    ),
    QuestionLecon(
      question: 'Quels verbes sont suivis de ne + subjonctif (négation ne non) ?',
      options: ['les verbes de crainte', 'les verbes de volonté', 'les verbes d\'événement', 'les verbes de perception'],
      reponseCorrecte: 'les verbes de crainte',
    ),
    QuestionLecon(
      question: 'Quels verbes sont suivis de ut + subjonctif (négation ut non), exprimant l\'événement ?',
      options: ['accidit, contingit, evenit', 'timere, metuere', 'imperare, orare', 'impedire, obstare'],
      reponseCorrecte: 'accidit, contingit, evenit',
    ),
    QuestionLecon(
      question: 'Comment jubere se construit-il, par exception (« ordonner que ») ?',
      options: ['+ ACI', '+ ut + subjonctif', '+ infinitif seul', '+ génitif'],
      reponseCorrecte: '+ ACI',
    ),
    QuestionLecon(
      question: 'Si le sujet de cupere est le même que celui du verbe désiré, comment se construit cupere ?',
      options: ['+ infinitif', '+ ACI', '+ ut + subjonctif', '+ ne + subjonctif'],
      reponseCorrecte: '+ infinitif',
    ),
    QuestionLecon(
      question: 'Qu\'est-ce que le « ne » explétif en français ?',
      options: [
        'un ne qui ne rend pas la phrase négative, hérité du latin',
        'un ne qui rend toujours la phrase négative',
        'une faute de français',
        'un ne qui s\'utilise uniquement à l\'oral',
      ],
      reponseCorrecte: 'un ne qui ne rend pas la phrase négative, hérité du latin',
    ),
    QuestionLecon(
      question: 'Que signifie contingit ut ?',
      options: [
        'il arrive que (événement le plus souvent heureux)',
        'il arrive que (événement toujours négatif)',
        'il empêche que',
        'il ordonne que',
      ],
      reponseCorrecte: 'il arrive que (événement le plus souvent heureux)',
    ),
    QuestionLecon(
      question:
          'Si le verbe de la principale est au passé, à quel temps se '
          'met le verbe de la complétive au subjonctif (simultanéité) ?',
      options: ['subjonctif imparfait', 'subjonctif présent', 'subjonctif parfait', 'subjonctif plus-que-parfait'],
      reponseCorrecte: 'subjonctif imparfait',
    ),
    QuestionLecon(
      question: 'Quelle conjonction introduit une complétive d\'empêchement après une principale affirmative ?',
      options: ['ne', 'quin', 'quominus', 'ut'],
      reponseCorrecte: 'ne',
    ),
    QuestionLecon(
      question:
          'Quelles conjonctions introduisent une complétive d\'empêchement après une principale négative ou interrogative ?',
      options: ['quin ou quominus', 'ne seulement', 'ut seulement', 'ut non'],
      reponseCorrecte: 'quin ou quominus',
    ),
    QuestionLecon(
      question:
          'Quelle fonction les complétives au subjonctif ont-elles le plus souvent ?',
      options: ['COD', 'sujet uniquement', 'complément circonstanciel', 'attribut'],
      reponseCorrecte: 'COD',
    ),
    ExerciceSaisie(
      question: 'Quelle conjonction introduit une complétive après un verbe de crainte (« craindre que ») ?',
      reponsesAcceptees: ['ne'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['type de verbe', 'conjonction', 'négation'],
        [
          ['volonté, souhait, prière, effort', 'ut', 'ne'],
          ['crainte', 'ne', 'ne non'],
          ['événement', 'ut', 'ut non'],
          ['empêchement (principale affirmative)', 'ne', '—'],
          ['empêchement (principale négative/interr.)', 'quin / quominus', '—'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Unus, solus, totus, nullus
// ------------------------------------------------------------

final Lecon _leconUnusSolusTotusNullus = Lecon(
  id: 'unus_solus_totus_nullus',
  titre: 'Unus, solus, totus, nullus',
  sousTitre: 'Génitif en -ius, datif en -i : une déclinaison à part',
  icone: Icons.adjust,
  unite: 'Vol. II – Unité 7',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Unum hominem vidi. (J\'ai vu un seul homme.) Solum hominem vidi. '
      '(J\'ai vu un homme seul.)\n\n'
      'Totum terrarum orbem novit. (Il connaît toute la terre.) Omnes '
      'Italiae terras novit. (Il connaît toutes les terres d\'Italie.) '
      'Omnis civis sententiam dicat ! (Que tout citoyen dise son avis !)',
    ),
    _titreExplication('Il ne faut pas confondre'),
    _paragrapheExplication(
      'solus « seul » et unus « un seul »\n\n'
      'totus = cunctus « tout, tout entier » et omnis « tout, chaque »\n\n'
      'omnes « tous » = cuncti',
    ),
    _titreExplication('Nullus : « aucun... ne », « ne... aucun »'),
    _paragrapheExplication(
      'Est nullus cibus quem recuso. (Il n\'y a aucune nourriture que je '
      'refuse.) Nullam legem novit. (Il ne connaît aucune loi.) Jus non '
      'novit neque ullam legem. (Il ne connaît pas le droit ni aucune '
      'loi.)',
    ),
    _paragrapheExplication(
      '« aucun... ne » ou « ne... aucun » se traduit par nullus, a, um.\n\n'
      '« et aucun... ne » ou « et ne... aucun » se traduit par neque '
      'ullus, a, um.\n\n'
      'Dans une proposition déjà négative, on remplace nullus, a, um '
      'par ullus, a, um.',
    ),
    _titreExplication('Nullus, aussi au pluriel'),
    _paragrapheExplication(
      'Contrairement au français, le latin utilise nullus, a, um aussi '
      'au pluriel.\n\n'
      'Ex. : Si nulla est divinatio, nulli sunt dei. (D\'après Cicéron, '
      'De divinatione, II, 17 : « S\'il n\'y a aucune divination, il '
      'n\'y a aucun dieu. »)',
    ),
    _titreExplication('Une déclinaison à part'),
    _paragrapheExplication(
      'Nullius viri audaciae cedamus ! (Ne cédons à l\'audace d\'aucun '
      'homme !) Unius viri vis satis non est. (La force d\'un seul '
      'homme ne suffit pas.) Tibi soli fidem habeo. (J\'ai confiance en '
      'toi seul.) Toti civitati gratias agere debemus. (Nous devons '
      'remercier la cité tout entière.)',
    ),
    _tableauColonnes(
      ['cas', 'unus', 'solus', 'totus', 'nullus'],
      [
        ['nom.', 'unus', 'solus', 'totus', 'nullus'],
        ['gén.', 'unius', 'solius', 'totius', 'nullius'],
        ['dat.', 'uni', 'soli', 'toti', 'nulli'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Les adjectifs unus, a, um « un, un seul » (ALL. einzig), solus, '
      'a, um « seul » (ALL. allein), totus, a, um « tout, tout entier » '
      '(ALL. ganz) et nullus, a, um « aucun... ne ; ne... aucun » se '
      'déclinent comme bonus, a, um, sauf au génitif singulier (en '
      '-ius) et au datif singulier (en -i), et cela aux trois genres.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Que signifie unus, a, um, à la différence de solus, a, um ?',
      options: [
        'un, un seul (par opposition à plusieurs)',
        'seul (sans personne d\'autre)',
        'tout entier',
        'aucun',
      ],
      reponseCorrecte: 'un, un seul (par opposition à plusieurs)',
    ),
    QuestionLecon(
      question: 'Que signifie solus, a, um ?',
      options: [
        'seul (sans personne d\'autre)',
        'un seul (par opposition à plusieurs)',
        'tout entier',
        'chaque',
      ],
      reponseCorrecte: 'seul (sans personne d\'autre)',
    ),
    QuestionLecon(
      question:
          'Quel adjectif signifie « tout, tout entier » et est synonyme de cunctus ?',
      options: ['totus', 'omnis', 'unus', 'nullus'],
      reponseCorrecte: 'totus',
    ),
    QuestionLecon(
      question:
          'Quelle terminaison présente le génitif singulier de unus, solus, totus, nullus, aux trois genres ?',
      options: ['-ius', '-i', '-orum', '-arum'],
      reponseCorrecte: '-ius',
    ),
    QuestionLecon(
      question:
          'Quelle terminaison présente le datif singulier de ces adjectifs ?',
      options: ['-i', '-ius', '-o', '-ae'],
      reponseCorrecte: '-i',
    ),
    QuestionLecon(
      question: 'Quel est le génitif singulier de totus, a, um ?',
      options: ['totius', 'toti', 'totorum', 'totum'],
      reponseCorrecte: 'totius',
    ),
    QuestionLecon(
      question: 'Quel est le datif singulier de solus, a, um ?',
      options: ['soli', 'solius', 'solo', 'solum'],
      reponseCorrecte: 'soli',
    ),
    QuestionLecon(
      question:
          'Contrairement au français, à quel nombre le latin peut-il aussi employer nullus, a, um ?',
      options: [
        'au pluriel',
        'au singulier seulement',
        'jamais au nominatif',
        'jamais à l\'accusatif',
      ],
      reponseCorrecte: 'au pluriel',
    ),
    QuestionLecon(
      question:
          'En dehors du génitif et du datif singuliers, comment se déclinent unus, solus, totus, nullus ?',
      options: [
        'comme bonus, a, um',
        'comme un nom de la 3e déclinaison',
        'ils sont indéclinables',
        'comme res, rei',
      ],
      reponseCorrecte: 'comme bonus, a, um',
    ),
    ExerciceSaisie(
      question: 'Donne le génitif singulier masculin de nullus, a, um.',
      reponsesAcceptees: ['nullius'],
    ),
    ExerciceSaisie(
      question: 'Donne le datif singulier masculin de unus, a, um.',
      reponsesAcceptees: ['uni'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['cas', 'unus', 'solus', 'totus', 'nullus'],
        [
          ['nom.', 'unus', 'solus', 'totus', 'nullus'],
          ['gén.', 'unius', 'solius', 'totius', 'nullius'],
          ['dat.', 'uni', 'soli', 'toti', 'nulli'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'unus « un seul » ≠ solus « seul ». totus « tout entier » ≠ '
        'omnis « tout, chaque ». nullus, a, um s\'emploie aussi au '
        'pluriel et se remplace par ullus, a, um en contexte déjà '
        'négatif.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les pronoms indéfinis nemo et nihil
// ------------------------------------------------------------

final Lecon _leconNemoNihil = Lecon(
  id: 'nemo_nihil',
  titre: 'Les pronoms indéfinis nemo et nihil',
  sousTitre: '« personne » et « rien » : deux déclinaisons empruntées à nullus',
  icone: Icons.person_off,
  unite: 'Vol. II – Unité 7',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Nemo te vidit. (Personne ne t\'a vu.) Iste neminem amat. (Cet '
      'individu n\'aime personne.) Nullius nomen novi. (Je ne connais '
      'le nom de personne.) Nemini credo. (Je ne fais confiance à '
      'personne.) A nullo amatur. (Il n\'est aimé de personne.)',
    ),
    _titreExplication('La déclinaison de nemo'),
    _tableauColonnes(
      ['cas', 'nemo « personne »'],
      [
        ['nom.', 'nemo'],
        ['acc.', 'neminem'],
        ['gén.', 'nullius'],
        ['dat.', 'nemini'],
        ['abl.', 'nullo'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Au génitif et à l\'ablatif, nemo emprunte ses formes à l\'adjectif '
      'nullus « aucun ».',
    ),
    _titreExplication('Nihil « rien »'),
    _paragrapheExplication(
      'Nihil novi sub sole ! (Rien de nouveau sous le soleil !) Nihil '
      'vidi. Nihil audivi. (Je n\'ai rien vu. Je n\'ai rien entendu.) '
      'homo ad nullam rem utilis (un homme utile à rien — d\'après '
      'Cicéron, De Officiis, 3, 29). Nullius rei rationem habuit. (Il '
      'ne tint compte de rien.) Iste nulli rei credit. (Cet individu ne '
      'croit en rien.) De nulla re verba fecit. (Il ne parla de rien.)',
    ),
    _paragrapheExplication(
      'Aux cas obliques (génitif, datif, ablatif), et même à '
      'l\'accusatif précédé d\'une préposition, le pronom nihil est '
      'remplacé par nulla res « aucune chose ».',
    ),
    _titreExplication('Je récapitule'),
    _tableauColonnes(
      ['cas', 'nemo « personne »', 'nihil « rien »'],
      [
        ['nom.', 'nemo', 'nihil'],
        ['acc.', 'neminem', 'nihil / prép. + nullam rem'],
        ['gén.', 'nullius', 'nullius rei'],
        ['dat.', 'nemini', 'nulli rei'],
        ['abl.', 'nullo', 'nulla re'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('D\'où viennent nemo et nihil ?'),
    _paragrapheExplication(
      'Étymologiquement, le pronom nemo s\'explique par ne + hemo '
      '(= homo) et le pronom nihil par ne + hilum. L\'origine du mot '
      'hilum n\'est pas sûre ; certains pensent qu\'il désignait le '
      'petit point noir au bout d\'une fève. Il désigne en tout cas '
      'quelque chose de tout petit.',
    ),
    _paragrapheExplication(
      'En français, on retrouve nihil dans le verbe « annihiler » '
      '(= réduire à rien) et le substantif « nihiliste » (« une '
      'personne qui ne croit en rien »). De même, le français garde une '
      'réminiscence du neutre nihilum : une création ex nihilo est une '
      'création « à partir de rien ».',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Que signifie nemo ?',
      options: [
        'personne... ne / ne... personne',
        'rien... ne / ne... rien',
        'aucun... ne',
        'tout le monde',
      ],
      reponseCorrecte: 'personne... ne / ne... personne',
    ),
    QuestionLecon(
      question: 'Que signifie nihil ?',
      options: ['rien... ne / ne... rien', 'personne... ne', 'tout', 'quelque chose'],
      reponseCorrecte: 'rien... ne / ne... rien',
    ),
    QuestionLecon(
      question: 'Quel est l\'accusatif de nemo ?',
      options: ['neminem', 'nemo', 'nullius', 'nemini'],
      reponseCorrecte: 'neminem',
    ),
    QuestionLecon(
      question:
          'À quels cas nemo emprunte-t-il ses formes à l\'adjectif nullus ?',
      options: [
        'génitif et ablatif',
        'nominatif et accusatif',
        'datif et accusatif',
        'à tous les cas',
      ],
      reponseCorrecte: 'génitif et ablatif',
    ),
    QuestionLecon(
      question:
          'Que remplace nihil aux cas obliques, et à l\'accusatif précédé d\'une préposition ?',
      options: ['nulla res', 'nemo', 'nullus homo', 'res'],
      reponseCorrecte: 'nulla res',
    ),
    QuestionLecon(
      question: 'Quel est le génitif de nihil (aux cas obliques) ?',
      options: ['nullius rei', 'nihilis', 'nihili', 'nullius'],
      reponseCorrecte: 'nullius rei',
    ),
    QuestionLecon(
      question: 'Quel est l\'ablatif de nemo ?',
      options: ['nullo', 'nemine', 'nihilo', 'nullius'],
      reponseCorrecte: 'nullo',
    ),
    QuestionLecon(
      question:
          'De quels mots latins nemo et nihil sont-ils issus, étymologiquement ?',
      options: [
        'ne + hemo (homo) ; ne + hilum',
        'ne + unus ; ne + res',
        'non + homo ; non + res',
        'ne + solus ; ne + totus',
      ],
      reponseCorrecte: 'ne + hemo (homo) ; ne + hilum',
    ),
    QuestionLecon(
      question:
          'Quel mot français, dérivé de nihil, signifie « réduire à rien » ?',
      options: ['annihiler', 'nier', 'néant', 'nul'],
      reponseCorrecte: 'annihiler',
    ),
    ExerciceSaisie(
      question: 'Quel est le datif de nemo (« à personne ») ?',
      reponsesAcceptees: ['nemini'],
    ),
    ExerciceSaisie(
      question:
          'Quel est l\'ablatif de nihil, remplacé par nulla res (« par rien ») ?',
      reponsesAcceptees: ['nulla re'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['cas', 'nemo « personne »', 'nihil « rien »'],
        [
          ['nom.', 'nemo', 'nihil'],
          ['acc.', 'neminem', 'nihil / prép. + nullam rem'],
          ['gén.', 'nullius', 'nullius rei'],
          ['dat.', 'nemini', 'nulli rei'],
          ['abl.', 'nullo', 'nulla re'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'nemo et nihil empruntent leurs cas obliques à nullus, a, um '
        '(et à nulla res pour nihil).',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : La négation dans la coordination et la subordination
// ------------------------------------------------------------

final Lecon _leconNegationCoordinationSubordination = Lecon(
  id: 'negation_coordination_subordination',
  titre: 'La négation dans la coordination et la subordination',
  sousTitre: 'nec/neque, quisquam, quidquam : éviter la double négation',
  icone: Icons.not_interested,
  unite: 'Vol. II – Unité 7',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication('*et non → nec / neque'),
    _titreExplication('Coordonner une négation : nec / neque'),
    _paragrapheExplication(
      'Puer tacuit neque umquam timuit. (L\'enfant s\'est tu et n\'a '
      'jamais eu peur.) Veni neque ullum hominem vidi. (Je suis venu et '
      'je n\'ai vu aucun homme.) Audiebat nec quidquam dicebat. (Il '
      'écoutait et ne disait rien.) Veni nec quemquam vidi. (Je suis '
      'venu et je n\'ai vu personne.)',
    ),
    _paragrapheExplication(
      '*et numquam → neque umquam « et... ne... jamais »\n'
      '*et nullus, a, um → neque ullus, a, um « et... ne... aucun »\n'
      '*et nihil → nec quidquam / quicquam « et... rien... ne »\n'
      '*et nemo → nec quisquam « et... personne ne... »',
    ),
    _paragrapheExplication(
      'Le latin n\'utilise que rarement la conjonction de coordination '
      'et suivie d\'un mot négatif, mais il utilise plutôt nec/neque '
      'pour dire « et... ne... pas ». De même, il utilise neque umquam '
      'pour dire « et... ne... jamais », neque ullus, a, um pour dire '
      '« et... ne... aucun », et remplace les pronoms indéfinis nemo et '
      'nihil par les pronoms quisquam et quidquam / quicquam pour dire '
      '« et... personne ne... », « et... rien ne... ».',
    ),
    _titreExplication('quisquam et quidquam'),
    _paragrapheExplication(
      'Quisquam et quidquam se déclinent comme le pronom interrogatif, '
      'auquel s\'ajoute l\'élément invariable -quam.',
    ),
    _tableauColonnes(
      ['cas', 'masculin', 'neutre'],
      [
        ['nom.', 'quisquam', 'quidquam / quicquam'],
        ['acc.', 'quemquam', 'quidquam / quicquam'],
        ['gén.', 'cujusquam', 'ullius rei'],
        ['dat.', 'cuiquam', 'ulli rei'],
        ['abl.', 'quoquam', 'ulla re'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Aux cas obliques (génitif, datif, ablatif), le latin remplace le '
      'plus souvent le pronom neutre par ulla res aux cas '
      'correspondants.\n\n'
      'Ex. : Omnes vocavi nec quemquam inveni. (Je les ai tous appelés '
      'et je n\'en ai trouvé personne.) Omnibus adfuit nec cuiquam '
      'obfuit. (Il les aida tous et ne nuisit à personne.) Omnia '
      'adsunt nec quidquam deest. (Tout est là et rien ne manque.) '
      'Iratus fuit neque ullius rei rationem habuit. (Il fut en colère '
      'et ne tint compte de rien.)',
    ),
    _titreExplication('Même substitution après un mot à idée négative'),
    _paragrapheExplication(
      'On trouve la même substitution d\'un mot négatif si un autre '
      'mot que nec comporte une idée négative. Il en est ainsi, par '
      'exemple, de la préposition sine + ablatif « sans ».\n\n'
      'Ex. : sine ulla re (sans rien). Omnia fecerunt, sine cujusquam '
      'auxilio. (Ils firent tout sans l\'aide de personne.)',
    ),
    _titreExplication('Après une conjonction de subordination'),
    _paragrapheExplication(
      'On trouve la même substitution d\'un mot négatif derrière une '
      'conjonction de subordination. Afin de ne pas créer de double '
      'négation après un verbe de volonté, de souhait, de prière, '
      'd\'effort, le latin utilise ne umquam pour dire « que jamais... '
      'ne », ne ullus pour dire « qu\'aucun... ne », ne quisquam pour '
      '« que personne... ne », ne quidquam / quicquam pour « que '
      'rien... ne ». Mais il garde ut numquam, ut nullus, ut nemo, ut '
      'nihil après un verbe d\'événement.',
    ),
    _tableauColonnes(
      ['après un verbe d\'événement', 'après volonté/souhait/prière/effort'],
      [
        ['accidit ut numquam', 'opto ne umquam'],
        ['accidit ut nullus', 'opto ne ullus'],
        ['accidit ut nemo', 'opto ne quisquam'],
        ['accidit ut nihil', 'opto ne quidquam / quicquam'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('La négation « en série »'),
    _paragrapheExplication(
      'Le latin, contrairement au français, évite d\'enchaîner '
      'plusieurs mots négatifs. C\'est pourquoi, après une première '
      'négation ou un mot comportant une idée négative, il ne faut '
      'plus mettre de négation, mais l\'expression positive.\n\n'
      'Ex. : neque umquam quidquam ei defuit. Littéralement, « et '
      'jamais quelque chose ne lui manqua » → et jamais rien ne lui '
      'manqua.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question:
          'Comment le latin traduit-il le plus souvent « et... ne... pas », plutôt que par et non ?',
      options: ['nec / neque', 'et non', 'ne... non', 'numquam'],
      reponseCorrecte: 'nec / neque',
    ),
    QuestionLecon(
      question: 'Comment traduit-on « et... ne... jamais » ?',
      options: ['neque umquam', 'et numquam', 'nec umquam tantum', 'ne umquam'],
      reponseCorrecte: 'neque umquam',
    ),
    QuestionLecon(
      question:
          'Après nec/neque, quel pronom remplace nemo pour dire « et... personne ne... » ?',
      options: ['quisquam', 'nemo', 'aliquis', 'quidam'],
      reponseCorrecte: 'quisquam',
    ),
    QuestionLecon(
      question:
          'Après nec/neque, quel pronom remplace nihil pour dire « et... rien... ne » ?',
      options: ['quidquam / quicquam', 'nihil', 'aliquid', 'quid'],
      reponseCorrecte: 'quidquam / quicquam',
    ),
    QuestionLecon(
      question: 'Comment se déclinent quisquam et quidquam ?',
      options: [
        'comme le pronom interrogatif + élément invariable -quam',
        'comme bonus, a, um',
        'comme nemo et nihil',
        'ils sont indéclinables',
      ],
      reponseCorrecte: 'comme le pronom interrogatif + élément invariable -quam',
    ),
    QuestionLecon(
      question:
          'Aux cas obliques, par quoi le latin remplace-t-il le plus souvent le pronom neutre quidquam ?',
      options: ['ulla res', 'nulla res', 'res', 'quidquam lui-même'],
      reponseCorrecte: 'ulla res',
    ),
    QuestionLecon(
      question:
          'Quelle préposition, comportant une idée négative, entraîne la même substitution que nec (ullus, quisquam...) ?',
      options: ['sine + ablatif', 'cum + ablatif', 'sub + ablatif', 'ad + accusatif'],
      reponseCorrecte: 'sine + ablatif',
    ),
    QuestionLecon(
      question:
          'Après un verbe de volonté, souhait, prière ou effort, comment le latin dit-il « que personne ne » sans double négation ?',
      options: ['ne quisquam', 'ut nemo', 'ne nemo', 'ut non quisquam'],
      reponseCorrecte: 'ne quisquam',
    ),
    QuestionLecon(
      question:
          'Après un verbe d\'événement (accidit, evenit...), quelles formes le latin garde-t-il malgré la négation déjà présente ?',
      options: [
        'ut numquam, ut nullus, ut nemo, ut nihil',
        'ne umquam, ne ullus, ne quisquam, ne quidquam',
        'nec umquam, nec ullus',
        'les deux séries indifféremment',
      ],
      reponseCorrecte: 'ut numquam, ut nullus, ut nemo, ut nihil',
    ),
    QuestionLecon(
      question:
          'Que fait le latin après une première négation, à la différence du français qui peut enchaîner plusieurs négations ?',
      options: [
        'il utilise l\'expression positive (quisquam, quidquam...)',
        'il répète nec deux fois',
        'il supprime le verbe',
        'il ajoute non'
      ],
      reponseCorrecte: 'il utilise l\'expression positive (quisquam, quidquam...)',
    ),
    ExerciceSaisie(
      question:
          'Quel pronom neutre indéfini apparaît après nec pour dire « rien » (forme la plus courte, en -quam) ?',
      reponsesAcceptees: ['quidquam', 'quicquam'],
    ),
    ExerciceSaisie(
      question:
          'Quelle préposition + ablatif entraîne la même substitution négative que nec (« sans ») ?',
      reponsesAcceptees: ['sine'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['positif', 'négatif isolé', 'après nec/neque, sine, ut négatif'],
        [
          ['umquam', 'numquam', 'neque/ne umquam'],
          ['ullus', 'nullus', 'neque/ne ullus'],
          ['quisquam', 'nemo', 'nec/ne quisquam'],
          ['quidquam', 'nihil', 'nec/ne quidquam'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Le latin évite la double négation : après nec/neque, sine, ou '
        'une conjonction déjà négative, on emploie la forme positive '
        '(ullus, quisquam, quidquam, umquam), sauf ut numquam/nullus/'
        'nemo/nihil après un verbe d\'événement.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Le verbe ferre et ses composés
// ------------------------------------------------------------

final Lecon _leconFerreComposes = Lecon(
  id: 'ferre_composes',
  titre: 'Le verbe ferre et ses composés',
  sousTitre: 'fero, fers, ferre, tuli, latum : trois radicaux à surveiller',
  icone: Icons.local_shipping,
  unite: 'Vol. II – Unité 7',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Un somnifère, les abeilles mellifères, les lucioles aux ailes '
      'lucifères, un transfert, vociférer... Tous ces mots français '
      'contiennent le suffixe -fère, issu du verbe ferre, dont voici '
      'les temps primitifs :',
    ),
    _paragrapheExplication('fero, fers, ferre, tuli, latum « porter, supporter, rapporter »'),
    _titreExplication('Trois radicaux'),
    _paragrapheExplication(
      'fer- est le radical de l\'infectum, tul- le radical du '
      'perfectum, lat- le radical du supin. Ces trois radicaux très '
      'différents rendent ferre irrégulier.',
    ),
    _titreExplication('L\'indicatif présent : fero, fers, fert...'),
    _tableauColonnes(
      ['pers.', 'présent actif', 'présent passif'],
      [
        ['je', 'fero', 'feror'],
        ['tu', 'fers', 'ferris'],
        ['il / elle', 'fert', 'fertur'],
        ['nous', 'ferimus', 'ferimur'],
        ['vous', 'fertis', 'ferimini'],
        ['ils / elles', 'ferunt', 'feruntur'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'À l\'imparfait (ferebam...) et au futur (feram...), ferre se '
      'conjugue en revanche tout à fait normalement, comme un verbe de '
      'la 3e conjugaison sur le radical fer-.',
    ),
    _titreExplication('Des formes sans voyelle de liaison'),
    _paragrapheExplication(
      'L\'infinitif du verbe est fer-re, son radical est donc fer- ; en '
      'principe ce verbe suit la 3e conjugaison (modèle : mitto), mais '
      'certaines formes ne présentent pas de voyelle de liaison, par '
      'exemple mitt-e-re mais fer-re, mitt-i-s mais fer-s. Les temps '
      'concernés sont l\'infinitif et l\'indicatif présents, le '
      'subjonctif imparfait et l\'impératif (fer ! ferte !).',
    ),
    _paragrapheExplication(
      'ferunt et fertur sont souvent employés avec la proposition '
      'infinitive (ACI) et se traduisent alors par « on rapporte que ».',
    ),
    _titreExplication('Les composés de ferre'),
    _paragrapheExplication(
      'Le verbe fero a de nombreux composés, formés d\'un préverbe et '
      'de fero/tuli/latum. Attention, au contact des différents '
      'radicaux (fer-, tul-, lat-), le préfixe peut changer.',
    ),
    _tableauColonnes(
      ['préverbe', 'temps primitifs', 'sens'],
      [
        ['ad-', 'affero, affers, afferre, attuli, allatum', 'porter vers, apporter'],
        ['ab- (a-)', 'aufero, aufers, auferre, abstuli, ablatum', 'porter loin de, emporter, enlever'],
        ['in-', 'infero, infers, inferre, intuli, illatum', 'porter dans, contre'],
        ['ex- (e-)', 'effero, effers, efferre, extuli, elatum', 'porter hors de, emporter ; élever'],
        ['ob-', 'offero, offers, offerre, obtuli, oblatum', 'porter au-devant de, présenter, offrir'],
        ['cum- (con-, co-)', 'confero, confers, conferre, contuli, collatum', 'porter ensemble, réunir ; comparer'],
        ['re-', 'refero, refers, referre, retuli, relatum', 'porter de nouveau, rapporter, faire un rapport'],
        ['dis-', 'differo, differs, differre, distuli, dilatum', 'porter de côtés différents ; différer ; être différent'],
        ['per-', 'perfero, perfers, perferre, pertuli, perlatum', '(sup)porter jusqu\'au bout'],
        ['pro-', 'profero, profers, proferre, protuli, prolatum', 'porter en avant, présenter'],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quels sont les temps primitifs de ferre ?',
      options: [
        'fero, fers, ferre, tuli, latum',
        'fero, feris, ferere, feci, factum',
        'fero, fers, ferre, tuli, feritum',
        'facio, facis, facere, feci, factum',
      ],
      reponseCorrecte: 'fero, fers, ferre, tuli, latum',
    ),
    QuestionLecon(
      question: 'Que signifie ferre ?',
      options: ['porter, supporter, rapporter', 'faire', 'dire', 'aller'],
      reponseCorrecte: 'porter, supporter, rapporter',
    ),
    QuestionLecon(
      question: 'Quel est le radical du perfectum de ferre ?',
      options: ['tul-', 'fer-', 'lat-', 'tuli-'],
      reponseCorrecte: 'tul-',
    ),
    QuestionLecon(
      question: 'Quel est le radical du supin de ferre ?',
      options: ['lat-', 'fer-', 'tul-', 'ferit-'],
      reponseCorrecte: 'lat-',
    ),
    QuestionLecon(
      question: 'Quelle est la 2e personne du singulier de l\'indicatif présent actif ?',
      options: ['fers', 'feris', 'ferris', 'ferti'],
      reponseCorrecte: 'fers',
    ),
    QuestionLecon(
      question:
          'Pourquoi dit-on que ferre présente des formes irrégulières, bien qu\'il suive la 3e conjugaison ?',
      options: [
        'certaines formes n\'ont pas de voyelle de liaison (fer-s, fer-re)',
        'il a un radical différent à chaque personne',
        'il n\'a pas de forme passive',
        'il ne se conjugue qu\'au parfait',
      ],
      reponseCorrecte: 'certaines formes n\'ont pas de voyelle de liaison (fer-s, fer-re)',
    ),
    QuestionLecon(
      question:
          'Que signifient souvent ferunt et fertur employés avec une proposition infinitive (ACI) ?',
      options: ['on rapporte que', 'ils portent', 'il est porté', 'on dit que jamais'],
      reponseCorrecte: 'on rapporte que',
    ),
    QuestionLecon(
      question: 'Quel est l\'infinitif présent passif de ferre ?',
      options: ['ferri', 'ferre', 'ferere', 'ferrari'],
      reponseCorrecte: 'ferri',
    ),
    QuestionLecon(
      question: 'Que signifie le composé auferre (ab + ferre) ?',
      options: [
        'porter loin de, emporter, enlever',
        'porter vers, apporter',
        'porter dans, contre',
        'réunir, comparer',
      ],
      reponseCorrecte: 'porter loin de, emporter, enlever',
    ),
    QuestionLecon(
      question: 'Que signifie le composé differre (dis + ferre) ?',
      options: [
        'être différent, différer (remettre à plus tard)',
        'apporter',
        'réunir, comparer',
        'offrir',
      ],
      reponseCorrecte: 'être différent, différer (remettre à plus tard)',
    ),
    ExerciceSaisie(
      question:
          'Conjugue ferre à la 3e personne du singulier de l\'indicatif présent actif (il porte).',
      reponsesAcceptees: ['fert'],
    ),
    ExerciceSaisie(
      question:
          'Donne le supin du composé offerre (ob + ferre).',
      reponsesAcceptees: ['oblatum'],
      indice: 'Le préfixe ob- devient ob- devant le radical tul-/lat-.',
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'fero, fers, ferre, tuli, latum. Trois radicaux : fer- '
        '(infectum), tul- (perfectum), lat- (supin). Au présent, pas de '
        'voyelle de liaison (fer-s, fer-t, fer-re).',
      ),
      _tableauColonnes(
        ['pers.', 'présent actif', 'présent passif'],
        [
          ['je', 'fero', 'feror'],
          ['tu', 'fers', 'ferris'],
          ['il', 'fert', 'fertur'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les subjonctifs parfait et plus-que-parfait
// ------------------------------------------------------------

final Lecon _leconSubjonctifParfaitPlusQueParfait = Lecon(
  id: 'subjonctif_parfait_plusqueparfait',
  titre: 'Les subjonctifs parfait et plus-que-parfait',
  sousTitre: 'Suffixes -eri-/-isse- sur le radical du parfait, et concordance des temps',
  icone: Icons.history,
  unite: 'Vol. II – Unité 8',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Accidit saepe ut stulti bona consilia non ceperint. (Il arrive '
      'souvent que des hommes sots n\'aient pas pris les bonnes '
      'décisions.) Parentes timent ne erraverim. (Mes parents craignent '
      'que je ne me sois trompé.)',
    ),
    _titreExplication('La formation du subjonctif parfait'),
    _paragrapheExplication(
      'Pour former le subjonctif parfait, on ajoute au radical du '
      'parfait le suffixe -eri- suivi des terminaisons personnelles '
      'actives -m, -s, -t, -mus, -tis, -nt.',
    ),
    _tableauColonnes(
      ['pers.', 'amare'],
      [
        ['je', 'amaverim'],
        ['tu', 'amaveris'],
        ['il / elle', 'amaverit'],
        ['nous', 'amaverimus'],
        ['vous', 'amaveritis'],
        ['ils / elles', 'amaverint'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Le suffixe du subjonctif parfait ressemble beaucoup à celui d\'un '
      'autre temps déjà connu : l\'indicatif futur antérieur (amavero, '
      'amaveris, amaverit...). Les deux temps ne se distinguent que par '
      'la 1re personne du singulier : amavero (futur antérieur) mais '
      'amaverim (subjonctif parfait).',
    ),
    _titreExplication('La formation du subjonctif plus-que-parfait'),
    _paragrapheExplication(
      'Pueri metuebant ne parentes venissent. (Les enfants craignaient '
      'que leurs parents ne soient [déjà] arrivés.) Optabam ne '
      'erravisses. (Je souhaitais que tu ne te sois pas trompé.)',
    ),
    _paragrapheExplication(
      'Pour former le subjonctif plus-que-parfait, on ajoute au radical '
      'du parfait le suffixe -isse- suivi des terminaisons personnelles '
      'actives -m, -s, -t, -mus, -tis, -nt.\n\n'
      'Astuce : pour simplifier, tu peux ajouter les terminaisons '
      'personnelles actives à l\'infinitif parfait (amavisse + -m, -s, '
      '-t...).',
    ),
    _tableauColonnes(
      ['pers.', 'amare'],
      [
        ['je', 'amavissem'],
        ['tu', 'amavisses'],
        ['il / elle', 'amavisset'],
        ['nous', 'amavissemus'],
        ['vous', 'amavissetis'],
        ['ils / elles', 'amavissent'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Qui l\'eût cru ? En français, de même que le subjonctif '
      'imparfait, le subjonctif plus-que-parfait s\'utilise peu, sauf à '
      'la 3e personne du singulier ; on utilise plus fréquemment le '
      'subjonctif passé dans les autres cas.\n\n'
      'Astuce : pour former un subjonctif plus-que-parfait à la 3e '
      'personne du singulier en français, rien de plus simple : qu\'il '
      'eût / qu\'il fût + participe passé.',
    ),
    _titreExplication('La concordance des temps'),
    _paragrapheExplication(
      'Le temps de la proposition subordonnée au subjonctif dépend du '
      'temps de la proposition principale :',
    ),
    _tableauColonnes(
      ['principale', 'rapport', 'subordonnée'],
      [
        ['présent (ou futur)', 'antériorité', 'subj. parfait'],
        ['présent (ou futur)', 'simultanéité', 'subj. présent'],
        ['présent (ou futur)', 'postériorité', 'subj. présent'],
        ['passé', 'antériorité', 'subj. plus-que-parfait'],
        ['passé', 'simultanéité', 'subj. imparfait'],
        ['passé', 'postériorité', 'subj. imparfait'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Dans l\'interrogation indirecte, pour exprimer la postériorité, '
      'le latin utilise la périphrase -urus, a, um sim / essem.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quel suffixe utilise-t-on pour former le subjonctif parfait ?',
      options: ['-eri-', '-isse-', '-ba-', '-re-'],
      reponseCorrecte: '-eri-',
    ),
    QuestionLecon(
      question: 'Sur quel radical se forme le subjonctif parfait ?',
      options: [
        'le radical du parfait',
        'le radical de l\'infectum',
        'le radical du supin',
        'l\'infinitif présent',
      ],
      reponseCorrecte: 'le radical du parfait',
    ),
    QuestionLecon(
      question: 'Quelle est la 1re personne du singulier du subjonctif parfait de amare ?',
      options: ['amaverim', 'amavero', 'amarem', 'amem'],
      reponseCorrecte: 'amaverim',
    ),
    QuestionLecon(
      question:
          'À quelle personne le subjonctif parfait se distingue-t-il de l\'indicatif futur antérieur ?',
      options: [
        'la 1re personne du singulier',
        'la 2e personne du singulier',
        'la 3e personne du pluriel',
        'ils ne se distinguent jamais',
      ],
      reponseCorrecte: 'la 1re personne du singulier',
    ),
    QuestionLecon(
      question: 'Quel suffixe utilise-t-on pour former le subjonctif plus-que-parfait ?',
      options: ['-isse-', '-eri-', '-ba-', '-a-'],
      reponseCorrecte: '-isse-',
    ),
    QuestionLecon(
      question:
          'Quelle astuce permet de former facilement le subjonctif plus-que-parfait ?',
      options: [
        'ajouter les terminaisons personnelles actives à l\'infinitif parfait',
        'ajouter -ba- au radical du parfait',
        'utiliser l\'infinitif présent',
        'utiliser le participe futur',
      ],
      reponseCorrecte: 'ajouter les terminaisons personnelles actives à l\'infinitif parfait',
    ),
    QuestionLecon(
      question:
          'En français, à quelle personne le subjonctif plus-que-parfait s\'utilise-t-il encore couramment ?',
      options: [
        'la 3e personne du singulier',
        'la 1re personne du singulier',
        'toutes les personnes également',
        'il ne s\'utilise plus du tout',
      ],
      reponseCorrecte: 'la 3e personne du singulier',
    ),
    QuestionLecon(
      question:
          'Si la principale est à un temps du présent et la subordonnée exprime l\'antériorité, quel temps du subjonctif emploie-t-on ?',
      options: [
        'le subjonctif parfait',
        'le subjonctif présent',
        'le subjonctif imparfait',
        'le subjonctif plus-que-parfait',
      ],
      reponseCorrecte: 'le subjonctif parfait',
    ),
    QuestionLecon(
      question:
          'Si la principale est à un temps du passé et la subordonnée exprime la simultanéité, quel temps du subjonctif emploie-t-on ?',
      options: [
        'le subjonctif imparfait',
        'le subjonctif présent',
        'le subjonctif parfait',
        'le subjonctif plus-que-parfait',
      ],
      reponseCorrecte: 'le subjonctif imparfait',
    ),
    QuestionLecon(
      question:
          'Si la principale est à un temps du passé et la subordonnée exprime l\'antériorité, quel temps du subjonctif emploie-t-on ?',
      options: [
        'le subjonctif plus-que-parfait',
        'le subjonctif imparfait',
        'le subjonctif parfait',
        'le subjonctif présent',
      ],
      reponseCorrecte: 'le subjonctif plus-que-parfait',
    ),
    ExerciceSaisie(
      question: 'Conjugue amare à la 3e personne du singulier du subjonctif parfait actif.',
      reponsesAcceptees: ['amaverit'],
    ),
    ExerciceSaisie(
      question:
          'Conjugue amare à la 1re personne du pluriel du subjonctif plus-que-parfait actif.',
      reponsesAcceptees: ['amavissemus'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Subjonctif parfait : radical du parfait + -eri- + terminaisons '
        '(amaverim). Subjonctif plus-que-parfait : radical du parfait + '
        '-isse- + terminaisons (amavissem), soit infinitif parfait + '
        'terminaisons.',
      ),
      _tableauColonnes(
        ['principale', 'antériorité', 'simultanéité'],
        [
          ['présent/futur', 'subj. parfait', 'subj. présent'],
          ['passé', 'subj. plus-que-parfait', 'subj. imparfait'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les subordonnées circonstancielles de but (finales)
// ------------------------------------------------------------

final Lecon _leconSubordonneesBut = Lecon(
  id: 'subordonnees_but',
  titre: 'Les subordonnées circonstancielles de but',
  sousTitre: 'ut / ne + subjonctif : les subordonnées finales',
  icone: Icons.flag,
  unite: 'Vol. II – Unité 8',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Libros tibi affero ut eos legas. (Je t\'apporte des livres pour '
      'que tu les lises.) Litteras ad parentes misit ut auxilium sibi '
      'mitterent. (Il a envoyé une lettre à ses parents pour qu\'ils '
      'lui envoient de l\'aide.) Litteras ad parentes misi ne eis curae '
      'essent. (J\'ai envoyé une lettre à mes parents pour qu\'ils '
      'n\'aient pas de soucis.) Pueri discunt ut doctiores sint. (Les '
      'enfants étudient pour qu\'ils soient plus savants.) Pueri '
      'discunt ne errent. (Les enfants étudient pour qu\'ils ne se '
      'trompent pas.)',
    ),
    _paragrapheExplication(
      'Les subordonnées de but / finales sont introduites par la '
      'conjonction :\n\n'
      'ut (uti) → pour que, afin que (+ subjonctif) ; pour, afin de '
      '(+ infinitif)\n\n'
      'ne → pour que... ne... pas, afin que... ne... pas ; de peur que '
      '(ne), de crainte que (ne) ; pour ne pas, afin de ne pas (+ '
      'infinitif) ; de peur de, de crainte de (+ infinitif)\n\n'
      'Elles sont toujours suivies du subjonctif.',
    ),
    _paragrapheExplication(
      'En français, avec l\'expression « de peur que », on trouve '
      'également un « ne explétif » dont l\'emploi est facultatif.\n\n'
      'Ex. : Pueri bene discunt ne errent. (Les enfants étudient bien '
      'pour qu\'ils ne se trompent pas → de peur qu\'ils (ne) se '
      'trompent.) Incolae oppidum muniunt ne oppugnetur. (Les habitants '
      'fortifient la place forte pour qu\'elle ne soit pas attaquée → '
      'de peur qu\'elle (ne) soit attaquée.)',
    ),
    _titreExplication('La négation dans les subordonnées finales'),
    _paragrapheExplication(
      'Comme la négation est ne, on dira de même :\n\n'
      'pour que personne ne... → ne quisquam...\n'
      'pour que rien ne... → ne quidquam...\n'
      'pour qu\'aucun ne... → ne ullus, a, um...\n'
      'pour que jamais ne... → ne umquam...',
    ),
    _titreExplication('Le réfléchi dans les subordonnées finales'),
    _paragrapheExplication(
      'Pueri discunt ne quisquam se doctior sit. (Les enfants étudient '
      'pour que personne ne soit plus savant qu\'eux.) Litteras ad '
      'parentes misit ut auxilium sibi mitterent. (Il a envoyé une '
      'lettre à ses parents pour qu\'ils lui envoient de l\'aide.)',
    ),
    _paragrapheExplication(
      'De même que dans les subordonnées complétives (la proposition '
      'infinitive et les complétives introduites par ut/ne + '
      'subjonctif), dans les subordonnées de but le pronom réfléchi se '
      'et l\'adjectif possessif réfléchi suus renvoient :\n\n'
      '• ou bien au sujet de la même proposition = réfléchi direct\n'
      '• ou bien au sujet de la proposition principale = réfléchi '
      'indirect',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Par quelles conjonctions les subordonnées de but (finales) sont-elles introduites ?',
      options: ['ut (uti) et ne', 'ut et ut non', 'quod et quia', 'cum et si'],
      reponseCorrecte: 'ut (uti) et ne',
    ),
    QuestionLecon(
      question: 'À quel mode sont les subordonnées de but ?',
      options: ['le subjonctif', 'l\'indicatif', 'l\'infinitif seul', 'le participe'],
      reponseCorrecte: 'le subjonctif',
    ),
    QuestionLecon(
      question: 'Que signifie ut + subjonctif dans une subordonnée de but ?',
      options: ['pour que, afin que', 'pour que... ne... pas', 'parce que', 'bien que'],
      reponseCorrecte: 'pour que, afin que',
    ),
    QuestionLecon(
      question: 'Que signifie ne + subjonctif dans une subordonnée de but ?',
      options: [
        'pour que... ne... pas, de peur que',
        'pour que',
        'à condition que',
        'même si',
      ],
      reponseCorrecte: 'pour que... ne... pas, de peur que',
    ),
    QuestionLecon(
      question:
          'Qu\'est-ce que le « ne explétif », que l\'on trouve en français après « de peur que » ?',
      options: [
        'un ne qui ne rend pas la phrase négative, d\'emploi facultatif',
        'un ne obligatoire qui rend la phrase négative',
        'une faute de français',
        'un ne qui s\'utilise uniquement en latin',
      ],
      reponseCorrecte: 'un ne qui ne rend pas la phrase négative, d\'emploi facultatif',
    ),
    QuestionLecon(
      question: 'Comment dit-on « pour que personne ne... » dans une subordonnée de but ?',
      options: ['ne quisquam', 'ut nemo', 'ne nemo', 'ut non quisquam'],
      reponseCorrecte: 'ne quisquam',
    ),
    QuestionLecon(
      question: 'Comment dit-on « pour qu\'aucun ne... » ?',
      options: ['ne ullus, a, um', 'ut nullus, a, um', 'ne nullus', 'ut ullus'],
      reponseCorrecte: 'ne ullus, a, um',
    ),
    QuestionLecon(
      question: 'Comment dit-on « pour que rien ne... » ?',
      options: ['ne quidquam', 'ut nihil', 'ne nihil', 'ut quidquam'],
      reponseCorrecte: 'ne quidquam',
    ),
    QuestionLecon(
      question:
          'Dans une subordonnée de but, quand le pronom réfléchi se renvoie-t-il au sujet de la proposition principale ?',
      options: ['quand c\'est un réfléchi indirect', 'quand c\'est un réfléchi direct', 'jamais', 'toujours'],
      reponseCorrecte: 'quand c\'est un réfléchi indirect',
    ),
    ExerciceSaisie(
      question: 'Quelle conjonction introduit une subordonnée de but positive (« pour que ») ?',
      reponsesAcceptees: ['ut'],
    ),
    ExerciceSaisie(
      question:
          'Quelle conjonction introduit une subordonnée de but négative (« pour que... ne... pas ») ?',
      reponsesAcceptees: ['ne'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['conjonction', 'sens'],
        [
          ['ut (uti)', 'pour que, afin que (+ subj.)'],
          ['ne', 'pour que... ne... pas, de peur que'],
          ['ne quisquam', 'pour que personne ne...'],
          ['ne quidquam', 'pour que rien ne...'],
          ['ne ullus, a, um', 'pour qu\'aucun ne...'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Toujours au subjonctif. se/suus renvoient au sujet de la même '
        'proposition (direct) ou de la principale (indirect).',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les subordonnées circonstancielles de conséquence
// ------------------------------------------------------------

final Lecon _leconSubordonneesConsequence = Lecon(
  id: 'subordonnees_consequence',
  titre: 'Les subordonnées circonstancielles de conséquence',
  sousTitre: 'ut / ut non + subjonctif, et les corrélatifs tam, talis, tantus...',
  icone: Icons.compare_arrows,
  unite: 'Vol. II – Unité 8',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Aeger sum. (Je suis malade — cause.) Domi maneo. (Je reste à la '
      'maison — conséquence.) La subordonnée de conséquence exprime la '
      'même relation logique que la subordonnée de cause, mais du '
      'point de vue inverse.',
    ),
    _paragrapheExplication(
      'Les subordonnées de conséquence sont toujours au subjonctif. '
      'Elles sont introduites par ut (uti) « de telle sorte (façon, '
      'manière) que », « à tel point que », « si bien que ». La '
      'négation est ut non.\n\n'
      'Ex. : Aeger sum ut domi maneam. (Je suis malade à tel point que '
      'je reste à la maison.)',
    ),
    _titreExplication('La négation dans les subordonnées de conséquence'),
    _paragrapheExplication(
      'Comme la négation est ut non, on dira de même :\n\n'
      'de telle sorte que personne ne... → ut nemo...\n'
      'de telle sorte que rien ne... → ut nihil...\n'
      'de telle sorte qu\'aucun ne... → ut nullus, a, um...\n'
      'de telle sorte que jamais... → ut numquam...',
    ),
    _titreExplication('Les expressions corrélatives'),
    _paragrapheExplication(
      'Tam aeger sum ut domi maneam. (Je suis si malade que je reste à '
      'la maison.) Talis est morbus ut ambulare non possim. (Ma '
      'maladie est telle que je ne peux pas me promener.)\n\n'
      'Les subordonnées de conséquence sont souvent annoncées par un '
      'corrélatif : la conjonction ut/uti est annoncée dans la '
      'proposition principale par un adverbe ou un adjectif.',
    ),
    _tableauColonnes(
      ['corrélatif', 'sens'],
      [
        ['tam (+ adj./adv.) ... ut', 'si, tellement (+ adj./adv.) ... que'],
        ['ita / sic / adeo (+ verbe) ... ut', 'tellement, à tel point (+ verbe) ... que'],
        ['tantus, a, um ... ut', 'si grand que'],
        ['talis, e ... ut / is, ea, id ... ut', 'tel ... que'],
        ['tot (indéclinable = tam multi) ... ut', 'si nombreux que'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Réfléchi ou non réfléchi ?'),
    _paragrapheExplication(
      'Hic vir probus non est ita ut nemo ei credere possit. (Cet homme '
      'n\'est pas honnête, de telle sorte que personne ne peut lui '
      'faire confiance.) Hic vir probus non est ita ut ejus verbis '
      'credere non possis. (...de telle sorte que tu ne peux faire '
      'confiance à ses paroles.) Haec mulier tam valida est ut nihil '
      'eam movere possit. (Cette femme est si robuste que rien ne peut '
      'l\'émouvoir.)',
    ),
    _paragrapheExplication(
      'Il n\'y a pas de réfléchi indirect dans les subordonnées de '
      'conséquence : contrairement aux subordonnées de but ou aux '
      'complétives, se et suus n\'y renvoient jamais au sujet de la '
      'principale, mais toujours au sujet de la subordonnée elle-même '
      '(ejus, ei remplacent alors se, sibi pour renvoyer à la '
      'principale).',
    ),
    _titreExplication('L\'emploi des temps : une particularité'),
    _paragrapheExplication(
      'Le temps du subjonctif employé dans les subordonnées consécutives '
      'correspond en principe au temps qu\'on utiliserait dans une '
      'proposition principale : là où il y aurait un indicatif '
      'imparfait dans une principale, on trouve un subjonctif imparfait '
      'dans la subordonnée. L\'imparfait du subjonctif est ainsi le '
      'temps le plus usuel dans les subordonnées consécutives en latin '
      '; le subjonctif plus-que-parfait y est plutôt rare.',
    ),
    _paragrapheExplication(
      'Le subjonctif parfait, quant à lui, peut avoir une valeur '
      'particulière : avec une principale au passé, il exprime dans la '
      'subordonnée consécutive une conséquence durable et acquise, ou '
      'présente la conséquence comme un fait réel. On peut souvent le '
      'traduire par un passé simple en français.\n\n'
      'Ex. : Eorum amicitia talis erat ut numquam se reliquerint. (Leur '
      'amitié était telle qu\'ils ne se quittèrent jamais.)',
    ),
    _paragrapheExplication(
      'En latin, les subordonnées de conséquence sont toujours au '
      'subjonctif ; en français, elles sont à l\'indicatif s\'il s\'agit '
      'd\'une conséquence réelle, et au subjonctif s\'il s\'agit d\'une '
      'conséquence souhaitée.\n\n'
      'Ex. : Répartissez les tâches de telle sorte que personne n\'ait '
      'trop de travail (conséquence souhaitée). Ils ont réparti les '
      'tâches de telle sorte que personne n\'avait trop de travail '
      '(conséquence réelle).',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'À quel mode sont toujours les subordonnées de conséquence en latin ?',
      options: ['le subjonctif', 'l\'indicatif', 'l\'infinitif', 'le participe'],
      reponseCorrecte: 'le subjonctif',
    ),
    QuestionLecon(
      question: 'Par quelle conjonction les subordonnées de conséquence sont-elles introduites ?',
      options: ['ut (uti)', 'quod', 'cum', 'si'],
      reponseCorrecte: 'ut (uti)',
    ),
    QuestionLecon(
      question: 'Quelle est la négation d\'une subordonnée de conséquence ?',
      options: ['ut non', 'ne', 'non ut', 'ne non'],
      reponseCorrecte: 'ut non',
    ),
    QuestionLecon(
      question:
          'Quelle relation logique la subordonnée de conséquence exprime-t-elle, par rapport à la subordonnée de cause ?',
      options: [
        'la même relation, du point de vue inverse',
        'une relation totalement différente',
        'une opposition',
        'une condition',
      ],
      reponseCorrecte: 'la même relation, du point de vue inverse',
    ),
    QuestionLecon(
      question: 'Comment dit-on « de telle sorte que personne ne... » ?',
      options: ['ut nemo', 'ne quisquam', 'ut non nemo', 'ne nemo'],
      reponseCorrecte: 'ut nemo',
    ),
    QuestionLecon(
      question:
          'Quel corrélatif, employé avec un adjectif ou un adverbe, annonce souvent une subordonnée de conséquence (« si, tellement ») ?',
      options: ['tam', 'tantus, a, um', 'talis, e', 'tot'],
      reponseCorrecte: 'tam',
    ),
    QuestionLecon(
      question: 'Que signifie le corrélatif tantus, a, um ... ut ?',
      options: ['si grand que...', 'tel que...', 'si nombreux que...', 'tellement que...'],
      reponseCorrecte: 'si grand que...',
    ),
    QuestionLecon(
      question: 'Y a-t-il un réfléchi indirect possible dans les subordonnées de conséquence ?',
      options: [
        'non, il n\'y a pas de réfléchi indirect',
        'oui, comme dans les complétives',
        'oui, mais seulement au pluriel',
        'cela dépend du corrélatif',
      ],
      reponseCorrecte: 'non, il n\'y a pas de réfléchi indirect',
    ),
    QuestionLecon(
      question: 'Quel temps du subjonctif est le plus usuel dans les subordonnées consécutives en latin ?',
      options: ['l\'imparfait', 'le présent', 'le parfait', 'le plus-que-parfait'],
      reponseCorrecte: 'l\'imparfait',
    ),
    QuestionLecon(
      question:
          'Avec une principale au passé, quelle valeur particulière peut avoir le subjonctif parfait dans une subordonnée consécutive ?',
      options: [
        'il exprime une conséquence durable, comme un fait réel (traduisible par un passé simple)',
        'il exprime le futur',
        'il marque l\'irréel du passé',
        'il n\'a aucune valeur particulière',
      ],
      reponseCorrecte:
          'il exprime une conséquence durable, comme un fait réel (traduisible par un passé simple)',
    ),
    QuestionLecon(
      question: 'En français, à quel mode se met une subordonnée de conséquence réelle ?',
      options: ['l\'indicatif', 'le subjonctif', 'l\'infinitif', 'le conditionnel'],
      reponseCorrecte: 'l\'indicatif',
    ),
    ExerciceSaisie(
      question: 'Quelle conjonction introduit une subordonnée de conséquence ?',
      reponsesAcceptees: ['ut'],
    ),
    ExerciceSaisie(
      question:
          'Quel corrélatif signifie « tel... que » et se décline comme un adjectif de la 2e classe ?',
      reponsesAcceptees: ['talis'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['corrélatif', 'sens'],
        [
          ['tam ... ut', 'si, tellement ... que'],
          ['ita / sic / adeo ... ut', 'tellement, à tel point ... que'],
          ['tantus, a, um ... ut', 'si grand que'],
          ['talis, e ... ut', 'tel ... que'],
          ['tot ... ut', 'si nombreux que'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Toujours au subjonctif, négation ut non. Pas de réfléchi '
        'indirect. Le subjonctif imparfait est le plus fréquent ; le '
        'subjonctif parfait, après une principale au passé, exprime une '
        'conséquence durable ou réelle.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Le verbe ire et ses composés
// ------------------------------------------------------------

final Lecon _leconIreComposes = Lecon(
  id: 'ire_composes',
  titre: 'Le verbe ire et ses composés',
  sousTitre: 'eo, is, ire, ivi (ii), itum : présent irrégulier, parfait régulier',
  icone: Icons.directions_walk,
  unite: 'Vol. II – Unité 9',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Le français « aller » est un verbe irrégulier qui combine trois '
      'radicaux issus de trois verbes latins distincts : eo, is, ire, '
      'ivi (ii), itum a donné les formes en ir- (comme au futur « il '
      'ira ») ; vado, vadis, vadere a donné les formes en v- (« je '
      'vais, tu vas ») ; ambulo, as, are « marcher, se promener », '
      'selon certains linguistes, aurait donné les formes en all- '
      '(« aller, nous allons, il alla »), mais son origine n\'est pas '
      'sûre. On retrouve ces racines dans des verbes dérivés restés '
      'réguliers, comme « déambuler » (ambulare) ou « s\'évader » '
      '(vadere).',
    ),
    _titreExplication('Les temps primitifs du verbe ire'),
    _paragrapheExplication(
      'eo, is, ire, ivi ou ii, itum « aller ». La forme ivi peut '
      's\'abréger en ii, comme tu l\'as déjà vu avec d\'autres verbes '
      '(ex. audii pour audivi).',
    ),
    _paragrapheExplication(
      'Ce verbe est régulier aux temps formés sur le radical du parfait '
      '(perfectum). En revanche, il est irrégulier à l\'indicatif '
      'présent et au participe présent : son radical du présent '
      '(infectum) est i- ou e- (< *ey-).',
    ),
    _titreExplication('L\'indicatif présent, l\'imparfait et le futur'),
    _tableauColonnes(
      ['pers.', 'présent', 'imparfait', 'futur'],
      [
        ['je', 'eo', 'ibam', 'ibo'],
        ['tu', 'is', 'ibas', 'ibis'],
        ['il / elle', 'it', 'ibat', 'ibit'],
        ['nous', 'imus', 'ibamus', 'ibimus'],
        ['vous', 'itis', 'ibatis', 'ibitis'],
        ['ils / elles', 'eunt', 'ibant', 'ibunt'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Le participe présent : iens, euntis'),
    _tableauColonnes(
      ['cas', 'masc. / fém.', 'neutre'],
      [
        ['nom.', 'iens', 'iens'],
        ['acc.', 'euntem', 'iens'],
        ['gén.', 'euntis', 'euntis'],
        ['dat.', 'eunti', 'eunti'],
        ['abl.', 'eunte', 'eunte'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Au pluriel, ce participe se décline régulièrement comme un '
      'adjectif de la 3e déclinaison : euntes, euntium, euntibus.',
    ),
    _titreExplication('Le parfait, le plus-que-parfait, le futur antérieur : réguliers'),
    _tableauColonnes(
      ['pers.', 'parfait', 'plus-que-parfait', 'futur antérieur'],
      [
        ['je', 'ivi (ou ii)', 'iveram (ou ieram)', 'ivero (ou iero)'],
        ['tu', 'ivisti (ou iisti)', 'iveras (ou ieras)', 'iveris (ou ieris)'],
        ['il / elle', 'ivit (ou iit)', 'iverat (ou ierat)', 'iverit (ou ierit)'],
        ['nous', 'ivimus (ou iimus)', 'iveramus (ou ieramus)', 'iverimus (ou ierimus)'],
        ['vous', 'ivistis (ou iistis)', 'iveratis (ou ieratis)', 'iveritis (ou ieritis)'],
        ['ils / elles', 'iverunt (ou ierunt)', 'iverant (ou ierant)', 'iverint (ou ierint)'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Les composés de ire'),
    _paragrapheExplication(
      'La conjugaison des composés est identique à celle de ire : il '
      'suffit d\'y ajouter le préfixe concerné. Nota bene : le parfait '
      'des composés de ire est en -ii ; le radical du parfait est donc '
      'en -i- (transi-, abi-, ini-...).',
    ),
    _tableauColonnes(
      ['préfixe', 'temps primitifs', 'sens'],
      [
        ['ab-', 'abeo, abis, abire, abii, abitum', 's\'éloigner (de), s\'en aller, partir (de)'],
        ['ad-', 'adeo, adis, adire, adii, aditum', 'aller (vers), s\'approcher (de), aborder'],
        ['ex-', 'exeo, exis, exire, exii, exitum', 'sortir (de), partir (de)'],
        ['in-', 'ineo, inis, inire, inii, initum', 'entrer (dans), commencer'],
        ['inter-', 'intereo, interis, interire, interii, interitum', 'mourir, périr'],
        ['per-', 'pereo, peris, perire, perii, peritum', 'mourir, périr'],
        ['re-', 'redeo, redis, redire, redii, reditum', 'revenir'],
        ['trans-', 'transeo, transis, transire, transii, transitum', 'traverser, franchir, passer au-delà (de)'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Après un verbe de mouvement comme ire, souviens-toi que le supin '
      'exprime le but.\n\n'
      'Ex. : Milites Romani mare transierunt Carthaginem captum. (Les '
      'soldats romains traversèrent la mer pour prendre Carthage.)',
    ),
    _titreExplication('Les adverbes de lieu'),
    _paragrapheExplication(
      'Pour bien les retenir, voici de courtes phrases faciles à '
      'mémoriser :\n\n'
      'Ubi es ? Ibi sum. (Où es-tu ? Je suis là, j\'y suis.)\n'
      'Quo is ? Eo eo. (Où vas-tu ? J\'y vais.)\n'
      'Unde redis ? Inde redeo. (D\'où reviens-tu ? Je reviens de là, '
      'j\'en reviens.)\n'
      'Quā iter facis ? Eā iter facio. (Par où passes-tu ? Je passe par '
      'là.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quels sont les temps primitifs de ire ?',
      options: [
        'eo, is, ire, ivi (ii), itum',
        'eo, is, ire, ivi, eitum',
        'vado, vadis, vadere, vasi, vasum',
        'facio, facis, facere, feci, factum',
      ],
      reponseCorrecte: 'eo, is, ire, ivi (ii), itum',
    ),
    QuestionLecon(
      question: 'Quel est le radical de l\'infectum (présent) de ire ?',
      options: ['i- (ou e-)', 'iv-', 'it-', 'ii-'],
      reponseCorrecte: 'i- (ou e-)',
    ),
    QuestionLecon(
      question: 'Le verbe ire est-il régulier ou irrégulier au parfait ?',
      options: ['régulier', 'irrégulier', 'il n\'a pas de parfait', 'cela dépend du composé'],
      reponseCorrecte: 'régulier',
    ),
    QuestionLecon(
      question: 'Quelle est la 3e personne du pluriel de l\'indicatif présent de ire ?',
      options: ['eunt', 'eont', 'iunt', 'ibunt'],
      reponseCorrecte: 'eunt',
    ),
    QuestionLecon(
      question: 'Quel est le génitif du participe présent iens ?',
      options: ['euntis', 'ientis', 'itis', 'euntus'],
      reponseCorrecte: 'euntis',
    ),
    QuestionLecon(
      question: 'Quelle forme abrégée du parfait ivi rencontre-t-on souvent ?',
      options: ['ii', 'iv', 'it', 'eii'],
      reponseCorrecte: 'ii',
    ),
    QuestionLecon(
      question: 'Que signifie le composé abeo (a(b) + ablatif) ?',
      options: [
        's\'éloigner, s\'en aller, partir',
        'aller vers, s\'approcher',
        'entrer dans',
        'revenir',
      ],
      reponseCorrecte: 's\'éloigner, s\'en aller, partir',
    ),
    QuestionLecon(
      question: 'Que signifient intereo et pereo ?',
      options: ['mourir, périr', 'revenir', 'sortir, partir', 'traverser'],
      reponseCorrecte: 'mourir, périr',
    ),
    QuestionLecon(
      question: 'Que signifie transeo (+ acc. ou per + acc.) ?',
      options: [
        'traverser, franchir, passer au-delà de',
        'entrer dans',
        'sortir de',
        'revenir',
      ],
      reponseCorrecte: 'traverser, franchir, passer au-delà de',
    ),
    QuestionLecon(
      question: 'Après un verbe de mouvement comme ire, qu\'exprime le supin ?',
      options: ['le but', 'la cause', 'la conséquence', 'la concession'],
      reponseCorrecte: 'le but',
    ),
    ExerciceSaisie(
      question: 'Conjugue ire à la 3e personne du singulier de l\'indicatif présent (il va).',
      reponsesAcceptees: ['it'],
    ),
    ExerciceSaisie(
      question: 'Donne la forme abrégée du parfait ivi (1re personne du singulier).',
      reponsesAcceptees: ['ii'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['pers.', 'présent', 'parfait'],
        [
          ['je', 'eo', 'ivi (ii)'],
          ['tu', 'is', 'ivisti'],
          ['il', 'it', 'ivit'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Radical du présent irrégulier (i-/e-), radical du parfait '
        'régulier (iv-/i-). Les composés se conjuguent comme ire, avec '
        'un parfait en -ii.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Rappel — les préfixes dans les verbes composés
// ------------------------------------------------------------

final Lecon _leconRappelPrefixesComposes = Lecon(
  id: 'rappel_prefixes_composes',
  titre: 'Rappel : les préfixes dans les verbes composés',
  sousTitre: 'Tableau récapitulatif des préverbes, et le phénomène d\'apophonie',
  icone: Icons.transform,
  unite: 'Vol. II – Unité 9',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Tu connais maintenant le principe des verbes composés : un '
      'préverbe, souvent identique à une préposition, se combine avec '
      'un verbe simple. Il est souvent possible de déduire le sens du '
      'verbe composé à partir du sens du verbe simple et de celui du '
      'préfixe.',
    ),
    _titreExplication('Tableau récapitulatif des préverbes'),
    _tableauColonnes(
      ['préverbe', 'sens', 'exemples de composés'],
      [
        ['ad-', 'près de, vers', 'adsum (être présent), adeo (s\'approcher), affero (apporter), addo (ajouter)'],
        ['ab- (a-)', 'loin de', 'absum (être absent), abeo (s\'éloigner), aufero (emporter, enlever)'],
        ['in-', 'dans', 'ineo (entrer, commencer), infero (porter dans, contre)'],
        ['ex- (e-)', 'hors de', 'exeo (sortir), effero (emporter, élever)'],
        ['ob-', 'au-devant de, en face de', 'obsum (nuire), offero (offrir, présenter)'],
        ['cum- (con-, co-)', 'avec, ensemble', 'confero (réunir, comparer), convenio (se rassembler), cogo (réunir, obliger)'],
        ['re-', 'en arrière, à nouveau', 'redeo (revenir), refero (rapporter), reddo (rendre)'],
        ['dis-', 'de côtés différents', 'differo (différer, remettre à plus tard)'],
        ['trans- (tra-)', 'à travers', 'transeo (traverser), trado (transmettre, livrer, confier)'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Le phénomène de l\'apophonie'),
    _paragrapheExplication(
      'Quand un verbe simple contient un ă bref dans sa première '
      'syllabe, celui-ci se transforme dans les composés :\n\n'
      '• en ĭ dans les composés ;\n'
      '• en ĕ devant un r ou une consonne double.',
    ),
    _tableauColonnes(
      ['verbe simple', 'verbe composé', 'sens'],
      [
        ['capio, is, ere, cepi, captum', 'accipio, is, ere, accepi, acceptum', '< prendre près de soi >, recevoir, accueillir, apprendre'],
        ['facio, is, ere, feci, factum', 'perficio, is, ere, perfeci, perfectum', '< faire jusqu\'au bout >, achever, parfaire'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Le verbe dare présente une particularité : contrairement aux '
      'autres verbes de la 1re conjugaison, son a est bref. Le '
      'phénomène d\'apophonie transforme ainsi les composés de dare en '
      'verbes de la 3e conjugaison.',
    ),
    _tableauColonnes(
      ['verbe simple', 'verbe composé', 'sens'],
      [
        ['do, das, dare, dedi, datum', 'addo, addis, addere, addidi, additum', '< donner en plus, placer près de >, ajouter'],
        ['do, das, dare, dedi, datum', 'reddo, reddis, reddere, reddidi, redditum', '< re-donner >, rendre'],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Qu\'est-ce qui permet souvent de déduire le sens d\'un verbe composé ?',
      options: [
        'le sens du verbe simple et celui du préfixe',
        'uniquement la terminaison',
        'le contexte, jamais la morphologie',
        'le nombre de syllabes',
      ],
      reponseCorrecte: 'le sens du verbe simple et celui du préfixe',
    ),
    QuestionLecon(
      question: 'Que signifie le préverbe cum- (con-, co-) ?',
      options: ['avec, ensemble', 'loin de', 'au-devant de', 'à travers'],
      reponseCorrecte: 'avec, ensemble',
    ),
    QuestionLecon(
      question: 'Que signifie le préverbe dis- ?',
      options: ['de côtés différents', 'avec, ensemble', 'dans', 'vers'],
      reponseCorrecte: 'de côtés différents',
    ),
    QuestionLecon(
      question: 'Qu\'est-ce que l\'apophonie ?',
      options: [
        'la transformation d\'un ă bref de la première syllabe en ĭ (ou ĕ) dans un composé',
        'la disparition d\'une syllabe entière dans un composé',
        'le redoublement de la première syllabe au parfait',
        'l\'allongement systématique des voyelles dans les composés',
      ],
      reponseCorrecte: 'la transformation d\'un ă bref de la première syllabe en ĭ (ou ĕ) dans un composé',
    ),
    QuestionLecon(
      question: 'Devant quoi le ă bref devient-il ĕ, plutôt que ĭ, dans un composé ?',
      options: ['devant un r ou une consonne double', 'devant une voyelle', 'en fin de mot', 'jamais, seul ĭ est possible'],
      reponseCorrecte: 'devant un r ou une consonne double',
    ),
    QuestionLecon(
      question: 'Quel est le composé de capio (par apophonie) qui signifie « recevoir, accueillir » ?',
      options: ['accipio', 'incipio', 'recipio', 'concipio'],
      reponseCorrecte: 'accipio',
    ),
    QuestionLecon(
      question: 'Quel est le composé de facio qui signifie « achever, parfaire » ?',
      options: ['perficio', 'affacio', 'deficio', 'proficio'],
      reponseCorrecte: 'perficio',
    ),
    QuestionLecon(
      question: 'Pourquoi le verbe dare a-t-il un comportement particulier face à l\'apophonie ?',
      options: [
        'son a est bref, contrairement aux autres verbes de la 1re conjugaison',
        'il n\'a pas de composés',
        'il appartient déjà à la 3e conjugaison',
        'son radical du parfait est irrégulier',
      ],
      reponseCorrecte: 'son a est bref, contrairement aux autres verbes de la 1re conjugaison',
    ),
    QuestionLecon(
      question: 'À quelle conjugaison les composés de dare (addo, reddo...) appartiennent-ils, à cause de l\'apophonie ?',
      options: ['la 3e conjugaison', 'la 1re conjugaison', 'la 4e conjugaison', 'ils restent hors conjugaison'],
      reponseCorrecte: 'la 3e conjugaison',
    ),
    ExerciceSaisie(
      question: 'Donne le composé de dare avec le préverbe red- (« rendre »), à l\'infinitif présent.',
      reponsesAcceptees: ['reddere'],
    ),
    ExerciceSaisie(
      question: 'Donne le supin du composé addo (préverbe ad- + dare).',
      reponsesAcceptees: ['additum'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Un ă bref de première syllabe devient ĭ dans un composé (capio '
        '→ accipio), ou ĕ devant r/consonne double (facio → perficio). '
        'dare, à a bref, bascule même de conjugaison : do, dare → addo, '
        'addere ; reddo, reddere.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les pronoms-adjectifs alius et alter
// ------------------------------------------------------------

final Lecon _leconAliusAlterUter = Lecon(
  id: 'alius_alter_uter',
  titre: 'Les pronoms-adjectifs alius et alter',
  sousTitre: 'Deux, ou plus de deux ? — et uter, uterque, neuter',
  icone: Icons.compare,
  unite: 'Vol. II – Unité 9',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Mucius Scaevola dextram amisit ; altera manu nunc pugnat. '
      '(Mucius Scaevola a perdu sa main droite ; il combat maintenant '
      'de l\'autre main.) Cum alter consul Romae esset, alter in '
      'Gallia copiis praeerat. (Alors que l\'un des deux consuls était '
      'à Rome, l\'autre commandait les troupes en Gaule.) Ledonae duo '
      'filii sunt : alter equitibus Treveris adest, alter nobilium '
      'consiliis interest. (Ledo a deux fils : l\'un assiste les '
      'cavaliers trévires, l\'autre participe aux conseils des '
      'nobles.)',
    ),
    _paragrapheExplication(
      'Quod iste equus veterior nunc est, alio equo iter faciam. '
      '(Comme ce cheval est maintenant plus vieux, je ferai le voyage '
      'avec un autre cheval.) Multi juvenes qui Britannici caedi '
      'adfuerunt, terrentur et fugam capiunt ; alii vero manent et '
      'Neronem adspiciunt. (Beaucoup de jeunes gens qui assistèrent au '
      'meurtre de Britannicus sont terrifiés et prennent la fuite ; '
      'd\'autres cependant restent et regardent Néron.) Ledonae tres '
      'liberi fuerunt : alius equitibus Treveris adfuit, alius caupo '
      'fuit, alia infans periit. (Ledo a eu trois enfants : l\'un '
      'assista les cavaliers trévires, un autre fut aubergiste, une '
      'autre, enfant, périt.)',
    ),
    _titreExplication('La morphologie'),
    _paragrapheExplication(
      'alter, altera, alterum « l\'un (des deux), l\'autre (des deux), '
      'le second » (pluriel : « les uns... les autres... »).\n\n'
      'alius, alia, aliud « un (de plus de deux), un autre » (pluriel '
      ': « les uns... d\'autres... »).',
    ),
    _tableauColonnes(
      ['cas', 'alter (m.)', 'altera (f.)', 'alterum (n.)'],
      [
        ['nom.', 'alter', 'altera', 'alterum'],
        ['acc.', 'alterum', 'alteram', 'alterum'],
        ['gén.', 'alterius', 'alterius', 'alterius'],
        ['dat.', 'alteri', 'alteri', 'alteri'],
        ['abl.', 'altero', 'altera', 'altero'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Comme unus, solus, totus et nullus, alter et alius se déclinent '
      'avec un génitif en -ius et un datif en -i au singulier, quel '
      'que soit le genre.',
    ),
    _tableauColonnes(
      ['cas', 'alius (m.)', 'alia (f.)', 'aliud (n.)'],
      [
        ['nom.', 'alius', 'alia', 'aliud'],
        ['acc.', 'alium', 'aliam', 'aliud'],
        ['dat.', 'alii', 'alii', 'alii'],
        ['abl.', 'alio', 'alia', 'alio'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Alius n\'a pas de génitif : on utilise alors l\'adjectif '
      'alienus, a, um « étranger, d\'autrui ».\n\n'
      'Ex. : aliena mala, « les maux d\'autrui ».',
    ),
    _titreExplication('Alter : deux ; alius : plus de deux'),
    _paragrapheExplication(
      'Alter s\'emploie quand on parle de deux personnes, de deux '
      'choses, de deux groupes. Alius s\'emploie quand on parle de '
      'plus de deux personnes, choses ou groupes.',
    ),
    _titreExplication('Employés seuls'),
    _paragrapheExplication(
      'alter, altera, alterum « l\'un (des deux), l\'autre (des deux) '
      '» (pluriel : « les uns, les autres »). alius, alia, aliud « un '
      'autre » (pluriel : « d\'autres »).\n\n'
      'Ex. : Alter consul venit. (adjectif) Altera venit. (pronom) '
      'Alteri venerunt. (pronom, pluriel) — Alius civis venit. '
      '(adjectif) Alia venit. (pronom) Alii venerunt. (pronom, '
      'pluriel).',
    ),
    _titreExplication('Employés en série'),
    _paragrapheExplication(
      'alter... alter... « l\'un..., l\'autre... » (pluriel alteri... '
      'alteri... « les uns..., les autres... »). alius... alius... '
      '« l\'un..., un autre... » (pluriel alii... alii... alii... « '
      'les uns..., d\'autres..., d\'autres... »).\n\n'
      'Ex. : Alter scribit, alter legit. (L\'un écrit, l\'autre lit.) '
      'Alii scribunt, alii legunt, alii discunt. (Les uns écrivent, '
      'd\'autres lisent, d\'autres étudient.)',
    ),
    _titreExplication('Réciprocité et diversité'),
    _paragrapheExplication(
      'Alter et alius, répétés à des cas différents, peuvent marquer :'
      '\n\n'
      '• la réciprocité — Alter alteri adest. (Ils s\'aident l\'un '
      'l\'autre, ils s\'entraident.) Alii aliis obsunt. (Ils se '
      'nuisent entre eux, mutuellement.)\n\n'
      '• la diversité — Alii in aliam provinciam discesserunt. (Les '
      'uns partirent dans une province, d\'autres dans une autre → ils '
      'partirent dans des provinces différentes.)',
    ),
    _titreExplication('La comparaison : « autre que »'),
    _paragrapheExplication(
      'De même que idem s\'accompagne de que pour dire « le même que '
      '», alius s\'accompagne de atque (ou ac) pour dire « autre que '
      '». Autre que = alius atque (ac).',
    ),
    _titreExplication('Lequel des deux, tous les deux, aucun des deux'),
    _paragrapheExplication(
      'Cum utro consule verba fecisti ? (Auquel des deux consuls '
      'as-tu parlé ?)',
    ),
    _paragrapheExplication(
      'uter, utra, utrum ? « lequel (des deux) ? »\n'
      'uterque, utraque, utrumque « l\'un et l\'autre, tous les deux »\n'
      'neuter, neutra, neutrum « aucun (des deux), ni l\'un, ni '
      'l\'autre »\n\n'
      'Ces trois mots se déclinent comme alter, et présentent donc au '
      'génitif utrius, utriusque, neutrius, et au datif utri, utrique, '
      'neutri.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Alter s\'emploie-t-il pour parler de deux ou de plus de deux éléments ?',
      options: ['de deux', 'de plus de deux', 'indifféremment des deux', 'uniquement d\'un seul'],
      reponseCorrecte: 'de deux',
    ),
    QuestionLecon(
      question: 'Alius s\'emploie-t-il pour parler de deux ou de plus de deux éléments ?',
      options: ['de plus de deux', 'de deux', 'uniquement au pluriel', 'uniquement au singulier'],
      reponseCorrecte: 'de plus de deux',
    ),
    QuestionLecon(
      question: 'Quel est le génitif singulier de alter, a, um (aux trois genres) ?',
      options: ['alterius', 'alteri', 'alterorum', 'alterae'],
      reponseCorrecte: 'alterius',
    ),
    QuestionLecon(
      question: 'Comment forme-t-on le génitif de alius, faute de génitif propre ?',
      options: [
        'avec l\'adjectif alienus, a, um',
        'avec alterius',
        'avec aliusius',
        'alius n\'a jamais besoin de génitif',
      ],
      reponseCorrecte: 'avec l\'adjectif alienus, a, um',
    ),
    QuestionLecon(
      question: 'Que signifie alter... alter... ?',
      options: ['l\'un..., l\'autre...', 'les uns..., d\'autres...', 'ni l\'un ni l\'autre', 'tous les deux'],
      reponseCorrecte: 'l\'un..., l\'autre...',
    ),
    QuestionLecon(
      question: 'Que signifie alii... alii... ?',
      options: ['les uns..., d\'autres...', 'l\'un..., l\'autre...', 'aucun des deux', 'tous ensemble'],
      reponseCorrecte: 'les uns..., d\'autres...',
    ),
    QuestionLecon(
      question: 'Que marque alter alteri adest (« ils s\'aident l\'un l\'autre ») ?',
      options: ['la réciprocité', 'la diversité', 'la comparaison', 'la négation'],
      reponseCorrecte: 'la réciprocité',
    ),
    QuestionLecon(
      question: 'Que marque alii in aliam provinciam discesserunt (« ils partirent dans des provinces différentes ») ?',
      options: ['la diversité', 'la réciprocité', 'l\'identité', 'la négation'],
      reponseCorrecte: 'la diversité',
    ),
    QuestionLecon(
      question: 'Comment traduit-on « autre que » en latin ?',
      options: ['alius atque (ac)', 'alius quam', 'alius quod', 'alius ut'],
      reponseCorrecte: 'alius atque (ac)',
    ),
    QuestionLecon(
      question: 'Que signifie uterque, utraque, utrumque ?',
      options: ['l\'un et l\'autre, tous les deux', 'lequel des deux', 'aucun des deux', 'le même'],
      reponseCorrecte: 'l\'un et l\'autre, tous les deux',
    ),
    QuestionLecon(
      question: 'Que signifie neuter, neutra, neutrum ?',
      options: ['aucun des deux, ni l\'un ni l\'autre', 'tous les deux', 'lequel des deux', 'l\'un des deux'],
      reponseCorrecte: 'aucun des deux, ni l\'un ni l\'autre',
    ),
    QuestionLecon(
      question: 'Comme quel mot se déclinent uter, uterque et neuter ?',
      options: ['alter', 'alius', 'idem', 'ipse'],
      reponseCorrecte: 'alter',
    ),
    ExerciceSaisie(
      question: 'Donne le génitif singulier de uter (« lequel des deux »), aux trois genres.',
      reponsesAcceptees: ['utrius'],
    ),
    ExerciceSaisie(
      question: 'Quel mot latin signifie « lequel des deux ? » ?',
      reponsesAcceptees: ['uter'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['mot', 'sens', 'gén. / dat. sg.'],
        [
          ['alter, a, um', 'l\'un/l\'autre (de deux)', 'alterius / alteri'],
          ['alius, a, ud', 'un autre (de plus de deux)', '(alienus) / alii'],
          ['uter, utra, utrum', 'lequel des deux ?', 'utrius / utri'],
          ['uterque', 'l\'un et l\'autre, tous les deux', 'utriusque / utrique'],
          ['neuter', 'aucun des deux', 'neutrius / neutri'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : L'impératif
// ------------------------------------------------------------

final Lecon _leconImperatif = Lecon(
  id: 'imperatif',
  titre: 'L\'impératif',
  sousTitre: 'Une seule personne : le radical seul au singulier, -te au pluriel',
  icone: Icons.campaign,
  unite: 'Vol. II – Unité 10',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Nostri lege culta magistri carmina ! (Lis les vers soignés de '
      'notre maître !) Me vatem celebrate, [...] mihi dicite laudes ! '
      '(Célébrez-moi comme poète, dites-moi des éloges !) Duc, age, '
      'discipulos ad mea templa tuos ! (Allez, conduis tes disciples à '
      'mes temples !) — d\'après Ovide, Ars amatoria.',
    ),
    _paragrapheExplication(
      'Tempus [...] collige et serva ! (Rassemble le temps et '
      'préserve-le !) Persuade tibi hoc sic esse ! (Persuade-toi qu\'il '
      'en est ainsi !) Fac [...] quod facere te scribis ! (Fais ce que '
      'tu écris faire !) Ama rationem ! (Aime la raison !) — d\'après '
      'Sénèque, Epistulae morales ad Lucilium.',
    ),
    _paragrapheExplication(
      'L\'impératif sert à exprimer l\'ordre. Contrairement au '
      'français, qui connaît trois formes d\'impératif (chante ! '
      'chantons ! chantez !), le latin ne connaît que l\'impératif à la '
      '2e personne (singulier et pluriel).',
    ),
    _titreExplication('La formation'),
    _paragrapheExplication(
      'À la 2e personne du singulier, l\'impératif actif est '
      'simplement constitué du radical du verbe. Mais à la 3e '
      'conjugaison (modèle mittere), à radical consonantique (mitt-), '
      'on trouve pourtant la voyelle -e (mitte), de même qu\'à la 4e '
      'conjugaison (cape). Astuce mnémotechnique : tu enlèves la '
      'terminaison -re (ou -se) de l\'infinitif présent.',
    ),
    _paragrapheExplication(
      'À la 2e personne du pluriel, l\'impératif actif présente la '
      'terminaison -te au lieu de -tis (de l\'indicatif présent).',
    ),
    _tableauColonnes(
      ['infinitif', 'impératif sg.', 'impératif pl.'],
      [
        ['amare', 'ama !', 'amate !'],
        ['monere', 'mone !', 'monete !'],
        ['mittere', 'mitte !', 'mittite !'],
        ['capere', 'cape !', 'capite !'],
        ['audire', 'audi !', 'audite !'],
        ['ire', 'i !', 'ite !'],
        ['redire', 'redi !', 'redite !'],
        ['esse', 'es !', 'este !'],
        ['prodesse', 'prodes !', 'prodeste !'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Cas particuliers : dic, duc, fac, fer'),
    _paragrapheExplication(
      'L\'impératif de dicere, ducere, facere et ferre ne présente pas '
      'de -e final à la 2e personne du singulier ; le pluriel, quant à '
      'lui, est régulier.',
    ),
    _tableauColonnes(
      ['infinitif', 'impératif sg.', 'impératif pl.'],
      [
        ['dicere', 'dic !', 'dicite !'],
        ['ducere', 'duc !', 'ducite !'],
        ['facere', 'fac !', 'facite !'],
        ['ferre', 'fer !', 'ferte !'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Cet impératif sans -e se retrouve dans les composés.\n\n'
      'Ex. : Adduc ! (Apporte !)\n\n'
      'Mais les composés de facere qui ont le radical en -ficere ont un '
      'impératif régulier.\n\n'
      'Ex. : Confice ! (Achève !) Interfice ! (Tue !)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'À combien de personnes le latin connaît-il l\'impératif ?',
      options: [
        'une seule, la 2e personne (singulier et pluriel)',
        'les trois personnes, comme en français',
        'uniquement la 1re personne',
        'uniquement le pluriel',
      ],
      reponseCorrecte: 'une seule, la 2e personne (singulier et pluriel)',
    ),
    QuestionLecon(
      question: 'Comment forme-t-on l\'impératif actif à la 2e personne du singulier, pour la plupart des verbes ?',
      options: [
        'en enlevant -re (ou -se) à l\'infinitif',
        'en ajoutant -e au radical du parfait',
        'avec le radical du parfait + -to',
        'en ajoutant -to à l\'infinitif',
      ],
      reponseCorrecte: 'en enlevant -re (ou -se) à l\'infinitif',
    ),
    QuestionLecon(
      question: 'Quelle terminaison remplace -tis à la 2e personne du pluriel de l\'impératif actif ?',
      options: ['-te', '-ti', '-tum', '-ntur'],
      reponseCorrecte: '-te',
    ),
    QuestionLecon(
      question: 'Quel est l\'impératif singulier de mittere (3e conjugaison, radical consonantique) ?',
      options: ['mitte', 'mitt', 'mittis', 'mittere'],
      reponseCorrecte: 'mitte',
    ),
    QuestionLecon(
      question: 'Quel est l\'impératif singulier de dicere ?',
      options: ['dic', 'dice', 'dici', 'dicere'],
      reponseCorrecte: 'dic',
    ),
    QuestionLecon(
      question: 'Quels quatre verbes ont un impératif singulier sans -e final ?',
      options: [
        'dicere, ducere, facere, ferre',
        'esse, ire, velle, ferre',
        'amare, monere, mittere, audire',
        'capere, audire, esse, ire',
      ],
      reponseCorrecte: 'dicere, ducere, facere, ferre',
    ),
    QuestionLecon(
      question: 'Quel est l\'impératif singulier du composé adducere ?',
      options: ['adduc', 'adduce', 'adducere', 'addic'],
      reponseCorrecte: 'adduc',
    ),
    QuestionLecon(
      question: 'Les composés de facere en -ficere (comme conficere) ont-ils un impératif régulier ou irrégulier ?',
      options: ['régulier (en -e)', 'irrégulier, comme facere', 'ils n\'ont pas d\'impératif', 'cela dépend du sens'],
      reponseCorrecte: 'régulier (en -e)',
    ),
    QuestionLecon(
      question: 'Quel est l\'impératif singulier de esse ?',
      options: ['es', 'sis', 'esto', 'sum'],
      reponseCorrecte: 'es',
    ),
    ExerciceSaisie(
      question: 'Donne l\'impératif pluriel de audire.',
      reponsesAcceptees: ['audite'],
    ),
    ExerciceSaisie(
      question: 'Donne l\'impératif singulier de ferre.',
      reponsesAcceptees: ['fer'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['infinitif', 'impératif sg.', 'impératif pl.'],
        [
          ['amare', 'ama !', 'amate !'],
          ['mittere', 'mitte !', 'mittite !'],
          ['dicere', 'dic !', 'dicite !'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Singulier = radical (infinitif − re/-se), sauf dic, duc, fac, '
        'fer (sans -e). Pluriel = indicatif présent avec -te à la place '
        'de -tis.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Velle, nolle, malle
// ------------------------------------------------------------

final Lecon _leconVelleNolleMalle = Lecon(
  id: 'velle_nolle_malle',
  titre: 'Velle, nolle, malle',
  sousTitre: 'Vouloir, ne pas vouloir, préférer : trois verbes apparentés à mittere',
  icone: Icons.favorite,
  unite: 'Vol. II – Unité 10',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'volo, vis, velle, volui / « vouloir »\n'
      'nolo, non vis, nolle, nolui / « ne pas vouloir »\n'
      'malo, mavis, malle, malui / « préférer, aimer mieux »\n\n'
      'Ces verbes se rattachent à la conjugaison de mitto, mais '
      'présentent des irrégularités à l\'indicatif présent.',
    ),
    _titreExplication('L\'indicatif présent'),
    _tableauColonnes(
      ['pers.', 'velle', 'nolle', 'malle'],
      [
        ['je', 'volo', 'nolo', 'malo'],
        ['tu', 'vis', 'non vis', 'mavis'],
        ['il / elle', 'vult', 'non vult', 'mavult'],
        ['nous', 'volumus', 'nolumus', 'malumus'],
        ['vous', 'vultis', 'non vultis', 'mavultis'],
        ['ils / elles', 'volunt', 'nolunt', 'malunt'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Les autres temps formés sur le radical du présent sont en '
      'principe réguliers ; attention pourtant au verbe velle, qui '
      'présente tantôt le radical vol-, tantôt le radical vel-.',
    ),
    _titreExplication('L\'imparfait, le futur et le subjonctif'),
    _tableauColonnes(
      ['temps', 'velle', 'nolle', 'malle'],
      [
        ['imparfait (je)', 'volebam', 'nolebam', 'malebam'],
        ['futur (je)', 'volam', 'nolam', 'malam'],
        ['subj. présent (je)', 'velim', 'nolim', 'malim'],
        ['subj. imparfait (je)', 'vellem', 'nollem', 'mallem'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Le participe présent est régulier : volens, volentis ; nolens, '
      'nolentis ; malens, malentis.',
    ),
    _titreExplication('Le parfait : régulier'),
    _paragrapheExplication(
      'volui, volueram, voluero... (comme un parfait ordinaire en '
      '-ui). Velle, nolle et malle n\'ont pas de supin, donc pas de '
      'participe ni d\'infinitif futurs.',
    ),
    _titreExplication('L\'expression de la défense : noli, nolite'),
    _paragrapheExplication(
      'Seul nolle présente des formes d\'impératif qui, accompagnées '
      'd\'un infinitif présent, servent à exprimer la défense.\n\n'
      'Défense : noli + infinitif présent ; nolite + infinitif '
      'présent.\n\n'
      'Ex. : Noli istud facere ! (littéralement « ne veuille pas faire '
      'cela » → Ne fais pas cela !) Nolite istud facere ! (« ne '
      'veuillez pas faire cela » → Ne faites pas cela !)',
    ),
    _titreExplication('L\'emploi des verbes de volonté et de savoir'),
    _paragrapheExplication(
      'Volo, nolo et malo, de même que cupio et scio, se construisent '
      'avec l\'ACI si le sujet de la principale est différent du sujet '
      'de la proposition infinitive (sujet 1 ≠ sujet 2) ; avec '
      'l\'infinitif, si les deux verbes ont le même sujet (sujet 1 = '
      'sujet 2).\n\n'
      'Ex. : Volo ut exeas / Volo te exire. (Je veux que tu sortes.) '
      'Volo exire. (Je veux sortir.)',
    ),
    _paragrapheExplication(
      'Le verbe malo (< magis volo, « j\'aime mieux, je préfère ») '
      'peut être suivi d\'une subordonnée de comparaison, introduite '
      'par quam.\n\n'
      'Ex. : Malo abire quam mala verba tua audire. (J\'aime mieux '
      'm\'en aller que d\'écouter tes paroles méchantes.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Que signifie velle ?',
      options: ['vouloir', 'ne pas vouloir', 'préférer', 'pouvoir'],
      reponseCorrecte: 'vouloir',
    ),
    QuestionLecon(
      question: 'Que signifie nolle ?',
      options: ['ne pas vouloir', 'vouloir', 'préférer', 'savoir'],
      reponseCorrecte: 'ne pas vouloir',
    ),
    QuestionLecon(
      question: 'Que signifie malle ?',
      options: ['préférer, aimer mieux', 'vouloir', 'ne pas vouloir', 'oser'],
      reponseCorrecte: 'préférer, aimer mieux',
    ),
    QuestionLecon(
      question: 'Quelle est la 2e personne du singulier de l\'indicatif présent de velle ?',
      options: ['vis', 'volis', 'voles', 'velis'],
      reponseCorrecte: 'vis',
    ),
    QuestionLecon(
      question: 'Quelle est la 3e personne du singulier de l\'indicatif présent de malle ?',
      options: ['mavult', 'malit', 'mavolt', 'malet'],
      reponseCorrecte: 'mavult',
    ),
    QuestionLecon(
      question: 'À quelle conjugaison se rattachent velle, nolle et malle, malgré leurs irrégularités au présent ?',
      options: [
        'celle de mittere (3e conjugaison)',
        'celle de amare (1re conjugaison)',
        'celle de audire (4e conjugaison)',
        'aucune, ce sont des verbes hors conjugaison',
      ],
      reponseCorrecte: 'celle de mittere (3e conjugaison)',
    ),
    QuestionLecon(
      question: 'Pourquoi velle, nolle et malle n\'ont-ils pas de participe futur ni d\'infinitif futur ?',
      options: [
        'parce qu\'ils n\'ont pas de supin',
        'parce qu\'ils n\'ont pas de parfait',
        'parce que ce sont des verbes déponents',
        'parce qu\'ils n\'ont pas d\'indicatif présent',
      ],
      reponseCorrecte: 'parce qu\'ils n\'ont pas de supin',
    ),
    QuestionLecon(
      question: 'Comment exprime-t-on la défense (« ne fais pas... ») avec nolle ?',
      options: ['noli / nolite + infinitif présent', 'ne + impératif', 'non + impératif', 'noli + subjonctif'],
      reponseCorrecte: 'noli / nolite + infinitif présent',
    ),
    QuestionLecon(
      question: 'Quand volo, nolo et malo se construisent-ils avec l\'ACI plutôt qu\'avec l\'infinitif ?',
      options: [
        'quand le sujet de la principale diffère du sujet de l\'infinitive',
        'quand les deux sujets sont identiques',
        'toujours',
        'jamais',
      ],
      reponseCorrecte: 'quand le sujet de la principale diffère du sujet de l\'infinitive',
    ),
    QuestionLecon(
      question: 'Quelle conjonction introduit la subordonnée de comparaison après malo ?',
      options: ['quam', 'ut', 'quod', 'cum'],
      reponseCorrecte: 'quam',
    ),
    ExerciceSaisie(
      question: 'Donne l\'impératif singulier de nolle, utilisé pour exprimer la défense.',
      reponsesAcceptees: ['noli'],
    ),
    ExerciceSaisie(
      question: 'Conjugue malle à la 1re personne du singulier de l\'indicatif présent.',
      reponsesAcceptees: ['malo'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['pers.', 'velle', 'nolle', 'malle'],
        [
          ['je', 'volo', 'nolo', 'malo'],
          ['tu', 'vis', 'non vis', 'mavis'],
          ['il', 'vult', 'non vult', 'mavult'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Irréguliers seulement à l\'indicatif présent. Pas de supin '
        '(donc pas de participe/infinitif futurs). Défense : noli / '
        'nolite + infinitif présent.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : L'ordre et la défense
// ------------------------------------------------------------

final Lecon _leconOrdreDefense = Lecon(
  id: 'ordre_et_defense',
  titre: 'L\'ordre et la défense',
  sousTitre: 'Impératif (2e pers.), subjonctif (1re/3e pers.), et noli + infinitif',
  icone: Icons.block,
  unite: 'Vol. II – Unité 10',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Observe l\'ordre et la défense du verbe ire à toutes les '
      'personnes :',
    ),
    _tableauColonnes(
      ['pers.', 'ordre', 'défense'],
      [
        ['je (rare)', 'eam', 'ne eam'],
        ['tu', 'i', 'noli ire / ne iveris (ieris)'],
        ['il / elle', 'eat', 'ne eat'],
        ['nous', 'eamus', 'ne eamus'],
        ['vous', 'ite', 'nolite ire / ne iveritis (ieritis)'],
        ['ils / elles', 'eant', 'ne eant'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('L\'ordre : impératif à la 2e personne, subjonctif ailleurs'),
    _paragrapheExplication(
      'Pour l\'ordre, contrairement au français, le latin ne connaît '
      'l\'impératif qu\'à la 2e personne (singulier et pluriel). Aux '
      'deux autres personnes, c\'est le subjonctif qui exprime cette '
      'idée de « volition ». À la 1re personne, un « ordre » donné à '
      'soi-même correspond plutôt à une exhortation, une forme qu\'on '
      'retrouve surtout au pluriel.\n\n'
      'Ex. : Domum redeamus ! (Rentrons à la maison !)',
    ),
    _titreExplication('La défense à la 2e personne : noli / nolite + infinitif'),
    _paragrapheExplication(
      'Pour la défense, la 2e personne présente noli / nolite suivi de '
      'l\'infinitif présent. Il s\'agit à l\'origine de l\'expression '
      'polie de la défense.\n\n'
      'Ex. : noli putare... (ne va pas penser...) nolite existimare... '
      '(n\'allez pas croire...)',
    ),
    _paragrapheExplication(
      'À côté de noli / nolite + infinitif présent, le latin classique '
      'utilise ne + subjonctif parfait pour la 2e personne. Ce '
      'subjonctif parfait n\'a pas de notion de temps ou d\'achèvement, '
      'comme à l\'indicatif, mais exprime uniquement l\'action verbale.',
    ),
    _paragrapheExplication(
      'Cet emploi est l\'héritier d\'un ancien mode appelé « optatif » '
      'qui servait à exprimer le souhait. Très présent encore en grec '
      'ancien, il a disparu en latin et on en trouve uniquement des '
      'traces dans des formes comme ne faxis, ne dixis.',
    ),
    _titreExplication('La défense aux 1re et 3e personnes : ne + subjonctif présent'),
    _paragrapheExplication(
      'L\'expression ne + subjonctif présent sert d\'expression de la '
      'défense aux 1re et 3e personnes.',
    ),
    _titreExplication('Des constructions variantes selon les époques'),
    _paragrapheExplication(
      'D\'autres constructions existent, le système ayant évolué au '
      'cours du temps. Retiens les règles ci-dessus, mais ne sois pas '
      'étonné de trouver des variantes, notamment chez des auteurs '
      'tardifs, comme Sénèque, qui emploie parfois ne + subjonctif '
      'présent à la 2e personne.\n\n'
      'Ex. : non rapias hoc nec testeris (ne va pas t\'en saisir ou '
      't\'en prévaloir) — Sénèque, De Beneficiis, 7, 16, 4.',
    ),
    _paragrapheExplication(
      'Ou encore, chez des auteurs préclassiques, comme Plaute, qui '
      'emploie directement ne + impératif.\n\n'
      'Ex. : ne fle (ne pleure pas) — Plaute, Captivi, 139 ; ne time '
      '(n\'aie pas peur) — Plaute, Amphitruo, 674.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'À quelle(s) personne(s) le latin utilise-t-il l\'impératif pour exprimer l\'ordre ?',
      options: [
        'uniquement à la 2e personne (sg. et pl.)',
        'aux trois personnes, comme en français',
        'uniquement à la 1re personne',
        'uniquement à la 3e personne',
      ],
      reponseCorrecte: 'uniquement à la 2e personne (sg. et pl.)',
    ),
    QuestionLecon(
      question: 'Quel mode exprime l\'ordre aux 1re et 3e personnes ?',
      options: ['le subjonctif', 'l\'indicatif', 'l\'infinitif', 'le participe'],
      reponseCorrecte: 'le subjonctif',
    ),
    QuestionLecon(
      question: 'Que signifie l\'exhortation Domum redeamus ! ?',
      options: [
        'Rentrons à la maison !',
        'Rentre à la maison !',
        'Qu\'il rentre à la maison !',
        'Ils rentrent à la maison.',
      ],
      reponseCorrecte: 'Rentrons à la maison !',
    ),
    QuestionLecon(
      question: 'Comment exprime-t-on la défense à la 2e personne, de façon polie ?',
      options: ['noli / nolite + infinitif présent', 'ne + impératif', 'non + impératif', 'noli + subjonctif imparfait'],
      reponseCorrecte: 'noli / nolite + infinitif présent',
    ),
    QuestionLecon(
      question: 'Quelle autre construction classique exprime la défense à la 2e personne ?',
      options: ['ne + subjonctif parfait', 'ne + subjonctif présent', 'ne + indicatif futur', 'ne + infinitif'],
      reponseCorrecte: 'ne + subjonctif parfait',
    ),
    QuestionLecon(
      question: 'Quel mode exprime la défense aux 1re et 3e personnes ?',
      options: ['ne + subjonctif présent', 'ne + subjonctif parfait', 'ne + impératif', 'noli + infinitif'],
      reponseCorrecte: 'ne + subjonctif présent',
    ),
    QuestionLecon(
      question: 'De quel ancien mode grec l\'emploi de ne + subjonctif parfait pour la défense est-il l\'héritier ?',
      options: ['l\'optatif', 'le désidératif', 'le jussif', 'l\'impératif futur'],
      reponseCorrecte: 'l\'optatif',
    ),
    QuestionLecon(
      question: 'Chez quel auteur tardif trouve-t-on parfois ne + subjonctif présent à la 2e personne, en variante ?',
      options: ['Sénèque', 'Ovide', 'Plaute', 'Cicéron'],
      reponseCorrecte: 'Sénèque',
    ),
    QuestionLecon(
      question: 'Chez quel auteur préclassique trouve-t-on la construction directe ne + impératif ?',
      options: ['Plaute', 'Sénèque', 'Ovide', 'Virgile'],
      reponseCorrecte: 'Plaute',
    ),
    ExerciceSaisie(
      question: 'Quel mot latin, suivi d\'un infinitif présent, exprime la défense à la 2e personne du singulier ?',
      reponsesAcceptees: ['noli'],
    ),
    ExerciceSaisie(
      question: 'Quel mot latin exprime la défense à la 2e personne du pluriel (+ infinitif présent) ?',
      reponsesAcceptees: ['nolite'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['pers.', 'ordre', 'défense'],
        [
          ['tu', 'impératif', 'noli + inf. / ne + subj. parfait'],
          ['il / elle', 'subjonctif présent', 'ne + subjonctif présent'],
          ['nous', 'subjonctif présent', 'ne + subjonctif présent'],
          ['vous', 'impératif', 'nolite + inf. / ne + subj. parfait'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les temps du parfait passif, et l'infinitif passif dans l'ACI
// ------------------------------------------------------------

final Lecon _leconTempsParfaitPassif = Lecon(
  id: 'temps_parfait_passif',
  titre: 'Les temps du parfait passif',
  sousTitre: 'Participe parfait + esse, et l\'infinitif passif dans l\'ACI',
  icone: Icons.done_all,
  unite: 'Vol. III – Unité 1',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'amavi (j\'ai aimé) / amatus sum (j\'ai été aimé) — amaverant '
      '(ils avaient aimé) / amati erant (ils avaient été aimés) — '
      'amaverimus (nous aurons aimé) / amati erimus (nous aurons été '
      'aimés).',
    ),
    _titreExplication('La formation'),
    _paragrapheExplication(
      'Le parfait, le plus-que-parfait et le futur antérieur passifs '
      'sont formés du participe parfait et de l\'auxiliaire esse :',
    ),
    _tableauColonnes(
      ['temps', 'formation'],
      [
        ['indicatif parfait passif', 'participe parfait + sum'],
        ['indicatif plus-que-parfait passif', 'participe parfait + eram'],
        ['indicatif futur antérieur passif', 'participe parfait + ero'],
        ['subjonctif parfait passif', 'participe parfait + sim'],
        ['subjonctif plus-que-parfait passif', 'participe parfait + essem'],
        ['infinitif parfait passif', 'participe parfait + esse'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Le participe parfait, comme tout adjectif de la 1re classe, '
      's\'accorde en genre, en nombre et en cas avec le sujet : amatus, '
      'amata, amatum sum ; amati, amatae, amata sumus...',
    ),
    _titreExplication('L\'infinitif passif dans l\'ACI'),
    _paragrapheExplication(
      'Dicit [litteras scribi]. (Il dit que la lettre est écrite. — '
      'rapport de simultanéité.) Dicit [litteras scriptas esse]. (Il '
      'dit que la lettre a été écrite. — rapport d\'antériorité.)',
    ),
    _paragrapheExplication(
      'Dans l\'ACI, l\'infinitif parfait passif exprime l\'antériorité '
      'et le participe parfait se met à l\'accusatif.',
    ),
    _titreExplication('Cas particulier : l\'infinitif futur passif'),
    _paragrapheExplication(
      'Dicit [litteras scriptum iri]. (Il dit que la lettre sera '
      'écrite. — rapport de postériorité.)',
    ),
    _paragrapheExplication(
      'L\'infinitif futur passif est une forme invariable composée du '
      'supin + iri. Dans l\'ACI, l\'infinitif futur passif exprime la '
      'postériorité.\n\n'
      'Bon à savoir : la forme iri correspond à l\'infinitif '
      'impersonnel du verbe ire « aller ».',
    ),
    _titreExplication('Je récapitule'),
    _tableauColonnes(
      ['rapport de temps', 'actif', 'passif'],
      [
        ['antériorité (infinitif parfait)', 'scripsisse', 'scriptum, am, um esse'],
        ['simultanéité (infinitif présent)', 'scribere', 'scribi'],
        ['postériorité (infinitif futur)', 'scripturum, am, um esse', 'scriptum iri (invariable)'],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Comment forme-t-on l\'indicatif parfait passif ?',
      options: [
        'participe parfait + sum',
        'participe parfait + eram',
        'radical du parfait + -eri-',
        'radical de l\'infectum + -ba-',
      ],
      reponseCorrecte: 'participe parfait + sum',
    ),
    QuestionLecon(
      question: 'Comment forme-t-on le subjonctif plus-que-parfait passif ?',
      options: [
        'participe parfait + essem',
        'participe parfait + sim',
        'participe parfait + eram',
        'participe parfait + ero',
      ],
      reponseCorrecte: 'participe parfait + essem',
    ),
    QuestionLecon(
      question: 'Comment forme-t-on l\'infinitif parfait passif ?',
      options: ['participe parfait + esse', 'participe parfait + fuisse', 'supin + iri', 'participe parfait + sim'],
      reponseCorrecte: 'participe parfait + esse',
    ),
    QuestionLecon(
      question: 'Dans l\'ACI, que marque l\'infinitif parfait passif ?',
      options: ['l\'antériorité', 'la simultanéité', 'la postériorité', 'aucun rapport de temps'],
      reponseCorrecte: 'l\'antériorité',
    ),
    QuestionLecon(
      question: 'À quel cas se met le participe parfait dans l\'infinitif parfait passif de l\'ACI ?',
      options: ['l\'accusatif', 'le nominatif', 'l\'ablatif', 'le génitif'],
      reponseCorrecte: 'l\'accusatif',
    ),
    QuestionLecon(
      question: 'Comment se forme l\'infinitif futur passif ?',
      options: ['supin + iri', 'participe futur + esse', 'participe parfait + iri', 'radical + -turum esse'],
      reponseCorrecte: 'supin + iri',
    ),
    QuestionLecon(
      question: 'Dans l\'ACI, que marque l\'infinitif futur passif ?',
      options: ['la postériorité', 'l\'antériorité', 'la simultanéité', 'la cause'],
      reponseCorrecte: 'la postériorité',
    ),
    QuestionLecon(
      question: 'À quel verbe correspond la forme iri de l\'infinitif futur passif ?',
      options: ['l\'infinitif impersonnel de ire', 'l\'infinitif de esse', 'l\'infinitif de ferre', 'aucun verbe, c\'est une particule'],
      reponseCorrecte: 'l\'infinitif impersonnel de ire',
    ),
    QuestionLecon(
      question: 'Quel infinitif passif marque la simultanéité dans l\'ACI ?',
      options: ['l\'infinitif présent passif', 'l\'infinitif parfait passif', 'l\'infinitif futur passif', 'aucun'],
      reponseCorrecte: 'l\'infinitif présent passif',
    ),
    ExerciceSaisie(
      question: 'Donne l\'infinitif parfait passif de scribere (« avoir été écrit »), au masculin singulier.',
      reponsesAcceptees: ['scriptum esse'],
    ),
    ExerciceSaisie(
      question: 'Donne l\'infinitif futur passif (invariable) de scribere.',
      reponsesAcceptees: ['scriptum iri'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['rapport de temps', 'actif', 'passif'],
        [
          ['antériorité', 'scripsisse', 'scriptum esse'],
          ['simultanéité', 'scribere', 'scribi'],
          ['postériorité', 'scripturum esse', 'scriptum iri'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Parfait, plus-que-parfait, futur antérieur passifs = participe '
        'parfait + esse (sum/eram/ero, sim/essem). Infinitif futur '
        'passif = supin + iri, forme invariable.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Fieri
// ------------------------------------------------------------

final Lecon _leconFieri = Lecon(
  id: 'fieri',
  titre: 'Fieri',
  sousTitre: 'Le passif de facere : « être fait », « se produire », « devenir »',
  icone: Icons.change_circle,
  unite: 'Vol. III – Unité 1',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'fio, fis, fieri, factus sum : à la fois des formes actives (fio, '
      'fis) et des formes passives (fieri, factus sum) — et trois sens '
      '« être fait, se faire » (sens passif), « se produire, arriver » '
      'et « devenir » (sens actif).',
    ),
    _paragrapheExplication(
      'Fieri présente un mélange de formes actives (fio, fis) et '
      'passives (fieri, factus sum) ; de même, ses traductions '
      'mélangent des traductions au passif « être fait, se faire » (= '
      'passif de facio) et à l\'actif « arriver, devenir ». Les '
      'particularités de fieri se présentent donc tant au niveau '
      'morphologique que sémantique.',
    ),
    _titreExplication('La morphologie'),
    _paragrapheExplication(
      'Aux temps formés sur le radical du présent (fio, fis, fieri > '
      'radical fi-), fio se conjugue comme audio, à l\'exception de '
      'l\'infinitif présent fieri.',
    ),
    _tableauColonnes(
      ['pers.', 'indicatif présent', 'subjonctif présent'],
      [
        ['je', 'fio', 'fiam'],
        ['tu', 'fis', 'fias'],
        ['il / elle', 'fit', 'fiat'],
        ['nous', 'fimus', 'fiamus'],
        ['vous', 'fitis', 'fiatis'],
        ['ils / elles', 'fiunt', 'fiant'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Infinitif présent : fieri. Indicatif imparfait : fiebam, '
      'fiebas... (sur fi-, comme audiebam). Indicatif futur : fiam, '
      'fies, fiet, fiemus, fietis, fient. Subjonctif imparfait : '
      'fierem, fieres, fieret...',
    ),
    _titreExplication('Le parfait : les formes régulières du passif de facere'),
    _tableauColonnes(
      ['temps', 'forme'],
      [
        ['indicatif parfait passif', 'factus sum'],
        ['subjonctif parfait passif', 'factus, a, um sim'],
        ['indicatif plus-que-parfait passif', 'factus, a, um eram'],
        ['subjonctif plus-que-parfait passif', 'factus, a, um essem'],
        ['indicatif futur antérieur passif', 'factus, a, um ero'],
        ['infinitif parfait passif', 'factum, am, um esse'],
        ['participe parfait passif', 'factus, a, um'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Particularité : fieri ne possède pas de supin, ni de participes '
      'présent et futur.',
    ),
    _titreExplication('Traductions de fio'),
    _paragrapheExplication(
      'Les différents sens de fio se déduisent assez facilement de son '
      'emploi premier, le passif de facio :',
    ),
    _paragrapheExplication(
      '1. fio sert de passif à facio : « être fait, se faire ».\n\n'
      'Ex. : Haec verba fiunt. (Ces paroles sont prononcées.) Fiat lux '
      'et facta est lux. (Que la lumière soit faite et la lumière fut '
      'faite.) In initio erat Verbum [...] et Verbum caro factum est. '
      '(Au commencement était le Verbe [...] et le Verbe s\'est fait '
      'chair.)',
    ),
    _paragrapheExplication(
      '2. Selon le contexte, « être fait » signifie « se produire, '
      'arriver ».\n\n'
      'Ex. : Omni aetate, mala fiunt. (À chaque époque, des maux se '
      'produisent.) Haec fiunt, dum pax paratur. (Ces événements ont '
      'lieu, pendant que la paix est préparée.)',
    ),
    _paragrapheExplication(
      '3. Avec un attribut du sujet, « être fait » signifie « '
      'devenir ».\n\n'
      'Ex. : Marcus Tullius Cicero consul factus est. (Marcus Tullius '
      'Cicéron devint consul.) Nonne Nero in dies saevior fit ? (Néron '
      'ne devient-il pas plus cruel de jour en jour ?) Semper optabam '
      'ut sapientior fierem. (Je souhaitais toujours devenir plus '
      'sage.)',
    ),
    _paragrapheExplication(
      '4. fieri connaît un emploi impersonnel : fit = « il arrive », '
      'que tu trouves dans des expressions comme fit ut + subjonctif '
      '(« il arrive que ») ou ut fit (« comme il arrive »). Attention, '
      'l\'impersonnel est un neutre : au parfait, tu trouves donc '
      'factum est.\n\n'
      'Ex. : Paulisper, dum se uxor — ut fit — comparat, commoratus '
      'est. (Cicéron, Pro Milone, X, 28 : « Il s\'attarda un petit '
      'moment, pendant que sa femme — comme il arrive — se préparait. »)',
    ),
    _titreExplication('Je me souviens : les autres verbes de « il arrive que »'),
    _tableauColonnes(
      ['verbe', 'sens'],
      [
        ['accidit ut', 'il arrive que (événement imprévu, souvent négatif)'],
        ['contingit ut', 'il arrive que (événement le plus souvent heureux)'],
        ['evenit ut', 'il arrive que (événement quelconque)'],
        ['fit ut', 'il arrive que (événement quelconque)'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Le passif des composés de facere'),
    _paragrapheExplication(
      'Curis conficitur. (Elle est accablée de soucis.) Multi milites '
      'interficientur. (De nombreux soldats seront tués.) Numquam homo '
      'bellis adsuefit. (L\'homme ne s\'habituera jamais aux guerres.)',
    ),
    _paragrapheExplication(
      'Les composés en -facere forment leur passif en -fieri (à '
      'quelques exceptions près), les composés en -ficere ont un '
      'passif « régulier ».',
    ),
    _tableauColonnes(
      ['composé en -facere', 'sens', 'exemple'],
      [
        ['adsuefacere / assuefacere → adsuefieri / assuefieri', 'habituer → être habitué', 'Pessimis casibus adsuefit.'],
        ['patefacere → patefieri', 'ouvrir → être ouvert', 'Porta patefit = porta aperitur.'],
      ],
    ),
    const SizedBox(height: 12),
    _tableauColonnes(
      ['composé en -ficere', 'sens'],
      [
        ['efficere', 'achever, réaliser'],
        ['efficere ut + subj.', 'faire en sorte que'],
        ['efficitur ut + subj.', 'il s\'ensuit, il en résulte que'],
        ['conficere', 'achever'],
        ['perficere', 'achever, parfaire'],
        ['interficere', 'tuer'],
        ['proficere', 'avancer'],
        ['reficere', 'refaire, réparer ; se remettre'],
        ['praeficere (+ dat.)', 'mettre à la tête de'],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quels sont les temps primitifs de fieri ?',
      options: ['fio, fis, fieri, factus sum', 'fio, fis, fiere, feci', 'facio, facis, facere, feci, factum', 'fio, fis, fieri, fii'],
      reponseCorrecte: 'fio, fis, fieri, factus sum',
    ),
    QuestionLecon(
      question: 'De quel verbe fieri est-il le passif ?',
      options: ['facere', 'ferre', 'ire', 'esse'],
      reponseCorrecte: 'facere',
    ),
    QuestionLecon(
      question: 'Comme quel verbe se conjugue fio aux temps du présent, à l\'exception de l\'infinitif ?',
      options: ['audio', 'amo', 'mitto', 'capio'],
      reponseCorrecte: 'audio',
    ),
    QuestionLecon(
      question: 'Quel est l\'infinitif présent de fieri ?',
      options: ['fieri', 'fiere', 'fire', 'facier'],
      reponseCorrecte: 'fieri',
    ),
    QuestionLecon(
      question: 'Sur quel modèle les temps du parfait de fieri sont-ils formés ?',
      options: [
        'les formes régulières du passif de facere',
        'les formes régulières du passif de audire',
        'les formes actives de facere',
        'fieri n\'a pas de parfait',
      ],
      reponseCorrecte: 'les formes régulières du passif de facere',
    ),
    QuestionLecon(
      question: 'Que signifie fio quand il sert de passif à facio ?',
      options: ['être fait, se faire', 'se produire', 'devenir', 'faire en sorte que'],
      reponseCorrecte: 'être fait, se faire',
    ),
    QuestionLecon(
      question: 'Que signifie fio avec un attribut du sujet ?',
      options: ['devenir', 'être fait', 'se produire', 'faire'],
      reponseCorrecte: 'devenir',
    ),
    QuestionLecon(
      question: 'Que signifie l\'emploi impersonnel fit ut + subjonctif ?',
      options: ['il arrive que', 'il faut que', 'il est fait que', 'il devient que'],
      reponseCorrecte: 'il arrive que',
    ),
    QuestionLecon(
      question: 'À quel parfait correspond l\'emploi impersonnel de fieri, puisque l\'impersonnel est un neutre ?',
      options: ['factum est', 'factus est', 'facta est', 'fit'],
      reponseCorrecte: 'factum est',
    ),
    QuestionLecon(
      question: 'Que possède fieri, contrairement à la plupart des verbes ?',
      options: [
        'ni supin, ni participes présent et futur',
        'un supin mais pas de participe',
        'deux radicaux du parfait',
        'un impératif irrégulier'
      ],
      reponseCorrecte: 'ni supin, ni participes présent et futur',
    ),
    QuestionLecon(
      question: 'Comment se forme le passif des composés en -facere (comme patefacere) ?',
      options: ['en -fieri', 'régulièrement, comme un verbe en -are', 'ils n\'ont pas de passif', 'en -ficior'],
      reponseCorrecte: 'en -fieri',
    ),
    QuestionLecon(
      question: 'Comment se forme le passif des composés en -ficere (comme conficere) ?',
      options: ['de façon régulière (conficitur...)', 'en -fieri', 'ils n\'ont pas de passif', 'comme fio'],
      reponseCorrecte: 'de façon régulière (conficitur...)',
    ),
    QuestionLecon(
      question: 'Que signifie interficere ?',
      options: ['tuer', 'réparer', 'achever', 'avancer'],
      reponseCorrecte: 'tuer',
    ),
    ExerciceSaisie(
      question: 'Conjugue fio à la 3e personne du singulier de l\'indicatif présent.',
      reponsesAcceptees: ['fit'],
    ),
    ExerciceSaisie(
      question: 'Donne le participe parfait passif de fieri (masculin singulier).',
      reponsesAcceptees: ['factus'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'fio, fis, fieri, factus sum. Présent sur fi- (comme audio, '
        'sauf infinitif fieri). Parfait = formes régulières du passif '
        'de facere (factus sum...). Pas de supin ni de participes '
        'présent/futur.',
      ),
      _tableauColonnes(
        ['sens', 'exemple'],
        [
          ['être fait, se faire', 'Haec verba fiunt.'],
          ['se produire, arriver', 'Haec fiunt.'],
          ['devenir (+ attribut)', 'Consul factus est.'],
          ['il arrive que (fit ut)', 'Fit ut errent.'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Mihi adeste ! — La conjonction dum
// ------------------------------------------------------------

final Lecon _leconConjonctionDum = Lecon(
  id: 'conjonction_dum',
  titre: 'Mihi adeste ! La conjonction dum',
  sousTitre: 'dum + indicatif (réalité) ou + subjonctif (fait envisagé)',
  icone: Icons.hourglass_bottom,
  unite: 'Vol. III – Unité 1',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Tu as déjà appris que la conjonction de subordination dum suivie '
      'de l\'indicatif se traduit par « pendant que » ou « jusqu\'au '
      'moment où ». Tu découvres à présent les autres emplois de cette '
      'conjonction, que tu peux répartir en deux grandes catégories :',
    ),
    _paragrapheExplication(
      'dum + indicatif = réalité présente, passée ou future\n'
      'dum + subjonctif = fait envisagé, hypothétique',
    ),
    _titreExplication('1. dum + indicatif'),
    _paragrapheExplication(
      'Dum haec fiunt, Caesar oppidum cum catervis petivit. (Pendant '
      'que ceci se produisait, César gagna la place forte avec ses '
      'troupes.) Dum fortuna tecum erit / erat, multi amici tibi erunt '
      '/ erant. (Aussi longtemps que la fortune sera / était avec toi, '
      'tu auras / avais de nombreux amis.) Exspectate, dum redibimus. '
      '(Attendez jusqu\'au moment où nous reviendrons !)',
    ),
    _paragrapheExplication(
      'dum + indicatif présent (quel que soit le temps du verbe de la '
      'principale) → pendant que + indicatif (à adapter selon la '
      'concordance des temps en français).\n\n'
      'dum + indicatif (imparfait, plus-que-parfait, futur, futur '
      'antérieur) → aussi longtemps que, tant que + indicatif ; '
      'jusqu\'au moment où + indicatif.',
    ),
    _titreExplication('2. dum + subjonctif'),
    _paragrapheExplication(
      'Exspectate, dum redeamus. (Attendez jusqu\'à ce que nous '
      'revenions !) Oderint, dum metuant. (Qu\'ils haïssent, pourvu '
      'qu\'ils craignent !) Omnia fecit, dum imperium ei esset. (Il fit '
      'tout, pourvu que le pouvoir lui appartînt.) Nihil fecit, dum '
      'amici venirent. (Il ne fit rien, en attendant que ses amis '
      'arrivent.)',
    ),
    _paragrapheExplication(
      'dum + subjonctif → jusqu\'à ce que, en attendant que + '
      'subjonctif ; pourvu que + subjonctif.',
    ),
    _paragrapheExplication(
      'Note bene : dans les textes latins, la conjonction dum est '
      'parfois gravée DVM (le V représentant le U dans l\'écriture '
      'capitale antique) — d\'où le clin d\'œil du titre « Mihi adeste '
      '! » (Soyez attentifs, aidez-moi !).',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Que signifie dum + indicatif présent, quel que soit le temps de la principale ?',
      options: ['pendant que', 'jusqu\'à ce que', 'pourvu que', 'bien que'],
      reponseCorrecte: 'pendant que',
    ),
    QuestionLecon(
      question: 'Que signifie dum + indicatif imparfait, plus-que-parfait, futur ou futur antérieur ?',
      options: [
        'aussi longtemps que / jusqu\'au moment où',
        'pendant que uniquement',
        'jusqu\'à ce que',
        'pourvu que',
      ],
      reponseCorrecte: 'aussi longtemps que / jusqu\'au moment où',
    ),
    QuestionLecon(
      question: 'Que marque dum suivi du subjonctif ?',
      options: ['un fait envisagé, hypothétique', 'une réalité passée', 'une réalité présente', 'une cause certaine'],
      reponseCorrecte: 'un fait envisagé, hypothétique',
    ),
    QuestionLecon(
      question: 'Que peut signifier dum + subjonctif, parmi les traductions suivantes ?',
      options: [
        'jusqu\'à ce que, en attendant que, pourvu que',
        'parce que, puisque',
        'bien que, quoique',
        'si, à condition que'
      ],
      reponseCorrecte: 'jusqu\'à ce que, en attendant que, pourvu que',
    ),
    QuestionLecon(
      question: 'Que signifie Exspectate, dum redeamus ?',
      options: [
        'Attendez jusqu\'à ce que nous revenions !',
        'Attendez pendant que nous revenons !',
        'Attendez, aussi longtemps que nous reviendrons !',
        'Attendez, parce que nous revenons !',
      ],
      reponseCorrecte: 'Attendez jusqu\'à ce que nous revenions !',
    ),
    QuestionLecon(
      question: 'Que signifie la célèbre formule Oderint, dum metuant ?',
      options: [
        'Qu\'ils haïssent, pourvu qu\'ils craignent !',
        'Ils haïssent pendant qu\'ils craignent.',
        'Ils haïront jusqu\'à ce qu\'ils craignent.',
        'Qu\'ils ne haïssent pas, car ils craignent.',
      ],
      reponseCorrecte: 'Qu\'ils haïssent, pourvu qu\'ils craignent !',
    ),
    QuestionLecon(
      question: 'Dum haec fiunt, Caesar oppidum petivit : quel rapport de temps exprime dum ici ?',
      options: ['la simultanéité (pendant que)', 'le but', 'la cause', 'la condition'],
      reponseCorrecte: 'la simultanéité (pendant que)',
    ),
    QuestionLecon(
      question: 'Comment écrivait-on parfois dum sur les inscriptions antiques (capitales) ?',
      options: ['DVM', 'DOM', 'DUN', 'DHM'],
      reponseCorrecte: 'DVM',
    ),
    ExerciceSaisie(
      question: 'Quelle conjonction latine peut signifier « pendant que » ou « jusqu\'à ce que » selon le mode qui suit ?',
      reponsesAcceptees: ['dum'],
    ),
    ExerciceSaisie(
      question: 'Quel mode suit dum quand il exprime un fait hypothétique ou envisagé (« pourvu que », « jusqu\'à ce que ») ?',
      reponsesAcceptees: ['le subjonctif', 'subjonctif'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['dum +', 'sens'],
        [
          ['indicatif présent', 'pendant que'],
          ['indicatif (autres temps)', 'aussi longtemps que, jusqu\'au moment où'],
          ['subjonctif', 'jusqu\'à ce que, en attendant que, pourvu que'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Passifs personnel et impersonnel ; NCI
// ------------------------------------------------------------

final Lecon _leconPassifsPersonnelImpersonnelNCI = Lecon(
  id: 'passifs_personnel_impersonnel_nci',
  titre: 'Passifs personnel et impersonnel ; NCI',
  sousTitre: 'Le passif sans sujet, et le Nominativus cum Infinitivo',
  icone: Icons.forum,
  unite: 'Vol. III – Unité 2',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Avec le passif des temps du parfait, tu as complété tes '
      'connaissances de la morphologie du passif en latin. Tu '
      'apprends maintenant les « cas particuliers », où latin et '
      'français ne fonctionnent pas de la même manière.',
    ),
    _titreExplication('1. Le passif personnel'),
    _paragrapheExplication(
      'Le latin utilise le passif beaucoup plus volontiers que le '
      'français. Il est donc parfois utile de transformer un passif à '
      'l\'actif pour améliorer la traduction.\n\n'
      'Civium virtus a principe laudatur. (La vertu des citoyens est '
      'louée par l\'empereur. → L\'empereur loue la vertu des '
      'citoyens.) Egregia facta a poetis canuntur. (Les hauts faits '
      'sont chantés par les poètes. → Les poètes chantent les hauts '
      'faits.)',
    ),
    _paragrapheExplication(
      'Quand, en latin, la phrase passive n\'a pas de complément '
      'd\'agent, le français traduit le plus souvent en transposant la '
      'phrase à l\'actif et en se servant du sujet « on ».\n\n'
      'Civium virtus laudatur. (La vertu des citoyens est louée. → On '
      'loue la vertu des citoyens.) Egregia facta canuntur. (Les hauts '
      'faits sont chantés. → On chante les hauts faits.)',
    ),
    _paragrapheExplication(
      'Bon à savoir : d\'où vient le pronom « on » ? Le latin ne '
      'connaît pas le pronom indéfini « on », qui, étymologiquement, '
      's\'explique par le nom latin homo (nominatif) → « on », dont '
      'l\'accusatif hominem a donné « homme ».',
    ),
    _paragrapheExplication(
      'Tu peux traduire un passif personnel en gardant le verbe au '
      'passif, ou en le transformant à l\'actif. Pour faire la '
      'transformation active : s\'il y a un complément du passif, '
      'celui-ci devient sujet ; s\'il n\'y a pas de complément du '
      'passif, tu peux utiliser le pronom « on ».',
    ),
    _titreExplication('2. Le passif impersonnel'),
    _paragrapheExplication(
      'Romam itur. Romae manebitur. Pugnatum est. Consuli respondetur.',
    ),
    _paragrapheExplication(
      'En principe, tu as appris que, dans la transformation passive, '
      'le complément du verbe à l\'accusatif devient sujet du verbe au '
      'passif : Princeps virtutem laudat. → Virtus a principe laudatur.',
    ),
    _paragrapheExplication(
      'Or, les verbes ire « aller », manere « rester », pugnare (cum) '
      '« combattre (contre) » ne sont pas suivis d\'un accusatif en '
      'latin, et le verbe respondere « répondre », ici, ne l\'est pas '
      'non plus. En principe, ces verbes ne devraient donc pas être au '
      'passif.',
    ),
    _paragrapheExplication(
      'Or en latin, tous les verbes, même les verbes intransitifs, '
      'peuvent se mettre au passif. Sans accusatif à l\'actif, ces '
      'verbes n\'ont donc pas de sujet au passif : il ne s\'agit plus '
      'd\'un « vrai » passif, mais d\'un passif impersonnel.\n\n'
      'Romam itur. (On va à Rome.) Romae manebitur. (On restera à '
      'Rome.) Pugnatum est. (On combattit.) Consuli respondetur. (On '
      'répond au consul.)',
    ),
    _paragrapheExplication(
      'Employé sans sujet, à la 3e personne du singulier (neutre), le '
      'verbe est au passif impersonnel. Il se traduit par « on ».',
    ),
    _titreExplication('Cas particulier : l\'infinitif impersonnel'),
    _paragrapheExplication(
      'Attention : c\'est l\'infinitif, et non le verbe « pouvoir » '
      'qu\'il faut mettre au passif impersonnel (comparable à '
      'l\'allemand : Es kann gekämpft werden). Avec les verbes suivis '
      'd\'un infinitif, c\'est donc l\'infinitif qui se met au passif '
      'impersonnel, et non le verbe conjugué.\n\n'
      'Ex. : On ne peut pas vaincre. → Vinci non potest.',
    ),
    _paragrapheExplication(
      'Le passif impersonnel produit parfois un effet de style : dans '
      'un récit de bataille confuse (par exemple au siège d\'Alésia, '
      'chez César), un passif impersonnel comme cum pugnaretur (« comme '
      'on combattait ») rend la confusion du combat, où des soldats des '
      'deux camps se mêlent sans qu\'aucun sujet précis ne se dégage.',
    ),
    _titreExplication('Méthode pratique pour le thème'),
    _paragrapheExplication(
      'Une phrase qui présente le pronom impersonnel « on » mérite une '
      'attention particulière. Il faut vérifier si le verbe est suivi '
      'd\'un COD, c\'est-à-dire si le verbe se construit avec un '
      'accusatif en latin.\n\n'
      'On lit beaucoup à l\'école. (pas de COD en français) — On lit '
      'beaucoup de livres à l\'école. (COD : « beaucoup de livres »)',
    ),
    _paragrapheExplication(
      '• Si le verbe présente un COD, le COD devient sujet du verbe '
      'passif : le latin utilise alors un passif personnel avec sujet, '
      'donc le passif « normal » (Multi libri leguntur in scholā.)\n\n'
      '• Si le verbe ne présente pas de COD, le latin utilise le '
      'passif impersonnel, donc le passif sans sujet (Multum legitur in '
      'scholā.)\n\n'
      '• Attention, certains verbes n\'ont pas la même construction en '
      'latin et en français : « Les beaux livres plaisent aux élèves » '
      'n\'a pas de COD en français, mais en latin, delectare se '
      'construit avec l\'accusatif → passif personnel : Discipuli a '
      'libris delectantur.',
    ),
    _titreExplication('3. Nominativus cum infinitivo (NCI)'),
    _paragrapheExplication(
      'Tu viens de voir que pugnatur se traduit par « on combat », '
      'itur « on va », dicitur « on dit ». Or, que se passe-t-il si le '
      'passif impersonnel dicitur est complété par une proposition '
      'infinitive ?',
    ),
    _paragrapheExplication(
      'Pour traduire « On dit que Homère a été aveugle », le latin '
      'évite Dicitur [Homerum caecum fuisse] (un ACI complétant un '
      'passif impersonnel) et dit plutôt : Homerus dicitur caecus '
      'fuisse. (littéralement « Homère est dit avoir été aveugle ».) → '
      'Le sujet de l\'ACI devient sujet du verbe au passif.',
    ),
    _paragrapheExplication(
      'Le latin évite généralement de compléter un verbe au passif '
      'impersonnel par un ACI. Il emploie plutôt une tournure '
      'personnelle avec un sujet : le Nominativus cum Infinitivo (NCI).\n\n'
      'Ex. : Dicitur [Romam perpetuam esse] → Roma dicitur perpetua '
      'esse. (On dit que Rome est éternelle.) Creditur [Cleopatram '
      'Antonium delectavisse] → Cleopatra creditur Antonium '
      'delectavisse. (On croit que Cléopâtre a charmé Antoine.)',
    ),
    _paragrapheExplication(
      'Comme tu as déjà de solides connaissances en anglais, aide-toi '
      'en traduisant en anglais le NCI latin, qui fonctionne de la même '
      'manière : Rome is said to be eternal. Homer is reported to have '
      'been blind. Cleopatra is thought to have seduced Antony.',
    ),
    _titreExplication('Cas particuliers : cogor, jubeor'),
    _paragrapheExplication(
      'Hostes cedere coguntur. Milites arma capere jubentur. Equites '
      'Romani flere vetabantur. Si coguntur se traduit facilement par '
      'un passif en français (« ils sont forcés/obligés/contraints de '
      '»), jubentur et vetabantur posent problème : le français ne peut '
      'pas mettre au passif « ordonner à qqn » ou « interdire à qqn ». '
      'Il faut donc recourir à une tournure impersonnelle : « on '
      'ordonne (de) », « recevoir l\'ordre (de)... », « on interdit à '
      'qqn de ».',
    ),
    _paragrapheExplication(
      'Retiens l\'emploi obligatoire du passif personnel (avec sujet) '
      'avec jubere et cogere : cogor « on me force à, je suis forcé de '
      '» ; jubeor « on m\'ordonne de, je reçois l\'ordre de ». Ces '
      'verbes se construisent donc avec un NCI.',
    ),
    _titreExplication('Je récapitule : la traduction de « on »'),
    _tableauColonnes(
      ['procédé', 'exemple', 'traduction'],
      [
        ['3e pers. du pluriel (+ ACI)', 'dicunt, narrant, ferunt', 'on dit, raconte, rapporte (que)'],
        ['passif impersonnel', 'itur', 'on va'],
        ['passif impersonnel (+ NCI)', 'dicitur', 'on dit (que)'],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Comment peut-on traduire un passif personnel latin sans complément d\'agent ?',
      options: [
        'en le gardant au passif, ou en le transformant à l\'actif avec « on »',
        'uniquement en le gardant au passif',
        'uniquement en le transformant à l\'actif avec un sujet précis',
        'il est impossible de le traduire'
      ],
      reponseCorrecte: 'en le gardant au passif, ou en le transformant à l\'actif avec « on »',
    ),
    QuestionLecon(
      question: 'De quel mot latin le pronom français « on » est-il issu, étymologiquement ?',
      options: ['homo', 'unus', 'aliquis', 'quidam'],
      reponseCorrecte: 'homo',
    ),
    QuestionLecon(
      question: 'Pourquoi des verbes comme ire, manere ou pugnare peuvent-ils être mis au passif en latin, bien qu\'ils soient intransitifs ?',
      options: [
        'tous les verbes latins, même intransitifs, peuvent se mettre au passif',
        'ce sont en réalité des verbes transitifs en latin',
        'ils ne peuvent pas être mis au passif',
        'ils se construisent avec le génitif au passif',
      ],
      reponseCorrecte: 'tous les verbes latins, même intransitifs, peuvent se mettre au passif',
    ),
    QuestionLecon(
      question: 'À quelle personne et quel nombre se met le passif impersonnel ?',
      options: ['3e personne du singulier (neutre)', '3e personne du pluriel', '1re personne du singulier', '2e personne du pluriel'],
      reponseCorrecte: '3e personne du singulier (neutre)',
    ),
    QuestionLecon(
      question: 'Avec un verbe suivi d\'un infinitif (comme « pouvoir »), qu\'est-ce qui se met au passif impersonnel ?',
      options: ['l\'infinitif', 'le verbe conjugué (« pouvoir »)', 'les deux verbes', 'aucun des deux'],
      reponseCorrecte: 'l\'infinitif',
    ),
    QuestionLecon(
      question: 'Si un verbe français a un COD, comment le latin traduit-il « on + verbe + COD » ?',
      options: [
        'par un passif personnel, le COD devenant sujet',
        'par un passif impersonnel',
        'par un ACI',
        'par un NCI'
      ],
      reponseCorrecte: 'par un passif personnel, le COD devenant sujet',
    ),
    QuestionLecon(
      question: 'Que signifie NCI ?',
      options: ['Nominativus cum Infinitivo', 'Nomen cum Infinitivo', 'Nominativus cum Indicativo', 'Nominativus contra Infinitivum'],
      reponseCorrecte: 'Nominativus cum Infinitivo',
    ),
    QuestionLecon(
      question: 'Pourquoi le latin utilise-t-il un NCI plutôt qu\'un ACI après un passif impersonnel comme dicitur ?',
      options: [
        'il évite de faire compléter un passif impersonnel par un ACI',
        'l\'ACI est agrammatical en latin',
        'le NCI est plus court',
        'dicitur ne peut jamais être suivi d\'une proposition'
      ],
      reponseCorrecte: 'il évite de faire compléter un passif impersonnel par un ACI',
    ),
    QuestionLecon(
      question: 'Dans le NCI Homerus dicitur caecus fuisse, quel élément devient sujet du verbe au passif ?',
      options: ['le sujet de l\'infinitive (Homerus)', 'l\'infinitif (fuisse)', 'l\'attribut (caecus)', 'aucun élément ne devient sujet'],
      reponseCorrecte: 'le sujet de l\'infinitive (Homerus)',
    ),
    QuestionLecon(
      question: 'Comment traduit-on jubeor, puisque le français ne peut pas mettre « ordonner à qqn » au passif ?',
      options: [
        'on m\'ordonne de, je reçois l\'ordre de',
        'je suis ordonné de',
        'j\'ordonne à quelqu\'un',
        'on m\'interdit de'
      ],
      reponseCorrecte: 'on m\'ordonne de, je reçois l\'ordre de',
    ),
    ExerciceSaisie(
      question: 'Quel est le passif impersonnel du verbe pugnare, à la 3e personne du singulier de l\'indicatif présent (« on combat ») ?',
      reponsesAcceptees: ['pugnatur'],
    ),
    ExerciceSaisie(
      question: 'Quel verbe latin, avec jubere, se construit obligatoirement avec un NCI (« on me force à ») ?',
      reponsesAcceptees: ['cogor', 'cogere'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Passif impersonnel : sans sujet, 3e pers. sg. neutre (itur, '
        'pugnatur) = « on ». NCI : le sujet d\'un infinitif devient '
        'sujet du verbe au passif (Homerus dicitur caecus fuisse), pour '
        'éviter un ACI après un passif impersonnel.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les indéfinis quidam, aliquis et quis
// ------------------------------------------------------------

final Lecon _leconIndefinisQuidamAliquisQuis = Lecon(
  id: 'indefinis_quidam_aliquis_quis',
  titre: 'Les indéfinis quidam, aliquis et quis',
  sousTitre: '« un certain », « quelqu\'un (inconnu) », et un troisième, plus rare',
  icone: Icons.question_mark,
  unite: 'Vol. III – Unité 2',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Quidam venit. (Quelqu\'un est venu.) Vir quidam, Rufus nomine, '
      'venit. (Un certain homme, du nom de Rufus, est venu.) Aliquis '
      'venit. (Quelqu\'un est venu.) alicui parcere (épargner '
      'quelqu\'un) verba facere de aliqua re (parler de quelque chose)',
    ),
    _paragrapheExplication(
      'Les pronoms indéfinis aliquis et quidam se traduisent en '
      'français par « quelqu\'un », « quelque chose », mais :\n\n'
      '• quidam désigne une personne ou une chose que l\'on pourrait '
      'préciser ;\n'
      '• aliquis a un sens plus indéfini que quidam : il désigne une '
      'personne ou une chose que l\'on ne connaît pas.\n\n'
      'Voilà pourquoi aliquis se prête bien à indiquer la construction '
      'd\'un verbe ou d\'un adjectif dans le dictionnaire.',
    ),
    _paragrapheExplication(
      'Ces pronoms-adjectifs indéfinis se déclinent, à quelques '
      'différences près, comme le pronom interrogatif quis, quae, quid '
      'et l\'adjectif interrogatif qui, quae, quod.',
    ),
    _titreExplication('1. Le pronom-adjectif quidam'),
    _tableauColonnes(
      ['', 'pronom', 'adjectif'],
      [
        ['formes', 'quidam, quaedam, quiddam', 'quidam, quaedam, quoddam'],
        ['sens', '« un certain homme, quelqu\'un, quelque chose »', '« un certain, certaine, un »'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Désigne une personne ou une chose qu\'on pourrait préciser.\n\n'
      'Remarques : la particule -dam est invariable et se soude au '
      'pronom-adjectif (quidam, cujusdam, quibusdam...) ; le -m- peut '
      'se transformer en -n- devant -d- (quorumdam > quorundam).',
    ),
    _paragrapheExplication(
      'Quidam venit. (Quelqu\'un est venu. Un certain homme est venu — '
      'je sais qui, mais il n\'est pas important de le préciser.) Vir '
      'quidam, Rufus nomine, venit. (Un (certain) homme, du nom de '
      'Rufus, est venu — même emploi que l\'article indéfini « un, une '
      '» en français.) furor quidam (une certaine folie, une sorte de '
      'folie)',
    ),
    _titreExplication('2. Le pronom-adjectif aliquis'),
    _tableauColonnes(
      ['', 'pronom', 'adjectif'],
      [
        ['formes', 'aliquis, aliqua, aliquid', 'aliqui(s), aliqua, aliquod'],
        ['sens', '« quelqu\'un, quelque chose »', '« quelque »'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Désigne une personne ou une chose que l\'on ne connaît pas.\n\n'
      'Aliquis venit. (Quelqu\'un est venu — je ne sais pas qui.) '
      'alicui parcere (épargner quelqu\'un) verba facere de aliqua re '
      '(parler de quelque chose)',
    ),
    _paragrapheExplication(
      'Remarques :\n\n'
      '1) Comme aliquis désigne une personne ou une chose qu\'on ne '
      'connaît pas, on emploie le pronom-adjectif pour indiquer la '
      'construction d\'un verbe ou d\'un adjectif : pour « épargner '
      'quelqu\'un », on peut dire parcere + datif, ou parcere alicui.\n\n'
      '2) Au lieu du pluriel de aliquis, on utilise plutôt nonnulli, '
      'ae, a « quelques-uns, quelques ».',
    ),
    _titreExplication('3. Un troisième indéfini, plus rare : quis, qui'),
    _paragrapheExplication(
      'Il existe un troisième pronom-adjectif, quis, quae, quid / qui, '
      'quae, quod, de valeur très indéterminée : « quelqu\'un '
      '(éventuellement), on ». Son emploi est très limité, et on le '
      'trouve uniquement après certains mots.',
    ),
    _paragrapheExplication(
      'On trouve quis, quae, quid / qui, quae, quod :\n\n'
      '• dans des subordonnées de sens hypothétique ou éventuel, après '
      'si, nisi, dum, cum = « quand on » (répétition) ;\n'
      '• dans les défenses. Ex. : Ne quis dicat ! (Qu\'on ne dise pas '
      '!)\n'
      '• après ne final ou complétif. Ex. : Timeo ne quid desit. (Je '
      'crains qu\'il ne manque quelque chose.)\n'
      '• dans les interrogations avec num « est-ce que par hasard », '
      'an, ubi, uter, quando... Ex. : Num quis putavit... ? (Est-ce que '
      'par hasard quelqu\'un a pensé que... ?)',
    ),
    _paragrapheExplication(
      'Pour simplifier, retiens la formule : après si, nisi, ne, num, '
      'cum, dum, le préfixe ali- « tombe ».\n\n'
      'Ex. : Num quis venit ? (Est-ce que quelqu\'un est venu ?) Si '
      'quis adest... (Si quelqu\'un est là...)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quelle différence sépare quidam et aliquis ?',
      options: [
        'quidam désigne une personne qu\'on pourrait préciser, aliquis une personne inconnue',
        'quidam désigne une personne inconnue, aliquis une personne qu\'on pourrait préciser',
        'aucune différence, ce sont des synonymes stricts',
        'quidam ne s\'emploie qu\'au pluriel'
      ],
      reponseCorrecte: 'quidam désigne une personne qu\'on pourrait préciser, aliquis une personne inconnue',
    ),
    QuestionLecon(
      question: 'Comme quels mots quidam et aliquis se déclinent-ils, à quelques différences près ?',
      options: [
        'le pronom et l\'adjectif interrogatifs (quis/qui)',
        'les adjectifs de la 1re classe (bonus, a, um)',
        'nemo et nihil',
        'unus, solus, totus, nullus'
      ],
      reponseCorrecte: 'le pronom et l\'adjectif interrogatifs (quis/qui)',
    ),
    QuestionLecon(
      question: 'Que signifie la particule -dam ajoutée à quidam ?',
      options: [
        'elle est invariable et se soude au pronom-adjectif',
        'elle varie selon le genre',
        'elle indique le pluriel',
        'elle transforme quidam en adverbe'
      ],
      reponseCorrecte: 'elle est invariable et se soude au pronom-adjectif',
    ),
    QuestionLecon(
      question: 'Pourquoi aliquis se prête-t-il bien à indiquer la construction d\'un verbe dans le dictionnaire ?',
      options: [
        'parce qu\'il désigne une personne indéterminée, comme « quelqu\'un » dans une définition',
        'parce qu\'il est toujours au génitif',
        'parce qu\'il n\'a pas de déclinaison',
        'parce que c\'est le seul indéfini du latin'
      ],
      reponseCorrecte: 'parce qu\'il désigne une personne indéterminée, comme « quelqu\'un » dans une définition',
    ),
    QuestionLecon(
      question: 'Que remplace-t-on habituellement au pluriel de aliquis ?',
      options: ['nonnulli, ae, a', 'quidam au pluriel', 'multi, ae, a', 'quis, quae, quid'],
      reponseCorrecte: 'nonnulli, ae, a',
    ),
    QuestionLecon(
      question: 'Après quels mots le préfixe ali- de aliquis « tombe »-t-il, laissant quis, quae, quid ?',
      options: ['si, nisi, ne, num, cum, dum', 'et, sed, aut', 'ut, quod, quia', 'a, ab, de'],
      reponseCorrecte: 'si, nisi, ne, num, cum, dum',
    ),
    QuestionLecon(
      question: 'Que signifie Ne quis dicat ! ?',
      options: ['Qu\'on ne dise pas !', 'Qui a dit cela ?', 'Que quelqu\'un le dise !', 'On ne dit rien.'],
      reponseCorrecte: 'Qu\'on ne dise pas !',
    ),
    QuestionLecon(
      question: 'Que signifie Si quis adest... ?',
      options: ['Si quelqu\'un est là...', 'Si personne n\'est là...', 'Puisque quelqu\'un est là...', 'Bien que quelqu\'un soit là...'],
      reponseCorrecte: 'Si quelqu\'un est là...',
    ),
    ExerciceSaisie(
      question: 'Quel pronom indéfini latin désigne une personne connue mais qu\'on ne précise pas (« un certain ») ?',
      reponsesAcceptees: ['quidam'],
    ),
    ExerciceSaisie(
      question: 'Quel pronom indéfini latin désigne une personne totalement inconnue (« quelqu\'un, on ne sait qui ») ?',
      reponsesAcceptees: ['aliquis'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['mot', 'sens'],
        [
          ['quidam', 'un certain (que l\'on pourrait préciser)'],
          ['aliquis', 'quelqu\'un (que l\'on ne connaît pas)'],
          ['quis / qui (après si, nisi, ne, num, cum, dum)', 'quelqu\'un, on'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Comparaison de deux personnes ou choses
// ------------------------------------------------------------

final Lecon _leconComparaisonDeDeux = Lecon(
  id: 'comparaison_de_deux',
  titre: 'Comparaison de deux personnes ou choses',
  sousTitre: 'Le latin préfère le comparatif là où le français emploie le superlatif',
  icone: Icons.balance,
  unite: 'Vol. III – Unité 2',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Saepe dextra validior manus est. (Souvent, la main droite est '
      'la plus forte.) Caesar eo anno fortior consul erat. (Cette '
      'année-là, César était le consul le plus courageux.)',
    ),
    _paragrapheExplication(
      'En présence de deux éléments, le latin — comme l\'allemand — '
      'utilise le comparatif (comparatif de l\'adjectif + génitif '
      'partitif, ou adjectif et nom accordés), alors que le français '
      'préfère le superlatif.',
    ),
    _paragrapheExplication(
      'validior manuum / validior manus → la plus forte des deux mains '
      '/ la main la plus forte (des deux).\n\n'
      'fortior consulum / fortior consul → le plus courageux des deux '
      'consuls / le consul le plus courageux (des deux).\n\n'
      'majus malorum / majus malum → le plus grand des deux maux / le '
      'plus grand mal (des deux).',
    ),
    _titreExplication('Cas particulier : le pluriel'),
    _paragrapheExplication(
      'De même, au pluriel, le latin utilise plutôt un comparatif là '
      'où le français préfère le superlatif quand il s\'agit de deux '
      'groupes.\n\n'
      'Ex. : Nostri ferociores erant. (Les nôtres étaient les plus '
      'farouches — de deux partis, deux armées, deux camps en présence '
      'l\'un de l\'autre.)',
    ),
    _titreExplication('L\'expression de l\'âge au quotidien et dans l\'armée'),
    _tableauColonnes(
      ['expression', 'sens'],
      [
        ['minor natu', 'le plus jeune (par la naissance) → le cadet (de deux)'],
        ['major natu', 'le plus âgé (par la naissance) → l\'aîné (de deux)'],
        ['junior', 'le plus jeune (de deux)'],
        ['senior', 'le plus âgé (de deux)'],
        ['juniores', 'les plus jeunes (17-45 ans) = l\'armée active'],
        ['seniores', 'les plus âgés (45-60 ans) = la réserve'],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quand deux éléments sont en présence, quel degré de l\'adjectif le latin utilise-t-il ?',
      options: ['le comparatif', 'le superlatif', 'le positif', 'aucun degré particulier'],
      reponseCorrecte: 'le comparatif',
    ),
    QuestionLecon(
      question: 'Quel degré le français préfère-t-il dans le même cas (deux éléments comparés) ?',
      options: ['le superlatif', 'le comparatif', 'le positif', 'l\'adjectif verbal'],
      reponseCorrecte: 'le superlatif',
    ),
    QuestionLecon(
      question: 'Avec quelle autre langue le latin partage-t-il cet usage du comparatif pour deux éléments ?',
      options: ['l\'allemand', 'l\'anglais', 'l\'italien', 'le grec'],
      reponseCorrecte: 'l\'allemand',
    ),
    QuestionLecon(
      question: 'Comment le comparatif latin peut-il se construire avec un second terme ?',
      options: [
        'avec un génitif partitif, ou avec l\'adjectif et le nom accordés',
        'uniquement avec quam',
        'uniquement avec l\'ablatif',
        'il ne peut pas avoir de second terme'
      ],
      reponseCorrecte: 'avec un génitif partitif, ou avec l\'adjectif et le nom accordés',
    ),
    QuestionLecon(
      question: 'Que signifie validior manuum ?',
      options: ['la plus forte des deux mains', 'la main forte', 'plus forte que la main', 'la main la moins forte'],
      reponseCorrecte: 'la plus forte des deux mains',
    ),
    QuestionLecon(
      question: 'Au pluriel, quand le latin emploie-t-il un comparatif là où le français préfère le superlatif ?',
      options: [
        'quand il s\'agit de deux groupes en présence l\'un de l\'autre',
        'toujours, sans exception',
        'jamais au pluriel',
        'seulement pour les adjectifs de couleur'
      ],
      reponseCorrecte: 'quand il s\'agit de deux groupes en présence l\'un de l\'autre',
    ),
    QuestionLecon(
      question: 'Que signifie minor natu ?',
      options: ['le cadet (de deux), le plus jeune par la naissance', 'l\'aîné (de deux)', 'le plus jeune (de l\'armée active)', 'le plus âgé (de la réserve)'],
      reponseCorrecte: 'le cadet (de deux), le plus jeune par la naissance',
    ),
    QuestionLecon(
      question: 'Dans l\'armée romaine, à quoi correspondent les seniores ?',
      options: ['la réserve (45-60 ans)', 'l\'armée active (17-45 ans)', 'les officiers uniquement', 'les nouvelles recrues'],
      reponseCorrecte: 'la réserve (45-60 ans)',
    ),
    ExerciceSaisie(
      question: 'Quel mot latin signifie « l\'aîné (de deux), le plus âgé par la naissance » ?',
      reponsesAcceptees: ['major natu', 'maior natu'],
    ),
    ExerciceSaisie(
      question: 'Quel mot latin désigne les soldats de l\'armée active (17-45 ans, les plus jeunes de deux groupes) ?',
      reponsesAcceptees: ['juniores', 'iuniores'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Pour deux éléments, le latin (comme l\'allemand) emploie le '
        'comparatif là où le français préfère le superlatif : validior '
        'manus, « la main la plus forte (des deux) ».',
      ),
      _tableauColonnes(
        ['deux personnes', 'deux groupes'],
        [
          ['junior / senior', 'juniores / seniores'],
          ['minor natu / major natu', '—'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les verbes déponents
// ------------------------------------------------------------

final Lecon _leconVerbesDeponents = Lecon(
  id: 'verbes_deponents',
  titre: 'Les verbes déponents',
  sousTitre: 'Forme passive, sens actif : miror, vereor, utor, patior, experior',
  icone: Icons.sync_alt,
  unite: 'Vol. III – Unité 3',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'miror, miraris, mirari, miratus sum (admirer, s\'étonner) ; '
      'vereor, vereris, vereri, veritus sum (craindre, respecter) ; '
      'utor, uteris, uti, usus sum + abl. (se servir de, utiliser) ; '
      'patior, pateris, pati, passus sum (supporter, souffrir, '
      'permettre) ; experior, experiris, experiri, expertus sum '
      '(essayer, faire l\'expérience de, éprouver).',
    ),
    _paragrapheExplication(
      'Que constates-tu quant à la forme de ces verbes, et quant à leur '
      'sens ? En observant leurs temps primitifs, combien de modèles de '
      'conjugaison ces verbes suivent-ils ?',
    ),
    _paragrapheExplication('Les verbes déponents sont de forme passive mais de sens actif.'),
    _titreExplication('Bon à savoir : d\'où vient le nom « déponent » ?'),
    _paragrapheExplication(
      'Ces verbes ont été appelés « déponents » par les grammairiens '
      'latins, qui considéraient qu\'ils avaient « déposé » (deponere) '
      ', donc abandonné, le sens passif.',
    ),
    _paragrapheExplication(
      'En réalité, les verbes déponents sont les héritiers d\'un ancien '
      'système verbal indo-européen. L\'indo-européen n\'oppose pas '
      'actif et passif, mais actif et moyen — le passif ne s\'est '
      'développé que plus tard. Le moyen indique que le sujet du verbe '
      'est personnellement intéressé par le développement de '
      'l\'action, qu\'il accomplit pour ainsi dire pour lui-même : une '
      'sorte de voix « égocentrique ».',
    ),
    _paragrapheExplication(
      'Le latin a en principe abandonné cette voix moyenne, sauf pour '
      'les verbes déponents, qui en sont une réminiscence : ces '
      'verbes, par leur sens, dénotent des actions où le sujet est '
      'toujours personnellement impliqué — naître (nascor), mourir '
      '(morior), utiliser (utor), éprouver un sentiment (miror, '
      'vereor, patior)...',
    ),
    _titreExplication('La conjugaison des verbes déponents : 5 modèles'),
    _tableauColonnes(
      ['déponents en', 'modèle', 'se conjuguent comme le passif de'],
      [
        ['-or, -aris, -ari', 'miror, miraris, mirari, miratus sum', 'amare'],
        ['-eor, -eris, -eri', 'vereor, vereris, vereri, veritus sum', 'monere'],
        ['-or, -eris, -i (cons.)', 'utor, uteris, uti, usus sum', 'mittere'],
        ['-ior, -eris, -i (-io)', 'patior, pateris, pati, passus sum', 'capere'],
        ['-ior, -iris, -iri', 'experior, experiris, experiri, expertus sum', 'audire'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Pour conjuguer les verbes déponents aux temps formés sur le '
      'radical du présent, il est donc utile de faire un « détour » '
      'mental par le modèle actif, après avoir repéré le radical des '
      'verbes déponents.\n\n'
      'Ex. : « il craignait » → vereri fonctionne comme le passif de '
      'monere → radical verē-, comme monē- → « il avertissait » = '
      'monebat → « il était averti » = monebatur → « il craignait » = '
      'verebatur.',
    ),
    _paragrapheExplication(
      'Les radicaux des 5 modèles déponents : mirā-, verē-, ut-, '
      'pati-, experī-.\n\n'
      'Pour les autres temps (parfait, plus-que-parfait, futur '
      'antérieur, subjonctifs parfait et plus-que-parfait, infinitif '
      'parfait), sers-toi du parfait passif appris avec les temps '
      'primitifs.\n\n'
      'Ex. : vereor, vereris, vereri, veritus sum → veritus eram, ero, '
      'sim, essem, esse.',
    ),
    _titreExplication('Cas particuliers'),
    _paragrapheExplication(
      '1. Certaines formes n\'existent pas au passif et sont donc '
      'empruntées à l\'actif : le participe présent (mirans, '
      'mirantis, « admirant »), le gérondif (mirandum, « le fait '
      'd\'admirer »), le supin (miratum, « pour admirer »), le '
      'participe futur (miraturus, a, um, « sur le point d\'admirer '
      '») et l\'infinitif futur (miraturum, am, um esse, expression de '
      'la postériorité dans l\'ACI).',
    ),
    _paragrapheExplication(
      '2. Le verbe morior, -eris, mori, mortuus sum « mourir » a un '
      'participe futur irrégulier : moriturus, a, um « destiné à '
      'mourir, sur le point de mourir ».',
    ),
    _paragrapheExplication(
      '3. Attention à la traduction des participes : les verbes '
      'déponents ont toujours un sens actif. Le participe présent '
      '(mirans, « admirant ») garde donc un sens actif, comme pour '
      'tout verbe ; mais le participe « parfait » de forme passive '
      '(miratus, a, um) se traduit lui aussi à l\'actif : « ayant '
      'admiré » (et non « ayant été admiré »).',
    ),
    _paragrapheExplication(
      '4. L\'impératif — rare pour les verbes au passif — est fréquent '
      'pour les verbes déponents. Pour former l\'impératif passif à la '
      '2e personne du singulier, on remplace la terminaison -ris par '
      '-re. L\'impératif passif de la 2e personne du pluriel est '
      'identique à la forme de l\'indicatif présent.\n\n'
      'Ex. : Admire ! = Mirare ! Admirez ! = Miramini !',
    ),
    _paragrapheExplication(
      '5. Le passif du verbe videre peut se traduire littéralement '
      'par le passif de « voir », mais aussi à l\'actif par « sembler, '
      'paraître ». Dans ce cas, videri se construit avec un attribut '
      'du sujet, et peut être accompagné d\'un datif d\'intérêt et '
      'd\'un infinitif.\n\n'
      'Ex. : Quam beata nunc mihi videtur pueritia nostra ! (Combien '
      'heureuse me semble maintenant notre enfance !) Saepe errare '
      'videtur. (Il semble souvent se tromper.)',
    ),
    _paragrapheExplication(
      'De plus, videri connaît un emploi impersonnel à côté de '
      'l\'emploi personnel : Mihi videtur, tibi videtur, ei videtur... '
      '(Il me/te/lui semble (bon)...) Mihi videor, tibi videris, sibi '
      'videtur... (Je m\'imagine, tu t\'imagines, il s\'imagine... — je '
      'crois, tu crois, il croit...)',
    ),
    _paragrapheExplication(
      '6. Certains verbes, appelés semi-déponents, ne sont déponents '
      'qu\'aux temps du parfait.',
    ),
    _tableauColonnes(
      ['verbe', 'sens'],
      [
        ['gaudeo, es, ere, gavisus sum (+ abl.)', 'se réjouir (de)'],
        ['audeo, es, ere, ausus sum (+ inf.)', 'oser'],
        ['soleo, es, ere, solitus sum (+ inf.)', 'avoir l\'habitude (de)'],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Comment définit-on un verbe déponent ?',
      options: ['de forme passive, mais de sens actif', 'de forme active, mais de sens passif', 'sans aucune forme passive ni active', 'toujours impersonnel'],
      reponseCorrecte: 'de forme passive, mais de sens actif',
    ),
    QuestionLecon(
      question: 'D\'où vient le nom « déponent » donné par les grammairiens latins ?',
      options: [
        'du verbe deponere, « déposer », car ces verbes auraient abandonné le sens passif',
        'du nom d\'un grammairien romain',
        'de leur position dans le dictionnaire',
        'du fait qu\'ils n\'ont pas de temps primitifs'
      ],
      reponseCorrecte: 'du verbe deponere, « déposer », car ces verbes auraient abandonné le sens passif',
    ),
    QuestionLecon(
      question: 'À quelle ancienne voix indo-européenne les verbes déponents sont-ils rattachés, selon la linguistique historique ?',
      options: ['la voix moyenne', 'la voix causative', 'l\'optatif', 'le désidératif'],
      reponseCorrecte: 'la voix moyenne',
    ),
    QuestionLecon(
      question: 'Comme le passif de quel verbe se conjugue miror, miraris, mirari ?',
      options: ['amare', 'monere', 'mittere', 'audire'],
      reponseCorrecte: 'amare',
    ),
    QuestionLecon(
      question: 'Comme le passif de quel verbe se conjugue experior, experiris, experiri ?',
      options: ['audire', 'amare', 'monere', 'capere'],
      reponseCorrecte: 'audire',
    ),
    QuestionLecon(
      question: 'Quelles formes des verbes déponents sont empruntées à l\'actif, car elles n\'existent pas au passif ?',
      options: [
        'le participe présent, le gérondif, le supin, le participe futur, l\'infinitif futur',
        'l\'indicatif présent uniquement',
        'le subjonctif présent uniquement',
        'aucune, tout se forme sur le passif'
      ],
      reponseCorrecte: 'le participe présent, le gérondif, le supin, le participe futur, l\'infinitif futur',
    ),
    QuestionLecon(
      question: 'Comment traduit-on le participe « parfait » d\'un verbe déponent, comme miratus, a, um ?',
      options: ['à l\'actif : « ayant admiré »', 'au passif : « ayant été admiré »', 'les deux sont possibles indifféremment', 'il n\'a pas de traduction'],
      reponseCorrecte: 'à l\'actif : « ayant admiré »',
    ),
    QuestionLecon(
      question: 'Comment forme-t-on l\'impératif d\'un verbe déponent à la 2e personne du singulier ?',
      options: ['on remplace -ris par -re', 'on ajoute -e au radical', 'on utilise l\'infinitif tel quel', 'on remplace -ris par -to'],
      reponseCorrecte: 'on remplace -ris par -re',
    ),
    QuestionLecon(
      question: 'Que peut signifier videri, à l\'actif, en plus de « être vu » ?',
      options: ['sembler, paraître', 'devenir', 'craindre', 'oser'],
      reponseCorrecte: 'sembler, paraître',
    ),
    QuestionLecon(
      question: 'Qu\'est-ce qu\'un verbe semi-déponent ?',
      options: [
        'un verbe qui n\'est déponent qu\'aux temps du parfait',
        'un verbe qui n\'est déponent qu\'au présent',
        'un verbe à moitié transitif',
        'un verbe sans infinitif'
      ],
      reponseCorrecte: 'un verbe qui n\'est déponent qu\'aux temps du parfait',
    ),
    QuestionLecon(
      question: 'Lequel de ces verbes est semi-déponent ?',
      options: ['gaudeo, gavisus sum', 'miror, miratus sum', 'utor, usus sum', 'patior, passus sum'],
      reponseCorrecte: 'gaudeo, gavisus sum',
    ),
    ExerciceSaisie(
      question: 'Conjugue utor à la 3e personne du singulier de l\'indicatif présent (il se sert de).',
      reponsesAcceptees: ['utitur'],
    ),
    ExerciceSaisie(
      question: 'Donne l\'impératif singulier du verbe déponent mirari (« admire ! »).',
      reponsesAcceptees: ['mirare'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['modèle déponent', 'comme le passif de'],
        [
          ['miror, -ari', 'amare'],
          ['vereor, -eri', 'monere'],
          ['utor, uti', 'mittere'],
          ['patior, pati', 'capere'],
          ['experior, -iri', 'audire'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Forme passive, sens actif. Participe présent, gérondif, '
        'supin, participe et infinitif futurs = empruntés à l\'actif. '
        'Participe « parfait » = sens actif (miratus, « ayant admiré »).',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les adverbes de manière et quam
// ------------------------------------------------------------

final Lecon _leconAdverbesManiereQuam = Lecon(
  id: 'adverbes_maniere_quam',
  titre: 'Les adverbes de manière et quam',
  sousTitre: 'Formation, comparatif, superlatif, et quam + superlatif « le plus... possible »',
  icone: Icons.speed,
  unite: 'Vol. III – Unité 3',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Nostri primo integris viribus fortiter propugnare... (Au début, '
      'les nôtres s\'opposèrent courageusement...) Subductis navibus '
      'castrisque egregie munitis... (Quand les navires furent à sec '
      'et le camp remarquablement fortifié...) — d\'après César, De '
      'bello Gallico.',
    ),
    _titreExplication('Adjectif ou adverbe ?'),
    _paragrapheExplication(
      'celer est. (il est rapide — adjectif) celeriter currit. (il '
      'court rapidement — adverbe) celerior est quam tu. (il est plus '
      'rapide que toi — adjectif au comparatif) celerius currit quam '
      'tu. (il court plus rapidement que toi — adverbe au comparatif) '
      'celerrimus est. (il est très rapide — adjectif au superlatif) '
      'celerrime currit. (il court très rapidement — adverbe au '
      'superlatif)',
    ),
    _paragrapheExplication(
      'L\'adverbe de manière répond à la question quomodo ? (comment) '
      ': Quomodo currit ? (Comment court-il ?) De même que l\'adjectif, '
      'l\'adverbe connaît un comparatif (« plus, assez, '
      'particulièrement, trop rapidement ») et un superlatif (« très, '
      'le plus rapidement »).',
    ),
    _titreExplication('La formation des adverbes de manière'),
    _paragrapheExplication(
      'On forme les adverbes de manière en ajoutant au radical de '
      'l\'adjectif le suffixe :\n\n'
      '• -e pour les adjectifs de la 1re classe (doctus → docte)\n'
      '• -iter pour les adjectifs de la 2e classe (fortis → fortiter)\n'
      '• -er pour les adjectifs en -ens, -entis de la 2e classe '
      '(prudens → prudenter)',
    ),
    _tableauColonnes(
      ['adjectif', 'radical', 'adverbe'],
      [
        ['doctus, a, um (savant)', 'doct-', 'docte'],
        ['fortis, is, e (courageux)', 'fort-', 'fortiter'],
        ['acer, acris, acre (vif)', 'acr-', 'acriter'],
        ['prudens, entis (prudent)', 'prudent-', 'prudenter'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Exceptions : à bonus, a, um correspond l\'adverbe bene « bien ». '
      'À facilis, is, e correspond facile « facilement » ; à '
      'difficilis, is, e correspond difficulter « difficilement » ; à '
      'audax, acis correspond audacter « hardiment ».',
    ),
    _titreExplication('Le comparatif et le superlatif des adverbes de manière'),
    _paragrapheExplication(
      'Le comparatif de l\'adverbe correspond à l\'accusatif neutre '
      'singulier (en -ius) du comparatif de l\'adjectif correspondant. '
      'Le superlatif correspond à l\'adverbe en -e formé sur le '
      'superlatif de l\'adjectif correspondant.',
    ),
    _tableauColonnes(
      ['adverbe (degré zéro)', 'comparatif', 'superlatif'],
      [
        ['docte (savamment)', 'doctius', 'doctissime'],
        ['fortiter (courageusement)', 'fortius', 'fortissime'],
        ['facile (facilement)', 'facilius', 'facillime'],
        ['bene (bien)', 'melius (mieux)', 'optime'],
        ['male (mal)', 'pejus (plus mal)', 'pessime'],
        ['prope (près)', 'propius', 'proxime'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Il faut donc toujours se référer au comparatif et au superlatif '
      'de l\'adjectif correspondant, surtout s\'ils sont formés '
      'irrégulièrement.',
    ),
    _titreExplication('Bon à savoir : d\'où vient le -ment français ?'),
    _paragrapheExplication(
      'En français, l\'adverbe de manière en -ment provient d\'un '
      'phénomène de grammaticalisation : au lieu de créer l\'adverbe '
      'par un suffixe, comme en latin, on a utilisé l\'ablatif de mens, '
      'mentis (f.), par exemple dulci mente « de manière douce ». Peu à '
      'peu, mente a perdu son sens propre et a été réinterprété comme '
      'suffixe de formation de l\'adverbe : d\'où le suffixe -ment '
      'français, comme dans « doucement ».',
    ),
    _titreExplication('Quelques adverbes de temps et de quantité'),
    _tableauColonnes(
      ['adverbe', 'comparatif', 'superlatif'],
      [
        ['saepe (souvent)', 'saepius', 'saepissime'],
        ['diu (longtemps)', 'diutius', 'diutissime'],
        ['multum (beaucoup)', 'magis (plus)', 'maxime (le plus, surtout)'],
        ['paulum (peu)', 'minus (moins)', 'minime (le moins)'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Quam + superlatif : « le plus... possible »'),
    _paragrapheExplication(
      'Athleta quam celerrime [potest] currit. (L\'athlète court le '
      'plus rapidement possible.) Quam maximum [potuerunt] emporium '
      'effecerunt. (Ils ont construit le plus grand marché possible.) '
      'quam primum (le plus tôt possible) quam plurimis prodesse (être '
      'utile au plus grand nombre possible)',
    ),
    _paragrapheExplication(
      'Quam, employé seul ou avec le verbe posse qui se conjugue, sert '
      'à renforcer le superlatif : quam + superlatif (+ possum, '
      'poteris, potuit...) → « le plus... que je peux (que tu pourras, '
      'qu\'il a pu...) », c\'est-à-dire « le plus possible ».',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'À quelle question répond l\'adverbe de manière ?',
      options: ['quomodo ? (comment ?)', 'ubi ? (où ?)', 'cur ? (pourquoi ?)', 'quando ? (quand ?)'],
      reponseCorrecte: 'quomodo ? (comment ?)',
    ),
    QuestionLecon(
      question: 'Quel suffixe forme l\'adverbe de manière des adjectifs de la 1re classe ?',
      options: ['-e', '-iter', '-er', '-ius'],
      reponseCorrecte: '-e',
    ),
    QuestionLecon(
      question: 'Quel suffixe forme l\'adverbe de manière des adjectifs de la 2e classe (comme fortis) ?',
      options: ['-iter', '-e', '-ius', '-issime'],
      reponseCorrecte: '-iter',
    ),
    QuestionLecon(
      question: 'Quel suffixe forme l\'adverbe des adjectifs en -ens, -entis (comme prudens) ?',
      options: ['-er', '-iter', '-e', '-ius'],
      reponseCorrecte: '-er',
    ),
    QuestionLecon(
      question: 'Quel est l\'adverbe correspondant à bonus, a, um (exception) ?',
      options: ['bene', 'bonе', 'boniter', 'melius'],
      reponseCorrecte: 'bene',
    ),
    QuestionLecon(
      question: 'À quoi correspond le comparatif d\'un adverbe de manière ?',
      options: [
        'à l\'accusatif neutre singulier du comparatif de l\'adjectif correspondant',
        'au nominatif masculin du comparatif de l\'adjectif',
        'à l\'ablatif singulier du superlatif',
        'à une forme totalement indépendante de l\'adjectif'
      ],
      reponseCorrecte: 'à l\'accusatif neutre singulier du comparatif de l\'adjectif correspondant',
    ),
    QuestionLecon(
      question: 'Quel suffixe caractérise le superlatif d\'un adverbe de manière ?',
      options: ['-e (sur le radical du superlatif de l\'adjectif)', '-iter', '-ius', '-issime toujours'],
      reponseCorrecte: '-e (sur le radical du superlatif de l\'adjectif)',
    ),
    QuestionLecon(
      question: 'Que signifie quam + superlatif (éventuellement + possum) ?',
      options: ['le plus... possible', 'aussi... que', 'moins... que', 'si... que'],
      reponseCorrecte: 'le plus... possible',
    ),
    QuestionLecon(
      question: 'Que signifie quam primum ?',
      options: ['le plus tôt possible', 'le premier de tous', 'avant tout', 'dès que possible seulement au passé'],
      reponseCorrecte: 'le plus tôt possible',
    ),
    QuestionLecon(
      question: 'D\'où vient, en français, le suffixe adverbial -ment ?',
      options: [
        'de l\'ablatif du nom latin mens, mentis, réinterprété comme suffixe (grammaticalisation)',
        'du suffixe latin -mentum désignant un instrument',
        'd\'un emprunt direct au grec',
        'du participe présent latin'
      ],
      reponseCorrecte: 'de l\'ablatif du nom latin mens, mentis, réinterprété comme suffixe (grammaticalisation)',
    ),
    ExerciceSaisie(
      question: 'Donne l\'adverbe de manière formé sur fortis, is, e (« courageusement »).',
      reponsesAcceptees: ['fortiter'],
    ),
    ExerciceSaisie(
      question: 'Donne le superlatif de l\'adverbe bene (« bien »).',
      reponsesAcceptees: ['optime'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        '1re classe : radical + -e (docte). 2e classe : radical + -iter '
        '(fortiter), ou + -er si adjectif en -ens/-entis (prudenter). '
        'Comparatif = accusatif neutre sg. du comparatif de l\'adjectif '
        '(doctius). Superlatif = -e sur le superlatif (doctissime). '
        'quam + superlatif (+ possum) = « le plus... possible ».',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les adjectifs rares ou inusités
// ------------------------------------------------------------

final Lecon _leconAdjectifsRaresInusites = Lecon(
  id: 'adjectifs_rares_inusites',
  titre: 'Les adjectifs rares ou inusités',
  sousTitre: 'prior/primus, superior/summus... : comparatifs et superlatifs de position',
  icone: Icons.map,
  unite: 'Vol. III – Unité 3',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Certains comparatifs et superlatifs sont formés à partir '
      'd\'adjectifs rares ou inusités au positif — ils n\'ont pas, ou '
      'presque pas, de forme de base employée telle quelle. Voici '
      'quelques particularités de ces adjectifs.',
    ),
    _paragrapheExplication(
      '• Ils indiquent principalement une position dans l\'espace ou '
      'dans le temps.\n\n'
      'Ex. : postremo anno (l\'année dernière, la dernière année) '
      'ulterius litus (la côte la plus éloignée)',
    ),
    _paragrapheExplication(
      '• Ils sont majoritairement dérivés de prépositions ou '
      'd\'adverbes.\n\n'
      'Ex. : postremus < post (après, derrière) ulterior < ultra (de '
      'l\'autre côté, au-delà)',
    ),
    _paragrapheExplication(
      '• Ils peuvent souvent être mémorisés par couples opposés.\n\n'
      'Ex. : supremus et infimus (le plus haut et le plus bas) '
      'interior et exterior (intérieur et extérieur)',
    ),
    _paragrapheExplication(
      '• Certaines formes (comme posterus, exterus, superus ou '
      'inferus) apparaissent employées dans des expressions '
      'idiomatiques.\n\n'
      'Ex. : superi [dei] (les dieux d\'en haut) postero die (le '
      'lendemain)',
    ),
    _paragrapheExplication(
      '• En plus d\'indiquer la position, le superlatif de ces '
      'adjectifs exprime surtout la partie d\'un élément, pour '
      'laquelle il faudra parfois utiliser un nom en français (le bas, '
      'la fin...). Le contexte de la phrase t\'aidera à choisir la '
      'bonne traduction.\n\n'
      'Ex. : prima fabula → la première légende ou le début de la '
      'légende.',
    ),
    _titreExplication('Je récapitule'),
    _tableauColonnes(
      ['comparatif', 'sens', 'superlatif', 'position / partie'],
      [
        ['prior', 'le premier (de 2), antérieur, précédent', 'primus', 'le premier / le début de'],
        ['posterior', 'le dernier (de 2), postérieur, suivant', 'postremus', 'le dernier / la fin de'],
        ['superior', 'plus haut, supérieur, antérieur', 'supremus / summus', 'le plus haut, suprême / le sommet de'],
        ['inferior', 'plus bas, inférieur', 'infimus / imus', 'le plus bas / le bas de'],
        ['exterior', 'plus en dehors, extérieur', 'extremus', 'le plus éloigné, extrême / l\'extrémité de'],
        ['ulterior', 'plus éloigné', 'ultimus', 'le plus éloigné, extrême / l\'extrémité de'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Des expressions à retenir'),
    _tableauColonnes(
      ['expression', 'sens'],
      [
        ['prima luce', 'au point du jour, à l\'aube'],
        ['prima nocte', 'au début de la nuit, au crépuscule'],
        ['primum agmen', 'la tête de la colonne, l\'avant-garde'],
        ['extremum / novissimum agmen', 'la fin de la colonne, l\'arrière-garde'],
        ['intimae aedes', 'l\'intérieur de la maison'],
        ['summus mons', 'le sommet de la montagne'],
        ['infimus collis', 'le bas de la colline'],
        ['ultima Italia', 'l\'extrémité de l\'Italie'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Les adjectifs medius, a, um et reliquus, a, um'),
    _paragrapheExplication(
      'De même que les superlatifs ci-dessus, les adjectifs de la 1re '
      'classe medius, a, um et reliquus, a, um peuvent exprimer la '
      'position ou la partie.\n\n'
      'medium templum → le temple du milieu / le milieu du temple. '
      'reliquum tempus → le temps qui reste / le reste du temps.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Que désignent principalement les adjectifs comparatifs/superlatifs rares comme prior, superior, exterior ?',
      options: ['une position dans l\'espace ou le temps', 'une couleur', 'une quantité précise', 'un sentiment'],
      reponseCorrecte: 'une position dans l\'espace ou le temps',
    ),
    QuestionLecon(
      question: 'De quoi la plupart de ces adjectifs sont-ils dérivés ?',
      options: ['de prépositions ou d\'adverbes', 'de noms propres', 'de verbes déponents', 'de chiffres'],
      reponseCorrecte: 'de prépositions ou d\'adverbes',
    ),
    QuestionLecon(
      question: 'De quelle préposition/adverbe dérive ulterior ?',
      options: ['ultra (de l\'autre côté, au-delà)', 'ultimus', 'unus', 'sub'],
      reponseCorrecte: 'ultra (de l\'autre côté, au-delà)',
    ),
    QuestionLecon(
      question: 'Que signifie le comparatif prior ?',
      options: ['le premier (de deux), antérieur, précédent', 'le dernier (de deux)', 'le plus haut', 'le plus bas'],
      reponseCorrecte: 'le premier (de deux), antérieur, précédent',
    ),
    QuestionLecon(
      question: 'Quel superlatif correspond au comparatif superior ?',
      options: ['supremus / summus', 'primus', 'ultimus', 'infimus'],
      reponseCorrecte: 'supremus / summus',
    ),
    QuestionLecon(
      question: 'En plus de la position, que peut exprimer le superlatif de ces adjectifs (comme prima fabula) ?',
      options: [
        'la partie d\'un élément, traduisible par un nom (le début, la fin...)',
        'toujours uniquement l\'ordre chronologique',
        'la couleur de l\'objet',
        'rien d\'autre que la position'
      ],
      reponseCorrecte: 'la partie d\'un élément, traduisible par un nom (le début, la fin...)',
    ),
    QuestionLecon(
      question: 'Que signifie l\'expression summus mons ?',
      options: ['le sommet de la montagne', 'la montagne la plus proche', 'le pied de la montagne', 'une petite colline'],
      reponseCorrecte: 'le sommet de la montagne',
    ),
    QuestionLecon(
      question: 'Que signifie primum agmen dans le contexte militaire ?',
      options: ['la tête de la colonne, l\'avant-garde', 'l\'arrière-garde', 'le camp', 'la cavalerie'],
      reponseCorrecte: 'la tête de la colonne, l\'avant-garde',
    ),
    QuestionLecon(
      question: 'Que peut signifier medium templum ?',
      options: ['le milieu du temple / le temple du milieu', 'un grand temple', 'un temple ancien', 'l\'entrée du temple'],
      reponseCorrecte: 'le milieu du temple / le temple du milieu',
    ),
    ExerciceSaisie(
      question: 'Quel superlatif, dérivé de exterior, signifie « le plus éloigné, extrême, l\'extrémité de » ?',
      reponsesAcceptees: ['extremus'],
    ),
    ExerciceSaisie(
      question: 'Quel adjectif de la 1re classe signifie « qui reste » (reliquum tempus, « le reste du temps ») ?',
      reponsesAcceptees: ['reliquus'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['comparatif', 'superlatif', 'partie'],
        [
          ['prior', 'primus', 'le début de'],
          ['posterior', 'postremus', 'la fin de'],
          ['superior', 'summus', 'le sommet de'],
          ['inferior', 'imus', 'le bas de'],
          ['exterior / ulterior', 'extremus / ultimus', 'l\'extrémité de'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les systèmes conditionnels
// ------------------------------------------------------------

final Lecon _leconSystemesConditionnels = Lecon(
  id: 'systemes_conditionnels',
  titre: 'Les systèmes conditionnels',
  sousTitre: 'Réel, potentiel, irréel du présent, irréel du passé : si + indicatif ou subjonctif',
  icone: Icons.fork_right,
  unite: 'Vol. III – Unité 4',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      '« J\'organise un banquet tous les ans, et tous les ans, si tu '
      'assistes au banquet, je suis content » exprime une vérité '
      'générale (réel). « J\'organise un banquet exceptionnel cette '
      'année : si tu assistes au banquet, je serai content » exprime '
      'une condition supposée remplie dans l\'avenir (réel encore). '
      'Mais « si tu assistais au banquet, je serais content » peut '
      'exprimer un possible (potentiel) ou un irréel du présent, et '
      '« si tu avais assisté au banquet, j\'aurais été content » un '
      'irréel du passé.',
    ),
    _titreExplication('Le réel : si (nisi) + indicatif'),
    _paragrapheExplication(
      'Le système conditionnel appelé « réel » exprime une condition '
      'supposée réalisée et se met au mode indicatif. Le présent '
      'exprime une vérité générale, l\'imparfait une répétition, le '
      'futur une condition supposée remplie dans l\'avenir. Attention, '
      'au futur, le latin n\'utilise pas les mêmes temps que le '
      'français.\n\n'
      'Si dei sunt, boni magnique sunt. (Si les dieux existent, ils '
      'sont bons et grands.) Si convivio aderas, laetus eram. (Si — et '
      'chaque fois que — tu assistais à mon banquet, j\'étais content.)',
    ),
    _tableauColonnes(
      ['réel', 'subordonnée (si)', 'principale'],
      [
        ['latin', 'indicatif présent (ou imparfait)', 'indicatif présent (ou imparfait)'],
        ['français', 'indicatif présent (ou imparfait)', 'indicatif présent (ou imparfait)'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Nisi convivio aderis (adfueris), miser ero. (Si tu n\'assistes '
      'pas à mon banquet, je serai malheureux.) Persequar, si potero. '
      '(Je poursuivrai, si je peux.)',
    ),
    _tableauColonnes(
      ['réel (avenir)', 'subordonnée (si)', 'principale'],
      [
        ['latin', 'indicatif futur simple ou futur antérieur', 'indicatif futur simple'],
        ['français', 'indicatif présent', 'indicatif futur simple'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Le potentiel : si (nisi) + subjonctif présent'),
    _paragrapheExplication(
      'Le potentiel exprime un fait possible qui peut se réaliser dans '
      'l\'avenir. La traduction en français est identique à celle de '
      'l\'irréel du présent ; tu peux souligner la nuance du possible '
      'en ajoutant par exemple « un jour ».\n\n'
      'Si convivio adsis, laetus sim. (Si tu assistais — un jour — à '
      'mon banquet, je serais content — il est possible que tu y '
      'assistes un jour.)',
    ),
    _tableauColonnes(
      ['potentiel', 'subordonnée (si)', 'principale'],
      [
        ['latin', 'subjonctif présent', 'subjonctif présent'],
        ['français', 'indicatif imparfait', 'conditionnel présent'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('L\'irréel du présent : si (nisi) + subjonctif imparfait'),
    _paragrapheExplication(
      'L\'irréel du présent exprime une condition non réalisée dans le '
      'présent, contraire à la réalité. Traduction identique à celle '
      'du potentiel ; tu peux souligner la nuance en ajoutant par '
      'exemple « maintenant ».\n\n'
      'Si convivio adesses, laetus essem. (Si tu assistais — maintenant '
      '— à mon banquet, je serais content — mais tu n\'y assistes '
      'pas.)',
    ),
    _tableauColonnes(
      ['irréel du présent', 'subordonnée (si)', 'principale'],
      [
        ['latin', 'subjonctif imparfait', 'subjonctif imparfait'],
        ['français', 'indicatif imparfait', 'conditionnel présent'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Remarque : le français ne distingue donc pas le potentiel et '
      'l\'irréel du présent. En thème, il faudra veiller à bien '
      'comprendre le sens de la phrase et le point de vue envisagé. En '
      'version, il n\'est pas toujours nécessaire d\'ajouter « un jour '
      '» ou « maintenant » : vise une traduction française correcte et '
      'élégante.',
    ),
    _titreExplication('L\'irréel du passé : si (nisi) + subjonctif plus-que-parfait'),
    _paragrapheExplication(
      'L\'irréel du passé exprime une condition non réalisée dans le '
      'passé.\n\n'
      'Si convivio adfuisses, laetus fuissem. (Si tu avais assisté à '
      'mon banquet, j\'aurais été content — mais tu n\'y as pas '
      'assisté.)',
    ),
    _tableauColonnes(
      ['irréel du passé', 'subordonnée (si)', 'principale'],
      [
        ['latin', 'subjonctif plus-que-parfait', 'subjonctif plus-que-parfait'],
        ['français', 'indicatif plus-que-parfait', 'conditionnel passé'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Potentiel et irréel sans subordonnée conditionnelle'),
    _paragrapheExplication(
      'Le subjonctif potentiel ou irréel s\'utilise aussi dans une '
      'proposition indépendante, sans subordonnée en si. Le subjonctif '
      'latin se traduit alors par un conditionnel français : le '
      'subjonctif présent exprime le potentiel (conditionnel présent), '
      'le subjonctif imparfait exprime l\'irréel du présent '
      '(conditionnel présent), le subjonctif plus-que-parfait exprime '
      'l\'irréel du passé (conditionnel passé).\n\n'
      'Ex. : Laetus sim. (Je serais content.) Laetus essem. (Je '
      'serais content — mais je ne le suis pas.) Laetus fuissem. '
      '(J\'aurais été content.)',
    ),
    _paragrapheExplication(
      'Nota bene : il se peut que les systèmes soient « mélangés ». '
      'Ex. : Quod si nostris consiliis usi essemus (irréel du passé) '
      'neque... valuisset sermo..., beatissimi viveremus (irréel du '
      'présent). (Si je m\'étais servi de mes propres conseils et si '
      'le discours de mauvaises fréquentations n\'avait pas eu autant '
      'de valeur, nous vivrions parfaitement heureux — Cicéron, Ad '
      'Familiares, XIV, 1.)',
    ),
    _titreExplication('Autres conjonctions conditionnelles'),
    _paragrapheExplication(
      '1) La négation : variantes. La négation habituelle de si est '
      'nisi « si... ne... pas ». On trouve parfois si non ou ni (rare, '
      'dans des formules toutes faites). Ex. : Ni ita est... (S\'il '
      'n\'en est pas ainsi...) Si debuisset, et petisses statim ; si '
      'non statim, paulo quidem post. (S\'il t\'avait dû de l\'argent, '
      'tu l\'aurais réclamé sur-le-champ ; sinon, du moins peu après.)',
    ),
    _paragrapheExplication(
      '2) La concession. La conjonction si peut s\'associer à une '
      'valeur concessive : etiam si, etsi = « même si ». Ex. : Sapiens, '
      'etiam si contentus est se, amicum habere vult. (Le sage, même '
      's\'il se suffit à lui-même, veut pourtant avoir un ami.)',
    ),
    _paragrapheExplication(
      '3) La comparaison conditionnelle, introduite par ut si, velut '
      'si, tamquam si « comme si ». On y emploie les mêmes modes '
      'qu\'après si, souvent le subjonctif imparfait ou plus-que-'
      'parfait (donc l\'irréel), même si la principale est à '
      'l\'indicatif. Ex. : Absentis Ariovisti crudelitatem, velut si '
      'coram adesset, horremus. (Nous craignons la cruauté d\'Arioviste, '
      'malgré son absence, comme s\'il se trouvait là.)',
    ),
    _paragrapheExplication(
      '4) sive... sive (seu... seu) se construit le plus souvent avec '
      'l\'indicatif, alors qu\'en français « soit que... soit que... » '
      'et « que... ou que... » sont suivis du subjonctif. Ex. : Sive '
      'habes quid, sive nihil habes, scribe tamen aliquid. (Que tu '
      'aies quelque chose à écrire ou que tu n\'aies rien, écris quand '
      'même quelque chose.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quel mode utilise le système « réel » en latin ?',
      options: ['l\'indicatif', 'le subjonctif', 'l\'infinitif', 'le participe'],
      reponseCorrecte: 'l\'indicatif',
    ),
    QuestionLecon(
      question: 'Quelle est la négation habituelle de si ?',
      options: ['nisi', 'non si', 'ne si', 'si ne'],
      reponseCorrecte: 'nisi',
    ),
    QuestionLecon(
      question: 'Quel mode et temps latins expriment le potentiel dans la subordonnée en si ?',
      options: ['le subjonctif présent', 'le subjonctif imparfait', 'l\'indicatif futur', 'le subjonctif plus-que-parfait'],
      reponseCorrecte: 'le subjonctif présent',
    ),
    QuestionLecon(
      question: 'Quel mode et temps latins expriment l\'irréel du présent ?',
      options: ['le subjonctif imparfait', 'le subjonctif présent', 'le subjonctif plus-que-parfait', 'l\'indicatif imparfait'],
      reponseCorrecte: 'le subjonctif imparfait',
    ),
    QuestionLecon(
      question: 'Quel mode et temps latins expriment l\'irréel du passé ?',
      options: ['le subjonctif plus-que-parfait', 'le subjonctif imparfait', 'l\'indicatif plus-que-parfait', 'le subjonctif présent'],
      reponseCorrecte: 'le subjonctif plus-que-parfait',
    ),
    QuestionLecon(
      question: 'Le français distingue-t-il clairement le potentiel et l\'irréel du présent ?',
      options: [
        'non, la traduction française est identique dans les deux cas',
        'oui, par des modes différents',
        'oui, par des temps différents',
        'le français n\'exprime jamais ces nuances'
      ],
      reponseCorrecte: 'non, la traduction française est identique dans les deux cas',
    ),
    QuestionLecon(
      question: 'Comment traduit-on en français un subjonctif potentiel employé dans une proposition indépendante (sans si) ?',
      options: ['par un conditionnel présent', 'par un indicatif présent', 'par un subjonctif français', 'par un infinitif'],
      reponseCorrecte: 'par un conditionnel présent',
    ),
    QuestionLecon(
      question: 'Que signifie etiam si / etsi ?',
      options: ['même si', 'si... ne... pas', 'comme si', 'soit que'],
      reponseCorrecte: 'même si',
    ),
    QuestionLecon(
      question: 'Que signifient ut si, velut si, tamquam si ?',
      options: ['comme si', 'même si', 'si... ne... pas', 'pourvu que'],
      reponseCorrecte: 'comme si',
    ),
    QuestionLecon(
      question: 'Avec quel mode se construit le plus souvent sive... sive (« soit que... soit que ») ?',
      options: ['l\'indicatif', 'le subjonctif', 'l\'infinitif', 'l\'impératif'],
      reponseCorrecte: 'l\'indicatif',
    ),
    ExerciceSaisie(
      question: 'Quelle conjonction latine introduit la comparaison conditionnelle « comme si », composée avec si ?',
      reponsesAcceptees: ['tamquam si', 'velut si', 'ut si'],
    ),
    ExerciceSaisie(
      question: 'Quel mot latin, rare, sert parfois de négation de si à la place de nisi ?',
      reponsesAcceptees: ['ni'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['système', 'si + (latin)', 'traduction française'],
        [
          ['réel', 'indicatif', 'indicatif'],
          ['potentiel', 'subjonctif présent', 'imparfait / conditionnel présent'],
          ['irréel du présent', 'subjonctif imparfait', 'imparfait / conditionnel présent'],
          ['irréel du passé', 'subjonctif plus-que-parfait', 'plus-que-parfait / conditionnel passé'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Le subjonctif dans les propositions principales et indépendantes
// ------------------------------------------------------------

final Lecon _leconSubjonctifPropositionsPrincipales = Lecon(
  id: 'subjonctif_propositions_principales',
  titre: 'Le subjonctif dans les propositions principales et indépendantes',
  sousTitre: 'utinam (souhait, regret) et le subjonctif délibératif',
  icone: Icons.star,
  unite: 'Vol. III – Unité 4',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('Le souhait et le regret'),
    _paragrapheExplication(
      'Utinam beatus sit ! (Puisse-t-il être heureux !) Utinam beata '
      'essem ! (Ah, si seulement j\'étais heureuse !) Utinam beatus '
      'fuisses ! (Ah, si seulement tu avais été heureux !)',
    ),
    _paragrapheExplication(
      'Le subjonctif, généralement précédé de utinam, sert à '
      'exprimer :\n\n'
      '• le souhait (réalisable = potentiel) : subjonctif présent\n'
      '• le regret dans le présent (souhait qu\'on sait irréalisable = '
      'irréel du présent) : subjonctif imparfait\n'
      '• le regret dans le passé (souhait non réalisé dans le passé = '
      'irréel du passé) : subjonctif plus-que-parfait\n\n'
      'La négation est utinam ne.',
    ),
    _paragrapheExplication(
      'Ex. : Utinam P. Clodius non modo viveret, sed etiam praetor, '
      'consul, dictator esset ! (Ah, si seulement Publius Clodius non '
      'seulement était vivant, mais qu\'il fût même préteur, consul, '
      'dictateur !) Utinam illum diem videam ! (Pourvu que je voie ce '
      'jour-là !) Utinam omnes M. Lepidus servare potuisset ! (Ah, si '
      'seulement Marcus Lepidus avait pu les sauver tous !)',
    ),
    _titreExplication('La délibération'),
    _paragrapheExplication(
      'Quo eam ? (Où dois-je aller ? Où puis-je aller ? Où aller ?) '
      'Quo non eam ? (Où ne pas aller ?) Quo irem ? (Où devais-je '
      'aller ? Où pouvais-je aller ? Où aller ?) Quid igitur faciamus ? '
      '(Que faire, donc ?)',
    ),
    _paragrapheExplication(
      'Le subjonctif délibératif indique une question que l\'on se '
      'pose à soi-même sur un parti à prendre. Dans une phrase '
      'interrogative, il sert à se demander à soi-même :\n\n'
      '• ce qu\'on peut ou doit faire → subjonctif présent\n'
      '• ce qu\'on pouvait ou devait faire → subjonctif imparfait',
    ),
    _titreExplication('Je me rappelle : l\'ordre et la défense'),
    _paragrapheExplication(
      'À la 2e personne, pour exprimer l\'ordre, le latin utilise '
      'l\'impératif ; pour exprimer la défense, noli / nolite + '
      'infinitif, ou ne + subjonctif parfait.\n\n'
      'Pour les autres personnes, le latin utilise le subjonctif '
      'présent pour exprimer l\'ordre, et ne + subjonctif présent pour '
      'exprimer la défense.',
    ),
    _titreExplication('Je retiens : les emplois du subjonctif dans les propositions principales ou indépendantes'),
    _tableauColonnes(
      ['emploi', 'exemple', 'sens'],
      [
        ['1) Ordre et défense', 'eat / ne eant', '« qu\'il aille ! » / « qu\'ils n\'aillent pas ! »'],
        ['2) Potentiel et irréel', 'Laetus sim. / essem. / fuissem.', '« je serais content » / « j\'aurais été content »'],
        ['3) Souhait et regret', 'Utinam beatus sit / esset / fuisset !', '« puisse-t-il être ! » / « si seulement il était/avait été ! »'],
        ['4) Délibération', 'Quo eam ? / irem ?', '« où dois-je/puis-je aller ? » / « où devais-je/pouvais-je aller ? »'],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Par quel mot le subjonctif de souhait est-il généralement introduit ?',
      options: ['utinam', 'quam', 'dum', 'ut'],
      reponseCorrecte: 'utinam',
    ),
    QuestionLecon(
      question: 'Quel temps du subjonctif exprime un souhait réalisable (potentiel) après utinam ?',
      options: ['le présent', 'l\'imparfait', 'le plus-que-parfait', 'le parfait'],
      reponseCorrecte: 'le présent',
    ),
    QuestionLecon(
      question: 'Quel temps du subjonctif exprime un regret dans le présent après utinam ?',
      options: ['l\'imparfait', 'le présent', 'le plus-que-parfait', 'le futur'],
      reponseCorrecte: 'l\'imparfait',
    ),
    QuestionLecon(
      question: 'Quel temps du subjonctif exprime un regret dans le passé après utinam ?',
      options: ['le plus-que-parfait', 'l\'imparfait', 'le présent', 'le parfait'],
      reponseCorrecte: 'le plus-que-parfait',
    ),
    QuestionLecon(
      question: 'Quelle est la négation de utinam ?',
      options: ['utinam ne', 'non utinam', 'ne utinam non', 'utinam non'],
      reponseCorrecte: 'utinam ne',
    ),
    QuestionLecon(
      question: 'Qu\'exprime le subjonctif délibératif ?',
      options: [
        'une question que l\'on se pose à soi-même sur un parti à prendre',
        'un ordre donné à autrui',
        'une affirmation certaine',
        'une comparaison'
      ],
      reponseCorrecte: 'une question que l\'on se pose à soi-même sur un parti à prendre',
    ),
    QuestionLecon(
      question: 'Quel temps du subjonctif délibératif exprime « ce qu\'on peut ou doit faire » (présent) ?',
      options: ['le subjonctif présent', 'le subjonctif imparfait', 'le subjonctif parfait', 'le subjonctif plus-que-parfait'],
      reponseCorrecte: 'le subjonctif présent',
    ),
    QuestionLecon(
      question: 'Quel temps du subjonctif délibératif exprime « ce qu\'on pouvait ou devait faire » (passé) ?',
      options: ['le subjonctif imparfait', 'le subjonctif présent', 'le subjonctif parfait', 'l\'indicatif imparfait'],
      reponseCorrecte: 'le subjonctif imparfait',
    ),
    QuestionLecon(
      question: 'Que signifie Quid igitur faciamus ?',
      options: ['Que faire, donc ?', 'Qu\'avons-nous fait ?', 'Que ferons-nous demain ?', 'Pourquoi faisons-nous cela ?'],
      reponseCorrecte: 'Que faire, donc ?',
    ),
    ExerciceSaisie(
      question: 'Quel adverbe latin introduit un souhait, généralement suivi du subjonctif ?',
      reponsesAcceptees: ['utinam'],
    ),
    ExerciceSaisie(
      question: 'Conjugue le verbe esse au subjonctif présent, 3e pers. sg., dans « Utinam beatus ___ ! » (« puisse-t-il être heureux ! »).',
      reponsesAcceptees: ['sit'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['temps du subjonctif', 'après utinam', 'en délibération'],
        [
          ['présent', 'souhait réalisable', 'que faire ? (présent)'],
          ['imparfait', 'regret présent', 'que faire ? (passé)'],
          ['plus-que-parfait', 'regret passé', '—'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Le double datif
// ------------------------------------------------------------

final Lecon _leconDoubleDatif = Lecon(
  id: 'double_datif',
  titre: 'Le double datif',
  sousTitre: 'esse, venire, mittere, dare + datif d\'intérêt + datif de destination',
  icone: Icons.double_arrow,
  unite: 'Vol. III – Unité 4',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Mihi responde ! Tibi nulli amici erunt. Pater non sibi sed '
      'liberis suis laborat. Legati diem concilio constituere debent.',
    ),
    _paragrapheExplication(
      'Tu sais déjà que le datif ne correspond pas seulement au COI '
      'français, mais qu\'il sert aussi de datif possessif, de datif '
      'd\'intérêt ou même de datif de destination (ou de résultat) :\n\n'
      '• datif possessif = exprime l\'appartenance, la propriété (avec '
      'le verbe esse)\n'
      '• datif d\'intérêt = indique pour qui une action est réalisée\n'
      '• datif de destination (ou de résultat) = indique en vue de '
      'quoi, avec quel résultat l\'action est réalisée',
    ),
    _titreExplication('Le double datif'),
    _paragrapheExplication(
      'Certains verbes latins, notamment esse, venire, mittere et '
      'dare, peuvent être construits avec deux compléments au datif :\n\n'
      '• un datif d\'intérêt, indiquant pour qui l\'action est réalisée\n'
      '• un datif de destination, indiquant avec quel résultat '
      'l\'action est réalisée',
    ),
    _paragrapheExplication(
      'Cette construction, appelée double datif, est difficile à '
      'traduire littéralement en français.\n\n'
      'Hoc tibi dolori erit. (littéralement « Ceci sera pour toi objet '
      'de douleur » → il faut reformuler : « Ceci te causera de la '
      'douleur. »)',
    ),
    _paragrapheExplication(
      'Victoria equitum Treverorum gaudio omnibus fuit. (La victoire '
      'des cavaliers trévires causa de la joie à tous.) Cui bono [est] '
      '? (À qui profite le crime ? — littéralement « à qui est-ce un '
      'bien ? »)',
    ),
    _paragrapheExplication(
      'Victoriae putabat esse multa Romam deportare quae ornamento '
      'urbi esse possent. (Il pensait que c\'était le propre de la '
      'victoire d\'emporter à Rome de nombreux objets qui pourraient '
      'être un ornement pour la ville — c\'est-à-dire des objets '
      'susceptibles d\'embellir la ville.) Alexander putabat illorum '
      '[artificum] artem sibi gloriae fore. (Alexandre pensait que '
      'l\'art de ces illustres artistes lui vaudrait de la gloire.)',
    ),
    _titreExplication('Les principales expressions à double datif'),
    _tableauColonnes(
      ['expression latine', 'traduction française'],
      [
        ['esse argumento alicui', 'servir de preuve à quelqu\'un'],
        ['esse auxilio alicui', 'apporter du secours à quelqu\'un'],
        ['esse cordi alicui', 'tenir à cœur, être agréable à quelqu\'un'],
        ['esse curae alicui', 'donner du souci à quelqu\'un'],
        ['esse dolori alicui', 'causer de la douleur à quelqu\'un'],
        ['esse gaudio alicui', 'causer de la joie à quelqu\'un'],
        ['esse impedimento alicui', 'être un obstacle pour quelqu\'un'],
        ['esse odio alicui', 'être un objet de haine pour / être haï de quelqu\'un'],
        ['esse saluti alicui', 'être salutaire pour, sauver quelqu\'un'],
        ['esse usui alicui', 'être utile à quelqu\'un'],
        ['dare (aliquid) crimini alicui', 'accuser quelqu\'un de quelque chose'],
        ['dare (aliquid) dono / muneri alicui', 'faire cadeau à quelqu\'un (de quelque chose)'],
        ['mittere auxilio alicui', 'envoyer au secours de quelqu\'un'],
        ['venire auxilio alicui', 'venir au secours de quelqu\'un'],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quels verbes latins se construisent typiquement avec un double datif ?',
      options: ['esse, venire, mittere, dare', 'amare, monere, mittere, audire', 'ire et ses composés', 'volo, nolo, malo'],
      reponseCorrecte: 'esse, venire, mittere, dare',
    ),
    QuestionLecon(
      question: 'De quels deux datifs le « double datif » est-il composé ?',
      options: [
        'un datif d\'intérêt et un datif de destination',
        'un datif possessif et un datif de lieu',
        'deux datifs d\'intérêt identiques',
        'un datif et un ablatif'
      ],
      reponseCorrecte: 'un datif d\'intérêt et un datif de destination',
    ),
    QuestionLecon(
      question: 'Que traduit habituellement le datif de destination dans un double datif ?',
      options: [
        'le résultat ou l\'effet de l\'action (souvent par un verbe ou un nom en français)',
        'le lieu où se déroule l\'action',
        'le moment de l\'action',
        'l\'agent de l\'action'
      ],
      reponseCorrecte: 'le résultat ou l\'effet de l\'action (souvent par un verbe ou un nom en français)',
    ),
    QuestionLecon(
      question: 'Comment traduit-on Hoc tibi dolori erit ?',
      options: ['Ceci te causera de la douleur.', 'Tu causeras de la douleur à ceci.', 'Ceci est ta douleur.', 'La douleur te sera donnée.'],
      reponseCorrecte: 'Ceci te causera de la douleur.',
    ),
    QuestionLecon(
      question: 'Que signifie l\'expression esse curae alicui ?',
      options: ['donner du souci à quelqu\'un', 'être utile à quelqu\'un', 'causer de la joie à quelqu\'un', 'servir de preuve à quelqu\'un'],
      reponseCorrecte: 'donner du souci à quelqu\'un',
    ),
    QuestionLecon(
      question: 'Que signifie l\'expression esse odio alicui ?',
      options: ['être un objet de haine pour quelqu\'un, être haï de quelqu\'un', 'aimer quelqu\'un', 'craindre quelqu\'un', 'servir de preuve à quelqu\'un'],
      reponseCorrecte: 'être un objet de haine pour quelqu\'un, être haï de quelqu\'un',
    ),
    QuestionLecon(
      question: 'Que signifie littéralement dare (aliquid) crimini alicui ?',
      options: [
        'accuser quelqu\'un de quelque chose (donner qqch. comme accusation à qqn)',
        'faire cadeau de quelque chose à quelqu\'un',
        'envoyer quelque chose au secours de quelqu\'un',
        'être un obstacle pour quelqu\'un'
      ],
      reponseCorrecte: 'accuser quelqu\'un de quelque chose (donner qqch. comme accusation à qqn)',
    ),
    QuestionLecon(
      question: 'Que signifie la formule célèbre Cui bono ?',
      options: ['à qui profite le crime ?', 'quel est le bien suprême ?', 'qui est bon ?', 'pour quel bien ?'],
      reponseCorrecte: 'à qui profite le crime ?',
    ),
    ExerciceSaisie(
      question: 'Quelle expression à double datif signifie « être utile à quelqu\'un » ?',
      reponsesAcceptees: ['esse usui alicui', 'usui alicui'],
    ),
    ExerciceSaisie(
      question: 'Quelle expression à double datif signifie « venir au secours de quelqu\'un » ?',
      reponsesAcceptees: ['venire auxilio alicui', 'auxilio alicui'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'esse/venire/mittere/dare + datif d\'intérêt (pour qui) + datif '
        'de destination (avec quel résultat). Se reformule souvent en '
        'français par un verbe : esse dolori alicui = « causer de la '
        'douleur à quelqu\'un ».',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les subordonnées relatives — notions complémentaires
// ------------------------------------------------------------

final Lecon _leconSubordonneesRelativesComplements = Lecon(
  id: 'subordonnees_relatives_complements',
  titre: 'Les subordonnées relatives : notions complémentaires',
  sousTitre: 'Le subjonctif dans la relative, et l\'attraction de l\'antécédent',
  icone: Icons.call_merge,
  unite: 'Vol. III – Unité 5',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('I. Les subordonnées relatives au subjonctif'),
    _paragrapheExplication(
      'Errat qui putet omnia bona esse. ≠ Errat qui putat omnia bona '
      'esse. Misit legatos qui pacem peterent. ≠ Misit legatos qui '
      'pacem petebant. Tibi adsum qui mihi adsis. ≠ Tibi adsum qui '
      'mihi ades.',
    ),
    _paragrapheExplication(
      'Dans la subordonnée relative latine, le subjonctif sert à '
      'exprimer une nuance :\n\n'
      '• de but\n'
      '• de conséquence\n'
      '• de condition\n'
      '• d\'opposition, de restriction, de concession\n'
      '• de cause',
    ),
    _paragrapheExplication(
      'Misit legatos qui pacem peterent. (= ut... peterent, but : « Il '
      'envoya des ambassadeurs pour demander la paix. ») Cleopatra '
      'forma erat, quae semper ad oculos accideret. (= talis/ea ut... '
      'accideret, conséquence : « Cléopâtre avait une beauté telle '
      'qu\'elle frappait toujours les regards. ») Tibi adsum qui mihi '
      'ades. (= quia/quod mihi ades, cause : « Je t\'assiste parce que '
      'tu m\'assistes. ») Ignovit Augustus qui saevus esse posset. (= '
      'cum posset, quamquam poterat, concession : « Auguste pardonna, '
      'bien qu\'il pût être cruel. ») Errat qui putet omnia bona esse. '
      '(= si quis putet, condition/potentiel : « Il se trompe, celui '
      'qui penserait que tout est bon. »)',
    ),
    _titreExplication('Des tournures pour l\'expression de la conséquence'),
    _tableauColonnes(
      ['tournure', 'sens'],
      [
        ['is... qui + subj.', 'tel... qu\'il, homme à, capable de'],
        ['dignus / indignus qui + subj.', 'digne / indigne de'],
        ['sunt / erant... qui + subj.', 'il y a / avait des gens tels qu\'ils, capables de, pour'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Voici d\'autres expressions à retenir :\n\n'
      'Nihil habeo quod scribam. (Je n\'ai rien à écrire, je n\'ai '
      'aucune raison d\'écrire.) Quis est qui velit... ? (Qui est-ce '
      'qui voudrait... ?) Nemo est qui velit... (Il n\'y a personne '
      'qui veuille...) Quid est quod... (Quelle raison y a-t-il pour '
      'que...) Nihil est quod... (Il n\'y a aucune raison pour que...)',
    ),
    _paragrapheExplication(
      'Si la subordonnée est négative, qui non / quod non peuvent être '
      'remplacés par quin.\n\n'
      'Ex. : Nego ullam picturam fuisse quin inspexerit. (Cicéron, '
      'Oratio in Verrem, II, 4, 1 : « Je dis qu\'il n\'y a eu aucun '
      'tableau qu\'il [= Verrès] n\'ait pas examiné. »)',
    ),
    _titreExplication('II. La subordonnée relative précédant la principale'),
    _paragrapheExplication(
      'Quos in crimen vocasti, nemo eos laudat. (Ceux que tu as '
      'accusés, personne ne les loue → Personne ne loue ceux que tu as '
      'accusés.)',
    ),
    _paragrapheExplication(
      'En latin, il se peut que la subordonnée relative précède la '
      'principale. Le pronom relatif est alors souvent repris par is, '
      'ea, id dans la principale.',
    ),
    _titreExplication('L\'attraction de l\'antécédent dans la relative'),
    _paragrapheExplication(
      'Quos cives in crimen vocasti, nemo eos laudat. (Les citoyens '
      'que tu as accusés, personne ne les loue.)',
    ),
    _paragrapheExplication(
      'Quand la subordonnée relative précède la principale, il arrive '
      'que le nom « antécédent » soit attiré dans la relative. Cet '
      'antécédent se met au même cas que le relatif, qui devient '
      'adjectif relatif. Souvent, le pronom is, ea, id reprend le nom '
      '« antécédent » dans la principale.',
    ),
    _paragrapheExplication(
      'Afin de bien traduire ces propositions, il peut être utile de '
      'restituer « l\'ordre normal », et donc de sortir l\'antécédent '
      'de la relative pour le mettre au cas du is, ea, id (ou d\'un '
      'autre démonstratif) de la principale.\n\n'
      'Quorum sociorum auxilium amiserant, Romani eos jam '
      'desideraverunt.\n'
      '→ Quorum auxilium amiserant, Romani eos socios jam '
      'desideraverunt.\n'
      '→ Romani eos socios, quorum auxilium amiserant, jam '
      'desideraverunt. (Les Romains regrettèrent dès lors ces alliés '
      'dont ils avaient perdu le secours.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Que peut exprimer le subjonctif dans une subordonnée relative latine, en plus de la simple description ?',
      options: [
        'le but, la conséquence, la condition, l\'opposition/concession, la cause',
        'uniquement le temps',
        'uniquement le lieu',
        'rien de particulier, c\'est un usage interchangeable avec l\'indicatif'
      ],
      reponseCorrecte: 'le but, la conséquence, la condition, l\'opposition/concession, la cause',
    ),
    QuestionLecon(
      question: 'Misit legatos qui pacem peterent : quelle nuance exprime le subjonctif peterent ?',
      options: ['le but', 'la cause', 'la concession', 'la condition'],
      reponseCorrecte: 'le but',
    ),
    QuestionLecon(
      question: 'Ignovit Augustus qui saevus esse posset : quelle nuance exprime le subjonctif posset ?',
      options: ['la concession (bien qu\'il pût)', 'le but', 'la conséquence', 'la condition'],
      reponseCorrecte: 'la concession (bien qu\'il pût)',
    ),
    QuestionLecon(
      question: 'Que signifie la tournure dignus qui + subjonctif ?',
      options: ['digne de', 'indigne de', 'capable de', 'incapable de'],
      reponseCorrecte: 'digne de',
    ),
    QuestionLecon(
      question: 'Que signifie Nihil habeo quod scribam ?',
      options: [
        'Je n\'ai rien à écrire / aucune raison d\'écrire.',
        'Je n\'ai rien écrit.',
        'Je n\'écris jamais.',
        'J\'ai beaucoup à écrire.'
      ],
      reponseCorrecte: 'Je n\'ai rien à écrire / aucune raison d\'écrire.',
    ),
    QuestionLecon(
      question: 'Par quel mot qui non / quod non peuvent-ils être remplacés dans une relative négative ?',
      options: ['quin', 'nec', 'neque', 'ne'],
      reponseCorrecte: 'quin',
    ),
    QuestionLecon(
      question: 'Que se passe-t-il souvent en latin quand une subordonnée relative précède sa principale ?',
      options: [
        'le pronom relatif est repris par is, ea, id dans la principale',
        'la principale disparaît',
        'le verbe de la relative passe à l\'indicatif',
        'rien de particulier'
      ],
      reponseCorrecte: 'le pronom relatif est repris par is, ea, id dans la principale',
    ),
    QuestionLecon(
      question: 'Qu\'est-ce que l\'« attraction de l\'antécédent » dans une relative qui précède la principale ?',
      options: [
        'l\'antécédent est attiré dans la relative et prend le cas du relatif',
        'l\'antécédent disparaît complètement',
        'le relatif prend le cas de l\'antécédent',
        'l\'antécédent devient un adverbe'
      ],
      reponseCorrecte: 'l\'antécédent est attiré dans la relative et prend le cas du relatif',
    ),
    QuestionLecon(
      question: 'Dans Quorum sociorum auxilium amiserant, Romani eos jam desideraverunt, quel est l\'antécédent attiré dans la relative ?',
      options: ['sociorum', 'Romani', 'auxilium', 'eos'],
      reponseCorrecte: 'sociorum',
    ),
    ExerciceSaisie(
      question: 'Quel pronom remplace souvent qui non / quod non dans une subordonnée relative négative ?',
      reponsesAcceptees: ['quin'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['nuance du subjonctif relatif', 'exemple'],
        [
          ['but', 'misit qui peterent'],
          ['conséquence', 'talis... quae accideret'],
          ['cause', 'qui mihi ades'],
          ['concession', 'qui saevus esse posset'],
          ['condition', 'errat qui putet'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Relative avant la principale : reprise par is, ea, id. '
        'L\'antécédent peut être attiré dans la relative et prendre le '
        'cas du relatif.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les compléments de provenance, de séparation et de qualité
// ------------------------------------------------------------

final Lecon _leconComplementsProvenanceSeparationQualite = Lecon(
  id: 'complements_provenance_separation_qualite',
  titre: 'Les compléments de provenance, de séparation et de qualité',
  sousTitre: 'a(b)/e(x) + abl. pour provenir ou se séparer ; génitif/ablatif pour la qualité',
  icone: Icons.label,
  unite: 'Vol. III – Unité 5',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('La provenance et la séparation'),
    _paragrapheExplication(
      'a Venere se liberare (s\'affranchir de Vénus) Sic a summis '
      'hominibus accepimus, poetam natura ipsa valere. (Nous avons '
      'appris des hommes les plus éminents que le poète vaut par sa '
      'seule nature.) Gallos ab Aquitanis Garumna flumen, a Belgis '
      'Matrona et Sequana dividit. (La Garonne sépare les Gaulois des '
      'Aquitains, la Seine et la Marne les séparent des Belges.) a '
      'quartana liberatus (délivré de la fièvre quarte)',
    ),
    _tableauColonnes(
      ['', 'complément de provenance', 'complément de séparation'],
      [
        ['construction', 'a(b) ou e(x) + abl.', 'a(b) + abl. (personne) ou abl. seul (chose)'],
        [
          'verbes complétés',
          'exprimant la provenance (accipere, audire, petere, quaerere)',
          'exprimant la séparation de deux choses ou personnes (liberare, dividere, prohibere)',
        ],
        ['traduction', 'de qqn/qqch., de la part de qqn/qqch.', 'de qqn/qqch.'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'prohibeo, es, ere, -hibui, -hibitum (a(b) + abl.) « tenir loin '
      '(de), écarter (de) » — ANGL. prohibition.',
    ),
    _titreExplication('La qualité'),
    _paragrapheExplication(
      'Nero fuit valetudine prospera. (Néron fut d\'une santé très '
      'solide.) Iste novo quodam genere imperator pulcherrimo '
      'Syracusarum loco stativa sibi castra faciebat. (Ce général '
      'd\'un nouveau genre s\'établissait des quartiers fixes au plus '
      'bel endroit de Syracuse.) [Ali]qui numquam aegro corpore '
      'fuerunt. (Quelques hommes n\'eurent jamais un corps malade.) '
      'Vir magni ingenii summaque prudentia. (Un homme d\'une grande '
      'intelligence, et d\'une très grande sagesse.)',
    ),
    _paragrapheExplication(
      'Le complément de qualité :\n\n'
      '• est constitué d\'un nom et d\'un adjectif déclinés au génitif '
      'ou à l\'ablatif ;\n'
      '• exprime la qualité d\'une personne ou d\'une chose ;\n'
      '• occupe la fonction de complément du nom ou d\'attribut du '
      'sujet.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Avec quelle(s) préposition(s) + cas se construit le complément de provenance ?',
      options: ['a(b) ou e(x) + ablatif', 'in + accusatif', 'ad + accusatif', 'cum + ablatif'],
      reponseCorrecte: 'a(b) ou e(x) + ablatif',
    ),
    QuestionLecon(
      question: 'Quels verbes le complément de provenance complète-t-il typiquement ?',
      options: ['accipere, audire, petere, quaerere', 'amare, monere, mittere', 'esse, ire, ferre', 'volo, nolo, malo'],
      reponseCorrecte: 'accipere, audire, petere, quaerere',
    ),
    QuestionLecon(
      question: 'Avec quel cas se construit le complément de séparation, pour une chose ?',
      options: ['l\'ablatif seul', 'l\'accusatif', 'le génitif', 'le datif'],
      reponseCorrecte: 'l\'ablatif seul',
    ),
    QuestionLecon(
      question: 'Avec quelle construction se met le complément de séparation, pour une personne ?',
      options: ['a(b) + ablatif', 'ablatif seul', 'ad + accusatif', 'de + ablatif'],
      reponseCorrecte: 'a(b) + ablatif',
    ),
    QuestionLecon(
      question: 'Quels verbes le complément de séparation complète-t-il typiquement ?',
      options: ['liberare, dividere, prohibere', 'accipere, audire, petere', 'dare, mittere, ferre', 'esse, fieri'],
      reponseCorrecte: 'liberare, dividere, prohibere',
    ),
    QuestionLecon(
      question: 'Que signifie prohibere (a(b) + abl.) ?',
      options: ['tenir loin de, écarter de', 's\'affranchir de', 'demander de', 'recevoir de'],
      reponseCorrecte: 'tenir loin de, écarter de',
    ),
    QuestionLecon(
      question: 'À quel(s) cas se met le complément de qualité ?',
      options: ['au génitif ou à l\'ablatif', 'à l\'accusatif uniquement', 'au datif uniquement', 'au nominatif uniquement'],
      reponseCorrecte: 'au génitif ou à l\'ablatif',
    ),
    QuestionLecon(
      question: 'De quels éléments le complément de qualité est-il constitué ?',
      options: ['un nom et un adjectif accordés', 'un verbe et un adverbe', 'deux noms coordonnés', 'un pronom seul'],
      reponseCorrecte: 'un nom et un adjectif accordés',
    ),
    QuestionLecon(
      question: 'Quelle(s) fonction(s) le complément de qualité peut-il occuper ?',
      options: ['complément du nom ou attribut du sujet', 'uniquement sujet', 'uniquement COD', 'uniquement complément circonstanciel de lieu'],
      reponseCorrecte: 'complément du nom ou attribut du sujet',
    ),
    ExerciceSaisie(
      question: 'Quelle préposition + ablatif introduit typiquement le complément de provenance ou de séparation ?',
      reponsesAcceptees: ['a', 'ab', 'a(b)'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['complément', 'construction', 'traduction'],
        [
          ['provenance', 'a(b)/e(x) + abl.', 'de qqn/qqch.'],
          ['séparation', 'a(b) + abl. (pers.) / abl. (chose)', 'de qqn/qqch.'],
          ['qualité', 'nom + adjectif au gén. ou à l\'abl.', 'd\'une qualité X'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Le gérondif, ou « la déclinaison du verbe »
// ------------------------------------------------------------

final Lecon _leconGerondif = Lecon(
  id: 'gerondif',
  titre: 'Le gérondif',
  sousTitre: '« La déclinaison du verbe » : radical du présent + -nd- + terminaisons neutres',
  icone: Icons.import_contacts,
  unite: 'Vol. III – Unité 6',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Errare humanum est. (Se tromper est humain — sujet.) Nihil '
      'agere non est vivere. (Ne rien faire, ce n\'est pas vivre — '
      'attribut du sujet.) Exire volo. (Je veux sortir — COD.)',
    ),
    _paragrapheExplication(
      'L\'infinitif peut se substituer à un groupe nominal dans ces '
      'fonctions. Or, cette « déclinaison » du verbe est incomplète : '
      'l\'infinitif n\'a ni génitif, ni datif, ni ablatif, ni '
      'd\'accusatif après une préposition. Pour la compléter, le latin '
      'utilise le gérondif.\n\n'
      'Abiit ad cogitandum. (Il s\'est éloigné pour réfléchir — '
      'accusatif.) Nunc est tempus bibendi. (C\'est maintenant le '
      'moment de boire ! — génitif.) Legendo doctior fies. (C\'est en '
      'lisant que tu deviendras plus savant — ablatif.)',
    ),
    _paragrapheExplication(
      'Tu peux ainsi comparer une expression comme cupiditas vincendi '
      'à cupiditas victoriae : « le désir de vaincre » = « le désir de '
      'la victoire ».',
    ),
    _titreExplication('La morphologie'),
    _paragrapheExplication(
      'radical du présent + (e) + suffixe -nd- + terminaisons des mots '
      'neutres de la 2e déclinaison : -um, -i, -o, -o.',
    ),
    _tableauColonnes(
      ['infinitif', 'accusatif du gérondif'],
      [
        ['amare', '(ad) amandum'],
        ['monere', '(ad) monendum'],
        ['mittere', '(ad) mittendum'],
        ['capere', '(ad) capiendum'],
        ['audire', '(ad) audiendum'],
        ['mirari (déponent)', '(ad) mirandum'],
        ['ferre', '(ad) ferendum'],
        ['ire', '(ad) eundum'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Les verbes déponents empruntent à l\'actif les formes qui '
      'n\'existent pas au passif : participe présent (mirans, antis, '
      '« admirant »), gérondif ((ad) mirandum, « pour admirer »), '
      'supin (miratum, « pour admirer », après un verbe de mouvement), '
      'participe futur (miraturus, a, um, « sur le point d\'admirer »).',
    ),
    _titreExplication('Le tableau de déclinaison'),
    _paragrapheExplication(
      'Le gérondif est décliné comme un substantif de la 2e '
      'déclinaison (type : oppidum, i, n.). Comme l\'infinitif n\'a '
      'pas toutes ces formes, gérondif et infinitif se complètent :',
    ),
    _tableauColonnes(
      ['cas', 'infinitif', 'gérondif', 'traduction'],
      [
        ['nom.', 'legere', 'ø', 'lire'],
        ['acc. sans prép.', 'legere', 'ø', 'lire'],
        ['acc. avec prép.', 'ø', '(ad) legendum', '(pour) lire'],
        ['gén.', 'ø', 'legendi', 'de lire, de la lecture'],
        ['dat. (rare)', 'ø', 'legendo', 'à lire'],
        ['abl.', 'ø', 'legendo', 'en lisant, par la lecture'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Les emplois'),
    _paragrapheExplication(
      'Le gérondif s\'emploie :\n\n'
      '• à l\'accusatif, précédé de ad, comme complément de but. Ex. : '
      'Legit ad discendum. (Il lit pour apprendre.)\n\n'
      '• au génitif, comme complément d\'un nom ou d\'un adjectif. Ex. '
      ': tempus legendi (le temps de lire) ; cupidus legendi (désireux '
      'de lire).',
    ),
    _paragrapheExplication(
      'Remarque : dans les expressions legendi causa ou legendi gratia '
      '« pour lire », le gérondif est complément au génitif du nom '
      'causa ou gratia. Ces noms à l\'ablatif jouent le rôle d\'une '
      'préposition et expriment le but.',
    ),
    _paragrapheExplication(
      '• à l\'ablatif, comme complément de moyen (ou de manière). Ex. '
      ': Legendo doctior fies. (C\'est en lisant que tu deviendras '
      'plus savant.)\n\n'
      'Attention : le participe présent exprime la simultanéité, et '
      'non le moyen ! Ex. : Legens ambulas. (Tu marches en lisant — '
      'simultanéité, non moyen.)\n\n'
      '• au datif (emploi rare), comme complément de certains verbes '
      'et adjectifs. Ex. : Scribendo adfuerunt. (Ils assistèrent à la '
      'rédaction.)',
    ),
    _titreExplication('Cas particulier : l\'adjectif verbal remplaçant le gérondif'),
    _paragrapheExplication(
      'Cupiditas litteras discendi mihi est. = Cupiditas litterarum '
      'discendarum mihi est. Litteras discendo doctior fio. = Litteris '
      'discendis doctior fio.',
    ),
    _paragrapheExplication(
      'Le gérondif est parfois remplacé par l\'adjectif verbal '
      '(modèle de déclinaison : bonus, a, um). Ex. : legere → '
      'gérondif : legendum, legendi, legendo → adjectif verbal : '
      'legendus, a, um.',
    ),
    _paragrapheExplication(
      'Quand un gérondif a un complément d\'objet à l\'accusatif, le '
      'latin remplace cette tournure par une tournure utilisant '
      'l\'adjectif verbal. Au lieu de dire cupidus legendi historiam, '
      'le latin préfère cupidus historiae legendae (désireux de lire '
      'l\'histoire).\n\n'
      'Méthode : 1) l\'ancien COD (historiam) devient le complément de '
      'cupidus et prend le cas qui était celui du gérondif ; 2) le '
      'gérondif est transformé en adjectif, qui s\'accorde en genre, '
      'nombre et cas avec historiae. Le sens est inchangé.',
    ),
    _paragrapheExplication(
      'Cette substitution, habituelle au génitif et à l\'ablatif sans '
      'préposition, est obligatoire au datif et après une '
      'préposition.\n\n'
      'Ex. : le temps de lire l\'histoire → tempus legendi historiam '
      'ou tempus historiae legendae. pour lire l\'histoire → ad '
      'legendam historiam (obligatoire, car après préposition).',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Pourquoi le latin a-t-il besoin du gérondif, alors qu\'il possède déjà l\'infinitif ?',
      options: [
        'l\'infinitif n\'a pas de génitif, de datif, d\'ablatif ni d\'accusatif après préposition',
        'l\'infinitif n\'existe pas en latin',
        'le gérondif remplace entièrement l\'infinitif',
        'le gérondif sert uniquement au pluriel'
      ],
      reponseCorrecte: 'l\'infinitif n\'a pas de génitif, de datif, d\'ablatif ni d\'accusatif après préposition',
    ),
    QuestionLecon(
      question: 'Comment forme-t-on le gérondif ?',
      options: [
        'radical du présent + suffixe -nd- + terminaisons neutres de la 2e déclinaison',
        'radical du parfait + suffixe -nd-',
        'infinitif + terminaisons de la 1re déclinaison',
        'supin + suffixe -nd-'
      ],
      reponseCorrecte: 'radical du présent + suffixe -nd- + terminaisons neutres de la 2e déclinaison',
    ),
    QuestionLecon(
      question: 'Comme quel type de mot le gérondif est-il décliné ?',
      options: ['un substantif neutre de la 2e déclinaison', 'un adjectif de la 1re classe', 'un nom de la 3e déclinaison', 'un pronom'],
      reponseCorrecte: 'un substantif neutre de la 2e déclinaison',
    ),
    QuestionLecon(
      question: 'Quelle préposition précède le gérondif à l\'accusatif pour exprimer le but ?',
      options: ['ad', 'de', 'in', 'ab'],
      reponseCorrecte: 'ad',
    ),
    QuestionLecon(
      question: 'À quel cas le gérondif complète-t-il un nom ou un adjectif (comme cupidus legendi) ?',
      options: ['le génitif', 'l\'accusatif', 'le datif', 'l\'ablatif'],
      reponseCorrecte: 'le génitif',
    ),
    QuestionLecon(
      question: 'À quel cas le gérondif exprime-t-il le moyen ou la manière ?',
      options: ['l\'ablatif', 'le génitif', 'le datif', 'l\'accusatif'],
      reponseCorrecte: 'l\'ablatif',
    ),
    QuestionLecon(
      question: 'Qu\'exprime le participe présent (comme legens), à la différence du gérondif à l\'ablatif ?',
      options: ['la simultanéité, non le moyen', 'le but', 'la cause', 'la même chose que le gérondif'],
      reponseCorrecte: 'la simultanéité, non le moyen',
    ),
    QuestionLecon(
      question: 'Par quoi le gérondif est-il souvent remplacé quand il a un complément d\'objet à l\'accusatif ?',
      options: ['l\'adjectif verbal, accordé avec ce complément', 'le participe présent', 'le supin', 'l\'infinitif seul'],
      reponseCorrecte: 'l\'adjectif verbal, accordé avec ce complément',
    ),
    QuestionLecon(
      question: 'Dans quels cas cette substitution par l\'adjectif verbal est-elle obligatoire ?',
      options: ['au datif et après une préposition', 'au génitif seul', 'à l\'ablatif seul', 'elle n\'est jamais obligatoire'],
      reponseCorrecte: 'au datif et après une préposition',
    ),
    ExerciceSaisie(
      question: 'Donne l\'accusatif du gérondif de mittere, précédé de ad (« pour envoyer »).',
      reponsesAcceptees: ['ad mittendum', 'mittendum'],
    ),
    ExerciceSaisie(
      question: 'Donne le génitif du gérondif de legere (« de lire »).',
      reponsesAcceptees: ['legendi'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['cas', 'gérondif', 'emploi'],
        [
          ['acc. (ad +)', 'legendum', 'but'],
          ['gén.', 'legendi', 'complément de nom/adjectif'],
          ['dat. (rare)', 'legendo', 'complément de certains verbes'],
          ['abl.', 'legendo', 'moyen, manière'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Complète l\'infinitif, qui n\'a pas ces cas. Avec un COD à '
        'l\'accusatif, remplacé par l\'adjectif verbal accordé '
        '(obligatoire au datif et après préposition).',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : L'adjectif verbal d'obligation
// ------------------------------------------------------------

final Lecon _leconAdjectifVerbalObligation = Lecon(
  id: 'adjectif_verbal_obligation',
  titre: 'L\'adjectif verbal d\'obligation',
  sousTitre: 'Carthago delenda est : sens passif et sens d\'obligation',
  icone: Icons.assignment,
  unite: 'Vol. III – Unité 6',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Bona magnaque cena tibi afferenda est. (Il te faudra apporter '
      'un bon et copieux dîner.) Tunc erit bibendi tempus. Immo vero, '
      'semper bibendum est. (Alors ce sera le moment de boire. Mais en '
      'fait, il faut toujours boire.) — d\'après Catulle, Carmen XIII '
      'ad Fabullum.',
    ),
    _paragrapheExplication(
      'unguento olfaciendo (olfaciendo = adjectif verbal remplaçant le '
      'gérondif) unguentum olfaciendum dabo (olfaciendum = adjectif '
      'verbal après un verbe comme dare « donner » ; il est attribut '
      'du COD, avec un sens d\'obligation ou d\'intention) Bona '
      'magnaque cena tibi afferenda est (afferenda = adjectif verbal, '
      'attribut du sujet cena, avec un sens d\'obligation ; la '
      'personne concernée est au datif d\'intérêt) bibendum est '
      '(adjectif verbal, attribut du sujet impersonnel, donc au '
      'neutre, sens d\'obligation)',
    ),
    _titreExplication('L\'adjectif verbal a trois emplois'),
    _paragrapheExplication(
      '• il remplace le gérondif (même sens que le gérondif)\n'
      '• il est attribut du sujet (sens d\'obligation)\n'
      '• il est attribut du COD (sens d\'obligation ou d\'intention)',
    ),
    _titreExplication('Formation et sens'),
    _paragrapheExplication(
      'Comme son nom l\'indique, l\'adjectif verbal « transforme » un '
      'verbe en adjectif. Le français connaît une dérivation similaire '
      'par le suffixe -ble : lisible = qui peut être lu ; illisible : '
      'qui ne peut pas être lu. De même en allemand : essbar = was '
      'gegessen werden kann. Et en anglais : understandable = what can '
      'be understood.',
    ),
    _paragrapheExplication(
      'L\'adjectif verbal en latin est formé par : radical du présent '
      '+ (voyelle intermédiaire) + suffixe -nd- + terminaisons des '
      'adjectifs de la 1re classe : -us, -a, -um.\n\n'
      'L\'adjectif verbal a un sens passif et un sens d\'obligation : '
      'legendus, a, um « qui doit être lu », « (qui est) à lire ».\n\n'
      'Comme le français n\'a pas d\'adjectif verbal correspondant, il '
      'faut trouver d\'autres moyens pour le traduire.',
    ),
    _titreExplication('L\'adjectif verbal, attribut du sujet'),
    _paragrapheExplication(
      'L\'adjectif verbal s\'emploie surtout comme attribut du sujet. '
      'S\'il a un complément, celui-ci est au datif d\'intérêt.\n\n'
      'Carthago delenda est. (littéralement « Carthage est \'qui doit '
      'être détruite\' » → Carthage est à détruire. → Carthage doit '
      'être détruite. → Il faut détruire Carthage.) Romanis Carthago '
      'delenda est. (littéralement « ... pour les Romains » → Les '
      'Romains doivent détruire Carthage. → Il faut que les Romains '
      'détruisent Carthage.) Draco dormiens numquam titillandus [est]. '
      '(Il ne faut jamais chatouiller le dragon qui dort.)',
    ),
    _paragrapheExplication(
      'Les verbes déponents peuvent se mettre à l\'adjectif verbal. '
      'Ils ont alors un sens passif (contrairement à leurs autres '
      'formes, toujours actives).\n\n'
      'Au passif impersonnel (sans sujet), l\'adjectif verbal se met '
      'au neutre. Ex. : Gaudendum est. (Il faut se réjouir.) Tibi '
      'gaudendum est. (Il te faut te réjouir.)',
    ),
    _titreExplication('L\'adjectif verbal, attribut du COD'),
    _paragrapheExplication(
      'L\'adjectif verbal s\'emploie aussi comme attribut du COD. On '
      'le rencontre avec des verbes comme dare « donner », mittere '
      '« envoyer », tradere « remettre, livrer », curare « s\'occuper '
      'de, prendre soin de ». Le sens d\'obligation est alors affaibli '
      '; on dit que l\'adjectif verbal a un sens d\'intention.\n\n'
      'Dedit mihi libros legendos. (Il m\'a donné des livres à lire.) '
      'Caesar pontem aedificandum curavit. (César s\'est occupé de la '
      'construction d\'un pont — César a fait construire un pont.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Quels sont les trois emplois de l\'adjectif verbal ?',
      options: [
        'remplacer le gérondif ; être attribut du sujet ; être attribut du COD',
        'être sujet, COD et COI',
        'exprimer le temps, le lieu et la manière',
        'former le comparatif, le superlatif et le positif'
      ],
      reponseCorrecte: 'remplacer le gérondif ; être attribut du sujet ; être attribut du COD',
    ),
    QuestionLecon(
      question: 'Comme quels adjectifs se décline l\'adjectif verbal ?',
      options: ['les adjectifs de la 1re classe (bonus, a, um)', 'les adjectifs de la 2e classe (fortis, e)', 'les comparatifs', 'il est indéclinable'],
      reponseCorrecte: 'les adjectifs de la 1re classe (bonus, a, um)',
    ),
    QuestionLecon(
      question: 'Quels deux sens l\'adjectif verbal porte-t-il ?',
      options: ['un sens passif et un sens d\'obligation', 'un sens actif et un sens de possibilité', 'un sens de lieu et un sens de temps', 'aucun sens particulier'],
      reponseCorrecte: 'un sens passif et un sens d\'obligation',
    ),
    QuestionLecon(
      question: 'Que signifie littéralement Carthago delenda est ?',
      options: ['Carthage est « qui doit être détruite »', 'Carthage a été détruite', 'Carthage détruit', 'Carthage sera détruite un jour'],
      reponseCorrecte: 'Carthage est « qui doit être détruite »',
    ),
    QuestionLecon(
      question: 'Dans Romanis Carthago delenda est, à quel cas est Romanis, et quelle est sa fonction ?',
      options: ['datif d\'intérêt (pour qui vaut l\'obligation)', 'ablatif d\'agent', 'génitif possessif', 'accusatif COD'],
      reponseCorrecte: 'datif d\'intérêt (pour qui vaut l\'obligation)',
    ),
    QuestionLecon(
      question: 'À quel cas/genre se met l\'adjectif verbal au passif impersonnel (sans sujet) ?',
      options: ['au neutre', 'au masculin pluriel', 'au féminin singulier', 'il n\'existe pas au passif impersonnel'],
      reponseCorrecte: 'au neutre',
    ),
    QuestionLecon(
      question: 'Quel sens prennent les verbes déponents mis à l\'adjectif verbal ?',
      options: ['un sens passif', 'un sens actif, comme d\'habitude', 'aucun sens, c\'est impossible', 'un sens réfléchi'],
      reponseCorrecte: 'un sens passif',
    ),
    QuestionLecon(
      question: 'Avec quels verbes l\'adjectif verbal s\'emploie-t-il typiquement comme attribut du COD ?',
      options: ['dare, mittere, tradere, curare', 'esse, ire, ferre', 'volo, nolo, malo', 'amare, monere, audire'],
      reponseCorrecte: 'dare, mittere, tradere, curare',
    ),
    QuestionLecon(
      question: 'Quel sens, plus faible que l\'obligation, l\'adjectif verbal a-t-il comme attribut du COD ?',
      options: ['un sens d\'intention', 'un sens de certitude', 'un sens de regret', 'un sens de souhait'],
      reponseCorrecte: 'un sens d\'intention',
    ),
    ExerciceSaisie(
      question: 'Donne l\'adjectif verbal de delere (« qui doit être détruite »), au féminin singulier.',
      reponsesAcceptees: ['delenda'],
    ),
    ExerciceSaisie(
      question: 'Donne l\'adjectif verbal impersonnel de gaudere (« il faut se réjouir »), au neutre.',
      reponsesAcceptees: ['gaudendum'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _paragrapheExplication(
        'Adjectif verbal = radical du présent + -nd- + -us,a,um. Sens '
        'passif + obligation. Attribut du sujet (Carthago delenda est '
        ', datif d\'intérêt pour l\'agent) ou attribut du COD (dedit '
        'libros legendos, sens d\'intention, après dare/mittere/'
        'tradere/curare).',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les verbes impersonnels
// ------------------------------------------------------------

final Lecon _leconVerbesImpersonnels = Lecon(
  id: 'verbes_impersonnels',
  titre: 'Les verbes impersonnels',
  sousTitre: 'lucet, decet, licet, oportet... : la 3e personne du singulier sans sujet',
  icone: Icons.cloud,
  unite: 'Vol. III – Unité 6',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Tu connais déjà un certain nombre de verbes, d\'expressions ou '
      'de tournures impersonnels (Nunc est bibendum, Romam itur...). '
      'Voici une liste plus complète, qui te servira de référence.',
    ),
    _paragrapheExplication('Le verbe impersonnel s\'emploie à la 3e personne du singulier et à l\'infinitif.'),
    _titreExplication('Les phénomènes atmosphériques'),
    _tableauColonnes(
      ['verbe', 'sens'],
      [
        ['lucet, ere, luxit', 'il fait jour'],
        ['pluit, ere, pluit (arch. pluvit)', 'il pleut'],
        ['ningit, ere, ninxit', 'il neige'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Tu pourras trouver d\'autres constructions avec ces verbes, '
      'notamment chez des auteurs tardifs. Ex. : nubes pluunt (saint '
      'Augustin, Commentaires sur les Psaumes, CXXXIV, 13 : « les '
      'nuages pleuvent » → les nuages se résolvent en pluie).',
    ),
    _titreExplication('Les verbes d\'évidence, de convenance ou de nécessité'),
    _tableauColonnes(
      ['verbe', 'sens'],
      [
        ['(satis) constat, -are, constitit', 'il est (bien) établi que'],
        ['decet, ere, decuit', 'il convient que'],
        ['juvat, are, juvit', 'il est agréable que'],
        ['licet, ere, licuit (ou licitum est)', 'il est permis'],
        ['praestat, are, praestitit', 'il vaut mieux'],
        ['placet, ere, placuit', 'il plaît, il paraît bon'],
        ['interest, esse, interfuit', 'il importe'],
        ['oportet, ere, oportuit', 'il faut'],
        ['convenit, -ire, -venit', 'il convient, il y a accord'],
        ['libet (lubet), ere, libuit (ou libitum est)', 'il plaît, il fait plaisir'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Ex. : Adde, si lubet, pernicitatem et velocitatem. (Cicéron, '
      'Tusculanae Disputationes, V, 45 : « Ajoute, s\'il te plaît, la '
      'souplesse et l\'agilité. ») Licet nemini contra patriam ducere '
      'exercitum. (Cicéron, Philippicae, XIII, 14 : « Personne n\'a le '
      'droit de conduire une armée contre sa patrie. »)',
    ),
    _paragrapheExplication(
      'Ces verbes peuvent avoir pour sujet grammatical un infinitif ou '
      'une proposition infinitive.\n\n'
      'Ex. : Tacere decet. (« Se taire convient » → Il convient de se '
      'taire.) Te omnibus rebus studere decet. (Il convient que tu '
      't\'intéresses à tout.)',
    ),
    _titreExplication('Les locutions composées de esse'),
    _tableauColonnes(
      ['locution', 'sens'],
      [
        ['facile, difficile est + inf.', 'il est facile, difficile de'],
        ['necesse est + inf. / ACI', 'il est nécessaire de/que, inévitable de/que'],
        ['mos est + inf. / ACI', 'c\'est la coutume de/que'],
        ['fama est (fert) + ACI', 'le bruit court que'],
        ['opus est + dat. + abl. / + inf.', 'qqn a besoin de'],
        ['fas / nefas est + inf. / ACI', 'il est permis / interdit par les dieux de/que'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Je me rappelle : les verbes d\'événement'),
    _tableauColonnes(
      ['verbe', 'sens'],
      [
        ['accidit, ere, accidit ut', 'il arrive que (événement imprévu, souvent malheureux)'],
        ['contingit, ere, contigit ut', 'il arrive que (événement le plus souvent heureux)'],
        ['evenit, ire, evenit ut', 'il arrive que'],
        ['fit, fieri, factum est ut', 'il arrive que'],
        ['est, esse, fuit ut', 'il arrive que'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Les verbes exprimant l\'événement sont suivis de la conjonction '
      'ut + subjonctif. La négation est ut non + subjonctif.\n\n'
      'Ex. : Saepe accidit ut cibus incolis desit. (Il arrive souvent '
      'que la nourriture manque aux habitants.)',
    ),
    _titreExplication('Les verbes exprimant certains sentiments'),
    _tableauColonnes(
      ['verbe', 'sens'],
      [
        ['me paenitet, paenitere, paenituit + gén.', 'je me repens de, je regrette qqch.'],
        ['me miseret + gén.', 'j\'ai pitié de'],
        ['me piget, pigere, piguit + gén.', 'je suis fâché, ennuyé'],
        ['me pudet, pudere, puduit + gén.', 'j\'ai honte de'],
        ['me taedet, taedere, taeduit + gén.', 'je suis dégoûté de'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Ces verbes se construisent avec l\'accusatif de la personne et '
      'le génitif de la cause.\n\n'
      'Ex. : Me paenitet erroris mei. (Je me repens de mon erreur.) '
      'Eorum nos miseret. (Nous avons pitié d\'eux.) Taedet omnino eos '
      'vitae. (Ils sont tout à fait dégoûtés de la vie.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'À quelle(s) forme(s) le verbe impersonnel s\'emploie-t-il ?',
      options: ['3e personne du singulier et infinitif', 'toutes les personnes', '1re personne du pluriel uniquement', 'impératif uniquement'],
      reponseCorrecte: '3e personne du singulier et infinitif',
    ),
    QuestionLecon(
      question: 'Que signifie pluit ?',
      options: ['il pleut', 'il neige', 'il fait jour', 'il vente'],
      reponseCorrecte: 'il pleut',
    ),
    QuestionLecon(
      question: 'Que signifie oportet ?',
      options: ['il faut', 'il est permis', 'il plaît', 'il importe'],
      reponseCorrecte: 'il faut',
    ),
    QuestionLecon(
      question: 'Que signifie licet ?',
      options: ['il est permis', 'il est interdit', 'il faut', 'il convient'],
      reponseCorrecte: 'il est permis',
    ),
    QuestionLecon(
      question: 'Quel sujet grammatical les verbes impersonnels de convenance ou de nécessité peuvent-ils avoir ?',
      options: ['un infinitif ou une proposition infinitive', 'un nom au nominatif uniquement', 'un pronom personnel uniquement', 'aucun sujet possible'],
      reponseCorrecte: 'un infinitif ou une proposition infinitive',
    ),
    QuestionLecon(
      question: 'Que signifie la locution opus est + datif + ablatif ?',
      options: ['quelqu\'un a besoin de quelque chose', 'il est facile de', 'le bruit court que', 'c\'est la coutume de'],
      reponseCorrecte: 'quelqu\'un a besoin de quelque chose',
    ),
    QuestionLecon(
      question: 'Par quelle conjonction les verbes d\'événement (accidit, contingit...) sont-ils suivis ?',
      options: ['ut + subjonctif', 'quod + indicatif', 'si + indicatif', 'quia + indicatif'],
      reponseCorrecte: 'ut + subjonctif',
    ),
    QuestionLecon(
      question: 'Avec quels cas se construisent les verbes impersonnels de sentiment (paenitet, pudet, taedet...) ?',
      options: ['accusatif de la personne + génitif de la cause', 'nominatif + génitif', 'datif + ablatif', 'accusatif + accusatif'],
      reponseCorrecte: 'accusatif de la personne + génitif de la cause',
    ),
    QuestionLecon(
      question: 'Que signifie me pudet + génitif ?',
      options: ['j\'ai honte de', 'je me repens de', 'j\'ai pitié de', 'je suis dégoûté de'],
      reponseCorrecte: 'j\'ai honte de',
    ),
    QuestionLecon(
      question: 'Que signifie me taedet + génitif ?',
      options: ['je suis dégoûté de', 'j\'ai honte de', 'je regrette', 'j\'ai pitié de'],
      reponseCorrecte: 'je suis dégoûté de',
    ),
    ExerciceSaisie(
      question: 'Quel verbe impersonnel latin signifie « il faut » ?',
      reponsesAcceptees: ['oportet'],
    ),
    ExerciceSaisie(
      question: 'Traduis « je me repens de mon erreur » en gardant le verbe latin paenitet (mei erroris) : Me paenitet ___.',
      reponsesAcceptees: ['erroris mei', 'mei erroris'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['catégorie', 'exemples'],
        [
          ['atmosphérique', 'lucet, pluit, ningit'],
          ['convenance/nécessité', 'decet, licet, oportet, placet'],
          ['événement (+ ut subj.)', 'accidit, contingit, evenit, fit'],
          ['sentiment (acc. + gén.)', 'paenitet, pudet, taedet, piget, miseret'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : La concession
// ------------------------------------------------------------

final Lecon _leconConcession = Lecon(
  id: 'concession',
  titre: 'La concession',
  sousTitre: 'cum, quamvis, quamquam, etsi + subjonctif ou indicatif',
  icone: Icons.warning_amber_rounded,
  unite: 'Vol. III – Unité 7',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Cum absit a culpa, accusatur. (Bien qu\'il soit innocent, il '
      'est accusé.) Quamvis sint sub aqua, sub aqua maledicere '
      'temptant. (Bien qu\'ils soient sous l\'eau, sous l\'eau ils '
      'essaient de maudire — d\'après Ovide, Métamorphoses, VI, 376.)',
    ),
    _paragrapheExplication(
      'La subordonnée circonstancielle de concession exprime une '
      'opposition entre deux faits, ou montre qu\'un fait se produit '
      'malgré un autre qui aurait pu l\'empêcher. Les propositions '
      'principale et subordonnée sont ainsi liées par une logique '
      'contradictoire.',
    ),
    _titreExplication('Les conjonctions concessives les plus fréquentes'),
    _tableauColonnes(
      ['conjonction', 'construction', 'sens'],
      [
        ['cum', '+ subjonctif', 'bien que, quoique'],
        ['quamvis', '+ subjonctif', 'bien que, quoique'],
        ['quamvis', '+ adj./adv. [+ subjonctif]', 'quelque... que, si... que, tout... que'],
        ['quamquam', '+ indicatif / + subjonctif', 'à quelque degré que, bien que, quoique'],
        ['quamquam', '+ adj./adv.', 'quoique'],
        ['etsi', '+ indicatif', 'même si'],
        ['etsi', '+ subjonctif', 'bien que, quoique'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Bella parat Minos ; qui quamquam milite, quamquam classe valet, '
      'patria tamen est firmissimus ira... (Minos prépare les guerres '
      '; quoiqu\'il soit vigoureux par l\'armée, quoiqu\'il le soit par '
      'la flotte, c\'est pourtant par sa colère de père qu\'il est le '
      'plus inébranlable... — d\'après Ovide, Métamorphoses, VII, '
      '456-457.)',
    ),
    _paragrapheExplication(
      'Etsi difficile esse videtur credere quicquam in rebus solido '
      'reperiri corpore posse... (Même s\'il semble difficile de '
      'croire que des corps aussi solides puissent être trouvés dans '
      'la nature... — d\'après Lucrèce, De rerum natura, I, 487-488.)',
    ),
    _paragrapheExplication(
      'Quamvis enim sine mente, sine sensu sis [...], tamen te et tua '
      'et tuos nosti. (En effet, tout dépourvu d\'esprit et de sens que '
      'tu sois, tu te connais cependant toi-même, tes affaires et tes '
      'proches — Cicéron, Philippiques, II, 28.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Que exprime la subordonnée circonstancielle de concession ?',
      options: [
        'une opposition entre deux faits, malgré ce qui aurait pu empêcher l\'un d\'eux',
        'la cause d\'un fait',
        'le but d\'une action',
        'une comparaison entre deux éléments'
      ],
      reponseCorrecte: 'une opposition entre deux faits, malgré ce qui aurait pu empêcher l\'un d\'eux',
    ),
    QuestionLecon(
      question: 'Avec quel mode se construit cum concessif ?',
      options: ['le subjonctif', 'l\'indicatif', 'l\'infinitif', 'l\'impératif'],
      reponseCorrecte: 'le subjonctif',
    ),
    QuestionLecon(
      question: 'Avec quel mode se construit quamvis ?',
      options: ['le subjonctif', 'l\'indicatif', 'l\'infinitif', 'le participe'],
      reponseCorrecte: 'le subjonctif',
    ),
    QuestionLecon(
      question: 'Que signifie quamvis + adjectif/adverbe [+ subjonctif] ?',
      options: ['quelque... que, si... que, tout... que', 'bien que, quoique', 'même si', 'parce que'],
      reponseCorrecte: 'quelque... que, si... que, tout... que',
    ),
    QuestionLecon(
      question: 'Avec quel(s) mode(s) quamquam peut-il se construire ?',
      options: ['l\'indicatif ou le subjonctif', 'l\'indicatif seulement', 'le subjonctif seulement', 'l\'impératif seulement'],
      reponseCorrecte: 'l\'indicatif ou le subjonctif',
    ),
    QuestionLecon(
      question: 'Que signifie etsi + indicatif ?',
      options: ['même si', 'bien que', 'parce que', 'pourvu que'],
      reponseCorrecte: 'même si',
    ),
    QuestionLecon(
      question: 'Que peut aussi signifier etsi, quand il est suivi du subjonctif ?',
      options: ['bien que, quoique', 'même si (seulement)', 'parce que', 'de peur que'],
      reponseCorrecte: 'bien que, quoique',
    ),
    QuestionLecon(
      question: 'Quelle logique relie la principale et la subordonnée de concession ?',
      options: ['une logique contradictoire', 'une logique causale', 'une logique finale', 'une logique temporelle'],
      reponseCorrecte: 'une logique contradictoire',
    ),
    ExerciceSaisie(
      question: 'Quelle conjonction concessive, toujours suivie du subjonctif, signifie « bien que, quoique » ?',
      reponsesAcceptees: ['quamvis'],
    ),
    ExerciceSaisie(
      question: 'Quelle conjonction concessive signifie « même si » quand elle est suivie de l\'indicatif ?',
      reponsesAcceptees: ['etsi'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['conjonction', 'mode', 'sens'],
        [
          ['cum', 'subjonctif', 'bien que'],
          ['quamvis', 'subjonctif', 'bien que'],
          ['quamquam', 'indicatif ou subjonctif', 'bien que'],
          ['etsi', 'indicatif', 'même si'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : La comparaison
// ------------------------------------------------------------

final Lecon _leconComparaisonSubordonnee = Lecon(
  id: 'comparaison_subordonnee',
  titre: 'La comparaison',
  sousTitre: 'ut/sicut/tamquam, talis...qualis, tam...quam, quo... eo',
  icone: Icons.trending_up,
  unite: 'Vol. III – Unité 7',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Talis est filius, qualis pater [est]. Qualis pater, talis '
      'filius. Tam fortis quam pater est. Tantae virtutes ei sunt '
      'quantae patri. Ita loquitur filius in foro ut locutus est '
      'pater.',
    ),
    _paragrapheExplication(
      '• Les subordonnées de comparaison sont à l\'indicatif.\n\n'
      '• Elles sont souvent elliptiques : si le verbe de la '
      'subordonnée est le même que celui de la principale, il est '
      'souvent omis.\n\n'
      '• Les mots introducteurs sont d\'origine diverse : conjonctions '
      '(ut, sicut, velut...), adjectifs (quantus, qualis...), adverbes '
      '(quam, ac...).\n\n'
      '• Ces mots introducteurs sont souvent annoncés ou repris dans '
      'la principale par un corrélatif (tam... quam, ita... ut, '
      'tantus... quantus...).',
    ),
    _titreExplication('1. La subordonnée introduite par une conjonction'),
    _paragrapheExplication(
      'ut (uti), sicut (sicuti), velut (veluti), quomodo, quemadmodum, '
      'tamquam « de même que, ainsi que, comme ».\n\n'
      'Ex. : Ficta omnia celeriter tamquam flosculi decidunt. (Tout ce '
      'qui est feint périt aussi vite que les fleurs — Cicéron, De '
      'Officiis, II, 12, 43.)',
    ),
    _paragrapheExplication(
      'Ces conjonctions de subordination — surtout ut — peuvent être '
      'annoncées ou reprises dans la principale par les adverbes '
      'corrélatifs sic ou ita. Il n\'est pas toujours nécessaire de '
      'traduire le corrélatif en français.\n\n'
      'Ex. : Ita metes, ut sementem feceris. ((Ainsi) tu moissonneras, '
      'comme tu auras semé.)',
    ),
    _paragrapheExplication(
      'Ordre inversé : si la subordonnée précède la principale, tu '
      'peux traduire par « de même que... de même » ou « comme... '
      'ainsi ».\n\n'
      'Ex. : Ut sementem feceris, ita metes. (Comme tu auras semé, '
      'ainsi tu moissonneras.) Ut medicorum scientiam non ipsius '
      'artis, sed bonae valetudinis causa probamus, sic sapientia non '
      'expeteretur, si nihil efficeret. (De même que nous prisons la '
      'science des médecins non pour l\'art lui-même, mais pour la '
      'bonne santé, de même la sagesse ne serait pas recherchée, si '
      'elle ne réalisait rien — Cicéron, De Finibus, I, 13.)',
    ),
    _titreExplication('2. La subordonnée introduite par un adjectif ou un adverbe'),
    _tableauColonnes(
      ['ordre normal (principale... subordonnée)', 'ordre inversé (subordonnée... principale)'],
      [
        ['talis, is, e... qualis, is, e (« tel... que »)', 'qualis, is, e... talis, is, e (« tel... tel »)'],
        ['tantus, a, um... quantus, a, um (« aussi grand... que »)', 'quantus, a, um... tantus, a, um (« aussi grand... aussi grand »)'],
        ['tot... quot (« aussi nombreux... que, autant de... que de »)', 'quot... tot (« aussi nombreux... aussi nombreux »)'],
        ['tamdiu... quamdiu (« aussi longtemps que »)', 'quamdiu... tamdiu (« aussi longtemps... aussi longtemps »)'],
        ['tot(i)es... quot(i)es (« autant de fois que »)', 'quot(i)es... tot(i)es (« autant de fois... autant de fois »)'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Ex. : Quot homines, tot sententiae. (Autant d\'hommes, autant '
      'd\'avis.) Quotiens mihi auxilio fuisti, totiens tibi gratias '
      'egi. (Autant de fois tu m\'as aidé, autant de fois je t\'ai '
      'remercié.)',
    ),
    _titreExplication('3. Rappels'),
    _paragrapheExplication(
      'quam s\'emploie après un comparatif ou un verbe exprimant une '
      'idée de comparaison. Ex. : Doctior quam Petrus est. (Il est '
      'plus savant que Pierre.) Malo mori quam servire. (Je préfère '
      'mourir qu\'être esclave.)',
    ),
    _paragrapheExplication(
      'tam + adj./adv. ... quam « aussi... que ». Ex. : Tam celeriter '
      'currit quam tu. (Il court aussi vite que toi.)',
    ),
    _paragrapheExplication(
      'ac / atque s\'emploie après des mots qui expriment l\'égalité, '
      'la ressemblance ou leurs contraires. Ex. : Iisdem libris utor '
      'ac tu. (Je me sers des mêmes livres que toi.) Alios libros legi '
      'ac tu. (J\'ai lu d\'autres livres que toi.)',
    ),
    _titreExplication('4. Pour aller plus loin : « plus... plus... »'),
    _tableauColonnes(
      ['ordre normal', 'ordre inversé'],
      [
        ['eo (hoc) magis / comparatif... quo magis', 'quo magis... eo (hoc) magis'],
        ['eo (hoc) + comparatif... quo + comparatif', 'quo + comparatif... eo (hoc) + comparatif'],
        ['« d\'autant plus... que plus... »', '« plus... plus... »'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Ex. (ordre normal) : Eo modestior [est] quo doctior est. (Il est '
      'd\'autant plus modeste qu\'il est plus instruit.) Ex. (ordre '
      'inversé) : Quo quis doctior, eo modestior est. (Plus quelqu\'un '
      'est savant, plus il est modeste.) Utique quo major est populus '
      'cui miscemur, hoc periculi plus est. (En tout cas, plus la '
      'foule à laquelle nous nous mêlons est grande, plus il y a de '
      'danger — Sénèque, Epistulae ad Lucilium, I, 7.)',
    ),
    _paragrapheExplication(
      'Quand le second terme ne comporte pas de comparatif, on a : eo '
      '(hoc) magis / comparatif... quod « d\'autant plus... que... ». '
      'Ex. : Eo modestior [est] quod doctus est. (Il est d\'autant plus '
      'modeste qu\'il est instruit.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'À quel mode sont les subordonnées de comparaison en latin ?',
      options: ['l\'indicatif', 'le subjonctif', 'l\'infinitif', 'le participe'],
      reponseCorrecte: 'l\'indicatif',
    ),
    QuestionLecon(
      question: 'Pourquoi les subordonnées de comparaison sont-elles souvent elliptiques ?',
      options: [
        'parce que le verbe, identique à celui de la principale, est souvent omis',
        'parce qu\'elles n\'ont jamais de verbe',
        'parce qu\'elles sont toujours au participe',
        'parce que le sujet est toujours omis'
      ],
      reponseCorrecte: 'parce que le verbe, identique à celui de la principale, est souvent omis',
    ),
    QuestionLecon(
      question: 'Que signifie tamquam (parmi les conjonctions de comparaison) ?',
      options: ['de même que, ainsi que, comme', 'bien que', 'pourvu que', 'parce que'],
      reponseCorrecte: 'de même que, ainsi que, comme',
    ),
    QuestionLecon(
      question: 'Par quels adverbes corrélatifs la conjonction ut de comparaison peut-elle être annoncée ou reprise dans la principale ?',
      options: ['sic ou ita', 'tam ou quam', 'quo ou eo', 'tot ou quot'],
      reponseCorrecte: 'sic ou ita',
    ),
    QuestionLecon(
      question: 'Que signifie le corrélatif talis... qualis (ordre normal) ?',
      options: ['tel... que', 'aussi grand... que', 'autant de... que de', 'aussi longtemps... que'],
      reponseCorrecte: 'tel... que',
    ),
    QuestionLecon(
      question: 'Que signifie tot... quot ?',
      options: ['aussi nombreux... que, autant de... que de', 'tel... que', 'aussi grand... que', 'aussi longtemps... que'],
      reponseCorrecte: 'aussi nombreux... que, autant de... que de',
    ),
    QuestionLecon(
      question: 'Après quel type de mot emploie-t-on quam pour introduire le second terme d\'une comparaison ?',
      options: ['un comparatif ou un verbe de comparaison', 'un superlatif uniquement', 'un nom au génitif', 'un adjectif au positif seul'],
      reponseCorrecte: 'un comparatif ou un verbe de comparaison',
    ),
    QuestionLecon(
      question: 'Après quels mots emploie-t-on ac/atque plutôt que quam ?',
      options: [
        'des mots exprimant l\'égalité, la ressemblance ou leurs contraires',
        'tous les comparatifs sans exception',
        'les superlatifs uniquement',
        'les verbes de mouvement'
      ],
      reponseCorrecte: 'des mots exprimant l\'égalité, la ressemblance ou leurs contraires',
    ),
    QuestionLecon(
      question: 'Que signifie la structure quo... eo + comparatifs (ordre inversé) ?',
      options: ['plus... plus...', 'moins... moins...', 'aussi... que', 'tel... que'],
      reponseCorrecte: 'plus... plus...',
    ),
    QuestionLecon(
      question: 'Que signifie Iisdem libris utor ac tu ?',
      options: ['Je me sers des mêmes livres que toi.', 'Je lis d\'autres livres que toi.', 'Tu te sers de mes livres.', 'Je n\'ai pas de livres.'],
      reponseCorrecte: 'Je me sers des mêmes livres que toi.',
    ),
    ExerciceSaisie(
      question: 'Quel adverbe corrélatif latin annonce souvent la conjonction ut de comparaison dans la principale (« ainsi ») ?',
      reponsesAcceptees: ['ita', 'sic'],
    ),
    ExerciceSaisie(
      question: 'Quelle conjonction, après tam + adjectif/adverbe, signifie « que » dans une comparaison d\'égalité ?',
      reponsesAcceptees: ['quam'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['corrélatifs', 'sens'],
        [
          ['tam... quam', 'aussi... que'],
          ['talis... qualis', 'tel... que'],
          ['tantus... quantus', 'aussi grand... que'],
          ['tot... quot', 'autant de... que de'],
          ['quo... eo (+ comparatifs)', 'plus... plus...'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Toujours à l\'indicatif, souvent elliptiques. quam après un '
        'comparatif ; ac/atque après un mot d\'égalité ou de '
        'ressemblance.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : L'interrogation indirecte
// ------------------------------------------------------------

final Lecon _leconInterrogationIndirecte = Lecon(
  id: 'interrogation_indirecte',
  titre: 'L\'interrogation indirecte',
  sousTitre: 'Une interrogative subordonnée au subjonctif, avec concordance des temps',
  icone: Icons.contact_support,
  unite: 'Vol. III – Unité 8',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Odi et amo. Quare id faciam, fortasse requiris. Nescio, sed '
      'fieri sentio et excrucior. (Je hais et j\'aime. Pourquoi je le '
      'fais, tu le demandes peut-être. Je ne sais pas, mais je sens '
      'que cela se produit et je suis torturé. — Catulle, Carmina, '
      'LXXXV.) Nunc ego, quid tibi accidat, Crasse, quid ceteris '
      'accidat, nescio. (Cicéron, De Oratore, II, 189.) Ipse timet nec '
      'scit qua sit iter. (d\'après Ovide, Métamorphoses, II, 169-170.)',
    ),
    _paragrapheExplication(
      'L\'interrogation indirecte est une proposition interrogative '
      'subordonnée :\n\n'
      '• qui dépend d\'un verbe signifiant « demander » (rogare '
      'aliquem, quaerere ab aliquo, petere ab aliquo) ou « dire, '
      'savoir, comprendre, voir, sentir » ;\n'
      '• qui se met au mode subjonctif ;\n'
      '• qui est introduite par les mêmes mots interrogatifs que '
      'l\'interrogation directe ;\n'
      '• qui observe la concordance des temps.',
    ),
    _paragrapheExplication(
      'Quis venit ? (Qui vient ? — proposition indépendante à '
      'l\'indicatif) Quaero quis veniat. (Je demande qui vient. — '
      'proposition subordonnée au subjonctif)',
    ),
    _titreExplication('Particularités'),
    _paragrapheExplication(
      '1. Attention au sens : certains verbes se construisent selon le '
      'sens soit avec la proposition infinitive (ACI), soit avec '
      'l\'interrogation indirecte.\n\n'
      'Il dit qu\'il vient. → Dicit se venire. (ACI) Il dit qui vient. '
      '→ Dicit quis veniat. (interrogation indirecte)',
    ),
    _paragrapheExplication(
      '2. num est synonyme de -ne « si » et ne sollicite donc pas de '
      'réponse négative, comme c\'est le cas dans une interrogation '
      'directe.\n\n'
      'Venitne pater tuus ? (Est-ce que ton père est venu ?) → Quaero '
      'veniturne pater tuus. ou Quaero num venerit pater tuus. (Je '
      'demande si ton père est venu.)',
    ),
    _paragrapheExplication(
      '3. L\'interrogation double peut également être indirecte.\n\n'
      'Utrum nobis ades an obes ? / Adesne nobis an obes ? (Es-tu avec '
      'ou contre nous ?) → Nescio utrum nobis adsis an obsis. / Nescio '
      'adsisne nobis an obsis. (Je ne sais pas si tu es avec ou contre '
      'nous.)',
    ),
    _paragrapheExplication(
      '4. Pour traduire en français une interrogation indirecte '
      'introduite par un pronom interrogatif neutre, il faut faire '
      'précéder celui-ci d\'un « ce ».\n\n'
      'Quid agis ? (Que fais-tu ?) → Dic quid agas. (Dis ce que tu '
      'fais.)',
    ),
    _titreExplication('La concordance des temps'),
    _paragrapheExplication(
      'Le temps du subjonctif de la subordonnée indirecte dépend :\n\n'
      '• du temps du verbe principal (temps du présent ou temps du '
      'passé) ;\n'
      '• du moment où l\'action de la subordonnée se situe par rapport '
      'à celle de la principale (antériorité, simultanéité, '
      'postériorité).',
    ),
    _paragrapheExplication(
      'Nota bene : pour exprimer la postériorité, le latin utilise une '
      'périphrase en -urus, a, um sim / essem. Ce « subjonctif futur » '
      'est utilisé uniquement dans l\'interrogation indirecte !',
    ),
    _tableauColonnes(
      ['rapport', 'principale au présent/futur', 'principale au passé'],
      [
        ['antériorité', 'subjonctif parfait', 'subjonctif plus-que-parfait'],
        ['simultanéité', 'subjonctif présent', 'subjonctif imparfait'],
        ['postériorité', 'périphrase en -urus sim', 'périphrase en -urus essem'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Ex. : Rogo quis venerit. (Je demande qui est venu.) Rogabam '
      'quis venisset. (Je demandais qui était venu.) Rogo quis '
      'venturus sit. (Je demande qui viendra.) Rogabam quis venturus '
      'esset. (Je demandais qui viendrait.)',
    ),
    _titreExplication('L\'exclamation indirecte'),
    _paragrapheExplication(
      'On peut trouver une subordonnée exclamative indirecte après des '
      'verbes comme « savoir, voir, s\'étonner, admirer »... Celle-ci '
      'fonctionne alors comme l\'interrogation indirecte.\n\n'
      'Quam pulcher est ! (Comme il est beau !) → Videte quam pulcher '
      'sit. (Voyez comme il est beau !) Quanta est audacia tua ! '
      '(Combien grande est ton audace !) → Miramur quanta sit audacia '
      'tua. (Nous admirons combien son audace est grande.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'À quel mode se met le verbe d\'une interrogation indirecte ?',
      options: ['le subjonctif', 'l\'indicatif', 'l\'infinitif', 'l\'impératif'],
      reponseCorrecte: 'le subjonctif',
    ),
    QuestionLecon(
      question: 'Par quels mots l\'interrogation indirecte est-elle introduite ?',
      options: [
        'les mêmes mots interrogatifs que l\'interrogation directe',
        'uniquement par si',
        'uniquement par num',
        'elle n\'a pas de mot introducteur'
      ],
      reponseCorrecte: 'les mêmes mots interrogatifs que l\'interrogation directe',
    ),
    QuestionLecon(
      question: 'Que règle l\'interrogation indirecte, en plus du mode et des mots introducteurs ?',
      options: ['la concordance des temps', 'l\'accord du participe', 'le genre du sujet', 'rien de plus'],
      reponseCorrecte: 'la concordance des temps',
    ),
    QuestionLecon(
      question: 'Quelle différence de sens y a-t-il entre num en interrogation directe et en interrogation indirecte ?',
      options: [
        'en indirecte, num n\'appelle plus de réponse négative, il est synonyme de -ne',
        'aucune différence',
        'num n\'existe qu\'en interrogation directe',
        'num devient une négation forte en indirecte'
      ],
      reponseCorrecte: 'en indirecte, num n\'appelle plus de réponse négative, il est synonyme de -ne',
    ),
    QuestionLecon(
      question: 'L\'interrogation double (utrum... an) peut-elle être indirecte ?',
      options: ['oui', 'non, jamais', 'seulement au passé', 'seulement avec num'],
      reponseCorrecte: 'oui',
    ),
    QuestionLecon(
      question: 'Comment traduit-on en français une interrogation indirecte introduite par un pronom neutre (quid) ?',
      options: ['en faisant précéder le pronom de « ce »', 'en omettant le pronom', 'en le traduisant par « qui »', 'cela ne se traduit pas'],
      reponseCorrecte: 'en faisant précéder le pronom de « ce »',
    ),
    QuestionLecon(
      question: 'Comment le latin exprime-t-il la postériorité dans une interrogation indirecte ?',
      options: ['par une périphrase en -urus, a, um sim/essem', 'par l\'indicatif futur', 'par le subjonctif présent seul', 'il ne peut pas l\'exprimer'],
      reponseCorrecte: 'par une périphrase en -urus, a, um sim/essem',
    ),
    QuestionLecon(
      question: 'Si le verbe principal est au passé et la subordonnée exprime la simultanéité, quel temps du subjonctif emploie-t-on ?',
      options: ['le subjonctif imparfait', 'le subjonctif présent', 'le subjonctif parfait', 'le subjonctif plus-que-parfait'],
      reponseCorrecte: 'le subjonctif imparfait',
    ),
    QuestionLecon(
      question: 'Après quels types de verbes trouve-t-on une exclamation indirecte, qui fonctionne comme l\'interrogation indirecte ?',
      options: ['savoir, voir, s\'étonner, admirer', 'les verbes de mouvement', 'les verbes déponents uniquement', 'les verbes impersonnels uniquement'],
      reponseCorrecte: 'savoir, voir, s\'étonner, admirer',
    ),
    ExerciceSaisie(
      question: 'Conjugue venire au subjonctif parfait, 3e pers. sg., dans Rogo quis ___ (« je demande qui est venu »).',
      reponsesAcceptees: ['venerit'],
    ),
    ExerciceSaisie(
      question: 'Quel mot latin, synonyme de -ne, introduit une interrogation indirecte totale (« si ») ?',
      reponsesAcceptees: ['num'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['rapport', 'principale présent/futur', 'principale passé'],
        [
          ['antériorité', 'subj. parfait', 'subj. plus-que-parfait'],
          ['simultanéité', 'subj. présent', 'subj. imparfait'],
          ['postériorité', '-urus sim', '-urus essem'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'Interrogative subordonnée au subjonctif, mêmes mots '
        'interrogatifs qu\'au style direct, concordance des temps. num '
        '= -ne (n\'appelle pas de réponse négative).',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Le discours indirect
// ------------------------------------------------------------

final Lecon _leconDiscoursIndirect = Lecon(
  id: 'discours_indirect',
  titre: 'Le discours indirect',
  sousTitre: 'Rapporter des paroles : ACI, interrogatives et ordres subordonnés au subjonctif',
  icone: Icons.record_voice_over,
  unite: 'Vol. III – Unité 8',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Le discours indirect rapporte les paroles de quelqu\'un sous '
      'forme de propositions subordonnées dépendant d\'un verbe à la '
      '3e personne signifiant dire, répondre, penser... Ce verbe peut '
      'être exprimé ou simplement suggéré par le contexte.\n\n'
      'Dixit : « Civis Romanus sum. » (Il a dit : « Je suis un citoyen '
      'romain. ») → Dixit se civem Romanum esse. (Il a dit qu\'il était '
      'un citoyen romain.)',
    ),
    _titreExplication('Les modes : du discours direct au discours indirect'),
    _paragrapheExplication(
      'Les propositions indépendantes ou principales du discours '
      'direct deviennent des propositions subordonnées de 1er degré '
      'dans le discours indirect :\n\n'
      '1. déclaratives → proposition infinitive (ACI)\n'
      '2. interrogatives → interrogative indirecte au subjonctif\n'
      '3. ordre et défense → subjonctif sans subordonnant (négation : '
      'ne)',
    ),
    _paragrapheExplication(
      'Les propositions déjà subordonnées dans le discours direct '
      'deviennent des propositions subordonnées de 2e degré :\n\n'
      '1. subordonnée relative ou conjonctive à l\'indicatif ou au '
      'subjonctif → subordonnée relative ou conjonctive au subjonctif\n'
      '2. ACI → ACI (pas de changement)\n'
      '3. participes et ablatif absolu → participes et ablatif absolu '
      '(pas de changement)',
    ),
    _titreExplication('Les temps : la concordance'),
    _paragrapheExplication(
      'La concordance des temps se fait par rapport au verbe dont '
      'dépend l\'ensemble du discours indirect.',
    ),
    _tableauColonnes(
      ['verbe introducteur', 'antériorité', 'simultanéité', 'postériorité (interr. ind.)'],
      [
        ['au présent (ou futur)', 'subjonctif parfait', 'subjonctif présent', '-urus, a, um sim'],
        ['au passé', 'subjonctif plus-que-parfait', 'subjonctif imparfait', '-urus, a, um essem'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Remarque : dans les subordonnées conditionnelles, on n\'emploie '
      'pas la périphrase en -urus, a, um sim/essem.',
    ),
    _paragrapheExplication(
      'Pour l\'ACI, quel que soit le verbe introducteur, on aura '
      'toujours :\n\n'
      '• pour l\'antériorité : un infinitif parfait\n'
      '• pour la simultanéité : un infinitif présent\n'
      '• pour la postériorité : un infinitif futur en -urum, am, um '
      'esse',
    ),
    _titreExplication('Les pronoms'),
    _paragrapheExplication(
      'Les pronom et adjectif réfléchis se et suus renvoient :\n\n'
      '• soit au sujet de la proposition dans laquelle ils se trouvent '
      '(réfléchi direct) ;\n'
      '• soit au sujet du verbe introducteur (réfléchi indirect).\n\n'
      'Le pronom ipse s\'emploie en cas d\'équivoque : si se, suus est '
      'réfléchi direct, ipse renvoie au sujet du verbe introducteur du '
      'discours indirect. Les pronoms is et ille renvoient aux autres '
      'personnes.',
    ),
    _paragrapheExplication(
      'Ex. : Ariovistus Romanis respondit : « Oportet me a vobis in '
      'jure meo non impediri. » (Ariovist répondit aux Romains : « Il '
      'convient que je ne sois pas gêné par vous dans l\'exercice de '
      'mon droit. ») → Ariovistus Romanis respondit oportere se ab '
      'illis in jure suo non impediri. (Ariovist répondit aux Romains '
      'qu\'il convenait qu\'il ne fût pas gêné par eux dans l\'exercice '
      'de son droit.)',
    ),
    _titreExplication('Bon à savoir'),
    _paragrapheExplication(
      '• L\'ACI a en général un sujet exprimé ; dans le discours '
      'indirect néanmoins, il n\'est pas toujours répété.\n\n'
      '• Même si le français emploie le style indirect beaucoup moins '
      'souvent que le latin, tu peux cependant le conserver dans la '
      'traduction française. Pour l\'alléger, évite de répéter la '
      'conjonction « que » après l\'avoir exprimée une première fois '
      '(style indirect libre).\n\n'
      '• Comme le latin dispose du réfléchi (se) et du non réfléchi '
      '(is, ille), il évite un certain nombre d\'équivoques. N\'hésite '
      'pas à remplacer un pronom par le nom qu\'il représente pour '
      'rendre ta traduction plus claire.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Comment se traduit une proposition déclarative du discours direct dans le discours indirect ?',
      options: ['par une proposition infinitive (ACI)', 'par une interrogative indirecte', 'par un subjonctif sans subordonnant', 'elle reste inchangée'],
      reponseCorrecte: 'par une proposition infinitive (ACI)',
    ),
    QuestionLecon(
      question: 'Comment se traduit une proposition interrogative du discours direct dans le discours indirect ?',
      options: ['par une interrogative indirecte au subjonctif', 'par une ACI', 'par un impératif', 'par un infinitif seul'],
      reponseCorrecte: 'par une interrogative indirecte au subjonctif',
    ),
    QuestionLecon(
      question: 'Comment se traduisent un ordre ou une défense du discours direct dans le discours indirect ?',
      options: ['par le subjonctif sans subordonnant (négation ne)', 'par l\'impératif, comme au style direct', 'par une ACI', 'par l\'indicatif futur'],
      reponseCorrecte: 'par le subjonctif sans subordonnant (négation ne)',
    ),
    QuestionLecon(
      question: 'Que deviennent les subordonnées relatives ou conjonctives déjà présentes dans le discours direct (« 2e degré ») ?',
      options: ['elles passent au subjonctif', 'elles restent à l\'indicatif', 'elles deviennent des ACI', 'elles disparaissent'],
      reponseCorrecte: 'elles passent au subjonctif',
    ),
    QuestionLecon(
      question: 'Un ACI ou un ablatif absolu déjà présents dans le discours direct changent-ils de forme au discours indirect ?',
      options: ['non, ils ne changent pas', 'oui, ils passent au subjonctif', 'oui, ils passent à l\'indicatif', 'ils disparaissent'],
      reponseCorrecte: 'non, ils ne changent pas',
    ),
    QuestionLecon(
      question: 'Par rapport à quel verbe se fait la concordance des temps du discours indirect ?',
      options: ['le verbe introducteur du discours indirect', 'le verbe le plus proche', 'toujours l\'indicatif présent', 'il n\'y a pas de concordance'],
      reponseCorrecte: 'le verbe introducteur du discours indirect',
    ),
    QuestionLecon(
      question: 'Dans l\'ACI du discours indirect, quel infinitif exprime toujours la postériorité, quel que soit le temps du verbe introducteur ?',
      options: ['l\'infinitif futur en -urum, am, um esse', 'l\'infinitif présent', 'l\'infinitif parfait', 'le supin'],
      reponseCorrecte: 'l\'infinitif futur en -urum, am, um esse',
    ),
    QuestionLecon(
      question: 'À quoi renvoient se et suus dans le discours indirect ?',
      options: [
        'au sujet de leur propre proposition (direct) ou au sujet du verbe introducteur (indirect)',
        'toujours au sujet du verbe introducteur uniquement',
        'toujours au sujet de leur propre proposition uniquement',
        'ils ne s\'emploient jamais dans le discours indirect'
      ],
      reponseCorrecte: 'au sujet de leur propre proposition (direct) ou au sujet du verbe introducteur (indirect)',
    ),
    QuestionLecon(
      question: 'Quel pronom lève l\'équivoque quand se/suus est déjà pris comme réfléchi direct, pour renvoyer au sujet du verbe introducteur ?',
      options: ['ipse', 'is', 'ille', 'hic'],
      reponseCorrecte: 'ipse',
    ),
    ExerciceSaisie(
      question: 'Complète : dans les subordonnées conditionnelles du discours indirect, on n\'emploie pas la périphrase en -urus, a, um ___/essem.',
      reponsesAcceptees: ['sim'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['discours direct', 'discours indirect'],
        [
          ['déclarative', 'ACI'],
          ['interrogative', 'interrogative indirecte (subj.)'],
          ['ordre / défense', 'subjonctif (négation ne)'],
          ['subordonnée déjà présente', 'passe au subjonctif (ACI inchangé)'],
        ],
      ),
      const SizedBox(height: 12),
      _paragrapheExplication(
        'se/suus = réfléchi (direct ou indirect) ; ipse lève '
        'l\'équivoque ; is/ille pour les autres personnes.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les pronoms-adjectifs indéfinis quisque, quicumque, quisquis
// ------------------------------------------------------------

final Lecon _leconQuisqueQuicumqueQuisquis = Lecon(
  id: 'quisque_quicumque_quisquis',
  titre: 'Les pronoms-adjectifs indéfinis quisque, quicumque, quisquis',
  sousTitre: '« chacun », « quiconque, tout homme qui », « qui que ce soit qui »',
  icone: Icons.groups,
  unite: 'Vol. III – Unité 8',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('1. quisque, quaeque, quidque/quodque'),
    _paragrapheExplication(
      'Faber est suae quisque fortunae. (Chacun est l\'artisan de sa '
      'propre fortune.) Res familiaris sua quemque delectat. (Son '
      'patrimoine charme chacun.) Num decimus quisque laudatus est ? '
      '(Est-ce que vraiment chaque dixième fut loué ?)',
    ),
    _paragrapheExplication(
      'Le pronom-adjectif quisque suit le modèle quis, quae, quid / '
      'qui, quae, quod, se traduit par « chacun, chacune » (pronom) ou '
      '« chaque » (adjectif), et s\'utilise dans un contexte '
      'syntaxique particulier qui requiert souvent une traduction '
      'française plus libre. On le trouve ainsi :\n\n'
      '• très rarement en tête de phrase ;\n'
      '• à côté des réfléchis se et suus ;\n'
      '• avec un superlatif ;\n'
      '• avec un adjectif ordinal ;\n'
      '• avec un pronom relatif ou interrogatif.',
    ),
    _paragrapheExplication(
      'Ex. : Fortissimum quemque fortuna juvat. (La fortune aide tous '
      'les plus courageux.) Octavus quisque tum quievit. (Un sur huit '
      'se reposa alors.) Quam quisque noverit artem, in hac se '
      'exerceat ! (Que chacun s\'exerce dans l\'art qu\'il connaît !)',
    ),
    _paragrapheExplication(
      'Dans les autres contextes syntaxiques et en début de '
      'proposition, on utilise le pronom-adjectif unusquisque, '
      'unaquaeque, unumquidque (ou unumquodque comme adjectif).',
    ),
    _titreExplication('2. quicumque, quaecumque, quodcumque'),
    _paragrapheExplication(
      'Quoscumque adit ex civitate ad suam sententiam perducit. (Tous '
      'ceux de la cité qu\'il aborde, il les rallie à son avis — '
      'César, De Bello Gallico, VII, 4.) Quicumque spectaculo aderat '
      'laetus erat. (Quiconque assistait au spectacle était content.) '
      'Quoscumque de te queri audivi, quacumque potui ratione placavi. '
      '(Tous ceux que j\'ai entendus se plaindre de toi, je les ai '
      'calmés par tous les moyens que j\'ai pu — Cicéron, Ad Quintum '
      'fratrem, I, 2, 4.)',
    ),
    _paragrapheExplication(
      'Quicumque, quaecumque, quodcumque :\n\n'
      '• est un relatif indéfini ;\n'
      '• n\'a pas d\'antécédent, comme pronom ;\n'
      '• comme pronom, se traduit par « tout homme qui, tous ceux qui, '
      'tout ce qui », « celui, quel qu\'il soit, qui » ou « quiconque '
      '» ;\n'
      '• comme adjectif, se traduit par « tout (homme) qui », « quel '
      'que soit (l\'homme) qui » ou « quel... que ».',
    ),
    _titreExplication('3. quisquis, quidquid/quicquid'),
    _paragrapheExplication(
      'Ille, quisquis erat, quem tu in crucem rapiebas... (Celui-là, '
      'quel qu\'il fût, que toi tu as traîné sur la croix... — '
      'Cicéron, In Verrem, II, 5, 164.) quoquo modo se res habet (de '
      'quelle manière que l\'affaire se porte — Cicéron, Ad Familiares, '
      'IX, 5.) Quicquid animo cernimus, id omne oritur a sensibus. '
      '(Tout ce que nous apercevons par l\'âme tire son origine des '
      'sens — d\'après Cicéron, De Finibus, I, 19, 64.)',
    ),
    _paragrapheExplication(
      'Quisquis a le même sens que quicumque, mais ne s\'emploie qu\'à '
      'certaines formes du singulier.\n\n'
      'Comme pronom : « quelque... que, qui que ce soit qui, tout '
      'homme qui, tout ce qui ». Comme adjectif : « quel... que, '
      'tout... qui ».',
    ),
    _titreExplication('Bon à savoir : les adverbes de lieu indéfinis'),
    _paragrapheExplication(
      'Les adverbes et adverbes relatifs de lieu peuvent également '
      'exprimer cette notion d\'indétermination.',
    ),
    _tableauColonnes(
      ['ubi ?', 'quo ?', 'unde ?', 'qua ?'],
      [
        ['ubique « partout »', '—', 'undique « de partout »', '—'],
        ['ubicumque « partout où »', 'quocumque = quoquo « (vers) partout où »', 'undecumque « de quelque endroit que »', 'quacumque « par quelque endroit que »'],
      ],
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Que signifie quisque, quaeque, quidque comme pronom ?',
      options: ['chacun, chacune', 'tout homme qui', 'qui que ce soit', 'quiconque'],
      reponseCorrecte: 'chacun, chacune',
    ),
    QuestionLecon(
      question: 'Dans quel contexte trouve-t-on le plus souvent quisque, à côté de quels mots ?',
      options: ['les réfléchis se et suus', 'les négations ne et non', 'les conjonctions de coordination', 'les prépositions de lieu'],
      reponseCorrecte: 'les réfléchis se et suus',
    ),
    QuestionLecon(
      question: 'Avec quel type de mot quisque s\'emploie-t-il aussi (comme fortissimum quemque) ?',
      options: ['un superlatif', 'un comparatif seul', 'une négation', 'un impératif'],
      reponseCorrecte: 'un superlatif',
    ),
    QuestionLecon(
      question: 'Quel pronom-adjectif utilise-t-on à la place de quisque en tête de phrase ou dans d\'autres contextes ?',
      options: ['unusquisque, unaquaeque, unumquidque', 'quicumque', 'quisquis', 'aliquis'],
      reponseCorrecte: 'unusquisque, unaquaeque, unumquidque',
    ),
    QuestionLecon(
      question: 'Que signifie quicumque, quaecumque, quodcumque comme pronom ?',
      options: ['tout homme qui, quiconque', 'chacun', 'quelqu\'un (inconnu)', 'un certain'],
      reponseCorrecte: 'tout homme qui, quiconque',
    ),
    QuestionLecon(
      question: 'Quicumque a-t-il un antécédent, employé comme pronom ?',
      options: ['non, il n\'a pas d\'antécédent', 'oui, toujours', 'seulement au pluriel', 'seulement au féminin'],
      reponseCorrecte: 'non, il n\'a pas d\'antécédent',
    ),
    QuestionLecon(
      question: 'Que signifie quisquis, quidquid/quicquid ?',
      options: ['le même sens que quicumque, mais limité à certaines formes du singulier', 'un sens totalement différent de quicumque', 'chacun', 'un certain'],
      reponseCorrecte: 'le même sens que quicumque, mais limité à certaines formes du singulier',
    ),
    QuestionLecon(
      question: 'Que signifie l\'adverbe ubicumque ?',
      options: ['partout où', 'de partout', 'nulle part', 'quelque part'],
      reponseCorrecte: 'partout où',
    ),
    QuestionLecon(
      question: 'Que signifie undecumque ?',
      options: ['de quelque endroit que', 'partout où', 'vers quelque endroit que', 'par quelque endroit que'],
      reponseCorrecte: 'de quelque endroit que',
    ),
    ExerciceSaisie(
      question: 'Quel pronom-adjectif indéfini latin signifie « chacun, chacune » ?',
      reponsesAcceptees: ['quisque'],
    ),
    ExerciceSaisie(
      question: 'Quel relatif indéfini latin signifie « quiconque, tout homme qui » ?',
      reponsesAcceptees: ['quicumque'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['mot', 'sens'],
        [
          ['quisque, quaeque, quidque/quodque', 'chacun, chacune / chaque'],
          ['quicumque, quaecumque, quodcumque', 'quiconque, tout homme qui'],
          ['quisquis, quidquid/quicquid', 'qui que ce soit qui (singulier)'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Cause réelle et cause alléguée / repoussée
// ------------------------------------------------------------

final Lecon _leconCauseReelleAllegueeRepoussee = Lecon(
  id: 'cause_reelle_alleguee_repoussee',
  titre: 'Cause réelle et cause alléguée / repoussée',
  sousTitre: 'quod/quia + indicatif (réel) ou + subjonctif (allégué, repoussé)',
  icone: Icons.fact_check,
  unite: 'Vol. III – Unité 9',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Taceo quod cogor. (Je me tais parce que j\'y suis forcé.) '
      'Taceo, non quod assentiar, sed quod cogor. (Je me tais, non que '
      'je sois d\'accord, mais parce que j\'y suis forcé.) Socrates '
      'accusatus est quod juvenes corrumperet. (Socrate fut accusé '
      'sous prétexte qu\'il corrompait les jeunes gens.)',
    ),
    _paragrapheExplication(
      'Quelle est la différence entre une cause exprimée dans une '
      'subordonnée à l\'indicatif et une cause exprimée dans une '
      'subordonnée au subjonctif ?',
    ),
    _paragrapheExplication(
      'Une cause dont on ne peut / veut affirmer la réalité, parce '
      'qu\'il s\'agit :\n\n'
      '• de la parole ou de la pensée d\'un tiers (discours indirect) '
      ';\n'
      '• d\'un prétexte allégué par quelqu\'un ;\n'
      '• d\'une cause envisageable, mais qui n\'est pas fondée,\n\n'
      'est appelée cause alléguée ou cause repoussée, et se met au '
      'subjonctif en latin.',
    ),
    _paragrapheExplication(
      'De même, en français, « non que » n\'exprime pas une cause '
      'réelle, mais une cause repoussée.\n\n'
      'Taceo, non quod assentiar, sed quod cogor. (Je me tais, non que '
      'je sois d\'accord, mais parce que j\'y suis forcé.)',
    ),
    _tableauColonnes(
      ['construction', 'sens'],
      [
        ['quod, quia + subjonctif', 'sous prétexte que + indicatif (/conditionnel) ; « parce que dit-il, disait-il, dis-tu... » + indicatif'],
        ['non quod / quia + subjonctif', 'non que + subjonctif'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Cicero Catilinam ejusque comites accusavit quod rem publicam '
      'turbavissent. (Cicéron accusa Catilina et ses complices sous '
      'prétexte qu\'ils avaient troublé la république.) Paucis post '
      'annis, Clodius, tribunus plebis, Ciceronem accusavit, quod '
      'cives Romanos injuria interfecisset. (Quelques années après, '
      'Clodius, tribun de la plèbe, accusa Cicéron sous prétexte qu\'il '
      'avait tué injustement des citoyens romains.)',
    ),
    _paragrapheExplication(
      'Nemo enim ipsam voluptatem, quia voluptas sit, aspernatur aut '
      'odit aut fugit, sed quia consequuntur magni dolores... '
      '(Personne, en effet, ne repousse, ne hait ou ne fuit le plaisir '
      'lui-même parce qu\'il serait le plaisir, mais parce que de '
      'grandes souffrances en résultent — Cicéron, De Finibus '
      'Bonorum et Malorum, I, 146.) Non expectant belli tempora moras, '
      'et pugnandum est interim non quia velis sed quia hostis cogit. '
      '(Les circonstances de la guerre n\'attendent pas de délais, et '
      'il faut combattre entre-temps, non parce que tu le voudrais, '
      'mais parce que l\'ennemi t\'y force — d\'après Tite-Live, Ab '
      'Urbe condita, XXXI, 48, 10.)',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'À quel mode se met une cause réelle, introduite par quod ou quia ?',
      options: ['l\'indicatif', 'le subjonctif', 'l\'infinitif', 'le participe'],
      reponseCorrecte: 'l\'indicatif',
    ),
    QuestionLecon(
      question: 'À quel mode se met une cause alléguée ou repoussée ?',
      options: ['le subjonctif', 'l\'indicatif', 'l\'impératif', 'le supin'],
      reponseCorrecte: 'le subjonctif',
    ),
    QuestionLecon(
      question: 'Quels types de causes sont exprimés au subjonctif (causes « alléguées » ou « repoussées ») ?',
      options: [
        'la parole/pensée d\'un tiers, un prétexte allégué, ou une cause envisageable mais non fondée',
        'uniquement les causes historiques certaines',
        'uniquement les causes exprimées par un nom',
        'toutes les causes, sans exception'
      ],
      reponseCorrecte: 'la parole/pensée d\'un tiers, un prétexte allégué, ou une cause envisageable mais non fondée',
    ),
    QuestionLecon(
      question: 'En français, quelle locution exprime une cause repoussée, et non une cause réelle ?',
      options: ['non que', 'parce que', 'puisque', 'comme'],
      reponseCorrecte: 'non que',
    ),
    QuestionLecon(
      question: 'Comment traduit-on quod/quia + subjonctif, exprimant une cause alléguée ?',
      options: ['sous prétexte que + indicatif', 'parce que + indicatif (cause certaine)', 'bien que + subjonctif', 'pourvu que + subjonctif'],
      reponseCorrecte: 'sous prétexte que + indicatif',
    ),
    QuestionLecon(
      question: 'Dans Socrates accusatus est quod juvenes corrumperet, pourquoi corrumperet est-il au subjonctif ?',
      options: [
        'car c\'est un prétexte allégué par les accusateurs, non une cause reconnue comme vraie par l\'auteur',
        'car c\'est une cause certaine et avérée',
        'car juvenes est au pluriel',
        'car corrumperet est un verbe déponent'
      ],
      reponseCorrecte: 'car c\'est un prétexte allégué par les accusateurs, non une cause reconnue comme vraie par l\'auteur',
    ),
    QuestionLecon(
      question: 'Dans Nemo... aspernatur... quia voluptas sit, sed quia consequuntur magni dolores, quelle cause est réelle (indicatif) selon Cicéron ?',
      options: [
        'quia consequuntur magni dolores (les grandes souffrances qui en résultent)',
        'quia voluptas sit (le plaisir lui-même)',
        'les deux causes sont réelles',
        'aucune des deux n\'est réelle'
      ],
      reponseCorrecte: 'quia consequuntur magni dolores (les grandes souffrances qui en résultent)',
    ),
    ExerciceSaisie(
      question: 'Quelle locution française, correspondant à non quod/quia + subjonctif, exprime une cause repoussée ?',
      reponsesAcceptees: ['non que'],
    ),
    ExerciceSaisie(
      question: 'À quel mode latin se met la cause quand elle est présentée comme un simple prétexte allégué ?',
      reponsesAcceptees: ['le subjonctif', 'subjonctif'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['cause', 'mode', 'exemple'],
        [
          ['réelle (assumée par l\'auteur)', 'indicatif', 'taceo quod cogor'],
          ['alléguée / repoussée', 'subjonctif', 'non quod assentiar, sed quod cogor'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Quelques particularités de l'accord
// ------------------------------------------------------------

final Lecon _leconParticularitesAccord = Lecon(
  id: 'particularites_accord',
  titre: 'Quelques particularités de l\'accord',
  sousTitre: 'Accord de proximité de l\'épithète, accord de l\'attribut, accord du verbe',
  icone: Icons.spellcheck,
  unite: 'Vol. III – Unité 9',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _titreExplication('1. L\'accord de l\'adjectif qualificatif'),
    _paragrapheExplication(
      'L\'adjectif qualificatif s\'accorde en genre, nombre et cas '
      'avec le nom auquel il se rapporte, et peut être épithète ou '
      'attribut.',
    ),
    _titreExplication('A. L\'adjectif épithète'),
    _paragrapheExplication(
      'L\'adjectif épithète précède le nom déterminé (ex. : novus '
      'amicus), sauf s\'il est possessif ou formé sur un nom propre '
      '(ex. : mare nostrum, senatus populusque Romanus).',
    ),
    _paragrapheExplication(
      'Employé comme épithète de plusieurs noms, un adjectif '
      'qualificatif ne s\'exprime qu\'une seule fois : il s\'accorde '
      'alors avec le nom le plus proche (accord de proximité), tandis '
      'qu\'en français, l\'adjectif s\'accorde au pluriel avec tous les '
      'noms coordonnés.\n\n'
      'Ex. : senatus populusque Romanus (littéralement « le sénat et '
      'le peuple romain » → le sénat et le peuple romains).',
    ),
    _tableauColonnes(
      ['langue', 'accord'],
      [
        ['latin (accord de proximité)', 'puella et puer Romanus / puella Romana et puer'],
        ['français (accord au pluriel)', 'la jeune fille et le garçon romains'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('B. L\'adjectif attribut'),
    _paragrapheExplication(
      'Contrairement à l\'adjectif épithète, l\'adjectif attribut de '
      'plusieurs noms s\'accorde avec l\'ensemble des noms déterminés '
      'et se met donc au pluriel :\n\n'
      '• si les noms sont du même genre, l\'adjectif attribut se met '
      'au masculin, féminin ou neutre pluriel selon le genre des noms '
      ';\n'
      '• si les noms sont de genres différents, l\'adjectif attribut '
      'est au masculin avec des noms de personnes (Pater materque sunt '
      'boni.), et au neutre avec des noms de choses (Domus et hortus '
      'sunt pulchra.).',
    ),
    _titreExplication('2. L\'accord du verbe avec son sujet'),
    _paragrapheExplication(
      'Bien qu\'il ait deux sujets, un verbe latin peut s\'accorder '
      'avec le sujet le plus proche (accord de proximité) si :\n\n'
      '• le verbe précède les sujets (Loquitur dominus et domina.) ;\n'
      '• le verbe n\'est précédé que d\'un seul des sujets (Pater '
      'venit atque mater.) ;\n'
      '• les sujets sont reliés par nec, aut, vel, -ve ou sive (Nec '
      'pater nec mater venit.) ;\n'
      '• les sujets désignent des éléments abstraits (Mores tempusque '
      'volat.).',
    ),
    _paragrapheExplication(
      'Si le verbe a plusieurs sujets au singulier sans ces '
      'conditions, il est le plus souvent au pluriel (Pater et mater '
      'sunt boni.). Si un verbe a pour sujet un nom singulier de sens '
      'collectif suivi d\'un complément au pluriel, le verbe peut '
      's\'accorder au singulier ou au pluriel (Turba militum ruit / '
      'ruunt.). Si les sujets d\'un même verbe ne sont pas à la même '
      'personne, l\'accord se fait comme en français (Ego et tu '
      'valemus.).',
    ),
    _tableauColonnes(
      ['langue', 'règle'],
      [
        ['français', 'accord du verbe en personne et nombre avec le/les sujet(s)'],
        ['latin', 'accord en personne et nombre avec le/les sujet(s), ou accord de proximité avec un sujet'],
      ],
    ),
    const SizedBox(height: 12),
    _paragrapheExplication(
      'Bon à savoir : en grec ancien, un neutre pluriel, considéré '
      'comme un collectif, a un accord verbal au singulier. Ex. : Les '
      'animaux courent. Τὰ ζῷα τρέχει.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Où se place normalement l\'adjectif épithète par rapport au nom qu\'il détermine ?',
      options: [
        'il le précède, sauf s\'il est possessif ou formé sur un nom propre',
        'il le suit toujours',
        'sa place est totalement libre, sans règle',
        'il précède toujours, sans exception'
      ],
      reponseCorrecte: 'il le précède, sauf s\'il est possessif ou formé sur un nom propre',
    ),
    QuestionLecon(
      question: 'Quand un adjectif épithète qualifie deux noms coordonnés, avec lequel s\'accorde-t-il en latin ?',
      options: ['le nom le plus proche (accord de proximité)', 'toujours le premier nom', 'il se met au pluriel comme en français', 'il ne s\'accorde avec aucun'],
      reponseCorrecte: 'le nom le plus proche (accord de proximité)',
    ),
    QuestionLecon(
      question: 'Comment se comporte un adjectif attribut de plusieurs noms, à la différence de l\'épithète ?',
      options: [
        'il s\'accorde avec l\'ensemble des noms et se met au pluriel',
        'il s\'accorde seulement avec le nom le plus proche, comme l\'épithète',
        'il reste toujours au singulier',
        'il disparaît'
      ],
      reponseCorrecte: 'il s\'accorde avec l\'ensemble des noms et se met au pluriel',
    ),
    QuestionLecon(
      question: 'Quand l\'adjectif attribut porte sur des noms de personnes de genres différents, à quel genre se met-il ?',
      options: ['au masculin', 'au féminin', 'au neutre', 'il reste au genre du nom le plus proche'],
      reponseCorrecte: 'au masculin',
    ),
    QuestionLecon(
      question: 'Quand l\'adjectif attribut porte sur des noms de choses de genres différents, à quel genre se met-il ?',
      options: ['au neutre', 'au masculin', 'au féminin', 'il n\'y a pas d\'accord possible'],
      reponseCorrecte: 'au neutre',
    ),
    QuestionLecon(
      question: 'Dans quel cas un verbe latin à deux sujets peut-il s\'accorder seulement avec le sujet le plus proche ?',
      options: [
        'si le verbe précède les sujets, ou n\'est précédé que d\'un seul, ou si les sujets sont reliés par nec/aut/vel/sive, ou abstraits',
        'uniquement si les deux sujets sont au pluriel',
        'jamais, l\'accord de proximité n\'existe pas pour le verbe',
        'uniquement à l\'impératif'
      ],
      reponseCorrecte: 'si le verbe précède les sujets, ou n\'est précédé que d\'un seul, ou si les sujets sont reliés par nec/aut/vel/sive, ou abstraits',
    ),
    QuestionLecon(
      question: 'Comment un nom singulier de sens collectif (comme turba) suivi d\'un complément au pluriel peut-il accorder son verbe ?',
      options: ['au singulier ou au pluriel', 'toujours au singulier uniquement', 'toujours au pluriel uniquement', 'il n\'a jamais de verbe'],
      reponseCorrecte: 'au singulier ou au pluriel',
    ),
    QuestionLecon(
      question: 'Si les sujets d\'un même verbe ne sont pas à la même personne (ego et tu), comment se fait l\'accord ?',
      options: ['comme en français (à la personne qui l\'emporte)', 'toujours à la 3e personne', 'accord de proximité uniquement', 'le verbe reste au singulier'],
      reponseCorrecte: 'comme en français (à la personne qui l\'emporte)',
    ),
    ExerciceSaisie(
      question: 'Comment appelle-t-on l\'accord d\'un adjectif épithète ou d\'un verbe avec le seul nom/sujet le plus proche ?',
      reponsesAcceptees: ['accord de proximité', 'proximité'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['fonction', 'accord avec 2+ noms coordonnés'],
        [
          ['adjectif épithète', 'accord de proximité (nom le plus proche)'],
          ['adjectif attribut', 'pluriel (masc. si personnes de genres mêlés, neutre si choses)'],
          ['verbe', 'pluriel, ou accord de proximité selon le contexte'],
        ],
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : L'aspect du verbe
// ------------------------------------------------------------

final Lecon _leconAspectDuVerbe = Lecon(
  id: 'aspect_du_verbe',
  titre: 'L\'aspect du verbe',
  sousTitre: 'Linéaire (duratif, itératif, conatif), ponctuel (inchoatif, terminatif), résultatif',
  icone: Icons.timeline,
  unite: 'Vol. III – Unité 9',
  uniteRecommandees: _unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    _paragrapheExplication(
      'Tu as abordé jusque-là les notions verbales de temps (passé, '
      'présent ou futur), de concordance des temps (antériorité, '
      'simultanéité ou postériorité), de mode (indicatif, subjonctif, '
      'etc.) ou de voix (actif, passif ou déponent).',
    ),
    _paragrapheExplication(
      'Pour bien saisir toutes les nuances du système verbal latin, il '
      'convient de s\'intéresser également à l\'aspect du verbe. Il '
      's\'agit de la façon dont on envisage le procès exprimé par le '
      'verbe : procès en cours, entamé, achevé, itératif, etc. Ces '
      'notions sont encore perceptibles en latin classique, notamment '
      'aux temps du passé où apparaît clairement l\'opposition entre '
      'infectum et perfectum.',
    ),
    _titreExplication('1. L\'action peut être linéaire'),
    _paragrapheExplication(
      'Elle s\'étend sur une période de temps. Dans ce cas, elle peut '
      'être durative (elle dure encore / perdure), itérative (elle est '
      'répétée) ou conative (elle est tentée). Ces valeurs aspectuelles '
      'peuvent être exprimées par les temps formés sur le radical de '
      'l\'infectum, et se trouvent souvent à l\'imparfait ou au '
      'passif :',
    ),
    _tableauColonnes(
      ['forme', 'sens', 'aspect'],
      [
        ['edebam', 'je mangeais = j\'étais en train de manger', 'duratif'],
        ['vocabam', 'j\'appelais = j\'appelais encore et encore', 'itératif'],
        ['componebam', 'je disposais = je tentais de disposer', 'conatif'],
        ['januae aperiuntur', 'les portes sont ouvertes = on est en train de les ouvrir', 'linéaire'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('2. L\'action peut être ponctuelle'),
    _paragrapheExplication(
      'Elle correspond à un moment précis et ponctuel de l\'axe du '
      'temps. Dans ce cas, elle peut être inchoative (elle commence) '
      'ou effective/terminative (elle est achevée). Ces valeurs '
      'aspectuelles peuvent être exprimées par les temps formés sur le '
      'radical du perfectum, et se trouvent notamment au parfait :',
    ),
    _tableauColonnes(
      ['forme', 'sens', 'aspect'],
      [
        ['rex factus est', 'il est devenu roi', 'inchoatif'],
        ['vocavi', 'j\'ai appelé', 'effectif / terminatif'],
        ['vixit', 'il a vécu = il est mort', 'terminatif'],
        ['dixi', 'j\'ai dit = j\'ai fini de parler', 'terminatif'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('3. L\'action peut être résultative'),
    _paragrapheExplication(
      'L\'action est achevée au passé, mais le résultat de l\'action '
      'perdure.',
    ),
    _tableauColonnes(
      ['forme', 'sens'],
      [
        ['novi', 'j\'ai appris à connaître = je sais'],
        ['noveram', 'j\'avais appris à connaître = je savais'],
        ['consuevi', 'j\'ai pris l\'habitude = j\'ai l\'habitude'],
        ['odi', 'j\'ai pris en haine = je hais'],
        ['memini', 'je me suis rappelé = je me souviens'],
        ['januae apertae sunt', 'les portes ont été ouvertes = les portes sont ouvertes'],
      ],
    ),
    const SizedBox(height: 12),
    _titreExplication('Exemples d\'analyse'),
    _paragrapheExplication(
      'Gallia est omnis divisa in partes tres... (César, De bello '
      'Gallico, I, 1) — divisa est : sens résultatif ; appellantur : '
      'présent de vérité générale.\n\n'
      'Odi profanum vulgus et arceo. (Horace, Carmina, III, 1) — odi : '
      'sens résultatif ; arceo : linéaire et itératif (il la tient '
      'toujours à l\'écart) ou conatif (il tente de la tenir à '
      'l\'écart).\n\n'
      'Lucius Thorius Balbus fuit, Lanuvinus, quem meminisse tu non '
      'potes. (Cicéron, De Finibus Bonorum et Malorum, II, 20, 63) — '
      'fuit : ponctuel, terminatif (ce personnage ne vit plus au '
      'moment où Cicéron parle de lui) ; meminisse : résultatif.',
    ),
  ],
  exercices: const [
    QuestionLecon(
      question: 'Qu\'est-ce que l\'aspect du verbe, par opposition au temps ?',
      options: [
        'la façon dont on envisage le déroulement du procès (en cours, achevé, répété...)',
        'le moment où l\'action se situe (passé, présent, futur)',
        'la personne qui fait l\'action',
        'la voix active ou passive'
      ],
      reponseCorrecte: 'la façon dont on envisage le déroulement du procès (en cours, achevé, répété...)',
    ),
    QuestionLecon(
      question: 'Sur quel radical les valeurs aspectuelles linéaires (duratif, itératif, conatif) sont-elles souvent exprimées ?',
      options: ['le radical de l\'infectum', 'le radical du perfectum', 'le radical du supin', 'le radical du participe futur'],
      reponseCorrecte: 'le radical de l\'infectum',
    ),
    QuestionLecon(
      question: 'Que signifie l\'aspect « conatif » ?',
      options: ['l\'action est tentée', 'l\'action est répétée', 'l\'action dure encore', 'l\'action est achevée'],
      reponseCorrecte: 'l\'action est tentée',
    ),
    QuestionLecon(
      question: 'Que signifie l\'aspect « itératif » ?',
      options: ['l\'action est répétée', 'l\'action commence', 'l\'action est tentée', 'l\'action est achevée avec résultat'],
      reponseCorrecte: 'l\'action est répétée',
    ),
    QuestionLecon(
      question: 'Sur quel radical les valeurs aspectuelles ponctuelles (inchoatif, terminatif) sont-elles souvent exprimées ?',
      options: ['le radical du perfectum', 'le radical de l\'infectum', 'le radical du présent', 'le radical du gérondif'],
      reponseCorrecte: 'le radical du perfectum',
    ),
    QuestionLecon(
      question: 'Que signifie l\'aspect « inchoatif » ?',
      options: ['l\'action commence', 'l\'action est achevée', 'l\'action se répète', 'l\'action perdure'],
      reponseCorrecte: 'l\'action commence',
    ),
    QuestionLecon(
      question: 'Que signifie odi (parfait de « prendre en haine »), d\'aspect résultatif ?',
      options: ['je hais (état résultant d\'une action passée)', 'je vais haïr', 'je hais peu à peu', 'j\'ai cessé de haïr'],
      reponseCorrecte: 'je hais (état résultant d\'une action passée)',
    ),
    QuestionLecon(
      question: 'Que signifie memini, d\'aspect résultatif ?',
      options: ['je me souviens', 'je me rappellerai', 'j\'oublie', 'je me suis rappelé récemment seulement'],
      reponseCorrecte: 'je me souviens',
    ),
    QuestionLecon(
      question: 'Dans vixit (« il a vécu »), quel double sens l\'aspect terminatif peut-il suggérer ?',
      options: ['il a vécu = il est mort (la vie est achevée)', 'il vit encore', 'il va vivre', 'il vivait autrefois, sans plus de précision'],
      reponseCorrecte: 'il a vécu = il est mort (la vie est achevée)',
    ),
    ExerciceSaisie(
      question: 'Quel terme désigne l\'aspect d\'une action achevée au passé mais dont le résultat perdure (comme novi, « je sais ») ?',
      reponsesAcceptees: ['résultatif', 'résultative'],
    ),
  ],
  fiche: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _tableauColonnes(
        ['aspect', 'valeurs', 'radical'],
        [
          ['linéaire', 'duratif, itératif, conatif', 'infectum (souvent imparfait)'],
          ['ponctuel', 'inchoatif, effectif/terminatif', 'perfectum (souvent parfait)'],
          ['résultatif', 'action passée, résultat présent', 'perfectum (novi, odi, memini)'],
        ],
      ),
    ],
  ),
);

final List<Lecon> parcoursLeconsGrammaire = [
  // Unité 1
  _leconFonctionsPhrase,
  _leconCasIntro,
  _leconDeclinaison1,
  _leconVerbeEtre,
  _leconOrdreMots,
  _leconMethodeAnalyse,
  // Unité 2, 3, ... (garder ces leçons groupées par unité : le chemin
  // affiche un séparateur à chaque changement d'unité, donc les leçons
  // d'une même unité doivent rester contiguës dans cette liste).
  _leconPhraseSimpleComplexe,
  _leconDeclinaison2,
  _leconConjonctions,
  // Unité 3
  _leconNeutre2eDecl,
  _leconAdjectifs1reClasse,
  _leconVerbeLatin,
  // Unité 4
  _leconEsseComposes,
  _leconInterrogationSimple,
  // Unité 5
  _leconImparfaitActif,
  _leconACI,
  // Unité 6
  _leconEmploisEsse,
  _leconVoixPassive,
  _leconPassifFrancais,
  // Unité 7
  _leconDeclinaison3,
  _leconIndicatifParfait,
  _leconInfinitifParfaitACI,
  // Unité 8
  _leconAdjectifs2eClasse,
  _leconParticipePresentActif,
  _leconComparatifSuperlatif,
  // Unité 9
  _leconSupinPPP,
  _leconAblatifAbsolu,
  _leconTechniqueTraductionAA,
  // Unité 10
  _leconPronomIsEaId,
  _leconPronomRelatif,
  _leconEmploisRelatif,
  // Vol. II – Unité 1
  _leconIndicatifFutur,
  _leconFuturAnterieurPPF,
  _leconSubordonneeConditionnelleIndicatif,
  // Vol. II – Unité 2
  _leconDemonstratifsHicIsteIlle,
  _leconCCTemps,
  _leconCCLieu,
  // Vol. II – Unité 3
  _leconDeclinaison4,
  _leconPronomIdem,
  _leconPronomIpse,
  // Vol. II – Unité 4
  _leconInterrogatifsExclamatifs,
  _leconParticipeInfinitifFuturs,
  // Vol. II – Unité 5
  _leconPronomsPersonnelsPossessifs,
  _leconReflechisDirectIndirect,
  _leconAdjectifsNumeraux,
  // Vol. II – Unité 6
  _leconDeclinaison5,
  _leconSubjonctifPresentImparfait,
  _leconCompletivesSubjonctif,
  // Vol. II – Unité 7
  _leconUnusSolusTotusNullus,
  _leconNemoNihil,
  _leconNegationCoordinationSubordination,
  _leconFerreComposes,
  // Vol. II – Unité 8
  _leconSubjonctifParfaitPlusQueParfait,
  _leconSubordonneesBut,
  _leconSubordonneesConsequence,
  // Vol. II – Unité 9
  _leconIreComposes,
  _leconRappelPrefixesComposes,
  _leconAliusAlterUter,
  // Vol. II – Unité 10
  _leconImperatif,
  _leconVelleNolleMalle,
  _leconOrdreDefense,
  // Vol. III – Unité 1
  _leconTempsParfaitPassif,
  _leconFieri,
  _leconConjonctionDum,
  // Vol. III – Unité 2
  _leconPassifsPersonnelImpersonnelNCI,
  _leconIndefinisQuidamAliquisQuis,
  _leconComparaisonDeDeux,
  // Vol. III – Unité 3
  _leconVerbesDeponents,
  _leconAdverbesManiereQuam,
  _leconAdjectifsRaresInusites,
  // Vol. III – Unité 4
  _leconSystemesConditionnels,
  _leconSubjonctifPropositionsPrincipales,
  _leconDoubleDatif,
  // Vol. III – Unité 5
  _leconSubordonneesRelativesComplements,
  _leconComplementsProvenanceSeparationQualite,
  // Vol. III – Unité 6
  _leconGerondif,
  _leconAdjectifVerbalObligation,
  _leconVerbesImpersonnels,
  // Vol. III – Unité 7
  _leconConcession,
  _leconComparaisonSubordonnee,
  // Vol. III – Unité 8
  _leconInterrogationIndirecte,
  _leconDiscoursIndirect,
  _leconQuisqueQuicumqueQuisquis,
  // Vol. III – Unité 9
  _leconCauseReelleAllegueeRepoussee,
  _leconParticularitesAccord,
  _leconAspectDuVerbe,
];

List<Lecon> construireParcoursComplet() => parcoursLeconsGrammaire;

