import 'package:hive_flutter/hive_flutter.dart';

import 'package:itinera/latin/declinaison.dart';

// Suivi des erreurs de déclinaison par catégorie grammaticale (pas par mot :
// "confond le génitif et l'ablatif", pas "s'est planté sur dominus"). Chaque
// entrée de quiz enregistre soit une vraie confusion (on connaît la
// catégorie que l'utilisateur a choisie à la place — cas des questions à
// choix multiple, ou d'une réponse libre qui correspond pile à une autre
// case du même paradigme), soit une erreur "non classée" quand la réponse
// tapée ne correspond à aucune forme connue (faute de frappe, mot inconnu).
//
// Stocké dans Hive sous une seule Map<String,int> :
//   "Génitif-pluriel"                          -> erreur non classée
//   "Génitif-pluriel>Ablatif-pluriel"           -> confusion cible>confondu

const _erreursDeclinaisonKey = 'erreursDeclinaison';

String _cleForme(String cas, bool pluriel) => '$cas-${pluriel ? 'pluriel' : 'singulier'}';

void enregistrerErreurDeclinaison({
  required String casCible,
  required bool plurielCible,
  String? casConfondu,
  bool? plurielConfondu,
}) {
  final box = Hive.box('vocabBox');
  final erreurs = Map<String, dynamic>.from(
    (box.get(_erreursDeclinaisonKey) as Map?) ?? {},
  );

  final cible = _cleForme(casCible, plurielCible);
  final cle = casConfondu != null
      ? '$cible>${_cleForme(casConfondu, plurielConfondu!)}'
      : cible;

  erreurs[cle] = ((erreurs[cle] as int?) ?? 0) + 1;
  box.put(_erreursDeclinaisonKey, erreurs);
}

// Cherche si [reponse] correspond exactement à une autre case du paradigme
// que la case visée ([casCible]/[plurielCible]) — ce qui révèle une vraie
// confusion entre deux catégories plutôt qu'une simple faute de frappe.
// Retourne (cas, pluriel) de la case trouvée, ou null si aucune ne
// correspond.
(Cas, bool)? formeConfondue(
  ParadigmeNominal paradigme,
  String reponse,
  Cas casCible,
  bool plurielCible,
) {
  final texte = reponse.trim().toLowerCase();
  if (texte.isEmpty) return null;

  for (final pluriel in [false, true]) {
    for (final cas in ordreCas) {
      if (cas == casCible && pluriel == plurielCible) continue;

      final forme = paradigme.forme(cas, pluriel: pluriel);
      if (forme.toLowerCase() == texte) return (cas, pluriel);
    }
  }

  return null;
}

class ConfusionFrequente {
  final String casCible;
  final bool plurielCible;
  final String? casConfondu;
  final bool? plurielConfondu;
  final int occurrences;

  const ConfusionFrequente({
    required this.casCible,
    required this.plurielCible,
    required this.casConfondu,
    required this.plurielConfondu,
    required this.occurrences,
  });

  String get libelleCible => '$casCible ${plurielCible ? 'pluriel' : 'singulier'}';

  String? get libelleConfondu => casConfondu == null
      ? null
      : '$casConfondu ${plurielConfondu! ? 'pluriel' : 'singulier'}';
}

List<ConfusionFrequente> _toutesLesConfusions() {
  final box = Hive.box('vocabBox');
  final erreurs = Map<String, dynamic>.from(
    (box.get(_erreursDeclinaisonKey) as Map?) ?? {},
  );

  final resultat = <ConfusionFrequente>[];

  for (final entry in erreurs.entries) {
    final parties = entry.key.split('>');
    final cible = parties[0].split('-');

    String? casConfondu;
    bool? plurielConfondu;

    if (parties.length > 1) {
      final confondu = parties[1].split('-');
      casConfondu = confondu[0];
      plurielConfondu = confondu[1] == 'pluriel';
    }

    resultat.add(
      ConfusionFrequente(
        casCible: cible[0],
        plurielCible: cible[1] == 'pluriel',
        casConfondu: casConfondu,
        plurielConfondu: plurielConfondu,
        occurrences: (entry.value as int?) ?? 0,
      ),
    );
  }

  return resultat;
}

// Les vraies confusions (cible + catégorie confondue connue), triées par
// fréquence — pour l'affichage "tes erreurs fréquentes".
List<ConfusionFrequente> confusionsFrequentes({int limite = 3}) {
  final confusions = _toutesLesConfusions()
      .where((c) => c.casConfondu != null)
      .toList()
    ..sort((a, b) => b.occurrences.compareTo(a.occurrences));

  return confusions.take(limite).toList();
}

// Total d'erreurs par catégorie cible, confusion classée ou non — pour
// alimenter la pratique ciblée (peu importe avec quoi la catégorie a été
// confondue, elle reste un point faible à travailler).
List<(String cas, bool pluriel, int occurrences)> categoriesFaibles({int limite = 5}) {
  final totaux = <String, int>{};

  for (final c in _toutesLesConfusions()) {
    final cle = _cleForme(c.casCible, c.plurielCible);
    totaux[cle] = (totaux[cle] ?? 0) + c.occurrences;
  }

  final entrees = totaux.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return [
    for (final e in entrees.take(limite))
      (e.key.split('-')[0], e.key.split('-')[1] == 'pluriel', e.value),
  ];
}
