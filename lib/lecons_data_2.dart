import 'package:flutter/material.dart';

import 'grammaire_tableaux_data.dart';
import 'lecons_core.dart';
import 'screens/declinaisons_screen.dart' show tableauDeclinaison;

// ------------------------------------------------------------
// Leçon : Mihi adeste ! Le passif en français
// ------------------------------------------------------------

final Lecon leconPassifFrancais = Lecon(
  id: 'passif_francais',
  titre: 'Mihi adeste ! Le passif en français',
  sousTitre: 'Le mécanisme de la transformation passive, méthode en 3 étapes',
  icone: Icons.auto_fix_high,
  unite: 'Vol. I – Unité 6',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('Le mécanisme de la transformation passive'),
    paragrapheExplication(
      'À la voix active, le sujet fait l\'action exprimée par le verbe. '
      'Mais à la voix passive, le sujet ne fait pas l\'action, il la '
      'subit.\n\n'
      'Ex. : Les jeunes lisent beaucoup de livres. (le sujet fait '
      'l\'action)\n'
      '→ Beaucoup de livres sont lus par les jeunes. (le sujet subit '
      'l\'action, il ne la fait pas lui-même)',
    ),
    paragrapheExplication(
      '• Le COD de la phrase active devient le sujet de la phrase '
      'passive.\n'
      '• Le sujet de la phrase active devient un complément dans la '
      'phrase passive, introduit par « par ».\n'
      '• Le verbe prend la forme passive « être + participe passé ».',
    ),
    titreExplication(
      'Une méthode pratique en 3 étapes pour mettre un verbe au passif',
    ),
    paragrapheExplication(
      '1. Mettre l\'auxiliaire « être » au mode, au temps et à la '
      'personne voulus.\n'
      '2. Mettre le verbe au participe passé.\n'
      '3. Accorder le participe passé avec le sujet.',
    ),
    paragrapheExplication(
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
      paragrapheExplication(
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

final Lecon leconDeclinaison3 = Lecon(
  id: 'decl_3',
  titre: 'La troisième déclinaison',
  sousTitre: 'civis, mare, rex, corpus : radicaux variables',
  icone: Icons.pets,
  unite: 'Vol. I – Unité 7',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'La 3e déclinaison constitue l\'ensemble nominal le plus riche et '
      'le plus varié de la langue latine. Contrairement aux 1re et 2e '
      'déclinaisons, les noms ont des radicaux variables, et les formes '
      'de nominatif sont très variées. Il faut donc bien retenir le '
      'vocabulaire (nominatif ET génitif) pour ne pas se tromper.',
    ),
    paragrapheExplication(
      'Les noms de la troisième déclinaison ont le génitif singulier en '
      '-is. C\'est en enlevant cette terminaison qu\'on obtient le '
      'radical auquel s\'ajoutent les autres terminaisons.',
    ),
    titreExplication(
      'Masculins et féminins : parisyllabiques et imparisyllabiques',
    ),
    paragrapheExplication(
      'Si le nombre de syllabes est identique au nominatif et au '
      'génitif, le nom fait partie de la catégorie des parisyllabiques '
      '(civis, 2 syllabes ; civis, 2 syllabes). Sinon, il fait partie '
      'des imparisyllabiques (rex, 1 syllabe ; regis, 2 syllabes).',
    ),
    tableauDeclinaison(declinaisons[5]),
    const SizedBox(height: 12),
    tableauDeclinaison(declinaisons[3]),
    const SizedBox(height: 12),
    titreExplication('Les noms neutres : repérer les « AREAL »'),
    paragrapheExplication(
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
    titreExplication('Une méthode pratique'),
    paragrapheExplication(
      'Pour les noms masculins ou féminins, il faut compter les '
      'syllabes du nominatif et du génitif : identiques → '
      'parisyllabique (modèle civis) ; différentes → imparisyllabique '
      '(modèle rex).\n\n'
      'Pour les noms neutres, il faut repérer les « AREAL » : '
      'nominatif en -ar, -e ou -al → modèle mare ; sinon → modèle '
      'corpus.',
    ),
    titreExplication('Les cas particuliers'),
    paragrapheExplication(
      'Les « faux parisyllabiques » : un petit nombre de noms '
      'masculins et féminins parisyllabiques ont malgré tout un '
      'génitif pluriel en -um, comme le type imparisyllabique. C\'est '
      'le cas d\'une liste de noms constituée des habitants d\'une '
      'maisonnée : mater, matris (mère) → matrum ; pater, patris '
      '(père) → patrum ; frater, fratris (frère) → fratrum ; juvenis, '
      'is (jeune homme) → juvenum ; senex, is (vieillard) → senum ; '
      'canis, is (chien) → canum.',
    ),
    paragrapheExplication(
      'Les « faux imparisyllabiques » : certains noms monosyllabiques, '
      'dont le radical se termine par deux consonnes, ont perdu au '
      'nominatif la voyelle -i caractéristique des radicaux vocaliques '
      '(urbs < *urbis). Ce sont donc d\'anciens parisyllabiques, dont '
      'le génitif pluriel est en -ium : urbs, urbis (ville) → urbium ; '
      'fons, fontis (source) → fontium ; gens, gentis (famille, '
      'peuple) → gentium ; mens, mentis (esprit) → mentium ; mons, '
      'montis (montagne) → montium ; pars, partis (partie) → partium.',
    ),
    paragrapheExplication(
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
      paragrapheExplication(
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

final Lecon leconIndicatifParfait = Lecon(
  id: 'indicatif_parfait',
  titre: 'L\'indicatif parfait',
  sousTitre: 'Formation, 5 types de radicaux, traduction',
  icone: Icons.emoji_events,
  unite: 'Vol. I – Unité 7',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Le terme perfectum vient du verbe perficio, is, ere, -feci, '
      '-fectum, et signifie « faire complètement, achever ». Le '
      'parfait est donc le temps de l\'action achevée.',
    ),
    titreExplication('La morphologie du parfait'),
    paragrapheExplication(
      'La 4e forme des temps primitifs correspond à la 1re personne du '
      'singulier du verbe à l\'indicatif parfait. On en déduit le '
      'radical du perfectum (ou radical du passé) en enlevant la '
      'terminaison -i.\n\n'
      'Ex. : amo, as, are, amavi, amatum → radical du perfectum : amav-',
    ),
    paragrapheExplication(
      'Formation du parfait : radical du perfectum + terminaisons -i, '
      '-isti, -it, -imus, -istis, -erunt.',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'La formation du parfait des verbes irréguliers, comme esse et '
      'ses composés, est identique à celle des verbes réguliers : sum, '
      'es, esse, fui → fui, fuisti, fuit... ; possum, potui → potui, '
      'potuisti... ; prosum, profui → profui...',
    ),
    titreExplication('Les 5 types de formation du parfait'),
    paragrapheExplication(
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
    paragrapheExplication(
      'On distingue ainsi 5 types de formation du parfait latin : les '
      'radicaux en -v, en -u, en -s, à redoublement, et à voyelle '
      'longue.',
    ),
    titreExplication('Quelques particularités de la conjugaison au parfait'),
    paragrapheExplication(
      '• À la 3e personne du pluriel, on trouve souvent la terminaison '
      '-ere au lieu de -erunt (fuere pour fuerunt).\n\n'
      '• Les parfaits en -avi, -evi, -ivi et -ovi peuvent être syncopés '
      '(le -v- et même -vi- ou -ve- disparaissent) : scivit ou sciit ; '
      'audivit ou audiit.\n\n'
      '• Le latin possède des verbes qui n\'existent qu\'au temps du '
      'parfait et que le français traduit par un présent, comme '
      'memini, « je me souviens ».',
    ),
    titreExplication('La traduction du parfait'),
    paragrapheExplication(
      'Un parfait latin peut être traduit par trois temps français : le '
      'passé simple, le passé antérieur ou le passé composé. L\'emploi '
      'du temps en français dépend du contexte.',
    ),
    tableauColonnes(
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
      paragrapheExplication(
        'Parfait = radical du perfectum (4e temps primitif − -i) + -i, '
        '-isti, -it, -imus, -istis, -erunt.',
      ),
      tableauColonnes(
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

final Lecon leconInfinitifParfaitACI = Lecon(
  id: 'infinitif_parfait_aci',
  titre: 'L\'infinitif parfait et l\'ACI',
  sousTitre: 'Formation, antériorité dans la proposition infinitive',
  icone: Icons.nightlight_round,
  unite: 'Vol. I – Unité 7',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Dans une phrase comme « Nicéros se retourna vers son compagnon, '
      'et vit qu\'il s\'était déshabillé et avait posé ses vêtements '
      'sur le bord de la route », le verbe vidit (« il vit ») introduit '
      'une proposition infinitive (ACI), et les verbes latins exuisse '
      'et posuisse sont à l\'infinitif parfait.',
    ),
    titreExplication('La formation de l\'infinitif parfait'),
    paragrapheExplication(
      'L\'infinitif parfait se forme ainsi : radical du perfectum + '
      '-isse.',
    ),
    tableauColonnes(
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
    paragrapheExplication(
      'Tu trouveras surtout l\'infinitif parfait dans la proposition '
      'infinitive (ACI).\n\n'
      'Ex. : Scio [filium tuum venisse]. (Je sais que ton fils est '
      'venu.)\n'
      'Sciebam [filium tuum venisse]. (Je savais que ton fils était '
      'venu.)',
    ),
    titreExplication('L\'antériorité dans l\'ACI'),
    paragrapheExplication(
      'Quand l\'action de la subordonnée se déroule avant l\'action de '
      'la principale, ce rapport de temps est appelé l\'antériorité '
      '(en latin, ante signifie « avant »). Pour exprimer l\'antériorité '
      'dans l\'ACI, le latin utilise l\'infinitif parfait.',
    ),
    paragrapheExplication(
      'En français, il faut appliquer la concordance des temps. '
      'N\'oublie pas qu\'en français, le subjonctif s\'utilise après des '
      'verbes de volonté (ordonner que) et de souhait (désirer que).',
    ),
    tableauColonnes(
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
      paragrapheExplication(
        'Infinitif parfait : radical du perfectum + -isse. Dans l\'ACI, '
        'il exprime l\'antériorité (l\'action de la subordonnée '
        'précède celle de la principale).',
      ),
      tableauColonnes(
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

final Lecon leconAdjectifs2eClasse = Lecon(
  id: 'adj_2e_classe',
  titre: 'Les adjectifs de la 2e classe',
  sousTitre: 'fortis, e — felix, felicis — acer, acris, acre',
  icone: Icons.diamond,
  unite: 'Vol. I – Unité 8',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('Je me rappelle'),
    paragrapheExplication(
      'Les adjectifs de la 1re classe sont regroupés en 3 types : bonus, '
      'bona, bonum ; miser, misera, miserum ; pulcher, pulchra, '
      'pulchrum. L\'adjectif s\'accorde en genre, nombre et cas avec le '
      'nom auquel il se rapporte. S\'il ne détermine pas un nom, il est '
      'substantivé, utilisé comme un nom.',
    ),
    titreExplication('Les 3 types d\'adjectifs de la 2e classe'),
    paragrapheExplication(
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
    paragrapheExplication(
      'La plupart des adjectifs de la 2e classe suivent la 3e '
      'déclinaison :\n\n'
      '• des noms parisyllabiques au masculin et au féminin (modèle '
      'civis), mais ils ont un ablatif singulier en -i (et non -e comme '
      'le nom civis).\n'
      '• des noms AREAL au neutre.\n\n'
      'On obtient leur radical en enlevant la terminaison -is au '
      'génitif singulier, ou -is au féminin singulier.',
    ),
    titreExplication('Le type fortis, e'),
    tableauColonnes(
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
    titreExplication('Les adjectifs en -ax, -ex, -ix, -ox (type felix)'),
    paragrapheExplication(
      'Ces adjectifs n\'ont qu\'une forme au nominatif pour les 3 '
      'genres, mais se déclinent comme le type fortis (radical déduit '
      'du génitif). Ex. : ferox, ferocis (farouche, radical feroc-).',
    ),
    titreExplication('Les adjectifs en -ns, -ntis (type ingens)'),
    paragrapheExplication(
      'Ex. : ingens, ingentis (énorme, immense). Ces adjectifs ont '
      'l\'ablatif singulier en -i ou -e.',
    ),
    titreExplication(
      'Exceptions : les adjectifs imparisyllabiques (type consul/scelus)',
    ),
    paragrapheExplication(
      'Quelques adjectifs (dives, pauper, vetus, juvenis, princeps) ne '
      'suivent pas le modèle civis/mare, mais se déclinent comme les '
      'noms imparisyllabiques consul et scelus : ablatif singulier en '
      '-e (et non -i) et génitif pluriel en -um (et non -ium).',
    ),
    tableauColonnes(
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
      paragrapheExplication(
        '3 types au nominatif : 1 forme (felix, felicis), 2 formes '
        '(fortis, e), 3 formes (acer, acris, acre).\n\n'
        'La plupart suivent le modèle civis/mare (mais ablatif '
        'singulier en -i pour les adjectifs m./f.).\n\n'
        'Exceptions (comme consul/scelus, abl. sg. -e, gén. pl. -um) : '
        'dives, pauper, vetus, juvenis, princeps.',
      ),
      tableauColonnes(
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

final Lecon leconParticipePresentActif = Lecon(
  id: 'participe_present_actif',
  titre: 'Le participe présent actif',
  sousTitre: 'Formation « mixte », traduction, apposition au sujet',
  icone: Icons.bolt,
  unite: 'Vol. I – Unité 8',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Le participe présent latin s\'accorde en genre, nombre et cas '
      'avec le nom auquel il se rapporte. Il exprime toujours une '
      'action simultanée au(x) verbe(s) conjugué(s) de la phrase, et '
      'peut exprimer d\'autres circonstances, comme la cause.',
    ),
    titreExplication('La formation du participe présent actif'),
    paragrapheExplication(
      'Radical du présent + -ns, -ntis, avec la voyelle d\'ajout -e- '
      'aux 3e, 4e et 5e conjugaisons. Les terminaisons sont celles des '
      'adjectifs de la 2e classe, sauf à l\'ablatif singulier : -e.',
    ),
    paragrapheExplication(
      'Le participe présent actif se caractérise donc par une '
      'formation « mixte » :\n\n'
      '• ablatif singulier (m./f./n.) en -e\n'
      '• nominatif/vocatif/accusatif pluriel (neutre) en -ia\n'
      '• génitif pluriel (m./f./n.) en -ium',
    ),
    titreExplication('pugnans, -ntis « combattant »'),
    tableauColonnes(
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
    titreExplication('La traduction du participe présent actif'),
    paragrapheExplication(
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
    titreExplication('Le participe présent, apposition au sujet'),
    paragrapheExplication(
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
      paragrapheExplication(
        'Participe présent actif = radical du présent (+ voyelle '
        'd\'ajout -e- aux 3e/4e/5e conj.) + -ns, -ntis.\n\n'
        'Formation mixte : abl. sg. en -e ; nom./voc./acc. pl. (n.) en '
        '-ia ; gén. pl. en -ium.',
      ),
      tableauColonnes(
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

final Lecon leconComparatifSuperlatif = Lecon(
  id: 'comparatif_superlatif',
  titre: 'Le comparatif et le superlatif',
  sousTitre: 'Formation régulière et irrégulière, sens et traductions',
  icone: Icons.military_tech,
  unite: 'Vol. I – Unité 8',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('La morphologie du comparatif'),
    paragrapheExplication(
      'Radical de l\'adjectif + -ior, -ior, -ius. Le comparatif se '
      'décline comme l\'adjectif dives de la 2e classe (c\'est-à-dire '
      'comme le type imparisyllabique, avec exception) : ablatif '
      'singulier en -e, nominatif/vocatif/accusatif neutre pluriel en '
      '-a, génitif pluriel en -um.',
    ),
    tableauColonnes(
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
    titreExplication('La morphologie du superlatif'),
    paragrapheExplication(
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
    titreExplication('Les comparatifs et superlatifs irréguliers'),
    paragrapheExplication(
      'Quelques adjectifs forment des comparatifs et superlatifs '
      'irréguliers, à apprendre par cœur. Heureusement, ces formes '
      'latines sont faciles à retenir, car elles rappellent des mots '
      'français que tu connais bien.',
    ),
    tableauColonnes(
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
    titreExplication('Le sens et les traductions du comparatif'),
    paragrapheExplication(
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
    paragrapheExplication(
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
    titreExplication('Le sens et les traductions du superlatif'),
    paragrapheExplication(
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
      paragrapheExplication(
        'Comparatif : radical + -ior, -ior, -ius (décliné comme dives).\n'
        'Superlatif : radical + -issimus, -issima, -issimum (décliné '
        'comme bonus) ; -errimus pour les adjectifs en -er ; -illimus '
        'pour facilis, difficilis, similis, dissimilis, humilis.',
      ),
      tableauColonnes(
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
      paragrapheExplication(
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

final Lecon leconSupinPPP = Lecon(
  id: 'supin_ppp',
  titre: 'Le supin et le participe parfait passif',
  sousTitre: 'La 5e forme des temps primitifs, le PPP (radical + -us, -a, -um)',
  icone: Icons.workspace_premium,
  unite: 'Vol. I – Unité 9',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('Le supin'),
    paragrapheExplication(
      'La 5e forme des temps primitifs est appelée le supin. Le supin '
      'est invariable.\n\n'
      'Ex. : amo, as, are, amavi, amatum → amatum est le supin.',
    ),
    paragrapheExplication(
      'Après un verbe de mouvement (comme venire), le supin exprime le '
      'but.\n\n'
      'Ex. : Milites veniunt pugnatum. (Les soldats viennent pour '
      'combattre.)\n'
      'Romam petimus amicos visum. (Nous gagnons Rome pour voir nos '
      'amis.)',
    ),
    titreExplication('Quelques remarques'),
    paragrapheExplication(
      'Certains verbes n\'ont pas de supin (comme esse et ses '
      'composés). Il faut donc bien mémoriser les temps primitifs !',
    ),
    paragrapheExplication(
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
    titreExplication('Le participe parfait passif (PPP)'),
    paragrapheExplication(
      'Le participe parfait passif correspond au participe passé '
      'français, mais il n\'a pas tout à fait les mêmes emplois. On '
      'peut le traduire par la forme « simple » (aimé, averti, envoyé) '
      'ou la forme « développée » (ayant été aimé, ayant été averti).',
    ),
    paragrapheExplication(
      'Le PPP s\'obtient à partir du radical du supin. On obtient le '
      'radical du supin en lui enlevant la terminaison -um. On obtient '
      'le participe parfait passif en ajoutant -us, -a, -um au radical '
      'du supin. Le PPP se décline comme bonus, a, um.\n\n'
      'Ex. : amatum → amat- → amatus, a, um',
    ),
    tableauColonnes(
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
    titreExplication('Emploi du PPP : le participe apposé'),
    paragrapheExplication(
      'Le participe parfait apposé se traduit par la forme « simple ». '
      'Il fonctionne comme un adjectif et s\'accorde donc en genre, '
      'nombre et cas avec le nom auquel il se rapporte.\n\n'
      'Ex. : consul auditus (le consul averti).',
    ),
    paragrapheExplication(
      'Le PPP est un participe parfait PASSIF : de même que le verbe '
      'conjugué au passif, il peut avoir un complément du passif. '
      'N\'oublie pas de distinguer le complément d\'agent (a[b] + '
      'ablatif) et le complément de moyen (ablatif sans préposition).',
    ),
    titreExplication('À quoi faut-il faire attention ?'),
    paragrapheExplication(
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
      paragrapheExplication(
        'Supin = 5e forme des temps primitifs, invariable, exprime le '
        'but après un verbe de mouvement.\n\n'
        'PPP = radical du supin (− -um) + -us, -a, -um. Se décline '
        'comme bonus.',
      ),
      tableauColonnes(
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

final Lecon leconAblatifAbsolu = Lecon(
  id: 'ablatif_absolu',
  titre: 'L\'ablatif absolu (AA)',
  sousTitre: 'Sujet et participe à l\'ablatif, simultanéité et antériorité',
  icone: Icons.bubble_chart,
  unite: 'Vol. I – Unité 9',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Caesare bellum in Gallia gerente, multi Treveri interficiebantur. '
      '(César menant la guerre en Gaule, de nombreux Trévires étaient '
      'tués.)\n'
      'Indutiomaro victo, Treveri a Germanis auxilium petiverunt. '
      '(Indutiomaros ayant été vaincu, les Trévires demandèrent secours '
      'aux Germains.)',
    ),
    titreExplication('Qu\'est-ce que l\'ablatif absolu ?'),
    paragrapheExplication(
      'L\'ablatif absolu (AA) est une construction dont le sujet est à '
      'l\'ablatif et dont le verbe au participe (présent actif ou '
      'parfait passif) est également à l\'ablatif. L\'ablatif absolu '
      'latin équivaut en français à une subordonnée circonstancielle, '
      'le plus souvent de temps (quand, lorsque, après que) ou de cause '
      '(comme, puisque).',
    ),
    paragrapheExplication(
      'Il faut d\'abord traduire littéralement l\'ablatif absolu (sujet '
      '+ verbe au participe) et ensuite seulement trouver une '
      'traduction plus élégante en français, avec une nuance de temps '
      'ou de cause, parfois même d\'opposition, selon le contexte. '
      'Attention à la concordance des temps en français : le participe '
      'présent exprime la simultanéité, le participe parfait '
      'l\'antériorité.',
    ),
    tableauColonnes(
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
    paragrapheExplication(
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
    titreExplication('À quoi faut-il faire attention ?'),
    paragrapheExplication(
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
    paragrapheExplication(
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
    paragrapheExplication(
      '3. Le sujet de l\'ablatif absolu ne peut pas avoir de fonction '
      'dans la proposition principale, on aurait sinon un participe '
      'apposé.\n'
      'Ex. : La place forte ayant été prise, les Romains la pillèrent. '
      '→ Les Romains pillèrent la place forte prise. → oppidum captum '
      '(participe apposé, accusatif COD) ≠ oppido capto (ablatif '
      'absolu) !',
    ),
    paragrapheExplication(
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
    titreExplication('Ne pas confondre AA et participe apposé'),
    paragrapheExplication(
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
      paragrapheExplication(
        'AA = sujet à l\'ablatif + participe à l\'ablatif. Participe '
        'présent actif = simultanéité ; participe parfait passif = '
        'antériorité.\n\n'
        'Le sujet de l\'AA ne peut pas avoir de fonction dans la '
        'principale (sinon : participe apposé).',
      ),
      tableauColonnes(
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

final Lecon leconTechniqueTraductionAA = Lecon(
  id: 'technique_traduction_aa',
  titre: 'La technique de traduction de l\'ablatif absolu',
  sousTitre: 'La méthode, étape par étape, en version et en thème',
  icone: Icons.explore,
  unite: 'Vol. I – Unité 9',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('En version (traduire du latin vers le français)'),
    paragrapheExplication(
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
    paragrapheExplication(
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
    titreExplication('En thème (traduire du français vers le latin)'),
    paragrapheExplication(
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
    paragrapheExplication(
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
      paragrapheExplication(
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

final Lecon leconPronomIsEaId = Lecon(
  id: 'pronom_is_ea_id',
  titre: 'Le pronom-adjectif is, ea, id',
  sousTitre: 'Rappel, démonstratif — et suus/ejus pour « son, sa, ses »',
  icone: Icons.bookmark,
  unite: 'Vol. I – Unité 10',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Le pronom-adjectif is, ea, id désigne une personne ou une chose '
      'dont on a déjà parlé : c\'est un pronom-adjectif de rappel.',
    ),
    titreExplication('La morphologie'),
    tableauColonnes(
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
    paragrapheExplication(
      'Un certain nombre de pronoms-adjectifs en latin ont le génitif '
      'singulier en -ius, le datif singulier en -i, et le nominatif/'
      'accusatif neutre singulier en -d. Pour le reste, ils '
      'fonctionnent principalement comme bonus, a, um.',
    ),
    titreExplication('is, ea, id employé comme adjectif'),
    paragrapheExplication(
      'Utilisé comme adjectif, is, ea, id se traduit par l\'adjectif '
      'démonstratif « ce(t)..., cette..., ces... ».\n\n'
      'Ex. : Is puer amicus meus est. (Ce garçon est mon ami.)\n'
      'Optimi filii ei matri sunt. (Cette mère a d\'excellents fils.)',
    ),
    titreExplication('is, ea, id employé comme pronom'),
    paragrapheExplication(
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
    titreExplication('La traduction du génitif latin par « son, sa, ses »'),
    paragrapheExplication(
      'Pour alléger la traduction du génitif ejus, eorum, earum (« de '
      'celui-ci/de lui, de celle-ci/d\'elle, de ceux-ci/d\'eux, de '
      'celles-ci/d\'elles »), on utilise souvent en français l\'adjectif '
      'possessif « son, sa, ses, leur(s) ». Attention : ejus, eorum, '
      'earum ne se rapportent alors jamais au sujet de la même '
      'proposition !',
    ),
    paragrapheExplication(
      'Le latin connaît aussi l\'adjectif possessif suus, a, um, qui se '
      'décline comme un adjectif de la 1re classe et se rapporte '
      'toujours au sujet de la proposition dans laquelle il se trouve. '
      'On l\'appelle adjectif possessif réfléchi.',
    ),
    titreExplication('Remarque 1 : la possession souvent sous-entendue'),
    paragrapheExplication(
      'Le latin sous-entend souvent l\'adjectif possessif, '
      'contrairement au français.\n\n'
      'Ex. : Puella cum familia in Arduenna silva habitat. (La jeune '
      'fille habite dans la forêt des Ardennes avec sa famille.)\n\n'
      'Du français au latin, il n\'est donc pas toujours nécessaire '
      'd\'exprimer la possession par suus, a, um, sauf pour y insister.',
    ),
    titreExplication('Remarque 2 : suus, a, um substantivé'),
    paragrapheExplication(
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
      tableauColonnes(
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
      paragrapheExplication(
        '« son, sa, ses, leur(s) » : suus, a, um si le possesseur est le '
        'sujet de la proposition ; ejus/eorum/earum (génitif) sinon.',
      ),
    ],
  ),
);

// ------------------------------------------------------------
// Leçon : Le pronom relatif qui, quae, quod
// ------------------------------------------------------------

final Lecon leconPronomRelatif = Lecon(
  id: 'pronom_relatif',
  titre: 'Le pronom relatif qui, quae, quod',
  sousTitre: 'Antécédent, accord, le cum d\'accompagnement, l\'adverbe relatif',
  icone: Icons.link,
  unite: 'Vol. I – Unité 10',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Le pronom qui, quae, quod introduit une proposition subordonnée '
      '« reliée » à la proposition principale. On appelle cette '
      'subordonnée « relative », et on appelle « antécédent » (du latin '
      'antecedo, is, ere, « devancer, précéder ») le mot auquel le '
      'pronom relatif se rapporte.',
    ),
    titreExplication('La morphologie'),
    tableauColonnes(
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
    titreExplication('L\'emploi du pronom relatif'),
    paragrapheExplication(
      'Le pronom relatif s\'accorde en genre et en nombre avec '
      'l\'antécédent. Il se met au cas voulu par sa fonction dans la '
      'subordonnée relative.\n\n'
      'Ex. : Bellum [quod Caesar in Gallia gessit] difficile fuit. (La '
      'guerre que César mena en Gaule fut difficile.)',
    ),
    titreExplication('L\'antécédent'),
    paragrapheExplication(
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
    titreExplication('Le cum d\'accompagnement'),
    paragrapheExplication(
      'Le cum d\'accompagnement se place après le relatif à l\'ablatif '
      'et se soude à lui : quocum, quacum, quibuscum.\n\n'
      'Ex. : Amici quibuscum Ledona oppidum petivit multi erant. (Les '
      'amis avec lesquels Ledona gagna la place forte étaient '
      'nombreux.)\n'
      'Mater quacum verba fecimus curis premitur. (La mère à qui / à '
      'laquelle nous avons parlé est accablée de soucis.)',
    ),
    titreExplication('La traduction de « dont »'),
    paragrapheExplication(
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
    titreExplication('L\'adverbe relatif'),
    paragrapheExplication(
      'Un complément circonstanciel de lieu peut être exprimé par une '
      'préposition suivie du pronom relatif au cas voulu, ou bien par '
      'l\'adverbe relatif, dont la forme est invariable.',
    ),
    tableauColonnes(
      ['adverbe relatif', 'sens', 'équivalence'],
      [
        ['ubi', 'où', 'in + ablatif du pronom relatif'],
        ['quo', 'où (direction)', 'in + accusatif du pronom relatif'],
        ['unde', 'd\'où', 'e(x)/a(b) + ablatif du pronom relatif'],
        ['qua', 'par où', 'per + accusatif du pronom relatif'],
      ],
    ),
    const SizedBox(height: 12),
    paragrapheExplication(
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
      tableauColonnes(
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
      paragrapheExplication(
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

final Lecon leconEmploisRelatif = Lecon(
  id: 'emplois_relatif',
  titre: 'Emplois particuliers du pronom relatif',
  sousTitre: 'L\'omission de l\'antécédent, le relatif de liaison',
  icone: Icons.repeat,
  unite: 'Vol. I – Unité 10',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    titreExplication('L\'omission de l\'antécédent'),
    paragrapheExplication(
      'En latin, contrairement au français, l\'antécédent is, ea, id du '
      'pronom relatif est parfois omis, surtout — mais pas seulement — '
      'quand il est au même cas que le relatif. Dans la traduction '
      'française, tu dois le restituer et le traduire par « celui qui, '
      'celle qui, ce qui, etc. ».',
    ),
    paragrapheExplication(
      'facis quod dicis = facis id quod dicis\n'
      '→ tu fais ce que tu dis\n\n'
      'amas quae facis = amas ea quae facis\n'
      '→ tu aimes [ces →] les choses que tu fais → tu aimes ce que tu '
      'fais',
    ),
    titreExplication('Le relatif de liaison'),
    paragrapheExplication(
      'Le relatif de liaison est fréquent dans la littérature latine. '
      'Au début d\'une phrase, il sert à reprendre un élément mentionné '
      'dans la phrase précédente et fait ainsi un lien entre les deux '
      'phrases. On le traduit par la forme équivalente de is, ea, id, '
      'précédée, selon le contexte, d\'une conjonction de coordination.',
    ),
    paragrapheExplication(
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
      paragrapheExplication(
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

final Lecon leconIndicatifFutur = Lecon(
  id: 'indicatif_futur',
  titre: 'L\'indicatif futur',
  sousTitre: '2 groupes de conjugaisons, actif et passif, esse et ses composés',
  icone: Icons.rocket_launch,
  unite: 'Vol. II – Unité 1',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
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
    titreExplication('La formation de l\'indicatif futur'),
    paragrapheExplication(
      'À l\'indicatif futur, les 5 conjugaisons se divisent en 2 '
      'groupes. La conjugaison du verbe esse et de ses composés est à '
      'part.',
    ),
    titreExplication('Groupe 1 : les 1re et 2e conjugaisons'),
    paragrapheExplication(
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
    paragrapheExplication(
      'Attention au passif de la 2e personne du singulier : devant -r-, '
      'un -i- bref se transforme en -e- !\n\n'
      'amabis (« tu aimeras ») → *amabi-ris > amabe-ris (« tu seras '
      'aimé »)\n'
      'monebis (« tu avertiras ») → *monebi-ris > monebe-ris (« tu '
      'seras averti »)',
    ),
    tableauColonnes(
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
    titreExplication('Groupe 2 : les 3e, 4e et 5e conjugaisons'),
    paragrapheExplication(
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
    tableauColonnes(
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
    titreExplication('Le futur du verbe esse et de ses composés'),
    tableauColonnes(
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
    titreExplication('L\'emploi de l\'indicatif futur'),
    paragrapheExplication(
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
      paragrapheExplication(
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

final Lecon leconFuturAnterieurPPF = Lecon(
  id: 'futur_anterieur_ppf',
  titre: 'Le futur antérieur et le plus-que-parfait de l\'indicatif',
  sousTitre: 'Deux temps bâtis sur le radical du parfait',
  icone: Icons.alarm,
  unite: 'Vol. II – Unité 1',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'Le futur antérieur et le plus-que-parfait de l\'indicatif se '
      'forment tous les deux sur le radical du parfait (le radical du '
      'passé).',
    ),
    titreExplication('L\'indicatif futur antérieur'),
    paragrapheExplication(
      'Formation : radical du parfait + -ero, -eris, -erit, -erimus, '
      '-eritis, -erint.',
    ),
    titreExplication('L\'indicatif plus-que-parfait'),
    paragrapheExplication(
      'Formation : radical du parfait + -eram, -eras, -erat, -eramus, '
      '-eratis, -erant.',
    ),
    tableauColonnes(
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
      paragrapheExplication(
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

final Lecon leconSubordonneeConditionnelleIndicatif = Lecon(
  id: 'subordonnee_conditionnelle_indicatif',
  titre: 'La subordonnée conditionnelle à l\'indicatif',
  sousTitre: 'si / nisi, vérité générale et condition dans l\'avenir',
  icone: Icons.rule,
  unite: 'Vol. II – Unité 1',
  uniteRecommandees: unitesRecommandeesTranche(16, 999),
  explication: (context) => [
    paragrapheExplication(
      'La proposition subordonnée conditionnelle à l\'indicatif est '
      'introduite par la conjonction si (« si ») ou nisi (« si... '
      'ne... pas ») et exprime soit une vérité générale, soit une '
      'condition supposée remplie dans l\'avenir.',
    ),
    titreExplication('1. Le verbe à l\'indicatif présent (vérité générale)'),
    paragrapheExplication(
      'Ex. : Si dei sunt, boni magnique sunt. (Si les dieux existent, '
      'ils sont bons et grands.)',
    ),
    tableauColonnes(
      ['', 'dans la subordonnée', 'dans la principale'],
      [
        ['latin et français', 'si + indicatif présent', 'indicatif présent'],
      ],
    ),
    const SizedBox(height: 12),
    titreExplication(
      '2. Le verbe à l\'indicatif futur ou futur antérieur (condition '
      'dans l\'avenir)',
    ),
    paragrapheExplication(
      'Contrairement au latin — qui est sémantiquement plus logique —, '
      'le français utilise l\'indicatif présent après la conjonction '
      '« si ».\n\n'
      'Ex. : Nisi in forum venietis / veneritis, miseri erimus. (Si '
      'vous ne venez pas sur le forum, nous serons malheureux.)',
    ),
    tableauColonnes(
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
      tableauColonnes(
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
      paragrapheExplication(
        'Piège classique : en français, on garde le présent après « si '
        '», même quand le latin est au futur ou au futur antérieur.',
      ),
    ],
  ),
);

