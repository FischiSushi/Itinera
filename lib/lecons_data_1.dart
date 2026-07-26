import 'package:flutter/material.dart';

import 'grammaire_tableaux_data.dart';
import 'lecons_core.dart';
import 'main.dart';
import 'screens/declinaisons_screen.dart' show tableauDeclinaison;
import 'screens/grammaire_screen.dart' show tableauConjugaison, tableauImparfait;

// ------------------------------------------------------------
// Leçon 1 : Qu'est-ce qu'un cas ?
// ------------------------------------------------------------

final Lecon leconCasIntro = Lecon(
  id: 'cas_intro',
  titre: 'Qu\'est-ce qu\'un cas ?',
  sousTitre: 'Nominatif, accusatif, génitif, datif, ablatif',
  icone: Icons.help_outline,
  uniteRecommandees: unitesRecommandeesTranche(0, 8),
  explication: (context) => [
    paragrapheExplication(
      'En français, c\'est l\'ordre des mots qui indique qui fait quoi.\n'
      '« Le loup mange l\'agneau » ne veut pas dire la même chose que '
      '« L\'agneau mange le loup ».',
    ),
    paragrapheExplication(
      'En latin, ce n\'est pas la position du mot qui compte, mais sa '
      'terminaison (la fin du mot). Chaque terminaison indique le rôle '
      'du mot dans la phrase : sujet, complément, possession...\n\n'
      'Cette terminaison s\'appelle un cas. Changer les terminaisons '
      's\'appelle décliner un mot, et l\'ensemble de ses terminaisons '
      'possibles s\'appelle sa déclinaison.',
    ),
    paragrapheExplication(
      'C\'est pourquoi l\'ordre des mots est très libre en latin : '
      '« Lupus agnum vorat » et « Agnum lupus vorat » veulent dire '
      'exactement la même chose (Le loup dévore l\'agneau), grâce aux '
      'terminaisons -us et -um.',
    ),
    titreExplication('Les cas et leur rôle'),
    tableauRolesCas([
      ['Nominatif', 'le sujet, qui fait l\'action', 'qui est-ce qui ?'],
      ['Vocatif', 'pour appeler quelqu\'un', 'ô ... !'],
      ['Accusatif', 'le complément d\'objet direct', 'qui ? quoi ?'],
      ['Génitif', 'la possession', 'de qui ? de quoi ?'],
      ['Datif', 'le complément d\'objet indirect', 'à qui ? à quoi ?'],
      ['Ablatif', 'le moyen, la manière, le lieu', 'par/avec/dans quoi ?'],
    ]),
    titreExplication('Un même mot, tous les cas'),
    paragrapheExplication(
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
        paragrapheExplication(
          'En français, c\'est l\'ordre des mots qui indique qui fait quoi.\n'
          '« Le loup mange l\'agneau » ne veut pas dire la même chose que '
          '« L\'agneau mange le loup ».',
        ),
      ],
    ),
    EtapeTexte(
      (context) => [
        paragrapheExplication(
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
        paragrapheExplication(
          'C\'est pourquoi l\'ordre des mots est très libre en latin : '
          '« Lupus agnum vorat » et « Agnum lupus vorat » veulent dire '
          'exactement la même chose (Le loup dévore l\'agneau), grâce aux '
          'terminaisons -us et -um.',
        ),
      ],
    ),
    EtapeTexte(
      (context) => [
        titreExplication('Les cas et leur rôle'),
        tableauRolesCas([
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
        titreExplication('Un même mot, tous les cas'),
        paragrapheExplication(
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
  fiche: (context) => tableauRolesCas([
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

final Lecon leconDeclinaison1 = Lecon(
  id: 'decl_1',
  titre: '1ère déclinaison',
  sousTitre: 'puella, -ae — les mots en -a',
  icone: Icons.looks_one,
  uniteRecommandees: unitesRecommandeesTranche(8, 16),
  explication: (context) => [
    paragrapheExplication(
      'Maintenant que tu connais le rôle de chaque cas, voici comment ils '
      's\'expriment concrètement.\n\n'
      'Les noms latins se répartissent en 5 groupes de terminaisons, '
      'appelés déclinaisons. La 1ère déclinaison regroupe surtout des noms '
      'féminins terminés par -a au nominatif singulier, comme puella '
      '(la jeune fille).',
    ),
    titreExplication('Les terminaisons'),
    tableauDeclinaison(declinaisons[0]),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Le génitif singulier (ici puellae) permet toujours de reconnaître '
      'la déclinaison d\'un mot : c\'est pourquoi le dictionnaire indique '
      'toujours les deux formes, « puella, -ae ».',
    ),
  ],
  etapes: [
    EtapeTexte(
      (context) => [
        paragrapheExplication(
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
        titreExplication('Les terminaisons'),
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
        paragrapheExplication(
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

final Lecon leconDeclinaison2 = Lecon(
  id: 'decl_2',
  titre: '2e déclinaison',
  sousTitre: 'dominus / bellum / puer / ager / vir',
  icone: Icons.looks_two,
  unite: 'Vol. I – Unité 2',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'La 2e déclinaison regroupe deux groupes principaux :\n'
      '• les masculins en -us, comme dominus, -i (le maître)\n'
      '• les neutres en -um, comme bellum, -i (la guerre)',
    ),
    titreExplication('Masculin (dominus)'),
    tableauDeclinaison(declinaisons[1]),
    const SizedBox(height: 16),
    titreExplication('Neutre (bellum)'),
    tableauDeclinaison(declinaisons[2]),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Règle importante à retenir pour TOUS les neutres, à toutes les '
      'déclinaisons : le nominatif, le vocatif et l\'accusatif sont '
      'toujours identiques. Et au pluriel, ces trois cas se terminent '
      'toujours par -a.',
    ),
    titreExplication('Les noms et adjectifs en -er'),
    paragrapheExplication(
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
    titreExplication('puer, pueri'),
    tableauDeclinaison(declinaisons[9]),
    const SizedBox(height: 16),
    titreExplication('ager, agri (radical qui perd son -e-)'),
    tableauDeclinaison(declinaisons[10]),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Les adjectifs suivent le même schéma : miser, mísera, míserum '
      '(malheureux) se décline comme puer ; pulcher, pulchra, pulchrum '
      '(beau) et sacer, sacra, sacrum (sacré) se déclinent comme ager, '
      'mais seulement au masculin — le féminin (pulchra) et le neutre '
      '(pulchrum) suivent leurs déclinaisons habituelles (1re et 2e '
      'neutre), sans perdre de -e-, puisqu\'il n\'y en avait pas.',
    ),
    titreExplication('vir, viri — une exception à part'),
    tableauDeclinaison(declinaisons[11]),
    paragrapheExplication(
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

final Lecon leconPhraseSimpleComplexe = Lecon(
  id: 'phrase_simple_complexe',
  titre: 'La phrase simple et complexe',
  sousTitre: 'Juxtaposition, coordination, subordination',
  icone: Icons.call_split,
  unite: 'Vol. I – Unité 2',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'La phrase est l\'unité maximale de l\'analyse grammaticale : elle '
      'commence par une majuscule et se termine par une ponctuation '
      'forte (. ! ?). Son pivot est le verbe : une phrase contient au '
      'moins un verbe conjugué, mais elle peut en comporter plusieurs. '
      'Chaque partie de la phrase qui contient un verbe conjugué '
      's\'appelle une proposition.',
    ),
    titreExplication('La phrase simple'),
    paragrapheExplication(
      'Une phrase simple ne contient qu\'un seul verbe conjugué : c\'est '
      'une proposition indépendante à elle seule.\n\n'
      'Ex. : Puella cantat. (La jeune fille chante.) → 1 phrase simple.',
    ),
    titreExplication('La phrase complexe'),
    paragrapheExplication(
      'Une phrase complexe contient au moins deux verbes conjugués, donc '
      'au moins deux propositions. Elles peuvent être reliées de trois '
      'façons :',
    ),
    paragrapheExplication(
      '1. Par juxtaposition : les propositions sont simplement placées '
      'l\'une à côté de l\'autre, séparées par une virgule, un '
      'point-virgule ou deux-points, sans mot de liaison.\n'
      'Ex. : Puella cantat, puer ludit. (La jeune fille chante, le '
      'garçon joue.)',
    ),
    paragrapheExplication(
      '2. Par coordination : les propositions sont reliées par une '
      'conjonction de coordination (mais, ou, et, donc, or, ni, car — en '
      'latin, notamment et, -que, nec/neque).\n'
      'Ex. : Dominus servum vocat et servus venit. (Le maître appelle '
      'l\'esclave et l\'esclave vient.)',
    ),
    paragrapheExplication(
      '3. Par subordination : une proposition (la subordonnée) dépend '
      'd\'une autre (la principale) et ne peut pas exister seule, '
      'introduite par une conjonction de subordination (quand, parce '
      'que, puisque...). Tu apprendras les conjonctions de subordination '
      'latines plus tard dans ton apprentissage.',
    ),
    titreExplication('Une curiosité : la scriptio continua'),
    paragrapheExplication(
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
  fiche: (context) => paragrapheExplication(
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

final Lecon leconConjonctions = Lecon(
  id: 'conj_et_que',
  titre: 'Les conjonctions et, -que, neque',
  sousTitre: 'Coordonner deux mots, groupes ou propositions',
  icone: Icons.link,
  unite: 'Vol. I – Unité 2',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Les conjonctions de coordination unissent des mots, des groupes '
      'de mots ou des propositions de même nature et de même fonction.',
    ),
    titreExplication('L\'union sans négation : et / -que'),
    paragrapheExplication(
      'et se place avant le second élément coordonné, comme en français.\n'
      'Ex. : dominus et filius (le maître et le fils).\n\n'
      '-que est enclitique : il se soude à la fin du premier mot de '
      'l\'élément qu\'il coordonne (jamais au premier élément de la '
      'phrase).\n'
      'Ex. : dominus filiusque (le maître et le fils).',
    ),
    titreExplication('L\'union avec négation : neque / nec'),
    paragrapheExplication(
      '« et ... ne ... pas » se dit toujours neque (ou nec) : l\'emploi '
      'de non après et ou -que est incorrect en latin. On trouve le plus '
      'souvent neque devant une voyelle, nec devant une consonne.\n'
      'Ex. : Dormit nec servos audit. (Il dort et n\'entend pas les '
      'esclaves.)\n\n'
      'nec/neque ... nec/neque ... signifie « ni ... ni ... ne ».\n'
      'Ex. : Nec dominus neque amicus venit. (Ni le maître ni l\'ami ne '
      'viennent.)',
    ),
    titreExplication('Coordonner trois éléments ou plus'),
    paragrapheExplication(
      'Dans une énumération de plusieurs termes (3 ou plus), on peut '
      'utiliser et ou -que :\n'
      '• et se répète devant chaque terme coordonné ;\n'
      '• -que se soude uniquement au dernier terme et ne se répète pas.\n'
      'Ex. : dominus et filius et servus = dominus, filius servusque '
      '(le maître, le fils et l\'esclave).',
    ),
    titreExplication('Insistance : et... et...'),
    paragrapheExplication(
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
  fiche: (context) => paragrapheExplication(
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

final Lecon leconFonctionsPhrase = Lecon(
  id: 'fonctions_phrase',
  titre: 'Les fonctions dans la phrase',
  sousTitre: 'Sujet, COD, COI, CN, compléments circonstanciels...',
  icone: Icons.account_tree_outlined,
  explication: (context) => [
    paragrapheExplication(
      'Avant de décliner un mot, il faut savoir quel rôle — quelle '
      'fonction — il joue dans la phrase. C\'est ce rôle qui déterminera '
      'plus tard son cas en latin.',
    ),
    titreExplication('Les fonctions liées au verbe'),
    paragrapheExplication(
      'Le verbe est le point de départ de l\'analyse : il exprime '
      'l\'action. Pour que la phrase ait un sens, il manque deux '
      'informations :\n\n'
      '• le sujet : qui fait l\'action ? Le sujet détermine la '
      'terminaison du verbe.\n'
      'Ex. : L\'ennemi tombe. / Les ennemis tombent. / Nous tombons.\n\n'
      '• l\'objet : sur qui ou sur quoi s\'applique l\'action ? '
      'L\'objet complète le verbe, il dépend de lui.',
    ),
    paragrapheExplication(
      'Il existe deux types de compléments d\'objet :\n\n'
      '• le complément d\'objet direct (COD), rattaché directement au '
      'verbe (voir qqn / voir qqch) ;\n'
      '• le complément d\'objet indirect (COI), rattaché « indirectement » '
      'au verbe par les prépositions « à » ou « de » (penser à qqn / à '
      'qqch). En latin, on considère aussi la préposition « pour » : '
      '« pour qui », « dans l\'intérêt de qui » l\'action est faite.',
    ),
    titreExplication('Cas particulier : l\'apostrophe'),
    paragrapheExplication(
      'L\'apostrophe désigne la personne (ou la chose) à laquelle on '
      's\'adresse. On la trouve donc avec des verbes à l\'impératif ou à '
      'la 2e personne.\n\n'
      'Ex. : Marcus, écoute le maître ! / Venez, les enfants !',
    ),
    titreExplication('Cas particulier : l\'attribut du sujet'),
    paragrapheExplication(
      'Compare : « Publius chante une chanson » (une chanson = COD) et '
      '« Publius est chanteur » (chanteur = attribut du sujet).\n\n'
      'L\'attribut du sujet exprime une caractéristique du sujet. Il est '
      'rattaché au sujet par l\'intermédiaire du verbe « être » et de '
      'verbes comme « paraître, sembler, demeurer, rester, naître, '
      'vivre, devenir, mourir, tomber (amoureux, malade) ». Ces verbes '
      'sont appelés verbes attributifs.',
    ),
    titreExplication('Une fonction liée au nom : le complément du nom (CN)'),
    paragrapheExplication(
      'Ex. : Le livre de Pierre a disparu. → le livre de qui ? de Pierre.\n\n'
      'Le complément du nom « complète » un nom. Il se rattache le plus '
      'souvent au nom par la préposition « de ». Il marque principalement '
      'l\'appartenance.',
    ),
    titreExplication(
      'Des fonctions « libres » : les compléments circonstanciels',
    ),
    paragrapheExplication(
      'Ces fonctions indiquent les circonstances de l\'action :\n\n'
      '• CCT (temps) — quand ? Ex. : Tullia part le matin.\n'
      '• CCL (lieu) — où ? Ex. : Tullia reste à la maison.\n'
      '• CCM (manière) — comment ? Ex. : Quintus travaille bien.\n'
      '• CCC (cause) — pourquoi ? Ex. : Quintus pleure parce qu\'il a mal.\n'
      '• CC de moyen — avec quoi ? au moyen de quoi ? Le moyen est '
      'toujours un être inanimé (une chose), introduit par : au moyen '
      'de, de, grâce à, par, avec.',
    ),
    titreExplication('Cas particulier : l\'apposition'),
    paragrapheExplication(
      'Ex. : Rome, la capitale de l\'Italie, est une ville magnifique. '
      '→ Rome = la capitale (de l\'Italie).\n\n'
      'L\'apposition se rattache à un nom auquel elle apporte une '
      'information supplémentaire. L\'apposition et le nom indiquent la '
      'même réalité, et ont donc la même fonction — et en latin, le même '
      'cas.',
    ),
    titreExplication('Fonction ↔ cas en latin'),
    paragrapheExplication(
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
  fiche: (context) => tableauRolesCas([
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

final Lecon leconVerbeEtre = Lecon(
  id: 'verbe_etre',
  titre: 'Le verbe être : sum, es, est...',
  sousTitre: 'Indicatif et infinitif présents, emplois de esse',
  icone: Icons.psychology_outlined,
  explication: (context) => [
    titreExplication('Le sujet du verbe'),
    paragrapheExplication(
      'Sauf pour insister, le latin ne connaît pas de pronom personnel '
      'sujet, puisque les terminaisons -o/m, -s, -t, -mus, -tis, -nt '
      'renseignent déjà sur la personne.\n\n'
      'Ex. : Cogito, ergo sum. → Je pense, donc je suis.\n'
      'Boni discipuli estis. → Vous êtes de bons élèves.\n\n'
      'MAIS, pour insister :\n'
      'Ego in Italiā fui. → Moi, j\'ai été en Italie.\n'
      'Vos bene laboratis. → Vous, vous travaillez bien.',
    ),
    titreExplication('Indicatif et infinitif présents de esse'),
    paragrapheExplication(
      'sum, es, est, sumus, estis, sunt — je suis, tu es, il/elle est, '
      'nous sommes, vous êtes, ils/elles sont.\n\n'
      'Infinitif présent : esse (« être »).\n\n'
      'Dans le lexique, esse se présente sous cette forme, avec ses '
      'temps primitifs : sum, es, esse, fui, – « être ».',
    ),
    titreExplication('Les emplois de esse'),
    paragrapheExplication(
      '1. En général, le verbe esse est accompagné d\'un attribut du '
      'sujet et se traduit par « être ».\n'
      'Ex. : Puella est pulchra. (La jeune fille est belle.)\n'
      'Gallia est magna. (La Gaule est grande.)\n'
      'Vesta dea est. (Vesta est une déesse.)',
    ),
    paragrapheExplication(
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
      titreExplication('Indicatif présent de esse'),
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
      paragrapheExplication(
        'Infinitif présent : esse (« être »).\n'
        'Temps primitifs (lexique) : sum, es, esse, fui.',
      ),
      paragrapheExplication(
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

final Lecon leconOrdreMots = Lecon(
  id: 'ordre_mots',
  titre: 'La place des mots dans la phrase latine',
  sousTitre: 'Un ordre libre, mais pas anarchique',
  icone: Icons.swap_horiz,
  explication: (context) => [
    paragrapheExplication(
      'L\'ordre des mots en latin est libre, dans des limites bien '
      'définies. En effet, le latin regroupe souvent les mots ayant un '
      'lien grammatical et logique. Voici les regroupements les plus '
      'usuels :',
    ),
    paragrapheExplication(
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
    paragrapheExplication(
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
  fiche: (context) => tableauRolesCas([
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

final Lecon leconMethodeAnalyse = Lecon(
  id: 'methode_analyse',
  titre: 'Comment analyser une phrase pour la traduire',
  sousTitre: 'La méthode, étape par étape',
  icone: Icons.checklist,
  explication: (context) => [
    paragrapheExplication(
      'Tu connais maintenant les fonctions, les cas et l\'ordre des mots. '
      'Voici comment t\'en servir, dans l\'ordre, pour analyser puis '
      'traduire n\'importe quelle phrase latine.',
    ),
    titreExplication('1. Repérer le verbe'),
    paragrapheExplication(
      'Le verbe est souvent à la fin de la proposition. Sa terminaison '
      'indique la personne et le nombre (donc, souvent, le sujet — même '
      'sans pronom exprimé).',
    ),
    titreExplication('2. Chercher le sujet'),
    paragrapheExplication(
      'Cherche un nominatif qui s\'accorde avec le verbe. S\'il n\'y en a '
      'pas, le sujet est sous-entendu dans la terminaison du verbe '
      '(« il/elle », « ils/elles »).',
    ),
    titreExplication('3. Chercher les compléments d\'objet'),
    paragrapheExplication(
      'Un accusatif sans préposition est souvent un COD. Un datif, ou un '
      'accusatif/ablatif avec préposition, est souvent un COI ou un CC.',
    ),
    titreExplication('4. Chercher le complément du nom'),
    paragrapheExplication(
      'Un génitif se rattache toujours à un nom (jamais au verbe) : '
      'cherche de quel nom il dépend.',
    ),
    titreExplication('5. Chercher les compléments circonstanciels'),
    paragrapheExplication(
      'Un ablatif seul (moyen, manière) ou avec préposition (lieu, '
      'temps...), ou un accusatif avec préposition de direction : ce '
      'sont des CC.',
    ),
    titreExplication('6. Vérifier les cas particuliers'),
    paragrapheExplication(
      'Un vocatif ? C\'est une apostrophe. Un nom au nominatif après '
      '« être » ou un verbe attributif ? C\'est un attribut du sujet. '
      'Un nom qui renomme un autre nom, au même cas ? C\'est une '
      'apposition.',
    ),
    titreExplication('7. Traduire dans l\'ordre naturel'),
    paragrapheExplication(
      'Traduis chaque groupe, puis reconstruis la phrase en français '
      'dans l\'ordre sujet - verbe - compléments : ne traduis jamais '
      'mot à mot dans l\'ordre latin !',
    ),
    titreExplication('Exemple complet'),
    paragrapheExplication(
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
  fiche: (context) => paragrapheExplication(
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

final Lecon leconNeutre2eDecl = Lecon(
  id: 'neutre_2e_decl',
  titre: 'Les noms neutres de la 2e déclinaison',
  sousTitre: 'oppidum / bellum — le troisième genre',
  icone: Icons.crop_square,
  unite: 'Vol. I – Unité 3',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Le latin possède 3 genres : masculin, féminin et neutre.\n\n'
      'Il n\'y a pas de noms neutres à la 1re déclinaison : ils sont '
      'féminins (puella, ae, f.) et parfois masculins (nauta, ae, m. — '
      'le marin).\n\n'
      'Les noms de la 2e déclinaison, eux, sont masculins (lupus, i, m.) '
      'ou neutres (oppidum, i, n. — la place forte). Quelques-uns sont '
      'féminins (Aegyptus, i, f.).',
    ),
    titreExplication('La règle des neutres'),
    paragrapheExplication(
      'Pour les noms neutres de la 2e déclinaison, la terminaison est '
      '-um au singulier et -a au pluriel.\n\n'
      'Règle valable pour TOUS les neutres, à toutes les déclinaisons : '
      'le nominatif, le vocatif et l\'accusatif ont toujours la même '
      'forme. Aux autres cas (génitif, datif, ablatif), les neutres se '
      'déclinent exactement comme lupus.',
    ),
    titreExplication('oppidum, i, n. (= bellum, i, n.)'),
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

final Lecon leconAdjectifs1reClasse = Lecon(
  id: 'adj_1re_classe',
  titre: 'Les adjectifs de la 1re classe',
  sousTitre: 'bonus, bona, bonum — et les adjectifs substantivés',
  icone: Icons.style,
  unite: 'Vol. I – Unité 3',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'L\'adjectif latin s\'accorde en genre, en nombre et en cas avec '
      'le nom auquel il se rapporte. Comme en français, il peut être :\n\n'
      '• épithète : Bonus puer adest. (Le bon garçon est là.)\n'
      '• attribut : Puer bonus est. (Le garçon est bon.)',
    ),
    titreExplication('Trois déclinaisons pour un seul adjectif'),
    paragrapheExplication(
      'Les adjectifs de la 1re classe suivent, au masculin et au neutre, '
      'la déclinaison des noms de la 2e déclinaison (lupus, i, m. et '
      'oppidum, i, n.), et au féminin, celle de la 1re déclinaison '
      '(puella, ae, f.) :\n\n'
      'masculin : bon-us → se décline comme lupus\n'
      'féminin : bon-a → se décline comme puella\n'
      'neutre : bon-um → se décline comme oppidum',
    ),
    paragrapheExplication(
      'Le radical de l\'adjectif s\'obtient en enlevant la terminaison '
      '-a au nominatif féminin singulier.\n\n'
      'bonus, bona, bonum → radical bon-\n'
      'pulcher, pulchra, pulchrum → radical pulchr-\n'
      'miser, misera, miserum → radical miser-',
    ),
    titreExplication('L\'adjectif substantivé'),
    paragrapheExplication(
      'Lorsqu\'un adjectif est employé seul, sans nom qu\'il accompagne, '
      'on dit qu\'il est substantivé : il a alors la valeur d\'un nom, '
      'masculin, féminin ou neutre.',
    ),
    paragrapheExplication(
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
  fiche: (context) => paragrapheExplication(
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

final Lecon leconVerbeLatin = Lecon(
  id: 'verbe_latin',
  titre: 'Le verbe latin',
  sousTitre: 'Temps primitifs, 5 conjugaisons, indicatif présent',
  icone: Icons.play_circle_outline,
  unite: 'Vol. I – Unité 3',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('Les temps primitifs'),
    paragrapheExplication(
      'Les verbes latins se présentent avec 5 formes, appelées temps '
      'primitifs : amo, as, are, avi, atum « aimer ». Elles indiquent '
      'les trois radicaux nécessaires pour former tous les modes et '
      'tous les temps du latin :\n\n'
      '• amo, as, are → le radical du présent (ou infectum) : ama-\n'
      '• amavi → le radical du passé (ou perfectum) : amav-\n'
      '• amatum → le radical du supin : amat-',
    ),
    paragrapheExplication(
      'Certains verbes, dont « être » et ses composés, n\'ont pas de '
      'supin : sum, es, esse, fui, Ø.',
    ),
    titreExplication('Les 5 modèles de conjugaison'),
    paragrapheExplication(
      'conjugaisons — verbes en — modèles\n\n'
      '1re — -o, -as, -are — amo, as, are, avi, atum « aimer »\n'
      '2e — -eo, -es, -ere — moneo, es, ere, monui, monitum « avertir »\n'
      '3e — -o, -is, -ere — mitto, is, ere, misi, missum « envoyer »\n'
      '4e — -io, -is, -ere — capio, is, ere, cepi, captum « prendre »\n'
      '5e — -io, -is, -ire — audio, is, ire, audivi, auditum « écouter »',
    ),
    paragrapheExplication(
      'Aux 1re, 2e et 5e conjugaisons, le radical se termine par une '
      'voyelle longue et stable (amā-, monē-, audī- — il suffit '
      'd\'enlever -re à l\'infinitif).\n\n'
      'Aux 3e et 4e conjugaisons, en -ĕre, le radical de la 3e se '
      'termine par une consonne (mitt-), celui de la 4e par la voyelle '
      '-i (capi-).',
    ),
    titreExplication('L\'indicatif présent'),
    paragrapheExplication(
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

Widget tableauColonnes(List<String> entetes, List<List<String>> lignes) {
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

final Lecon leconEsseComposes = Lecon(
  id: 'esse_composes',
  titre: 'Le verbe esse et ses composés',
  sousTitre: 'absum, adsum, praesum, possum...',
  icone: Icons.merge_type,
  unite: 'Vol. I – Unité 4',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Le verbe être apparaît dans de nombreux composés en latin. Pour '
      'connaître la morphologie de ces composés, il est indispensable '
      'de bien connaître la conjugaison de esse : sum, es, est, sumus, '
      'estis, sunt.',
    ),
    titreExplication('Des prépositions qui deviennent préverbes'),
    paragrapheExplication(
      'a(b) + abl. = « loin de »\n'
      'ad + acc. = « près de »\n'
      'prae + abl. = « devant »\n'
      'pro + abl. = « pour » (ALL. für)\n\n'
      'On appelle composés de esse les verbes qui se composent d\'un '
      'préfixe — qui devient préverbe et qui, par ailleurs, peut servir '
      'de préposition — et du verbe esse.',
    ),
    titreExplication('Les composés de esse'),
    tableauColonnes(
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
    paragrapheExplication(
      'Note bene : au contact du radical du verbe, le préfixe peut '
      'subir des changements (ex. : ob- devient parfois of-, com-...).',
    ),
    titreExplication('Deux verbes au radical variable'),
    paragrapheExplication(
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
  fiche: (context) => tableauColonnes(
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

final Lecon leconInterrogationSimple = Lecon(
  id: 'interrogation_simple',
  titre: 'L\'interrogation simple',
  sousTitre: 'Totale (-ne, nonne, num) et partielle (ubi, quo, cur)',
  icone: Icons.quiz,
  unite: 'Vol. I – Unité 4',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Il existe deux types d\'interrogations simples en latin : '
      'l\'interrogation totale, qui porte sur toute la phrase et '
      'attend une réponse par oui ou par non, et l\'interrogation '
      'partielle, qui porte sur un seul élément de la phrase (le lieu, '
      'la cause...) et attend une réponse précise.',
    ),
    titreExplication('L\'interrogation totale : trois particules'),
    tableauColonnes(
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
    paragrapheExplication(
      'Une particule enclitique (comme -ne) est un mot atone — non '
      'accentué — qui se lie au mot tonique — accentué — qui le '
      'précède et forme un tout avec lui.\n\n'
      'Nonne et Num attendent en réalité une réponse déjà connue de '
      'celui qui pose la question (questions orientées ou '
      'rhétoriques) : Nonne suppose « oui », Num suppose « non ».',
    ),
    titreExplication(
      'L\'interrogation partielle : les adverbes interrogatifs',
    ),
    tableauColonnes(
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
    titreExplication('Comment répondre aux questions simples ?'),
    paragrapheExplication(
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
      tableauColonnes(
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

final Lecon leconImparfaitActif = Lecon(
  id: 'imparfait_actif',
  titre: 'L\'indicatif imparfait actif',
  sousTitre: 'Suffixe -ba-, les 5 conjugaisons, esse et ses composés',
  icone: Icons.auto_stories,
  unite: 'Vol. I – Unité 5',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'L\'indicatif imparfait latin présente, en principe, les mêmes '
      'usages qu\'en français (description d\'une situation ou d\'une '
      'habitude dans le passé, action inachevée...) et se traduit donc '
      'par le même temps verbal en français.',
    ),
    titreExplication('La formation de l\'imparfait'),
    paragrapheExplication(
      'Un verbe à l\'imparfait se compose du radical du présent, du '
      'suffixe -ba- et des terminaisons -m, -s, -t, -mus, -tis, -nt.\n\n'
      'Attention : aux 3e, 4e et 5e conjugaisons, une voyelle d\'ajout '
      '-e- s\'intercale entre le radical et le suffixe -ba-.',
    ),
    titreExplication('Les 5 modèles de conjugaison'),
    for (final conj in conjugaisons) ...[
      tableauImparfait(conj),
      const SizedBox(height: 12),
    ],
    titreExplication('La conjugaison de esse et de ses composés'),
    paragrapheExplication(
      'Il faut bien connaître l\'imparfait de esse : eram, eras, erat, '
      'eramus, eratis, erant.\n\n'
      'Les formes verbales de l\'imparfait des composés correspondent à '
      'l\'imparfait de esse auquel vient s\'ajouter un préfixe : '
      'adsum → aderam, absum → aberam, desum → deeram, intersum → '
      'intereram, obsum → oberam, praesum → praeeram, supersum → '
      'supereram.',
    ),
    paragrapheExplication(
      'Attention à posse et prodesse, dont le radical varie selon la '
      'lettre qui suit (pos-/pot- et pro-/prod-, comme au présent).',
    ),
    tableauColonnes(
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
      tableauColonnes(
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

final Lecon leconACI = Lecon(
  id: 'aci',
  titre: 'La proposition infinitive : l\'ACI',
  sousTitre: 'Accusativus Cum Infinitivo, concordance des temps',
  icone: Icons.chat_bubble,
  unite: 'Vol. I – Unité 5',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Essaie de traduire spontanément : Romani dicunt barbaros esse '
      'saevos (cruels).\n\n'
      'Ta traduction comporte sans doute deux verbes, donc deux '
      'propositions : une principale (« Les Romains disent »), et une '
      'subordonnée complétive introduite par « que » (« que les '
      'barbares sont cruels »).',
    ),
    paragrapheExplication(
      'Mais en latin, cette subordonnée n\'est introduite par aucun mot '
      '(pas d\'équivalent de « que ») : son sujet (barbaros) est à '
      'l\'accusatif, son verbe (esse) est à l\'infinitif, et son '
      'attribut (saevos) est lui aussi à l\'accusatif.',
    ),
    titreExplication('Qu\'est-ce que l\'ACI ?'),
    paragrapheExplication(
      'Cette proposition subordonnée s\'appelle la proposition '
      'infinitive, ou ACI (Accusativus Cum Infinitivo, « accusatif '
      'avec infinitif »). Elle n\'est introduite par aucun mot '
      'subordonnant.',
    ),
    titreExplication('Le sujet et l\'attribut de l\'ACI'),
    paragrapheExplication(
      'En principe, l\'ACI a toujours un sujet exprimé à l\'accusatif, '
      'et son verbe est à l\'infinitif. S\'il y a un attribut du sujet, '
      'il se met également à l\'accusatif.\n\n'
      'Exemple : Je pense que ton fils est présent.\n'
      '→ Puto [filium tuum adesse].',
    ),
    titreExplication('Le verbe introducteur'),
    paragrapheExplication(
      'Les verbes de parole (dire), de pensée (croire, penser) et de '
      'perception (voir, savoir) sont suivis d\'un ACI en latin, comme '
      'en français d\'une subordonnée en « que ».',
    ),
    paragrapheExplication(
      'Quelques verbes de volonté ou de souhait se construisent aussi '
      'avec l\'ACI :\n\n'
      'jubeo, es, ere, jussi, jussum + ACI : « ordonner que »\n'
      'cupio, is, ere, cupivi/cupii, cupitum + ACI : « désirer que »\n\n'
      'Attention, en français, ces deux verbes sont suivis du '
      'subjonctif !',
    ),
    paragrapheExplication(
      'Il faut parfois transformer la phrase française pour lui donner '
      'un deuxième sujet exprimé. Par exemple, pour « César ordonne aux '
      'Romains de combattre contre les barbares », on dira plutôt '
      '« César ordonne que les Romains combattent contre les '
      'barbares », que l\'on traduit alors par jubere + ACI.',
    ),
    titreExplication('Exception : les verbes à sujet identique'),
    paragrapheExplication(
      'Certains verbes (volo, nolo, malo, cupio et scio) se '
      'construisent avec l\'infinitif seul, sans sujet exprimé à '
      'l\'accusatif, quand le sujet de la subordonnée est le même que '
      'celui de la principale (S1 = S2).\n\n'
      'Ex. : Cupio [amicum meum adesse], « je désire que mon ami soit '
      'présent » (S1 ≠ S2, sujet à l\'accusatif) ; mais Cupio adesse, '
      '« je désire être présent » (S1 = S2, infinitif seul, sans '
      'accusatif).',
    ),
    titreExplication('La concordance des temps'),
    paragrapheExplication(
      'Quand l\'action de la subordonnée se déroule en même temps que '
      'celle de la principale, ce rapport de temps s\'appelle la '
      'simultanéité. En latin, on utilise alors l\'infinitif présent.\n\n'
      'En français, il faut appliquer la concordance des temps '
      '(consecutio temporum) : le temps de la subordonnée dépend du '
      'temps du verbe introducteur.',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'Remarque : en français, le subjonctif imparfait est surtout '
      'utilisé à la 3e personne du singulier ; pour les autres '
      'personnes, on emploie plutôt le subjonctif présent, même après '
      'un verbe introducteur au passé.',
    ),
    titreExplication(
      'Les trois temps de l\'infinitif : antériorité, simultanéité, '
      'postériorité',
    ),
    paragrapheExplication(
      'Le latin possède trois temps à l\'infinitif, qui expriment le '
      'rapport de temps entre la subordonnée et la principale : '
      'l\'infinitif parfait (antériorité, l\'action de la subordonnée '
      'est antérieure à celle de la principale), l\'infinitif présent '
      '(simultanéité) et l\'infinitif futur (postériorité, l\'action de '
      'la subordonnée est postérieure à celle de la principale). Le '
      'français applique dans tous les cas la concordance des temps.',
    ),
    tableauColonnes(
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
      paragrapheExplication(
        'ACI : sujet à l\'accusatif + verbe à l\'infinitif (+ attribut à '
        'l\'accusatif s\'il y en a un). Sauf si S1 = S2 avec volo, nolo, '
        'malo, cupio, scio : infinitif seul, sans accusatif.',
      ),
      tableauColonnes(
        ['verbe introducteur', 'subordonnée française'],
        [
          ['temps du présent', 'indicatif/subjonctif présent'],
          ['temps du passé', 'indicatif/subjonctif imparfait'],
        ],
      ),
      const SizedBox(height: 12),
      tableauColonnes(
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

final Lecon leconEmploisEsse = Lecon(
  id: 'emplois_esse',
  titre: 'Les emplois de esse',
  sousTitre: 'Attribut, « il y a », le datif possessif',
  icone: Icons.savings,
  unite: 'Vol. I – Unité 6',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('Je me rappelle'),
    paragrapheExplication(
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
    titreExplication(
      'esse employé avec un complément au datif : le dativus possessivus',
    ),
    paragrapheExplication(
      'esse suivi d\'un datif exprime la possession.\n\n'
      'Ex. : Multae fibulae puellis sunt. (littéralement : De nombreuses '
      'fibules sont/appartiennent aux jeunes filles.)',
    ),
    paragrapheExplication(
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
      paragrapheExplication(
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

final Lecon leconVoixPassive = Lecon(
  id: 'voix_passive',
  titre: 'La voix passive',
  sousTitre: 'Terminaisons, infinitif passif, complément d\'agent',
  icone: Icons.cruelty_free,
  unite: 'Vol. I – Unité 6',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('Qu\'est-ce que la voix passive ?'),
    paragrapheExplication(
      'À la voix active, le sujet fait l\'action exprimée par le verbe. '
      'Mais à la voix passive, le sujet ne fait pas l\'action, il la '
      'subit. Il n\'est pas actif (il n\'agit pas) mais passif.\n\n'
      'Voix active : Romani januas aperiunt. (Les Romains ouvrent les '
      'portes.) → le sujet fait l\'action.\n'
      'Voix passive : Januae aperiuntur. (Les portes sont ouvertes.) → '
      'le sujet subit l\'action.',
    ),
    titreExplication('La transformation passive'),
    paragrapheExplication(
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
    paragrapheExplication(
      'En principe, seul un verbe qui se construit avec un accusatif '
      'peut être transformé au passif (comme, en français, seuls les '
      'verbes transitifs directs, suivis d\'un COD, admettent la '
      'tournure passive).',
    ),
    titreExplication('La morphologie : le passif des temps du présent'),
    paragrapheExplication(
      'Pour former le passif des temps conjugués du présent (indicatif '
      'présent, imparfait, futur simple, subjonctif présent et '
      'imparfait), il suffit de remplacer la terminaison personnelle '
      'active par la terminaison personnelle passive.',
    ),
    tableauColonnes(
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
    titreExplication('L\'indicatif présent passif des 5 conjugaisons'),
    tableauColonnes(
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
    paragrapheExplication(
      'La même substitution de terminaison s\'applique à l\'imparfait '
      '(ex. : amabam → amabar, « j\'étais aimé »), au futur simple et '
      'aux subjonctifs présent et imparfait.',
    ),
    titreExplication('Cas particulier : le passif de mittis et de capis'),
    paragrapheExplication(
      'Devant -r-, un -i- bref se transforme en -e- : mittis (« tu '
      'envoies ») → mitteris (« tu es envoyé »), capis (« tu prends ») '
      '→ caperis (« tu es pris »).\n\n'
      'Mais à la 5e conjugaison, le -i- est long et ne change pas : '
      'audis → audiris (« tu es écouté »).',
    ),
    titreExplication('L\'infinitif présent passif'),
    paragrapheExplication(
      'Pour former le passif de l\'infinitif présent, on remplace la '
      'terminaison active par la terminaison passive :\n\n'
      '• radical long + -re → -ri, aux 1re, 2e et 5e conjugaisons '
      '(amare → amari, monere → moneri, audire → audiri).\n'
      '• -ere → -i, aux 3e et 4e conjugaisons (mittere → mitti, capere '
      '→ capi).',
    ),
    titreExplication('Le complément du passif'),
    paragrapheExplication(
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
    titreExplication('L\'emploi de l\'infinitif passif'),
    paragrapheExplication(
      'L\'infinitif passif s\'utilise surtout dans deux cas :\n\n'
      '• comme complément d\'un verbe suivi de l\'infinitif (verbe '
      'modal ou semi-auxiliaire, comme posse ou debere).\n'
      'Ex. : Treveri vinci non possunt. (Les Trévires ne peuvent pas '
      'être vaincus.)\n\n'
      '• dans la proposition infinitive (ACI).\n'
      'Ex. : Ledona putat Treveros a Romanis timeri. (Ledona pense que '
      'les Trévires sont craints des Romains.)',
    ),
    paragrapheExplication(
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
      tableauColonnes(
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
      tableauColonnes(
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
      paragrapheExplication(
        'Infinitif passif : radical long + -re → -ri (1re, 2e, 5e) ; '
        '-ere → -i (3e, 4e).\n\n'
        'Complément d\'agent : a(b) + ablatif (être animé) / ablatif '
        'seul (être inanimé).',
      ),
    ],
  ),
);

