import 'package:flutter/material.dart';

import 'package:itinera/main.dart';
import 'package:itinera/vocabulaire_data.dart';

// ============================================================
// JEU : ASSOCIATION
// ============================================================

class JeuAssociationScreen extends StatefulWidget {
  final List<Vocabulaire> vocabulaire;
  final String direction;

  const JeuAssociationScreen({
    super.key,
    required this.vocabulaire,
    required this.direction,
  });

  @override
  State<JeuAssociationScreen> createState() => _JeuAssociationScreenState();
}

class _JeuAssociationScreenState extends State<JeuAssociationScreen> {
  static const _tailleGroupe = 6;

  late List<Vocabulaire> tousLesMots;
  int indexGroupe = 0;

  late List<Vocabulaire> groupeActuel;
  late List<String> questionsMelangees;
  late List<String> reponsesMelangees;

  String? questionSelectionnee;
  String? reponseSelectionnee;
  final Set<String> questionsTrouvees = {};
  final Set<String> reponsesTrouvees = {};

  bool erreurEnCours = false;
  bool? dernierResultatCorrect;

  @override
  void initState() {
    super.initState();
    tousLesMots = List.of(widget.vocabulaire)..shuffle();
    demarrerGroupe();
  }

  String texteQuestion(Vocabulaire mot) =>
      widget.direction == directionLatinVersFrancais ? mot.latin : mot.francais;

  String texteReponse(Vocabulaire mot) =>
      widget.direction == directionLatinVersFrancais ? mot.francais : mot.latin;

  void demarrerGroupe() {
    final debut = indexGroupe * _tailleGroupe;
    final fin = (debut + _tailleGroupe).clamp(0, tousLesMots.length);

    groupeActuel = tousLesMots.sublist(debut, fin);
    questionsMelangees = groupeActuel.map(texteQuestion).toList()..shuffle();
    reponsesMelangees = groupeActuel.map(texteReponse).toList()..shuffle();

    questionSelectionnee = null;
    reponseSelectionnee = null;
    questionsTrouvees.clear();
    reponsesTrouvees.clear();
  }

  void selectionnerQuestion(String question) {
    if (erreurEnCours || questionsTrouvees.contains(question)) return;

    setState(() {
      questionSelectionnee = question;
      tenterAssociation();
    });
  }

  void selectionnerReponse(String reponse) {
    if (erreurEnCours || reponsesTrouvees.contains(reponse)) return;

    setState(() {
      reponseSelectionnee = reponse;
      tenterAssociation();
    });
  }

  void tenterAssociation() {
    if (questionSelectionnee == null || reponseSelectionnee == null) return;

    final mot = groupeActuel.firstWhere(
      (m) => texteQuestion(m) == questionSelectionnee,
    );

    final correct = texteReponse(mot) == reponseSelectionnee;

    dernierResultatCorrect = correct;

    if (correct) {
      questionsTrouvees.add(questionSelectionnee!);
      reponsesTrouvees.add(reponseSelectionnee!);
      questionSelectionnee = null;
      reponseSelectionnee = null;
    } else {
      erreurEnCours = true;
    }

    Future.delayed(Duration(milliseconds: correct ? 700 : 600), () {
      if (!mounted) return;

      setState(() {
        if (!correct) {
          questionSelectionnee = null;
          reponseSelectionnee = null;
          erreurEnCours = false;
        }
        dernierResultatCorrect = null;
      });
    });
  }

  Color? couleurBouton({
    required String texte,
    required bool trouve,
    required bool selectionne,
  }) {
    if (trouve) return Colors.green.withValues(alpha: 0.4);
    if (selectionne && erreurEnCours) return Colors.red;
    if (selectionne) return accentViolet;
    return null;
  }

  Widget boutonMot({
    required String texte,
    required bool trouve,
    required bool selectionne,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: couleurBouton(
              texte: texte,
              trouve: trouve,
              selectionne: selectionne,
            ),
            foregroundColor: texteClair,
            disabledForegroundColor: texteClair.withValues(alpha: 0.8),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          ),
          onPressed: trouve ? null : onTap,
          child: Text(
            texte,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupeTermine = questionsTrouvees.length == groupeActuel.length;
    final dernierGroupe =
        (indexGroupe + 1) * _tailleGroupe >= tousLesMots.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Association (groupe ${indexGroupe + 1}/'
          '${(tousLesMots.length / _tailleGroupe).ceil()})',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Text(
              'Trouvées : ${questionsTrouvees.length} / ${groupeActuel.length}',
              style: const TextStyle(color: texteAttenue),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        for (final question in questionsMelangees)
                          boutonMot(
                            texte: question,
                            trouve: questionsTrouvees.contains(question),
                            selectionne: question == questionSelectionnee,
                            onTap: () => selectionnerQuestion(question),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        for (final reponse in reponsesMelangees)
                          boutonMot(
                            texte: reponse,
                            trouve: reponsesTrouvees.contains(reponse),
                            selectionne: reponse == reponseSelectionnee,
                            onTap: () => selectionnerReponse(reponse),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (dernierResultatCorrect != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      dernierResultatCorrect!
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: dernierResultatCorrect!
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      dernierResultatCorrect!
                          ? 'Bonne paire !'
                          : 'Mauvaise paire',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: dernierResultatCorrect!
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

            if (groupeTermine)
              ElevatedButton(
                onPressed: () {
                  if (dernierGroupe) {
                    Navigator.pop(context);
                    return;
                  }

                  setState(() {
                    indexGroupe++;
                    demarrerGroupe();
                  });
                },
                child: Text(dernierGroupe ? 'Terminer' : 'Groupe suivant'),
              ),
          ],
        ),
      ),
    );
  }
}
