import 'package:flutter/material.dart';

import 'package:itinera/lecons_grammaire_data.dart';
import 'package:itinera/main.dart';

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
  static const _etapeGuide = 3;

  late int etape;

  int indexQuestion = 0;
  int score = 0;
  String? optionChoisie;
  List<String> optionsMelangees = [];

  int indexEtapeGuide = 0;

  late final TextEditingController controleurSaisie;
  bool aValideSaisie = false;
  bool saisieCorrecte = false;

  @override
  void initState() {
    super.initState();
    controleurSaisie = TextEditingController();

    if (widget.lecon.etapes != null) {
      etape = _etapeGuide;
      _preparerEtapeGuide();
    } else {
      etape = _etapeExplication;
      _preparerExercice();
    }
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

  // ------------------------------------------------------------
  // PARCOURS GUIDÉ (Lecon.etapes) : lecture et vérifications rapides
  // alternées, non notées — voir EtapeLecon.
  // ------------------------------------------------------------

  void _preparerEtapeGuide() {
    final etapeCourante = widget.lecon.etapes![indexEtapeGuide];

    optionsMelangees = switch (etapeCourante) {
      EtapeVerification(exercice: QuestionLecon q) => List.of(q.options)
        ..shuffle(),
      _ => [],
    };
  }

  void repondreGuide(String option) {
    if (optionChoisie != null) return;

    setState(() {
      optionChoisie = option;
    });
  }

  void validerSaisieGuide(ExerciceSaisie exercice) {
    if (aValideSaisie) return;

    final reponse = normaliserReponse(controleurSaisie.text);
    final correcte = exercice.reponsesAcceptees
        .map(normaliserReponse)
        .contains(reponse);

    setState(() {
      aValideSaisie = true;
      saisieCorrecte = correcte;
    });
  }

  void etapeGuideSuivante() {
    if (indexEtapeGuide + 1 >= widget.lecon.etapes!.length) {
      setState(() {
        etape = _etapeExercices;
        controleurSaisie.clear();
        _preparerExercice();
      });

      return;
    }

    setState(() {
      indexEtapeGuide++;
      optionChoisie = null;
      aValideSaisie = false;
      saisieCorrecte = false;
      controleurSaisie.clear();
      _preparerEtapeGuide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lecon.titre)),
      body: switch (etape) {
        _etapeGuide => _construireGuide(context),
        _etapeExercices => _construireExercice(context),
        _etapeFiche => _construireFiche(context),
        _ => _construireExplication(context),
      },
    );
  }

  Widget _construireGuide(BuildContext context) {
    final etapeCourante = widget.lecon.etapes![indexEtapeGuide];

    return switch (etapeCourante) {
      EtapeTexte t => _construireEtapeTexte(context, t),
      EtapeVerification v => _construireEtapeVerification(context, v),
    };
  }

  Widget _construireEtapeTexte(BuildContext context, EtapeTexte etapeTexte) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: etapeTexte.contenu(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: etapeGuideSuivante,
              child: const Text('Continuer'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _construireEtapeVerification(
    BuildContext context,
    EtapeVerification etapeVerification,
  ) {
    final exercice = etapeVerification.exercice;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bolt, color: accentViolet, size: 18),
              SizedBox(width: 6),
              Text(
                'Vérification rapide',
                style: TextStyle(
                  color: accentViolet,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
            QuestionLecon q => _corpsGuideChoixMultiple(q),
            ExerciceSaisie s => _corpsGuideSaisie(s),
          },
        ],
      ),
    );
  }

  Widget _corpsGuideChoixMultiple(QuestionLecon question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final option in optionsMelangees) ...[
          _boutonOptionLecon(
            option,
            question.reponseCorrecte,
            onTap: repondreGuide,
          ),
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
            onPressed: etapeGuideSuivante,
            child: const Text('Continuer'),
          ),
        ],
      ],
    );
  }

  Widget _corpsGuideSaisie(ExerciceSaisie exercice) {
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
          onSubmitted: (_) => validerSaisieGuide(exercice),
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
            onPressed: () => validerSaisieGuide(exercice),
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
            onPressed: etapeGuideSuivante,
            child: const Text('Continuer'),
          ),
        ],
      ],
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
          _boutonOptionLecon(
            option,
            question.reponseCorrecte,
            onTap: repondre,
          ),
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

  Widget _boutonOptionLecon(
    String option,
    String reponseCorrecte, {
    required ValueChanged<String> onTap,
  }) {
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
        onPressed: () => onTap(option),
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
              children: [widget.lecon.fiche!(context)],
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
