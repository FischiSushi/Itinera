import 'package:flutter/material.dart';

import 'package:itinera/lecons_grammaire_data.dart';
import 'package:itinera/main.dart';
import 'package:itinera/screens/vocabulaire_liste_screen.dart';

// ============================================================
// PARCOURS DE LEÇONS : DÉTAIL D'UNE LEÇON
// ============================================================

class LeconDetailScreen extends StatefulWidget {
  final Lecon lecon;

  const LeconDetailScreen({super.key, required this.lecon});

  @override
  State<LeconDetailScreen> createState() => _LeconDetailScreenState();
}

class _LeconDetailScreenState extends State<LeconDetailScreen> {
  static const _etapeExplication = 0;
  static const _etapeExercices = 1;
  static const _etapeFiche = 2;

  int etape = _etapeExplication;

  int indexQuestion = 0;
  int score = 0;
  String? optionChoisie;
  List<String> optionsMelangees = [];

  late final TextEditingController controleurSaisie;
  bool aValideSaisie = false;
  bool saisieCorrecte = false;

  @override
  void initState() {
    super.initState();
    controleurSaisie = TextEditingController();
    _preparerExercice();
  }

  @override
  void dispose() {
    controleurSaisie.dispose();
    super.dispose();
  }

  void _preparerExercice() {
    final exercice = widget.lecon.exercices![indexQuestion];

    optionsMelangees = switch (exercice) {
      QuestionLecon q => List.of(q.options)..shuffle(),
      ExerciceSaisie _ => [],
    };
  }

  void repondre(String option) {
    if (optionChoisie != null) return;

    final exercice = widget.lecon.exercices![indexQuestion] as QuestionLecon;

    setState(() {
      optionChoisie = option;

      if (option == exercice.reponseCorrecte) {
        score++;
      }
    });
  }

  void validerSaisie(ExerciceSaisie exercice) {
    if (aValideSaisie) return;

    final reponse = normaliserReponse(controleurSaisie.text);
    final correcte = exercice.reponsesAcceptees
        .map(normaliserReponse)
        .contains(reponse);

    setState(() {
      aValideSaisie = true;
      saisieCorrecte = correcte;

      if (correcte) score++;
    });
  }

  void suivantExercice() {
    if (indexQuestion + 1 >= widget.lecon.exercices!.length) {
      final reussite = score / widget.lecon.exercices!.length >= 0.7;

      if (reussite) {
        marquerLeconCompletee(widget.lecon.id);
        verifierSuccesEtNotifier(context);
      }

      setState(() {
        etape = _etapeFiche;
      });

      return;
    }

    setState(() {
      indexQuestion++;
      optionChoisie = null;
      aValideSaisie = false;
      saisieCorrecte = false;
      controleurSaisie.clear();
      _preparerExercice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lecon.titre)),
      body: switch (etape) {
        _etapeExercices => _construireExercice(context),
        _etapeFiche => _construireFiche(context),
        _ => _construireExplication(context),
      },
    );
  }

  Widget _construireExplication(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: widget.lecon.explication!(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => etape = _etapeExercices),
              child: const Text('Passer aux exercices'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _construireExercice(BuildContext context) {
    final exercice = widget.lecon.exercices![indexQuestion];
    final total = widget.lecon.exercices!.length;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Question ${indexQuestion + 1}/$total · Score : $score',
            style: const TextStyle(color: texteAttenue),
          ),

          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                exercice.question,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          switch (exercice) {
            QuestionLecon q => _corpsExerciceChoixMultiple(q, total),
            ExerciceSaisie s => _corpsExerciceSaisie(s, total),
          },
        ],
      ),
    );
  }

  Widget _corpsExerciceChoixMultiple(QuestionLecon question, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final option in optionsMelangees) ...[
          _boutonOptionLecon(option, question.reponseCorrecte),
          const SizedBox(height: 12),
        ],

        if (optionChoisie != null) ...[
          const SizedBox(height: 8),
          _ligneResultatExercice(
            correcte: optionChoisie == question.reponseCorrecte,
            texte: optionChoisie == question.reponseCorrecte
                ? 'Correct !'
                : 'Faux — la bonne réponse était : ${question.reponseCorrecte}',
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: suivantExercice,
            child: Text(
              indexQuestion + 1 >= total ? 'Voir la fiche' : 'Suivant',
            ),
          ),
        ],
      ],
    );
  }

  Widget _corpsExerciceSaisie(ExerciceSaisie exercice, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (exercice.indice != null) ...[
          Text(
            exercice.indice!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: texteAttenue,
            ),
          ),
          const SizedBox(height: 12),
        ],

        TextField(
          controller: controleurSaisie,
          readOnly: aValideSaisie,
          textAlign: TextAlign.center,
          autofocus: true,
          onSubmitted: (_) => validerSaisie(exercice),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: aValideSaisie,
            fillColor: aValideSaisie
                ? (saisieCorrecte ? Colors.green : Colors.red).withValues(
                    alpha: 0.15,
                  )
                : null,
          ),
        ),

        const SizedBox(height: 16),

        if (!aValideSaisie)
          ElevatedButton(
            onPressed: () => validerSaisie(exercice),
            child: const Text('Vérifier'),
          )
        else ...[
          _ligneResultatExercice(
            correcte: saisieCorrecte,
            texte: saisieCorrecte
                ? 'Correct !'
                : 'Faux — la bonne réponse était : '
                      '${exercice.reponsesAcceptees.first}',
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: suivantExercice,
            child: Text(
              indexQuestion + 1 >= total ? 'Voir la fiche' : 'Suivant',
            ),
          ),
        ],
      ],
    );
  }

  Widget _ligneResultatExercice({
    required bool correcte,
    required String texte,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          correcte ? Icons.check_circle : Icons.cancel,
          color: correcte ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            texte,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: correcte ? Colors.green : Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _boutonOptionLecon(String option, String reponseCorrecte) {
    Color? couleur;

    if (optionChoisie != null) {
      if (option == reponseCorrecte) {
        couleur = Colors.green;
      } else if (option == optionChoisie) {
        couleur = Colors.red;
      }
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: couleur,
          foregroundColor: texteClair,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () => repondre(option),
        child: Text(option, textAlign: TextAlign.center),
      ),
    );
  }

  Widget _construireFiche(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.lecon.fiche!(context),
                if (widget.lecon.uniteRecommandees.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Vocabulaire recommandé pour t\'entraîner',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: accentViolet,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final unite in widget.lecon.uniteRecommandees)
                    Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.menu_book),
                        title: Text(nomAffiche(unite)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VocabulaireListeScreen(unite: unite),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Terminer la leçon'),
            ),
          ),
        ),
      ],
    );
  }
}
