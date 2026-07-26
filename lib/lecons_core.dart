import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'main.dart';
import 'vocabulaire_data.dart';


// ============================================================
// PARCOURS DE LEÇONS : DONNÉES
// ============================================================

sealed class ExerciceLecon {
  const ExerciceLecon();

  String get question;
}

class QuestionLecon extends ExerciceLecon {
  @override
  final String question;
  final List<String> options;
  final String reponseCorrecte;

  const QuestionLecon({
    required this.question,
    required this.options,
    required this.reponseCorrecte,
  });
}

// Exercice à réponse libre (saisie clavier), corrigé automatiquement.
class ExerciceSaisie extends ExerciceLecon {
  @override
  final String question;
  final List<String> reponsesAcceptees;
  final String? indice;

  const ExerciceSaisie({
    required this.question,
    required this.reponsesAcceptees,
    this.indice,
  });
}

// Normalise une réponse saisie pour la comparaison : espaces, casse et
// accents de prononciation pédagogiques (Rómae -> romae) ignorés.
String normaliserReponse(String texte) {
  const accents = {
    'á': 'a',
    'à': 'a',
    'â': 'a',
    'ä': 'a',
    'é': 'e',
    'è': 'e',
    'ê': 'e',
    'ë': 'e',
    'í': 'i',
    'ì': 'i',
    'î': 'i',
    'ï': 'i',
    'ó': 'o',
    'ò': 'o',
    'ô': 'o',
    'ö': 'o',
    'ú': 'u',
    'ù': 'u',
    'û': 'u',
    'ü': 'u',
    'ý': 'y',
  };

  var resultat = texte.trim().toLowerCase();

  accents.forEach((accentue, simple) {
    resultat = resultat.replaceAll(accentue, simple);
  });

  resultat = resultat.replaceAll(RegExp(r'[.!?,;:]+$'), '').trim();

  return resultat.replaceAll(RegExp(r'\s+'), ' ');
}

// Un "parcours guidé" alterne de courts blocs de lecture avec des
// vérifications rapides (non notées, juste formatives), plutôt que de tout
// lire d'un bloc avant d'attaquer le quiz noté (voir Lecon.etapes).
sealed class EtapeLecon {
  const EtapeLecon();
}

class EtapeTexte extends EtapeLecon {
  final List<Widget> Function(BuildContext) contenu;

  const EtapeTexte(this.contenu);
}

class EtapeVerification extends EtapeLecon {
  final ExerciceLecon exercice;

  const EtapeVerification(this.exercice);
}

class Lecon {
  final String id;
  final String titre;
  final String sousTitre;
  final IconData icone;

  // À quelle unité (au sens du vocabulaire, ex. "Vol. I – Unité 1") cette
  // leçon de grammaire appartient — permet un parcours distinct par unité.
  final String unite;

  final List<Widget> Function(BuildContext)? explication;
  final List<ExerciceLecon>? exercices;
  final Widget Function(BuildContext)? fiche;

  // Si présent, remplace l'écran d'explication par un parcours guidé qui
  // alterne lecture et vérifications rapides — voir EtapeLecon. Le quiz
  // noté (exercices) et la fiche restent inchangés et suivent le parcours
  // guidé normalement.
  final List<EtapeLecon>? etapes;

  // Unités de vocabulaire recommandées pour aller avec ce point de
  // grammaire (accessibles librement, pas verrouillées).
  final List<String> uniteRecommandees;

  const Lecon({
    required this.id,
    required this.titre,
    required this.sousTitre,
    required this.icone,
    this.unite = 'Vol. I – Unité 1',
    this.explication,
    this.exercices,
    this.fiche,
    this.etapes,
    this.uniteRecommandees = const [],
  });
}

const leconsCompleteesKey = 'leconsCompletees';

Set<String> leconsCompletees() {
  final box = Hive.box('vocabBox');
  return Set<String>.from((box.get(leconsCompleteesKey) as List?) ?? []);
}

void marquerLeconCompletee(String id) {
  final box = Hive.box('vocabBox');
  final completees = leconsCompletees()..add(id);
  box.put(leconsCompleteesKey, completees.toList());
}

bool leconEstCompletee(Lecon lecon) {
  return leconsCompletees().contains(lecon.id);
}

// ------------------------------------------------------------
// Petits widgets réutilisés dans les explications de leçons
// ------------------------------------------------------------

Widget titreExplication(String texte) {
  return Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(
      texte,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: accentViolet,
      ),
    ),
  );
}

Widget paragrapheExplication(String texte) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(texte, style: const TextStyle(fontSize: 15, height: 1.5)),
  );
}

Widget tableauRolesCas(List<List<String>> lignes) {
  return Table(
    border: TableBorder.all(color: texteAttenue.withValues(alpha: 0.3)),
    columnWidths: const {
      0: FlexColumnWidth(1),
      1: FlexColumnWidth(1.6),
      2: FlexColumnWidth(1.3),
    },
    children: [
      const TableRow(
        children: [
          Padding(
            padding: EdgeInsets.all(6),
            child: Text('Cas', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.all(6),
            child: Text('Rôle', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.all(6),
            child: Text(
              'Question',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      for (final ligne in lignes)
        TableRow(
          children: [
            Padding(padding: const EdgeInsets.all(6), child: Text(ligne[0])),
            Padding(padding: const EdgeInsets.all(6), child: Text(ligne[1])),
            Padding(padding: const EdgeInsets.all(6), child: Text(ligne[2])),
          ],
        ),
    ],
  );
}

// ------------------------------------------------------------
// Tableau générique à colonnes multiples (composés de esse,
// particules interrogatives...)
// ------------------------------------------------------------

Widget tableauColonnes(List<String> entetes, List<List<String>> lignes) {
  return Table(
    border: TableBorder.all(color: texteAttenue.withValues(alpha: 0.3)),
    columnWidths: {
      for (var i = 0; i < entetes.length; i++)
        i: FlexColumnWidth(i == 0 ? 0.8 : 1),
    },
    children: [
      TableRow(
        children: [
          for (final entete in entetes)
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                entete,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      for (final ligne in lignes)
        TableRow(
          children: [
            for (final cellule in ligne)
              Padding(padding: const EdgeInsets.all(6), child: Text(cellule)),
          ],
        ),
    ],
  );
}

// ------------------------------------------------------------
// Vocabulaire recommandé par leçon (réparti simplement en 3 tiers,
// en attendant un étiquetage plus précis par point de grammaire)
// ------------------------------------------------------------

List<String> unitesRecommandeesTranche(int debut, int fin) {
  final toutes = vocabulaire.map((mot) => mot.unite).toSet().toList();

  return toutes.sublist(
    debut.clamp(0, toutes.length),
    fin.clamp(0, toutes.length),
  );
}

