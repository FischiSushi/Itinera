import 'package:fsrs/fsrs.dart' as fsrs;

// ============================================================
// DATENMODELL
// ============================================================

class Vocabulaire {
  final String latin;
  final String francais;
  final String categorie;
  final String unite;
  final String? etymologie;

  fsrs.Card fsrsCard;

  Vocabulaire({
    required this.latin,
    required this.francais,
    required this.categorie,
    required this.unite,
    this.etymologie,
  }) : fsrsCard = fsrs.Card(cardId: latin.hashCode);
}

// ============================================================
// DEINE VOKABELN
// ============================================================

final List<Vocabulaire> vocabulaire = [

  // ==========================================================
  // VOL. I – UNITÉ 0
  // ==========================================================

  Vocabulaire(
    latin: 'unus, -a, -um',
    francais: 'un, une',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'duo, -ae, -o',
    francais: 'deux',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'tres, tres, tria',
    francais: 'trois',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'quattuor',
    francais: 'quatre',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'quinque',
    francais: 'cinq',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'sex',
    francais: 'six',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'septem',
    francais: 'sept',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'octo',
    francais: 'huit',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'novem',
    francais: 'neuf',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'decem',
    francais: 'dix',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'centum',
    francais: 'cent',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'mille',
    francais: 'mille',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
    etymologie: 'millésime / ESP. et PORT. mil',
  ),

  Vocabulaire(
    latin: 'primus, -a, -um',
    francais: 'premier, -ère',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'secundus, -a, -um',
    francais: 'second, e ; deuxième',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'tertius, -a, -um',
    francais: 'troisième',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'quartus, -a, -um',
    francais: 'quatrième',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'quintus, -a, -um',
    francais: 'cinquième',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'sextus, -a, -um',
    francais: 'sixième',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'septimus, -a, -um',
    francais: 'septième',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'octavus, -a, -um',
    francais: 'huitième',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'nonus, -a, -um',
    francais: 'neuvième',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'decimus, -a, -um',
    francais: 'dixième',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'centesimus, -a, -um',
    francais: 'centième',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  Vocabulaire(
    latin: 'millesimus, -a, -um',
    francais: 'millième',
    unite: 'Vol. I – Unité 0',
    categorie: 'Nombres',
  ),

  // ==========================================================
  // VOL. I – UNITÉ 1
  // ==========================================================

  Vocabulaire(
    latin: 'advena, -ae, m.',
    francais: 'étranger',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie: 'advenir / ESP. advenir / ALL. Advent',
  ),

  Vocabulaire(
    latin: 'copia, -ae, f.',
    francais: 'abondance, quantité',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie: 'copieux / IT. copioso',
  ),

  Vocabulaire(
    latin: 'copiae, -arum, f. pl.',
    francais: 'les/des troupes (militaires)',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
  ),

  Vocabulaire(
    latin: 'caterva, -ae, f.',
    francais: 'la troupe (militaire)',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
  ),

  Vocabulaire(
    latin: 'cura, -ae, f.',
    francais: 'soin, souci',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie: 'manucure, pédicure, sinécure',
  ),

  Vocabulaire(
    latin: 'dea, -ae, f.',
    francais: 'déesse',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie: 'PORT. deusa',
  ),

  Vocabulaire(
    latin: 'fama, -ae, f.',
    francais: 'bruit qui court, rumeur, renommée, réputation',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie: 'fameux, infâme, un lieu mal famé / PORT. fama / ANGL. famous',
  ),

  Vocabulaire(
    latin: 'familia, -ae, f.',
    francais: 'famille, maisonnée, le personnel des esclaves',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie:
        'familial, familier / ESP. familia / PORT. família / IT. famiglia / ROUM. familie',
  ),

  Vocabulaire(
    latin: 'femina, -ae, f.',
    francais: 'femme',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie: 'féminin, féminité / ROUM. femeia',
  ),

  Vocabulaire(
    latin: 'fibula, -ae, f.',
    francais: 'fibule, agrafe pour cheveux ou vêtements',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
  ),

  Vocabulaire(
    latin: 'fortuna, -ae, f.',
    francais: 'sort, destin, hasard, chance, fortune',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie:
        'fortuit(e), fortuité, la roue de la fortune / ANGL. fortuite / IT., PORT. et ESP. fortuna',
  ),

  Vocabulaire(
    latin: 'Gallia, -ae, f.',
    francais: 'la Gaule',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie: 'IT. Gallia / ESP. Galia / PORT. Gália',
  ),

  Vocabulaire(
    latin: 'gloria, -ae, f.',
    francais: 'gloire',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie: 'glorifier, glorifiant / PORT. glória / ESP. et IT. gloria',
  ),

  Vocabulaire(
    latin: 'Ledona, -ae, f.',
    francais: 'Ledona (prénom féminin gaulois)',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
  ),

  Vocabulaire(
    latin: 'patria, -ae, f.',
    francais: 'patrie',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie:
        'patriotisme, patriote / ESP. et IT. patria / PORT. pátria',
  ),

  Vocabulaire(
    latin: 'puella, -ae, f.',
    francais: 'jeune fille',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie: 'pucelle',
  ),

  Vocabulaire(
    latin: 'Roma, -ae, f.',
    francais: 'Rome',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie: 'palindrome : ROMA AMOR',
  ),

  Vocabulaire(
    latin: 'silva, -ae, f.',
    francais: 'forêt, bois',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie: 'sylvestre / PORT. silva (la ronce)',
  ),

  Vocabulaire(
    latin: 'terra, -ae, f.',
    francais: 'terre',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie: 'terrestre / PORT. et IT. terra / ESP. tierra',
  ),

  Vocabulaire(
    latin: 'tunica, -ae, f.',
    francais: 'tunique',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie: 'IT. tunica / PORT. et ESP. túnica',
  ),

  Vocabulaire(
    latin: 'Vesta, -ae, f.',
    francais: 'Vesta (déesse du feu et du foyer ; Vestales)',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
  ),

  Vocabulaire(
    latin: 'vita, -ae, f.',
    francais: 'vie',
    unite: 'Vol. I – Unité 1',
    categorie: 'Noms',
    etymologie: 'vital, vitalité / IT. vita / ESP. et PORT. vida / ad vitam aeternam',
  ),

  // ---------------- ADJECTIFS ----------------

  Vocabulaire(
    latin: 'bonus, -a, -um',
    francais: 'bon',
    unite: 'Vol. I – Unité 1',
    categorie: 'Adjectifs',
    etymologie: 'bonus, bonté / PORT. bom / IT. buono / ESP. bueno',
  ),

  Vocabulaire(
    latin: 'clarus, -a, -um',
    francais: 'clair, brillant, éclatant ; célèbre, illustre',
    unite: 'Vol. I – Unité 1',
    categorie: 'Adjectifs',
    etymologie: 'la clarté, clarifier / ESP. et PORT. claro / IT. chiaro',
  ),

  Vocabulaire(
    latin: 'Gallicus, -a, -um',
    francais: 'gaulois',
    unite: 'Vol. I – Unité 1',
    categorie: 'Adjectifs',
    etymologie: 'IT. gallico / ALL. gallisch',
  ),

  Vocabulaire(
    latin: 'magnus, -a, -um',
    francais: 'grand',
    unite: 'Vol. I – Unité 1',
    categorie: 'Adjectifs',
    etymologie: 'magnitude, magnifique / Karolus Magnus (Charlemagne)',
  ),

  Vocabulaire(
    latin: 'meus, -a, -um',
    francais: 'mon',
    unite: 'Vol. I – Unité 1',
    categorie: 'Adjectifs',
    etymologie: 'PORT. meu',
  ),

  Vocabulaire(
    latin: 'novus, -a, -um',
    francais: 'nouveau',
    unite: 'Vol. I – Unité 1',
    categorie: 'Adjectifs',
    etymologie: 'novic / PORT. novo / ESP. nuevo / IT. nuovo',
  ),

  Vocabulaire(
    latin: 'Romanus, -a, -um',
    francais: 'romain',
    unite: 'Vol. I – Unité 1',
    categorie: 'Adjectifs',
    etymologie: 'senatus populusque Romanus (SPQR)',
  ),

  // ---------------- VERBE ----------------

  Vocabulaire(
    latin: 'sum, es, esse, fui',
    francais: 'être',
    unite: 'Vol. I – Unité 1',
    categorie: 'Verbes',
  ),

  // ---------------- PRÉPOSITIONS ----------------

  Vocabulaire(
    latin: 'ad + acc.',
    francais: 'près de, vers, auprès de, chez (une personne)',
    unite: 'Vol. I – Unité 1',
    categorie: 'Prépositions',
    etymologie: 'préfixe ad-, adverbe, adhésion / ad libitum, ad absurdum',
  ),

  Vocabulaire(
    latin: 'cum + abl.',
    francais: 'avec, en compagnie de (personnes)',
    unite: 'Vol. I – Unité 1',
    categorie: 'Prépositions',
    etymologie: 'compagnon / PORT. com / ESP. et IT. con',
  ),

  Vocabulaire(
    latin: 'de + abl.',
    francais: 'du haut de, au sujet de, de',
    unite: 'Vol. I – Unité 1',
    categorie: 'Prépositions',
    etymologie: 'de facto',
  ),

  Vocabulaire(
    latin: 'in + abl.',
    francais: 'dans, en, sur',
    unite: 'Vol. I – Unité 1',
    categorie: 'Prépositions',
  ),

  Vocabulaire(
    latin: 'per + acc.',
    francais: 'à travers, par ; pendant',
    unite: 'Vol. I – Unité 1',
    categorie: 'Prépositions',
    etymologie: 'perpendiculaire / IT. per / ESP. et PORT. por ; persévérer, perpétuer',
  ),

  // ---------------- MOTS-OUTILS ----------------

  Vocabulaire(
    latin: 'et',
    francais: 'et',
    unite: 'Vol. I – Unité 1',
    categorie: 'Mots-outils',
    etymologie: 'etc. (et cetera)',
  ),

  Vocabulaire(
    latin: 'ita',
    francais: 'ainsi',
    unite: 'Vol. I – Unité 1',
    categorie: 'Mots-outils',
    etymologie: 'ita est (formule latine validant un acte notarié)',
  ),

  Vocabulaire(
    latin: 'itaque',
    francais: 'c\'est pourquoi, voilà pourquoi ; aussi',
    unite: 'Vol. I – Unité 1',
    categorie: 'Mots-outils',
  ),

  Vocabulaire(
    latin: 'nam',
    francais: 'car, en effet',
    unite: 'Vol. I – Unité 1',
    categorie: 'Mots-outils',
  ),

  Vocabulaire(
    latin: 'numquam',
    francais: 'ne ... jamais, jamais ... ne',
    unite: 'Vol. I – Unité 1',
    categorie: 'Mots-outils',
    etymologie: 'ESP. et PORT. nunca',
  ),

  Vocabulaire(
    latin: 'nunc',
    francais: 'maintenant',
    unite: 'Vol. I – Unité 1',
    categorie: 'Mots-outils',
    etymologie: 'hic et nunc',
  ),

  Vocabulaire(
    latin: 'quoque',
    francais: 'aussi, également',
    unite: 'Vol. I – Unité 1',
    categorie: 'Mots-outils',
    etymologie: 'Tu quoque, fili mi.',
  ),

  Vocabulaire(
    latin: 'saepe',
    francais: 'souvent',
    unite: 'Vol. I – Unité 1',
    categorie: 'Mots-outils',
  ),

  Vocabulaire(
    latin: 'sed',
    francais: 'mais',
    unite: 'Vol. I – Unité 1',
    categorie: 'Mots-outils',
    etymologie: 'dura lex, sed lex',
  ),

  Vocabulaire(
    latin: 'semper',
    francais: 'toujours',
    unite: 'Vol. I – Unité 1',
    categorie: 'Mots-outils',
    etymologie: 'sempiternel / PORT. sempre / ESP. siempre',
  ),

  // ==========================================================
  // VOL. I – UNITÉ 2
  // ==========================================================

  Vocabulaire(latin: 'Aegyptus, i, f.', francais: 'Égypte', unite: 'Vol. I – Unité 2', categorie: 'Noms'),
  Vocabulaire(latin: 'ager, agri, m.', francais: 'champ ; territoire', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'agricole, agriculture, agraire'),
  Vocabulaire(latin: 'amicus, i, m.', francais: 'ami', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'amical, amicalement / IT. amico / PORT. et ESP. amigo'),
  Vocabulaire(latin: 'inimicus, i, m.', francais: 'ennemi (personnel)', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: '< in + amicus'),
  Vocabulaire(latin: 'animus, i, m.', francais: '1. esprit 2. âme 3. courage', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'animosité / ESP. ánimo / PORT. ânimo / mens sana in corpore sano'),
  Vocabulaire(latin: 'annus, i, m.', francais: 'an, année', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'annuel, biennale, quinquennat'),
  Vocabulaire(latin: 'aqua, ae, f.', francais: 'eau', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'aquarium, aquatique, aquarelle / IT. acqua / PORT. et ESP. agua'),
  Vocabulaire(latin: 'deus, i, m.', francais: 'dieu', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'deus ex machina / PORT. deus'),
  Vocabulaire(latin: 'dominus, i, m.', francais: 'maître', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'dominical / ESP. et PORT. domingo / IT. domenica'),
  Vocabulaire(latin: 'druida, ae, m.', francais: 'druide', unite: 'Vol. I – Unité 2', categorie: 'Noms'),
  Vocabulaire(latin: 'equus, i, m.', francais: 'cheval', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'équitation, équestre'),
  Vocabulaire(latin: 'fera, ae, f.', francais: 'bête sauvage', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'ESP. fiera'),
  Vocabulaire(latin: 'filius, i, m.', francais: 'fils', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'filial, filiation / IT. figlio / PORT. filho'),
  Vocabulaire(latin: 'fluvius, i, m.', francais: 'fleuve', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'fluvial, effluve / ROUM. fluviu'),
  Vocabulaire(latin: 'gemelli, orum, m. pl.', francais: 'jumeaux', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'gémellaire, gémeaux / ROUM. gemeni / PORT. gémeos / IT. gemelli / ESP. gemelos'),
  Vocabulaire(latin: 'gratia, ae, f.', francais: '1. reconnaissance 2. faveur', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'gratis pro deo ; ars gratia artis / IT. grazia / PORT. graça / ESP. gracia / ROUM. gratie'),
  Vocabulaire(latin: 'laurus, i, f.', francais: 'laurier (m.)', unite: 'Vol. I – Unité 2', categorie: 'Noms'),
  Vocabulaire(latin: 'liberi, orum, m. pl.', francais: 'enfants (fils et filles, par opposition aux parents)', unite: 'Vol. I – Unité 2', categorie: 'Noms'),
  Vocabulaire(latin: 'locus, i, m.', francais: 'lieu, endroit', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'IT. luogo / ROUM. loc'),
  Vocabulaire(latin: 'lupa, ae, f.', francais: 'louve', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'ESP. et PORT. loba'),
  Vocabulaire(latin: 'lupus, i, m.', francais: 'loup', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'ESP. et PORT. lobo'),
  Vocabulaire(latin: 'murus, i, m.', francais: 'mur (m.)', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'mur, mural / intra muros, extra muros'),
  Vocabulaire(latin: 'muri, orum, m. pl.', francais: 'remparts, murailles', unite: 'Vol. I – Unité 2', categorie: 'Noms'),
  Vocabulaire(latin: 'populus, i, m.', francais: 'peuple', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'senatus populusque Romanus (SPQR)'),
  Vocabulaire(latin: 'puer, i, m.', francais: 'garçon ; enfant', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'puéril, puériculture'),
  Vocabulaire(latin: 'ripa, ae, f.', francais: 'rive, rivage', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'Riparenses (soldats romains stationnés sur les rives du Danube)'),
  Vocabulaire(latin: 'Romani, orum, m. pl.', francais: 'les Romains', unite: 'Vol. I – Unité 2', categorie: 'Noms'),
  Vocabulaire(latin: 'servus, i, m.', francais: 'esclave', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'servitude, servile, asservir'),
  Vocabulaire(latin: 'Treveri, orum, m. pl.', francais: 'les Trévires', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'Colonia Augusta Treverorum = Trèves / Trier'),
  Vocabulaire(latin: 'umbra, ae, f.', francais: 'ombre', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'ROUM. umbra'),
  Vocabulaire(latin: 'vir, viri, m.', francais: '1. homme 2. mari', unite: 'Vol. I – Unité 2', categorie: 'Noms', etymologie: 'viril, virilité / duumvir, triumvir / ESP. virago'),

  Vocabulaire(latin: 'malus, a, um', francais: 'mauvais, méchant', unite: 'Vol. I – Unité 2', categorie: 'Adjectifs', etymologie: 'un malus, la malice'),
  Vocabulaire(latin: 'miser, misera, miserum', francais: 'malheureux, misérable', unite: 'Vol. I – Unité 2', categorie: 'Adjectifs', etymologie: 'misère, miséricorde'),
  Vocabulaire(latin: 'pulcher, pulchra, pulchrum', francais: 'beau', unite: 'Vol. I – Unité 2', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'sacer, sacra, sacrum', francais: 'sacré', unite: 'Vol. I – Unité 2', categorie: 'Adjectifs', etymologie: 'sacrifice, sacrilège / auri sacra fames'),

  Vocabulaire(latin: 'ante + acc.', francais: 'avant [CCT] ; devant [CCL]', unite: 'Vol. I – Unité 2', categorie: 'Prépositions', etymologie: 'antérieur, antériorité'),
  Vocabulaire(latin: 'ex / e + abl.', francais: 'hors de, de ; à partir de', unite: 'Vol. I – Unité 2', categorie: 'Prépositions', etymologie: 'exporter / ex nihilo nihil'),
  Vocabulaire(latin: 'in + acc.', francais: 'dans, en, sur (lieu où l\'on va)', unite: 'Vol. I – Unité 2', categorie: 'Prépositions', etymologie: 'in memoriam'),
  Vocabulaire(latin: 'post + acc.', francais: 'après [CCT] ; derrière [CCL]', unite: 'Vol. I – Unité 2', categorie: 'Prépositions', etymologie: 'postérieur, postériorité, postérité'),
  Vocabulaire(latin: 'prope + acc.', francais: 'près de (choses)', unite: 'Vol. I – Unité 2', categorie: 'Prépositions', etymologie: 'ROUM. aproape'),
  Vocabulaire(latin: 'super + acc.', francais: 'au-dessus de, au-delà de', unite: 'Vol. I – Unité 2', categorie: 'Prépositions', etymologie: 'super (interjection), Superman'),

  Vocabulaire(latin: 'autem', francais: 'or, mais, quant à', unite: 'Vol. I – Unité 2', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'enim', francais: 'en effet ; car (= nam)', unite: 'Vol. I – Unité 2', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'etiam', francais: 'aussi, même, encore', unite: 'Vol. I – Unité 2', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'ibi', francais: 'là, à cet endroit, y', unite: 'Vol. I – Unité 2', categorie: 'Mots-outils', etymologie: 'ubi bene ibi patria'),
  Vocabulaire(latin: 'jam', francais: '1. déjà 2. désormais ; dès lors', unite: 'Vol. I – Unité 2', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'neque / nec', francais: 'et ... ne ... pas', unite: 'Vol. I – Unité 2', categorie: 'Mots-outils', etymologie: 'nec dominus nec magister'),
  Vocabulaire(latin: 'non', francais: 'ne ... pas, non', unite: 'Vol. I – Unité 2', categorie: 'Mots-outils', etymologie: 'IT. non / ANGL. no / non bis in idem'),
  Vocabulaire(latin: 'non jam', francais: 'ne ... plus', unite: 'Vol. I – Unité 2', categorie: 'Mots-outils'),
  Vocabulaire(latin: '-que', francais: 'et', unite: 'Vol. I – Unité 2', categorie: 'Mots-outils', etymologie: 'senatus populusque Romanus (SPQR)'),
  Vocabulaire(latin: 'quia, quod', francais: 'parce que', unite: 'Vol. I – Unité 2', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'tum, tunc', francais: 'alors', unite: 'Vol. I – Unité 2', categorie: 'Mots-outils', etymologie: 'ROUM. atunci'),
  Vocabulaire(latin: 'ubi + ind.', francais: 'quand, lorsque (= cum, ut)', unite: 'Vol. I – Unité 2', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. I – UNITÉ 3
  // ==========================================================

  Vocabulaire(latin: 'arma, orum, n. pl.', francais: 'les armes', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'PORT. et ESP. armas / IT. arme / arma cedant togae'),
  Vocabulaire(latin: 'auxilium, i, n.', francais: 'aide, secours', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'verbe auxiliaire'),
  Vocabulaire(latin: 'bellum, i, n.', francais: 'guerre', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'belliqueux, belligérant, rebelle'),
  Vocabulaire(latin: 'castra, orum, n. pl.', francais: 'le camp (militaire)', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'ESP. et IT. castro'),
  Vocabulaire(latin: 'consilium, i, n.', francais: '1. plan, projet 2. résolution, décision 3. conseil 4. sagesse 5. assemblée', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'IT. concilio'),
  Vocabulaire(latin: 'forum, i, n.', francais: 'place publique, forum', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'foris (dehors) / PORT. fórum / ESP. et IT. foro / ANGL. forum'),
  Vocabulaire(latin: 'Galli, orum, m. pl.', francais: 'les Gaulois', unite: 'Vol. I – Unité 3', categorie: 'Noms'),
  Vocabulaire(latin: 'imperium, i, n.', francais: '1. autorité, pouvoir 2. domination 3. empire', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'impérial, impérialisme / PORT. império, ESP. imperio, IT. impero'),
  Vocabulaire(latin: 'incola, ae, m.', francais: 'habitant', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'colon'),
  Vocabulaire(latin: 'legatus, i, m.', francais: '1. représentant, émissaire, ambassadeur 2. légat, lieutenant', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: '< lego, as, are / IT. legato / ANGL. legate'),
  Vocabulaire(latin: 'ludus, i, m.', francais: '1. jeu, amusement ; jeux (publics) 2. école', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'ludique, ludothèque, ludologie / IT. ludico / ESP. et PORT. lúdico'),
  Vocabulaire(latin: 'nuntius, i, m.', francais: '1. messager, courrier 2. message, nouvelle', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'annoncer / IT. nunzio / ESP. nuncio'),
  Vocabulaire(latin: 'oppidum, i, n.', francais: 'place forte', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'l\'oppidum du Titelberg'),
  Vocabulaire(latin: 'praesidium, i, n.', francais: 'défense, garnison, protection (contre) (+dat.)', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'président, présidence / ALL. Polizeipräsidium'),
  Vocabulaire(latin: 'regnum, i, n.', francais: '1. royaume 2. règne 3. royauté', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'régner / IT. regne / PORT. et ESP. reinado'),
  Vocabulaire(latin: 'saxum, i, n.', francais: 'rocher', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'saxatile'),
  Vocabulaire(latin: 'spatium, i, n.', francais: 'espace', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'espacer qqch., spatial / ANGL. space'),
  Vocabulaire(latin: 'templum, i, n.', francais: 'temple', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'templier / ESP. et PORT. templo / IT. tempio'),
  Vocabulaire(latin: 'verbum, i, n.', francais: 'parole, mot', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'verbe, adverbe, proverbe / ESP., PORT. et IT. verbo'),
  Vocabulaire(latin: 'via, ae, f.', francais: '1. chemin, route, voie 2. voie, rue 3. route, voyage, trajet, course', unite: 'Vol. I – Unité 3', categorie: 'Noms', etymologie: 'viaduc / PORT. et IT. via / ESP. vía'),

  Vocabulaire(latin: 'altus, a, um', francais: '1. haut ; élevé 2. profond', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs', etymologie: 'altitude, altier / PORT., ESP. et IT. alto'),
  Vocabulaire(latin: 'cuncti, ae, a', francais: 'tous (sans exception)', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'cunctus, a, um', francais: 'tout ; tout entier (= totus)', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'multi, ae, a', francais: 'beaucoup de, de nombreux', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs', etymologie: 'multitude, multiple'),
  Vocabulaire(latin: 'noster, nostra, nostrum', francais: 'notre', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs', etymologie: 'ESP. nuestro / IT. nostro / ROUM. nostru'),
  Vocabulaire(latin: 'parvus, a, um', francais: 'petit', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs', etymologie: 'PORT. parvo (sot, imbécile)'),
  Vocabulaire(latin: 'propinquus, a, um', francais: 'proche ; voisin', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs', etymologie: '< prope + inquus / ROUM. apropriat'),
  Vocabulaire(latin: 'totus, a, um', francais: 'tout ; tout entier', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs', etymologie: 'total / ESP. et PORT. todo / IT. tutto / ROUM. tot'),
  Vocabulaire(latin: 'vester, vestra, vestrum', francais: 'votre', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs', etymologie: 'ESP. vuestro / IT. vostro / ROUM. vostru'),

  Vocabulaire(latin: 'bonus, i, m.', francais: 'un homme bon, un homme de bien', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs substantivés'),
  Vocabulaire(latin: 'boni, orum, m. pl.', francais: 'les gens de bien', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs substantivés'),
  Vocabulaire(latin: 'multi, orum, m. pl.', francais: 'beaucoup de gens', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs substantivés'),
  Vocabulaire(latin: 'multae, arum, f. pl.', francais: 'beaucoup de femmes', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs substantivés'),
  Vocabulaire(latin: 'propinqui, orum, m. pl.', francais: 'les proches parents', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs substantivés'),
  Vocabulaire(latin: 'nostri, orum, m. pl.', francais: 'les nôtres, nos parents, nos amis', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs substantivés'),
  Vocabulaire(latin: 'bonum, i, n.', francais: 'une chose bonne, un bien, le bien', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs substantivés'),
  Vocabulaire(latin: 'bona, orum, n. pl.', francais: 'les biens', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs substantivés'),
  Vocabulaire(latin: 'malum, i, n.', francais: 'une chose mauvaise, un mal, le mal', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs substantivés'),
  Vocabulaire(latin: 'mala, orum, n. pl.', francais: 'les maux', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs substantivés'),
  Vocabulaire(latin: 'multa, orum, n. pl.', francais: 'de nombreuses choses, beaucoup (de choses)', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs substantivés'),
  Vocabulaire(latin: 'cuncta, orum, n. pl.', francais: 'toutes les choses, tout', unite: 'Vol. I – Unité 3', categorie: 'Adjectifs substantivés'),

  Vocabulaire(latin: 'amo, as, are, amavi, amatum', francais: 'aimer', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'amateur / IT. amare / ESP. et PORT. amar'),
  Vocabulaire(latin: 'audio, is, ire, audivi, auditum', francais: 'entendre, écouter', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'auditeur, audition, audience'),
  Vocabulaire(latin: 'capio, is, ere, cepi, captum', francais: 'prendre', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'capturer, captivant, captif'),
  Vocabulaire(latin: 'consilium capere + inf.', francais: 'prendre la décision de + inf.', unite: 'Vol. I – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'consilium capere de + abl.', francais: 'prendre une décision au sujet de', unite: 'Vol. I – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'condo, is, ere, condidi, conditum', francais: '1. fonder 2. mettre de côté, cacher', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'ab Vrbe condita'),
  Vocabulaire(latin: 'do, das, dare, dedi, datum', francais: 'donner', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'don, donation / IT. dare / ESP. et PORT. dar'),
  Vocabulaire(latin: 'auxilium dare + dat.', francais: 'donner de l\'aide à qqn', unite: 'Vol. I – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'facio, is, ere, feci, factum', francais: 'faire', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'défaire, refaire / IT. fare / PORT. fazer / ESP. hacer'),
  Vocabulaire(latin: 'verba facere (cum + abl. / de + abl.)', francais: 'parler (à qqn / de qqch.)', unite: 'Vol. I – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'gero, is, ere, gessi, gestum', francais: '1. mener, diriger, faire 2. exercer [une fonction]', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'gestion'),
  Vocabulaire(latin: 'bellum gerere (cum + abl.)', francais: 'mener la guerre (contre)', unite: 'Vol. I – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'habeo, es, ere, habui, habitum', francais: 'avoir, posséder', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'Habemus papam / ALL. haben / ESP. haber / ANGL. to have'),
  Vocabulaire(latin: 'gratiam habere (+ dat.)', francais: 'avoir/témoigner de la reconnaissance (à qqn) ; remercier (qqn)', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'ESP. gracias / IT. grazie / PORT. graça'),
  Vocabulaire(latin: 'maneo, es, ere, mansi, mansum', francais: 'rester, demeurer', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'manoir, permanence / IT. rimanere'),
  Vocabulaire(latin: 'mitto, is, ere, misi, missum', francais: 'envoyer', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'missive, missile, mission'),
  Vocabulaire(latin: 'moneo, es, ere, monui, monitum', francais: '1. avertir 2. conseiller', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'moniteur, prémonition'),
  Vocabulaire(latin: 'paro, as, are, paravi, paratum', francais: 'préparer', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'préparation / si vis pacem para bellum / ALL. parat'),
  Vocabulaire(latin: 'pono, is, ere, posui, positum (in + abl.)', francais: 'placer, poser, installer (sur)', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'position, positionner, poste'),
  Vocabulaire(latin: 'castra ponere ≠ castra movere', francais: 'établir (installer) le camp ≠ lever le camp', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'castra aestiva, castra hiberna'),
  Vocabulaire(latin: 'regno, as, are, regnavi, regnatum', francais: 'régner, exercer le règne', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'rex, regnum / IT. regnare / ESP. reinar / ANGL. to reign'),
  Vocabulaire(latin: 'timeo, es, ere, timui', francais: 'avoir peur de, craindre', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'timide, intimider'),
  Vocabulaire(latin: 'venio, is, ire, veni, ventum', francais: 'venir', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'advenir, l\'avent / ESP. venir / IT. venire'),
  Vocabulaire(latin: 'vivo, is, ere, vixi, victum', francais: 'vivre, être vivant', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'vivarium / ESP. vivir / PORT. viver / IT. vivere'),
  Vocabulaire(latin: 'voco, as, are, vocavi, vocatum (ad + acc.)', francais: '1. appeler (à) 2. inviter (à)', unite: 'Vol. I – Unité 3', categorie: 'Verbes', etymologie: 'vocatif, vocal, vocation, invocation, invoquer'),

  Vocabulaire(latin: 'aut', francais: 'ou [exclusif]', unite: 'Vol. I – Unité 3', categorie: 'Mots-outils', etymologie: 'aut Caesar aut nihil'),
  Vocabulaire(latin: 'deinde', francais: 'ensuite, puis', unite: 'Vol. I – Unité 3', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'mox', francais: 'bientôt', unite: 'Vol. I – Unité 3', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'nondum', francais: 'ne ... pas encore, non encore', unite: 'Vol. I – Unité 3', categorie: 'Mots-outils', etymologie: '< non + dum'),
  Vocabulaire(latin: 'tantum', francais: 'seulement', unite: 'Vol. I – Unité 3', categorie: 'Mots-outils', etymologie: 'plurale tantum, singulare tantum'),

  // ==========================================================
  // VOL. I – UNITÉ 4
  // ==========================================================

  Vocabulaire(latin: 'ancilla, ae, f.', francais: 'servante, esclave', unite: 'Vol. I – Unité 4', categorie: 'Noms'),
  Vocabulaire(latin: 'ara, ae, f.', francais: 'autel', unite: 'Vol. I – Unité 4', categorie: 'Noms', etymologie: 'Ara Pacis Augustae'),
  Vocabulaire(latin: 'filia, ae, f.', francais: 'fille', unite: 'Vol. I – Unité 4', categorie: 'Noms', etymologie: 'filial, filiation'),
  Vocabulaire(latin: 'initium, i, n. (initio, ab initio)', francais: 'commencement, début (au début / dès le début)', unite: 'Vol. I – Unité 4', categorie: 'Noms', etymologie: 'l\'initiale / PORT. início / ESP. inicio / IT. inizio'),
  Vocabulaire(latin: 'proelium, i, n.', francais: 'combat, bataille (= pugna)', unite: 'Vol. I – Unité 4', categorie: 'Noms'),
  Vocabulaire(latin: 'pugna, ae, f.', francais: 'bataille, combat', unite: 'Vol. I – Unité 4', categorie: 'Noms', etymologie: '< pugnus (le poing) / pugnacité'),
  Vocabulaire(latin: 'sententia, ae, f.', francais: '1. opinion, avis 2. sentence', unite: 'Vol. I – Unité 4', categorie: 'Noms', etymologie: 'sententia mea / Lata sententia, judex desinit esse judex.'),
  Vocabulaire(latin: 'socius, i, m.', francais: '1. compagnon 2. allié', unite: 'Vol. I – Unité 4', categorie: 'Noms', etymologie: 'associé, association / IT. et ESP. socio / PORT. sócio'),

  Vocabulaire(latin: 'tuus, a, um', francais: 'ton', unite: 'Vol. I – Unité 4', categorie: 'Adjectifs'),

  Vocabulaire(latin: 'absum, -es, -esse, afui (a(b) + abl.)', francais: 'être absent (de), être loin (de)', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: '< ab + esse / absence, absent'),
  Vocabulaire(latin: 'adsum, -es, -esse, adfui (+ dat.)', francais: '1. être présent, être là ; être près (de) 2. aider (qqn)', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: '< ad + esse'),
  Vocabulaire(latin: 'augeo, es, ere, auxi, auctum', francais: 'augmenter, accroître', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: 'ANGL. auction'),
  Vocabulaire(latin: 'cupio, is, ere, cupivi, cupitum (+ inf.)', francais: 'désirer (+ inf.)', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: 'cupidité, cupide, Cupidon'),
  Vocabulaire(latin: 'debeo, es, ere, debui, debitum (+ inf.)', francais: '1. devoir qqch. à qqn 2. devoir (+ inf.), être obligé (à)', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: 'devoir, débiteur / ANGL. debt'),
  Vocabulaire(latin: 'desum, -es, -esse, defui (+ dat.)', francais: 'manquer (à), faire défaut (à)', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: '< de + esse'),
  Vocabulaire(latin: 'habere + 2 acc.', francais: 'avoir + COD + attr. du COD ; considérer qqn/qqch. comme', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: 'Romulum dominum habere'),
  Vocabulaire(latin: 'interficio, is, ere, -feci, -fectum', francais: 'tuer', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: 'interfector (le meurtrier)'),
  Vocabulaire(latin: 'intersum, -es, -esse, interfui (+ dat.)', francais: 'participer (à)', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: 'intéresser, intérêt'),
  Vocabulaire(latin: 'obsum, -es, -esse, obfui (+ dat.)', francais: 's\'opposer (à), faire obstacle (à), nuire (à)', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: '< ob + esse'),
  Vocabulaire(latin: 'possum, potes, posse, potui (+ inf.)', francais: 'pouvoir (+ inf.)', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: 'puissant, puissance / IT. potere'),
  Vocabulaire(latin: 'praesum, -es, -esse, praefui (+ dat.)', francais: 'commander (à), être à la tête (de), présider (à)', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: 'président'),
  Vocabulaire(latin: 'prosum, prodes, prodesse, profui (+ dat.)', francais: 'être utile (à), profiter (à), servir (à)', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: '< pro + esse'),
  Vocabulaire(latin: 'pugno, as, are, avi, atum (cum + abl.)', francais: 'combattre (contre)', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: 'pugnace, pugnacité'),
  Vocabulaire(latin: 'relinquo, is, ere, reliqui, relictum', francais: 'laisser, quitter, abandonner', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: 'une relique'),
  Vocabulaire(latin: 'respondeo, es, ere, respondi, responsum', francais: 'répondre', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: 'PORT. et ESP. responder'),
  Vocabulaire(latin: 'rogo, as, are + acc. ; rogare + 2 acc.', francais: 'demander qqch. ; interroger qqn ; demander qqch. à qqn', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: 'interrogatoire'),
  Vocabulaire(latin: 'supersum, -es, -esse, superfui (+ dat.)', francais: 'survivre (à), subsister (à)', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: '< super + esse'),
  Vocabulaire(latin: 'video, es, ere, vidi, visum', francais: 'voir', unite: 'Vol. I – Unité 4', categorie: 'Verbes', etymologie: 'vidéo, vidéoconférence, vision / IT. vedere / ROUM. vedea'),

  Vocabulaire(latin: 'adversus + acc.', francais: 'contre', unite: 'Vol. I – Unité 4', categorie: 'Prépositions', etymologie: 'adversaire, adversité'),
  Vocabulaire(latin: 'apud + acc.', francais: 'auprès de, près de, chez (des personnes)', unite: 'Vol. I – Unité 4', categorie: 'Prépositions', etymologie: 'apud me, apud te ...'),
  Vocabulaire(latin: 'pro + abl.', francais: '1. devant 2. à la place de 3. pour la défense de 4. en proportion de', unite: 'Vol. I – Unité 4', categorie: 'Prépositions', etymologie: 'ALL. pro & kontra'),
  Vocabulaire(latin: 'sine + abl.', francais: 'sans', unite: 'Vol. I – Unité 4', categorie: 'Prépositions', etymologie: 'ESP. sin'),
  Vocabulaire(latin: 'sub + abl.', francais: 'sous, en dessous de', unite: 'Vol. I – Unité 4', categorie: 'Prépositions', etymologie: 'subalterne, subvention, subordonné(e) / ANGL. subway, suburban'),

  Vocabulaire(latin: 'aut ... aut ...', francais: 'ou bien ... ou bien ... ; soit ... soit ...', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils', etymologie: 'aut Caesar aut nihil'),
  Vocabulaire(latin: 'bene', francais: 'bien', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils', etymologie: 'IT. bene / ESP. bien / PORT. bem / Qui bene amat bene castigat'),
  Vocabulaire(latin: 'certe / certo', francais: 'certes, assurément, sans aucun doute ; du moins, en tout cas', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'Cur ... ?', francais: 'Pourquoi ... ?', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'diu', francais: 'longtemps', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'igitur', francais: 'donc', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: '-ne ... ?', francais: 'Est-ce que ... ?', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'Nonne ... ?', francais: 'Est-ce que ... ne ... pas ?', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'Num ... ?', francais: 'Est-ce que par hasard ... ? Est-ce que vraiment ... ?', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'primum', francais: 'd\'abord, pour la première fois', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils', etymologie: 'FR. primo'),
  Vocabulaire(latin: 'Quo ... ?', francais: 'Où ... ? (mouvement)', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'tam (+ adj. / adv.)', francais: 'si, aussi, tellement (+ adj. / adv.)', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils', etymologie: 'ESP. tan'),
  Vocabulaire(latin: 'Ubi ?', francais: 'Où ? (sans mouvement)', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'etiam (réponse)', francais: 'oui', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'fortasse', francais: 'peut-être', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'ita / sic (réponse)', francais: 'c\'est ainsi, oui', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'minime', francais: 'pas du tout', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'nimirum', francais: 'sans doute', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'profecto / sane', francais: 'assurément / vraiment', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'vero / enimvero', francais: 'oui, tout à fait', unite: 'Vol. I – Unité 4', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. I – UNITÉ 5
  // ==========================================================

  Vocabulaire(latin: 'dubium, i, n.', francais: 'doute ; hésitation', unite: 'Vol. I – Unité 5', categorie: 'Noms', etymologie: 'dubitatif / ANGL. doubt'),
  Vocabulaire(latin: 'ingenium, i, n.', francais: '1. tempérament, caractère 2. dispositions intellectuelles, intelligence 3. talent, génie', unite: 'Vol. I – Unité 5', categorie: 'Noms', etymologie: 'génie, ingénieur, ingénieux / ANGL. engin'),
  Vocabulaire(latin: 'periculum, i, n.', francais: 'danger, péril', unite: 'Vol. I – Unité 5', categorie: 'Noms', etymologie: 'IT. pericolo / ESP. peligro / PORT. perigo'),

  Vocabulaire(latin: 'ceteri, ae, a', francais: 'tous les autres', unite: 'Vol. I – Unité 5', categorie: 'Adjectifs', etymologie: 'etc. = et cetera'),
  Vocabulaire(latin: 'egregius, a, um', francais: 'remarquable', unite: 'Vol. I – Unité 5', categorie: 'Adjectifs', etymologie: '< e(x) + grex, gregis, m. (troupeau)'),
  Vocabulaire(latin: 'fessus, a, um (+ abl.)', francais: 'fatigué (par / de)', unite: 'Vol. I – Unité 5', categorie: 'Adjectifs', etymologie: 'IT. fesso (nigaud)'),
  Vocabulaire(latin: 'superbus, a, um', francais: 'orgueilleux', unite: 'Vol. I – Unité 5', categorie: 'Adjectifs', etymologie: 'superbe (f.)'),

  Vocabulaire(latin: 'credo, is, ere, credidi, creditum ; credere + dat.', francais: 'croire ; faire confiance à', unite: 'Vol. I – Unité 5', categorie: 'Verbes', etymologie: 'credo, crédible, décrédibiliser, carte de crédit'),
  Vocabulaire(latin: 'defendo, is, ere, defendi, defensum (a(b) + abl.)', francais: 'défendre (contre)', unite: 'Vol. I – Unité 5', categorie: 'Verbes', etymologie: 'ESP. et PORT. defender / ANGL. to defend / IT. difendere'),
  Vocabulaire(latin: 'dico, is, ere, dixi, dictum', francais: 'dire', unite: 'Vol. I – Unité 5', categorie: 'Verbes', etymologie: 'diction'),
  Vocabulaire(latin: 'dormio, is, ire, dormivi, dormitum', francais: 'dormir', unite: 'Vol. I – Unité 5', categorie: 'Verbes'),
  Vocabulaire(latin: 'duco, is, ere, duxi, ductum', francais: 'conduire, mener, diriger', unite: 'Vol. I – Unité 5', categorie: 'Verbes', etymologie: 'duc, grand-duc'),
  Vocabulaire(latin: 'ejicio, is, ere, ejeci, ejectum (ex + abl.)', francais: 'jeter (hors de), chasser (de)', unite: 'Vol. I – Unité 5', categorie: 'Verbes', etymologie: 'éjecter, siège éjectable / ANGL. to eject'),
  Vocabulaire(latin: 'jubeo, es, ere, jussi, jussum ; jubere + ACI', francais: 'ordonner ; ordonner que / à qqn de', unite: 'Vol. I – Unité 5', categorie: 'Verbes'),
  Vocabulaire(latin: 'narro, as, are, avi, atum', francais: 'raconter', unite: 'Vol. I – Unité 5', categorie: 'Verbes', etymologie: 'narrateur, narration, narratif'),
  Vocabulaire(latin: 'nescio, is, ire, nescivi, nescitum', francais: 'ne pas savoir, ignorer', unite: 'Vol. I – Unité 5', categorie: 'Verbes'),
  Vocabulaire(latin: 'peto, is, ere, petivi, petitum ; petere + acc. / a(b) + abl.', francais: '1. gagner, se diriger vers 2. chercher à obtenir, briguer ; demander qqch. / à qqn', unite: 'Vol. I – Unité 5', categorie: 'Verbes', etymologie: 'pétition, pétitionnaire, compétition'),
  Vocabulaire(latin: 'procedo, is, ere, processi, processum', francais: 's\'avancer', unite: 'Vol. I – Unité 5', categorie: 'Verbes', etymologie: 'procéder, procédure / IT. procedere'),
  Vocabulaire(latin: 'puto, as, are, avi, atum ; putare de + abl.', francais: 'penser ; penser à qqch. / qqn', unite: 'Vol. I – Unité 5', categorie: 'Verbes', etymologie: 'député / ANGL. computer'),
  Vocabulaire(latin: 'scio, is, ire, sci(v)i, scitum', francais: 'savoir', unite: 'Vol. I – Unité 5', categorie: 'Verbes', etymologie: 'science, scientifique'),
  Vocabulaire(latin: 'sentio, is, ire, sensi, sensum ; sentire + ACI', francais: '1. sentir, percevoir 2. se rendre compte que, penser que', unite: 'Vol. I – Unité 5', categorie: 'Verbes', etymologie: 'ressentir, sentiment / IT. sentire / ESP. et PORT. sentir'),
  Vocabulaire(latin: 'vinco, is, ere, vici, victum', francais: 'vaincre', unite: 'Vol. I – Unité 5', categorie: 'Verbes', etymologie: 'invincible / Veni, vidi, vici'),

  Vocabulaire(latin: 'clam', francais: 'en cachette', unite: 'Vol. I – Unité 5', categorie: 'Adverbes', etymologie: 'ALL. klammheimlich'),
  Vocabulaire(latin: 'facile', francais: 'facilement', unite: 'Vol. I – Unité 5', categorie: 'Adverbes', etymologie: 'facilité / ROUM. facilita'),
  Vocabulaire(latin: 'feliciter', francais: 'heureusement', unite: 'Vol. I – Unité 5', categorie: 'Adverbes', etymologie: '< felix, felicis / féliciter, félicitation'),
  Vocabulaire(latin: 'statim', francais: 'aussitôt, sur-le-champ', unite: 'Vol. I – Unité 5', categorie: 'Adverbes', etymologie: '< stare + suffixe -tim'),

  // ==========================================================
  // VOL. I – UNITÉ 6
  // ==========================================================

  Vocabulaire(latin: 'amica, ae, f.', francais: 'amie', unite: 'Vol. I – Unité 6', categorie: 'Noms', etymologie: 'IT. amica / PORT. et ESP. amiga'),
  Vocabulaire(latin: 'amicitia, ae, f.', francais: 'amitié', unite: 'Vol. I – Unité 6', categorie: 'Noms', etymologie: 'IT. amicizia / ROUM. amicitie'),
  Vocabulaire(latin: 'concilium, i, n. (concilium armatum)', francais: 'réunion, assemblée (réunion armée)', unite: 'Vol. I – Unité 6', categorie: 'Noms', etymologie: 'concile / PORT. concilio / ROUM. conciliu / ESP. concilio'),
  Vocabulaire(latin: 'lacrima, ae, f.', francais: 'larme', unite: 'Vol. I – Unité 6', categorie: 'Noms', etymologie: 'canal lacrymal, lacrymogène / IT. lacrima / ESP. et PORT. lagrima'),
  Vocabulaire(latin: 'memoria, ae, f.', francais: '1. mémoire 2. souvenir', unite: 'Vol. I – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'modus, i, m.', francais: '1. mesure 2. manière, façon, sorte', unite: 'Vol. I – Unité 6', categorie: 'Noms', etymologie: 'mode, modalité'),
  Vocabulaire(latin: 'odium, i, n.', francais: 'haine (f.), aversion', unite: 'Vol. I – Unité 6', categorie: 'Noms', etymologie: 'odieux / IT., ESP. et PORT. odio'),
  Vocabulaire(latin: 'officium, i, n. (in officio manere)', francais: '1. service rendu 2. devoir, fonction (rester dans le devoir)', unite: 'Vol. I – Unité 6', categorie: 'Noms', etymologie: 'office, officiel'),

  Vocabulaire(latin: 'pauci, ae, a', francais: 'peu nombreux, peu de', unite: 'Vol. I – Unité 6', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'probus, a, um', francais: 'honnête, vertueux, intègre, loyal', unite: 'Vol. I – Unité 6', categorie: 'Adjectifs', etymologie: 'probe, probité / ANGL. probe / IT. probo'),
  Vocabulaire(latin: 'saevus, a, um', francais: 'cruel', unite: 'Vol. I – Unité 6', categorie: 'Adjectifs'),

  Vocabulaire(latin: 'cogo, is, ere, coegi, coactum', francais: '1. rassembler, réunir 2. obliger de / à, forcer de / à', unite: 'Vol. I – Unité 6', categorie: 'Verbes', etymologie: '< cum + agere / ESP. coger'),
  Vocabulaire(latin: 'convenio, is, ire, -veni, -ventum (quo ?)', francais: 'venir ensemble, se rassembler, affluer', unite: 'Vol. I – Unité 6', categorie: 'Verbes', etymologie: 'ALL. Konveniat'),
  Vocabulaire(latin: 'incipio, is, ere, incepi / coepi, inceptum / coeptum', francais: 'commencer, engager', unite: 'Vol. I – Unité 6', categorie: 'Verbes', etymologie: 'un incipit / ANGL. inception'),
  Vocabulaire(latin: 'judico, as, are, avi, atum (aliquem hostem judicare)', francais: '1. dire le droit 2. juger, condamner 3. déclarer qqn ennemi public', unite: 'Vol. I – Unité 6', categorie: 'Verbes', etymologie: '< jus + dicere / ESP. juzgar / ANGL. to judge / IT. giudicare'),
  Vocabulaire(latin: 'necesse est (+ dat.) + inf. / + ACI', francais: 'il est nécessaire (à qqn) de / que', unite: 'Vol. I – Unité 6', categorie: 'Verbes', etymologie: 'ESP. es necesario / IT. è necessario'),
  Vocabulaire(latin: 'oppugno, as, are, avi, atum', francais: 'attaquer (une ville), assiéger', unite: 'Vol. I – Unité 6', categorie: 'Verbes', etymologie: '< ob + pugnare'),
  Vocabulaire(latin: 'ostendo, is, ere, ostendi, ostentum (+ acc.)', francais: 'montrer ; faire preuve (de)', unite: 'Vol. I – Unité 6', categorie: 'Verbes', etymologie: 'ostensible, ostentatoire'),
  Vocabulaire(latin: 'pertineo, es, ere, pertinui, pertentum (ad + acc.)', francais: '1. toucher (à), s\'étendre 2. appartenir (à) 3. concerner', unite: 'Vol. I – Unité 6', categorie: 'Verbes', etymologie: '< per + tenere / ESP. pertenecer'),
  Vocabulaire(latin: 'taceo, es, ere, tacui, tacitum (+ acc.)', francais: '1. taire (qqch.) 2. se taire, garder le silence', unite: 'Vol. I – Unité 6', categorie: 'Verbes', etymologie: 'tacite, taciturne'),
  Vocabulaire(latin: 'teneo, es, ere, tenui, tentum', francais: '1. tenir 2. détenir 3. maintenir 4. retenir 5. garder qqch. en mémoire', unite: 'Vol. I – Unité 6', categorie: 'Verbes', etymologie: 'IT. tenere / ESP. tener / PORT. ter'),
  Vocabulaire(latin: 'terreo, es, ere, terrui, territum', francais: 'effrayer, terrifier', unite: 'Vol. I – Unité 6', categorie: 'Verbes', etymologie: 'terreur / IT. terrorizzare'),
  Vocabulaire(latin: 'trado, is, ere, tradidi, traditum ; se tradere', francais: '1. transmettre, rapporter 2. confier 3. livrer 4. se livrer', unite: 'Vol. I – Unité 6', categorie: 'Verbes', etymologie: 'tradition, traditionnel / ANGL. to trade'),

  Vocabulaire(latin: 'a(b) + abl. (compl. du passif)', francais: 'par / de', unite: 'Vol. I – Unité 6', categorie: 'Prépositions'),
  Vocabulaire(latin: 'haud procul a(b) + abl.', francais: 'non loin de, à proximité de', unite: 'Vol. I – Unité 6', categorie: 'Prépositions'),
  Vocabulaire(latin: 'procul a(b) + abl.', francais: 'loin de', unite: 'Vol. I – Unité 6', categorie: 'Prépositions'),

  Vocabulaire(latin: 'aliquando', francais: '1. un jour 2. quelquefois, parfois', unite: 'Vol. I – Unité 6', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'interea, interim', francais: 'pendant ce temps', unite: 'Vol. I – Unité 6', categorie: 'Mots-outils', etymologie: 'intérimaire'),
  Vocabulaire(latin: 'non tantum ... sed etiam ...', francais: 'non seulement ... mais aussi / encore', unite: 'Vol. I – Unité 6', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'ut, sicut, velut', francais: 'comme, de même que, ainsi que', unite: 'Vol. I – Unité 6', categorie: 'Mots-outils', etymologie: 'ut mos est'),
  Vocabulaire(latin: 'vero', francais: 'mais, quant à', unite: 'Vol. I – Unité 6', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. I – UNITÉ 7
  // ==========================================================

  Vocabulaire(latin: 'animal, alis, n.', francais: 'être vivant ; animal', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'animalier / ROUM., ESP., ANGL. et PORT. animal / IT. animale'),
  Vocabulaire(latin: 'canis, is, m.', francais: 'chien', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'canicule / IT. cane / ROUM. câine'),
  Vocabulaire(latin: 'caput, itis, n.', francais: '1. tête 2. capitale', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'capitaine, caporal, chef / IT. capo / PORT. et ESP. cabo'),
  Vocabulaire(latin: 'civis, is, m.', francais: 'citoyen', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'civisme, civilité, civil'),
  Vocabulaire(latin: 'civitas, atis, f.', francais: '1. cité, État 2. droit de cité', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: '< civis / ESP. ciudad / ANGL. city / IT. città'),
  Vocabulaire(latin: 'consul, is, m.', francais: 'consul', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'consulat, consulaire / ROUM. consul / ESP. cónsul / PORT. cônsul / IT. console'),
  Vocabulaire(latin: 'corpus, oris, n.', francais: 'corps', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'corporel, incorporer / ALL. Körper / PORT. et IT. corpo / ESP. cuerpo / ROUM. corp'),
  Vocabulaire(latin: 'dux, ducis, m.', francais: '1. conducteur, guide 2. chef, général', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'duc, grand-duc, conducteur, adducteur / IT. duce'),
  Vocabulaire(latin: 'eques, equitis, m.', francais: '1. cavalier 2. chevalier', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'équestre, équitation'),
  Vocabulaire(latin: 'finis, is, m. (fines, ium, m. pl.)', francais: 'limite, fin (frontières, le territoire)', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'finir, final, finalité / IT. fine / ESP. fin / PORT. fim'),
  Vocabulaire(latin: 'flumen, inis, n.', francais: 'fleuve, rivière', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'IT. fiume / Tiber flumen'),
  Vocabulaire(latin: 'frater, fratris, m.', francais: 'frère', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'fraternel, fraternité / IT. fratello / ROUM. frate'),
  Vocabulaire(latin: 'fuga, ae, f.', francais: 'fuite', unite: 'Vol. I – Unité 7', categorie: 'Noms'),
  Vocabulaire(latin: 'genus, generis, n.', francais: 'genre', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'génération, généralité / ESP. género / IT. genere'),
  Vocabulaire(latin: 'homo, hominis, m.', francais: 'homme', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'homo erectus, homo sapiens / ESP. hombre / PORT. homen / IT. uomo / ROUM. om'),
  Vocabulaire(latin: 'hostis, is, m.', francais: 'ennemi (de guerre), ennemi public', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'hostile, hostilité / ANGL. hostile'),
  Vocabulaire(latin: 'imperator, oris, m.', francais: '1. celui qui commande, chef 2. général 3. empereur', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: '< impero / IT. imperatore / ANGL. emperor / ESP. emperador / ROUM. împarât'),
  Vocabulaire(latin: 'iter, itineris, n. ; iter facere (per + acc.)', francais: '1. route, chemin 2. marche 3. trajet 4. étape ; faire route (à travers)', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'itinéraire / ESP. itinerario / PORT. itinerário / ANGL. itinerary'),
  Vocabulaire(latin: 'juvenis, is, m.', francais: 'jeune homme', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'juvénile, jouvence / ESP. joven / PORT. jovem / IT. giovane'),
  Vocabulaire(latin: 'legio, onis, f.', francais: 'légion, corps de troupe', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: '< lego / légionnaire / IT. legione / ESP. legión'),
  Vocabulaire(latin: 'liber, libri, m.', francais: 'livre', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'libraire, librairie / ESP. et IT. libro / PORT. livro'),
  Vocabulaire(latin: 'mare, maris, n.', francais: 'mer', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'marée, maritime, marin / IT. et ROUM. mare / PORT. et ESP. mar'),
  Vocabulaire(latin: 'mater, matris, f.', francais: 'mère', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'maternité, matrone, maternelle, matricide / ESP. madre'),
  Vocabulaire(latin: 'miles, itis, m.', francais: 'soldat (en particulier d\'infanterie)', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'militaire, militer, milice / ESP. et PORT. militar'),
  Vocabulaire(latin: 'navis, is, f.', francais: 'navire, bateau', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'navigation, naval / PORT. navio / ESP. nave'),
  Vocabulaire(latin: 'pater, patris, m. (Patres, Patrum, m. pl.)', francais: 'père (sénateurs)', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'paternité, paternel, parricide / ESP. padre'),
  Vocabulaire(latin: 'rex, regis, m.', francais: 'roi', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'ESP. rex / PORT. rei / ROUM. rege'),
  Vocabulaire(latin: 'scelus, sceleris, n.', francais: 'crime', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'scélérat'),
  Vocabulaire(latin: 'senex, senis, m.', francais: 'vieillard', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'sénile, senior, sénat, sénateur'),
  Vocabulaire(latin: 'soror, oris, f.', francais: 'sœur', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'IT. sorella / ROUM. sora'),
  Vocabulaire(latin: 'telum, i, n.', francais: 'javelot, trait', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'tela fortunae'),
  Vocabulaire(latin: 'urbs, urbis, f. (Vrbs, Vrbis = Rome)', francais: 'ville (la Ville = Rome)', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'urbanisme, urbain / Urbi et orbi'),
  Vocabulaire(latin: 'virtus, utis, f.', francais: '1. vertu 2. courage', unite: 'Vol. I – Unité 7', categorie: 'Noms', etymologie: 'vertueux / ANGL. virtue / ESP. virtud / PORT. virtude'),
  Vocabulaire(latin: 'vis, /, f. (vires, virium, f. pl.)', francais: 'force, violence (les forces)', unite: 'Vol. I – Unité 7', categorie: 'Noms'),

  Vocabulaire(latin: 'omnia, omnium (n. pl.)', francais: '= cuncta, cunctorum', unite: 'Vol. I – Unité 7', categorie: 'Adjectifs', etymologie: 'omnibus, omnivore, omniscient, omniprésent'),
  Vocabulaire(latin: 'optimus, a, um', francais: 'très bon, le meilleur', unite: 'Vol. I – Unité 7', categorie: 'Adjectifs', etymologie: 'optimal, optimiser, optimiste / ESP. óptimo / PORT. ótimo'),

  Vocabulaire(latin: 'rego, is, ere, rexi, rectum', francais: 'diriger, gouverner', unite: 'Vol. I – Unité 7', categorie: 'Verbes', etymologie: 'régir, recteur'),
  Vocabulaire(latin: 'scribo, is, ere, scripsi, scriptum', francais: 'écrire', unite: 'Vol. I – Unité 7', categorie: 'Verbes', etymologie: 'scribe (ALL. Schreiber) / ANGL. script'),

  Vocabulaire(latin: 'cum / ut / ubi + ind.', francais: 'quand, lorsque', unite: 'Vol. I – Unité 7', categorie: 'Mots-outils', etymologie: 'Cum tacent, clamant.'),
  Vocabulaire(latin: 'postquam + ind. parfait', francais: 'après que + antériorité', unite: 'Vol. I – Unité 7', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'sic', francais: 'ainsi (= ita)', unite: 'Vol. I – Unité 7', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'subito', francais: 'soudain', unite: 'Vol. I – Unité 7', categorie: 'Mots-outils', etymologie: 'subitement / IT. subito'),

  Vocabulaire(latin: 'Apollo, Apollinis, m.', francais: 'Apollon — dieu de la clarté solaire et des arts', unite: 'Vol. I – Unité 7', categorie: 'Divinités romaines'),
  Vocabulaire(latin: 'Bacchus, i, m.', francais: 'Bacchus — dieu du vin et du délire de l\'ivresse', unite: 'Vol. I – Unité 7', categorie: 'Divinités romaines'),
  Vocabulaire(latin: 'Ceres, Cereris, f.', francais: 'Cérès — déesse de l\'agriculture et de la fertilité', unite: 'Vol. I – Unité 7', categorie: 'Divinités romaines'),
  Vocabulaire(latin: 'Diana, ae, f.', francais: 'Diane — déesse de la clarté lunaire et de la chasse', unite: 'Vol. I – Unité 7', categorie: 'Divinités romaines'),
  Vocabulaire(latin: 'Juno, Junonis, f.', francais: 'Junon — épouse de Jupiter, reine des dieux, déesse du mariage', unite: 'Vol. I – Unité 7', categorie: 'Divinités romaines'),
  Vocabulaire(latin: 'Juppiter, Jovis, m.', francais: 'Jupiter — maître des dieux et de l\'Univers', unite: 'Vol. I – Unité 7', categorie: 'Divinités romaines'),
  Vocabulaire(latin: 'Mars, Martis, m.', francais: 'Mars — dieu de la guerre, dieu protecteur de Rome', unite: 'Vol. I – Unité 7', categorie: 'Divinités romaines'),
  Vocabulaire(latin: 'Mercurius, i, m.', francais: 'Mercure — messager des dieux, dieu du commerce, des voyages et des brigands', unite: 'Vol. I – Unité 7', categorie: 'Divinités romaines'),
  Vocabulaire(latin: 'Minerva, ae, f.', francais: 'Minerve — déesse de la sagesse, de la raison, de la guerre stratégique et des métiers', unite: 'Vol. I – Unité 7', categorie: 'Divinités romaines'),
  Vocabulaire(latin: 'Neptunus, i, m.', francais: 'Neptune — frère de Jupiter et de Pluton, dieu des mers', unite: 'Vol. I – Unité 7', categorie: 'Divinités romaines'),
  Vocabulaire(latin: 'Pluto, Plutonis, m.', francais: 'Pluton — dieu des Enfers et du royaume des morts', unite: 'Vol. I – Unité 7', categorie: 'Divinités romaines'),
  Vocabulaire(latin: 'Quirinus, i, m.', francais: 'Quirinus — dieu romain primitif, assimilé plus tard à Romulus', unite: 'Vol. I – Unité 7', categorie: 'Divinités romaines'),
  Vocabulaire(latin: 'Venus, Veneris, f.', francais: 'Vénus — déesse de la beauté et de l\'amour', unite: 'Vol. I – Unité 7', categorie: 'Divinités romaines'),
  Vocabulaire(latin: 'Vulcanus, i, m.', francais: 'Vulcain — dieu du feu et de la forge', unite: 'Vol. I – Unité 7', categorie: 'Divinités romaines'),

  // ==========================================================
  // VOL. I – UNITÉ 8
  // ==========================================================

  Vocabulaire(latin: 'caedes, is, f.', francais: 'meurtre, massacre', unite: 'Vol. I – Unité 8', categorie: 'Noms', etymologie: '< caedo (abattre) / homicide'),
  Vocabulaire(latin: 'Caesar, Caesaris, m.', francais: 'César', unite: 'Vol. I – Unité 8', categorie: 'Noms', etymologie: 'ALL. Kaiser, Tsar'),
  Vocabulaire(latin: 'clamor, oris, m.', francais: 'cri, clameur (f.)', unite: 'Vol. I – Unité 8', categorie: 'Noms', etymologie: 'clamer, réclamation, acclamation / ANGL. clamour'),
  Vocabulaire(latin: 'cohors, cohortis, f.', francais: 'cohorte (1/10 d\'une légion)', unite: 'Vol. I – Unité 8', categorie: 'Noms', etymologie: 'ANGL. cohort / ESP. cohorte / ROUM. cohorta / PORT. coorte'),
  Vocabulaire(latin: 'imperium, i, n. (in imperio esse)', francais: '1. autorité, pouvoir 2. domination 3. empire (être au pouvoir militaire)', unite: 'Vol. I – Unité 8', categorie: 'Noms', etymologie: 'impérial, empire, impérialisme / PORT. império / ESP. imperio / IT. impero'),
  Vocabulaire(latin: 'numerus, i, m.', francais: 'nombre', unite: 'Vol. I – Unité 8', categorie: 'Noms', etymologie: 'numéro, numéral / ESP. et PORT. número / IT. numero'),
  Vocabulaire(latin: 'pax, pacis, f. (in bello ... in pace ...)', francais: 'paix (en temps de guerre ... en temps de paix ...)', unite: 'Vol. I – Unité 8', categorie: 'Noms', etymologie: 'pacifier, pacifique / Si vis pacem, para bellum.'),
  Vocabulaire(latin: 'pecunia, ae, f. (magna pecunia)', francais: '1. argent 2. richesse, patrimoine (grande somme d\'argent)', unite: 'Vol. I – Unité 8', categorie: 'Noms', etymologie: 'pécunier, pécuniaire / IT. et ESP. pecuniario'),
  Vocabulaire(latin: 'plebs, plebis, f.', francais: 'plèbe', unite: 'Vol. I – Unité 8', categorie: 'Noms', etymologie: 'plébiscite(r)'),
  Vocabulaire(latin: 'plebis tribunus, i, m.', francais: 'tribun de la plèbe', unite: 'Vol. I – Unité 8', categorie: 'Noms', etymologie: 'tribune, tribunale'),
  Vocabulaire(latin: 'pons, pontis, m.', francais: 'pont', unite: 'Vol. I – Unité 8', categorie: 'Noms', etymologie: 'PORT. et IT. ponte / ESP. puente'),
  Vocabulaire(latin: 'signum, i, n.', francais: '1. signe, signal 2. enseigne militaire 3. statue', unite: 'Vol. I – Unité 8', categorie: 'Noms', etymologie: 'signalisation / PORT. et ESP. signo / IT. segno / ANGL. sign'),
  Vocabulaire(latin: 'tempus, oris, n.', francais: '1. temps, époque, moment, instant 2. circonstance', unite: 'Vol. I – Unité 8', categorie: 'Noms', etymologie: 'temporel, temporiser / IT. et PORT. tempo / ESP. tiempo'),
  Vocabulaire(latin: 'victor, oris, m.', francais: 'vainqueur, gagnant', unite: 'Vol. I – Unité 8', categorie: 'Noms', etymologie: 'victorieux, victoire / invictus, a, um'),

  Vocabulaire(latin: 'acer, acris, acre', francais: '1. vif 2. ardent 3. dur 4. acharné', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: 'acerbe, acrimonie'),
  Vocabulaire(latin: 'audax, audacis', francais: 'audacieux, hardi', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: 'audace / ESP. audaz / IT. audace / PORT. audacioso'),
  Vocabulaire(latin: 'difficilis, e', francais: 'difficile', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'dissimilis, e', francais: 'dissemblable, différent', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: '< dis + similis / dissimilitude'),
  Vocabulaire(latin: 'dives, itis', francais: 'riche', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'facilis, e', francais: 'facile', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'felix, felicis', francais: 'chanceux, heureux', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: 'féliciter, félicitation / ESP. et PORT. feliz / IT. felice'),
  Vocabulaire(latin: 'ferox, ferocis', francais: 'farouche, fougueux, intrépide', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: 'féroce, férocité / ESP. et PORT. feroz / IT. feroce'),
  Vocabulaire(latin: 'fidelis, e', francais: 'en qui l\'on peut avoir confiance, sûr, loyal, fidèle', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: 'IT. fedele / ROUM. fidel / ESP. et PORT. fiel / semper fi(delis)'),
  Vocabulaire(latin: 'fortis, e', francais: 'courageux', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: 'fort, effort / IT. forte'),
  Vocabulaire(latin: 'gravis, e', francais: '1. lourd 2. grave, sérieux 3. pénible', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: 'aggraver / ESP., IT. et PORT. grave / ROUM. grav'),
  Vocabulaire(latin: 'humilis, e', francais: 'humble', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'ingens, tis', francais: 'énorme, immense', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'jucundus, a, um', francais: 'agréable', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: 'la Joconde / IT. giocondo'),
  Vocabulaire(latin: 'nobilis, e', francais: 'noble', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: 'anoblir, noblesse / ESP. noble / IT. nobile / PORT. nobre'),
  Vocabulaire(latin: 'omnis, e (omnia n. pl.)', francais: 'tout ; chaque (toutes les choses, tout)', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: 'omnibus, omnivore, omniscient, omniprésent'),
  Vocabulaire(latin: 'pauper, eris', francais: 'pauvre', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: 'paupériser, paupérisme'),
  Vocabulaire(latin: 'princeps, ipis', francais: 'premier, qui occupe le premier rang', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: 'principal, principe'),
  Vocabulaire(latin: 'prudens, tis', francais: 'prévoyant, prudent, sage, avisé', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: 'ESP., IT. et PORT. prudente / ROUM. prudent'),
  Vocabulaire(latin: 'secundus, a, um', francais: 'deuxième ; favorable', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: 'second(e), secondaire / PORT. et ESP. segundo / IT. secondo'),
  Vocabulaire(latin: 'similis, e', francais: 'semblable', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: 'similitude'),
  Vocabulaire(latin: 'vetus, eris', francais: 'vieux', unite: 'Vol. I – Unité 8', categorie: 'Adjectifs', etymologie: 'vétéran'),

  Vocabulaire(latin: 'accipio, is, ere, accepi, acceptum', francais: '1. accueillir 2. recevoir qqch. de qqn 3. apprendre qqch. de qqn', unite: 'Vol. I – Unité 8', categorie: 'Verbes', etymologie: 'PORT. acolher / ESP. acoger / IT. accogliere'),
  Vocabulaire(latin: 'ambulo, as, are, avi, atum', francais: 'aller et venir, marcher, se promener', unite: 'Vol. I – Unité 8', categorie: 'Verbes', etymologie: 'déambuler, ambulance, préambule / IT. deambulare / ESP. et PORT. deambular'),
  Vocabulaire(latin: 'committo, is, ere, commisi, commissum', francais: '1. confier 2. engager [proelium] 3. commettre [scelus]', unite: 'Vol. I – Unité 8', categorie: 'Verbes', etymologie: 'commission / ANGL. to commit / ESP. cometer / IT. commettere'),
  Vocabulaire(latin: 'delecto, as, are, avi, atum (+ acc.)', francais: 'charmer (qqn), plaire (à qqn)', unite: 'Vol. I – Unité 8', categorie: 'Verbes', etymologie: 'se délecter, délectation'),
  Vocabulaire(latin: 'facere + 2 acc.', francais: 'faire qqn / qqch. de qqn / qqch. → rendre qqn / qqch. qqn / qqch.', unite: 'Vol. I – Unité 8', categorie: 'Verbes', etymologie: 'défaire, refaire / IT. fare / PORT. fazer / ESP. hacer'),
  Vocabulaire(latin: 'impero, as, are, avi, atum (+ acc. / + dat.)', francais: 'ordonner, imposer (qqch. / à qqn)', unite: 'Vol. I – Unité 8', categorie: 'Verbes', etymologie: 'imperator, imperium'),
  Vocabulaire(latin: 'premo, is, ere, pressi, pressum', francais: '1. (presser) serrer de près 2. accabler', unite: 'Vol. I – Unité 8', categorie: 'Verbes', etymologie: 'presser, pression, exprimer, imprimer / IT. premere'),

  Vocabulaire(latin: 'trans + acc.', francais: 'au-delà de, de l\'autre côté de', unite: 'Vol. I – Unité 8', categorie: 'Prépositions', etymologie: 'transalpin, transatlantique, transport'),

  Vocabulaire(latin: 'et [adverbial]', francais: 'aussi, également (= etiam)', unite: 'Vol. I – Unité 8', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'iterum', francais: 'de nouveau, à nouveau ; pour la 2e fois', unite: 'Vol. I – Unité 8', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'minus', francais: 'moins', unite: 'Vol. I – Unité 8', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'minus (+ adj./adv.) quam', francais: 'moins (+ adj./adv.) que', unite: 'Vol. I – Unité 8', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'paulo post / ante ; paulum', francais: '(un) peu après / auparavant ; (un) peu', unite: 'Vol. I – Unité 8', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'rursus, rursum', francais: 'de nouveau', unite: 'Vol. I – Unité 8', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'tam (+ adj./adv.) quam', francais: 'aussi (+ adj./adv.) que', unite: 'Vol. I – Unité 8', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. I – UNITÉ 9
  // ==========================================================

  Vocabulaire(latin: 'ars, artis, f.', francais: '1. le talent, le savoir-faire 2. la science, l\'art 3. le moyen', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: 'artiste, artisanal / ESP., IT. et PORT. arte'),
  Vocabulaire(latin: 'emporium, i, n.', francais: 'marché, place de commerce, entrepôt', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: 'ESP. emporio / ANGL. emporium'),
  Vocabulaire(latin: 'exempli gratia', francais: 'par exemple', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: 'e.g. (abréviation)'),
  Vocabulaire(latin: 'fabula, ae, f.', francais: '(ici) pièce de théâtre ; récit, mythe, fable', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: 'fable, affabuler, fabuleux'),
  Vocabulaire(latin: 'fons, fontis, m.', francais: 'source, fontaine', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: '< fundere (verser) / Ad fontes ! / ESP. fuente / PORT. fonte / IT. fonte, fontana'),
  Vocabulaire(latin: 'forma, ae, f.', francais: '1. forme 2. beauté', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: 'ESP., IT. et PORT. forma / ROUM. formă'),
  Vocabulaire(latin: 'gladius, i, m.', francais: 'glaive (m.), épée (f.)', unite: 'Vol. I – Unité 9', categorie: 'Noms'),
  Vocabulaire(latin: 'libertus, i, m.', francais: '(esclave) affranchi', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: 'libertin, libertinage'),
  Vocabulaire(latin: 'littera, ae, f. (litterae, arum, f. pl.)', francais: 'lettre (de l\'alphabet) ; les lettres, la lettre (missive), littérature, culture', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: 'littéral, littéraire'),
  Vocabulaire(latin: 'litus, oris, n.', francais: 'côte, rivage, plage', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: 'littoral'),
  Vocabulaire(latin: 'mercator, oris, m.', francais: 'marchand', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: 'mercantile / IT. mercato / ESP. et PORT. mercado (marché)'),
  Vocabulaire(latin: 'negotiator, oris, m.', francais: 'négociant, marchand', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: 'négociateur / ANGL. negotiator'),
  Vocabulaire(latin: 'negotium, i, n. (negotium gerere) ≠ otium, i, n.', francais: 'occupation, travail, affaire ; faire des affaires ≠ oisiveté, loisir', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: 'négoce'),
  Vocabulaire(latin: 'nomen, nominis, n.', francais: 'nom, renom', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: 'nomenclature / IT. et PORT. nome / ALL. Nomen'),
  Vocabulaire(latin: 'pars, partis, f.', francais: 'partie', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: 'bipartite, participer / ESP., IT., PORT. et ROUM. parte / ANGL. part'),
  Vocabulaire(latin: 'poeta, ae, m.', francais: 'poète', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: 'IT., ESP. et PORT. poeta'),
  Vocabulaire(latin: 'scriptor, oris, m.', francais: 'celui qui écrit, auteur', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: 'script, scriptural, scriptorium'),
  Vocabulaire(latin: 'studium, i, n.', francais: '1. application, goût 2. ardeur, passion 3. attachement, sympathie 4. l\'étude', unite: 'Vol. I – Unité 9', categorie: 'Noms', etymologie: 'studieux / ALL. Studium, Student / ANGL. study / IT. studio / ESP. estudio / PORT. estudo'),

  Vocabulaire(latin: 'doctus, a, um', francais: 'savant, instruit, docte', unite: 'Vol. I – Unité 9', categorie: 'Adjectifs', etymologie: '< doceo'),
  Vocabulaire(latin: 'ferus, a, um', francais: 'sauvage ; farouche', unite: 'Vol. I – Unité 9', categorie: 'Adjectifs', etymologie: 'féroce / IT. et ESP. fiero'),
  Vocabulaire(latin: 'verus, a, um', francais: 'vrai, véritable', unite: 'Vol. I – Unité 9', categorie: 'Adjectifs'),

  Vocabulaire(latin: 'aedifico, as, are, avi, atum', francais: 'édifier, bâtir, construire un bâtiment', unite: 'Vol. I – Unité 9', categorie: 'Verbes', etymologie: 'édifiant / IT. et ESP. edificar / ROUM. edifica'),
  Vocabulaire(latin: 'animadverto, is, ere, -verti, -versum', francais: 'remarquer', unite: 'Vol. I – Unité 9', categorie: 'Verbes', etymologie: '< animum advertere / animadversion'),
  Vocabulaire(latin: 'cado, is, ere, cecidi, casum ; sub jugum cadere', francais: 'tomber ; tomber sous le joug (domination)', unite: 'Vol. I – Unité 9', categorie: 'Verbes', etymologie: 'cadence, décider, incidence / ROUM. cădea'),
  Vocabulaire(latin: 'cognosco, is, ere, cognovi / novi, cognitum / notum', francais: 'apprendre à connaître', unite: 'Vol. I – Unité 9', categorie: 'Verbes', etymologie: 'connaissance, incognito / ESP. conocer / PORT. conhecer'),
  Vocabulaire(latin: 'conficio, is, ere, -feci, -fectum', francais: '1. faire intégralement, achever 2. venir à bout de qqch., réaliser 3. venir à bout de qqn, faire périr', unite: 'Vol. I – Unité 9', categorie: 'Verbes', etymologie: '< cum + facio / confectionner / ALL. Eiskonfekt'),
  Vocabulaire(latin: 'emo, is, ere, emi, emptum (+ acc. + a(b) + abl.)', francais: 'acheter (qqch. à qqn)', unite: 'Vol. I – Unité 9', categorie: 'Verbes', etymologie: 'bene emere / male emere'),
  Vocabulaire(latin: 'invenio, is, ire, -veni, -ventum', francais: '1. trouver, rencontrer 2. inventer', unite: 'Vol. I – Unité 9', categorie: 'Verbes', etymologie: 'inventeur, invention'),
  Vocabulaire(latin: 'permitto, is, ere, -misi, -missum (+ inf.)', francais: 'permettre (de + inf.)', unite: 'Vol. I – Unité 9', categorie: 'Verbes', etymologie: 'permission / IT. permettere / ESP. et PORT. permitir / ROUM. permit / ANGL. to permit, permission'),
  Vocabulaire(latin: 'tego, is, ere, texi, tectum (a(b) + abl.)', francais: '1. couvrir 2. cacher, abriter 3. garantir, protéger (contre)', unite: 'Vol. I – Unité 9', categorie: 'Verbes', etymologie: 'protéger, protection, toge'),
  Vocabulaire(latin: 'vendo, is, ere, vendidi, venditum', francais: 'vendre', unite: 'Vol. I – Unité 9', categorie: 'Verbes', etymologie: 'vente, vendeur'),

  Vocabulaire(latin: 'maxime', francais: 'surtout, au plus haut point', unite: 'Vol. I – Unité 9', categorie: 'Mots-outils', etymologie: 'maximum, maximal, maxime (f.)'),
  Vocabulaire(latin: 'olim', francais: '1. autrefois, jadis 2. un jour', unite: 'Vol. I – Unité 9', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'praecipue', francais: 'surtout, avant tout', unite: 'Vol. I – Unité 9', categorie: 'Mots-outils', etymologie: '< prae + capio'),

  // ==========================================================
  // VOL. I – UNITÉ 10
  // ==========================================================

  Vocabulaire(latin: 'agmen, inis, n.', francais: 'armée en marche, colonne, troupe en marche', unite: 'Vol. I – Unité 10', categorie: 'Noms', etymologie: '< agere / primum agmen'),
  Vocabulaire(latin: 'amor, oris, m.', francais: 'amour (m.)', unite: 'Vol. I – Unité 10', categorie: 'Noms', etymologie: 'amoureux, désamour, amourette / ESP. et PORT. amor / IT. amore'),
  Vocabulaire(latin: 'basium, i, n.', francais: 'baiser', unite: 'Vol. I – Unité 10', categorie: 'Noms', etymologie: 'IT. bacio'),
  Vocabulaire(latin: 'cupiditas, atis, f.', francais: '1. passion, convoitise 2. désir', unite: 'Vol. I – Unité 10', categorie: 'Noms', etymologie: 'cupidité, Cupidon'),
  Vocabulaire(latin: 'dextra, ae, f.', francais: 'main droite', unite: 'Vol. I – Unité 10', categorie: 'Noms', etymologie: 'dextérité, ambidextre'),
  Vocabulaire(latin: 'donum, i, n.', francais: 'don, cadeau', unite: 'Vol. I – Unité 10', categorie: 'Noms', etymologie: 'ESP. don / IT. dono / PORT. dom'),
  Vocabulaire(latin: 'lex, legis, f.', francais: 'loi', unite: 'Vol. I – Unité 10', categorie: 'Noms', etymologie: 'légal, légalité, législation / dura lex, sed lex'),
  Vocabulaire(latin: 'libertas, atis, f.', francais: 'liberté', unite: 'Vol. I – Unité 10', categorie: 'Noms'),
  Vocabulaire(latin: 'matrimonium, i, n. (in matrimonium ducere)', francais: 'mariage (prendre pour femme, épouser)', unite: 'Vol. I – Unité 10', categorie: 'Noms', etymologie: 'agence matrimoniale / ESP. et IT. matrimonio'),
  Vocabulaire(latin: 'matrona, ae, f.', francais: 'femme mariée, matrone', unite: 'Vol. I – Unité 10', categorie: 'Noms', etymologie: 'matronyme, matriarcal, matriarcat'),
  Vocabulaire(latin: 'morbus, i, m.', francais: 'maladie', unite: 'Vol. I – Unité 10', categorie: 'Noms', etymologie: 'morbide, morbidité / IT. morbo / ROUM. morb'),
  Vocabulaire(latin: 'mulier, eris, f.', francais: 'femme', unite: 'Vol. I – Unité 10', categorie: 'Noms', etymologie: 'IT. moglie / PORT. mulher / ESP. mujer'),
  Vocabulaire(latin: 'pietas, atis, f.', francais: 'respect des devoirs envers les dieux, la patrie, la famille ; piété, amour de la patrie, affection', unite: 'Vol. I – Unité 10', categorie: 'Noms', etymologie: 'mont-de-piété / ROUM. pietate'),
  Vocabulaire(latin: 'sapientia, ae, f.', francais: 'sagesse', unite: 'Vol. I – Unité 10', categorie: 'Noms'),
  Vocabulaire(latin: 'uxor, oris, f. (uxorem ducere)', francais: 'femme, épouse (prendre pour femme, épouser)', unite: 'Vol. I – Unité 10', categorie: 'Noms'),
  Vocabulaire(latin: 'vitium, i, n.', francais: 'vice, défaut', unite: 'Vol. I – Unité 10', categorie: 'Noms', etymologie: 'vicieux / ESP. vicio / IT. vizio / PORT. vício'),

  Vocabulaire(latin: 'is, ea, id', francais: 'celui, celle-ci, ceci ; ce(t), cette ; le, la', unite: 'Vol. I – Unité 10', categorie: 'Pronoms-adjectifs'),
  Vocabulaire(latin: 'qui, quae, quod (relatif)', francais: 'qui, que, dont, ...', unite: 'Vol. I – Unité 10', categorie: 'Pronoms-adjectifs'),

  Vocabulaire(latin: 'dexter, dext(e)ra, dext(e)rum', francais: 'droit', unite: 'Vol. I – Unité 10', categorie: 'Adjectifs', etymologie: 'dextérité, ambidextre'),
  Vocabulaire(latin: 'nonnulli, ae, a', francais: 'quelques ; quelques-un(e)s', unite: 'Vol. I – Unité 10', categorie: 'Adjectifs', etymologie: '< non + nulli, ae, a'),
  Vocabulaire(latin: 'privatus, a, um', francais: 'particulier, privé, personnel', unite: 'Vol. I – Unité 10', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'publicus, a, um', francais: '1. officiel, public 2. commun à tous', unite: 'Vol. I – Unité 10', categorie: 'Adjectifs', etymologie: 'publicité, publier, république / ESP. et PORT. público / IT. pubblico'),

  Vocabulaire(latin: 'censeo, es, ere, censui, censum', francais: 'estimer ; juger, être d\'avis', unite: 'Vol. I – Unité 10', categorie: 'Verbes', etymologie: 'censeur, censure, recensement'),
  Vocabulaire(latin: 'cresco, is, ere, crevi, cretum', francais: '1. venir à l\'existence, naître 2. croître, grandir', unite: 'Vol. I – Unité 10', categorie: 'Verbes', etymologie: 'crescendo / PORT. crescer / IT. crescere / ESP. crecer'),
  Vocabulaire(latin: 'deleo, es, ere, evi, etum', francais: 'détruire', unite: 'Vol. I – Unité 10', categorie: 'Verbes', etymologie: 'indélébile / ANGL. to delete'),
  Vocabulaire(latin: 'disco, is, ere, didici (+ acc. / + a(b) + abl.)', francais: 'apprendre, étudier qqch. / de qqn', unite: 'Vol. I – Unité 10', categorie: 'Verbes', etymologie: 'disciple, discipline'),
  Vocabulaire(latin: 'jungo, is, ere, junxi, junctum', francais: 'joindre, lier, unir ; réunir', unite: 'Vol. I – Unité 10', categorie: 'Verbes', etymologie: 'jonction / IT. giungere'),
  Vocabulaire(latin: 'laudo, as, are, avi, atum', francais: 'louer', unite: 'Vol. I – Unité 10', categorie: 'Verbes', etymologie: 'laudatif / ROUM. laudă'),
  Vocabulaire(latin: 'misceo, es, ere, miscui, mixtum', francais: '1. mêler, mélanger 2. agiter, désorganiser, bouleverser', unite: 'Vol. I – Unité 10', categorie: 'Verbes', etymologie: 'promiscuité, immiscible'),
  Vocabulaire(latin: 'reddo, is, ere, reddidi, redditum', francais: 'rendre', unite: 'Vol. I – Unité 10', categorie: 'Verbes', etymologie: '< re + dare'),
  Vocabulaire(latin: 'rideo, es, ere, risi, risum (+ acc.)', francais: '1. rire 2. se moquer (de), se rire (de)', unite: 'Vol. I – Unité 10', categorie: 'Verbes', etymologie: 'ridicule, risible / IT. ridere'),
  Vocabulaire(latin: 'tempto / tento, as, are, avi, atum', francais: '1. tenter, essayer 2. mettre à l\'épreuve', unite: 'Vol. I – Unité 10', categorie: 'Verbes', etymologie: 'tentation, tentative / ANGL. temptation, attempt / IT. tentare / PORT. tentar / ESP. intentar'),

  Vocabulaire(latin: 'cottidie', francais: 'tous les jours, quotidiennement', unite: 'Vol. I – Unité 10', categorie: 'Mots-outils', etymologie: 'quotidien / ROUM. cotidian'),
  Vocabulaire(latin: 'modo', francais: 'seulement', unite: 'Vol. I – Unité 10', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'non modo ... sed etiam ...', francais: '= non tantum ... sed etiam', unite: 'Vol. I – Unité 10', categorie: 'Mots-outils'),
  Vocabulaire(latin: '-ne ... an ... ? / utrum ... an ... ?', francais: 'est-ce que ... ou ... ? (interrogation double)', unite: 'Vol. I – Unité 10', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'qua (adv. rel.)', francais: 'par où', unite: 'Vol. I – Unité 10', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'quo (adv. rel.)', francais: 'où (avec mouvement)', unite: 'Vol. I – Unité 10', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'satis (+ gén.)', francais: 'assez (de), suffisamment (de)', unite: 'Vol. I – Unité 10', categorie: 'Mots-outils', etymologie: 'satisfaisant, satisfaction'),
  Vocabulaire(latin: 'tamen', francais: 'cependant, pourtant', unite: 'Vol. I – Unité 10', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'ubi (adv. rel.)', francais: 'où (sans mouvement)', unite: 'Vol. I – Unité 10', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'unde (adv. rel.)', francais: 'd\'où', unite: 'Vol. I – Unité 10', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. II – UNITÉ 1
  // ==========================================================

  Vocabulaire(latin: 'concordia, ae, f.', francais: 'accord, entente, harmonie', unite: 'Vol. II – Unité 1', categorie: 'Noms', etymologie: '< cum + cor, cordis, n. / concorder'),
  Vocabulaire(latin: 'conjux, conjugis, m. / f.', francais: 'époux, épouse', unite: 'Vol. II – Unité 1', categorie: 'Noms', etymologie: '< conjungere < cum + jungere / conjugal, conjoint'),
  Vocabulaire(latin: 'curia, ae, f.', francais: 'curie (salle où se réunit le sénat)', unite: 'Vol. II – Unité 1', categorie: 'Noms', etymologie: 'curiate'),
  Vocabulaire(latin: 'decus, oris, n.', francais: 'ornement, parure, gloire', unite: 'Vol. II – Unité 1', categorie: 'Noms', etymologie: 'décor(ation), décorer qqn'),
  Vocabulaire(latin: 'gaudium, i, n.', francais: 'contentement, plaisir, joie', unite: 'Vol. II – Unité 1', categorie: 'Noms', etymologie: '< gaudeo'),
  Vocabulaire(latin: 'gens, gentis, f.', francais: '1. famille 2. peuple, nation', unite: 'Vol. II – Unité 1', categorie: 'Noms', etymologie: 'gens, gentilice, gendarme / ESP., IT. et PORT. gente'),
  Vocabulaire(latin: 'laus, laudis, f.', francais: 'éloge (m.), louange (f.)', unite: 'Vol. II – Unité 1', categorie: 'Noms', etymologie: 'laudatif'),
  Vocabulaire(latin: 'mors, mortis, f.', francais: 'la mort', unite: 'Vol. II – Unité 1', categorie: 'Noms', etymologie: 'mortel, mortuaire / IT. et PORT. morte / ESP. muerte / ROUM. moarte'),
  Vocabulaire(latin: 'regina, ae, f.', francais: 'reine', unite: 'Vol. II – Unité 1', categorie: 'Noms', etymologie: 'IT. regina'),
  Vocabulaire(latin: 'sors, tis, f.', francais: '1. sort, tirage au sort 2. prophétie 3. sort, destin', unite: 'Vol. II – Unité 1', categorie: 'Noms', etymologie: 'sortilège / ESP. suerte / IT. et PORT. sorte / ROUM. soartă'),
  Vocabulaire(latin: 'superbia, ae, f.', francais: 'orgueil', unite: 'Vol. II – Unité 1', categorie: 'Noms', etymologie: 'la superbe'),

  Vocabulaire(latin: 'aequalis, e', francais: 'du même âge, contemporain ; semblable', unite: 'Vol. II – Unité 1', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'beatus, a, um', francais: 'heureux', unite: 'Vol. II – Unité 1', categorie: 'Adjectifs', etymologie: 'béatitude, béatifier / ESP. et PORT. beato'),
  Vocabulaire(latin: 'Graecus, a, um', francais: 'grec, de Grèce', unite: 'Vol. II – Unité 1', categorie: 'Adjectifs'),

  Vocabulaire(latin: 'ago, is, ere, egi, actum ; gratias agere ; vitam agere', francais: '1. mener [equos] 2. agir, faire ; = gratiam habere ; mener une vie, passer sa vie', unite: 'Vol. II – Unité 1', categorie: 'Verbes', etymologie: 'actionner, actif, action, agent / ESP. actuar / PORT. agir'),
  Vocabulaire(latin: 'colo, is, ere, colui, cultum', francais: '1. cultiver, s\'occuper de 2. pratiquer 3. honorer, respecter', unite: 'Vol. II – Unité 1', categorie: 'Verbes', etymologie: 'culture, culte, agriculture'),
  Vocabulaire(latin: 'exspecto, as, are, avi, atum', francais: 'attendre', unite: 'Vol. II – Unité 1', categorie: 'Verbes', etymologie: 'expectatif / ANGL. to expect, expectation'),
  Vocabulaire(latin: 'gigno, is, ere, genui, genitum', francais: '1. engendrer 2. mettre au monde 3. créer, faire naître, produire', unite: 'Vol. II – Unité 1', categorie: 'Verbes', etymologie: 'géniteur, appareil génital'),
  Vocabulaire(latin: 'intellego, is, ere, -lexi, -lectum', francais: '1. s\'apercevoir, remarquer 2. comprendre', unite: 'Vol. II – Unité 1', categorie: 'Verbes', etymologie: 'intellectuel, intelligible / ROUM. intelege'),
  Vocabulaire(latin: 'lego, is, ere, legi, lectum', francais: '1. choisir, élire 2. cueillir 3. lire', unite: 'Vol. II – Unité 1', categorie: 'Verbes', etymologie: 'lecture, lecteur, intellectuel / IT. leggere'),
  Vocabulaire(latin: 'moveo, es, ere, movi, motum', francais: '1. mouvoir, déplacer, bouger 2. émouvoir, bouleverser', unite: 'Vol. II – Unité 1', categorie: 'Verbes', etymologie: 'mouvement, mouvance / ESP. mover / IT. muovere / ANGL. to move'),
  Vocabulaire(latin: 'muto, as, are, avi, atum', francais: 'changer, changer de [sententiam]', unite: 'Vol. II – Unité 1', categorie: 'Verbes', etymologie: 'muter, mutant, mutation / PORT. mudar / ROUM. muta'),
  Vocabulaire(latin: 'praebeo, es, ere, ui, itum', francais: 'présenter, offrir, fournir ; faire preuve de (= ostendere)', unite: 'Vol. II – Unité 1', categorie: 'Verbes'),
  Vocabulaire(latin: 'praesto, as, are, -stiti, -statum ; praestare + dat. + abl.', francais: '1. montrer, faire preuve de [virtutem] 2. l\'emporter sur qqn par qqch.', unite: 'Vol. II – Unité 1', categorie: 'Verbes', etymologie: '< prae + sto, as, are / la prestance'),
  Vocabulaire(latin: 'rapio, is, ere, rapui, raptum', francais: 'emporter, enlever', unite: 'Vol. II – Unité 1', categorie: 'Verbes', etymologie: 'le rapt des Sabines'),
  Vocabulaire(latin: 'recuso, as, are, avi, atum (+ inf.)', francais: 'refuser (de)', unite: 'Vol. II – Unité 1', categorie: 'Verbes', etymologie: 'récuser, récusation / PORT. recusar'),
  Vocabulaire(latin: 'servo, as, are, avi, atum', francais: '1. observer [stellas] 2. préserver, conserver, sauver [urbem]', unite: 'Vol. II – Unité 1', categorie: 'Verbes', etymologie: 'IT. servare'),

  Vocabulaire(latin: 'inter + acc.', francais: 'entre, parmi', unite: 'Vol. II – Unité 1', categorie: 'Prépositions', etymologie: 'international, interagir, interclasse'),

  Vocabulaire(latin: 'fere', francais: 'presque', unite: 'Vol. II – Unité 1', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'frustra', francais: 'en vain', unite: 'Vol. II – Unité 1', categorie: 'Mots-outils', etymologie: 'frustrer, frustration'),
  Vocabulaire(latin: 'nisi (+ ind.)', francais: 'si ... ne ... pas', unite: 'Vol. II – Unité 1', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'si (+ ind.)', francais: 'si', unite: 'Vol. II – Unité 1', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'simul ; simul ac / atque', francais: 'en même temps ; en même temps que, aussitôt que, dès que', unite: 'Vol. II – Unité 1', categorie: 'Mots-outils', etymologie: 'simultanément, simultanéité'),
  Vocabulaire(latin: 'tandem', francais: '1. finalement 2. enfin', unite: 'Vol. II – Unité 1', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'una ; una cum (+ abl.)', francais: 'ensemble ; en même temps (que)', unite: 'Vol. II – Unité 1', categorie: 'Mots-outils', etymologie: '< unus, a, um / uni, unifier'),

  // ==========================================================
  // VOL. II – UNITÉ 2
  // ==========================================================

  Vocabulaire(latin: 'aetas, atis, f. (aetatem agere)', francais: '1. âge 2. époque 3. vie, mener sa vie (= vitam agere)', unite: 'Vol. II – Unité 2', categorie: 'Noms', etymologie: 'ROUM. etate / ESP. edad / IT. età'),
  Vocabulaire(latin: 'aestas, atis, f.', francais: 'été', unite: 'Vol. II – Unité 2', categorie: 'Noms', etymologie: 'estival'),
  Vocabulaire(latin: 'Athenae, arum, f. pl.', francais: 'Athènes', unite: 'Vol. II – Unité 2', categorie: 'Noms'),
  Vocabulaire(latin: 'autumnus, i, m.', francais: 'automne', unite: 'Vol. II – Unité 2', categorie: 'Noms', etymologie: 'ANGL. autumn'),
  Vocabulaire(latin: 'Carthago, inis, f.', francais: 'Carthage', unite: 'Vol. II – Unité 2', categorie: 'Noms'),
  Vocabulaire(latin: 'Delphi, orum, m. pl.', francais: 'Delphes', unite: 'Vol. II – Unité 2', categorie: 'Noms'),
  Vocabulaire(latin: 'divitiae, arum, f. pl.', francais: 'ressources, richesses', unite: 'Vol. II – Unité 2', categorie: 'Noms', etymologie: '< dives'),
  Vocabulaire(latin: 'hiems, hiemis, f.', francais: 'hiver', unite: 'Vol. II – Unité 2', categorie: 'Noms', etymologie: 'hiémal (= hivernal)'),
  Vocabulaire(latin: 'hora, ae, f.', francais: 'heure', unite: 'Vol. II – Unité 2', categorie: 'Noms', etymologie: 'horaire / ESP. et PORT. hora / IT. ora / ROUM. oră'),
  Vocabulaire(latin: 'humus, i, f.', francais: 'sol, terre', unite: 'Vol. II – Unité 2', categorie: 'Noms'),
  Vocabulaire(latin: 'incommodum, i, n. ≠ commodum, i, n.', francais: 'désavantage, inconvénient ≠ avantage, intérêt', unite: 'Vol. II – Unité 2', categorie: 'Noms', etymologie: 'incommodité, incommodation / ESP. incomodidad'),
  Vocabulaire(latin: 'insula, ae, f.', francais: '1. île 2. pâté de maisons', unite: 'Vol. II – Unité 2', categorie: 'Noms'),
  Vocabulaire(latin: 'Italia, ae, f.', francais: 'Italie', unite: 'Vol. II – Unité 2', categorie: 'Noms'),
  Vocabulaire(latin: 'Lugdunum, i, n.', francais: 'Lyon', unite: 'Vol. II – Unité 2', categorie: 'Noms'),
  Vocabulaire(latin: 'Lutetia, ae, f.', francais: 'Lutèce (auj. Paris)', unite: 'Vol. II – Unité 2', categorie: 'Noms', etymologie: 'les arènes de Lutèce'),
  Vocabulaire(latin: 'majores, majorum, m. pl.', francais: 'les ancêtres', unite: 'Vol. II – Unité 2', categorie: 'Noms', etymologie: 'majeurs, majorité'),
  Vocabulaire(latin: 'mens, mentis, f. (in mentem venire + dat.)', francais: '1. faculté intellectuelle 2. esprit, pensée 3. disposition d\'esprit 4. manière (venir à l\'esprit de qqn)', unite: 'Vol. II – Unité 2', categorie: 'Noms', etymologie: 'mentalité, mental'),
  Vocabulaire(latin: 'mensis, is, m.', francais: 'mois', unite: 'Vol. II – Unité 2', categorie: 'Noms', etymologie: 'mensuel, mensualité'),
  Vocabulaire(latin: 'mos, moris, m. (mores, morum, m. pl. ; mos est + ACI)', francais: 'coutume, habitude (mœurs ; c\'est la coutume que)', unite: 'Vol. II – Unité 2', categorie: 'Noms', etymologie: 'moral, moralité'),
  Vocabulaire(latin: 'ratio, onis, f. (rationem habere + gén.)', francais: '1. compte, calcul 2. raison 3. méthode, manière (tenir compte de)', unite: 'Vol. II – Unité 2', categorie: 'Noms', etymologie: 'ratio, rationnel'),
  Vocabulaire(latin: 'rus, ruris, n.', francais: 'campagne', unite: 'Vol. II – Unité 2', categorie: 'Noms'),
  Vocabulaire(latin: 'speculum, i, n.', francais: 'miroir', unite: 'Vol. II – Unité 2', categorie: 'Noms', etymologie: 'ALL. Spiegel / ROUM. specul'),
  Vocabulaire(latin: 'ver, veris, n.', francais: 'printemps', unite: 'Vol. II – Unité 2', categorie: 'Noms', etymologie: 'ESP., IT. et PORT. primavera'),
  Vocabulaire(latin: 'vetustas, atis, f.', francais: 'ancienneté', unite: 'Vol. II – Unité 2', categorie: 'Noms', etymologie: '< vetus / vétuste, vétusté / ESP. et PORT. vetustez'),

  Vocabulaire(latin: 'carus, a, um (+ dat.)', francais: 'cher (à qqn), précieux', unite: 'Vol. II – Unité 2', categorie: 'Adjectifs', etymologie: 'charitable, ESP., IT. et PORT. caro'),
  Vocabulaire(latin: 'tutus, a, um (a(b) + abl. ; adversus + acc.)', francais: 'sûr, en sécurité, protégé (contre)', unite: 'Vol. II – Unité 2', categorie: 'Adjectifs', etymologie: 'tuteur, tutelle'),

  Vocabulaire(latin: 'hic, haec, hoc', francais: 'celui-ci, celle-ci, ceci, ...', unite: 'Vol. II – Unité 2', categorie: 'Pronoms-adjectifs'),
  Vocabulaire(latin: 'ille, illa, illud', francais: 'celui-là, celle-là, cela, ...', unite: 'Vol. II – Unité 2', categorie: 'Pronoms-adjectifs'),
  Vocabulaire(latin: 'iste, ista, istud', francais: 'celui-là, celle-là, cela, ...', unite: 'Vol. II – Unité 2', categorie: 'Pronoms-adjectifs', etymologie: 'ESP. este'),

  Vocabulaire(latin: 'conscribo, is, ere, -scripsi, -scriptum', francais: '1. inscrire sur une liste, enrôler [legiones] 2. composer, rédiger [librum]', unite: 'Vol. II – Unité 2', categorie: 'Verbes', etymologie: '< cum + scribere / conscription'),
  Vocabulaire(latin: 'constituo, is, ere, -stitui, -stitutum (+ inf.)', francais: '1. dresser, fixer, établir 2. décider (de)', unite: 'Vol. II – Unité 2', categorie: 'Verbes', etymologie: 'constitution / ESP. constituir'),
  Vocabulaire(latin: 'fugio, is, ere, fugi, fugitum', francais: 'fuir, s\'enfuir', unite: 'Vol. II – Unité 2', categorie: 'Verbes', etymologie: 'fuguer, fugitif / PORT. fugir'),
  Vocabulaire(latin: 'promitto, is, ere, -misi, -missum', francais: 'promettre, garantir, assurer', unite: 'Vol. II – Unité 2', categorie: 'Verbes', etymologie: 'ANGL. to promise'),

  Vocabulaire(latin: 'ante (adv.)', francais: 'auparavant, avant', unite: 'Vol. II – Unité 2', categorie: 'Mots-outils', etymologie: 'antérieur, antériorité'),
  Vocabulaire(latin: 'antequam / ante ... quam + ind. (= priusquam)', francais: 'avant le moment où', unite: 'Vol. II – Unité 2', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'cras', francais: 'demain', unite: 'Vol. II – Unité 2', categorie: 'Mots-outils', etymologie: 'procrastination'),
  Vocabulaire(latin: 'hodie', francais: 'aujourd\'hui, en ce jour', unite: 'Vol. II – Unité 2', categorie: 'Mots-outils', etymologie: '< hoc die'),
  Vocabulaire(latin: 'multum (adv.)', francais: 'beaucoup', unite: 'Vol. II – Unité 2', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'multo + post / ante', francais: 'beaucoup plus tard / auparavant', unite: 'Vol. II – Unité 2', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'multo + comparatif', francais: 'beaucoup plus ...', unite: 'Vol. II – Unité 2', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'post (adv.)', francais: 'plus tard, après', unite: 'Vol. II – Unité 2', categorie: 'Mots-outils', etymologie: 'postérieur, postériorité, postérité'),
  Vocabulaire(latin: 'Quam diu ?', francais: 'Combien de temps ?', unite: 'Vol. II – Unité 2', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'Quando ?', francais: 'Quand ? À quel moment ?', unite: 'Vol. II – Unité 2', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. II – UNITÉ 3
  // ==========================================================

  Vocabulaire(latin: 'adventus, us, m.', francais: 'arrivée', unite: 'Vol. II – Unité 3', categorie: 'Noms', etymologie: '< advenire / ALL. Advent'),
  Vocabulaire(latin: 'Augusta, ae Treverorum', francais: 'Trèves', unite: 'Vol. II – Unité 3', categorie: 'Noms'),
  Vocabulaire(latin: 'cibus, i, m.', francais: 'nourriture', unite: 'Vol. II – Unité 3', categorie: 'Noms', etymologie: 'cibarium / IT. cibo'),
  Vocabulaire(latin: 'cognomen, inis, n.', francais: 'surnom', unite: 'Vol. II – Unité 3', categorie: 'Noms', etymologie: '< cum + nomen'),
  Vocabulaire(latin: 'domus, us, f.', francais: 'maison', unite: 'Vol. II – Unité 3', categorie: 'Noms', etymologie: 'domicile, domotique'),
  Vocabulaire(latin: 'exercitus, us, m.', francais: 'armée, corps de troupes', unite: 'Vol. II – Unité 3', categorie: 'Noms', etymologie: 'ESP. ejército'),
  Vocabulaire(latin: 'genu, us, n.', francais: 'genou', unite: 'Vol. II – Unité 3', categorie: 'Noms', etymologie: 'génuflexion'),
  Vocabulaire(latin: 'gradus, us, m.', francais: '(le) pas ; (ici) degré, stade', unite: 'Vol. II – Unité 3', categorie: 'Noms', etymologie: 'grade, gradué'),
  Vocabulaire(latin: 'industria, ae, f.', francais: 'application, activité, assiduité', unite: 'Vol. II – Unité 3', categorie: 'Noms', etymologie: 'industrieux, industriel'),
  Vocabulaire(latin: 'manus, us, f.', francais: '1. main 2. poignée d\'hommes, troupe', unite: 'Vol. II – Unité 3', categorie: 'Noms', etymologie: 'manuel, manucure'),
  Vocabulaire(latin: 'metus, us, m.', francais: 'peur, crainte', unite: 'Vol. II – Unité 3', categorie: 'Noms'),
  Vocabulaire(latin: 'onus, eris, n.', francais: '1. charge, cargaison 2. fardeau, poids 3. chose pénible 4. (pl.) charges, impôts', unite: 'Vol. II – Unité 3', categorie: 'Noms', etymologie: 'onéreux'),
  Vocabulaire(latin: 'portus, us, m.', francais: 'port', unite: 'Vol. II – Unité 3', categorie: 'Noms', etymologie: 'portuaire'),
  Vocabulaire(latin: 'potus, us, m.', francais: '1. action de boire 2. boisson', unite: 'Vol. II – Unité 3', categorie: 'Noms', etymologie: 'potion'),
  Vocabulaire(latin: 'reditus, us, m.', francais: 'retour', unite: 'Vol. II – Unité 3', categorie: 'Noms'),
  Vocabulaire(latin: 'senatus, us, m.', francais: 'sénat', unite: 'Vol. II – Unité 3', categorie: 'Noms', etymologie: 'senatus populusque Romanus'),
  Vocabulaire(latin: 'sol, solis, m.', francais: 'soleil', unite: 'Vol. II – Unité 3', categorie: 'Noms', etymologie: 'solaire, solstice / ESP. sol / IT. sole'),
  Vocabulaire(latin: 'vicus, i, m.', francais: '1. quartier d\'une ville 2. bourg, village', unite: 'Vol. II – Unité 3', categorie: 'Noms', etymologie: '> vicinus > chemin vicinal'),
  Vocabulaire(latin: 'vultus, us, m.', francais: 'visage', unite: 'Vol. II – Unité 3', categorie: 'Noms', etymologie: 'vultueux'),

  Vocabulaire(latin: 'idem, eadem, idem (ac / atque)', francais: 'le même, la même, le même / la même chose (que)', unite: 'Vol. II – Unité 3', categorie: 'Pronoms-adjectifs'),
  Vocabulaire(latin: 'ipse, a, um', francais: '(-)même, en personne', unite: 'Vol. II – Unité 3', categorie: 'Pronoms-adjectifs', etymologie: 'ipséité (f.)'),
  Vocabulaire(latin: 'liber, libera, liberum', francais: 'libre', unite: 'Vol. II – Unité 3', categorie: 'Pronoms-adjectifs'),
  Vocabulaire(latin: 'major natu', francais: 'plus âgé (par la naissance) ; aîné', unite: 'Vol. II – Unité 3', categorie: 'Pronoms-adjectifs'),
  Vocabulaire(latin: 'minor natu', francais: 'moins âgé (par la naissance) ; plus jeune ; cadet', unite: 'Vol. II – Unité 3', categorie: 'Pronoms-adjectifs'),
  Vocabulaire(latin: 'natus, a, um + acc.', francais: 'né ; âgé de', unite: 'Vol. II – Unité 3', categorie: 'Pronoms-adjectifs', etymologie: 'natal, nativité'),
  Vocabulaire(latin: 'situs, a, um', francais: 'placé, posé ; situé', unite: 'Vol. II – Unité 3', categorie: 'Pronoms-adjectifs', etymologie: 'site'),
  Vocabulaire(latin: 'suavis, e', francais: 'doux, agréable', unite: 'Vol. II – Unité 3', categorie: 'Pronoms-adjectifs', etymologie: 'suave, la suavité / ESP. et PORT. suave'),
  Vocabulaire(latin: 'superior, oris', francais: '1. plus haut, supérieur [locus] 2. antérieur, précédent [annus]', unite: 'Vol. II – Unité 3', categorie: 'Pronoms-adjectifs', etymologie: 'supériorité'),

  Vocabulaire(latin: 'consuesco, is, ere, -suevi, -suetum (+ inf.)', francais: 's\'habituer (à), prendre l\'habitude (de)', unite: 'Vol. II – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'curo, as, are, avi, atum + acc.', francais: 'avoir soin de, soigner, s\'occuper de', unite: 'Vol. II – Unité 3', categorie: 'Verbes', etymologie: 'cure, curatif'),
  Vocabulaire(latin: 'spero, as, are, avi, atum (+ acc.) ; sperare de + abl. ; sperare + ACI', francais: 'espérer (qqch.) ; avoir bon espoir de ; espérer que', unite: 'Vol. II – Unité 3', categorie: 'Verbes', etymologie: 'IT. sperare / ESP. et PORT. esperar / ROUM. spera'),
  Vocabulaire(latin: 'statuo, is, ere, statui, statutum ; statuere + inf. / ACI', francais: 'établir, placer ; décider de / que', unite: 'Vol. II – Unité 3', categorie: 'Verbes', etymologie: 'statuer, statue'),
  Vocabulaire(latin: 'suadeo, es, ere, suasi, suasum (+ dat. + inf.)', francais: 'conseiller (à qqn de faire qqch.)', unite: 'Vol. II – Unité 3', categorie: 'Verbes'),

  Vocabulaire(latin: 'ob + acc.', francais: 'pour, en raison de, à cause de', unite: 'Vol. II – Unité 3', categorie: 'Prépositions'),

  Vocabulaire(latin: 'ac / atque', francais: 'et', unite: 'Vol. II – Unité 3', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'ac / atque (après idem)', francais: 'que', unite: 'Vol. II – Unité 3', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'undique', francais: 'de toutes parts, de tous les côtés, de partout', unite: 'Vol. II – Unité 3', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. II – UNITÉ 4
  // ==========================================================

  Vocabulaire(latin: 'aquila, ae, f.', francais: '1. aigle 2. enseigne militaire romaine', unite: 'Vol. II – Unité 4', categorie: 'Noms', etymologie: 'un nez aquilin'),
  Vocabulaire(latin: 'auxilia, orum, n. pl.', francais: 'troupes de secours, troupes auxiliaires', unite: 'Vol. II – Unité 4', categorie: 'Noms'),
  Vocabulaire(latin: 'clades, is, f. (cladem accipere ; cladi superesse)', francais: '1. désastre, fléau, calamité 2. défaite militaire (subir une défaite ; survivre à une défaite)', unite: 'Vol. II – Unité 4', categorie: 'Noms', etymologie: '< grec klaô (mettre en pièces)'),
  Vocabulaire(latin: 'cursus, us, m. (cursus honorum ; cursus publicus)', francais: '1. action de courir, course 2. cours, marche (carrière des honneurs ; service des dépêches)', unite: 'Vol. II – Unité 4', categorie: 'Noms', etymologie: 'ALL. Kurs'),
  Vocabulaire(latin: 'fatum, i, n.', francais: 'destin, destinée', unite: 'Vol. II – Unité 4', categorie: 'Noms', etymologie: 'fatal, fatalité'),
  Vocabulaire(latin: 'Germani, orum, m. pl.', francais: 'les Germains', unite: 'Vol. II – Unité 4', categorie: 'Noms'),
  Vocabulaire(latin: 'impetus, us, m. (impetum facere in + acc.)', francais: 'élan, attaque, assaut (lancer une attaque contre)', unite: 'Vol. II – Unité 4', categorie: 'Noms', etymologie: 'impétueux'),
  Vocabulaire(latin: 'magnitudo, inis, f.', francais: 'grandeur, force, importance', unite: 'Vol. II – Unité 4', categorie: 'Noms', etymologie: 'magnitude (échelle de Richter)'),
  Vocabulaire(latin: 'mansio, onis, f.', francais: '1. séjour 2. demeure, habitation 3. auberge, gîte d\'étape', unite: 'Vol. II – Unité 4', categorie: 'Noms', etymologie: 'maison / ANGL. mansion'),
  Vocabulaire(latin: 'obses, obsidis, m. / f.', francais: 'otage', unite: 'Vol. II – Unité 4', categorie: 'Noms', etymologie: '< ob + sedeo'),
  Vocabulaire(latin: 'terror, oris, m.', francais: 'terreur, effroi, épouvante', unite: 'Vol. II – Unité 4', categorie: 'Noms', etymologie: '< terreo'),
  Vocabulaire(latin: 'timor, oris, m.', francais: 'crainte, appréhension', unite: 'Vol. II – Unité 4', categorie: 'Noms', etymologie: '< timeo'),

  Vocabulaire(latin: 'Quam multi ? = Quot ?', francais: 'Combien nombreux... ? Combien de... ?', unite: 'Vol. II – Unité 4', categorie: 'Pronoms-adjectifs'),
  Vocabulaire(latin: 'Quis ? Quae ? Quid ?', francais: 'Qui ? Quoi ?', unite: 'Vol. II – Unité 4', categorie: 'Pronoms-adjectifs'),
  Vocabulaire(latin: 'Qui... ? Quae... ? Quod... ?', francais: 'Quel... ? Quelle... ?', unite: 'Vol. II – Unité 4', categorie: 'Pronoms-adjectifs'),
  Vocabulaire(latin: 'summus, a, um', francais: '1. le plus grand, très grand 2. le plus haut, le haut de 3. suprême', unite: 'Vol. II – Unité 4', categorie: 'Pronoms-adjectifs', etymologie: 'sommet'),
  Vocabulaire(latin: 'talis, e', francais: 'tel, telle', unite: 'Vol. II – Unité 4', categorie: 'Pronoms-adjectifs', etymologie: 'loi du talion'),
  Vocabulaire(latin: 'validus, a, um', francais: 'fort, robuste', unite: 'Vol. II – Unité 4', categorie: 'Pronoms-adjectifs', etymologie: 'valide, invalide'),

  Vocabulaire(latin: 'accido, is, ere, -cidi ; accidit ut (non) + subj.', francais: 'survenir, arriver (il arrive [par malheur] que ne pas)', unite: 'Vol. II – Unité 4', categorie: 'Verbes', etymologie: 'accident'),
  Vocabulaire(latin: 'caedo, is, ere, cecidi, caesum', francais: '1. couper, abattre [arborem] 2. tuer, massacrer [hostes]', unite: 'Vol. II – Unité 4', categorie: 'Verbes', etymologie: 'homicide, patricide'),
  Vocabulaire(latin: 'clamo, as, are, avi, atum', francais: 'crier, s\'écrier', unite: 'Vol. II – Unité 4', categorie: 'Verbes', etymologie: 'clameur, exclamation'),
  Vocabulaire(latin: 'decerno, is, ere, -crevi, -cretum ; decernere + inf. / ut + subj.', francais: 'attribuer par décret, décerner ; décider de / que', unite: 'Vol. II – Unité 4', categorie: 'Verbes', etymologie: 'ALL. ein Dekret'),
  Vocabulaire(latin: 'divido, is, ere, divisi, divisum', francais: 'partager, diviser (en) ; répartir, distribuer (à) ; séparer (de)', unite: 'Vol. II – Unité 4', categorie: 'Verbes', etymologie: 'division, dividende'),
  Vocabulaire(latin: 'ferunt + ACI', francais: 'on rapporte que', unite: 'Vol. II – Unité 4', categorie: 'Verbes'),
  Vocabulaire(latin: 'invado, is, ere, -vasi, -vasum', francais: 'attaquer, assaillir, envahir', unite: 'Vol. II – Unité 4', categorie: 'Verbes', etymologie: 'invasion / IT. invadere / ESP. et PORT. invadir / ANGL. Space Invaders'),
  Vocabulaire(latin: 'munio, is, ire, ivi, itum', francais: 'fortifier, consolider', unite: 'Vol. II – Unité 4', categorie: 'Verbes', etymologie: '> moenia (remparts)'),
  Vocabulaire(latin: 'sustineo, es, ere, -tinui, -tentum + acc.', francais: 'soutenir, supporter, résister à [impetum]', unite: 'Vol. II – Unité 4', categorie: 'Verbes'),

  Vocabulaire(latin: 'ne ... quidem ...', francais: 'ne pas même ; ne pas non plus', unite: 'Vol. II – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'paene', francais: 'presque', unite: 'Vol. II – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'Qua ?', francais: 'Par où ?', unite: 'Vol. II – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'Quam + adj. / adv. ?', francais: 'Combien ... ?', unite: 'Vol. II – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'quoniam (+ ind.)', francais: 'puisque', unite: 'Vol. II – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'ubique', francais: 'partout', unite: 'Vol. II – Unité 4', categorie: 'Mots-outils', etymologie: 'don d\'ubiquité'),

  // ==========================================================
  // VOL. II – UNITÉ 5
  // ==========================================================

  Vocabulaire(latin: 'clementia, ae, f.', francais: 'clémence, bonté, douceur', unite: 'Vol. II – Unité 5', categorie: 'Noms', etymologie: 'ESP. clemencia'),
  Vocabulaire(latin: 'cultus, us, m.', francais: '1. manière de cultiver [agrorum] 2. manière de pratiquer, culte [litterarum] 3. genre de vie', unite: 'Vol. II – Unité 5', categorie: 'Noms'),
  Vocabulaire(latin: 'currus, us, m.', francais: 'char', unite: 'Vol. II – Unité 5', categorie: 'Noms'),
  Vocabulaire(latin: 'fructus, us, m.', francais: '1. revenu, fruit 2. récompense, avantage', unite: 'Vol. II – Unité 5', categorie: 'Noms', etymologie: 'fructifier'),
  Vocabulaire(latin: 'furor, oris, m.', francais: 'délire, folie furieuse ; (ici) fureur guerrière', unite: 'Vol. II – Unité 5', categorie: 'Noms', etymologie: 'furie, furibond'),
  Vocabulaire(latin: 'honor / honos, honoris, m.', francais: '1. honneur, hommage 2. charge, magistrature', unite: 'Vol. II – Unité 5', categorie: 'Noms', etymologie: 'cursus honorum'),
  Vocabulaire(latin: 'ira, ae, f.', francais: 'colère', unite: 'Vol. II – Unité 5', categorie: 'Noms', etymologie: 'irascible'),
  Vocabulaire(latin: 'militia, ae, f.', francais: 'service militaire, métier de soldat', unite: 'Vol. II – Unité 5', categorie: 'Noms', etymologie: 'milice'),
  Vocabulaire(latin: 'mille (invar.) ; milia, milium, n. pl. + gén.', francais: 'mille ; ... milliers de', unite: 'Vol. II – Unité 5', categorie: 'Noms', etymologie: 'millésime'),
  Vocabulaire(latin: 'orbis, is, m. (orbis terrarum)', francais: 'cercle, disque (l\'ensemble des terres ; la terre)', unite: 'Vol. II – Unité 5', categorie: 'Noms', etymologie: 'urbi et orbi'),
  Vocabulaire(latin: 'parens, parentis, m. / f. (parentes, um, m. pl.)', francais: 'père / mère (les parents)', unite: 'Vol. II – Unité 5', categorie: 'Noms', etymologie: 'parental'),
  Vocabulaire(latin: 'praemium, i, n.', francais: 'récompense, avantage', unite: 'Vol. II – Unité 5', categorie: 'Noms', etymologie: 'prime / ANGL. premium'),
  Vocabulaire(latin: 'pueritia, ae, f.', francais: 'enfance', unite: 'Vol. II – Unité 5', categorie: 'Noms', etymologie: '< puer / puérilité'),
  Vocabulaire(latin: 'salus, utis, f. (salutem dare / dicere + dat.)', francais: 'santé, salut, action de saluer (saluer qqn)', unite: 'Vol. II – Unité 5', categorie: 'Noms', etymologie: 'salutaire / ESP. saludo'),
  Vocabulaire(latin: 'sermo, onis, m.', francais: '1. conversation, entretien 2. langue [sermo Latinus]', unite: 'Vol. II – Unité 5', categorie: 'Noms', etymologie: 'sermonner'),
  Vocabulaire(latin: 'terra et mari / terra marique', francais: 'sur terre et sur mer', unite: 'Vol. II – Unité 5', categorie: 'Noms'),
  Vocabulaire(latin: 'triumphus, i, m. (triumphum agere ; triumphum decernere + dat.)', francais: 'triomphe (célébrer le triomphe ; décerner le triomphe à qqn)', unite: 'Vol. II – Unité 5', categorie: 'Noms', etymologie: 'triompher / ANGL. triumph'),
  Vocabulaire(latin: 'votum, i, n. (vota solvere)', francais: 'vœu, promesse faite aux dieux (s\'acquitter des vœux)', unite: 'Vol. II – Unité 5', categorie: 'Noms', etymologie: 'vote, voter'),

  Vocabulaire(latin: 'civilis, e', francais: 'civil, civile [bellum civile]', unite: 'Vol. II – Unité 5', categorie: 'Adjectifs', etymologie: 'civiliser'),
  Vocabulaire(latin: 'turpis, e', francais: 'laid, honteux, ignoble', unite: 'Vol. II – Unité 5', categorie: 'Adjectifs', etymologie: 'turpitude'),
  Vocabulaire(latin: 'suus, a, um', francais: 'son, sa, ses (réfléchi direct et indirect)', unite: 'Vol. II – Unité 5', categorie: 'Adjectifs'),

  Vocabulaire(latin: 'addo, is, ere, addidi, additum (+ dat. ou ad + acc.) ; addere + ACI', francais: 'ajouter (à) ; ajouter que', unite: 'Vol. II – Unité 5', categorie: 'Verbes', etymologie: 'addition, additionner, additionnel'),
  Vocabulaire(latin: 'contemno, is, ere, -tempsi, -temptum (+ acc.)', francais: 'mépriser (qqch.) [mortem], négliger (qqch.) [consilium]', unite: 'Vol. II – Unité 5', categorie: 'Verbes', etymologie: 'ANGL. contempt'),
  Vocabulaire(latin: 'deduco, is, ere, -duxi, -ductum', francais: 'faire descendre, emmener, mener, escorter', unite: 'Vol. II – Unité 5', categorie: 'Verbes', etymologie: '< de + duco / déduire, déduction'),
  Vocabulaire(latin: 'ignosco, is, ere, -novi, -notum (+ dat.)', francais: 'pardonner (à)', unite: 'Vol. II – Unité 5', categorie: 'Verbes', etymologie: '< in + (g)nosco'),
  Vocabulaire(latin: 'incolo, is, ere, -colui, -cultum (+ acc.)', francais: 'habiter (un lieu)', unite: 'Vol. II – Unité 5', categorie: 'Verbes', etymologie: 'colon, colonie, coloniser'),
  Vocabulaire(latin: 'occido, is, ere, occidi, -cisum', francais: 'tuer, faire périr', unite: 'Vol. II – Unité 5', categorie: 'Verbes', etymologie: '< ob + caedo'),
  Vocabulaire(latin: 'parco, is, ere, peperci, parsum (+ dat.)', francais: '1. épargner, ménager (qqn / qqch.) 2. (rare) s\'abstenir (de qqch.)', unite: 'Vol. II – Unité 5', categorie: 'Verbes', etymologie: 'les Parques'),
  Vocabulaire(latin: 'resumo, is, ere, -sumpsi, -sumptum', francais: '1. prendre de nouveau, reprendre 2. recommencer, renouveler', unite: 'Vol. II – Unité 5', categorie: 'Verbes', etymologie: 'résumé / ANGL. to resume'),
  Vocabulaire(latin: 'solvo, is, ere, solui, solutum', francais: '1. délier, détacher, délivrer 2. payer, s\'acquitter de 3. dissoudre, rompre', unite: 'Vol. II – Unité 5', categorie: 'Verbes', etymologie: 'solution, dissolvant'),
  Vocabulaire(latin: 'videor, eris, eri (+ attr. du S ; + inf.)', francais: '1. être vu 2. sembler, paraître', unite: 'Vol. II – Unité 5', categorie: 'Verbes', etymologie: 'IT. vedere / ROUM. vedea'),

  Vocabulaire(latin: 'praeter + acc.', francais: '1. le long de 2. en plus de 3. excepté, sauf', unite: 'Vol. II – Unité 5', categorie: 'Prépositions'),

  Vocabulaire(latin: 'equidem', francais: '1. certes, sans doute 2. quant à moi, pour moi', unite: 'Vol. II – Unité 5', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'magis (... quam)', francais: 'plus (... que), plutôt (... que)', unite: 'Vol. II – Unité 5', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'praeterea', francais: 'en outre, de plus', unite: 'Vol. II – Unité 5', categorie: 'Mots-outils', etymologie: '< praeter + ea'),
  Vocabulaire(latin: 'semel – bis – ter – quater', francais: 'une fois – deux fois – trois fois – quatre fois', unite: 'Vol. II – Unité 5', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. II – UNITÉ 6
  // ==========================================================

  Vocabulaire(latin: 'convivium, i, n.', francais: 'repas, festin ; banquet', unite: 'Vol. II – Unité 6', categorie: 'Noms', etymologie: '< cum + vivere'),
  Vocabulaire(latin: 'dies, diei, m. (in dies)', francais: 'jour (de jour en jour)', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'divus, i, m.', francais: 'dieu, divinité (titre donné aux empereurs divinisés)', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'fas / nefas, n. (fas est + inf. / ACI)', francais: 'expression de la volonté divine, droit divin (il est permis par les dieux de / que)', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'fides, fidei, f. (fidem habere + dat. ≠ fidem fallere)', francais: '1. bonne foi, loyauté 2. foi, confiance 3. protection 4. promesse (faire confiance à qqn ≠ manquer à la parole donnée)', unite: 'Vol. II – Unité 6', categorie: 'Noms', etymologie: 'fides > fidelis / fidèle, fidélité'),
  Vocabulaire(latin: 'flamen, inis, m.', francais: 'flamine ; prêtre (chargé du culte d\'une seule divinité)', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'frumentum, i, n.', francais: 'blé en grains ; grains', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'ignis, is, m.', francais: 'feu', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'labor, oris, m.', francais: '1. peine, fatigue 2. travail 3. tâche, épreuve', unite: 'Vol. II – Unité 6', categorie: 'Noms', etymologie: 'labeur, labourer, laborieux'),
  Vocabulaire(latin: 'meridies, -diei, m.', francais: 'midi', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'munus, eris, n. (munera publica)', francais: '1. fonction, charge 2. cadeau (spectacles publics, combats de gladiateurs)', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'opus, operis, n. (opus esse + dat. + abl. / + inf.)', francais: 'œuvre, ouvrage, travail (qqn a besoin de)', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'ordo, inis, m.', francais: '1. rang, rangée, ligne 2. rang social, ordre 3. bon ordre, succession', unite: 'Vol. II – Unité 6', categorie: 'Noms', etymologie: 'chiffres ordinaux, ordinaire, subordination'),
  Vocabulaire(latin: 'poena, ae, f. (poenas dare)', francais: 'vengeance, punition, châtiment, peine (subir une punition, être puni)', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'pontifex, -ficis, m. (pontifex maximus)', francais: 'pontife (grand pontife)', unite: 'Vol. II – Unité 6', categorie: 'Noms', etymologie: '< pons + facio'),
  Vocabulaire(latin: 'posteri, orum, m. pl.', francais: 'les descendants, la postérité', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'religio, onis, f.', francais: '1. attention scrupuleuse, conscience 2. respect envers les dieux 3. croyance religieuse 4. pratiques religieuses, culte', unite: 'Vol. II – Unité 6', categorie: 'Noms', etymologie: 'écouter religieusement'),
  Vocabulaire(latin: 'res, rei, f.', francais: 'chose, affaire, bien (objet, fait, situation, entreprise, réalité, possession, fortune, etc.)', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'res familiaris, rei familiaris, f.', francais: 'patrimoine (m.)', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'res militaris, rei militaris, f.', francais: 'affaire militaire ; art de la guerre', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'res publica / respublica, ae, reipublicae, f.', francais: 'État, république, vie politique, affaires publiques', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'res novae, rerum novarum, f. pl.', francais: 'changement politique, révolution', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'res secundae / adversae, f. pl.', francais: 'situation favorable, bonheur / situation contraire, malheur', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'sacerdos, otis, m.', francais: 'prêtre (officiel du peuple romain)', unite: 'Vol. II – Unité 6', categorie: 'Noms', etymologie: 'sacerdotal'),
  Vocabulaire(latin: 'sacrificium, i, n.', francais: 'sacrifice', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'saeculum, i, n.', francais: 'âge, génération, époque, siècle', unite: 'Vol. II – Unité 6', categorie: 'Noms'),
  Vocabulaire(latin: 'spes, spei, f.', francais: 'espoir (m.), espérance (f.)', unite: 'Vol. II – Unité 6', categorie: 'Noms'),

  Vocabulaire(latin: 'certus, a, um', francais: '1. fixé, déterminé [tempus] 2. sûr, certain [via, amicus]', unite: 'Vol. II – Unité 6', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'divus, a, um', francais: 'divin', unite: 'Vol. II – Unité 6', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'festus, a, um (dies festus)', francais: 'de fête, solennel (jour de fête)', unite: 'Vol. II – Unité 6', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'immortalis, e', francais: 'immortel', unite: 'Vol. II – Unité 6', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'medius, a, um', francais: '1. le milieu de 2. ... du milieu', unite: 'Vol. II – Unité 6', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'mortalis, e', francais: 'mortel', unite: 'Vol. II – Unité 6', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'perpetuus, a, um', francais: 'sans interruption, qui dure toujours, éternel, perpétuel', unite: 'Vol. II – Unité 6', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'plerique, pleraeque, pleraque', francais: 'la plupart (de)', unite: 'Vol. II – Unité 6', categorie: 'Adjectifs'),

  Vocabulaire(latin: 'contingo, is, ere, -tigi, -tactum ; contingit ut (non) + subj.', francais: '1. toucher, atteindre 2. arriver, se produire (il arrive [par bonheur] que ne pas)', unite: 'Vol. II – Unité 6', categorie: 'Verbes', etymologie: '< cum + tango'),
  Vocabulaire(latin: 'curare + acc. ; curare ut + subj.', francais: 'avoir soin de, soigner ; veiller à ce que', unite: 'Vol. II – Unité 6', categorie: 'Verbes'),
  Vocabulaire(latin: 'efficio, is, ere, -feci, -fectum (ut + subj.)', francais: 'faire en sorte (que)', unite: 'Vol. II – Unité 6', categorie: 'Verbes'),
  Vocabulaire(latin: 'evenio, is, ire, -veni, -ventum ; evenit ut (non) + subj.', francais: '1. se réaliser, s\'accomplir 2. arriver, se produire (il arrive que ne pas)', unite: 'Vol. II – Unité 6', categorie: 'Verbes', etymologie: 'événement'),
  Vocabulaire(latin: 'fallo, is, ere, fefelli, falsum', francais: 'tromper, induire en erreur', unite: 'Vol. II – Unité 6', categorie: 'Verbes'),
  Vocabulaire(latin: 'festino, as, are, avi, atum', francais: 'se hâter, se dépêcher', unite: 'Vol. II – Unité 6', categorie: 'Verbes'),
  Vocabulaire(latin: 'imperare + dat. ut + subj.', francais: 'ordonner à qqn de / que', unite: 'Vol. II – Unité 6', categorie: 'Verbes'),
  Vocabulaire(latin: 'instituo, is, ere, -stitui, -stitutum (+ inf.)', francais: '1. instituer, établir, entreprendre (de) 2. organiser, former', unite: 'Vol. II – Unité 6', categorie: 'Verbes', etymologie: '< in + statuo'),
  Vocabulaire(latin: 'laboro, as, are, avi, atum', francais: 'travailler, se donner du mal, peiner', unite: 'Vol. II – Unité 6', categorie: 'Verbes'),
  Vocabulaire(latin: 'metuo, is, ere, metui, metutum (ne (non) + subj.)', francais: 'craindre, redouter (que ne (pas))', unite: 'Vol. II – Unité 6', categorie: 'Verbes'),
  Vocabulaire(latin: 'opto, as, are, avi, atum (ut + subj.)', francais: 'souhaiter (que)', unite: 'Vol. II – Unité 6', categorie: 'Verbes'),
  Vocabulaire(latin: 'oro, as, are, avi, atum (+ acc. ut + subj.)', francais: 'prier (qqn de / que)', unite: 'Vol. II – Unité 6', categorie: 'Verbes'),
  Vocabulaire(latin: 'pareo, es, ere, parui, paritum (+ dat.)', francais: 'obéir (à)', unite: 'Vol. II – Unité 6', categorie: 'Verbes'),
  Vocabulaire(latin: 'perdo, is, ere, -didi, -ditum (+ acc.)', francais: 'détruire, ruiner, causer la perte (de qqn)', unite: 'Vol. II – Unité 6', categorie: 'Verbes'),
  Vocabulaire(latin: 'turbo, as, are, avi, atum', francais: 'troubler, agiter, mettre en désordre ; bouleverser', unite: 'Vol. II – Unité 6', categorie: 'Verbes', etymologie: '< turba'),

  Vocabulaire(latin: 'cum + subj. (impf. / pl.-q.-pf.)', francais: 'comme, alors que', unite: 'Vol. II – Unité 6', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'lente', francais: 'lentement, sans hâte', unite: 'Vol. II – Unité 6', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'melius', francais: 'mieux', unite: 'Vol. II – Unité 6', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. II – UNITÉ 7
  // ==========================================================

  Vocabulaire(latin: 'ala, ae, f.', francais: 'aile ; aile d\'une armée (corps de cavalerie auxiliaire)', unite: 'Vol. II – Unité 7', categorie: 'Noms'),
  Vocabulaire(latin: 'caelum, i, n.', francais: 'ciel, climat', unite: 'Vol. II – Unité 7', categorie: 'Noms'),
  Vocabulaire(latin: 'casus, us, m.', francais: '1. ce qui arrive, hasard 2. accident ; malheur', unite: 'Vol. II – Unité 7', categorie: 'Noms', etymologie: '< cadere / ALL. Unfall'),
  Vocabulaire(latin: 'comes, comitis, m. / f.', francais: 'compagnon / compagne (de voyage)', unite: 'Vol. II – Unité 7', categorie: 'Noms', etymologie: 'comte'),
  Vocabulaire(latin: 'nemo', francais: 'personne ne ; ne ... personne', unite: 'Vol. II – Unité 7', categorie: 'Noms', etymologie: 'nihiliste'),
  Vocabulaire(latin: 'nihil', francais: 'rien ... ne ; ne ... rien', unite: 'Vol. II – Unité 7', categorie: 'Noms', etymologie: 'nihiliste'),
  Vocabulaire(latin: 'ops, opis, f. (opes, opum, f. pl.) ≠ inopia, ae, f.', francais: '1. pouvoir, force 2. aide, secours ; moyens, puissance, richesses', unite: 'Vol. II – Unité 7', categorie: 'Noms'),
  Vocabulaire(latin: 'pectus, pectoris, n.', francais: '1. poitrine 2. cœur ; (siège de l\')intelligence', unite: 'Vol. II – Unité 7', categorie: 'Noms'),
  Vocabulaire(latin: 'quisquam, quidquam / quicquam (nec quisquam ...)', francais: 'quelqu\'un, quelque chose ; et personne ... ne, et rien ... ne', unite: 'Vol. II – Unité 7', categorie: 'Noms'),
  Vocabulaire(latin: 'regio, onis, f.', francais: 'contrée, région', unite: 'Vol. II – Unité 7', categorie: 'Noms'),
  Vocabulaire(latin: 'sapiens, entis, m.', francais: 'sage', unite: 'Vol. II – Unité 7', categorie: 'Noms'),
  Vocabulaire(latin: 'turba, ae, f.', francais: '1. désordre 2. foule (en désordre)', unite: 'Vol. II – Unité 7', categorie: 'Noms'),
  Vocabulaire(latin: 'vinculum, i, n. (in vincula conjicere)', francais: 'lien, attache (jeter dans les fers, emprisonner)', unite: 'Vol. II – Unité 7', categorie: 'Noms'),

  Vocabulaire(latin: 'nullus, a, um', francais: 'aucun(e) ... ne ; ne ... aucun(e)', unite: 'Vol. II – Unité 7', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'prior, prioris', francais: 'précédent, antérieur', unite: 'Vol. II – Unité 7', categorie: 'Adjectifs', etymologie: 'priorité'),
  Vocabulaire(latin: 'solus, a, um', francais: 'seul', unite: 'Vol. II – Unité 7', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'ullus, a, um (neque ullus, a, um ; sine ullo, a, o)', francais: 'quelque, quelqu\'un ; et aucun ... ne ; sans aucun ...', unite: 'Vol. II – Unité 7', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'unus, a, um', francais: 'un (seul)', unite: 'Vol. II – Unité 7', categorie: 'Adjectifs'),

  Vocabulaire(latin: 'affero, affers, afferre, attuli, allatum', francais: 'porter vers, apporter', unite: 'Vol. II – Unité 7', categorie: 'Verbes'),
  Vocabulaire(latin: 'aufero, aufers, auferre, abstuli, ablatum', francais: 'porter loin (de), emporter, enlever', unite: 'Vol. II – Unité 7', categorie: 'Verbes'),
  Vocabulaire(latin: 'cogito, as, are, avi, atum (de + abl.)', francais: 'penser (à), réfléchir (à), méditer (sur)', unite: 'Vol. II – Unité 7', categorie: 'Verbes', etymologie: 'cogito, ergo sum'),
  Vocabulaire(latin: 'confero, confers, conferre, contuli, collatum', francais: '1. porter ensemble, réunir 2. comparer (à)', unite: 'Vol. II – Unité 7', categorie: 'Verbes', etymologie: 'conférence, collation'),
  Vocabulaire(latin: 'conjicio, is, ere, -jeci, jectum', francais: 'jeter ensemble', unite: 'Vol. II – Unité 7', categorie: 'Verbes', etymologie: '< cum + jacio'),
  Vocabulaire(latin: 'desino, is, ere, desii, desitum + acc. ; desinere + inf.', francais: 'laisser, cesser, mettre un terme à ; cesser de', unite: 'Vol. II – Unité 7', categorie: 'Verbes', etymologie: 'désinence'),
  Vocabulaire(latin: 'differo, differs, differre, distuli, dilatum', francais: '1. disperser 2. différer, remettre à plus tard 3. être différent, différer de', unite: 'Vol. II – Unité 7', categorie: 'Verbes', etymologie: 'différence'),
  Vocabulaire(latin: 'discedo, is, ere, -cessi, -cessum (+ abl.)', francais: 's\'éloigner (de), se séparer (de), se retirer (de)', unite: 'Vol. II – Unité 7', categorie: 'Verbes'),
  Vocabulaire(latin: 'doceo, es, ere, docui, doctum ; docere + 2 acc.', francais: 'enseigner, instruire ; enseigner qqch. à qqn', unite: 'Vol. II – Unité 7', categorie: 'Verbes', etymologie: 'docte, docteur / ALL. Dozent / IT. docente, dottore'),
  Vocabulaire(latin: 'effero, -fers, -ferre, extuli, elatum', francais: '1. porter hors de, emporter 2. élever (en rang)', unite: 'Vol. II – Unité 7', categorie: 'Verbes'),
  Vocabulaire(latin: 'fero, fers, ferre, tuli, latum ; ferre + ACI', francais: '1. porter 2. supporter 3. rapporter que', unite: 'Vol. II – Unité 7', categorie: 'Verbes'),
  Vocabulaire(latin: 'infero, infers, inferre, intuli, illatum', francais: 'porter dans, inspirer ; porter contre', unite: 'Vol. II – Unité 7', categorie: 'Verbes'),
  Vocabulaire(latin: 'noceo, es, ere, nocui, nocitum (+ dat.)', francais: 'nuire (à qqn)', unite: 'Vol. II – Unité 7', categorie: 'Verbes', etymologie: 'nocif'),
  Vocabulaire(latin: 'offero, offers, offerre, obtuli, oblatum', francais: '1. présenter 2. offrir', unite: 'Vol. II – Unité 7', categorie: 'Verbes'),
  Vocabulaire(latin: 'perfero, perfers, perferre, pertuli, perlatum', francais: '(sup)porter jusqu\'au bout', unite: 'Vol. II – Unité 7', categorie: 'Verbes'),
  Vocabulaire(latin: 'probo, as, are, avi, atum', francais: '1. éprouver, vérifier 2. approuver, apprécier 3. prouver', unite: 'Vol. II – Unité 7', categorie: 'Verbes', etymologie: 'ESP. probar, prueba'),
  Vocabulaire(latin: 'profero, profers, proferre, protuli, prolatum', francais: 'porter en avant, présenter', unite: 'Vol. II – Unité 7', categorie: 'Verbes'),
  Vocabulaire(latin: 'refero, refers, referre, re(t)tuli, relatum ; referre + ACI', francais: '1. porter en arrière, rapporter, ramener 2. rapporter que 3. faire un rapport sur', unite: 'Vol. II – Unité 7', categorie: 'Verbes'),
  Vocabulaire(latin: 'specto, as, are, avi, atum', francais: 'regarder, observer, contempler', unite: 'Vol. II – Unité 7', categorie: 'Verbes', etymologie: 'spectaculum'),

  Vocabulaire(latin: 'gén. + causa', francais: 'à cause de ; en vue de, pour', unite: 'Vol. II – Unité 7', categorie: 'Prépositions'),
  Vocabulaire(latin: 'circa + acc.', francais: 'autour de ; dans l\'entourage / le voisinage de', unite: 'Vol. II – Unité 7', categorie: 'Prépositions'),
  Vocabulaire(latin: 'contra + acc.', francais: '1. contrairement à [mores] 2. contre [hostes]', unite: 'Vol. II – Unité 7', categorie: 'Prépositions'),

  Vocabulaire(latin: 'circa (adv.)', francais: 'autour', unite: 'Vol. II – Unité 7', categorie: 'Mots-outils', etymologie: 'circonstances, circonscrire'),
  Vocabulaire(latin: 'contra (adv.)', francais: 'au contraire', unite: 'Vol. II – Unité 7', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'cum / ut / ubi primum (+ ind.)', francais: 'dès que', unite: 'Vol. II – Unité 7', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'dum + ind. prés.', francais: 'pendant que (+ ind.)', unite: 'Vol. II – Unité 7', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'dum + ind.', francais: 'jusqu\'au moment où (+ ind.)', unite: 'Vol. II – Unité 7', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'inde', francais: 'de là, de ce lieu, en', unite: 'Vol. II – Unité 7', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'male', francais: 'mal', unite: 'Vol. II – Unité 7', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'quemadmodum', francais: 'de même que, comme', unite: 'Vol. II – Unité 7', categorie: 'Mots-outils', etymologie: '< ad quem (= eum) modum'),
  Vocabulaire(latin: 'umquam / unquam (neque umquam / unquam)', francais: 'un jour, quelquefois ; et jamais ... ne', unite: 'Vol. II – Unité 7', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. II – UNITÉ 8
  // ==========================================================

  Vocabulaire(latin: 'anima, ae, f.', francais: 'souffle, âme', unite: 'Vol. II – Unité 8', categorie: 'Noms', etymologie: 'animation, animer'),
  Vocabulaire(latin: 'carmen, inis, n.', francais: '1. chant 2. poème, composition en vers 3. parole magique, formule religieuse', unite: 'Vol. II – Unité 8', categorie: 'Noms', etymologie: 'charme, charmant, Carmen / Carmina Burana'),
  Vocabulaire(latin: 'certamen, inis, n.', francais: 'action de se mesurer à un adversaire, lutte', unite: 'Vol. II – Unité 8', categorie: 'Noms', etymologie: 'Certamen Ciceronianum Arpinas'),
  Vocabulaire(latin: 'concursus, us, m.', francais: 'rencontre, choc ; (ici) concurrence', unite: 'Vol. II – Unité 8', categorie: 'Noms', etymologie: 'concours'),
  Vocabulaire(latin: 'contentio, onis, f.', francais: '1. rivalité, conflit 2. comparaison', unite: 'Vol. II – Unité 8', categorie: 'Noms', etymologie: 'ANGL. contest'),
  Vocabulaire(latin: 'contumelia, ae, f. (contumelias jacere in + acc.)', francais: 'outrage, injure (outrager qqn, injurier qqn)', unite: 'Vol. II – Unité 8', categorie: 'Noms'),
  Vocabulaire(latin: 'crux, crucis, f. (in cruce figi)', francais: 'croix, gibet (être crucifié)', unite: 'Vol. II – Unité 8', categorie: 'Noms', etymologie: 'crucifixion'),
  Vocabulaire(latin: 'dolus, i, m.', francais: 'ruse', unite: 'Vol. II – Unité 8', categorie: 'Noms', etymologie: 'Dolus an virtus, quis in hoste requirat ?'),
  Vocabulaire(latin: 'invidia, ae, f. (in invidia esse apud + acc.)', francais: '1. malveillance, hostilité, haine 2. jalousie, envie (être la cible de la jalousie de qqn)', unite: 'Vol. II – Unité 8', categorie: 'Noms', etymologie: 'ANGL. envy'),
  Vocabulaire(latin: 'judex, icis, m.', francais: 'juge', unite: 'Vol. II – Unité 8', categorie: 'Noms'),
  Vocabulaire(latin: 'lucrum, i, n.', francais: 'gain, profit, avantage', unite: 'Vol. II – Unité 8', categorie: 'Noms', etymologie: 'lucratif > a.s.b.l.'),
  Vocabulaire(latin: 'oculus, i, m.', francais: 'œil', unite: 'Vol. II – Unité 8', categorie: 'Noms', etymologie: 'oculiste, oculaire'),
  Vocabulaire(latin: 'tabella, ae, f.', francais: '1. petite planche 2. tablette de jeu, de vote 3. tablette (à écrire) 4. tablette votive', unite: 'Vol. II – Unité 8', categorie: 'Noms'),
  Vocabulaire(latin: 'venefica, ae, f.', francais: 'magicienne, sorcière', unite: 'Vol. II – Unité 8', categorie: 'Noms', etymologie: '< venenum + facere'),
  Vocabulaire(latin: 'venenum, i, n.', francais: 'poison', unite: 'Vol. II – Unité 8', categorie: 'Noms', etymologie: 'venin, venimeux, envenimer'),
  Vocabulaire(latin: 'visus, us, m.', francais: '1. action/faculté de voir, vue 2. aspect, apparence', unite: 'Vol. II – Unité 8', categorie: 'Noms'),
  Vocabulaire(latin: 'vox, vocis, f.', francais: 'voix', unite: 'Vol. II – Unité 8', categorie: 'Noms', etymologie: 'vocal, vociférer'),

  Vocabulaire(latin: 'brevis, e', francais: 'court, bref', unite: 'Vol. II – Unité 8', categorie: 'Adjectifs', etymologie: 'ars longa, vita brevis'),
  Vocabulaire(latin: 'calidus, a, um', francais: 'chaud', unite: 'Vol. II – Unité 8', categorie: 'Adjectifs', etymologie: 'caldarium / ESP. cálido / IT. caldo'),
  Vocabulaire(latin: 'celer, celeris, celere', francais: 'rapide', unite: 'Vol. II – Unité 8', categorie: 'Adjectifs', etymologie: 'célérité (E = mc²)'),
  Vocabulaire(latin: 'faustus, a, um', francais: 'heureux, favorable, prospère', unite: 'Vol. II – Unité 8', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'frigidus, a, um', francais: 'froid', unite: 'Vol. II – Unité 8', categorie: 'Adjectifs', etymologie: 'frigidarium / réfrigérateur, frigorifier'),
  Vocabulaire(latin: 'opulentus, a, um', francais: '1. qui a beaucoup de moyens, riche 2. magnifique, somptueux', unite: 'Vol. II – Unité 8', categorie: 'Adjectifs', etymologie: 'opulent'),
  Vocabulaire(latin: 'piger, pigra, pigrum ≠ impiger, gra, grum', francais: 'paresseux, indolent ≠ infatigable, actif', unite: 'Vol. II – Unité 8', categorie: 'Adjectifs', etymologie: 'pigritia'),
  Vocabulaire(latin: 'solitus, a, um', francais: 'habituel, ordinaire', unite: 'Vol. II – Unité 8', categorie: 'Adjectifs', etymologie: '< soleo / insolite'),
  Vocabulaire(latin: 'tantus, a, um', francais: 'si grand (conséquence), aussi grand (comparaison)', unite: 'Vol. II – Unité 8', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'tot (invar.)', francais: 'tant de ... (= tam multi, ae, a)', unite: 'Vol. II – Unité 8', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'vicinus, a, um', francais: 'voisin', unite: 'Vol. II – Unité 8', categorie: 'Adjectifs', etymologie: 'chemin vicinal'),

  Vocabulaire(latin: 'adspicio / conspicio, is, ere, -spexi, -spectum', francais: 'apercevoir, regarder, examiner', unite: 'Vol. II – Unité 8', categorie: 'Verbes', etymologie: '< ad + spicere'),
  Vocabulaire(latin: 'carpo, is, ere, carpsi, carptum', francais: '1. arracher, détacher, cueillir 2. (fig.) déchirer, affaiblir', unite: 'Vol. II – Unité 8', categorie: 'Verbes', etymologie: 'Carpe diem !'),
  Vocabulaire(latin: 'edo, edis, edere (/ esse), edi, esum', francais: 'manger', unite: 'Vol. II – Unité 8', categorie: 'Verbes', etymologie: 'canis canem edit'),
  Vocabulaire(latin: 'figo, is, ere, fixi, fixum', francais: '1. ficher, enfoncer, fixer 2. attacher', unite: 'Vol. II – Unité 8', categorie: 'Verbes', etymologie: 'crucifixion'),
  Vocabulaire(latin: 'impedio, is, ire, -pedivi / -pedii, -peditum (ne + subj.)', francais: 'entraver, empêcher, arrêter (que ne)', unite: 'Vol. II – Unité 8', categorie: 'Verbes', etymologie: 'ANGL. impediment'),
  Vocabulaire(latin: 'jacio, is, ere, jeci, jactum', francais: 'jeter, lancer', unite: 'Vol. II – Unité 8', categorie: 'Verbes'),
  Vocabulaire(latin: 'prodo, is, ere, -didi, -ditum', francais: '1. présenter 2. trahir', unite: 'Vol. II – Unité 8', categorie: 'Verbes', etymologie: '< pro + dare'),
  Vocabulaire(latin: 'pungo, is, ere, pupugi, punctum', francais: '1. piquer 2. tourmenter, faire souffrir', unite: 'Vol. II – Unité 8', categorie: 'Verbes', etymologie: 'point / ALL. Punkt'),
  Vocabulaire(latin: 'reperio, is, ire, rep(p)eri, repertum', francais: 'trouver (après recherche), découvrir', unite: 'Vol. II – Unité 8', categorie: 'Verbes', etymologie: 'repérer, repère, répertoire'),
  Vocabulaire(latin: 'tango, is, ere, tetigi, tactum', francais: 'toucher', unite: 'Vol. II – Unité 8', categorie: 'Verbes', etymologie: 'tactile, contact, intact, tangible'),
  Vocabulaire(latin: 'vindico, as, are, avi, atum', francais: '1. revendiquer 2. venger, punir', unite: 'Vol. II – Unité 8', categorie: 'Verbes', etymologie: 'vindicatif'),

  Vocabulaire(latin: 'adeo ... ut (non) + subj. ; ita ... ut ; sic ... ut', francais: 'tellement / de telle sorte ... que (ne pas)', unite: 'Vol. II – Unité 8', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'tam (+ adj./adv.) ... ut (non) + subj.', francais: 'si / tellement (+ adj./adv.) ... que (ne pas)', unite: 'Vol. II – Unité 8', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'ut (non) + subj. (consécutif)', francais: 'que (ne pas)', unite: 'Vol. II – Unité 8', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'ut + subj. (final) ; ne + subj.', francais: 'pour que ; afin que ; pour que ne pas, de peur que', unite: 'Vol. II – Unité 8', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. II – UNITÉ 9
  // ==========================================================

  Vocabulaire(latin: 'avus, i, m.', francais: 'aïeul, grand-père', unite: 'Vol. II – Unité 9', categorie: 'Noms', etymologie: 'PORT. avô'),
  Vocabulaire(latin: 'contio, onis, f. (contionem habere apud + acc.)', francais: '1. assemblée du peuple ou des soldats 2. harangue, discours (prononcer un discours auprès de)', unite: 'Vol. II – Unité 9', categorie: 'Noms'),
  Vocabulaire(latin: 'jus, juris, n.', francais: 'droit', unite: 'Vol. II – Unité 9', categorie: 'Noms', etymologie: 'sui juris esse / jurisprudence, juriste / ALL. Jura'),
  Vocabulaire(latin: 'minae, arum, f. pl.', francais: 'menaces', unite: 'Vol. II – Unité 9', categorie: 'Noms'),
  Vocabulaire(latin: 'quies, quietis, f.', francais: 'repos, calme', unite: 'Vol. II – Unité 9', categorie: 'Noms', etymologie: 'quiétude, inquiétude'),
  Vocabulaire(latin: 'tributum, i, n.', francais: 'taxe, impôt, tribut, contribution', unite: 'Vol. II – Unité 9', categorie: 'Noms', etymologie: 'attribution / ALL. Tribut'),

  Vocabulaire(latin: 'alienus, a, um', francais: 'étranger, d\'autrui', unite: 'Vol. II – Unité 9', categorie: 'Adjectifs', etymologie: 'aliéner / ANGL. alien'),
  Vocabulaire(latin: 'alius, alia, aliud', francais: 'l\'un (de plus de deux), un autre', unite: 'Vol. II – Unité 9', categorie: 'Adjectifs', etymologie: 'alter ego, alternance, altérité'),
  Vocabulaire(latin: 'alter, altera, alterum', francais: 'l\'un (de deux), l\'autre (de deux), le second', unite: 'Vol. II – Unité 9', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'neuter, neutra, neutrum', francais: 'aucun (des deux), ni l\'un, ni l\'autre', unite: 'Vol. II – Unité 9', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'uter, utra, utrum ?', francais: 'lequel (des deux) ?', unite: 'Vol. II – Unité 9', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'uterque, utraque, utrumque', francais: 'l\'un et l\'autre, (tous) les deux', unite: 'Vol. II – Unité 9', categorie: 'Adjectifs'),

  Vocabulaire(latin: 'abeo, is, ire, -ii, -itum (a(b) + abl.)', francais: 's\'éloigner (de), s\'en aller, partir (de)', unite: 'Vol. II – Unité 9', categorie: 'Verbes'),
  Vocabulaire(latin: 'adeo, is, ire, -ii, -itum + acc. ou ad + acc.', francais: 'aller vers, s\'approcher de qqch. / qqn, aborder qqn', unite: 'Vol. II – Unité 9', categorie: 'Verbes'),
  Vocabulaire(latin: 'compono, is, ere, -posui, -positum', francais: '1. placer ensemble 2. composer 3. mettre en accord, régler 4. mettre en ordre, disposer', unite: 'Vol. II – Unité 9', categorie: 'Verbes', etymologie: 'décomposer, recomposer, composition'),
  Vocabulaire(latin: 'exeo, exis, exire, exii, exitum (+ e(x) + abl.)', francais: 'sortir (de), partir (de)', unite: 'Vol. II – Unité 9', categorie: 'Verbes', etymologie: 'ANGL. exit'),
  Vocabulaire(latin: 'ineo, is, ire, -ii, -itum + acc. ou in + acc.', francais: '1. aller dans 2. commencer, entamer 3. entrer dans, entreprendre', unite: 'Vol. II – Unité 9', categorie: 'Verbes'),
  Vocabulaire(latin: 'inquit', francais: 'dit-il, dit-elle (proposition incise)', unite: 'Vol. II – Unité 9', categorie: 'Verbes'),
  Vocabulaire(latin: 'intereo, is, ire, -ii, -itum', francais: 'périr, disparaître, mourir', unite: 'Vol. II – Unité 9', categorie: 'Verbes'),
  Vocabulaire(latin: 'pello, is, ere, pepuli, pulsum', francais: 'pousser, repousser, chasser', unite: 'Vol. II – Unité 9', categorie: 'Verbes', etymologie: 'pulsion, pouls, impulsif'),
  Vocabulaire(latin: 'pereo, is, ire, perii, peritum', francais: 'mourir, périr', unite: 'Vol. II – Unité 9', categorie: 'Verbes'),
  Vocabulaire(latin: 'redeo, is, ire, redii, reditum', francais: 'revenir', unite: 'Vol. II – Unité 9', categorie: 'Verbes'),
  Vocabulaire(latin: 'transeo, is, ire, -ii, -itum + acc. ou per + acc.', francais: '1. aller au-delà (de), passer (qqch.) 2. traverser, franchir', unite: 'Vol. II – Unité 9', categorie: 'Verbes', etymologie: 'transir'),
  Vocabulaire(latin: 'valeo, es, ere, valui', francais: '1. être fort, vigoureux 2. être puissant, avoir de la valeur 3. se bien porter', unite: 'Vol. II – Unité 9', categorie: 'Verbes', etymologie: 'ESP. vale'),

  Vocabulaire(latin: 'an ; -ne ... an / Utrum ... an', francais: '... ou est-ce que ...', unite: 'Vol. II – Unité 9', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'donec + subj.', francais: 'jusqu\'à ce que + subj.', unite: 'Vol. II – Unité 9', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'forte', francais: 'par hasard, d\'aventure', unite: 'Vol. II – Unité 9', categorie: 'Mots-outils', etymologie: 'abl. sg. de fors, hasard, fortune'),
  Vocabulaire(latin: 'jure', francais: 'à bon droit, à juste titre', unite: 'Vol. II – Unité 9', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'nuper', francais: 'récemment', unite: 'Vol. II – Unité 9', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'ea (adv. de lieu)', francais: 'par là (réponse à Qua ?)', unite: 'Vol. II – Unité 9', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'eo (adv. de lieu)', francais: 'là, y, avec mouvement (réponse à Quo ?)', unite: 'Vol. II – Unité 9', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. II – UNITÉ 10
  // ==========================================================

  Vocabulaire(latin: 'cella, ae, f.', francais: '1. grenier, magasin 2. petite chambre 3. sanctuaire (partie du temple)', unite: 'Vol. II – Unité 10', categorie: 'Noms', etymologie: 'cellule, ALL. die Zelle'),
  Vocabulaire(latin: 'cor, cordis, n.', francais: 'cœur (siège du sentiment)', unite: 'Vol. II – Unité 10', categorie: 'Noms', etymologie: 'concorde, discorde, cordial'),
  Vocabulaire(latin: 'dispositio, onis, f.', francais: 'disposition, arrangement', unite: 'Vol. II – Unité 10', categorie: 'Noms', etymologie: '< dispono'),
  Vocabulaire(latin: 'domina, ae, f.', francais: 'maîtresse (de maison)', unite: 'Vol. II – Unité 10', categorie: 'Noms'),
  Vocabulaire(latin: 'epulae, arum, f. pl.', francais: '1. mets, aliment, nourriture 2. repas, festin, banquet', unite: 'Vol. II – Unité 10', categorie: 'Noms'),
  Vocabulaire(latin: 'praeceptum, i, n.', francais: 'précepte, leçon, instruction, recommandation', unite: 'Vol. II – Unité 10', categorie: 'Noms', etymologie: 'un précepteur'),
  Vocabulaire(latin: 'Saturnalia, ium, n. pl.', francais: 'Saturnales — fêtes en l\'honneur de Saturne', unite: 'Vol. II – Unité 10', categorie: 'Noms'),
  Vocabulaire(latin: 'vates, is, m. (/ f.)', francais: '1. devin, prophète 2. poète', unite: 'Vol. II – Unité 10', categorie: 'Noms'),
  Vocabulaire(latin: 'vilicus, i, m. / vilica, ae, f.', francais: 'fermier, régisseur d\'une propriété rurale / fermière', unite: 'Vol. II – Unité 10', categorie: 'Noms'),
  Vocabulaire(latin: 'villa, ae, f. - villa rustica', francais: 'maison de campagne, propriété, ferme', unite: 'Vol. II – Unité 10', categorie: 'Noms'),

  Vocabulaire(latin: 'durus, a, um', francais: '1. dur, ferme 2. âpre, rude 3. dur, grossier 4. dur, sévère 5. difficile, pénible', unite: 'Vol. II – Unité 10', categorie: 'Adjectifs'),

  Vocabulaire(latin: 'admoneo, es, ere, -monui, -monitum', francais: 'faire souvenir, rappeler ; avertir ; admonester', unite: 'Vol. II – Unité 10', categorie: 'Verbes', etymologie: 'admonestation'),
  Vocabulaire(latin: 'amitto, is, ere, -misi, -missum', francais: '1. laisser à l\'abandon, perdre (volontairement) 2. laisser s\'échapper, perdre (involontairement)', unite: 'Vol. II – Unité 10', categorie: 'Verbes', etymologie: '< a + mitto'),
  Vocabulaire(latin: 'cano, is, ere, cecini, cantum', francais: 'chanter', unite: 'Vol. II – Unité 10', categorie: 'Verbes'),
  Vocabulaire(latin: 'concurro, is, ere, -curri, -cursum', francais: 'courir (ensemble), se rassembler (en masse)', unite: 'Vol. II – Unité 10', categorie: 'Verbes', etymologie: 'un concours, la concurrence'),
  Vocabulaire(latin: 'eligo, is, ere, -legi, -lectum', francais: 'choisir, élire', unite: 'Vol. II – Unité 10', categorie: 'Verbes', etymologie: 'élection / ESP. elegir / IT. eleggere'),
  Vocabulaire(latin: 'erro, as, are, avi, atum', francais: '1. aller çà et là, errer 2. faire fausse route, se tromper', unite: 'Vol. II – Unité 10', categorie: 'Verbes', etymologie: 'erreur, aberration / ANGL. et ESP. error / IT. errore / PORT. erro'),
  Vocabulaire(latin: 'malo, mavis, malle, malui', francais: 'préférer', unite: 'Vol. II – Unité 10', categorie: 'Verbes'),
  Vocabulaire(latin: 'nolo, non vis, nolle, nolui', francais: 'ne pas vouloir', unite: 'Vol. II – Unité 10', categorie: 'Verbes', etymologie: 'nolens, volens'),
  Vocabulaire(latin: 'nuntio, as, are, avi, atum (+ ACI)', francais: 'annoncer (que)', unite: 'Vol. II – Unité 10', categorie: 'Verbes'),
  Vocabulaire(latin: 'permaneo, es, ere, -mansi, -mansum', francais: 'demeurer jusqu\'au bout, rester de façon durable', unite: 'Vol. II – Unité 10', categorie: 'Verbes', etymologie: 'permanent, permanence / ESP. permanecer / IT. permanere'),
  Vocabulaire(latin: 'praecipio, is, ere, -cepi, -ceptum', francais: 'recommander, conseiller ; enseigner', unite: 'Vol. II – Unité 10', categorie: 'Verbes', etymologie: '< praeceptum, praeceptor'),
  Vocabulaire(latin: 'reprehendo, is, ere, -di, -sum', francais: 'critiquer, blâmer', unite: 'Vol. II – Unité 10', categorie: 'Verbes'),
  Vocabulaire(latin: 'volo, vis, velle, volui', francais: 'vouloir', unite: 'Vol. II – Unité 10', categorie: 'Verbes'),

  Vocabulaire(latin: 'Eheu !', francais: 'ah, hélas (interjection de douleur)', unite: 'Vol. II – Unité 10', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'Io !', francais: 'Io ! (cri de joie dans les triomphes, les fêtes)', unite: 'Vol. II – Unité 10', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'longe', francais: '1. loin 2. de loin', unite: 'Vol. II – Unité 10', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'Quomodo ?', francais: 'De quelle manière ? Comment ?', unite: 'Vol. II – Unité 10', categorie: 'Mots-outils', etymologie: '< quo + modo'),

  // ==========================================================
  // VOL. III – UNITÉ 1
  // ==========================================================

  Vocabulaire(latin: 'Carthaginienses, ium, m. pl.', francais: 'les Carthaginois', unite: 'Vol. III – Unité 1', categorie: 'Noms'),
  Vocabulaire(latin: 'classis, is, f.', francais: '1. division du peuple romain, classe 2. classe, groupe 3. flotte (f.)', unite: 'Vol. III – Unité 1', categorie: 'Noms'),
  Vocabulaire(latin: 'cognitio, onis, f.', francais: '1. enquête 2. connaissance, étude', unite: 'Vol. III – Unité 1', categorie: 'Noms', etymologie: '< cognosco / cognitif'),
  Vocabulaire(latin: 'consuetudo, inis, f.', francais: 'habitude, coutume, usage', unite: 'Vol. III – Unité 1', categorie: 'Noms', etymologie: '< consuesco / ESP. costumbre'),
  Vocabulaire(latin: 'discipulus, i, m.', francais: 'disciple, élève', unite: 'Vol. III – Unité 1', categorie: 'Noms', etymologie: '< disco / discipline / ESP. discípulo / IT. discepolo'),
  Vocabulaire(latin: 'fames, is, f.', francais: 'faim', unite: 'Vol. III – Unité 1', categorie: 'Noms', etymologie: 'famélique, famine'),
  Vocabulaire(latin: 'gravitas, atis, f.', francais: '1. pesanteur, lourdeur 2. importance, poids ; gravité, dignité, sérieux, rigueur', unite: 'Vol. III – Unité 1', categorie: 'Noms', etymologie: '< gravis'),
  Vocabulaire(latin: 'lectio, onis, f.', francais: 'lecture (texte à lire / lu)', unite: 'Vol. III – Unité 1', categorie: 'Noms', etymologie: '< lego / leçon'),
  Vocabulaire(latin: 'magister, tri, m. ≠ minister, tri, m.', francais: '1. maître, directeur 2. maître d\'école ≠ serviteur', unite: 'Vol. III – Unité 1', categorie: 'Noms', etymologie: 'magistral'),
  Vocabulaire(latin: 'principium, i, n.', francais: 'commencement, début', unite: 'Vol. III – Unité 1', categorie: 'Noms', etymologie: '< princeps / principe, principal'),
  Vocabulaire(latin: 'Poeni, orum, m. pl. / Poenus, i, m.', francais: 'les Carthaginois / Hannibal (par antonomase)', unite: 'Vol. III – Unité 1', categorie: 'Noms', etymologie: 'emprunt du grec Phoenix « Phénicien »'),
  Vocabulaire(latin: 'sitis, is, f. (acc. sitim, abl. siti)', francais: 'soif', unite: 'Vol. III – Unité 1', categorie: 'Noms', etymologie: 'IT. sete / PORT. sede'),
  Vocabulaire(latin: 'volumen, inis, n.', francais: 'volume d\'un manuscrit, manuscrit, livre, ouvrage', unite: 'Vol. III – Unité 1', categorie: 'Noms', etymologie: '< volvo (tourner, rouler) / volumineux'),

  Vocabulaire(latin: 'dignus, a, um (+ abl.)', francais: 'digne (de)', unite: 'Vol. III – Unité 1', categorie: 'Adjectifs', etymologie: 's\'indigner, dignité'),
  Vocabulaire(latin: 'mirus, a, um', francais: 'étonnant, admirable', unite: 'Vol. III – Unité 1', categorie: 'Adjectifs', etymologie: 'miracle, admirer, admirable'),
  Vocabulaire(latin: 'par, paris (+ dat.)', francais: 'pareil, semblable (à)', unite: 'Vol. III – Unité 1', categorie: 'Adjectifs', etymologie: 'primus inter pares'),
  Vocabulaire(latin: 'plenus, a, um + gén.', francais: 'plein de, rempli de', unite: 'Vol. III – Unité 1', categorie: 'Adjectifs', etymologie: 'IT. pieno / ROUM. plin / ESP. lleno'),
  Vocabulaire(latin: 'Punicus, a, um', francais: 'de Carthage, punique', unite: 'Vol. III – Unité 1', categorie: 'Adjectifs', etymologie: 'Punica granatum'),
  Vocabulaire(latin: 'utilis, e', francais: 'utile', unite: 'Vol. III – Unité 1', categorie: 'Adjectifs'),

  Vocabulaire(latin: 'certo, as, are, avi, atum (cum + abl.)', francais: 'lutter, combattre, rivaliser (contre)', unite: 'Vol. III – Unité 1', categorie: 'Verbes', etymologie: 'certamen'),
  Vocabulaire(latin: 'arma / signa conferre (cum + abl.)', francais: 'engager le combat (contre)', unite: 'Vol. III – Unité 1', categorie: 'Verbes'),
  Vocabulaire(latin: 'fio, fis, fieri, factus sum + attr. du S', francais: '1. être fait 2. se produire, arriver 3. devenir', unite: 'Vol. III – Unité 1', categorie: 'Verbes'),
  Vocabulaire(latin: 'perficio, is, ere, -feci, féctum', francais: 'achever, parfaire', unite: 'Vol. III – Unité 1', categorie: 'Verbes', etymologie: '< per + facio'),
  Vocabulaire(latin: 'studeo, es, ere, -ui (+ dat.)', francais: '1. s\'appliquer (à), s\'attacher (à) 2. s\'intéresser (à)', unite: 'Vol. III – Unité 1', categorie: 'Verbes', etymologie: 'studieux / ALL. studieren / ANGL. study'),

  Vocabulaire(latin: 'cum ... tum ...', francais: 'd\'une part ..., d\'autre part (surtout) ; quand ..., alors ...', unite: 'Vol. III – Unité 1', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'dum + subj.', francais: 'jusqu\'à ce que, en attendant que ; pourvu que', unite: 'Vol. III – Unité 1', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'prope (adv.)', francais: 'près ; presque, à peu près', unite: 'Vol. III – Unité 1', categorie: 'Mots-outils', etymologie: 'propinquus, a, um'),
  Vocabulaire(latin: '-ve', francais: 'ou, ou bien [pater materve]', unite: 'Vol. III – Unité 1', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. III – UNITÉ 2
  // ==========================================================

  Vocabulaire(latin: 'aliquis, aliqua, aliquid / quis, quae, quid', francais: 'quelqu\'un, quelque chose (que l\'on ne connaît pas) ; après si, nisi, ne, num, dum, cum', unite: 'Vol. III – Unité 2', categorie: 'Noms & pronoms'),
  Vocabulaire(latin: 'imago, inis, f.', francais: '1. représentation, portrait 2. portrait d\'ancêtre 3. image, copie', unite: 'Vol. III – Unité 2', categorie: 'Noms & pronoms', etymologie: 'ANGL. image'),
  Vocabulaire(latin: 'juniores, um, m. pl.', francais: 'les plus jeunes (17-45 ans) ; l\'armée active', unite: 'Vol. III – Unité 2', categorie: 'Noms & pronoms'),
  Vocabulaire(latin: 'lux, lucis, f. (ante lucem)', francais: 'lumière (« avant la lumière » = avant le jour, à l\'aube)', unite: 'Vol. III – Unité 2', categorie: 'Noms & pronoms', etymologie: 'Fiat lux ! / luciole, Lucifer / IT. luce'),
  Vocabulaire(latin: 'numen, inis, n.', francais: '1. mouvement de la tête manifestant la volonté 2. divinité', unite: 'Vol. III – Unité 2', categorie: 'Noms & pronoms', etymologie: '< nuo (faire un mouvement de la tête)'),
  Vocabulaire(latin: 'quidam, quaedam, quiddam', francais: 'un certain homme, quelqu\'un, quelque chose (que l\'on pourrait préciser)', unite: 'Vol. III – Unité 2', categorie: 'Noms & pronoms'),
  Vocabulaire(latin: 'seniores, um, m. pl.', francais: 'les plus âgés (45-60 ans) ; la réserve', unite: 'Vol. III – Unité 2', categorie: 'Noms & pronoms'),
  Vocabulaire(latin: 'supplicium, i, n.', francais: 'punition, peine, châtiment, supplice', unite: 'Vol. III – Unité 2', categorie: 'Noms & pronoms'),

  Vocabulaire(latin: 'aliqui(s), aliqua, aliquod / qui, qua, quod', francais: 'quelque ... ; après si, nisi, ne, num, dum, cum', unite: 'Vol. III – Unité 2', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'imperitus, a, um', francais: 'ignorant, inexpérimenté, mal informé', unite: 'Vol. III – Unité 2', categorie: 'Adjectifs', etymologie: '< in + peritus'),
  Vocabulaire(latin: 'junior, oris', francais: 'le plus jeune (de deux)', unite: 'Vol. III – Unité 2', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'niger, nigra, nigrum', francais: 'noir', unite: 'Vol. III – Unité 2', categorie: 'Adjectifs', etymologie: 'Porta Nigra'),
  Vocabulaire(latin: 'peregrinus, a, um', francais: 'de l\'étranger, étranger', unite: 'Vol. III – Unité 2', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'peritus, a, um (+ gén.)', francais: 'qui s\'y connaît (en) ; expérimenté, connaisseur', unite: 'Vol. III – Unité 2', categorie: 'Adjectifs', etymologie: 'vir bonus dicendi peritus'),
  Vocabulaire(latin: 'quidam, quaedam, quoddam', francais: 'un certain ..., une certaine ... (que l\'on pourrait préciser)', unite: 'Vol. III – Unité 2', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'senior, oris', francais: 'le plus âgé (de deux)', unite: 'Vol. III – Unité 2', categorie: 'Adjectifs'),

  Vocabulaire(latin: 'careo, es, ere, carui (+ abl.)', francais: 'manquer (de), être privé (de), être sans', unite: 'Vol. III – Unité 2', categorie: 'Verbes', etymologie: 'carence'),
  Vocabulaire(latin: 'consto, as, are, constiti ; (satis) constat + inf. / + ACI', francais: 'il est (bien) établi que', unite: 'Vol. III – Unité 2', categorie: 'Verbes', etymologie: 'constater'),
  Vocabulaire(latin: 'desero, is, ere, -serui, -sertum', francais: 'abandonner', unite: 'Vol. III – Unité 2', categorie: 'Verbes', etymologie: 'déserter, désert'),
  Vocabulaire(latin: 'dimitto, is, ere, -misi, -missum', francais: 'envoyer de côté et d\'autre, renvoyer, congédier ; (fig.) renoncer', unite: 'Vol. III – Unité 2', categorie: 'Verbes', etymologie: 'démettre, démission'),
  Vocabulaire(latin: 'dubito, as, are, avi, atum (de + abl.) ; dubitare + inf.', francais: 'avoir des doutes (sur), douter (de qqch.) ; hésiter à', unite: 'Vol. III – Unité 2', categorie: 'Verbes'),
  Vocabulaire(latin: 'nego, as, are, avi, atum ; negare + ACI', francais: 'nier [scelus], refuser ; dire que ... ne ... pas', unite: 'Vol. III – Unité 2', categorie: 'Verbes', etymologie: 'négatif, négation'),
  Vocabulaire(latin: 'quaero, is, ere, quaesivi, quaesitum', francais: '1. chercher 2. chercher à savoir, demander (qqch. à qqn)', unite: 'Vol. III – Unité 2', categorie: 'Verbes', etymologie: 'quérir, question, quête'),
  Vocabulaire(latin: 'rejicio, is, ere, -jeci, -rectum', francais: '1. rejeter, jeter en retour / en arrière 2. rejeter, repousser, éloigner 3. ne pas admettre', unite: 'Vol. III – Unité 2', categorie: 'Verbes', etymologie: '< re + jacio'),
  Vocabulaire(latin: 'veto, as, are, vetui, vetitum', francais: 'interdire, défendre', unite: 'Vol. III – Unité 2', categorie: 'Verbes', etymologie: 'droit de véto'),

  Vocabulaire(latin: 'ultra + acc.', francais: 'au-delà de, de l\'autre côté de', unite: 'Vol. III – Unité 2', categorie: 'Prépositions'),

  Vocabulaire(latin: 'heri', francais: 'hier', unite: 'Vol. III – Unité 2', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'immo vero', francais: 'et même ; voire ; bien plus', unite: 'Vol. III – Unité 2', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'nihil (emploi adverbial)', francais: 'en rien ; absolument pas', unite: 'Vol. III – Unité 2', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'quasi / quam si (+ subj.)', francais: 'comme, pour ainsi dire ; comme si', unite: 'Vol. III – Unité 2', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'tamquam (adv.)', francais: '1. comme, de même que 2. pour ainsi dire', unite: 'Vol. III – Unité 2', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'ultra (adv.)', francais: '1. de l\'autre côté 2. plus loin', unite: 'Vol. III – Unité 2', categorie: 'Mots-outils', etymologie: 'nec plus ultra'),

  // ==========================================================
  // VOL. III – UNITÉ 3
  // ==========================================================

  Vocabulaire(latin: 'arbor, oris, f.', francais: 'arbre', unite: 'Vol. III – Unité 3', categorie: 'Noms & pronoms'),
  Vocabulaire(latin: 'luctus, us, m.', francais: 'douleur, chagrin, détresse, deuil (pl. crises d\'affliction)', unite: 'Vol. III – Unité 3', categorie: 'Noms & pronoms'),
  Vocabulaire(latin: 'maeror, oris, m.', francais: 'tristesse, affliction profonde (avec signes extérieurs)', unite: 'Vol. III – Unité 3', categorie: 'Noms & pronoms'),
  Vocabulaire(latin: 'motus, us, m. (motus animi / mentis)', francais: 'mouvement (mouvement de l\'esprit / de l\'âme, émotion)', unite: 'Vol. III – Unité 3', categorie: 'Noms & pronoms', etymologie: '< moveo'),
  Vocabulaire(latin: 'peregrinatio, onis, f.', francais: 'voyage', unite: 'Vol. III – Unité 3', categorie: 'Noms & pronoms', etymologie: '< peregrinus, a, um'),
  Vocabulaire(latin: 'Quid ? (emploi adverbial)', francais: 'En quoi ? En vue de quoi ? Pourquoi ?', unite: 'Vol. III – Unité 3', categorie: 'Noms & pronoms'),

  Vocabulaire(latin: 'extremus, a, um', francais: '1. le plus éloigné, le dernier ; extrême 2. l\'extrémité de', unite: 'Vol. III – Unité 3', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'per- (+ adjectif)', francais: '= superlatif absolu : très, tout à fait', unite: 'Vol. III – Unité 3', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'reliquus, a, um', francais: '... qui reste ; le reste de ...', unite: 'Vol. III – Unité 3', categorie: 'Adjectifs'),

  Vocabulaire(latin: 'accedo, is, ere, -cessi, -cessum (ad + acc.) ; accedit ut + subj.', francais: 's\'approcher (de), aborder ; s\'ajouter (à) ; il arrive en outre que', unite: 'Vol. III – Unité 3', categorie: 'Verbes', etymologie: 'accès, accéder / ANGL. access'),
  Vocabulaire(latin: '(ad)juvo, as, are, juvi, jutum (+ acc.)', francais: 'aider, seconder (qqn) ; être utile', unite: 'Vol. III – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'aio, ais, ait', francais: 'dire', unite: 'Vol. III – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'audeo, es, ere, ausus sum (+ inf.)', francais: 'prendre sur soi (de), oser (faire qqch.)', unite: 'Vol. III – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'experior, iris, iri, expertus sum (+ acc.)', francais: '1. éprouver, mettre à l\'épreuve (qqch.) 2. essayer (qqch.), faire l\'expérience (de qqch.)', unite: 'Vol. III – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'gaudeo, es, ere, gavisus sum (+ abl.) / + ACI', francais: 'se réjouir (de qqch.) / que', unite: 'Vol. III – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'licet, licere, licuit + inf. / + dat. + inf.', francais: 'il est permis de / à qqn de / que', unite: 'Vol. III – Unité 3', categorie: 'Verbes', etymologie: 'Quod licet Iovi non licet bovi / licence'),
  Vocabulaire(latin: 'miror, aris, ari, atus sum', francais: 'admirer, s\'étonner', unite: 'Vol. III – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'morior, moreris, mori, mortuus sum', francais: 'mourir', unite: 'Vol. III – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'patior, pateris, pati, passus sum ; pati + ACI', francais: 'supporter, souffrir, permettre ; permettre que', unite: 'Vol. III – Unité 3', categorie: 'Verbes', etymologie: 'patient, patience'),
  Vocabulaire(latin: 'placeo, es, ere, placui, placitum + dat.', francais: 'plaire à (= delectare + acc.)', unite: 'Vol. III – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'proficiscor, proficisceris, proficisci, profectus sum', francais: 'se mettre en route, partir, s\'en aller', unite: 'Vol. III – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'queror, quereris, queri, questus sum (+ acc.)', francais: 'plaindre ; se plaindre (de)', unite: 'Vol. III – Unité 3', categorie: 'Verbes', etymologie: '> querela : querelle'),
  Vocabulaire(latin: 'revertor, eris, i, reversus um', francais: 'revenir, retourner', unite: 'Vol. III – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'sequor, eris, i, secutus sum', francais: 'suivre, poursuivre', unite: 'Vol. III – Unité 3', categorie: 'Verbes', etymologie: 'séquence'),
  Vocabulaire(latin: 'soleo, es, ere, solitus sum (+ inf.)', francais: 'avoir l\'habitude (de)', unite: 'Vol. III – Unité 3', categorie: 'Verbes', etymologie: '= consuevisse'),
  Vocabulaire(latin: 'utor, eris, i, usus sum (+ abl.)', francais: 'se servir (de), utiliser', unite: 'Vol. III – Unité 3', categorie: 'Verbes'),
  Vocabulaire(latin: 'vereor, eris, eri, veritus sum', francais: 'craindre, respecter', unite: 'Vol. III – Unité 3', categorie: 'Verbes'),

  Vocabulaire(latin: 'coram + abl.', francais: 'en présence de, devant', unite: 'Vol. III – Unité 3', categorie: 'Prépositions', etymologie: 'coram publico'),

  Vocabulaire(latin: 'adhuc (adv.)', francais: 'jusqu\'ici, jusqu\'à ce moment, jusqu\'alors ; encore', unite: 'Vol. III – Unité 3', categorie: 'Mots-outils', etymologie: '< ad + huc'),
  Vocabulaire(latin: 'coram (adv.)', francais: 'en présence, publiquement, ouvertement ; (ici) ensemble', unite: 'Vol. III – Unité 3', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'quam + superlatif', francais: 'le plus ... possible', unite: 'Vol. III – Unité 3', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. III – UNITÉ 4
  // ==========================================================

  Vocabulaire(latin: 'comitatus, us, m.', francais: 'escorte, cortège, suite', unite: 'Vol. III – Unité 4', categorie: 'Noms & pronoms'),
  Vocabulaire(latin: 'crimen, criminis, n. (in crimen vocare)', francais: 'accusation, chef d\'accusation, grief (mettre en accusation, accuser)', unite: 'Vol. III – Unité 4', categorie: 'Noms & pronoms'),
  Vocabulaire(latin: 'impedimentum, i, n.', francais: 'empêchement, entrave, obstacle ; (pl.) bagages du voyageur ou du soldat', unite: 'Vol. III – Unité 4', categorie: 'Noms & pronoms', etymologie: '< impedire'),
  Vocabulaire(latin: 'insidiae, arum, f. pl.', francais: 'embuscade, piège, guet-apens', unite: 'Vol. III – Unité 4', categorie: 'Noms & pronoms', etymologie: 'insidieux'),
  Vocabulaire(latin: 'tergum, i, n. (terga vertere)', francais: 'dos (tourner le dos, fuir)', unite: 'Vol. III – Unité 4', categorie: 'Noms & pronoms', etymologie: 'tergiverser'),

  Vocabulaire(latin: 'praesens, -entis ≠ absens, -entis', francais: 'qui est là personnellement, présent ≠ absent', unite: 'Vol. III – Unité 4', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'solemnis, e', francais: 'annuel', unite: 'Vol. III – Unité 4', categorie: 'Adjectifs', etymologie: '< solus + annus / solennel'),

  Vocabulaire(latin: 'adorior, iris, iri, -ortus sum', francais: 'attaquer', unite: 'Vol. III – Unité 4', categorie: 'Verbes'),
  Vocabulaire(latin: 'orior, iris, iri, ortus sum', francais: '1. tirer son origine 2. se lever 3. commencer', unite: 'Vol. III – Unité 4', categorie: 'Verbes', etymologie: 'sol oriens = le soleil levant ≠ sol occidens = le soleil couchant'),
  Vocabulaire(latin: 'desidero, as, are, avi, atum', francais: '1. regretter (la perte de) 2. désirer vivement', unite: 'Vol. III – Unité 4', categorie: 'Verbes'),
  Vocabulaire(latin: 'eripio, is, ere, -ripui, -reptum', francais: 'tirer hors de, arracher, enlever', unite: 'Vol. III – Unité 4', categorie: 'Verbes', etymologie: '< ex + rapere'),
  Vocabulaire(latin: 'loquor, eris, i, locutus sum (de + abl., cum + abl.)', francais: 'parler (de qqch., à qqn), dire', unite: 'Vol. III – Unité 4', categorie: 'Verbes', etymologie: 'locution, élocution, interlocuteur'),
  Vocabulaire(latin: 'obeo, is, ire, obii, obitum (+ acc.)', francais: 'aller (vers), aller au-devant (de), à la rencontre (de)', unite: 'Vol. III – Unité 4', categorie: 'Verbes', etymologie: '< ob + ire'),
  Vocabulaire(latin: 'verto, is, ere, verti, versum', francais: 'tourner, faire tourner', unite: 'Vol. III – Unité 4', categorie: 'Verbes'),

  Vocabulaire(latin: 'prae + abl.', francais: '1. devant 2. en comparaison (de) 3. en raison (de)', unite: 'Vol. III – Unité 4', categorie: 'Prépositions'),

  Vocabulaire(latin: 'etiamsi / etsi', francais: 'même si (+ ind.), bien que (+ subj.)', unite: 'Vol. III – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'interim (adv.)', francais: 'entretemps', unite: 'Vol. III – Unité 4', categorie: 'Mots-outils', etymologie: 'un intérim'),
  Vocabulaire(latin: 'nisi / ni / si non', francais: 'si ... ne pas ; à moins que ne', unite: 'Vol. III – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'palam (adv.)', francais: 'ouvertement, publiquement', unite: 'Vol. III – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'partim (adv.)', francais: 'en partie', unite: 'Vol. III – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'pridie (adv.)', francais: 'la veille', unite: 'Vol. III – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'sive ... sive ... / seu ... seu ...', francais: 'soit que ... soit que ; que ... ou que ...', unite: 'Vol. III – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'utinam (ne) + subj.', francais: 'pourvu que (ne pas) ; ah, si seulement (ne pas)', unite: 'Vol. III – Unité 4', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'ut si / velut si', francais: 'comme si', unite: 'Vol. III – Unité 4', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. III – UNITÉ 5
  // ==========================================================

  Vocabulaire(latin: 'aedes, is, f. (aedes, ium, f. pl.)', francais: 'temple (maison, demeure)', unite: 'Vol. III – Unité 5', categorie: 'Noms', etymologie: 'cf. aedificare'),
  Vocabulaire(latin: 'aurum, i, n.', francais: 'or', unite: 'Vol. III – Unité 5', categorie: 'Noms', etymologie: 'tableau périodique des éléments : AU'),
  Vocabulaire(latin: 'injuria, ae, f.', francais: 'injustice', unite: 'Vol. III – Unité 5', categorie: 'Noms', etymologie: '< in privatif + jus'),
  Vocabulaire(latin: 'pulchritudo, inis, f.', francais: 'beauté', unite: 'Vol. III – Unité 5', categorie: 'Noms', etymologie: '< pulcher'),

  Vocabulaire(latin: 'dignus / indignus, a, um qui + subj.', francais: 'digne / indigne de', unite: 'Vol. III – Unité 5', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'pius, a, um', francais: 'respectueux envers les dieux, les parents, la patrie ; pieux, dévoué, juste', unite: 'Vol. III – Unité 5', categorie: 'Adjectifs'),

  Vocabulaire(latin: 'deficio, is, ere, -feci, féctum', francais: '1. faire défection 2. abandonner 3. manquer à', unite: 'Vol. III – Unité 5', categorie: 'Verbes'),
  Vocabulaire(latin: 'esse + génitif', francais: 'être le propre de ; être le fait de', unite: 'Vol. III – Unité 5', categorie: 'Verbes'),
  Vocabulaire(latin: 'negotior, aris, ari, atus sum', francais: 'faire le commerce (en grand)', unite: 'Vol. III – Unité 5', categorie: 'Verbes'),
  Vocabulaire(latin: 'moror, aris, ari, atus sum (+ acc.)', francais: '1. tarder, s\'attarder, rester, demeurer 2. retarder (qqn)', unite: 'Vol. III – Unité 5', categorie: 'Verbes', etymologie: 'un moratoire'),
  Vocabulaire(latin: 'pervenio, is, ire, -veni, -ventum (ad + acc. / in + acc.)', francais: 'parvenir (à), arriver (qq part)', unite: 'Vol. III – Unité 5', categorie: 'Verbes', etymologie: '< per- « jusqu\'au bout » + venire'),
  Vocabulaire(latin: 'prohibeo, es, ere, -hibui, -hibitum (ab + abl.)', francais: 'tenir loin de, écarter (de) [hostes a finibus]', unite: 'Vol. III – Unité 5', categorie: 'Verbes', etymologie: 'ANGL. prohibition'),
  Vocabulaire(latin: 'sunt / erant / ... qui + subj.', francais: 'il y a / avait des gens tels qu\'ils / capables de / pour', unite: 'Vol. III – Unité 5', categorie: 'Verbes'),
  Vocabulaire(latin: 'tollo, is, ere, sustuli, sublatum', francais: 'lever, élever, soulever ; enlever, supprimer', unite: 'Vol. III – Unité 5', categorie: 'Verbes'),

  Vocabulaire(latin: 'ceterum (adv.)', francais: 'd\'ailleurs, du reste', unite: 'Vol. III – Unité 5', categorie: 'Mots-outils', etymologie: 'cf. ceteri, ae, a'),
  Vocabulaire(latin: 'cito (adv.)', francais: 'rapidement', unite: 'Vol. III – Unité 5', categorie: 'Mots-outils', etymologie: 'altius, citius, fortius'),
  Vocabulaire(latin: 'prae- (+ adj./adv.)', francais: 'particulièrement..., très...', unite: 'Vol. III – Unité 5', categorie: 'Mots-outils', etymologie: 'praealte, praepotens'),
  Vocabulaire(latin: 'praesertim (adv.)', francais: 'surtout, notamment', unite: 'Vol. III – Unité 5', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'tamquam si + subj.', francais: 'comme si', unite: 'Vol. III – Unité 5', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. III – UNITÉ 6
  // ==========================================================

  Vocabulaire(latin: 'cena, ae, f.', francais: 'dîner', unite: 'Vol. III – Unité 6', categorie: 'Noms', etymologie: 'ITAL. cena'),

  Vocabulaire(latin: 'cupidus + gén.', francais: '(+) désireux de, (-) avide de', unite: 'Vol. III – Unité 6', categorie: 'Adjectifs'),

  Vocabulaire(latin: 'invideo, es, ere, -vidi, -visum (+ dat.)', francais: 'envier (qqn), jalouser (qqn)', unite: 'Vol. III – Unité 6', categorie: 'Verbes'),
  Vocabulaire(latin: 'ludo, is, ere, lusi, lusum', francais: 'jouer ; jouer à qqch. ; s\'amuser avec qqch./qqn ; se jouer de qqn', unite: 'Vol. III – Unité 6', categorie: 'Verbes', etymologie: 'ludique'),

  Vocabulaire(latin: 'gén. + gratia', francais: 'pour, en vue de', unite: 'Vol. III – Unité 6', categorie: 'Prépositions'),

  Vocabulaire(latin: 'nusquam (adv.)', francais: 'nulle part', unite: 'Vol. III – Unité 6', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'postea (adv.)', francais: 'ensuite, par la suite', unite: 'Vol. III – Unité 6', categorie: 'Mots-outils', etymologie: '= post ea'),
  Vocabulaire(latin: 'potius (adv.)', francais: 'plutôt', unite: 'Vol. III – Unité 6', categorie: 'Mots-outils'),

  // ==========================================================
  // VOL. III – UNITÉ 7
  // ==========================================================

  Vocabulaire(latin: 'aspectus, us, m.', francais: '1. action de regarder, regard 2. sens de la vue 3. vue, champ de la vision', unite: 'Vol. III – Unité 7', categorie: 'Noms', etymologie: 'aspect'),
  Vocabulaire(latin: 'cruor, oris, m.', francais: 'sang qui coule', unite: 'Vol. III – Unité 7', categorie: 'Noms'),
  Vocabulaire(latin: 'imbecillitas, atis, f.', francais: 'faiblesse', unite: 'Vol. III – Unité 7', categorie: 'Noms', etymologie: '< imbecillus'),
  Vocabulaire(latin: 'insania, ae, f.', francais: 'le fait de ne pas être sain (d\'esprit) > folie', unite: 'Vol. III – Unité 7', categorie: 'Noms', etymologie: '< in + sanus / ANGL. insane'),
  Vocabulaire(latin: 'judicium, i, n.', francais: '1. jugement, opinion, avis 2. jugement, sentence', unite: 'Vol. III – Unité 7', categorie: 'Noms', etymologie: 'judiciaire'),
  Vocabulaire(latin: 'os, oris, n.', francais: 'bouche', unite: 'Vol. III – Unité 7', categorie: 'Noms', etymologie: 'oral'),
  Vocabulaire(latin: 'vulnus, eris, n.', francais: 'blessure', unite: 'Vol. III – Unité 7', categorie: 'Noms', etymologie: '(in)vulnérable'),

  Vocabulaire(latin: 'aeger, gra, grum', francais: 'malade', unite: 'Vol. III – Unité 7', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'crudelis, e', francais: 'sanglant, cruel', unite: 'Vol. III – Unité 7', categorie: 'Adjectifs'),
  Vocabulaire(latin: 'merus, a, um', francais: 'pur, non mélangé', unite: 'Vol. III – Unité 7', categorie: 'Adjectifs', etymologie: 'ANGL. mere'),
  Vocabulaire(latin: 'quisquis, quidquid', francais: 'quelque ... que, qui/quoi que ce soit', unite: 'Vol. III – Unité 7', categorie: 'Adjectifs'),

  Vocabulaire(latin: '(ac)quiesco, is, ere, -quievi, -quietum', francais: 'se reposer', unite: 'Vol. III – Unité 7', categorie: 'Verbes', etymologie: 'quies'),
  Vocabulaire(latin: 'aperio, is, ire, aperui, apertum', francais: 'ouvrir', unite: 'Vol. III – Unité 7', categorie: 'Verbes', etymologie: 'ITAL. aperto'),
  Vocabulaire(latin: 'confiteor, eris, eri, -fisus sum', francais: 'avouer', unite: 'Vol. III – Unité 7', categorie: 'Verbes'),
  Vocabulaire(latin: 'intermitto, is, ere, -misi, -missum', francais: 'interrompre', unite: 'Vol. III – Unité 7', categorie: 'Verbes'),
  Vocabulaire(latin: 'odi, odisse', francais: 'haïr', unite: 'Vol. III – Unité 7', categorie: 'Verbes', etymologie: 'odi et amo'),
  Vocabulaire(latin: 'ruo, is, ere, rui, rutum', francais: 'se précipiter, se ruer', unite: 'Vol. III – Unité 7', categorie: 'Verbes'),
  Vocabulaire(latin: 'veho, is, ere, vexi, vectum', francais: 'porter, transporter', unite: 'Vol. III – Unité 7', categorie: 'Verbes', etymologie: 'véhicule, vecteur'),

  Vocabulaire(latin: 'usque + CCL ; + acc. / ad + acc.', francais: 'jusque ; jusqu\'à', unite: 'Vol. III – Unité 7', categorie: 'Prépositions'),

  Vocabulaire(latin: 'cum + subj.', francais: 'bien que, quoique + subj.', unite: 'Vol. III – Unité 7', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'etsi + ind.', francais: 'même si + ind. ; bien que, quoique + subj.', unite: 'Vol. III – Unité 7', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'illic (adv.)', francais: 'à cet endroit-là, là-bas, là', unite: 'Vol. III – Unité 7', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'quamvis + subj.', francais: 'bien que, quoique + subj. ; quelque ... que, si ... que + subj.', unite: 'Vol. III – Unité 7', categorie: 'Mots-outils', etymologie: '< quam + vis'),
  Vocabulaire(latin: 'quamquam + ind. / + subj.', francais: 'à quelque degré que ; bien que, quoique + subj.', unite: 'Vol. III – Unité 7', categorie: 'Mots-outils'),
  Vocabulaire(latin: 'usque eo ut + subj.', francais: 'jusqu\'à tel point que', unite: 'Vol. III – Unité 7', categorie: 'Mots-outils'),
];
