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
