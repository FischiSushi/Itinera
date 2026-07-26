import 'package:flutter/material.dart';

import 'lecons_core.dart';

// ------------------------------------------------------------
// Leçon : Les adverbes de manière et quam
// ------------------------------------------------------------

final Lecon leconAdverbesManiereQuam = Lecon(
  id: 'adverbes_maniere_quam',
  titre: 'Les adverbes de manière et quam',
  sousTitre: 'Formation, comparatif, superlatif, et quam + superlatif « le plus... possible »',
  icone: Icons.speed,
  unite: 'Vol. III – Unité 3',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Nostri primo integris viribus fortiter propugnare... (Au début, '
      'les nôtres s\'opposèrent courageusement...) Subductis navibus '
      'castrisque egregie munitis... (Quand les navires furent à sec '
      'et le camp remarquablement fortifié...) — d\'après César, De '
      'bello Gallico.',
    ),
    titreExplication('Adjectif ou adverbe ?'),
    paragrapheExplication(
      'celer est. (il est rapide — adjectif) celeriter currit. (il '
      'court rapidement — adverbe) celerior est quam tu. (il est plus '
      'rapide que toi — adjectif au comparatif) celerius currit quam '
      'tu. (il court plus rapidement que toi — adverbe au comparatif) '
      'celerrimus est. (il est très rapide — adjectif au superlatif) '
      'celerrime currit. (il court très rapidement — adverbe au '
      'superlatif)',
    ),
    paragrapheExplication(
      'L\'adverbe de manière répond à la question quomodo ? (comment) '
      ': Quomodo currit ? (Comment court-il ?) De même que l\'adjectif, '
      'l\'adverbe connaît un comparatif (« plus, assez, '
      'particulièrement, trop rapidement ») et un superlatif (« très, '
      'le plus rapidement »).',
    ),
    titreExplication('La formation des adverbes de manière'),
    paragrapheExplication(
      'On forme les adverbes de manière en ajoutant au radical de '
      'l\'adjectif le suffixe :\n\n'
      '• -e pour les adjectifs de la 1re classe (doctus → docte)\n'
      '• -iter pour les adjectifs de la 2e classe (fortis → fortiter)\n'
      '• -er pour les adjectifs en -ens, -entis de la 2e classe '
      '(prudens → prudenter)',
    ),
    tableauColonnes(
      ['adjectif', 'radical', 'adverbe'],
      [
        ['doctus, a, um (savant)', 'doct-', 'docte'],
        ['fortis, is, e (courageux)', 'fort-', 'fortiter'],
        ['acer, acris, acre (vif)', 'acr-', 'acriter'],
        ['prudens, entis (prudent)', 'prudent-', 'prudenter'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Exceptions : à bonus, a, um correspond l\'adverbe bene « bien ». '
      'À facilis, is, e correspond facile « facilement » ; à '
      'difficilis, is, e correspond difficulter « difficilement » ; à '
      'audax, acis correspond audacter « hardiment ».',
    ),
    titreExplication('Le comparatif et le superlatif des adverbes de manière'),
    paragrapheExplication(
      'Le comparatif de l\'adverbe correspond à l\'accusatif neutre '
      'singulier (en -ius) du comparatif de l\'adjectif correspondant. '
      'Le superlatif correspond à l\'adverbe en -e formé sur le '
      'superlatif de l\'adjectif correspondant.',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'Il faut donc toujours se référer au comparatif et au superlatif '
      'de l\'adjectif correspondant, surtout s\'ils sont formés '
      'irrégulièrement.',
    ),
    titreExplication('Bon à savoir : d\'où vient le -ment français ?'),
    paragrapheExplication(
      'En français, l\'adverbe de manière en -ment provient d\'un '
      'phénomène de grammaticalisation : au lieu de créer l\'adverbe '
      'par un suffixe, comme en latin, on a utilisé l\'ablatif de mens, '
      'mentis (f.), par exemple dulci mente « de manière douce ». Peu à '
      'peu, mente a perdu son sens propre et a été réinterprété comme '
      'suffixe de formation de l\'adverbe : d\'où le suffixe -ment '
      'français, comme dans « doucement ».',
    ),
    titreExplication('Quelques adverbes de temps et de quantité'),
    tableauColonnes(
      ['adverbe', 'comparatif', 'superlatif'],
      [
        ['saepe (souvent)', 'saepius', 'saepissime'],
        ['diu (longtemps)', 'diutius', 'diutissime'],
        ['multum (beaucoup)', 'magis (plus)', 'maxime (le plus, surtout)'],
        ['paulum (peu)', 'minus (moins)', 'minime (le moins)'],
      ],
    ),
    const SizedBox(height: 12),
    titreExplication('Quam + superlatif : « le plus... possible »'),
    paragrapheExplication(
      'Athleta quam celerrime [potest] currit. (L\'athlète court le '
      'plus rapidement possible.) Quam maximum [potuerunt] emporium '
      'effecerunt. (Ils ont construit le plus grand marché possible.) '
      'quam primum (le plus tôt possible) quam plurimis prodesse (être '
      'utile au plus grand nombre possible)',
    ),
    paragrapheExplication(
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
      paragrapheExplication(
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

final Lecon leconAdjectifsRaresInusites = Lecon(
  id: 'adjectifs_rares_inusites',
  titre: 'Les adjectifs rares ou inusités',
  sousTitre: 'prior/primus, superior/summus... : comparatifs et superlatifs de position',
  icone: Icons.map,
  unite: 'Vol. III – Unité 3',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Certains comparatifs et superlatifs sont formés à partir '
      'd\'adjectifs rares ou inusités au positif — ils n\'ont pas, ou '
      'presque pas, de forme de base employée telle quelle. Voici '
      'quelques particularités de ces adjectifs.',
    ),
    paragrapheExplication(
      '• Ils indiquent principalement une position dans l\'espace ou '
      'dans le temps.\n\n'
      'Ex. : postremo anno (l\'année dernière, la dernière année) '
      'ulterius litus (la côte la plus éloignée)',
    ),
    paragrapheExplication(
      '• Ils sont majoritairement dérivés de prépositions ou '
      'd\'adverbes.\n\n'
      'Ex. : postremus < post (après, derrière) ulterior < ultra (de '
      'l\'autre côté, au-delà)',
    ),
    paragrapheExplication(
      '• Ils peuvent souvent être mémorisés par couples opposés.\n\n'
      'Ex. : supremus et infimus (le plus haut et le plus bas) '
      'interior et exterior (intérieur et extérieur)',
    ),
    paragrapheExplication(
      '• Certaines formes (comme posterus, exterus, superus ou '
      'inferus) apparaissent employées dans des expressions '
      'idiomatiques.\n\n'
      'Ex. : superi [dei] (les dieux d\'en haut) postero die (le '
      'lendemain)',
    ),
    paragrapheExplication(
      '• En plus d\'indiquer la position, le superlatif de ces '
      'adjectifs exprime surtout la partie d\'un élément, pour '
      'laquelle il faudra parfois utiliser un nom en français (le bas, '
      'la fin...). Le contexte de la phrase t\'aidera à choisir la '
      'bonne traduction.\n\n'
      'Ex. : prima fabula → la première légende ou le début de la '
      'légende.',
    ),
    titreExplication('Je récapitule'),
    tableauColonnes(
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
    titreExplication('Des expressions à retenir'),
    tableauColonnes(
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
    titreExplication('Les adjectifs medius, a, um et reliquus, a, um'),
    paragrapheExplication(
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
      tableauColonnes(
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

final Lecon leconSystemesConditionnels = Lecon(
  id: 'systemes_conditionnels',
  titre: 'Les systèmes conditionnels',
  sousTitre: 'Réel, potentiel, irréel du présent, irréel du passé : si + indicatif ou subjonctif',
  icone: Icons.fork_right,
  unite: 'Vol. III – Unité 4',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
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
    titreExplication('Le réel : si (nisi) + indicatif'),
    paragrapheExplication(
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
    tableauColonnes(
      ['réel', 'subordonnée (si)', 'principale'],
      [
        ['latin', 'indicatif présent (ou imparfait)', 'indicatif présent (ou imparfait)'],
        ['français', 'indicatif présent (ou imparfait)', 'indicatif présent (ou imparfait)'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Nisi convivio aderis (adfueris), miser ero. (Si tu n\'assistes '
      'pas à mon banquet, je serai malheureux.) Persequar, si potero. '
      '(Je poursuivrai, si je peux.)',
    ),
    tableauColonnes(
      ['réel (avenir)', 'subordonnée (si)', 'principale'],
      [
        ['latin', 'indicatif futur simple ou futur antérieur', 'indicatif futur simple'],
        ['français', 'indicatif présent', 'indicatif futur simple'],
      ],
    ),
    const SizedBox(height: 12),
    titreExplication('Le potentiel : si (nisi) + subjonctif présent'),
    paragrapheExplication(
      'Le potentiel exprime un fait possible qui peut se réaliser dans '
      'l\'avenir. La traduction en français est identique à celle de '
      'l\'irréel du présent ; tu peux souligner la nuance du possible '
      'en ajoutant par exemple « un jour ».\n\n'
      'Si convivio adsis, laetus sim. (Si tu assistais — un jour — à '
      'mon banquet, je serais content — il est possible que tu y '
      'assistes un jour.)',
    ),
    tableauColonnes(
      ['potentiel', 'subordonnée (si)', 'principale'],
      [
        ['latin', 'subjonctif présent', 'subjonctif présent'],
        ['français', 'indicatif imparfait', 'conditionnel présent'],
      ],
    ),
    const SizedBox(height: 12),
    titreExplication('L\'irréel du présent : si (nisi) + subjonctif imparfait'),
    paragrapheExplication(
      'L\'irréel du présent exprime une condition non réalisée dans le '
      'présent, contraire à la réalité. Traduction identique à celle '
      'du potentiel ; tu peux souligner la nuance en ajoutant par '
      'exemple « maintenant ».\n\n'
      'Si convivio adesses, laetus essem. (Si tu assistais — maintenant '
      '— à mon banquet, je serais content — mais tu n\'y assistes '
      'pas.)',
    ),
    tableauColonnes(
      ['irréel du présent', 'subordonnée (si)', 'principale'],
      [
        ['latin', 'subjonctif imparfait', 'subjonctif imparfait'],
        ['français', 'indicatif imparfait', 'conditionnel présent'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Remarque : le français ne distingue donc pas le potentiel et '
      'l\'irréel du présent. En thème, il faudra veiller à bien '
      'comprendre le sens de la phrase et le point de vue envisagé. En '
      'version, il n\'est pas toujours nécessaire d\'ajouter « un jour '
      '» ou « maintenant » : vise une traduction française correcte et '
      'élégante.',
    ),
    titreExplication('L\'irréel du passé : si (nisi) + subjonctif plus-que-parfait'),
    paragrapheExplication(
      'L\'irréel du passé exprime une condition non réalisée dans le '
      'passé.\n\n'
      'Si convivio adfuisses, laetus fuissem. (Si tu avais assisté à '
      'mon banquet, j\'aurais été content — mais tu n\'y as pas '
      'assisté.)',
    ),
    tableauColonnes(
      ['irréel du passé', 'subordonnée (si)', 'principale'],
      [
        ['latin', 'subjonctif plus-que-parfait', 'subjonctif plus-que-parfait'],
        ['français', 'indicatif plus-que-parfait', 'conditionnel passé'],
      ],
    ),
    const SizedBox(height: 12),
    titreExplication('Potentiel et irréel sans subordonnée conditionnelle'),
    paragrapheExplication(
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
    paragrapheExplication(
      'Nota bene : il se peut que les systèmes soient « mélangés ». '
      'Ex. : Quod si nostris consiliis usi essemus (irréel du passé) '
      'neque... valuisset sermo..., beatissimi viveremus (irréel du '
      'présent). (Si je m\'étais servi de mes propres conseils et si '
      'le discours de mauvaises fréquentations n\'avait pas eu autant '
      'de valeur, nous vivrions parfaitement heureux — Cicéron, Ad '
      'Familiares, XIV, 1.)',
    ),
    titreExplication('Autres conjonctions conditionnelles'),
    paragrapheExplication(
      '1) La négation : variantes. La négation habituelle de si est '
      'nisi « si... ne... pas ». On trouve parfois si non ou ni (rare, '
      'dans des formules toutes faites). Ex. : Ni ita est... (S\'il '
      'n\'en est pas ainsi...) Si debuisset, et petisses statim ; si '
      'non statim, paulo quidem post. (S\'il t\'avait dû de l\'argent, '
      'tu l\'aurais réclamé sur-le-champ ; sinon, du moins peu après.)',
    ),
    paragrapheExplication(
      '2) La concession. La conjonction si peut s\'associer à une '
      'valeur concessive : etiam si, etsi = « même si ». Ex. : Sapiens, '
      'etiam si contentus est se, amicum habere vult. (Le sage, même '
      's\'il se suffit à lui-même, veut pourtant avoir un ami.)',
    ),
    paragrapheExplication(
      '3) La comparaison conditionnelle, introduite par ut si, velut '
      'si, tamquam si « comme si ». On y emploie les mêmes modes '
      'qu\'après si, souvent le subjonctif imparfait ou plus-que-'
      'parfait (donc l\'irréel), même si la principale est à '
      'l\'indicatif. Ex. : Absentis Ariovisti crudelitatem, velut si '
      'coram adesset, horremus. (Nous craignons la cruauté d\'Arioviste, '
      'malgré son absence, comme s\'il se trouvait là.)',
    ),
    paragrapheExplication(
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
      tableauColonnes(
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

final Lecon leconSubjonctifPropositionsPrincipales = Lecon(
  id: 'subjonctif_propositions_principales',
  titre: 'Le subjonctif dans les propositions principales et indépendantes',
  sousTitre: 'utinam (souhait, regret) et le subjonctif délibératif',
  icone: Icons.star,
  unite: 'Vol. III – Unité 4',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('Le souhait et le regret'),
    paragrapheExplication(
      'Utinam beatus sit ! (Puisse-t-il être heureux !) Utinam beata '
      'essem ! (Ah, si seulement j\'étais heureuse !) Utinam beatus '
      'fuisses ! (Ah, si seulement tu avais été heureux !)',
    ),
    paragrapheExplication(
      'Le subjonctif, généralement précédé de utinam, sert à '
      'exprimer :\n\n'
      '• le souhait (réalisable = potentiel) : subjonctif présent\n'
      '• le regret dans le présent (souhait qu\'on sait irréalisable = '
      'irréel du présent) : subjonctif imparfait\n'
      '• le regret dans le passé (souhait non réalisé dans le passé = '
      'irréel du passé) : subjonctif plus-que-parfait\n\n'
      'La négation est utinam ne.',
    ),
    paragrapheExplication(
      'Ex. : Utinam P. Clodius non modo viveret, sed etiam praetor, '
      'consul, dictator esset ! (Ah, si seulement Publius Clodius non '
      'seulement était vivant, mais qu\'il fût même préteur, consul, '
      'dictateur !) Utinam illum diem videam ! (Pourvu que je voie ce '
      'jour-là !) Utinam omnes M. Lepidus servare potuisset ! (Ah, si '
      'seulement Marcus Lepidus avait pu les sauver tous !)',
    ),
    titreExplication('La délibération'),
    paragrapheExplication(
      'Quo eam ? (Où dois-je aller ? Où puis-je aller ? Où aller ?) '
      'Quo non eam ? (Où ne pas aller ?) Quo irem ? (Où devais-je '
      'aller ? Où pouvais-je aller ? Où aller ?) Quid igitur faciamus ? '
      '(Que faire, donc ?)',
    ),
    paragrapheExplication(
      'Le subjonctif délibératif indique une question que l\'on se '
      'pose à soi-même sur un parti à prendre. Dans une phrase '
      'interrogative, il sert à se demander à soi-même :\n\n'
      '• ce qu\'on peut ou doit faire → subjonctif présent\n'
      '• ce qu\'on pouvait ou devait faire → subjonctif imparfait',
    ),
    titreExplication('Je me rappelle : l\'ordre et la défense'),
    paragrapheExplication(
      'À la 2e personne, pour exprimer l\'ordre, le latin utilise '
      'l\'impératif ; pour exprimer la défense, noli / nolite + '
      'infinitif, ou ne + subjonctif parfait.\n\n'
      'Pour les autres personnes, le latin utilise le subjonctif '
      'présent pour exprimer l\'ordre, et ne + subjonctif présent pour '
      'exprimer la défense.',
    ),
    titreExplication('Je retiens : les emplois du subjonctif dans les propositions principales ou indépendantes'),
    tableauColonnes(
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
      tableauColonnes(
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

final Lecon leconDoubleDatif = Lecon(
  id: 'double_datif',
  titre: 'Le double datif',
  sousTitre: 'esse, venire, mittere, dare + datif d\'intérêt + datif de destination',
  icone: Icons.double_arrow,
  unite: 'Vol. III – Unité 4',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Mihi responde ! Tibi nulli amici erunt. Pater non sibi sed '
      'liberis suis laborat. Legati diem concilio constituere debent.',
    ),
    paragrapheExplication(
      'Tu sais déjà que le datif ne correspond pas seulement au COI '
      'français, mais qu\'il sert aussi de datif possessif, de datif '
      'd\'intérêt ou même de datif de destination (ou de résultat) :\n\n'
      '• datif possessif = exprime l\'appartenance, la propriété (avec '
      'le verbe esse)\n'
      '• datif d\'intérêt = indique pour qui une action est réalisée\n'
      '• datif de destination (ou de résultat) = indique en vue de '
      'quoi, avec quel résultat l\'action est réalisée',
    ),
    titreExplication('Le double datif'),
    paragrapheExplication(
      'Certains verbes latins, notamment esse, venire, mittere et '
      'dare, peuvent être construits avec deux compléments au datif :\n\n'
      '• un datif d\'intérêt, indiquant pour qui l\'action est réalisée\n'
      '• un datif de destination, indiquant avec quel résultat '
      'l\'action est réalisée',
    ),
    paragrapheExplication(
      'Cette construction, appelée double datif, est difficile à '
      'traduire littéralement en français.\n\n'
      'Hoc tibi dolori erit. (littéralement « Ceci sera pour toi objet '
      'de douleur » → il faut reformuler : « Ceci te causera de la '
      'douleur. »)',
    ),
    paragrapheExplication(
      'Victoria equitum Treverorum gaudio omnibus fuit. (La victoire '
      'des cavaliers trévires causa de la joie à tous.) Cui bono [est] '
      '? (À qui profite le crime ? — littéralement « à qui est-ce un '
      'bien ? »)',
    ),
    paragrapheExplication(
      'Victoriae putabat esse multa Romam deportare quae ornamento '
      'urbi esse possent. (Il pensait que c\'était le propre de la '
      'victoire d\'emporter à Rome de nombreux objets qui pourraient '
      'être un ornement pour la ville — c\'est-à-dire des objets '
      'susceptibles d\'embellir la ville.) Alexander putabat illorum '
      '[artificum] artem sibi gloriae fore. (Alexandre pensait que '
      'l\'art de ces illustres artistes lui vaudrait de la gloire.)',
    ),
    titreExplication('Les principales expressions à double datif'),
    tableauColonnes(
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
      paragrapheExplication(
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

final Lecon leconSubordonneesRelativesComplements = Lecon(
  id: 'subordonnees_relatives_complements',
  titre: 'Les subordonnées relatives : notions complémentaires',
  sousTitre: 'Le subjonctif dans la relative, et l\'attraction de l\'antécédent',
  icone: Icons.call_merge,
  unite: 'Vol. III – Unité 5',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('I. Les subordonnées relatives au subjonctif'),
    paragrapheExplication(
      'Errat qui putet omnia bona esse. ≠ Errat qui putat omnia bona '
      'esse. Misit legatos qui pacem peterent. ≠ Misit legatos qui '
      'pacem petebant. Tibi adsum qui mihi adsis. ≠ Tibi adsum qui '
      'mihi ades.',
    ),
    paragrapheExplication(
      'Dans la subordonnée relative latine, le subjonctif sert à '
      'exprimer une nuance :\n\n'
      '• de but\n'
      '• de conséquence\n'
      '• de condition\n'
      '• d\'opposition, de restriction, de concession\n'
      '• de cause',
    ),
    paragrapheExplication(
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
    titreExplication('Des tournures pour l\'expression de la conséquence'),
    tableauColonnes(
      ['tournure', 'sens'],
      [
        ['is... qui + subj.', 'tel... qu\'il, homme à, capable de'],
        ['dignus / indignus qui + subj.', 'digne / indigne de'],
        ['sunt / erant... qui + subj.', 'il y a / avait des gens tels qu\'ils, capables de, pour'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Voici d\'autres expressions à retenir :\n\n'
      'Nihil habeo quod scribam. (Je n\'ai rien à écrire, je n\'ai '
      'aucune raison d\'écrire.) Quis est qui velit... ? (Qui est-ce '
      'qui voudrait... ?) Nemo est qui velit... (Il n\'y a personne '
      'qui veuille...) Quid est quod... (Quelle raison y a-t-il pour '
      'que...) Nihil est quod... (Il n\'y a aucune raison pour que...)',
    ),
    paragrapheExplication(
      'Si la subordonnée est négative, qui non / quod non peuvent être '
      'remplacés par quin.\n\n'
      'Ex. : Nego ullam picturam fuisse quin inspexerit. (Cicéron, '
      'Oratio in Verrem, II, 4, 1 : « Je dis qu\'il n\'y a eu aucun '
      'tableau qu\'il [= Verrès] n\'ait pas examiné. »)',
    ),
    titreExplication('II. La subordonnée relative précédant la principale'),
    paragrapheExplication(
      'Quos in crimen vocasti, nemo eos laudat. (Ceux que tu as '
      'accusés, personne ne les loue → Personne ne loue ceux que tu as '
      'accusés.)',
    ),
    paragrapheExplication(
      'En latin, il se peut que la subordonnée relative précède la '
      'principale. Le pronom relatif est alors souvent repris par is, '
      'ea, id dans la principale.',
    ),
    titreExplication('L\'attraction de l\'antécédent dans la relative'),
    paragrapheExplication(
      'Quos cives in crimen vocasti, nemo eos laudat. (Les citoyens '
      'que tu as accusés, personne ne les loue.)',
    ),
    paragrapheExplication(
      'Quand la subordonnée relative précède la principale, il arrive '
      'que le nom « antécédent » soit attiré dans la relative. Cet '
      'antécédent se met au même cas que le relatif, qui devient '
      'adjectif relatif. Souvent, le pronom is, ea, id reprend le nom '
      '« antécédent » dans la principale.',
    ),
    paragrapheExplication(
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
      tableauColonnes(
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
      paragrapheExplication(
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

final Lecon leconComplementsProvenanceSeparationQualite = Lecon(
  id: 'complements_provenance_separation_qualite',
  titre: 'Les compléments de provenance, de séparation et de qualité',
  sousTitre: 'a(b)/e(x) + abl. pour provenir ou se séparer ; génitif/ablatif pour la qualité',
  icone: Icons.label,
  unite: 'Vol. III – Unité 5',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('La provenance et la séparation'),
    paragrapheExplication(
      'a Venere se liberare (s\'affranchir de Vénus) Sic a summis '
      'hominibus accepimus, poetam natura ipsa valere. (Nous avons '
      'appris des hommes les plus éminents que le poète vaut par sa '
      'seule nature.) Gallos ab Aquitanis Garumna flumen, a Belgis '
      'Matrona et Sequana dividit. (La Garonne sépare les Gaulois des '
      'Aquitains, la Seine et la Marne les séparent des Belges.) a '
      'quartana liberatus (délivré de la fièvre quarte)',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'prohibeo, es, ere, -hibui, -hibitum (a(b) + abl.) « tenir loin '
      '(de), écarter (de) » — ANGL. prohibition.',
    ),
    titreExplication('La qualité'),
    paragrapheExplication(
      'Nero fuit valetudine prospera. (Néron fut d\'une santé très '
      'solide.) Iste novo quodam genere imperator pulcherrimo '
      'Syracusarum loco stativa sibi castra faciebat. (Ce général '
      'd\'un nouveau genre s\'établissait des quartiers fixes au plus '
      'bel endroit de Syracuse.) [Ali]qui numquam aegro corpore '
      'fuerunt. (Quelques hommes n\'eurent jamais un corps malade.) '
      'Vir magni ingenii summaque prudentia. (Un homme d\'une grande '
      'intelligence, et d\'une très grande sagesse.)',
    ),
    paragrapheExplication(
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
      tableauColonnes(
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

final Lecon leconGerondif = Lecon(
  id: 'gerondif',
  titre: 'Le gérondif',
  sousTitre: '« La déclinaison du verbe » : radical du présent + -nd- + terminaisons neutres',
  icone: Icons.import_contacts,
  unite: 'Vol. III – Unité 6',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Errare humanum est. (Se tromper est humain — sujet.) Nihil '
      'agere non est vivere. (Ne rien faire, ce n\'est pas vivre — '
      'attribut du sujet.) Exire volo. (Je veux sortir — COD.)',
    ),
    paragrapheExplication(
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
    paragrapheExplication(
      'Tu peux ainsi comparer une expression comme cupiditas vincendi '
      'à cupiditas victoriae : « le désir de vaincre » = « le désir de '
      'la victoire ».',
    ),
    titreExplication('La morphologie'),
    paragrapheExplication(
      'radical du présent + (e) + suffixe -nd- + terminaisons des mots '
      'neutres de la 2e déclinaison : -um, -i, -o, -o.',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'Les verbes déponents empruntent à l\'actif les formes qui '
      'n\'existent pas au passif : participe présent (mirans, antis, '
      '« admirant »), gérondif ((ad) mirandum, « pour admirer »), '
      'supin (miratum, « pour admirer », après un verbe de mouvement), '
      'participe futur (miraturus, a, um, « sur le point d\'admirer »).',
    ),
    titreExplication('Le tableau de déclinaison'),
    paragrapheExplication(
      'Le gérondif est décliné comme un substantif de la 2e '
      'déclinaison (type : oppidum, i, n.). Comme l\'infinitif n\'a '
      'pas toutes ces formes, gérondif et infinitif se complètent :',
    ),
    tableauColonnes(
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
    titreExplication('Les emplois'),
    paragrapheExplication(
      'Le gérondif s\'emploie :\n\n'
      '• à l\'accusatif, précédé de ad, comme complément de but. Ex. : '
      'Legit ad discendum. (Il lit pour apprendre.)\n\n'
      '• au génitif, comme complément d\'un nom ou d\'un adjectif. Ex. '
      ': tempus legendi (le temps de lire) ; cupidus legendi (désireux '
      'de lire).',
    ),
    paragrapheExplication(
      'Remarque : dans les expressions legendi causa ou legendi gratia '
      '« pour lire », le gérondif est complément au génitif du nom '
      'causa ou gratia. Ces noms à l\'ablatif jouent le rôle d\'une '
      'préposition et expriment le but.',
    ),
    paragrapheExplication(
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
    titreExplication('Cas particulier : l\'adjectif verbal remplaçant le gérondif'),
    paragrapheExplication(
      'Cupiditas litteras discendi mihi est. = Cupiditas litterarum '
      'discendarum mihi est. Litteras discendo doctior fio. = Litteris '
      'discendis doctior fio.',
    ),
    paragrapheExplication(
      'Le gérondif est parfois remplacé par l\'adjectif verbal '
      '(modèle de déclinaison : bonus, a, um). Ex. : legere → '
      'gérondif : legendum, legendi, legendo → adjectif verbal : '
      'legendus, a, um.',
    ),
    paragrapheExplication(
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
    paragrapheExplication(
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
      tableauColonnes(
        ['cas', 'gérondif', 'emploi'],
        [
          ['acc. (ad +)', 'legendum', 'but'],
          ['gén.', 'legendi', 'complément de nom/adjectif'],
          ['dat. (rare)', 'legendo', 'complément de certains verbes'],
          ['abl.', 'legendo', 'moyen, manière'],
        ],
      ),
      const SizedBox(height: 12),
      paragrapheExplication(
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

final Lecon leconAdjectifVerbalObligation = Lecon(
  id: 'adjectif_verbal_obligation',
  titre: 'L\'adjectif verbal d\'obligation',
  sousTitre: 'Carthago delenda est : sens passif et sens d\'obligation',
  icone: Icons.assignment,
  unite: 'Vol. III – Unité 6',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Bona magnaque cena tibi afferenda est. (Il te faudra apporter '
      'un bon et copieux dîner.) Tunc erit bibendi tempus. Immo vero, '
      'semper bibendum est. (Alors ce sera le moment de boire. Mais en '
      'fait, il faut toujours boire.) — d\'après Catulle, Carmen XIII '
      'ad Fabullum.',
    ),
    paragrapheExplication(
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
    titreExplication('L\'adjectif verbal a trois emplois'),
    paragrapheExplication(
      '• il remplace le gérondif (même sens que le gérondif)\n'
      '• il est attribut du sujet (sens d\'obligation)\n'
      '• il est attribut du COD (sens d\'obligation ou d\'intention)',
    ),
    titreExplication('Formation et sens'),
    paragrapheExplication(
      'Comme son nom l\'indique, l\'adjectif verbal « transforme » un '
      'verbe en adjectif. Le français connaît une dérivation similaire '
      'par le suffixe -ble : lisible = qui peut être lu ; illisible : '
      'qui ne peut pas être lu. De même en allemand : essbar = was '
      'gegessen werden kann. Et en anglais : understandable = what can '
      'be understood.',
    ),
    paragrapheExplication(
      'L\'adjectif verbal en latin est formé par : radical du présent '
      '+ (voyelle intermédiaire) + suffixe -nd- + terminaisons des '
      'adjectifs de la 1re classe : -us, -a, -um.\n\n'
      'L\'adjectif verbal a un sens passif et un sens d\'obligation : '
      'legendus, a, um « qui doit être lu », « (qui est) à lire ».\n\n'
      'Comme le français n\'a pas d\'adjectif verbal correspondant, il '
      'faut trouver d\'autres moyens pour le traduire.',
    ),
    titreExplication('L\'adjectif verbal, attribut du sujet'),
    paragrapheExplication(
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
    paragrapheExplication(
      'Les verbes déponents peuvent se mettre à l\'adjectif verbal. '
      'Ils ont alors un sens passif (contrairement à leurs autres '
      'formes, toujours actives).\n\n'
      'Au passif impersonnel (sans sujet), l\'adjectif verbal se met '
      'au neutre. Ex. : Gaudendum est. (Il faut se réjouir.) Tibi '
      'gaudendum est. (Il te faut te réjouir.)',
    ),
    titreExplication('L\'adjectif verbal, attribut du COD'),
    paragrapheExplication(
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
      paragrapheExplication(
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

final Lecon leconVerbesImpersonnels = Lecon(
  id: 'verbes_impersonnels',
  titre: 'Les verbes impersonnels',
  sousTitre: 'lucet, decet, licet, oportet... : la 3e personne du singulier sans sujet',
  icone: Icons.cloud,
  unite: 'Vol. III – Unité 6',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Tu connais déjà un certain nombre de verbes, d\'expressions ou '
      'de tournures impersonnels (Nunc est bibendum, Romam itur...). '
      'Voici une liste plus complète, qui te servira de référence.',
    ),
    paragrapheExplication('Le verbe impersonnel s\'emploie à la 3e personne du singulier et à l\'infinitif.'),
    titreExplication('Les phénomènes atmosphériques'),
    tableauColonnes(
      ['verbe', 'sens'],
      [
        ['lucet, ere, luxit', 'il fait jour'],
        ['pluit, ere, pluit (arch. pluvit)', 'il pleut'],
        ['ningit, ere, ninxit', 'il neige'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Tu pourras trouver d\'autres constructions avec ces verbes, '
      'notamment chez des auteurs tardifs. Ex. : nubes pluunt (saint '
      'Augustin, Commentaires sur les Psaumes, CXXXIV, 13 : « les '
      'nuages pleuvent » → les nuages se résolvent en pluie).',
    ),
    titreExplication('Les verbes d\'évidence, de convenance ou de nécessité'),
    tableauColonnes(
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
    paragrapheExplication(
      'Ex. : Adde, si lubet, pernicitatem et velocitatem. (Cicéron, '
      'Tusculanae Disputationes, V, 45 : « Ajoute, s\'il te plaît, la '
      'souplesse et l\'agilité. ») Licet nemini contra patriam ducere '
      'exercitum. (Cicéron, Philippicae, XIII, 14 : « Personne n\'a le '
      'droit de conduire une armée contre sa patrie. »)',
    ),
    paragrapheExplication(
      'Ces verbes peuvent avoir pour sujet grammatical un infinitif ou '
      'une proposition infinitive.\n\n'
      'Ex. : Tacere decet. (« Se taire convient » → Il convient de se '
      'taire.) Te omnibus rebus studere decet. (Il convient que tu '
      't\'intéresses à tout.)',
    ),
    titreExplication('Les locutions composées de esse'),
    tableauColonnes(
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
    titreExplication('Je me rappelle : les verbes d\'événement'),
    tableauColonnes(
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
    paragrapheExplication(
      'Les verbes exprimant l\'événement sont suivis de la conjonction '
      'ut + subjonctif. La négation est ut non + subjonctif.\n\n'
      'Ex. : Saepe accidit ut cibus incolis desit. (Il arrive souvent '
      'que la nourriture manque aux habitants.)',
    ),
    titreExplication('Les verbes exprimant certains sentiments'),
    tableauColonnes(
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
    paragrapheExplication(
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
      tableauColonnes(
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

final Lecon leconConcession = Lecon(
  id: 'concession',
  titre: 'La concession',
  sousTitre: 'cum, quamvis, quamquam, etsi + subjonctif ou indicatif',
  icone: Icons.warning_amber_rounded,
  unite: 'Vol. III – Unité 7',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Cum absit a culpa, accusatur. (Bien qu\'il soit innocent, il '
      'est accusé.) Quamvis sint sub aqua, sub aqua maledicere '
      'temptant. (Bien qu\'ils soient sous l\'eau, sous l\'eau ils '
      'essaient de maudire — d\'après Ovide, Métamorphoses, VI, 376.)',
    ),
    paragrapheExplication(
      'La subordonnée circonstancielle de concession exprime une '
      'opposition entre deux faits, ou montre qu\'un fait se produit '
      'malgré un autre qui aurait pu l\'empêcher. Les propositions '
      'principale et subordonnée sont ainsi liées par une logique '
      'contradictoire.',
    ),
    titreExplication('Les conjonctions concessives les plus fréquentes'),
    tableauColonnes(
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
    paragrapheExplication(
      'Bella parat Minos ; qui quamquam milite, quamquam classe valet, '
      'patria tamen est firmissimus ira... (Minos prépare les guerres '
      '; quoiqu\'il soit vigoureux par l\'armée, quoiqu\'il le soit par '
      'la flotte, c\'est pourtant par sa colère de père qu\'il est le '
      'plus inébranlable... — d\'après Ovide, Métamorphoses, VII, '
      '456-457.)',
    ),
    paragrapheExplication(
      'Etsi difficile esse videtur credere quicquam in rebus solido '
      'reperiri corpore posse... (Même s\'il semble difficile de '
      'croire que des corps aussi solides puissent être trouvés dans '
      'la nature... — d\'après Lucrèce, De rerum natura, I, 487-488.)',
    ),
    paragrapheExplication(
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
      tableauColonnes(
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

final Lecon leconComparaisonSubordonnee = Lecon(
  id: 'comparaison_subordonnee',
  titre: 'La comparaison',
  sousTitre: 'ut/sicut/tamquam, talis...qualis, tam...quam, quo... eo',
  icone: Icons.trending_up,
  unite: 'Vol. III – Unité 7',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Talis est filius, qualis pater [est]. Qualis pater, talis '
      'filius. Tam fortis quam pater est. Tantae virtutes ei sunt '
      'quantae patri. Ita loquitur filius in foro ut locutus est '
      'pater.',
    ),
    paragrapheExplication(
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
    titreExplication('1. La subordonnée introduite par une conjonction'),
    paragrapheExplication(
      'ut (uti), sicut (sicuti), velut (veluti), quomodo, quemadmodum, '
      'tamquam « de même que, ainsi que, comme ».\n\n'
      'Ex. : Ficta omnia celeriter tamquam flosculi decidunt. (Tout ce '
      'qui est feint périt aussi vite que les fleurs — Cicéron, De '
      'Officiis, II, 12, 43.)',
    ),
    paragrapheExplication(
      'Ces conjonctions de subordination — surtout ut — peuvent être '
      'annoncées ou reprises dans la principale par les adverbes '
      'corrélatifs sic ou ita. Il n\'est pas toujours nécessaire de '
      'traduire le corrélatif en français.\n\n'
      'Ex. : Ita metes, ut sementem feceris. ((Ainsi) tu moissonneras, '
      'comme tu auras semé.)',
    ),
    paragrapheExplication(
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
    titreExplication('2. La subordonnée introduite par un adjectif ou un adverbe'),
    tableauColonnes(
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
    paragrapheExplication(
      'Ex. : Quot homines, tot sententiae. (Autant d\'hommes, autant '
      'd\'avis.) Quotiens mihi auxilio fuisti, totiens tibi gratias '
      'egi. (Autant de fois tu m\'as aidé, autant de fois je t\'ai '
      'remercié.)',
    ),
    titreExplication('3. Rappels'),
    paragrapheExplication(
      'quam s\'emploie après un comparatif ou un verbe exprimant une '
      'idée de comparaison. Ex. : Doctior quam Petrus est. (Il est '
      'plus savant que Pierre.) Malo mori quam servire. (Je préfère '
      'mourir qu\'être esclave.)',
    ),
    paragrapheExplication(
      'tam + adj./adv. ... quam « aussi... que ». Ex. : Tam celeriter '
      'currit quam tu. (Il court aussi vite que toi.)',
    ),
    paragrapheExplication(
      'ac / atque s\'emploie après des mots qui expriment l\'égalité, '
      'la ressemblance ou leurs contraires. Ex. : Iisdem libris utor '
      'ac tu. (Je me sers des mêmes livres que toi.) Alios libros legi '
      'ac tu. (J\'ai lu d\'autres livres que toi.)',
    ),
    titreExplication('4. Pour aller plus loin : « plus... plus... »'),
    tableauColonnes(
      ['ordre normal', 'ordre inversé'],
      [
        ['eo (hoc) magis / comparatif... quo magis', 'quo magis... eo (hoc) magis'],
        ['eo (hoc) + comparatif... quo + comparatif', 'quo + comparatif... eo (hoc) + comparatif'],
        ['« d\'autant plus... que plus... »', '« plus... plus... »'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Ex. (ordre normal) : Eo modestior [est] quo doctior est. (Il est '
      'd\'autant plus modeste qu\'il est plus instruit.) Ex. (ordre '
      'inversé) : Quo quis doctior, eo modestior est. (Plus quelqu\'un '
      'est savant, plus il est modeste.) Utique quo major est populus '
      'cui miscemur, hoc periculi plus est. (En tout cas, plus la '
      'foule à laquelle nous nous mêlons est grande, plus il y a de '
      'danger — Sénèque, Epistulae ad Lucilium, I, 7.)',
    ),
    paragrapheExplication(
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
      tableauColonnes(
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
      paragrapheExplication(
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

final Lecon leconInterrogationIndirecte = Lecon(
  id: 'interrogation_indirecte',
  titre: 'L\'interrogation indirecte',
  sousTitre: 'Une interrogative subordonnée au subjonctif, avec concordance des temps',
  icone: Icons.contact_support,
  unite: 'Vol. III – Unité 8',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Odi et amo. Quare id faciam, fortasse requiris. Nescio, sed '
      'fieri sentio et excrucior. (Je hais et j\'aime. Pourquoi je le '
      'fais, tu le demandes peut-être. Je ne sais pas, mais je sens '
      'que cela se produit et je suis torturé. — Catulle, Carmina, '
      'LXXXV.) Nunc ego, quid tibi accidat, Crasse, quid ceteris '
      'accidat, nescio. (Cicéron, De Oratore, II, 189.) Ipse timet nec '
      'scit qua sit iter. (d\'après Ovide, Métamorphoses, II, 169-170.)',
    ),
    paragrapheExplication(
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
    paragrapheExplication(
      'Quis venit ? (Qui vient ? — proposition indépendante à '
      'l\'indicatif) Quaero quis veniat. (Je demande qui vient. — '
      'proposition subordonnée au subjonctif)',
    ),
    titreExplication('Particularités'),
    paragrapheExplication(
      '1. Attention au sens : certains verbes se construisent selon le '
      'sens soit avec la proposition infinitive (ACI), soit avec '
      'l\'interrogation indirecte.\n\n'
      'Il dit qu\'il vient. → Dicit se venire. (ACI) Il dit qui vient. '
      '→ Dicit quis veniat. (interrogation indirecte)',
    ),
    paragrapheExplication(
      '2. num est synonyme de -ne « si » et ne sollicite donc pas de '
      'réponse négative, comme c\'est le cas dans une interrogation '
      'directe.\n\n'
      'Venitne pater tuus ? (Est-ce que ton père est venu ?) → Quaero '
      'veniturne pater tuus. ou Quaero num venerit pater tuus. (Je '
      'demande si ton père est venu.)',
    ),
    paragrapheExplication(
      '3. L\'interrogation double peut également être indirecte.\n\n'
      'Utrum nobis ades an obes ? / Adesne nobis an obes ? (Es-tu avec '
      'ou contre nous ?) → Nescio utrum nobis adsis an obsis. / Nescio '
      'adsisne nobis an obsis. (Je ne sais pas si tu es avec ou contre '
      'nous.)',
    ),
    paragrapheExplication(
      '4. Pour traduire en français une interrogation indirecte '
      'introduite par un pronom interrogatif neutre, il faut faire '
      'précéder celui-ci d\'un « ce ».\n\n'
      'Quid agis ? (Que fais-tu ?) → Dic quid agas. (Dis ce que tu '
      'fais.)',
    ),
    titreExplication('La concordance des temps'),
    paragrapheExplication(
      'Le temps du subjonctif de la subordonnée indirecte dépend :\n\n'
      '• du temps du verbe principal (temps du présent ou temps du '
      'passé) ;\n'
      '• du moment où l\'action de la subordonnée se situe par rapport '
      'à celle de la principale (antériorité, simultanéité, '
      'postériorité).',
    ),
    paragrapheExplication(
      'Nota bene : pour exprimer la postériorité, le latin utilise une '
      'périphrase en -urus, a, um sim / essem. Ce « subjonctif futur » '
      'est utilisé uniquement dans l\'interrogation indirecte !',
    ),
    tableauColonnes(
      ['rapport', 'principale au présent/futur', 'principale au passé'],
      [
        ['antériorité', 'subjonctif parfait', 'subjonctif plus-que-parfait'],
        ['simultanéité', 'subjonctif présent', 'subjonctif imparfait'],
        ['postériorité', 'périphrase en -urus sim', 'périphrase en -urus essem'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Ex. : Rogo quis venerit. (Je demande qui est venu.) Rogabam '
      'quis venisset. (Je demandais qui était venu.) Rogo quis '
      'venturus sit. (Je demande qui viendra.) Rogabam quis venturus '
      'esset. (Je demandais qui viendrait.)',
    ),
    titreExplication('L\'exclamation indirecte'),
    paragrapheExplication(
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
      tableauColonnes(
        ['rapport', 'principale présent/futur', 'principale passé'],
        [
          ['antériorité', 'subj. parfait', 'subj. plus-que-parfait'],
          ['simultanéité', 'subj. présent', 'subj. imparfait'],
          ['postériorité', '-urus sim', '-urus essem'],
        ],
      ),
      const SizedBox(height: 12),
      paragrapheExplication(
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

final Lecon leconDiscoursIndirect = Lecon(
  id: 'discours_indirect',
  titre: 'Le discours indirect',
  sousTitre: 'Rapporter des paroles : ACI, interrogatives et ordres subordonnés au subjonctif',
  icone: Icons.record_voice_over,
  unite: 'Vol. III – Unité 8',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Le discours indirect rapporte les paroles de quelqu\'un sous '
      'forme de propositions subordonnées dépendant d\'un verbe à la '
      '3e personne signifiant dire, répondre, penser... Ce verbe peut '
      'être exprimé ou simplement suggéré par le contexte.\n\n'
      'Dixit : « Civis Romanus sum. » (Il a dit : « Je suis un citoyen '
      'romain. ») → Dixit se civem Romanum esse. (Il a dit qu\'il était '
      'un citoyen romain.)',
    ),
    titreExplication('Les modes : du discours direct au discours indirect'),
    paragrapheExplication(
      'Les propositions indépendantes ou principales du discours '
      'direct deviennent des propositions subordonnées de 1er degré '
      'dans le discours indirect :\n\n'
      '1. déclaratives → proposition infinitive (ACI)\n'
      '2. interrogatives → interrogative indirecte au subjonctif\n'
      '3. ordre et défense → subjonctif sans subordonnant (négation : '
      'ne)',
    ),
    paragrapheExplication(
      'Les propositions déjà subordonnées dans le discours direct '
      'deviennent des propositions subordonnées de 2e degré :\n\n'
      '1. subordonnée relative ou conjonctive à l\'indicatif ou au '
      'subjonctif → subordonnée relative ou conjonctive au subjonctif\n'
      '2. ACI → ACI (pas de changement)\n'
      '3. participes et ablatif absolu → participes et ablatif absolu '
      '(pas de changement)',
    ),
    titreExplication('Les temps : la concordance'),
    paragrapheExplication(
      'La concordance des temps se fait par rapport au verbe dont '
      'dépend l\'ensemble du discours indirect.',
    ),
    tableauColonnes(
      ['verbe introducteur', 'antériorité', 'simultanéité', 'postériorité (interr. ind.)'],
      [
        ['au présent (ou futur)', 'subjonctif parfait', 'subjonctif présent', '-urus, a, um sim'],
        ['au passé', 'subjonctif plus-que-parfait', 'subjonctif imparfait', '-urus, a, um essem'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Remarque : dans les subordonnées conditionnelles, on n\'emploie '
      'pas la périphrase en -urus, a, um sim/essem.',
    ),
    paragrapheExplication(
      'Pour l\'ACI, quel que soit le verbe introducteur, on aura '
      'toujours :\n\n'
      '• pour l\'antériorité : un infinitif parfait\n'
      '• pour la simultanéité : un infinitif présent\n'
      '• pour la postériorité : un infinitif futur en -urum, am, um '
      'esse',
    ),
    titreExplication('Les pronoms'),
    paragrapheExplication(
      'Les pronom et adjectif réfléchis se et suus renvoient :\n\n'
      '• soit au sujet de la proposition dans laquelle ils se trouvent '
      '(réfléchi direct) ;\n'
      '• soit au sujet du verbe introducteur (réfléchi indirect).\n\n'
      'Le pronom ipse s\'emploie en cas d\'équivoque : si se, suus est '
      'réfléchi direct, ipse renvoie au sujet du verbe introducteur du '
      'discours indirect. Les pronoms is et ille renvoient aux autres '
      'personnes.',
    ),
    paragrapheExplication(
      'Ex. : Ariovistus Romanis respondit : « Oportet me a vobis in '
      'jure meo non impediri. » (Ariovist répondit aux Romains : « Il '
      'convient que je ne sois pas gêné par vous dans l\'exercice de '
      'mon droit. ») → Ariovistus Romanis respondit oportere se ab '
      'illis in jure suo non impediri. (Ariovist répondit aux Romains '
      'qu\'il convenait qu\'il ne fût pas gêné par eux dans l\'exercice '
      'de son droit.)',
    ),
    titreExplication('Bon à savoir'),
    paragrapheExplication(
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
      tableauColonnes(
        ['discours direct', 'discours indirect'],
        [
          ['déclarative', 'ACI'],
          ['interrogative', 'interrogative indirecte (subj.)'],
          ['ordre / défense', 'subjonctif (négation ne)'],
          ['subordonnée déjà présente', 'passe au subjonctif (ACI inchangé)'],
        ],
      ),
      const SizedBox(height: 12),
      paragrapheExplication(
        'se/suus = réfléchi (direct ou indirect) ; ipse lève '
        'l\'équivoque ; is/ille pour les autres personnes.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les pronoms-adjectifs indéfinis quisque, quicumque, quisquis
// ------------------------------------------------------------

final Lecon leconQuisqueQuicumqueQuisquis = Lecon(
  id: 'quisque_quicumque_quisquis',
  titre: 'Les pronoms-adjectifs indéfinis quisque, quicumque, quisquis',
  sousTitre: '« chacun », « quiconque, tout homme qui », « qui que ce soit qui »',
  icone: Icons.groups,
  unite: 'Vol. III – Unité 8',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('1. quisque, quaeque, quidque/quodque'),
    paragrapheExplication(
      'Faber est suae quisque fortunae. (Chacun est l\'artisan de sa '
      'propre fortune.) Res familiaris sua quemque delectat. (Son '
      'patrimoine charme chacun.) Num decimus quisque laudatus est ? '
      '(Est-ce que vraiment chaque dixième fut loué ?)',
    ),
    paragrapheExplication(
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
    paragrapheExplication(
      'Ex. : Fortissimum quemque fortuna juvat. (La fortune aide tous '
      'les plus courageux.) Octavus quisque tum quievit. (Un sur huit '
      'se reposa alors.) Quam quisque noverit artem, in hac se '
      'exerceat ! (Que chacun s\'exerce dans l\'art qu\'il connaît !)',
    ),
    paragrapheExplication(
      'Dans les autres contextes syntaxiques et en début de '
      'proposition, on utilise le pronom-adjectif unusquisque, '
      'unaquaeque, unumquidque (ou unumquodque comme adjectif).',
    ),
    titreExplication('2. quicumque, quaecumque, quodcumque'),
    paragrapheExplication(
      'Quoscumque adit ex civitate ad suam sententiam perducit. (Tous '
      'ceux de la cité qu\'il aborde, il les rallie à son avis — '
      'César, De Bello Gallico, VII, 4.) Quicumque spectaculo aderat '
      'laetus erat. (Quiconque assistait au spectacle était content.) '
      'Quoscumque de te queri audivi, quacumque potui ratione placavi. '
      '(Tous ceux que j\'ai entendus se plaindre de toi, je les ai '
      'calmés par tous les moyens que j\'ai pu — Cicéron, Ad Quintum '
      'fratrem, I, 2, 4.)',
    ),
    paragrapheExplication(
      'Quicumque, quaecumque, quodcumque :\n\n'
      '• est un relatif indéfini ;\n'
      '• n\'a pas d\'antécédent, comme pronom ;\n'
      '• comme pronom, se traduit par « tout homme qui, tous ceux qui, '
      'tout ce qui », « celui, quel qu\'il soit, qui » ou « quiconque '
      '» ;\n'
      '• comme adjectif, se traduit par « tout (homme) qui », « quel '
      'que soit (l\'homme) qui » ou « quel... que ».',
    ),
    titreExplication('3. quisquis, quidquid/quicquid'),
    paragrapheExplication(
      'Ille, quisquis erat, quem tu in crucem rapiebas... (Celui-là, '
      'quel qu\'il fût, que toi tu as traîné sur la croix... — '
      'Cicéron, In Verrem, II, 5, 164.) quoquo modo se res habet (de '
      'quelle manière que l\'affaire se porte — Cicéron, Ad Familiares, '
      'IX, 5.) Quicquid animo cernimus, id omne oritur a sensibus. '
      '(Tout ce que nous apercevons par l\'âme tire son origine des '
      'sens — d\'après Cicéron, De Finibus, I, 19, 64.)',
    ),
    paragrapheExplication(
      'Quisquis a le même sens que quicumque, mais ne s\'emploie qu\'à '
      'certaines formes du singulier.\n\n'
      'Comme pronom : « quelque... que, qui que ce soit qui, tout '
      'homme qui, tout ce qui ». Comme adjectif : « quel... que, '
      'tout... qui ».',
    ),
    titreExplication('Bon à savoir : les adverbes de lieu indéfinis'),
    paragrapheExplication(
      'Les adverbes et adverbes relatifs de lieu peuvent également '
      'exprimer cette notion d\'indétermination.',
    ),
    tableauColonnes(
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
      tableauColonnes(
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

final Lecon leconCauseReelleAllegueeRepoussee = Lecon(
  id: 'cause_reelle_alleguee_repoussee',
  titre: 'Cause réelle et cause alléguée / repoussée',
  sousTitre: 'quod/quia + indicatif (réel) ou + subjonctif (allégué, repoussé)',
  icone: Icons.fact_check,
  unite: 'Vol. III – Unité 9',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Taceo quod cogor. (Je me tais parce que j\'y suis forcé.) '
      'Taceo, non quod assentiar, sed quod cogor. (Je me tais, non que '
      'je sois d\'accord, mais parce que j\'y suis forcé.) Socrates '
      'accusatus est quod juvenes corrumperet. (Socrate fut accusé '
      'sous prétexte qu\'il corrompait les jeunes gens.)',
    ),
    paragrapheExplication(
      'Quelle est la différence entre une cause exprimée dans une '
      'subordonnée à l\'indicatif et une cause exprimée dans une '
      'subordonnée au subjonctif ?',
    ),
    paragrapheExplication(
      'Une cause dont on ne peut / veut affirmer la réalité, parce '
      'qu\'il s\'agit :\n\n'
      '• de la parole ou de la pensée d\'un tiers (discours indirect) '
      ';\n'
      '• d\'un prétexte allégué par quelqu\'un ;\n'
      '• d\'une cause envisageable, mais qui n\'est pas fondée,\n\n'
      'est appelée cause alléguée ou cause repoussée, et se met au '
      'subjonctif en latin.',
    ),
    paragrapheExplication(
      'De même, en français, « non que » n\'exprime pas une cause '
      'réelle, mais une cause repoussée.\n\n'
      'Taceo, non quod assentiar, sed quod cogor. (Je me tais, non que '
      'je sois d\'accord, mais parce que j\'y suis forcé.)',
    ),
    tableauColonnes(
      ['construction', 'sens'],
      [
        ['quod, quia + subjonctif', 'sous prétexte que + indicatif (/conditionnel) ; « parce que dit-il, disait-il, dis-tu... » + indicatif'],
        ['non quod / quia + subjonctif', 'non que + subjonctif'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Cicero Catilinam ejusque comites accusavit quod rem publicam '
      'turbavissent. (Cicéron accusa Catilina et ses complices sous '
      'prétexte qu\'ils avaient troublé la république.) Paucis post '
      'annis, Clodius, tribunus plebis, Ciceronem accusavit, quod '
      'cives Romanos injuria interfecisset. (Quelques années après, '
      'Clodius, tribun de la plèbe, accusa Cicéron sous prétexte qu\'il '
      'avait tué injustement des citoyens romains.)',
    ),
    paragrapheExplication(
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
      tableauColonnes(
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

final Lecon leconParticularitesAccord = Lecon(
  id: 'particularites_accord',
  titre: 'Quelques particularités de l\'accord',
  sousTitre: 'Accord de proximité de l\'épithète, accord de l\'attribut, accord du verbe',
  icone: Icons.spellcheck,
  unite: 'Vol. III – Unité 9',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('1. L\'accord de l\'adjectif qualificatif'),
    paragrapheExplication(
      'L\'adjectif qualificatif s\'accorde en genre, nombre et cas '
      'avec le nom auquel il se rapporte, et peut être épithète ou '
      'attribut.',
    ),
    titreExplication('A. L\'adjectif épithète'),
    paragrapheExplication(
      'L\'adjectif épithète précède le nom déterminé (ex. : novus '
      'amicus), sauf s\'il est possessif ou formé sur un nom propre '
      '(ex. : mare nostrum, senatus populusque Romanus).',
    ),
    paragrapheExplication(
      'Employé comme épithète de plusieurs noms, un adjectif '
      'qualificatif ne s\'exprime qu\'une seule fois : il s\'accorde '
      'alors avec le nom le plus proche (accord de proximité), tandis '
      'qu\'en français, l\'adjectif s\'accorde au pluriel avec tous les '
      'noms coordonnés.\n\n'
      'Ex. : senatus populusque Romanus (littéralement « le sénat et '
      'le peuple romain » → le sénat et le peuple romains).',
    ),
    tableauColonnes(
      ['langue', 'accord'],
      [
        ['latin (accord de proximité)', 'puella et puer Romanus / puella Romana et puer'],
        ['français (accord au pluriel)', 'la jeune fille et le garçon romains'],
      ],
    ),
    const SizedBox(height: 12),
    titreExplication('B. L\'adjectif attribut'),
    paragrapheExplication(
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
    titreExplication('2. L\'accord du verbe avec son sujet'),
    paragrapheExplication(
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
    paragrapheExplication(
      'Si le verbe a plusieurs sujets au singulier sans ces '
      'conditions, il est le plus souvent au pluriel (Pater et mater '
      'sunt boni.). Si un verbe a pour sujet un nom singulier de sens '
      'collectif suivi d\'un complément au pluriel, le verbe peut '
      's\'accorder au singulier ou au pluriel (Turba militum ruit / '
      'ruunt.). Si les sujets d\'un même verbe ne sont pas à la même '
      'personne, l\'accord se fait comme en français (Ego et tu '
      'valemus.).',
    ),
    tableauColonnes(
      ['langue', 'règle'],
      [
        ['français', 'accord du verbe en personne et nombre avec le/les sujet(s)'],
        ['latin', 'accord en personne et nombre avec le/les sujet(s), ou accord de proximité avec un sujet'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
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
      tableauColonnes(
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

final Lecon leconAspectDuVerbe = Lecon(
  id: 'aspect_du_verbe',
  titre: 'L\'aspect du verbe',
  sousTitre: 'Linéaire (duratif, itératif, conatif), ponctuel (inchoatif, terminatif), résultatif',
  icone: Icons.timeline,
  unite: 'Vol. III – Unité 9',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Tu as abordé jusque-là les notions verbales de temps (passé, '
      'présent ou futur), de concordance des temps (antériorité, '
      'simultanéité ou postériorité), de mode (indicatif, subjonctif, '
      'etc.) ou de voix (actif, passif ou déponent).',
    ),
    paragrapheExplication(
      'Pour bien saisir toutes les nuances du système verbal latin, il '
      'convient de s\'intéresser également à l\'aspect du verbe. Il '
      's\'agit de la façon dont on envisage le procès exprimé par le '
      'verbe : procès en cours, entamé, achevé, itératif, etc. Ces '
      'notions sont encore perceptibles en latin classique, notamment '
      'aux temps du passé où apparaît clairement l\'opposition entre '
      'infectum et perfectum.',
    ),
    titreExplication('1. L\'action peut être linéaire'),
    paragrapheExplication(
      'Elle s\'étend sur une période de temps. Dans ce cas, elle peut '
      'être durative (elle dure encore / perdure), itérative (elle est '
      'répétée) ou conative (elle est tentée). Ces valeurs aspectuelles '
      'peuvent être exprimées par les temps formés sur le radical de '
      'l\'infectum, et se trouvent souvent à l\'imparfait ou au '
      'passif :',
    ),
    tableauColonnes(
      ['forme', 'sens', 'aspect'],
      [
        ['edebam', 'je mangeais = j\'étais en train de manger', 'duratif'],
        ['vocabam', 'j\'appelais = j\'appelais encore et encore', 'itératif'],
        ['componebam', 'je disposais = je tentais de disposer', 'conatif'],
        ['januae aperiuntur', 'les portes sont ouvertes = on est en train de les ouvrir', 'linéaire'],
      ],
    ),
    const SizedBox(height: 12),
    titreExplication('2. L\'action peut être ponctuelle'),
    paragrapheExplication(
      'Elle correspond à un moment précis et ponctuel de l\'axe du '
      'temps. Dans ce cas, elle peut être inchoative (elle commence) '
      'ou effective/terminative (elle est achevée). Ces valeurs '
      'aspectuelles peuvent être exprimées par les temps formés sur le '
      'radical du perfectum, et se trouvent notamment au parfait :',
    ),
    tableauColonnes(
      ['forme', 'sens', 'aspect'],
      [
        ['rex factus est', 'il est devenu roi', 'inchoatif'],
        ['vocavi', 'j\'ai appelé', 'effectif / terminatif'],
        ['vixit', 'il a vécu = il est mort', 'terminatif'],
        ['dixi', 'j\'ai dit = j\'ai fini de parler', 'terminatif'],
      ],
    ),
    const SizedBox(height: 12),
    titreExplication('3. L\'action peut être résultative'),
    paragrapheExplication(
      'L\'action est achevée au passé, mais le résultat de l\'action '
      'perdure.',
    ),
    tableauColonnes(
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
    titreExplication('Exemples d\'analyse'),
    paragrapheExplication(
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
      tableauColonnes(
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
