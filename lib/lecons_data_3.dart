import 'package:flutter/material.dart';

import 'grammaire_tableaux_data.dart';
import 'lecons_core.dart';
import 'screens/declinaisons_screen.dart' show tableauDeclinaison;

// ------------------------------------------------------------
// Leçon : Les pronoms-adjectifs démonstratifs hic, iste, ille
// ------------------------------------------------------------

final Lecon leconDemonstratifsHicIsteIlle = Lecon(
  id: 'demonstratifs_hic_iste_ille',
  titre: 'Les pronoms-adjectifs démonstratifs hic, iste, ille',
  sousTitre: 'Montrer et situer : proche, éloigné, le plus éloigné',
  icone: Icons.touch_app,
  unite: 'Vol. II – Unité 2',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Les pronoms-adjectifs démonstratifs servent à montrer, à situer '
      'dans l\'espace et le temps. Le latin en connaît trois '
      'différents : hic, haec, hoc ; iste, ista, istud et ille, illa, '
      'illud.',
    ),
    titreExplication('Hic, haec, hoc'),
    paragrapheExplication(
      'Pronom : celui-ci, celle-ci, ceci — Adjectif : ce... -ci, cet... '
      '-ci, cette... -ci.\n\n'
      'Hic est le pronom-adjectif démonstratif qui désigne ce qui est '
      'le plus rapproché du locuteur, que ce soit dans l\'espace, dans '
      'le temps ou dans la pensée. Il s\'ensuit un lien avec la 1re '
      'personne (je, nous).',
    ),
    paragrapheExplication(
      'hic liber, « ce livre-ci » = « le livre qui est ici » ou « le '
      'livre que je tiens », ou même « mon livre »\n'
      'hic dies, « ce jour-ci » = « le jour présent »\n'
      'hoc die (abl.) > hodie (adv.), « aujourd\'hui »\n'
      'hoc tempore, « à cette époque-ci » = « à notre époque »\n'
      'haec urbs, « cette ville-ci » = « la ville dans laquelle '
      'j\'habite/nous habitons »',
    ),
    tableauColonnes(
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
    tableauColonnes(
      ['cas', 'masc. pl.', 'fém. pl.', 'neutre pl.'],
      [
        ['nom.', 'hi', 'hae', 'haec'],
        ['acc.', 'hos', 'has', 'haec'],
        ['gén.', 'horum', 'harum', 'horum'],
        ['dat./abl.', 'his', 'his', 'his'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'La déclinaison du pronom hic présente de nombreuses '
      'terminaisons appartenant à la 1re et à la 2e déclinaison, '
      'notamment au pluriel. Au singulier, le génitif est en -jus, le '
      'datif en -i, terminaisons caractéristiques des pronoms-adjectifs '
      '(cf. ejus, cujus et ei, cui). Enfin, on remarque à certaines '
      'formes la présence d\'une particule démonstrative -c, reste '
      'd\'une ancienne particule démonstrative -ce (cf. ecce, « voici »).',
    ),
    paragrapheExplication(
      'Cette particule -ce peut apparaître sous plusieurs formes : -ce '
      '(hujusce, hosce...) ; -ci quand hic est suivi de la particule '
      'interrogative -ne (hicine, haecine, hocine ?) ; -c (hunc, hanc, '
      'huic, etc.).',
    ),
    titreExplication('Iste, ista, istud'),
    paragrapheExplication(
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
    paragrapheExplication(
      'iste liber, « ce livre-là » = « le livre que tu tiens », « ton '
      'livre », ou même « ce (mauvais) livre »\n'
      'ista urbs, « cette ville-là » = « la ville dans laquelle tu '
      'habites / vous habitez », ou même « cette (horrible) ville »',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'En plus du génitif en -ius et du datif en -i, on retrouve la '
      'particule -d typique des pronoms-adjectifs au neutre (cf. id, '
      'quod). Pour le reste, iste suit les 1re et 2e déclinaisons (le '
      'pluriel se décline comme boni, ae, a).',
    ),
    titreExplication('Ille, illa, illud'),
    paragrapheExplication(
      'Pronom : celui-là, celle-là, cela — Adjectif : ce... -là, cet... '
      '-là, cette... -là.\n\n'
      'Ille est le pronom-adjectif démonstratif de l\'objet éloigné : il '
      'désigne ce qui est le plus éloigné du locuteur dans l\'espace, '
      'le temps ou la pensée. Ille a parfois un sens laudatif (< '
      'laudare, « louer »).',
    ),
    paragrapheExplication(
      'ille liber, « ce livre-là » = « le livre qui est là-bas », ou '
      'même « ce (bon) livre »\n'
      'illa tempora, « ces temps-là » = « ces temps lointains », ou '
      'même « ces temps illustres »\n'
      'Medea illa, « la célèbre Médée »\n'
      'ille imperator, « ce général-là » ou « ce grand général »',
    ),
    tableauColonnes(
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
    paragrapheExplication(
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
    paragrapheExplication(
      'Ille est à l\'origine du pronom personnel français : il < ille, '
      'elle < illa, lui < illi, les < illos, leur < illorum, le < '
      'illum, la < illam, etc.',
    ),
    titreExplication('Opposer deux personnes ou choses déjà nommées'),
    paragrapheExplication(
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
      tableauColonnes(
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

final Lecon leconCCTemps = Lecon(
  id: 'cct_temps',
  titre: 'Les compléments circonstanciels de temps',
  sousTitre: 'La date (ablatif) et la durée ((per +) accusatif)',
  icone: Icons.calendar_month,
  unite: 'Vol. II – Unité 2',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
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
    titreExplication('1. La date — Quando ? (« Quand ? À quel moment ? »)'),
    paragrapheExplication(
      'Ce complément est exprimé à l\'ABLATIF.\n\n'
      'Ex. : illo tempore (à cette époque-là), hac aetate (à notre '
      'époque), sexta hora (à la sixième heure), vere / hieme (au '
      'printemps / en hiver), aestate / autumno (en été / en automne), '
      'septimo mense (le septième mois), nono jam anno (déjà la '
      'neuvième année), tribus (III) post / ante mensibus (trois mois '
      'après / avant).',
    ),
    titreExplication(
      '2. La durée — Quam diu ? ou Quamdiu ? (« Pendant combien de '
      'temps ? Combien de temps ? »)',
    ),
    paragrapheExplication(
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
      tableauColonnes(
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

final Lecon leconCCLieu = Lecon(
  id: 'cct_lieu',
  titre: 'Les compléments circonstanciels de lieu',
  sousTitre: 'Ubi, quo, unde, qua — et le régime particulier des noms de ville',
  icone: Icons.signpost,
  unite: 'Vol. II – Unité 2',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('Règle générale'),
    paragrapheExplication(
      'Tu connais déjà deux adverbes interrogatifs portant sur le lieu '
      ': ubi et quo. Voici le tableau complet des adverbes '
      'interrogatifs de lieu.',
    ),
    tableauColonnes(
      ['adverbe', 'explication', 'traduction'],
      [
        ['Ubi... ?', 'interroge sur le lieu où l\'on est', 'Où est-ce que... ?'],
        ['Quo... ?', 'interroge sur le lieu où l\'on va', 'Où est-ce que... ?'],
        ['Unde... ?', 'interroge sur le lieu d\'où l\'on vient', 'D\'où est-ce que... ?'],
        ['Qua... ?', 'interroge sur le lieu par où l\'on passe', 'Par où est-ce que... ?'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'En général, le latin utilise des prépositions pour exprimer les '
      'compléments de lieu.',
    ),
    tableauColonnes(
      ['question', 'préposition + cas'],
      [
        ['Ubi ?', 'in + ablatif'],
        ['Quo ?', 'in + accusatif'],
        ['Unde ?', 'ex + ablatif'],
        ['Qua ?', 'per + accusatif'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Or, pour les noms de villes, ainsi que pour domus (la maison), '
      'humus (le sol, la terre) et rus (la campagne), d\'autres règles '
      's\'appliquent.',
    ),
    titreExplication('Cas particuliers : en réponse à ubi ?'),
    paragrapheExplication(
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
    paragrapheExplication(
      'Pour les autres noms de ville (au pluriel, ou de la 3e '
      'déclinaison), on a l\'ablatif sans préposition en réponse à '
      'ubi.\n\n'
      'Ex. : Athenis sum (je suis à Athènes), Delphis sum (je suis à '
      'Delphes), Carthagine sum (je suis à Carthage).',
    ),
    titreExplication('En réponse aux questions quo ? et unde ?'),
    paragrapheExplication(
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
    titreExplication('En réponse à la question qua ?'),
    paragrapheExplication(
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
    titreExplication('Le locatif pour les petites îles'),
    paragrapheExplication(
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
    titreExplication('La proximité'),
    paragrapheExplication(
      'Ab et ad (emploi de ad avec idée de mouvement) s\'utilisent pour '
      'indiquer la proximité. Voilà pourquoi on trouve ces prépositions '
      'également avec des noms de personnes.\n\n'
      'Ex. : Ad dominum venio (je viens chez mon maître). A domino '
      'venio (je viens de chez mon maître).',
    ),
    paragrapheExplication(
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
      tableauColonnes(
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
      paragrapheExplication(
        'Proximité (ubi ?) : apud/prope/ad + accusatif. Moyens de '
        'communication (qua ?) : ablatif seul.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : La quatrième déclinaison
// ------------------------------------------------------------

final Lecon leconDeclinaison4 = Lecon(
  id: 'decl_4',
  titre: 'La quatrième déclinaison',
  sousTitre: 'exercitus, manus, genu — et domus, aux formes mixtes',
  icone: Icons.front_hand,
  unite: 'Vol. II – Unité 3',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Hostes fortium militum exercitum timebant. (Les ennemis '
      'craignaient l\'armée des soldats courageux.)\n'
      'Nauta manus in mari lavat. (Le marin lave [ses] mains dans la '
      'mer.)\n'
      'Marcus Antonius terram genu tangit. (Marc Antoine touche la '
      'terre du genou.)',
    ),
    paragrapheExplication(
      'Les mots de la 4e déclinaison ont leur génitif singulier en '
      '-us.',
    ),
    paragrapheExplication(
      'La 4e déclinaison comporte peu de mots dans le lexique latin : '
      'essentiellement des noms masculins, quelques noms féminins en '
      '-us et peu de noms neutres en -u.',
    ),
    titreExplication('Nom masculin : exercitus, us, m. « l\'armée »'),
    tableauDeclinaison(declinaisons[6]),
    const SizedBox(height: 12),
    paragrapheExplication(
      'exercitus, us, m. (« l\'armée ») se décline exactement comme '
      'manus ci-dessus : seul le genre change.',
    ),
    titreExplication('Remarques'),
    paragrapheExplication(
      'La terminaison du datif et de l\'ablatif pluriel devrait être '
      '-ubus, mais elle a été refaite sur le modèle de la 3e '
      'déclinaison en -(i)bus, par souci d\'harmonisation.',
    ),
    paragrapheExplication(
      'Certains noms de la 4e déclinaison n\'ont conservé que '
      'l\'ablatif singulier : jussu (+ gén.), « par ordre (de), sur '
      'l\'ordre (de) » ; rogatu (+ gén.), « à la demande (de) » ; natu, '
      '« par l\'âge ».\n\n'
      'Ainsi, major natu se traduit littéralement par « plus grand par '
      'l\'âge » (= plus âgé), et minor natu par « plus petit par '
      'l\'âge » (= plus jeune).',
    ),
    titreExplication('Nom féminin : manus, us, f. « la main ; la troupe »'),
    paragrapheExplication(
      'La 4e déclinaison compte aussi quelques noms féminins, comme '
      'manus, qui se décline exactement comme exercitus.',
    ),
    tableauDeclinaison(declinaisons[6]),
    const SizedBox(height: 12),
    titreExplication('Nom neutre : genu, us, n. « le genou »'),
    tableauDeclinaison(declinaisons[7]),
    const SizedBox(height: 12),
    titreExplication(
      'Cas particulier : formes combinées avec la deuxième déclinaison',
    ),
    paragrapheExplication(
      'Certains noms de la 4e déclinaison peuvent présenter des '
      'terminaisons de la deuxième déclinaison, comme c\'est le cas '
      'pour domus, us, f. (« la maison »).',
    ),
    tableauDeclinaison(declinaisons[13]),
    const SizedBox(height: 12),
    paragrapheExplication(
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

final Lecon leconPronomIdem = Lecon(
  id: 'pronom_idem',
  titre: 'Le pronom-adjectif idem, eadem, idem',
  sousTitre: '« Le même » : identité et similitude',
  icone: Icons.content_copy,
  unite: 'Vol. II – Unité 3',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Idem consul cunctis legionibus praeest. (Le même consul '
      'commande à toutes les légions. — adjectif)\n'
      'Idem cunctis legionibus praeest. (Le même [homme] commande à '
      'toutes les légions. — pronom)',
    ),
    titreExplication('La morphologie'),
    paragrapheExplication(
      'Idem est composé de is, ea, id suivi de la particule -dem '
      '(invariable), et se décline comme is, ea, id. Attention pourtant '
      'aux formes suivantes :\n\n'
      '• le nominatif masculin idem (*is-dem > idem)\n'
      '• le nominatif et l\'accusatif neutres idem (*id-dem > idem)\n'
      '• des formes fréquentes où m devient n devant d : eundem, '
      'eandem (à côté de eumdem, eamdem) ; eorundem, earundem (à côté '
      'de eorumdem, earumdem)',
    ),
    tableauColonnes(
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
    tableauColonnes(
      ['cas', 'masc. pl.', 'fém. pl.', 'neutre pl.'],
      [
        ['nom.', 'eidem', 'eaedem', 'eadem'],
        ['acc.', 'eosdem', 'easdem', 'eadem'],
        ['gén.', 'eorundem', 'earundem', 'eorundem'],
        ['dat./abl.', 'eisdem', 'eisdem', 'eisdem'],
      ],
    ),
    const SizedBox(height: 12),
    titreExplication('Le sens de idem'),
    paragrapheExplication(
      'Idem marque une identité, une similitude :\n\n'
      '• pronom : « le même (homme), la même (femme), la même (chose) '
      '»\n'
      '• adjectif : « le même, la même, les mêmes »',
    ),
    titreExplication('Comment bien traduire idem ?'),
    paragrapheExplication(
      'Afin d\'améliorer ta traduction, tu peux parfois avoir recours '
      'à d\'autres tournures pour traduire idem.\n\n'
      'ego vir fortis idemque philosophus (moi, homme courageux et le '
      'même homme philosophe) → moi, homme courageux et en même temps '
      'philosophe\n\n'
      'audax est idemque prudens (il est audacieux et le même homme '
      'est prévoyant) → il est audacieux et pourtant prévoyant',
    ),
    paragrapheExplication(
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
      paragrapheExplication(
        'idem = is, ea, id + -dem (invariable). Marque une identité, '
        'une similitude (« le même »).\n\n'
        '« le même... que » = idem atque/ac (ou idem... qui).',
      ),
      tableauColonnes(
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

final Lecon leconPronomIpse = Lecon(
  id: 'pronom_ipse',
  titre: 'Le pronom-adjectif ipse, ipsa, ipsum',
  sousTitre: '« Moi-même, lui-même... » : insistance et originalité',
  icone: Icons.fingerprint,
  unite: 'Vol. II – Unité 3',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Ipse consul exercitui praefuit. (Le consul lui-même commanda à '
      'l\'armée.)\n'
      'Ipse exercitui praefuit. (Il commanda lui-même à l\'armée.)\n'
      'Ipse exercitui praefuisti. (Tu commandas toi-même à l\'armée.)',
    ),
    paragrapheExplication(
      'Pourquoi ipse est-il traduit par « lui-même » dans les deux '
      'premiers exemples, et par « toi-même » dans le troisième ? '
      'Parce que ipse s\'accorde en personne avec le sujet du verbe : '
      'praefuit (3e personne) → lui-même ; praefuisti (2e personne) → '
      'toi-même. Ipse renvoie donc à la personne du sujet, exprimée '
      'par la terminaison verbale.',
    ),
    titreExplication('La morphologie'),
    tableauColonnes(
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
    tableauColonnes(
      ['cas', 'masc. pl.', 'fém. pl.', 'neutre pl.'],
      [
        ['nom.', 'ipsi', 'ipsae', 'ipsa'],
        ['acc.', 'ipsos', 'ipsas', 'ipsa'],
        ['gén.', 'ipsorum', 'ipsarum', 'ipsorum'],
        ['dat./abl.', 'ipsis', 'ipsis', 'ipsis'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'La déclinaison de ipse présente de nombreuses terminaisons '
      'appartenant à la 1re et à la 2e déclinaison, notamment au '
      'pluriel. Le génitif est en -jus, le datif en -i, terminaisons '
      'caractéristiques des pronoms-adjectifs (cf. ejus, cujus, hujus, '
      'istius, illius et ei, cui, huic, isti, illi).',
    ),
    titreExplication('Le sens de ipse'),
    paragrapheExplication(
      'Le pronom-adjectif ipse marque une insistance, une originalité '
      ':\n\n'
      '• pronom : « moi-même, toi-même, lui-même, elle-même, '
      'nous-mêmes », etc.\n'
      '• adjectif : « même, lui-même, elle-même », etc.',
    ),
    titreExplication('« Même » avec ou sans trait d\'union ?'),
    paragrapheExplication(
      'Il faut mettre un trait d\'union devant « même » si le mot qui '
      'précède est un pronom personnel : moi, toi, soi, lui, elle, '
      'nous, vous, eux, elles (remarque : avec « nous, vous, eux, '
      'elles », il faut mettre « même » au pluriel : nous-mêmes, '
      'vous-mêmes, eux-mêmes, elles-mêmes).\n\n'
      'On ne met pas de trait d\'union dans les autres cas : le jour '
      'même, cela même, ici même...',
    ),
    titreExplication('Comment bien traduire ipse ?'),
    paragrapheExplication(
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
    paragrapheExplication(
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
      paragrapheExplication(
        'ipse marque l\'insistance et l\'originalité (« lui-même », '
        'par opposition à un autre) — à distinguer de idem, qui marque '
        'l\'identité et la similitude (« le même »).',
      ),
      tableauColonnes(
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

final Lecon leconInterrogatifsExclamatifs = Lecon(
  id: 'interrogatifs_exclamatifs',
  titre: 'Adjectifs et pronoms interrogatifs / exclamatifs',
  sousTitre: 'quis/quid, qui/quae/quod, quam, qualis, quantus',
  icone: Icons.priority_high,
  unite: 'Vol. II – Unité 4',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('Je me rappelle'),
    paragrapheExplication(
      'Tu as déjà étudié l\'interrogation directe : l\'interrogation '
      'totale (-ne...?, nonne...?, num...?) et l\'interrogation '
      'partielle (ubi...?, quo...?, cur...?).',
    ),
    titreExplication('Le pronom interrogatif : quis, quae, quid'),
    paragrapheExplication(
      'Les pronoms interrogatifs servent à interroger sur l\'identité '
      'd\'une personne ou d\'une chose, ainsi que sur la nature d\'une '
      'action.\n\n'
      'Ex. : Quis venit ? (Qui est venu ?) Quid vidisti ? (Qu\'est-ce '
      'que tu as vu ?) Quem vidisti ? (Qui est-ce que tu as vu ?)',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'Au pluriel, le pronom interrogatif se décline exactement comme '
      'le relatif qui, quae, quod (qui, quae, quae au nominatif, etc.).',
    ),
    titreExplication('L\'adjectif interrogatif : qui, quae, quod'),
    paragrapheExplication(
      'Pour s\'informer sur l\'identité ou la qualité, on utilise '
      'l\'adjectif interrogatif, qui s\'accorde en genre et en nombre '
      'avec le nom auquel il se rapporte. La déclinaison de l\'adjectif '
      'interrogatif est identique à celle du relatif qui, quae, quod.\n\n'
      'Ex. : Qui servus venit ? (Quel esclave est venu ?) Quod templum '
      'vidisti ? (Quel temple as-tu vu ?)',
    ),
    paragrapheExplication(
      'Excepté le pronom interrogatif au nominatif masculin et aux '
      'nominatif/accusatif neutres singuliers (quis ? et quid ?), les '
      'adjectifs et pronoms interrogatifs se déclinent donc comme le '
      'relatif qui, quae, quod. Attention à ne pas confondre :\n\n'
      'pronom interrogatif : Quis venit ? (« Qui est venu ? »)\n'
      'adjectif interrogatif : Qui vir venit ? (« Quel homme est '
      'venu ? »)',
    ),
    titreExplication('Particularité : le cum d\'accompagnement'),
    paragrapheExplication(
      'Le cum d\'accompagnement se place après le pronom-adjectif '
      'interrogatif et se soude à lui, comme pour le relatif '
      '(quocum, quibuscum...).\n\n'
      'Ex. : Quibuscum amicis Ledona oppidum petivit ? (À qui as-tu '
      'parlé ? littéralement : Avec quels amis Ledona a-t-elle gagné '
      'la place forte ?)',
    ),
    titreExplication('Un adverbe interrogatif : quam'),
    paragrapheExplication(
      'Pour s\'informer sur le degré ou la quantité, on utilise '
      'l\'adverbe interrogatif quam, suivi d\'un adjectif ou d\'un '
      'adverbe (« combien + adj./adv. »). Pour s\'informer sur le '
      'nombre, on utilise quam multi, ae, a ou l\'adverbe invariable '
      'quot.\n\n'
      'Ex. : Quam dives est ? (Combien riche est-il ? = À quel point '
      'est-il riche ?) Quam multi / Quot milites venerunt ? (Combien '
      'de soldats sont venus ?)',
    ),
    titreExplication('Des adjectifs interrogatifs pour la qualité et la grandeur'),
    paragrapheExplication(
      'Le latin connaît d\'autres adjectifs interrogatifs :\n\n'
      '• qualis, e ? (« Quelle sorte de ? »)\n'
      '• quantus, a, um ? (« Combien grand ? De quelle grandeur ? »)\n\n'
      'Ex. : Qualis vir es ? (Quelle sorte d\'homme es-tu ?) Quanta est '
      'ejus audacia ? (Quelle est son audace ?)',
    ),
    titreExplication('L\'emploi exclamatif des adjectifs interrogatifs'),
    paragrapheExplication(
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
      paragrapheExplication(
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

final Lecon leconParticipeInfinitifFuturs = Lecon(
  id: 'participe_infinitif_futurs',
  titre: 'Participe et infinitif futurs',
  sousTitre: 'amaturus, a, um — et la postériorité complète dans l\'ACI',
  icone: Icons.flight_takeoff,
  unite: 'Vol. II – Unité 4',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      '« Ave imperator, morituri te salutant. » (Salut empereur, ceux '
      'qui vont mourir te saluent !)',
    ),
    titreExplication('La formation du participe futur actif'),
    paragrapheExplication(
      'On obtient le participe futur actif en ajoutant -urus, -ura, '
      '-urum au radical du supin.',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'Les verbes qui n\'ont pas de supin n\'ont donc, en principe, pas '
      'de participe futur. Pourtant, le verbe esse et ses composés en '
      'ont un : futurus, a, um ; profuturus, a, um ; etc.',
    ),
    titreExplication('Le sens du participe futur'),
    paragrapheExplication(
      'Le participe futur exprime une idée d\'avenir que le français ne '
      'peut traduire telle quelle, mais qu\'il peut rendre par les '
      'tournures suivantes.\n\n'
      'amaturus, a, um = sur le point d\'aimer / ayant l\'intention '
      'd\'aimer / disposé à aimer / destiné à aimer',
    ),
    paragrapheExplication(
      'On peut trouver ce participe futur employé comme adjectif, '
      'apposé à un autre mot de la phrase ou comme adjectif '
      'substantivé.\n\n'
      'Ex. : Dux milites pugnaturos laudat. (Le chef loue les soldats '
      'disposés à combattre.)',
    ),
    paragrapheExplication(
      'De même que les participes présent et parfait, le participe '
      'futur apposé peut être traduit par une subordonnée relative en '
      'français.\n\n'
      'Ex. : Novistine amicos venturos ? (Connais-tu les amis qui vont '
      'venir ?)',
    ),
    titreExplication('Le participe futur, attribut du sujet'),
    paragrapheExplication(
      'Le participe futur s\'emploie souvent comme attribut du sujet, '
      'avec le verbe esse conjugué à tous les temps, pour exprimer '
      'l\'intention, la fatalité ou le futur proche.\n\n'
      'amaturus sum (eram, ero...) = j\'ai (j\'avais, j\'aurai...) '
      'l\'intention d\'aimer, je suis (j\'étais, je serai...) disposé/'
      'destiné/sur le point d\'aimer\n'
      'amaturus sum (eram) = je vais (j\'allais) aimer',
    ),
    paragrapheExplication(
      'Étymologiquement, le mot « aventure » provient du participe '
      'futur du verbe advenire (« arriver ») : en latin vulgaire, '
      'adventura désigne littéralement « les/des choses qui vont '
      'arriver ». Des neutres pluriels en -a ont été réinterprétés en '
      'féminins singuliers de la 1re déclinaison — comme dans une '
      'arme (< arma, orum, « les armes »), une feuille (< folia, orum, '
      '« ensemble de feuilles ») ou une pomme (< poma, orum, « '
      'ensemble de fruits »).',
    ),
    titreExplication('L\'infinitif futur'),
    paragrapheExplication(
      'On utilise le participe futur pour former l\'infinitif futur. '
      'Celui-ci est le plus souvent employé dans une proposition '
      'infinitive (ACI), où il apparaît à l\'accusatif et exprime '
      'toujours la postériorité. Selon les exigences de la concordance '
      'des temps en français, on le traduit par un futur simple ou un '
      'conditionnel présent.\n\n'
      'On obtient l\'infinitif futur actif en ajoutant esse au '
      'participe futur actif : amaturum, am, um + esse.',
    ),
    paragrapheExplication(
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
    titreExplication('Le tableau complet des rapports de temps dans l\'ACI'),
    paragrapheExplication(
      'Tu peux à présent exprimer tous les rapports de temps dans la '
      'proposition infinitive.',
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
      paragrapheExplication(
        '1. participe apposé : amaturus, a, um = sur le point '
        'd\'aimer / ayant l\'intention d\'aimer / disposé, destiné à '
        'aimer.\n\n'
        '2. attribut du sujet (esse à tous les temps) : amaturus sum '
        '(eram, ero...) = je vais aimer, j\'allais aimer...\n\n'
        '3. infinitif futur (postériorité dans l\'ACI) : amaturum, am, '
        'um + esse.',
      ),
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
// Leçon : Les pronoms personnels et les adjectifs possessifs
// ------------------------------------------------------------

final Lecon leconPronomsPersonnelsPossessifs = Lecon(
  id: 'pronoms_personnels_possessifs',
  titre: 'Les pronoms personnels et les adjectifs possessifs',
  sousTitre: 'ego/tu/nos/vos, le réfléchi se, meus/tuus/suus...',
  icone: Icons.groups,
  unite: 'Vol. II – Unité 5',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('Les pronoms personnels des 1re et 2e personnes'),
    tableauColonnes(
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
    paragrapheExplication(
      'Seuls les pronoms de la 2e personne ont un vocatif. La '
      'préposition cum (« avec ») se place après le pronom personnel '
      'et se soude à lui : mecum, tecum, nobiscum, vobiscum.',
    ),
    paragrapheExplication(
      'nostrum et vestrum ont un sens partitif (« d\'entre nous/vous, '
      'parmi nous/vous »).\n\n'
      'Ex. : unus nostrum (l\'un d\'entre nous) ; Quis vestrum ? (Qui '
      'd\'entre vous ?)',
    ),
    paragrapheExplication(
      'nostri et vestri s\'emploient comme compléments au génitif d\'un '
      'verbe ou d\'un adjectif, par exemple avec memor, memoris + '
      'génitif (« qui se souvient de »).\n\n'
      'Ex. : nostri memores (les gens qui se souviennent de nous)',
    ),
    titreExplication('Le pronom personnel de la 3e personne : se'),
    paragrapheExplication(
      'Tu connais déjà des pronoms de la 3e personne : le pronom de '
      'rappel is, ea, id et les démonstratifs hic, iste, ille. Le '
      'latin connaît un autre pronom de la 3e personne : le pronom '
      'personnel réfléchi se.',
    ),
    paragrapheExplication(
      'Le pronom se est un pronom réfléchi : il renvoie au sujet de la '
      'proposition dans laquelle il se trouve. Le pronom réfléchi '
      'n\'existe donc pas au nominatif : il ne peut à la fois être '
      'sujet et renvoyer simultanément au sujet.\n\n'
      'Astuce mnémotechnique : se, sui, sibi renvoient au sujet.',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'Le singulier et le pluriel de se sont identiques, comme en '
      'français (« il se lave » et « ils se lavent »).',
    ),
    titreExplication('Les emplois des pronoms personnels'),
    paragrapheExplication(
      'Le sujet étant indiqué par la terminaison du verbe, les '
      'nominatifs ego, tu, nos, vos ne s\'emploient que pour insister '
      'sur une personne.\n\n'
      'Ex. : Ego Romanus sum, tu Graecus es.',
    ),
    paragrapheExplication(
      'On tutoie tout le monde en latin : Ave Caesar, morituri te '
      'salutant.',
    ),
    paragrapheExplication(
      'Le latin ignore l\'ordre de politesse du français ; il cite les '
      'personnes dans l\'ordre suivant : 1re, 2e, 3e personne.\n\n'
      'Ex. : Ego et pater venimus. (Mon père et moi sommes venus — '
      'littéralement « moi et le père sommes venus ».)',
    ),
    paragrapheExplication(
      'L\'action réciproque (« les uns les autres ») peut s\'exprimer '
      'par inter nos, inter vos, inter se.\n\n'
      'Ex. : Inter nos laudamus. (Nous nous louons les uns les '
      'autres.)',
    ),
    titreExplication('Les adjectifs possessifs'),
    paragrapheExplication(
      'Les adjectifs possessifs se déclinent comme les adjectifs de la '
      '1re classe.',
    ),
    tableauColonnes(
      ['', 'singulier', 'pluriel'],
      [
        ['1re pers.', 'meus, mea, meum (mon, ma, mes)', 'noster, nostra, nostrum (notre, nos)'],
        ['2e pers.', 'tuus, tua, tuum (ton, ta, tes)', 'vester, vestra, vestrum (votre, vos)'],
        ['3e pers.', 'suus, sua, suum (son, sa, ses)', 'suus, sua, suum (leur, leurs)'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
      'Le vocatif de meus est mi : Tu quoque, mi fili. (Toi aussi, mon '
      'fils.)',
    ),
    titreExplication('Les emplois des adjectifs possessifs'),
    paragrapheExplication(
      'Les adjectifs possessifs se placent en général après le nom '
      'qu\'ils déterminent (patria nostra, « notre patrie »), et ne '
      's\'expriment que s\'ils sont nécessaires pour préciser le sens.\n\n'
      'Ex. : Amo patrem. (J\'aime mon père — sous-entendu.) Mater mea '
      'vidit tuam. (Ma mère a vu la tienne.)',
    ),
    paragrapheExplication(
      'Les adjectifs possessifs expriment parfois une nuance '
      'd\'affection.\n\n'
      'Ex. : Publius noster. (Notre cher Publius.)',
    ),
    paragrapheExplication(
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
      tableauColonnes(
        ['cas', '1re sg.', '2e sg.', '3e (réfléchi)'],
        [
          ['nom.', 'ego', 'tu', '—'],
          ['acc.', 'me', 'te', 'se'],
          ['gén.', 'mei', 'tui', 'sui'],
          ['dat.', 'mihi', 'tibi', 'sibi'],
        ],
      ),
      const SizedBox(height: 12),
      paragrapheExplication(
        'Possessifs : meus/tuus/suus (sg.), noster/vester/suus (pl.), '
        'déclinés comme bonus, a, um.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : L'emploi des réfléchis direct et indirect
// ------------------------------------------------------------

final Lecon leconReflechisDirectIndirect = Lecon(
  id: 'reflechis_direct_indirect',
  titre: 'L\'emploi des réfléchis direct et indirect',
  sousTitre: 'se/suus : au sujet de la proposition, ou de la principale ?',
  icone: Icons.loop,
  unite: 'Vol. II – Unité 5',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('Le réfléchi direct'),
    paragrapheExplication(
      'Le maître est fâché parce que l\'esclave a perdu ses '
      'chaussures. → Quelles chaussures l\'esclave a-t-il perdues ? '
      'Les siennes ou celles du maître ? En français, ce n\'est pas '
      'clair. En latin, en revanche, on trouvera calceos suos, s\'il '
      's\'agit des chaussures de l\'esclave, et ejus calceos, s\'il '
      's\'agit des chaussures du maître.',
    ),
    paragrapheExplication(
      'La même réflexion s\'applique au pronom réfléchi se.\n\n'
      'Ex. : Superbi se laudant, sed eorum cives eos non laudant. (Les '
      'orgueilleux se louent, mais leurs concitoyens ne les louent '
      'pas.)',
    ),
    paragrapheExplication(
      'Tu connais donc déjà l\'emploi du réfléchi direct, qu\'il soit '
      'pronom ou adjectif possessif : dans une proposition '
      'indépendante, principale ou subordonnée, le pronom réfléchi se '
      'et l\'adjectif possessif réfléchi suus, a, um renvoient au sujet '
      'de la même proposition.',
    ),
    titreExplication('Je me rappelle'),
    paragrapheExplication(
      'Pour traduire « son, sa, ses, leur, leurs », le latin utilise '
      ':\n\n'
      '• l\'adjectif possessif suus, a, um, si le possessif renvoie au '
      'sujet de la même proposition ;\n'
      '• le pronom au génitif ejus, eorum, earum, si le possessif ne '
      'renvoie pas au sujet de la même proposition.',
    ),
    titreExplication('Cas particulier : le réfléchi indirect'),
    paragrapheExplication(
      'Quintus credit [se esse beatum]. → se = Quintus ? OUI.\n'
      'Quintus credit [eum esse beatum]. → eum = Quintus ? NON.\n'
      'Quintus credit [parentes suos esse beatos]. → parentes suos = '
      'les parents de Quintus ? OUI.\n'
      'Quintus credit [ejus parentes esse beatos]. → ejus parentes = '
      'les parents de Quintus ? NON.',
    ),
    paragrapheExplication(
      'Dans une proposition subordonnée qui exprime la parole ou la '
      'pensée de quelqu\'un, le pronom réfléchi se et l\'adjectif '
      'possessif réfléchi suus renvoient :\n\n'
      '• ou bien au sujet de la même proposition = réfléchi direct\n'
      '• ou bien au sujet de la proposition principale = réfléchi '
      'indirect',
    ),
    paragrapheExplication(
      'Parmi les subordonnées qui expriment la parole ou la pensée de '
      'quelqu\'un, tu connais pour l\'instant uniquement la proposition '
      'infinitive (ACI). Tu apprendras encore les subordonnées '
      'complétives introduites par ut (par exemple après un verbe de '
      'souhait ou de volonté), les subordonnées circonstancielles de '
      'but (ut, « pour que » ; ne, « pour que ne pas ») et les '
      'subordonnées interrogatives indirectes.',
    ),
    titreExplication('Méthode pratique pour le thème'),
    paragrapheExplication(
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
      paragrapheExplication(
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

final Lecon leconAdjectifsNumeraux = Lecon(
  id: 'adjectifs_numeraux',
  titre: 'Les adjectifs numéraux (cardinaux et ordinaux)',
  sousTitre: 'unus/duo/tres, mille et milia, les multiplicatifs',
  icone: Icons.numbers,
  unite: 'Vol. II – Unité 5',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('Je me rappelle'),
    tableauColonnes(
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
    titreExplication('Mille et mil(l)ia'),
    paragrapheExplication(
      'Comme en français, le chiffre mille est invariable en latin.\n\n'
      'Ex. : Mille milites adsunt. (Mille soldats sont là.) Cum mille '
      'militibus veniet. (Il viendra avec mille soldats.)',
    ),
    paragrapheExplication(
      'Or, quand il s\'agit de plusieurs milliers, le latin utilise le '
      'nom mil(l)ia, ium, n. pl. (« milliers ») suivi du génitif '
      'pluriel.\n\n'
      'Ex. : Duo milia militum adsunt. (Deux mille soldats, '
      'littéralement deux milliers de soldats, sont là.) Patria duobus '
      'milibus fortium militum gratiam habet. (La patrie témoigne de '
      'la reconnaissance à deux mille soldats courageux.)',
    ),
    tableauColonnes(
      ['nombre', 'construction'],
      [
        ['1000', 'mille (invariable)'],
        ['2000 = deux milliers de...', 'duo mil(l)ia + génitif'],
        ['n × 1000 = n milliers de...', 'n mil(l)ia + génitif'],
      ],
    ),
    const SizedBox(height: 12),
    titreExplication('Les adjectifs cardinaux'),
    paragrapheExplication(
      'Les adjectifs cardinaux sont invariables, sauf unus, duo et '
      'tres (employés seuls ou en composition).',
    ),
    tableauColonnes(
      ['cas', 'unus, a, um', 'duo, duae, duo', 'tres, tres, tria'],
      [
        ['nom.', 'unus / una / unum', 'duo / duae / duo', 'tres / tres / tria'],
        ['acc.', 'unum / unam / unum', 'duo(s) / duas / duo', 'tres / tres / tria'],
        ['gén.', 'unius', 'duorum / duarum / duorum', 'trium'],
        ['dat./abl.', 'uni / uno-a-o', 'duobus / duabus / duobus', 'tribus'],
      ],
    ),
    const SizedBox(height: 12),
    titreExplication('Quelques particularités'),
    paragrapheExplication(
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
    titreExplication('Les adjectifs ordinaux'),
    paragrapheExplication(
      'Les adjectifs ordinaux se déclinent comme les adjectifs de la '
      '1re classe (bonus, a, um). Le latin emploie toujours l\'adjectif '
      'ordinal pour marquer le rang, l\'heure et la date.\n\n'
      'Ex. : Philippus quintus (Philippe V, se lit « cinq »). prima '
      'hora (à la première heure = au lever du soleil, à l\'aube). '
      'ante diem sextum Kalendas Martias (le 6e jour avant les calendes '
      'de mars).',
    ),
    titreExplication('Les multiplicatifs'),
    paragrapheExplication(
      'Ce sont des adverbes qui indiquent combien de fois quelque '
      'chose s\'est produit : semel (« une fois »), bis (« deux fois '
      '»), ter (« trois fois »), quater (« quatre fois »).\n\n'
      'À partir de « cinq fois », la particule -iens (ou -ies) indique '
      'combien de fois quelque chose s\'est produit : quinquiens '
      '(« cinq fois »), sexiens, septiens, octiens, noviens, deciens, '
      'viciens (« vingt fois »), triciens, centiens, milliens.',
    ),
    paragrapheExplication(
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
      paragrapheExplication(
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

final Lecon leconDeclinaison5 = Lecon(
  id: 'decl_5',
  titre: 'La cinquième déclinaison',
  sousTitre: 'res, rei, f. — et l\'étonnante histoire du mot « rien »',
  icone: Icons.inventory_2,
  unite: 'Vol. II – Unité 6',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Les noms ayant le nominatif en -es et le génitif en -ei suivent '
      'la 5e déclinaison.',
    ),
    titreExplication('Le modèle : res, rei, f. « la chose »'),
    tableauColonnes(
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
    paragrapheExplication(
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
    titreExplication('Le genre des noms de la 5e déclinaison'),
    paragrapheExplication(
      'Les mots de la 5e déclinaison sont féminins, sauf dies, diei, '
      'm. (« jour ») et meridies, -diei, m. (« midi »).\n\n'
      'Attention, dies est féminin au singulier au sens de « date, jour '
      'fixé ».\n\n'
      'Ex. : die dicta (au jour dit / au jour fixé).',
    ),
    titreExplication('L\'histoire étonnante du mot « rien »'),
    paragrapheExplication(
      'Rien, ce n\'est pas rien, c\'est... quelque chose ! Étonnant ? '
      'Pas pour le latiniste qui reconnaît l\'origine du mot ! C\'est '
      'bien res, à l\'accusatif rem, qui a donné « rien » en français. '
      'On retrouve ce sens de « chose » dans certaines expressions un '
      'peu vieillies, comme « Y a-t-il rien de plus beau ? » ou dans '
      'des contextes négatifs, comme « rester sans rien faire », '
      'c\'est-à-dire « rester sans faire la moindre chose ».',
    ),
    paragrapheExplication(
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
      tableauColonnes(
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
      paragrapheExplication(
        'Féminins, sauf dies/meridies (masc.). rem (accusatif de res) '
        '→ « rien » en français.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Les subjonctifs présent et imparfait
// ------------------------------------------------------------

final Lecon leconSubjonctifPresentImparfait = Lecon(
  id: 'subjonctif_present_imparfait',
  titre: 'Les subjonctifs présent et imparfait',
  sousTitre: 'Voyelle caractéristique -i-/-e-/-a-, puis -re-/-se-',
  icone: Icons.tune,
  unite: 'Vol. II – Unité 6',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('Le subjonctif présent'),
    paragrapheExplication(
      'On ajoute les terminaisons personnelles actives -m, -s, -t, '
      '-mus, -tis, -nt ou passives -r, -ris, -tur, -mur, -mini, -ntur '
      'au radical de l\'infectum, suivi de la voyelle caractéristique '
      ':\n\n'
      '• -i- pour esse et ses composés (à l\'actif uniquement)\n'
      '• -e- pour les verbes de la 1re conjugaison\n'
      '• -a- pour les verbes des autres conjugaisons',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'Attention, à la 1re conjugaison, le -a- du radical « disparaît '
      '» par contraction : amem vient de *ama-e-m.',
    ),
    tableauColonnes(
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
    titreExplication('Le subjonctif imparfait'),
    paragrapheExplication(
      'On ajoute les terminaisons personnelles actives ou passives au '
      'radical de l\'infectum, suivi du suffixe -re- ou -se-.\n\n'
      'Pour simplifier, tu peux retenir l\'astuce suivante : on ajoute '
      'les terminaisons personnelles actives/passives à l\'infinitif '
      'présent !',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'Qui l\'eût cru ? Le subjonctif imparfait ne s\'utilise plus '
      'beaucoup en français, sauf à la 3e personne du singulier. On '
      'utilise plus fréquemment le subjonctif présent dans les autres '
      'cas.',
    ),
    paragrapheExplication(
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
      paragrapheExplication(
        'Subjonctif présent : radical infectum + voyelle (-i- esse, '
        '-e- 1re conj., -a- autres) + terminaisons.\n\n'
        'Subjonctif imparfait : infinitif présent + terminaisons '
        '(actives ou passives).',
      ),
      tableauColonnes(
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

final Lecon leconCompletivesSubjonctif = Lecon(
  id: 'completives_subjonctif',
  titre: 'Les complétives au subjonctif',
  sousTitre: 'Volonté (ut/ne), crainte (ne/ne non), événement (ut/ut non)',
  icone: Icons.gavel,
  unite: 'Vol. II – Unité 6',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Caesar statuit ut exercitus in Gallia maneat / ne exercitus '
      'Galliam relinquat. (César décide que son armée reste en Gaule / '
      'que son armée ne quitte pas la Gaule.)\n\n'
      'Hoc anno agricolae timent ne pluat / ne non pluat. (Cette '
      'année-ci, les paysans craignent qu\'il ne pleuve / qu\'il ne '
      'pleuve pas.)\n\n'
      'Saepe accidit ut cibus incolis desit. (Il arrive souvent que la '
      'nourriture manque aux habitants.)',
    ),
    titreExplication('Qu\'est-ce qu\'une subordonnée complétive ?'),
    paragrapheExplication(
      'On appelle subordonnées complétives des propositions qui '
      'complètent un verbe et ont ainsi la fonction de complément '
      'd\'objet. Les verbes de pensée, de parole et de perception sont '
      'suivis en latin d\'une proposition complétive qui est infinitive '
      '(ACI). Les complétives étudiées ici se mettent au subjonctif, '
      'après certains types de verbes.',
    ),
    titreExplication('1. Les complétives introduites par ut + subj. / ne + subj.'),
    paragrapheExplication(
      'Les verbes de volonté, souhait, prière, effort sont suivis de '
      'la conjonction ut + subjonctif. La négation est ne + '
      'subjonctif.',
    ),
    tableauColonnes(
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
    paragrapheExplication(
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
    paragrapheExplication(
      'Pour alléger le style, le français préfère remplacer le '
      'subjonctif par l\'infinitif, si possible.\n\n'
      'Ex. : Suadeo tibi ut bonos audias, ne malos audias. (Je te '
      'conseille d\'écouter les gens de bien, de ne pas écouter les '
      'méchants.)',
    ),
    titreExplication('2. Les complétives introduites par ne + subj. / ne non + subj.'),
    paragrapheExplication(
      'Les verbes de crainte sont suivis de la conjonction ne + '
      'subjonctif. La négation est ne non + subjonctif.\n\n'
      'timere ne, metuere ne = craindre, redouter, avoir peur que '
      '(ne) / de.\n\n'
      'Ex. : Timeo ne inimicus veniat. (Je crains que mon ennemi (ne) '
      'vienne.) Timeo ne non amicus veniat. (Je crains que mon ami ne '
      'vienne pas.)',
    ),
    paragrapheExplication(
      'Il existe en français un « ne » dit explétif — il « remplit » '
      'la proposition (du latin explere, « remplir »). Son emploi ne '
      'modifie pas la phrase positive en une phrase négative. Hérité '
      'du latin, il s\'utilise, surtout à l\'écrit, pour « l\'élégance '
      '» de la proposition, mais ne change pas le sens de l\'énoncé. Ce '
      '« ne » explétif tend à disparaître en français : « Je crains '
      'que mon ennemi ne vienne » et « Je crains que mon ennemi '
      'vienne » ont le même sens.',
    ),
    titreExplication('3. Les complétives introduites par ut + subj. / ut non + subj.'),
    paragrapheExplication(
      'Les verbes exprimant l\'événement sont suivis de la conjonction '
      'ut + subjonctif. La négation est ut non + subjonctif.\n\n'
      'accidit ut = il arrive que (événement imprévu, souvent négatif)\n'
      'contingit ut = il arrive que (événement le plus souvent heureux)\n'
      'evenit ut = il arrive que (événement quelconque)',
    ),
    paragrapheExplication(
      'Ex. : Beatum cui contingit ut sapientiam adsequi possit. '
      '(Heureux celui à qui il arrive qu\'il puisse atteindre la '
      'sagesse.) Accidit ut aegrotes. (Il arrive que tu sois malade.) '
      'Accidit ut non valeas. (Il arrive que tu ne te portes pas '
      'bien.)',
    ),
    titreExplication('La concordance des temps'),
    paragrapheExplication(
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
    paragrapheExplication(
      'D\'autres rapports de temps peuvent être exprimés : pour '
      'l\'antériorité, le latin emploie le subjonctif parfait si le '
      'verbe principal est au présent, et le subjonctif plus-que-parfait '
      'si le verbe principal est au passé. Le latin connaît même une '
      'tournure permettant d\'exprimer la postériorité à l\'aide d\'un '
      '« subjonctif futur », mais on ne le trouve que dans les '
      'interrogations indirectes.',
    ),
    titreExplication('L\'emploi du réfléchi et du non réfléchi'),
    paragrapheExplication(
      'Dans les propositions subordonnées complétives, le pronom '
      'réfléchi se et l\'adjectif possessif réfléchi suus renvoient ou '
      'bien au sujet de la même proposition (réfléchi direct), ou bien '
      'au sujet de la proposition principale (réfléchi indirect) — la '
      'même règle que pour l\'ACI.',
    ),
    titreExplication('Un quatrième type : quominus / quin'),
    paragrapheExplication(
      'Parmi les complétives au subjonctif, il existe un quatrième '
      'type : les propositions introduites par ne, quin ou quominus. Ce '
      'type de subordonnée complète des verbes exprimant l\'empêchement '
      ': impedire ne (« empêcher que/de »), obstare ne (« faire '
      'obstacle à ce que »), recusare ne (« refuser que/de »).',
    ),
    paragrapheExplication(
      'La conjonction utilisée diffère selon que la principale est '
      'affirmative, négative ou interrogative :\n\n'
      '• principale affirmative : conjonction ne. Ex. : Impedit ne '
      'veniam. (Il m\'empêche de venir.)\n\n'
      '• principale négative ou interrogative : conjonction quin ou '
      'quominus. Ex. : Nihil obstat quin sis beatus. (Rien n\'empêche '
      'que tu sois heureux.)',
    ),
    titreExplication('Quelle fonction pour la subordonnée complétive ?'),
    paragrapheExplication(
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
      tableauColonnes(
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

final Lecon leconUnusSolusTotusNullus = Lecon(
  id: 'unus_solus_totus_nullus',
  titre: 'Unus, solus, totus, nullus',
  sousTitre: 'Génitif en -ius, datif en -i : une déclinaison à part',
  icone: Icons.adjust,
  unite: 'Vol. II – Unité 7',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Unum hominem vidi. (J\'ai vu un seul homme.) Solum hominem vidi. '
      '(J\'ai vu un homme seul.)\n\n'
      'Totum terrarum orbem novit. (Il connaît toute la terre.) Omnes '
      'Italiae terras novit. (Il connaît toutes les terres d\'Italie.) '
      'Omnis civis sententiam dicat ! (Que tout citoyen dise son avis !)',
    ),
    titreExplication('Il ne faut pas confondre'),
    paragrapheExplication(
      'solus « seul » et unus « un seul »\n\n'
      'totus = cunctus « tout, tout entier » et omnis « tout, chaque »\n\n'
      'omnes « tous » = cuncti',
    ),
    titreExplication('Nullus : « aucun... ne », « ne... aucun »'),
    paragrapheExplication(
      'Est nullus cibus quem recuso. (Il n\'y a aucune nourriture que je '
      'refuse.) Nullam legem novit. (Il ne connaît aucune loi.) Jus non '
      'novit neque ullam legem. (Il ne connaît pas le droit ni aucune '
      'loi.)',
    ),
    paragrapheExplication(
      '« aucun... ne » ou « ne... aucun » se traduit par nullus, a, um.\n\n'
      '« et aucun... ne » ou « et ne... aucun » se traduit par neque '
      'ullus, a, um.\n\n'
      'Dans une proposition déjà négative, on remplace nullus, a, um '
      'par ullus, a, um.',
    ),
    titreExplication('Nullus, aussi au pluriel'),
    paragrapheExplication(
      'Contrairement au français, le latin utilise nullus, a, um aussi '
      'au pluriel.\n\n'
      'Ex. : Si nulla est divinatio, nulli sunt dei. (D\'après Cicéron, '
      'De divinatione, II, 17 : « S\'il n\'y a aucune divination, il '
      'n\'y a aucun dieu. »)',
    ),
    titreExplication('Une déclinaison à part'),
    paragrapheExplication(
      'Nullius viri audaciae cedamus ! (Ne cédons à l\'audace d\'aucun '
      'homme !) Unius viri vis satis non est. (La force d\'un seul '
      'homme ne suffit pas.) Tibi soli fidem habeo. (J\'ai confiance en '
      'toi seul.) Toti civitati gratias agere debemus. (Nous devons '
      'remercier la cité tout entière.)',
    ),
    tableauColonnes(
      ['cas', 'unus', 'solus', 'totus', 'nullus'],
      [
        ['nom.', 'unus', 'solus', 'totus', 'nullus'],
        ['gén.', 'unius', 'solius', 'totius', 'nullius'],
        ['dat.', 'uni', 'soli', 'toti', 'nulli'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
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
      tableauColonnes(
        ['cas', 'unus', 'solus', 'totus', 'nullus'],
        [
          ['nom.', 'unus', 'solus', 'totus', 'nullus'],
          ['gén.', 'unius', 'solius', 'totius', 'nullius'],
          ['dat.', 'uni', 'soli', 'toti', 'nulli'],
        ],
      ),
      const SizedBox(height: 12),
      paragrapheExplication(
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

final Lecon leconNemoNihil = Lecon(
  id: 'nemo_nihil',
  titre: 'Les pronoms indéfinis nemo et nihil',
  sousTitre: '« personne » et « rien » : deux déclinaisons empruntées à nullus',
  icone: Icons.person_off,
  unite: 'Vol. II – Unité 7',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Nemo te vidit. (Personne ne t\'a vu.) Iste neminem amat. (Cet '
      'individu n\'aime personne.) Nullius nomen novi. (Je ne connais '
      'le nom de personne.) Nemini credo. (Je ne fais confiance à '
      'personne.) A nullo amatur. (Il n\'est aimé de personne.)',
    ),
    titreExplication('La déclinaison de nemo'),
    tableauColonnes(
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
    paragrapheExplication(
      'Au génitif et à l\'ablatif, nemo emprunte ses formes à l\'adjectif '
      'nullus « aucun ».',
    ),
    titreExplication('Nihil « rien »'),
    paragrapheExplication(
      'Nihil novi sub sole ! (Rien de nouveau sous le soleil !) Nihil '
      'vidi. Nihil audivi. (Je n\'ai rien vu. Je n\'ai rien entendu.) '
      'homo ad nullam rem utilis (un homme utile à rien — d\'après '
      'Cicéron, De Officiis, 3, 29). Nullius rei rationem habuit. (Il '
      'ne tint compte de rien.) Iste nulli rei credit. (Cet individu ne '
      'croit en rien.) De nulla re verba fecit. (Il ne parla de rien.)',
    ),
    paragrapheExplication(
      'Aux cas obliques (génitif, datif, ablatif), et même à '
      'l\'accusatif précédé d\'une préposition, le pronom nihil est '
      'remplacé par nulla res « aucune chose ».',
    ),
    titreExplication('Je récapitule'),
    tableauColonnes(
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
    titreExplication('D\'où viennent nemo et nihil ?'),
    paragrapheExplication(
      'Étymologiquement, le pronom nemo s\'explique par ne + hemo '
      '(= homo) et le pronom nihil par ne + hilum. L\'origine du mot '
      'hilum n\'est pas sûre ; certains pensent qu\'il désignait le '
      'petit point noir au bout d\'une fève. Il désigne en tout cas '
      'quelque chose de tout petit.',
    ),
    paragrapheExplication(
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
      tableauColonnes(
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
      paragrapheExplication(
        'nemo et nihil empruntent leurs cas obliques à nullus, a, um '
        '(et à nulla res pour nihil).',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : La négation dans la coordination et la subordination
// ------------------------------------------------------------

final Lecon leconNegationCoordinationSubordination = Lecon(
  id: 'negation_coordination_subordination',
  titre: 'La négation dans la coordination et la subordination',
  sousTitre: 'nec/neque, quisquam, quidquam : éviter la double négation',
  icone: Icons.not_interested,
  unite: 'Vol. II – Unité 7',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication('*et non → nec / neque'),
    titreExplication('Coordonner une négation : nec / neque'),
    paragrapheExplication(
      'Puer tacuit neque umquam timuit. (L\'enfant s\'est tu et n\'a '
      'jamais eu peur.) Veni neque ullum hominem vidi. (Je suis venu et '
      'je n\'ai vu aucun homme.) Audiebat nec quidquam dicebat. (Il '
      'écoutait et ne disait rien.) Veni nec quemquam vidi. (Je suis '
      'venu et je n\'ai vu personne.)',
    ),
    paragrapheExplication(
      '*et numquam → neque umquam « et... ne... jamais »\n'
      '*et nullus, a, um → neque ullus, a, um « et... ne... aucun »\n'
      '*et nihil → nec quidquam / quicquam « et... rien... ne »\n'
      '*et nemo → nec quisquam « et... personne ne... »',
    ),
    paragrapheExplication(
      'Le latin n\'utilise que rarement la conjonction de coordination '
      'et suivie d\'un mot négatif, mais il utilise plutôt nec/neque '
      'pour dire « et... ne... pas ». De même, il utilise neque umquam '
      'pour dire « et... ne... jamais », neque ullus, a, um pour dire '
      '« et... ne... aucun », et remplace les pronoms indéfinis nemo et '
      'nihil par les pronoms quisquam et quidquam / quicquam pour dire '
      '« et... personne ne... », « et... rien ne... ».',
    ),
    titreExplication('quisquam et quidquam'),
    paragrapheExplication(
      'Quisquam et quidquam se déclinent comme le pronom interrogatif, '
      'auquel s\'ajoute l\'élément invariable -quam.',
    ),
    tableauColonnes(
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
    paragrapheExplication(
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
    titreExplication('Même substitution après un mot à idée négative'),
    paragrapheExplication(
      'On trouve la même substitution d\'un mot négatif si un autre '
      'mot que nec comporte une idée négative. Il en est ainsi, par '
      'exemple, de la préposition sine + ablatif « sans ».\n\n'
      'Ex. : sine ulla re (sans rien). Omnia fecerunt, sine cujusquam '
      'auxilio. (Ils firent tout sans l\'aide de personne.)',
    ),
    titreExplication('Après une conjonction de subordination'),
    paragrapheExplication(
      'On trouve la même substitution d\'un mot négatif derrière une '
      'conjonction de subordination. Afin de ne pas créer de double '
      'négation après un verbe de volonté, de souhait, de prière, '
      'd\'effort, le latin utilise ne umquam pour dire « que jamais... '
      'ne », ne ullus pour dire « qu\'aucun... ne », ne quisquam pour '
      '« que personne... ne », ne quidquam / quicquam pour « que '
      'rien... ne ». Mais il garde ut numquam, ut nullus, ut nemo, ut '
      'nihil après un verbe d\'événement.',
    ),
    tableauColonnes(
      ['après un verbe d\'événement', 'après volonté/souhait/prière/effort'],
      [
        ['accidit ut numquam', 'opto ne umquam'],
        ['accidit ut nullus', 'opto ne ullus'],
        ['accidit ut nemo', 'opto ne quisquam'],
        ['accidit ut nihil', 'opto ne quidquam / quicquam'],
      ],
    ),
    const SizedBox(height: 12),
    titreExplication('La négation « en série »'),
    paragrapheExplication(
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
      tableauColonnes(
        ['positif', 'négatif isolé', 'après nec/neque, sine, ut négatif'],
        [
          ['umquam', 'numquam', 'neque/ne umquam'],
          ['ullus', 'nullus', 'neque/ne ullus'],
          ['quisquam', 'nemo', 'nec/ne quisquam'],
          ['quidquam', 'nihil', 'nec/ne quidquam'],
        ],
      ),
      const SizedBox(height: 12),
      paragrapheExplication(
        'Le latin évite la double négation : après nec/neque, sine, ou '
        'une conjonction déjà négative, on emploie la forme positive '
        '(ullus, quisquam, quidquam, umquam), sauf ut numquam/nullus/'
        'nemo/nihil après un verbe d\'événement.',
      ),
    ],
  ),
);

