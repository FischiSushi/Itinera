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
