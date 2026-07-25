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
