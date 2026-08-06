import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

import 'package:itinera/main.dart';
import 'package:itinera/services/tts_service.dart';
import 'package:itinera/vocabulaire_data.dart';
import 'package:itinera/design/palette.dart';

// ============================================================
// VOKABELTRAINER
// ============================================================

class VocabulaireScreen extends StatefulWidget {
  final List<Vocabulaire> vocabulaire;
  final int startIndex;
  final String direction;

  const VocabulaireScreen({
    super.key,
    required this.vocabulaire,
    required this.startIndex,
    this.direction = directionLatinVersFrancais,
  });

  @override
  State<VocabulaireScreen> createState() {
    return _VocabulaireScreenState();
  }
}

class _VocabulaireScreenState extends State<VocabulaireScreen> {
  late int aktuellerIndex;

  bool antwortSichtbar = false;

  @override
  void initState() {
    super.initState();

    aktuellerIndex = widget.startIndex;
  }

  void naechsteKarte() {
    setState(() {
      aktuellerIndex = (aktuellerIndex + 1) % widget.vocabulaire.length;

      antwortSichtbar = false;
    });
  }

  void vorherigeKarte() {
    setState(() {
      aktuellerIndex--;

      if (aktuellerIndex < 0) {
        aktuellerIndex = widget.vocabulaire.length - 1;
      }

      antwortSichtbar = false;
    });
  }

  void antwortUmschalten() {
    setState(() {
      antwortSichtbar = !antwortSichtbar;
    });
  }

  void carteEvaluee(String evaluation) {
    final carte = widget.vocabulaire[aktuellerIndex];

    final rating = switch (evaluation) {
      'again' => fsrs.Rating.again,
      'hard' => fsrs.Rating.hard,
      'good' => fsrs.Rating.good,
      _ => fsrs.Rating.easy,
    };

    final result = scheduler.reviewCard(carte.carte(widget.direction), rating);
    carte.definirCarte(widget.direction, result.card);

    Hive.box(
      'vocabBox',
    ).put('${carte.latin}::${widget.direction}', result.card.toMap());
    registrerActiviteDuJour();
    enregistrerRevisionDuJour();

    if (rating == fsrs.Rating.good || rating == fsrs.Rating.easy) {
      ajouterCoins(1);
    }

    verifierSuccesEtNotifier(context);

    naechsteKarte();
  }

  void afficherEtymologie(String etymologie) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Étymologie',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SelectableText(etymologie),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final aktuelleVokabel = widget.vocabulaire[aktuellerIndex];

    final estLatinVersFrancais = widget.direction == directionLatinVersFrancais;

    final question = estLatinVersFrancais
        ? aktuelleVokabel.latin
        : aktuelleVokabel.francais;

    final reponse = estLatinVersFrancais
        ? aktuelleVokabel.francais
        : aktuelleVokabel.latin;

    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Révision'),
      ),

      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              // KARTE
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: designBlanc,
                      borderRadius: BorderRadius.circular(24),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(24),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Text(
                            aktuelleVokabel.categorie.toUpperCase(),

                            style: TextStyle(
                              color: designNoir.withValues(alpha: 0.5),
                              letterSpacing: 1.5,
                            ),
                          ),

                          const SizedBox(height: 24),

                          Text(
                            question,

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: designNoir,
                            ),
                          ),

                          const SizedBox(height: 30),

                          if (antwortSichtbar)
                            Text(
                              reponse,

                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontSize: 23,
                                color: designAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: IconButton(
                      icon: Icon(
                        Icons.volume_up,
                        color: designNoir.withValues(alpha: 0.5),
                      ),
                      tooltip: 'Écouter la prononciation',
                      onPressed: () {
                        TtsService.instance.prononcer(aktuelleVokabel.latin);
                      },
                    ),
                  ),
                  if (aktuelleVokabel.etymologie != null)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          color: designNoir.withValues(alpha: 0.5),
                        ),
                        onPressed: () {
                          afficherEtymologie(aktuelleVokabel.etymologie!);
                        },
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 35),

              // ANTWORT
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: designAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: antwortUmschalten,

                  child: Text(
                    antwortSichtbar
                        ? 'Masquer la réponse'
                        : 'Afficher la réponse',
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const SizedBox(height: 25),

              if (antwortSichtbar)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // AGAIN
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          carteEvaluee('again');
                        },
                        child: const Text('À revoir'),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // HARD
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          carteEvaluee('hard');
                        },
                        child: const Text('Difficile'),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // GOOD
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          carteEvaluee('good');
                        },
                        child: const Text('Bien'),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // EASY
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          carteEvaluee('easy');
                        },
                        child: const Text('Facile'),
                      ),
                    ),
                  ],
                ),

              // NAVIGATION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  IconButton(
                    onPressed: vorherigeKarte,

                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),

                  TextButton(
                    onPressed: naechsteKarte,

                    child: const Text(
                      'Suivant →',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
