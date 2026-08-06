import 'dart:math';

import 'package:flutter/material.dart';

import 'package:itinera/grammaire_tableaux_data.dart';
import 'package:itinera/latin/erreurs_declinaison.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';

// ============================================================
// GRAMMAIRE : MORPHOLOGIE (JEU)
// ============================================================

class MorphologieScreen extends StatefulWidget {
  const MorphologieScreen({super.key});

  @override
  State<MorphologieScreen> createState() => _MorphologieScreenState();
}

class _MorphologieScreenState extends State<MorphologieScreen> {
  static const _totalQuestions = 20;

  final _rng = Random();

  int index = 0;
  int score = 0;

  late Declinaison declinaisonActuelle;
  late String formeActuelle;
  late String reponseCorrecte;
  List<String> options = [];
  String? optionChoisie;

  @override
  void initState() {
    super.initState();
    genererQuestion();
  }

  void genererQuestion() {
    declinaisonActuelle = declinaisons[_rng.nextInt(declinaisons.length)];

    final cas = casLatins[_rng.nextInt(casLatins.length)];
    final singulier = _rng.nextBool();

    formeActuelle = singulier
        ? declinaisonActuelle.singulier[cas]!
        : declinaisonActuelle.pluriel[cas]!;

    reponseCorrecte = '$cas ${singulier ? 'singulier' : 'pluriel'}';

    final autresCombinaisons = <String>[];

    for (final c in casLatins) {
      for (final estSingulier in [true, false]) {
        final combinaison = '$c ${estSingulier ? 'singulier' : 'pluriel'}';

        if (combinaison == reponseCorrecte) continue;

        final forme = estSingulier
            ? declinaisonActuelle.singulier[c]!
            : declinaisonActuelle.pluriel[c]!;

        // Exclure les formes identiques (syncrétisme, ex. "dies" au
        // nominatif et vocatif, singulier et pluriel) pour éviter qu'une
        // réponse tout aussi correcte soit comptée comme fausse.
        if (forme == formeActuelle) continue;

        autresCombinaisons.add(combinaison);
      }
    }

    autresCombinaisons.shuffle(_rng);

    options = [reponseCorrecte, ...autresCombinaisons.take(3)]..shuffle(_rng);
    optionChoisie = null;
  }

  void repondre(String option) {
    if (optionChoisie != null) return;

    if (option != reponseCorrecte) {
      final cible = reponseCorrecte.split(' ');
      final confondu = option.split(' ');
      enregistrerErreurDeclinaison(
        casCible: cible[0],
        plurielCible: cible[1] == 'pluriel',
        casConfondu: confondu[0],
        plurielConfondu: confondu[1] == 'pluriel',
      );
    }

    setState(() {
      optionChoisie = option;

      if (option == reponseCorrecte) score++;
    });
  }

  void suivant() {
    if (index + 1 >= _totalQuestions) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Terminé'),
            content: Text('$score / $_totalQuestions bonnes réponses'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Terminer'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      index++;
      genererQuestion();
    });
  }

  Widget boutonOption(String option) {
    Color fond = designBlanc;
    Color texte = designNoir;

    if (optionChoisie != null) {
      if (option == reponseCorrecte) {
        fond = Colors.green;
        texte = Colors.white;
      } else if (option == optionChoisie) {
        fond = Colors.red;
        texte = Colors.white;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: fond,
            foregroundColor: texte,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () => repondre(option),
          child: Text(option, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text('Morphologie (${index + 1}/$_totalQuestions)'),
      ),

      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              Text(
                'Score : $score',
                style: const TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 8),

              Text(
                declinaisonActuelle.titre,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),

              const SizedBox(height: 16),

              CarteDesign(
                padding: const EdgeInsets.all(32),
                child: Text(
                  formeActuelle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: designNoir,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Quel cas et quel nombre ?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 24),

              for (final option in options) boutonOption(option),

              if (optionChoisie != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      optionChoisie == reponseCorrecte
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: optionChoisie == reponseCorrecte
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        optionChoisie == reponseCorrecte
                            ? 'Correct !'
                            : 'Faux — la bonne réponse était : $reponseCorrecte',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: optionChoisie == reponseCorrecte
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const Spacer(),

              if (optionChoisie != null)
                ElevatedButton(
                  style: styleBoutonAccent,
                  onPressed: suivant,
                  child: Text(
                    index + 1 >= _totalQuestions ? 'Terminer' : 'Suivant',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
