import 'package:itinera/vocabulaire_data.dart';

// Moteur de déclinaison régulière (1re, 2e, 4e et 5e déclinaisons).
//
// La 3e déclinaison est volontairement exclue : la notation abrégée du
// dictionnaire ("rex, regis" / "corpus, oris" / "legio, onis"...) ne permet
// pas de retrouver le radical de façon fiable par une règle générale — le
// point de coupe entre "abréviation à recoller au nominatif" et "génitif
// donné en entier" varie selon le mot (voir les notes de conception). Un
// vrai support de la 3e déclinaison demanderait une base de radicaux
// séparée plutôt qu'un simple découpage de la notation existante.

enum Cas { nominatif, vocatif, accusatif, genitif, datif, ablatif }

const List<Cas> ordreCas = [
  Cas.nominatif,
  Cas.vocatif,
  Cas.accusatif,
  Cas.genitif,
  Cas.datif,
  Cas.ablatif,
];

Cas casDepuisLibelle(String libelle) =>
    ordreCas.firstWhere((c) => c.libelle == libelle);

extension LibelleCas on Cas {
  String get libelle => switch (this) {
        Cas.nominatif => 'Nominatif',
        Cas.vocatif => 'Vocatif',
        Cas.accusatif => 'Accusatif',
        Cas.genitif => 'Génitif',
        Cas.datif => 'Datif',
        Cas.ablatif => 'Ablatif',
      };
}

class ParadigmeNominal {
  final String lemme;
  final String traduction;
  final int declinaison;
  final Map<Cas, String> singulier;
  final Map<Cas, String> pluriel;

  const ParadigmeNominal({
    required this.lemme,
    required this.traduction,
    required this.declinaison,
    required this.singulier,
    required this.pluriel,
  });

  String forme(Cas cas, {required bool pluriel}) =>
      (pluriel ? this.pluriel : singulier)[cas]!;
}

// Tente de construire le paradigme complet d'un nom à partir de sa notation
// dictionnaire ("aqua, ae, f." / "rex, regis, m." / "ager, agri, m." ...).
// Retourne null si le mot n'est pas un nom, si la notation ne peut pas être
// découpée proprement (locutions, notes entre parenthèses...), ou si la
// déclinaison ne peut pas être déterminée de façon fiable (3e déclinaison,
// pluralia tantum).
ParadigmeNominal? genererParadigme(Vocabulaire mot) {
  if (mot.categorie != 'Noms') return null;

  final notation = mot.latin.split('(').first.split(';').first.trim();
  final champs = notation.split(',').map((c) => c.trim()).toList();

  if (champs.length < 3) return null;

  final nominatif = champs[0];
  final genitifBrut = champs[1];
  final genre = champs[2].toLowerCase();

  // Pluriel tantum ("gemelli, orum, m. pl.") : notation différente (pas de
  // singulier), non pris en charge ici.
  if (genre.contains('pl.')) return null;
  if (nominatif.isEmpty || genitifBrut.isEmpty) return null;

  late final int declinaison;
  late final bool neutre;
  late final String stem;

  if (genitifBrut == 'ae') {
    declinaison = 1;
    neutre = false;
    if (nominatif.length < 2) return null;
    stem = nominatif.substring(0, nominatif.length - 1);
  } else if (genitifBrut == 'i') {
    declinaison = 2;
    neutre = nominatif.endsWith('um');
    if (nominatif.length < 3) return null;
    stem = nominatif.substring(0, nominatif.length - 2);
  } else if (genitifBrut == 'us') {
    declinaison = 4;
    neutre = nominatif.endsWith('u');
    if (neutre) {
      stem = nominatif.substring(0, nominatif.length - 1);
    } else {
      if (nominatif.length < 3) return null;
      stem = nominatif.substring(0, nominatif.length - 2);
    }
  } else if (genitifBrut == 'ei') {
    declinaison = 5;
    neutre = false;
    if (nominatif.length < 3) return null;
    stem = nominatif.substring(0, nominatif.length - 2);
  } else if (genitifBrut.length >= 2 &&
      genitifBrut.endsWith('i') &&
      !nominatif.endsWith('us') &&
      (nominatif.endsWith('er') || nominatif.endsWith('ir'))) {
    // 2e déclinaison à radical irrégulier, génitif donné en entier :
    // ager/agri, vir/viri, puer/pueri...
    declinaison = 2;
    neutre = false;
    stem = genitifBrut.substring(0, genitifBrut.length - 1);
  } else {
    return null;
  }

  if (stem.isEmpty) return null;

  return ParadigmeNominal(
    lemme: nominatif,
    traduction: mot.francais,
    declinaison: declinaison,
    singulier: _singulier(declinaison, neutre, nominatif, stem),
    pluriel: _pluriel(declinaison, neutre, stem),
  );
}

Map<Cas, String> _singulier(
  int declinaison,
  bool neutre,
  String nominatif,
  String stem,
) {
  switch (declinaison) {
    case 1:
      return {
        Cas.nominatif: '${stem}a',
        Cas.vocatif: '${stem}a',
        Cas.accusatif: '${stem}am',
        Cas.genitif: '${stem}ae',
        Cas.datif: '${stem}ae',
        Cas.ablatif: '${stem}a',
      };
    case 2:
      if (neutre) {
        return {
          Cas.nominatif: nominatif,
          Cas.vocatif: nominatif,
          Cas.accusatif: nominatif,
          Cas.genitif: '${stem}i',
          Cas.datif: '${stem}o',
          Cas.ablatif: '${stem}o',
        };
      }

      // Exception classique : les noms en -ius ont un vocatif en -i
      // (fili, non filie).
      final vocatif = nominatif.endsWith('ius')
          ? nominatif.substring(0, nominatif.length - 2)
          : (nominatif.endsWith('us') ? '${stem}e' : nominatif);

      return {
        Cas.nominatif: nominatif,
        Cas.vocatif: vocatif,
        Cas.accusatif: '${stem}um',
        Cas.genitif: '${stem}i',
        Cas.datif: '${stem}o',
        Cas.ablatif: '${stem}o',
      };
    case 4:
      if (neutre) {
        return {
          Cas.nominatif: nominatif,
          Cas.vocatif: nominatif,
          Cas.accusatif: nominatif,
          Cas.genitif: '${stem}us',
          Cas.datif: '${stem}u',
          Cas.ablatif: '${stem}u',
        };
      }
      return {
        Cas.nominatif: nominatif,
        Cas.vocatif: nominatif,
        Cas.accusatif: '${stem}um',
        Cas.genitif: '${stem}us',
        Cas.datif: '${stem}ui',
        Cas.ablatif: '${stem}u',
      };
    case 5:
      return {
        Cas.nominatif: '${stem}es',
        Cas.vocatif: '${stem}es',
        Cas.accusatif: '${stem}em',
        Cas.genitif: '${stem}ei',
        Cas.datif: '${stem}ei',
        Cas.ablatif: '${stem}e',
      };
    default:
      throw ArgumentError('Déclinaison non prise en charge : $declinaison');
  }
}

Map<Cas, String> _pluriel(int declinaison, bool neutre, String stem) {
  switch (declinaison) {
    case 1:
      return {
        Cas.nominatif: '${stem}ae',
        Cas.vocatif: '${stem}ae',
        Cas.accusatif: '${stem}as',
        Cas.genitif: '${stem}arum',
        Cas.datif: '${stem}is',
        Cas.ablatif: '${stem}is',
      };
    case 2:
      if (neutre) {
        return {
          Cas.nominatif: '${stem}a',
          Cas.vocatif: '${stem}a',
          Cas.accusatif: '${stem}a',
          Cas.genitif: '${stem}orum',
          Cas.datif: '${stem}is',
          Cas.ablatif: '${stem}is',
        };
      }
      return {
        Cas.nominatif: '${stem}i',
        Cas.vocatif: '${stem}i',
        Cas.accusatif: '${stem}os',
        Cas.genitif: '${stem}orum',
        Cas.datif: '${stem}is',
        Cas.ablatif: '${stem}is',
      };
    case 4:
      if (neutre) {
        return {
          Cas.nominatif: '${stem}ua',
          Cas.vocatif: '${stem}ua',
          Cas.accusatif: '${stem}ua',
          Cas.genitif: '${stem}uum',
          Cas.datif: '${stem}ibus',
          Cas.ablatif: '${stem}ibus',
        };
      }
      return {
        Cas.nominatif: '${stem}us',
        Cas.vocatif: '${stem}us',
        Cas.accusatif: '${stem}us',
        Cas.genitif: '${stem}uum',
        Cas.datif: '${stem}ibus',
        Cas.ablatif: '${stem}ibus',
      };
    case 5:
      return {
        Cas.nominatif: '${stem}es',
        Cas.vocatif: '${stem}es',
        Cas.accusatif: '${stem}es',
        Cas.genitif: '${stem}erum',
        Cas.datif: '${stem}ebus',
        Cas.ablatif: '${stem}ebus',
      };
    default:
      throw ArgumentError('Déclinaison non prise en charge : $declinaison');
  }
}

// Tous les paradigmes que le vocabulaire actuel permet de générer de façon
// fiable (dédupliqués par lemme). Alimente le générateur et la déclinaison
// rapide.
List<ParadigmeNominal> paradigmesDisponibles() {
  final vus = <String>{};
  final resultat = <ParadigmeNominal>[];

  for (final mot in vocabulaire) {
    final paradigme = genererParadigme(mot);
    if (paradigme == null) continue;
    if (!vus.add(paradigme.lemme)) continue;
    resultat.add(paradigme);
  }

  return resultat;
}
