import 'package:flutter/material.dart';

import 'lecons_core.dart';

// ------------------------------------------------------------
// Leçon : Le verbe ferre et ses composés
// ------------------------------------------------------------

final Lecon leconFerreComposes = Lecon(
  id: 'ferre_composes',
  titre: 'Le verbe ferre et ses composés',
  sousTitre: 'fero, fers, ferre, tuli, latum : trois radicaux à surveiller',
  icone: Icons.local_shipping,
  unite: 'Vol. II – Unité 7',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Un somnifère, les abeilles mellifères, les lucioles aux ailes '
      'lucifères, un transfert, vociférer... Tous ces mots français '
      'contiennent le suffixe -fère, issu du verbe ferre, dont voici '
      'les temps primitifs :',
    ),
    paragrapheExplication('fero, fers, ferre, tuli, latum « porter, supporter, rapporter »'),
    titreExplication('Trois radicaux'),
    paragrapheExplication(
      'fer- est le radical de l\'infectum, tul- le radical du '
      'perfectum, lat- le radical du supin. Ces trois radicaux très '
      'différents rendent ferre irrégulier.',
    ),
    titreExplication('L\'indicatif présent : fero, fers, fert...'),
    tableauColonnes(
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
    paragrapheExplication(
      'À l\'imparfait (ferebam...) et au futur (feram...), ferre se '
      'conjugue en revanche tout à fait normalement, comme un verbe de '
      'la 3e conjugaison sur le radical fer-.',
    ),
    titreExplication('Des formes sans voyelle de liaison'),
    paragrapheExplication(
      'L\'infinitif du verbe est fer-re, son radical est donc fer- ; en '
      'principe ce verbe suit la 3e conjugaison (modèle : mitto), mais '
      'certaines formes ne présentent pas de voyelle de liaison, par '
      'exemple mitt-e-re mais fer-re, mitt-i-s mais fer-s. Les temps '
      'concernés sont l\'infinitif et l\'indicatif présents, le '
      'subjonctif imparfait et l\'impératif (fer ! ferte !).',
    ),
    paragrapheExplication(
      'ferunt et fertur sont souvent employés avec la proposition '
      'infinitive (ACI) et se traduisent alors par « on rapporte que ».',
    ),
    titreExplication('Les composés de ferre'),
    paragrapheExplication(
      'Le verbe fero a de nombreux composés, formés d\'un préverbe et '
      'de fero/tuli/latum. Attention, au contact des différents '
      'radicaux (fer-, tul-, lat-), le préfixe peut changer.',
    ),
    tableauColonnes(
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
      paragrapheExplication(
        'fero, fers, ferre, tuli, latum. Trois radicaux : fer- '
        '(infectum), tul- (perfectum), lat- (supin). Au présent, pas de '
        'voyelle de liaison (fer-s, fer-t, fer-re).',
      ),
      tableauColonnes(
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

final Lecon leconSubjonctifParfaitPlusQueParfait = Lecon(
  id: 'subjonctif_parfait_plusqueparfait',
  titre: 'Les subjonctifs parfait et plus-que-parfait',
  sousTitre: 'Suffixes -eri-/-isse- sur le radical du parfait, et concordance des temps',
  icone: Icons.history,
  unite: 'Vol. II – Unité 8',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Accidit saepe ut stulti bona consilia non ceperint. (Il arrive '
      'souvent que des hommes sots n\'aient pas pris les bonnes '
      'décisions.) Parentes timent ne erraverim. (Mes parents craignent '
      'que je ne me sois trompé.)',
    ),
    titreExplication('La formation du subjonctif parfait'),
    paragrapheExplication(
      'Pour former le subjonctif parfait, on ajoute au radical du '
      'parfait le suffixe -eri- suivi des terminaisons personnelles '
      'actives -m, -s, -t, -mus, -tis, -nt.',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'Le suffixe du subjonctif parfait ressemble beaucoup à celui d\'un '
      'autre temps déjà connu : l\'indicatif futur antérieur (amavero, '
      'amaveris, amaverit...). Les deux temps ne se distinguent que par '
      'la 1re personne du singulier : amavero (futur antérieur) mais '
      'amaverim (subjonctif parfait).',
    ),
    titreExplication('La formation du subjonctif plus-que-parfait'),
    paragrapheExplication(
      'Pueri metuebant ne parentes venissent. (Les enfants craignaient '
      'que leurs parents ne soient [déjà] arrivés.) Optabam ne '
      'erravisses. (Je souhaitais que tu ne te sois pas trompé.)',
    ),
    paragrapheExplication(
      'Pour former le subjonctif plus-que-parfait, on ajoute au radical '
      'du parfait le suffixe -isse- suivi des terminaisons personnelles '
      'actives -m, -s, -t, -mus, -tis, -nt.\n\n'
      'Astuce : pour simplifier, tu peux ajouter les terminaisons '
      'personnelles actives à l\'infinitif parfait (amavisse + -m, -s, '
      '-t...).',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'Qui l\'eût cru ? En français, de même que le subjonctif '
      'imparfait, le subjonctif plus-que-parfait s\'utilise peu, sauf à '
      'la 3e personne du singulier ; on utilise plus fréquemment le '
      'subjonctif passé dans les autres cas.\n\n'
      'Astuce : pour former un subjonctif plus-que-parfait à la 3e '
      'personne du singulier en français, rien de plus simple : qu\'il '
      'eût / qu\'il fût + participe passé.',
    ),
    titreExplication('La concordance des temps'),
    paragrapheExplication(
      'Le temps de la proposition subordonnée au subjonctif dépend du '
      'temps de la proposition principale :',
    ),
    tableauColonnes(
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
    paragrapheExplication(
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
      paragrapheExplication(
        'Subjonctif parfait : radical du parfait + -eri- + terminaisons '
        '(amaverim). Subjonctif plus-que-parfait : radical du parfait + '
        '-isse- + terminaisons (amavissem), soit infinitif parfait + '
        'terminaisons.',
      ),
      tableauColonnes(
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

final Lecon leconSubordonneesBut = Lecon(
  id: 'subordonnees_but',
  titre: 'Les subordonnées circonstancielles de but',
  sousTitre: 'ut / ne + subjonctif : les subordonnées finales',
  icone: Icons.flag,
  unite: 'Vol. II – Unité 8',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
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
    paragrapheExplication(
      'Les subordonnées de but / finales sont introduites par la '
      'conjonction :\n\n'
      'ut (uti) → pour que, afin que (+ subjonctif) ; pour, afin de '
      '(+ infinitif)\n\n'
      'ne → pour que... ne... pas, afin que... ne... pas ; de peur que '
      '(ne), de crainte que (ne) ; pour ne pas, afin de ne pas (+ '
      'infinitif) ; de peur de, de crainte de (+ infinitif)\n\n'
      'Elles sont toujours suivies du subjonctif.',
    ),
    paragrapheExplication(
      'En français, avec l\'expression « de peur que », on trouve '
      'également un « ne explétif » dont l\'emploi est facultatif.\n\n'
      'Ex. : Pueri bene discunt ne errent. (Les enfants étudient bien '
      'pour qu\'ils ne se trompent pas → de peur qu\'ils (ne) se '
      'trompent.) Incolae oppidum muniunt ne oppugnetur. (Les habitants '
      'fortifient la place forte pour qu\'elle ne soit pas attaquée → '
      'de peur qu\'elle (ne) soit attaquée.)',
    ),
    titreExplication('La négation dans les subordonnées finales'),
    paragrapheExplication(
      'Comme la négation est ne, on dira de même :\n\n'
      'pour que personne ne... → ne quisquam...\n'
      'pour que rien ne... → ne quidquam...\n'
      'pour qu\'aucun ne... → ne ullus, a, um...\n'
      'pour que jamais ne... → ne umquam...',
    ),
    titreExplication('Le réfléchi dans les subordonnées finales'),
    paragrapheExplication(
      'Pueri discunt ne quisquam se doctior sit. (Les enfants étudient '
      'pour que personne ne soit plus savant qu\'eux.) Litteras ad '
      'parentes misit ut auxilium sibi mitterent. (Il a envoyé une '
      'lettre à ses parents pour qu\'ils lui envoient de l\'aide.)',
    ),
    paragrapheExplication(
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
      tableauColonnes(
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
      paragrapheExplication(
        'Toujours au subjonctif. se/suus renvoient au sujet de la même '
        'proposition (direct) ou de la principale (indirect).',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les subordonnées circonstancielles de conséquence
// ------------------------------------------------------------

final Lecon leconSubordonneesConsequence = Lecon(
  id: 'subordonnees_consequence',
  titre: 'Les subordonnées circonstancielles de conséquence',
  sousTitre: 'ut / ut non + subjonctif, et les corrélatifs tam, talis, tantus...',
  icone: Icons.compare_arrows,
  unite: 'Vol. II – Unité 8',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Aeger sum. (Je suis malade — cause.) Domi maneo. (Je reste à la '
      'maison — conséquence.) La subordonnée de conséquence exprime la '
      'même relation logique que la subordonnée de cause, mais du '
      'point de vue inverse.',
    ),
    paragrapheExplication(
      'Les subordonnées de conséquence sont toujours au subjonctif. '
      'Elles sont introduites par ut (uti) « de telle sorte (façon, '
      'manière) que », « à tel point que », « si bien que ». La '
      'négation est ut non.\n\n'
      'Ex. : Aeger sum ut domi maneam. (Je suis malade à tel point que '
      'je reste à la maison.)',
    ),
    titreExplication('La négation dans les subordonnées de conséquence'),
    paragrapheExplication(
      'Comme la négation est ut non, on dira de même :\n\n'
      'de telle sorte que personne ne... → ut nemo...\n'
      'de telle sorte que rien ne... → ut nihil...\n'
      'de telle sorte qu\'aucun ne... → ut nullus, a, um...\n'
      'de telle sorte que jamais... → ut numquam...',
    ),
    titreExplication('Les expressions corrélatives'),
    paragrapheExplication(
      'Tam aeger sum ut domi maneam. (Je suis si malade que je reste à '
      'la maison.) Talis est morbus ut ambulare non possim. (Ma '
      'maladie est telle que je ne peux pas me promener.)\n\n'
      'Les subordonnées de conséquence sont souvent annoncées par un '
      'corrélatif : la conjonction ut/uti est annoncée dans la '
      'proposition principale par un adverbe ou un adjectif.',
    ),
    tableauColonnes(
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
    titreExplication('Réfléchi ou non réfléchi ?'),
    paragrapheExplication(
      'Hic vir probus non est ita ut nemo ei credere possit. (Cet homme '
      'n\'est pas honnête, de telle sorte que personne ne peut lui '
      'faire confiance.) Hic vir probus non est ita ut ejus verbis '
      'credere non possis. (...de telle sorte que tu ne peux faire '
      'confiance à ses paroles.) Haec mulier tam valida est ut nihil '
      'eam movere possit. (Cette femme est si robuste que rien ne peut '
      'l\'émouvoir.)',
    ),
    paragrapheExplication(
      'Il n\'y a pas de réfléchi indirect dans les subordonnées de '
      'conséquence : contrairement aux subordonnées de but ou aux '
      'complétives, se et suus n\'y renvoient jamais au sujet de la '
      'principale, mais toujours au sujet de la subordonnée elle-même '
      '(ejus, ei remplacent alors se, sibi pour renvoyer à la '
      'principale).',
    ),
    titreExplication('L\'emploi des temps : une particularité'),
    paragrapheExplication(
      'Le temps du subjonctif employé dans les subordonnées consécutives '
      'correspond en principe au temps qu\'on utiliserait dans une '
      'proposition principale : là où il y aurait un indicatif '
      'imparfait dans une principale, on trouve un subjonctif imparfait '
      'dans la subordonnée. L\'imparfait du subjonctif est ainsi le '
      'temps le plus usuel dans les subordonnées consécutives en latin '
      '; le subjonctif plus-que-parfait y est plutôt rare.',
    ),
    paragrapheExplication(
      'Le subjonctif parfait, quant à lui, peut avoir une valeur '
      'particulière : avec une principale au passé, il exprime dans la '
      'subordonnée consécutive une conséquence durable et acquise, ou '
      'présente la conséquence comme un fait réel. On peut souvent le '
      'traduire par un passé simple en français.\n\n'
      'Ex. : Eorum amicitia talis erat ut numquam se reliquerint. (Leur '
      'amitié était telle qu\'ils ne se quittèrent jamais.)',
    ),
    paragrapheExplication(
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
      tableauColonnes(
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
      paragrapheExplication(
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

final Lecon leconIreComposes = Lecon(
  id: 'ire_composes',
  titre: 'Le verbe ire et ses composés',
  sousTitre: 'eo, is, ire, ivi (ii), itum : présent irrégulier, parfait régulier',
  icone: Icons.directions_walk,
  unite: 'Vol. II – Unité 9',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
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
    titreExplication('Les temps primitifs du verbe ire'),
    paragrapheExplication(
      'eo, is, ire, ivi ou ii, itum « aller ». La forme ivi peut '
      's\'abréger en ii, comme tu l\'as déjà vu avec d\'autres verbes '
      '(ex. audii pour audivi).',
    ),
    paragrapheExplication(
      'Ce verbe est régulier aux temps formés sur le radical du parfait '
      '(perfectum). En revanche, il est irrégulier à l\'indicatif '
      'présent et au participe présent : son radical du présent '
      '(infectum) est i- ou e- (< *ey-).',
    ),
    titreExplication('L\'indicatif présent, l\'imparfait et le futur'),
    tableauColonnes(
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
    titreExplication('Le participe présent : iens, euntis'),
    tableauColonnes(
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
    paragrapheExplication(
      'Au pluriel, ce participe se décline régulièrement comme un '
      'adjectif de la 3e déclinaison : euntes, euntium, euntibus.',
    ),
    titreExplication('Le parfait, le plus-que-parfait, le futur antérieur : réguliers'),
    tableauColonnes(
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
    titreExplication('Les composés de ire'),
    paragrapheExplication(
      'La conjugaison des composés est identique à celle de ire : il '
      'suffit d\'y ajouter le préfixe concerné. Nota bene : le parfait '
      'des composés de ire est en -ii ; le radical du parfait est donc '
      'en -i- (transi-, abi-, ini-...).',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'Après un verbe de mouvement comme ire, souviens-toi que le supin '
      'exprime le but.\n\n'
      'Ex. : Milites Romani mare transierunt Carthaginem captum. (Les '
      'soldats romains traversèrent la mer pour prendre Carthage.)',
    ),
    titreExplication('Les adverbes de lieu'),
    paragrapheExplication(
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
      tableauColonnes(
        ['pers.', 'présent', 'parfait'],
        [
          ['je', 'eo', 'ivi (ii)'],
          ['tu', 'is', 'ivisti'],
          ['il', 'it', 'ivit'],
        ],
      ),
      const SizedBox(height: 12),
      paragrapheExplication(
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

final Lecon leconRappelPrefixesComposes = Lecon(
  id: 'rappel_prefixes_composes',
  titre: 'Rappel : les préfixes dans les verbes composés',
  sousTitre: 'Tableau récapitulatif des préverbes, et le phénomène d\'apophonie',
  icone: Icons.transform,
  unite: 'Vol. II – Unité 9',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Tu connais maintenant le principe des verbes composés : un '
      'préverbe, souvent identique à une préposition, se combine avec '
      'un verbe simple. Il est souvent possible de déduire le sens du '
      'verbe composé à partir du sens du verbe simple et de celui du '
      'préfixe.',
    ),
    titreExplication('Tableau récapitulatif des préverbes'),
    tableauColonnes(
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
    titreExplication('Le phénomène de l\'apophonie'),
    paragrapheExplication(
      'Quand un verbe simple contient un ă bref dans sa première '
      'syllabe, celui-ci se transforme dans les composés :\n\n'
      '• en ĭ dans les composés ;\n'
      '• en ĕ devant un r ou une consonne double.',
    ),
    tableauColonnes(
      ['verbe simple', 'verbe composé', 'sens'],
      [
        ['capio, is, ere, cepi, captum', 'accipio, is, ere, accepi, acceptum', '< prendre près de soi >, recevoir, accueillir, apprendre'],
        ['facio, is, ere, feci, factum', 'perficio, is, ere, perfeci, perfectum', '< faire jusqu\'au bout >, achever, parfaire'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Le verbe dare présente une particularité : contrairement aux '
      'autres verbes de la 1re conjugaison, son a est bref. Le '
      'phénomène d\'apophonie transforme ainsi les composés de dare en '
      'verbes de la 3e conjugaison.',
    ),
    tableauColonnes(
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
      paragrapheExplication(
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

final Lecon leconAliusAlterUter = Lecon(
  id: 'alius_alter_uter',
  titre: 'Les pronoms-adjectifs alius et alter',
  sousTitre: 'Deux, ou plus de deux ? — et uter, uterque, neuter',
  icone: Icons.compare,
  unite: 'Vol. II – Unité 9',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
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
    paragrapheExplication(
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
    titreExplication('La morphologie'),
    paragrapheExplication(
      'alter, altera, alterum « l\'un (des deux), l\'autre (des deux), '
      'le second » (pluriel : « les uns... les autres... »).\n\n'
      'alius, alia, aliud « un (de plus de deux), un autre » (pluriel '
      ': « les uns... d\'autres... »).',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'Comme unus, solus, totus et nullus, alter et alius se déclinent '
      'avec un génitif en -ius et un datif en -i au singulier, quel '
      'que soit le genre.',
    ),
    tableauColonnes(
      ['cas', 'alius (m.)', 'alia (f.)', 'aliud (n.)'],
      [
        ['nom.', 'alius', 'alia', 'aliud'],
        ['acc.', 'alium', 'aliam', 'aliud'],
        ['dat.', 'alii', 'alii', 'alii'],
        ['abl.', 'alio', 'alia', 'alio'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Alius n\'a pas de génitif : on utilise alors l\'adjectif '
      'alienus, a, um « étranger, d\'autrui ».\n\n'
      'Ex. : aliena mala, « les maux d\'autrui ».',
    ),
    titreExplication('Alter : deux ; alius : plus de deux'),
    paragrapheExplication(
      'Alter s\'emploie quand on parle de deux personnes, de deux '
      'choses, de deux groupes. Alius s\'emploie quand on parle de '
      'plus de deux personnes, choses ou groupes.',
    ),
    titreExplication('Employés seuls'),
    paragrapheExplication(
      'alter, altera, alterum « l\'un (des deux), l\'autre (des deux) '
      '» (pluriel : « les uns, les autres »). alius, alia, aliud « un '
      'autre » (pluriel : « d\'autres »).\n\n'
      'Ex. : Alter consul venit. (adjectif) Altera venit. (pronom) '
      'Alteri venerunt. (pronom, pluriel) — Alius civis venit. '
      '(adjectif) Alia venit. (pronom) Alii venerunt. (pronom, '
      'pluriel).',
    ),
    titreExplication('Employés en série'),
    paragrapheExplication(
      'alter... alter... « l\'un..., l\'autre... » (pluriel alteri... '
      'alteri... « les uns..., les autres... »). alius... alius... '
      '« l\'un..., un autre... » (pluriel alii... alii... alii... « '
      'les uns..., d\'autres..., d\'autres... »).\n\n'
      'Ex. : Alter scribit, alter legit. (L\'un écrit, l\'autre lit.) '
      'Alii scribunt, alii legunt, alii discunt. (Les uns écrivent, '
      'd\'autres lisent, d\'autres étudient.)',
    ),
    titreExplication('Réciprocité et diversité'),
    paragrapheExplication(
      'Alter et alius, répétés à des cas différents, peuvent marquer :'
      '\n\n'
      '• la réciprocité — Alter alteri adest. (Ils s\'aident l\'un '
      'l\'autre, ils s\'entraident.) Alii aliis obsunt. (Ils se '
      'nuisent entre eux, mutuellement.)\n\n'
      '• la diversité — Alii in aliam provinciam discesserunt. (Les '
      'uns partirent dans une province, d\'autres dans une autre → ils '
      'partirent dans des provinces différentes.)',
    ),
    titreExplication('La comparaison : « autre que »'),
    paragrapheExplication(
      'De même que idem s\'accompagne de que pour dire « le même que '
      '», alius s\'accompagne de atque (ou ac) pour dire « autre que '
      '». Autre que = alius atque (ac).',
    ),
    titreExplication('Lequel des deux, tous les deux, aucun des deux'),
    paragrapheExplication(
      'Cum utro consule verba fecisti ? (Auquel des deux consuls '
      'as-tu parlé ?)',
    ),
    paragrapheExplication(
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
      tableauColonnes(
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

final Lecon leconImperatif = Lecon(
  id: 'imperatif',
  titre: 'L\'impératif',
  sousTitre: 'Une seule personne : le radical seul au singulier, -te au pluriel',
  icone: Icons.campaign,
  unite: 'Vol. II – Unité 10',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Nostri lege culta magistri carmina ! (Lis les vers soignés de '
      'notre maître !) Me vatem celebrate, [...] mihi dicite laudes ! '
      '(Célébrez-moi comme poète, dites-moi des éloges !) Duc, age, '
      'discipulos ad mea templa tuos ! (Allez, conduis tes disciples à '
      'mes temples !) — d\'après Ovide, Ars amatoria.',
    ),
    paragrapheExplication(
      'Tempus [...] collige et serva ! (Rassemble le temps et '
      'préserve-le !) Persuade tibi hoc sic esse ! (Persuade-toi qu\'il '
      'en est ainsi !) Fac [...] quod facere te scribis ! (Fais ce que '
      'tu écris faire !) Ama rationem ! (Aime la raison !) — d\'après '
      'Sénèque, Epistulae morales ad Lucilium.',
    ),
    paragrapheExplication(
      'L\'impératif sert à exprimer l\'ordre. Contrairement au '
      'français, qui connaît trois formes d\'impératif (chante ! '
      'chantons ! chantez !), le latin ne connaît que l\'impératif à la '
      '2e personne (singulier et pluriel).',
    ),
    titreExplication('La formation'),
    paragrapheExplication(
      'À la 2e personne du singulier, l\'impératif actif est '
      'simplement constitué du radical du verbe. Mais à la 3e '
      'conjugaison (modèle mittere), à radical consonantique (mitt-), '
      'on trouve pourtant la voyelle -e (mitte), de même qu\'à la 4e '
      'conjugaison (cape). Astuce mnémotechnique : tu enlèves la '
      'terminaison -re (ou -se) de l\'infinitif présent.',
    ),
    paragrapheExplication(
      'À la 2e personne du pluriel, l\'impératif actif présente la '
      'terminaison -te au lieu de -tis (de l\'indicatif présent).',
    ),
    tableauColonnes(
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
    titreExplication('Cas particuliers : dic, duc, fac, fer'),
    paragrapheExplication(
      'L\'impératif de dicere, ducere, facere et ferre ne présente pas '
      'de -e final à la 2e personne du singulier ; le pluriel, quant à '
      'lui, est régulier.',
    ),
    tableauColonnes(
      ['infinitif', 'impératif sg.', 'impératif pl.'],
      [
        ['dicere', 'dic !', 'dicite !'],
        ['ducere', 'duc !', 'ducite !'],
        ['facere', 'fac !', 'facite !'],
        ['ferre', 'fer !', 'ferte !'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
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
      tableauColonnes(
        ['infinitif', 'impératif sg.', 'impératif pl.'],
        [
          ['amare', 'ama !', 'amate !'],
          ['mittere', 'mitte !', 'mittite !'],
          ['dicere', 'dic !', 'dicite !'],
        ],
      ),
      const SizedBox(height: 12),
      paragrapheExplication(
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

final Lecon leconVelleNolleMalle = Lecon(
  id: 'velle_nolle_malle',
  titre: 'Velle, nolle, malle',
  sousTitre: 'Vouloir, ne pas vouloir, préférer : trois verbes apparentés à mittere',
  icone: Icons.favorite,
  unite: 'Vol. II – Unité 10',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'volo, vis, velle, volui / « vouloir »\n'
      'nolo, non vis, nolle, nolui / « ne pas vouloir »\n'
      'malo, mavis, malle, malui / « préférer, aimer mieux »\n\n'
      'Ces verbes se rattachent à la conjugaison de mitto, mais '
      'présentent des irrégularités à l\'indicatif présent.',
    ),
    titreExplication('L\'indicatif présent'),
    tableauColonnes(
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
    paragrapheExplication(
      'Les autres temps formés sur le radical du présent sont en '
      'principe réguliers ; attention pourtant au verbe velle, qui '
      'présente tantôt le radical vol-, tantôt le radical vel-.',
    ),
    titreExplication('L\'imparfait, le futur et le subjonctif'),
    tableauColonnes(
      ['temps', 'velle', 'nolle', 'malle'],
      [
        ['imparfait (je)', 'volebam', 'nolebam', 'malebam'],
        ['futur (je)', 'volam', 'nolam', 'malam'],
        ['subj. présent (je)', 'velim', 'nolim', 'malim'],
        ['subj. imparfait (je)', 'vellem', 'nollem', 'mallem'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Le participe présent est régulier : volens, volentis ; nolens, '
      'nolentis ; malens, malentis.',
    ),
    titreExplication('Le parfait : régulier'),
    paragrapheExplication(
      'volui, volueram, voluero... (comme un parfait ordinaire en '
      '-ui). Velle, nolle et malle n\'ont pas de supin, donc pas de '
      'participe ni d\'infinitif futurs.',
    ),
    titreExplication('L\'expression de la défense : noli, nolite'),
    paragrapheExplication(
      'Seul nolle présente des formes d\'impératif qui, accompagnées '
      'd\'un infinitif présent, servent à exprimer la défense.\n\n'
      'Défense : noli + infinitif présent ; nolite + infinitif '
      'présent.\n\n'
      'Ex. : Noli istud facere ! (littéralement « ne veuille pas faire '
      'cela » → Ne fais pas cela !) Nolite istud facere ! (« ne '
      'veuillez pas faire cela » → Ne faites pas cela !)',
    ),
    titreExplication('L\'emploi des verbes de volonté et de savoir'),
    paragrapheExplication(
      'Volo, nolo et malo, de même que cupio et scio, se construisent '
      'avec l\'ACI si le sujet de la principale est différent du sujet '
      'de la proposition infinitive (sujet 1 ≠ sujet 2) ; avec '
      'l\'infinitif, si les deux verbes ont le même sujet (sujet 1 = '
      'sujet 2).\n\n'
      'Ex. : Volo ut exeas / Volo te exire. (Je veux que tu sortes.) '
      'Volo exire. (Je veux sortir.)',
    ),
    paragrapheExplication(
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
      tableauColonnes(
        ['pers.', 'velle', 'nolle', 'malle'],
        [
          ['je', 'volo', 'nolo', 'malo'],
          ['tu', 'vis', 'non vis', 'mavis'],
          ['il', 'vult', 'non vult', 'mavult'],
        ],
      ),
      const SizedBox(height: 12),
      paragrapheExplication(
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

final Lecon leconOrdreDefense = Lecon(
  id: 'ordre_et_defense',
  titre: 'L\'ordre et la défense',
  sousTitre: 'Impératif (2e pers.), subjonctif (1re/3e pers.), et noli + infinitif',
  icone: Icons.block,
  unite: 'Vol. II – Unité 10',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Observe l\'ordre et la défense du verbe ire à toutes les '
      'personnes :',
    ),
    tableauColonnes(
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
    titreExplication('L\'ordre : impératif à la 2e personne, subjonctif ailleurs'),
    paragrapheExplication(
      'Pour l\'ordre, contrairement au français, le latin ne connaît '
      'l\'impératif qu\'à la 2e personne (singulier et pluriel). Aux '
      'deux autres personnes, c\'est le subjonctif qui exprime cette '
      'idée de « volition ». À la 1re personne, un « ordre » donné à '
      'soi-même correspond plutôt à une exhortation, une forme qu\'on '
      'retrouve surtout au pluriel.\n\n'
      'Ex. : Domum redeamus ! (Rentrons à la maison !)',
    ),
    titreExplication('La défense à la 2e personne : noli / nolite + infinitif'),
    paragrapheExplication(
      'Pour la défense, la 2e personne présente noli / nolite suivi de '
      'l\'infinitif présent. Il s\'agit à l\'origine de l\'expression '
      'polie de la défense.\n\n'
      'Ex. : noli putare... (ne va pas penser...) nolite existimare... '
      '(n\'allez pas croire...)',
    ),
    paragrapheExplication(
      'À côté de noli / nolite + infinitif présent, le latin classique '
      'utilise ne + subjonctif parfait pour la 2e personne. Ce '
      'subjonctif parfait n\'a pas de notion de temps ou d\'achèvement, '
      'comme à l\'indicatif, mais exprime uniquement l\'action verbale.',
    ),
    paragrapheExplication(
      'Cet emploi est l\'héritier d\'un ancien mode appelé « optatif » '
      'qui servait à exprimer le souhait. Très présent encore en grec '
      'ancien, il a disparu en latin et on en trouve uniquement des '
      'traces dans des formes comme ne faxis, ne dixis.',
    ),
    titreExplication('La défense aux 1re et 3e personnes : ne + subjonctif présent'),
    paragrapheExplication(
      'L\'expression ne + subjonctif présent sert d\'expression de la '
      'défense aux 1re et 3e personnes.',
    ),
    titreExplication('Des constructions variantes selon les époques'),
    paragrapheExplication(
      'D\'autres constructions existent, le système ayant évolué au '
      'cours du temps. Retiens les règles ci-dessus, mais ne sois pas '
      'étonné de trouver des variantes, notamment chez des auteurs '
      'tardifs, comme Sénèque, qui emploie parfois ne + subjonctif '
      'présent à la 2e personne.\n\n'
      'Ex. : non rapias hoc nec testeris (ne va pas t\'en saisir ou '
      't\'en prévaloir) — Sénèque, De Beneficiis, 7, 16, 4.',
    ),
    paragrapheExplication(
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
      tableauColonnes(
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

final Lecon leconTempsParfaitPassif = Lecon(
  id: 'temps_parfait_passif',
  titre: 'Les temps du parfait passif',
  sousTitre: 'Participe parfait + esse, et l\'infinitif passif dans l\'ACI',
  icone: Icons.done_all,
  unite: 'Vol. III – Unité 1',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'amavi (j\'ai aimé) / amatus sum (j\'ai été aimé) — amaverant '
      '(ils avaient aimé) / amati erant (ils avaient été aimés) — '
      'amaverimus (nous aurons aimé) / amati erimus (nous aurons été '
      'aimés).',
    ),
    titreExplication('La formation'),
    paragrapheExplication(
      'Le parfait, le plus-que-parfait et le futur antérieur passifs '
      'sont formés du participe parfait et de l\'auxiliaire esse :',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'Le participe parfait, comme tout adjectif de la 1re classe, '
      's\'accorde en genre, en nombre et en cas avec le sujet : amatus, '
      'amata, amatum sum ; amati, amatae, amata sumus...',
    ),
    titreExplication('L\'infinitif passif dans l\'ACI'),
    paragrapheExplication(
      'Dicit [litteras scribi]. (Il dit que la lettre est écrite. — '
      'rapport de simultanéité.) Dicit [litteras scriptas esse]. (Il '
      'dit que la lettre a été écrite. — rapport d\'antériorité.)',
    ),
    paragrapheExplication(
      'Dans l\'ACI, l\'infinitif parfait passif exprime l\'antériorité '
      'et le participe parfait se met à l\'accusatif.',
    ),
    titreExplication('Cas particulier : l\'infinitif futur passif'),
    paragrapheExplication(
      'Dicit [litteras scriptum iri]. (Il dit que la lettre sera '
      'écrite. — rapport de postériorité.)',
    ),
    paragrapheExplication(
      'L\'infinitif futur passif est une forme invariable composée du '
      'supin + iri. Dans l\'ACI, l\'infinitif futur passif exprime la '
      'postériorité.\n\n'
      'Bon à savoir : la forme iri correspond à l\'infinitif '
      'impersonnel du verbe ire « aller ».',
    ),
    titreExplication('Je récapitule'),
    tableauColonnes(
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
      tableauColonnes(
        ['rapport de temps', 'actif', 'passif'],
        [
          ['antériorité', 'scripsisse', 'scriptum esse'],
          ['simultanéité', 'scribere', 'scribi'],
          ['postériorité', 'scripturum esse', 'scriptum iri'],
        ],
      ),
      const SizedBox(height: 12),
      paragrapheExplication(
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

final Lecon leconFieri = Lecon(
  id: 'fieri',
  titre: 'Fieri',
  sousTitre: 'Le passif de facere : « être fait », « se produire », « devenir »',
  icone: Icons.change_circle,
  unite: 'Vol. III – Unité 1',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'fio, fis, fieri, factus sum : à la fois des formes actives (fio, '
      'fis) et des formes passives (fieri, factus sum) — et trois sens '
      '« être fait, se faire » (sens passif), « se produire, arriver » '
      'et « devenir » (sens actif).',
    ),
    paragrapheExplication(
      'Fieri présente un mélange de formes actives (fio, fis) et '
      'passives (fieri, factus sum) ; de même, ses traductions '
      'mélangent des traductions au passif « être fait, se faire » (= '
      'passif de facio) et à l\'actif « arriver, devenir ». Les '
      'particularités de fieri se présentent donc tant au niveau '
      'morphologique que sémantique.',
    ),
    titreExplication('La morphologie'),
    paragrapheExplication(
      'Aux temps formés sur le radical du présent (fio, fis, fieri > '
      'radical fi-), fio se conjugue comme audio, à l\'exception de '
      'l\'infinitif présent fieri.',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'Infinitif présent : fieri. Indicatif imparfait : fiebam, '
      'fiebas... (sur fi-, comme audiebam). Indicatif futur : fiam, '
      'fies, fiet, fiemus, fietis, fient. Subjonctif imparfait : '
      'fierem, fieres, fieret...',
    ),
    titreExplication('Le parfait : les formes régulières du passif de facere'),
    tableauColonnes(
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
    paragrapheExplication(
      'Particularité : fieri ne possède pas de supin, ni de participes '
      'présent et futur.',
    ),
    titreExplication('Traductions de fio'),
    paragrapheExplication(
      'Les différents sens de fio se déduisent assez facilement de son '
      'emploi premier, le passif de facio :',
    ),
    paragrapheExplication(
      '1. fio sert de passif à facio : « être fait, se faire ».\n\n'
      'Ex. : Haec verba fiunt. (Ces paroles sont prononcées.) Fiat lux '
      'et facta est lux. (Que la lumière soit faite et la lumière fut '
      'faite.) In initio erat Verbum [...] et Verbum caro factum est. '
      '(Au commencement était le Verbe [...] et le Verbe s\'est fait '
      'chair.)',
    ),
    paragrapheExplication(
      '2. Selon le contexte, « être fait » signifie « se produire, '
      'arriver ».\n\n'
      'Ex. : Omni aetate, mala fiunt. (À chaque époque, des maux se '
      'produisent.) Haec fiunt, dum pax paratur. (Ces événements ont '
      'lieu, pendant que la paix est préparée.)',
    ),
    paragrapheExplication(
      '3. Avec un attribut du sujet, « être fait » signifie « '
      'devenir ».\n\n'
      'Ex. : Marcus Tullius Cicero consul factus est. (Marcus Tullius '
      'Cicéron devint consul.) Nonne Nero in dies saevior fit ? (Néron '
      'ne devient-il pas plus cruel de jour en jour ?) Semper optabam '
      'ut sapientior fierem. (Je souhaitais toujours devenir plus '
      'sage.)',
    ),
    paragrapheExplication(
      '4. fieri connaît un emploi impersonnel : fit = « il arrive », '
      'que tu trouves dans des expressions comme fit ut + subjonctif '
      '(« il arrive que ») ou ut fit (« comme il arrive »). Attention, '
      'l\'impersonnel est un neutre : au parfait, tu trouves donc '
      'factum est.\n\n'
      'Ex. : Paulisper, dum se uxor — ut fit — comparat, commoratus '
      'est. (Cicéron, Pro Milone, X, 28 : « Il s\'attarda un petit '
      'moment, pendant que sa femme — comme il arrive — se préparait. »)',
    ),
    titreExplication('Je me souviens : les autres verbes de « il arrive que »'),
    tableauColonnes(
      ['verbe', 'sens'],
      [
        ['accidit ut', 'il arrive que (événement imprévu, souvent négatif)'],
        ['contingit ut', 'il arrive que (événement le plus souvent heureux)'],
        ['evenit ut', 'il arrive que (événement quelconque)'],
        ['fit ut', 'il arrive que (événement quelconque)'],
      ],
    ),
    const SizedBox(height: 12),
    titreExplication('Le passif des composés de facere'),
    paragrapheExplication(
      'Curis conficitur. (Elle est accablée de soucis.) Multi milites '
      'interficientur. (De nombreux soldats seront tués.) Numquam homo '
      'bellis adsuefit. (L\'homme ne s\'habituera jamais aux guerres.)',
    ),
    paragrapheExplication(
      'Les composés en -facere forment leur passif en -fieri (à '
      'quelques exceptions près), les composés en -ficere ont un '
      'passif « régulier ».',
    ),
    tableauColonnes(
      ['composé en -facere', 'sens', 'exemple'],
      [
        ['adsuefacere / assuefacere → adsuefieri / assuefieri', 'habituer → être habitué', 'Pessimis casibus adsuefit.'],
        ['patefacere → patefieri', 'ouvrir → être ouvert', 'Porta patefit = porta aperitur.'],
      ],
    ),
    const SizedBox(height: 12),
    tableauColonnes(
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
      paragrapheExplication(
        'fio, fis, fieri, factus sum. Présent sur fi- (comme audio, '
        'sauf infinitif fieri). Parfait = formes régulières du passif '
        'de facere (factus sum...). Pas de supin ni de participes '
        'présent/futur.',
      ),
      tableauColonnes(
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

final Lecon leconConjonctionDum = Lecon(
  id: 'conjonction_dum',
  titre: 'Mihi adeste ! La conjonction dum',
  sousTitre: 'dum + indicatif (réalité) ou + subjonctif (fait envisagé)',
  icone: Icons.hourglass_bottom,
  unite: 'Vol. III – Unité 1',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Tu as déjà appris que la conjonction de subordination dum suivie '
      'de l\'indicatif se traduit par « pendant que » ou « jusqu\'au '
      'moment où ». Tu découvres à présent les autres emplois de cette '
      'conjonction, que tu peux répartir en deux grandes catégories :',
    ),
    paragrapheExplication(
      'dum + indicatif = réalité présente, passée ou future\n'
      'dum + subjonctif = fait envisagé, hypothétique',
    ),
    titreExplication('1. dum + indicatif'),
    paragrapheExplication(
      'Dum haec fiunt, Caesar oppidum cum catervis petivit. (Pendant '
      'que ceci se produisait, César gagna la place forte avec ses '
      'troupes.) Dum fortuna tecum erit / erat, multi amici tibi erunt '
      '/ erant. (Aussi longtemps que la fortune sera / était avec toi, '
      'tu auras / avais de nombreux amis.) Exspectate, dum redibimus. '
      '(Attendez jusqu\'au moment où nous reviendrons !)',
    ),
    paragrapheExplication(
      'dum + indicatif présent (quel que soit le temps du verbe de la '
      'principale) → pendant que + indicatif (à adapter selon la '
      'concordance des temps en français).\n\n'
      'dum + indicatif (imparfait, plus-que-parfait, futur, futur '
      'antérieur) → aussi longtemps que, tant que + indicatif ; '
      'jusqu\'au moment où + indicatif.',
    ),
    titreExplication('2. dum + subjonctif'),
    paragrapheExplication(
      'Exspectate, dum redeamus. (Attendez jusqu\'à ce que nous '
      'revenions !) Oderint, dum metuant. (Qu\'ils haïssent, pourvu '
      'qu\'ils craignent !) Omnia fecit, dum imperium ei esset. (Il fit '
      'tout, pourvu que le pouvoir lui appartînt.) Nihil fecit, dum '
      'amici venirent. (Il ne fit rien, en attendant que ses amis '
      'arrivent.)',
    ),
    paragrapheExplication(
      'dum + subjonctif → jusqu\'à ce que, en attendant que + '
      'subjonctif ; pourvu que + subjonctif.',
    ),
    paragrapheExplication(
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
      tableauColonnes(
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

final Lecon leconPassifsPersonnelImpersonnelNCI = Lecon(
  id: 'passifs_personnel_impersonnel_nci',
  titre: 'Passifs personnel et impersonnel ; NCI',
  sousTitre: 'Le passif sans sujet, et le Nominativus cum Infinitivo',
  icone: Icons.forum,
  unite: 'Vol. III – Unité 2',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Avec le passif des temps du parfait, tu as complété tes '
      'connaissances de la morphologie du passif en latin. Tu '
      'apprends maintenant les « cas particuliers », où latin et '
      'français ne fonctionnent pas de la même manière.',
    ),
    titreExplication('1. Le passif personnel'),
    paragrapheExplication(
      'Le latin utilise le passif beaucoup plus volontiers que le '
      'français. Il est donc parfois utile de transformer un passif à '
      'l\'actif pour améliorer la traduction.\n\n'
      'Civium virtus a principe laudatur. (La vertu des citoyens est '
      'louée par l\'empereur. → L\'empereur loue la vertu des '
      'citoyens.) Egregia facta a poetis canuntur. (Les hauts faits '
      'sont chantés par les poètes. → Les poètes chantent les hauts '
      'faits.)',
    ),
    paragrapheExplication(
      'Quand, en latin, la phrase passive n\'a pas de complément '
      'd\'agent, le français traduit le plus souvent en transposant la '
      'phrase à l\'actif et en se servant du sujet « on ».\n\n'
      'Civium virtus laudatur. (La vertu des citoyens est louée. → On '
      'loue la vertu des citoyens.) Egregia facta canuntur. (Les hauts '
      'faits sont chantés. → On chante les hauts faits.)',
    ),
    paragrapheExplication(
      'Bon à savoir : d\'où vient le pronom « on » ? Le latin ne '
      'connaît pas le pronom indéfini « on », qui, étymologiquement, '
      's\'explique par le nom latin homo (nominatif) → « on », dont '
      'l\'accusatif hominem a donné « homme ».',
    ),
    paragrapheExplication(
      'Tu peux traduire un passif personnel en gardant le verbe au '
      'passif, ou en le transformant à l\'actif. Pour faire la '
      'transformation active : s\'il y a un complément du passif, '
      'celui-ci devient sujet ; s\'il n\'y a pas de complément du '
      'passif, tu peux utiliser le pronom « on ».',
    ),
    titreExplication('2. Le passif impersonnel'),
    paragrapheExplication(
      'Romam itur. Romae manebitur. Pugnatum est. Consuli respondetur.',
    ),
    paragrapheExplication(
      'En principe, tu as appris que, dans la transformation passive, '
      'le complément du verbe à l\'accusatif devient sujet du verbe au '
      'passif : Princeps virtutem laudat. → Virtus a principe laudatur.',
    ),
    paragrapheExplication(
      'Or, les verbes ire « aller », manere « rester », pugnare (cum) '
      '« combattre (contre) » ne sont pas suivis d\'un accusatif en '
      'latin, et le verbe respondere « répondre », ici, ne l\'est pas '
      'non plus. En principe, ces verbes ne devraient donc pas être au '
      'passif.',
    ),
    paragrapheExplication(
      'Or en latin, tous les verbes, même les verbes intransitifs, '
      'peuvent se mettre au passif. Sans accusatif à l\'actif, ces '
      'verbes n\'ont donc pas de sujet au passif : il ne s\'agit plus '
      'd\'un « vrai » passif, mais d\'un passif impersonnel.\n\n'
      'Romam itur. (On va à Rome.) Romae manebitur. (On restera à '
      'Rome.) Pugnatum est. (On combattit.) Consuli respondetur. (On '
      'répond au consul.)',
    ),
    paragrapheExplication(
      'Employé sans sujet, à la 3e personne du singulier (neutre), le '
      'verbe est au passif impersonnel. Il se traduit par « on ».',
    ),
    titreExplication('Cas particulier : l\'infinitif impersonnel'),
    paragrapheExplication(
      'Attention : c\'est l\'infinitif, et non le verbe « pouvoir » '
      'qu\'il faut mettre au passif impersonnel (comparable à '
      'l\'allemand : Es kann gekämpft werden). Avec les verbes suivis '
      'd\'un infinitif, c\'est donc l\'infinitif qui se met au passif '
      'impersonnel, et non le verbe conjugué.\n\n'
      'Ex. : On ne peut pas vaincre. → Vinci non potest.',
    ),
    paragrapheExplication(
      'Le passif impersonnel produit parfois un effet de style : dans '
      'un récit de bataille confuse (par exemple au siège d\'Alésia, '
      'chez César), un passif impersonnel comme cum pugnaretur (« comme '
      'on combattait ») rend la confusion du combat, où des soldats des '
      'deux camps se mêlent sans qu\'aucun sujet précis ne se dégage.',
    ),
    titreExplication('Méthode pratique pour le thème'),
    paragrapheExplication(
      'Une phrase qui présente le pronom impersonnel « on » mérite une '
      'attention particulière. Il faut vérifier si le verbe est suivi '
      'd\'un COD, c\'est-à-dire si le verbe se construit avec un '
      'accusatif en latin.\n\n'
      'On lit beaucoup à l\'école. (pas de COD en français) — On lit '
      'beaucoup de livres à l\'école. (COD : « beaucoup de livres »)',
    ),
    paragrapheExplication(
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
    titreExplication('3. Nominativus cum infinitivo (NCI)'),
    paragrapheExplication(
      'Tu viens de voir que pugnatur se traduit par « on combat », '
      'itur « on va », dicitur « on dit ». Or, que se passe-t-il si le '
      'passif impersonnel dicitur est complété par une proposition '
      'infinitive ?',
    ),
    paragrapheExplication(
      'Pour traduire « On dit que Homère a été aveugle », le latin '
      'évite Dicitur [Homerum caecum fuisse] (un ACI complétant un '
      'passif impersonnel) et dit plutôt : Homerus dicitur caecus '
      'fuisse. (littéralement « Homère est dit avoir été aveugle ».) → '
      'Le sujet de l\'ACI devient sujet du verbe au passif.',
    ),
    paragrapheExplication(
      'Le latin évite généralement de compléter un verbe au passif '
      'impersonnel par un ACI. Il emploie plutôt une tournure '
      'personnelle avec un sujet : le Nominativus cum Infinitivo (NCI).\n\n'
      'Ex. : Dicitur [Romam perpetuam esse] → Roma dicitur perpetua '
      'esse. (On dit que Rome est éternelle.) Creditur [Cleopatram '
      'Antonium delectavisse] → Cleopatra creditur Antonium '
      'delectavisse. (On croit que Cléopâtre a charmé Antoine.)',
    ),
    paragrapheExplication(
      'Comme tu as déjà de solides connaissances en anglais, aide-toi '
      'en traduisant en anglais le NCI latin, qui fonctionne de la même '
      'manière : Rome is said to be eternal. Homer is reported to have '
      'been blind. Cleopatra is thought to have seduced Antony.',
    ),
    titreExplication('Cas particuliers : cogor, jubeor'),
    paragrapheExplication(
      'Hostes cedere coguntur. Milites arma capere jubentur. Equites '
      'Romani flere vetabantur. Si coguntur se traduit facilement par '
      'un passif en français (« ils sont forcés/obligés/contraints de '
      '»), jubentur et vetabantur posent problème : le français ne peut '
      'pas mettre au passif « ordonner à qqn » ou « interdire à qqn ». '
      'Il faut donc recourir à une tournure impersonnelle : « on '
      'ordonne (de) », « recevoir l\'ordre (de)... », « on interdit à '
      'qqn de ».',
    ),
    paragrapheExplication(
      'Retiens l\'emploi obligatoire du passif personnel (avec sujet) '
      'avec jubere et cogere : cogor « on me force à, je suis forcé de '
      '» ; jubeor « on m\'ordonne de, je reçois l\'ordre de ». Ces '
      'verbes se construisent donc avec un NCI.',
    ),
    titreExplication('Je récapitule : la traduction de « on »'),
    tableauColonnes(
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
      paragrapheExplication(
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

final Lecon leconIndefinisQuidamAliquisQuis = Lecon(
  id: 'indefinis_quidam_aliquis_quis',
  titre: 'Les indéfinis quidam, aliquis et quis',
  sousTitre: '« un certain », « quelqu\'un (inconnu) », et un troisième, plus rare',
  icone: Icons.question_mark,
  unite: 'Vol. III – Unité 2',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Quidam venit. (Quelqu\'un est venu.) Vir quidam, Rufus nomine, '
      'venit. (Un certain homme, du nom de Rufus, est venu.) Aliquis '
      'venit. (Quelqu\'un est venu.) alicui parcere (épargner '
      'quelqu\'un) verba facere de aliqua re (parler de quelque chose)',
    ),
    paragrapheExplication(
      'Les pronoms indéfinis aliquis et quidam se traduisent en '
      'français par « quelqu\'un », « quelque chose », mais :\n\n'
      '• quidam désigne une personne ou une chose que l\'on pourrait '
      'préciser ;\n'
      '• aliquis a un sens plus indéfini que quidam : il désigne une '
      'personne ou une chose que l\'on ne connaît pas.\n\n'
      'Voilà pourquoi aliquis se prête bien à indiquer la construction '
      'd\'un verbe ou d\'un adjectif dans le dictionnaire.',
    ),
    paragrapheExplication(
      'Ces pronoms-adjectifs indéfinis se déclinent, à quelques '
      'différences près, comme le pronom interrogatif quis, quae, quid '
      'et l\'adjectif interrogatif qui, quae, quod.',
    ),
    titreExplication('1. Le pronom-adjectif quidam'),
    tableauColonnes(
      ['', 'pronom', 'adjectif'],
      [
        ['formes', 'quidam, quaedam, quiddam', 'quidam, quaedam, quoddam'],
        ['sens', '« un certain homme, quelqu\'un, quelque chose »', '« un certain, certaine, un »'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Désigne une personne ou une chose qu\'on pourrait préciser.\n\n'
      'Remarques : la particule -dam est invariable et se soude au '
      'pronom-adjectif (quidam, cujusdam, quibusdam...) ; le -m- peut '
      'se transformer en -n- devant -d- (quorumdam > quorundam).',
    ),
    paragrapheExplication(
      'Quidam venit. (Quelqu\'un est venu. Un certain homme est venu — '
      'je sais qui, mais il n\'est pas important de le préciser.) Vir '
      'quidam, Rufus nomine, venit. (Un (certain) homme, du nom de '
      'Rufus, est venu — même emploi que l\'article indéfini « un, une '
      '» en français.) furor quidam (une certaine folie, une sorte de '
      'folie)',
    ),
    titreExplication('2. Le pronom-adjectif aliquis'),
    tableauColonnes(
      ['', 'pronom', 'adjectif'],
      [
        ['formes', 'aliquis, aliqua, aliquid', 'aliqui(s), aliqua, aliquod'],
        ['sens', '« quelqu\'un, quelque chose »', '« quelque »'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Désigne une personne ou une chose que l\'on ne connaît pas.\n\n'
      'Aliquis venit. (Quelqu\'un est venu — je ne sais pas qui.) '
      'alicui parcere (épargner quelqu\'un) verba facere de aliqua re '
      '(parler de quelque chose)',
    ),
    paragrapheExplication(
      'Remarques :\n\n'
      '1) Comme aliquis désigne une personne ou une chose qu\'on ne '
      'connaît pas, on emploie le pronom-adjectif pour indiquer la '
      'construction d\'un verbe ou d\'un adjectif : pour « épargner '
      'quelqu\'un », on peut dire parcere + datif, ou parcere alicui.\n\n'
      '2) Au lieu du pluriel de aliquis, on utilise plutôt nonnulli, '
      'ae, a « quelques-uns, quelques ».',
    ),
    titreExplication('3. Un troisième indéfini, plus rare : quis, qui'),
    paragrapheExplication(
      'Il existe un troisième pronom-adjectif, quis, quae, quid / qui, '
      'quae, quod, de valeur très indéterminée : « quelqu\'un '
      '(éventuellement), on ». Son emploi est très limité, et on le '
      'trouve uniquement après certains mots.',
    ),
    paragrapheExplication(
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
    paragrapheExplication(
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
      tableauColonnes(
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

final Lecon leconComparaisonDeDeux = Lecon(
  id: 'comparaison_de_deux',
  titre: 'Comparaison de deux personnes ou choses',
  sousTitre: 'Le latin préfère le comparatif là où le français emploie le superlatif',
  icone: Icons.balance,
  unite: 'Vol. III – Unité 2',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Saepe dextra validior manus est. (Souvent, la main droite est '
      'la plus forte.) Caesar eo anno fortior consul erat. (Cette '
      'année-là, César était le consul le plus courageux.)',
    ),
    paragrapheExplication(
      'En présence de deux éléments, le latin — comme l\'allemand — '
      'utilise le comparatif (comparatif de l\'adjectif + génitif '
      'partitif, ou adjectif et nom accordés), alors que le français '
      'préfère le superlatif.',
    ),
    paragrapheExplication(
      'validior manuum / validior manus → la plus forte des deux mains '
      '/ la main la plus forte (des deux).\n\n'
      'fortior consulum / fortior consul → le plus courageux des deux '
      'consuls / le consul le plus courageux (des deux).\n\n'
      'majus malorum / majus malum → le plus grand des deux maux / le '
      'plus grand mal (des deux).',
    ),
    titreExplication('Cas particulier : le pluriel'),
    paragrapheExplication(
      'De même, au pluriel, le latin utilise plutôt un comparatif là '
      'où le français préfère le superlatif quand il s\'agit de deux '
      'groupes.\n\n'
      'Ex. : Nostri ferociores erant. (Les nôtres étaient les plus '
      'farouches — de deux partis, deux armées, deux camps en présence '
      'l\'un de l\'autre.)',
    ),
    titreExplication('L\'expression de l\'âge au quotidien et dans l\'armée'),
    tableauColonnes(
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
      paragrapheExplication(
        'Pour deux éléments, le latin (comme l\'allemand) emploie le '
        'comparatif là où le français préfère le superlatif : validior '
        'manus, « la main la plus forte (des deux) ».',
      ),
      tableauColonnes(
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

final Lecon leconVerbesDeponents = Lecon(
  id: 'verbes_deponents',
  titre: 'Les verbes déponents',
  sousTitre: 'Forme passive, sens actif : miror, vereor, utor, patior, experior',
  icone: Icons.sync_alt,
  unite: 'Vol. III – Unité 3',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'miror, miraris, mirari, miratus sum (admirer, s\'étonner) ; '
      'vereor, vereris, vereri, veritus sum (craindre, respecter) ; '
      'utor, uteris, uti, usus sum + abl. (se servir de, utiliser) ; '
      'patior, pateris, pati, passus sum (supporter, souffrir, '
      'permettre) ; experior, experiris, experiri, expertus sum '
      '(essayer, faire l\'expérience de, éprouver).',
    ),
    paragrapheExplication(
      'Que constates-tu quant à la forme de ces verbes, et quant à leur '
      'sens ? En observant leurs temps primitifs, combien de modèles de '
      'conjugaison ces verbes suivent-ils ?',
    ),
    paragrapheExplication('Les verbes déponents sont de forme passive mais de sens actif.'),
    titreExplication('Bon à savoir : d\'où vient le nom « déponent » ?'),
    paragrapheExplication(
      'Ces verbes ont été appelés « déponents » par les grammairiens '
      'latins, qui considéraient qu\'ils avaient « déposé » (deponere) '
      ', donc abandonné, le sens passif.',
    ),
    paragrapheExplication(
      'En réalité, les verbes déponents sont les héritiers d\'un ancien '
      'système verbal indo-européen. L\'indo-européen n\'oppose pas '
      'actif et passif, mais actif et moyen — le passif ne s\'est '
      'développé que plus tard. Le moyen indique que le sujet du verbe '
      'est personnellement intéressé par le développement de '
      'l\'action, qu\'il accomplit pour ainsi dire pour lui-même : une '
      'sorte de voix « égocentrique ».',
    ),
    paragrapheExplication(
      'Le latin a en principe abandonné cette voix moyenne, sauf pour '
      'les verbes déponents, qui en sont une réminiscence : ces '
      'verbes, par leur sens, dénotent des actions où le sujet est '
      'toujours personnellement impliqué — naître (nascor), mourir '
      '(morior), utiliser (utor), éprouver un sentiment (miror, '
      'vereor, patior)...',
    ),
    titreExplication('La conjugaison des verbes déponents : 5 modèles'),
    tableauColonnes(
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
    paragrapheExplication(
      'Pour conjuguer les verbes déponents aux temps formés sur le '
      'radical du présent, il est donc utile de faire un « détour » '
      'mental par le modèle actif, après avoir repéré le radical des '
      'verbes déponents.\n\n'
      'Ex. : « il craignait » → vereri fonctionne comme le passif de '
      'monere → radical verē-, comme monē- → « il avertissait » = '
      'monebat → « il était averti » = monebatur → « il craignait » = '
      'verebatur.',
    ),
    paragrapheExplication(
      'Les radicaux des 5 modèles déponents : mirā-, verē-, ut-, '
      'pati-, experī-.\n\n'
      'Pour les autres temps (parfait, plus-que-parfait, futur '
      'antérieur, subjonctifs parfait et plus-que-parfait, infinitif '
      'parfait), sers-toi du parfait passif appris avec les temps '
      'primitifs.\n\n'
      'Ex. : vereor, vereris, vereri, veritus sum → veritus eram, ero, '
      'sim, essem, esse.',
    ),
    titreExplication('Cas particuliers'),
    paragrapheExplication(
      '1. Certaines formes n\'existent pas au passif et sont donc '
      'empruntées à l\'actif : le participe présent (mirans, '
      'mirantis, « admirant »), le gérondif (mirandum, « le fait '
      'd\'admirer »), le supin (miratum, « pour admirer »), le '
      'participe futur (miraturus, a, um, « sur le point d\'admirer '
      '») et l\'infinitif futur (miraturum, am, um esse, expression de '
      'la postériorité dans l\'ACI).',
    ),
    paragrapheExplication(
      '2. Le verbe morior, -eris, mori, mortuus sum « mourir » a un '
      'participe futur irrégulier : moriturus, a, um « destiné à '
      'mourir, sur le point de mourir ».',
    ),
    paragrapheExplication(
      '3. Attention à la traduction des participes : les verbes '
      'déponents ont toujours un sens actif. Le participe présent '
      '(mirans, « admirant ») garde donc un sens actif, comme pour '
      'tout verbe ; mais le participe « parfait » de forme passive '
      '(miratus, a, um) se traduit lui aussi à l\'actif : « ayant '
      'admiré » (et non « ayant été admiré »).',
    ),
    paragrapheExplication(
      '4. L\'impératif — rare pour les verbes au passif — est fréquent '
      'pour les verbes déponents. Pour former l\'impératif passif à la '
      '2e personne du singulier, on remplace la terminaison -ris par '
      '-re. L\'impératif passif de la 2e personne du pluriel est '
      'identique à la forme de l\'indicatif présent.\n\n'
      'Ex. : Admire ! = Mirare ! Admirez ! = Miramini !',
    ),
    paragrapheExplication(
      '5. Le passif du verbe videre peut se traduire littéralement '
      'par le passif de « voir », mais aussi à l\'actif par « sembler, '
      'paraître ». Dans ce cas, videri se construit avec un attribut '
      'du sujet, et peut être accompagné d\'un datif d\'intérêt et '
      'd\'un infinitif.\n\n'
      'Ex. : Quam beata nunc mihi videtur pueritia nostra ! (Combien '
      'heureuse me semble maintenant notre enfance !) Saepe errare '
      'videtur. (Il semble souvent se tromper.)',
    ),
    paragrapheExplication(
      'De plus, videri connaît un emploi impersonnel à côté de '
      'l\'emploi personnel : Mihi videtur, tibi videtur, ei videtur... '
      '(Il me/te/lui semble (bon)...) Mihi videor, tibi videris, sibi '
      'videtur... (Je m\'imagine, tu t\'imagines, il s\'imagine... — je '
      'crois, tu crois, il croit...)',
    ),
    paragrapheExplication(
      '6. Certains verbes, appelés semi-déponents, ne sont déponents '
      'qu\'aux temps du parfait.',
    ),
    tableauColonnes(
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
      tableauColonnes(
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
      paragrapheExplication(
        'Forme passive, sens actif. Participe présent, gérondif, '
        'supin, participe et infinitif futurs = empruntés à l\'actif. '
        'Participe « parfait » = sens actif (miratus, « ayant admiré »).',
      ),
    ],
  ),
);

