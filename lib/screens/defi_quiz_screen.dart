import 'package:flutter/material.dart';

import 'package:itinera/main.dart' show texteAttenue, texteClair;
import 'package:itinera/services/duel_service.dart';
import 'package:itinera/vocabulaire_data.dart' show vocabulaire;

enum ModeDefi { creation, reponse }

// Quiz à choix multiple joué sur un jeu de mots figé (celui du défi), dans
// les deux sens : celui qui lance le défi (creation) joue son score puis
// crée le document Firestore ; celui qui reçoit (reponse) rejoue les mêmes
// mots puis complète le document avec son propre score.
class DefiQuizScreen extends StatefulWidget {
  final ModeDefi mode;
  final List<MotDefi> mots;

  // mode == creation
  final String? moi;
  final String? monNom;
  final String? monAvatar;
  final String? adversaireUid;
  final String? adversaireNom;
  final String? adversaireAvatar;

  // mode == reponse
  final String? defiId;

  const DefiQuizScreen({
    super.key,
    required this.mode,
    required this.mots,
    this.moi,
    this.monNom,
    this.monAvatar,
    this.adversaireUid,
    this.adversaireNom,
    this.adversaireAvatar,
    this.defiId,
  });

  @override
  State<DefiQuizScreen> createState() => _DefiQuizScreenState();
}

class _DefiQuizScreenState extends State<DefiQuizScreen> {
  final _duel = DuelService();

  late List<MotDefi> questions;
  int index = 0;
  int score = 0;
  List<String> options = [];
  String? optionChoisie;
  bool _envoiEnCours = false;

  @override
  void initState() {
    super.initState();
    questions = List.of(widget.mots)..shuffle();
    genererOptions();
  }

  void genererOptions() {
    final motActuel = questions[index];
    final bonneReponse = motActuel.francais;

    final distracteurs = vocabulaire
        .map((m) => m.francais)
        .where((r) => r != bonneReponse)
        .toSet()
        .toList()
      ..shuffle();

    options = [bonneReponse, ...distracteurs.take(3)]..shuffle();
    optionChoisie = null;
  }

  void repondre(String option) {
    if (optionChoisie != null) return;

    setState(() {
      optionChoisie = option;
      if (option == questions[index].francais) score++;
    });
  }

  Future<void> suivant() async {
    if (index + 1 >= questions.length) {
      await _terminer();
      return;
    }

    setState(() {
      index++;
      genererOptions();
    });
  }

  Future<void> _terminer() async {
    setState(() => _envoiEnCours = true);

    try {
      if (widget.mode == ModeDefi.creation) {
        await _duel.creerDefi(
          moi: widget.moi!,
          monNom: widget.monNom!,
          monAvatar: widget.monAvatar!,
          adversaire: widget.adversaireUid!,
          nomAdversaire: widget.adversaireNom!,
          avatarAdversaire: widget.adversaireAvatar!,
          mots: widget.mots,
          monScore: score,
        );
      } else {
        await _duel.repondreDefi(defiId: widget.defiId!, monScore: score);
      }
    } finally {
      if (mounted) setState(() => _envoiEnCours = false);
    }

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          widget.mode == ModeDefi.creation ? 'Défi envoyé !' : 'Défi terminé !',
        ),
        content: Text(
          widget.mode == ModeDefi.creation
              ? 'Score : $score / ${questions.length}\n'
                  '${widget.adversaireNom} recevra ton défi.'
              : 'Ton score : $score / ${questions.length}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (mounted) Navigator.pop(context);
  }

  Widget boutonOption(String option, String bonneReponse) {
    Color? couleur;

    if (optionChoisie != null) {
      if (option == bonneReponse) {
        couleur = Colors.green;
      } else if (option == optionChoisie) {
        couleur = Colors.red;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: couleur,
            foregroundColor: texteClair,
            disabledForegroundColor: texteClair.withValues(alpha: 0.8),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () => repondre(option),
          child: Text(option, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final motActuel = questions[index];
    final bonneReponse = motActuel.francais;

    return Scaffold(
      appBar: AppBar(
        title: Text('Défi (${index + 1}/${questions.length})'),
      ),
      body: AbsorbPointer(
        absorbing: _envoiEnCours,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Score : $score', style: const TextStyle(color: texteAttenue)),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    motActuel.latin,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              for (final option in options) boutonOption(option, bonneReponse),
              if (optionChoisie != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      optionChoisie == bonneReponse ? Icons.check_circle : Icons.cancel,
                      color: optionChoisie == bonneReponse ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        optionChoisie == bonneReponse
                            ? 'Correct !'
                            : 'Faux — la bonne réponse était : $bonneReponse',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: optionChoisie == bonneReponse ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const Spacer(),
              if (optionChoisie != null)
                ElevatedButton(
                  onPressed: _envoiEnCours ? null : suivant,
                  child: _envoiEnCours
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(index + 1 >= questions.length ? 'Terminer' : 'Suivant'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
