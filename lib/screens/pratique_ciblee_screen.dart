import 'dart:math';

import 'package:flutter/material.dart';

import 'package:itinera/latin/declinaison.dart';
import 'package:itinera/latin/erreurs_declinaison.dart';
import 'package:itinera/main.dart' show texteAttenue, texteClair;

// Pratique ciblée : ne pose des questions que sur les catégories (cas +
// nombre) où l'utilisateur se trompe le plus souvent, sur des mots tirés
// au hasard — plutôt que le paradigme complet d'un seul mot.
class PratiqueCibleeScreen extends StatefulWidget {
  final List<(String cas, bool pluriel, int occurrences)> categories;

  const PratiqueCibleeScreen({super.key, required this.categories});

  @override
  State<PratiqueCibleeScreen> createState() => _PratiqueCibleeScreenState();
}

class _PratiqueCibleeScreenState extends State<PratiqueCibleeScreen> {
  static const _totalQuestions = 10;

  final _rng = Random();
  late final List<ParadigmeNominal> _mots = paradigmesDisponibles();

  final _controleur = TextEditingController();
  final _focus = FocusNode();

  int _index = 0;
  int _score = 0;
  String? _feedback;
  bool _correct = false;

  late ParadigmeNominal _motActuel;
  late Cas _casActuel;
  late bool _plurielActuel;

  @override
  void initState() {
    super.initState();
    _genererQuestion();
  }

  @override
  void dispose() {
    _controleur.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _genererQuestion() {
    final categorie = widget.categories[_rng.nextInt(widget.categories.length)];
    _motActuel = _mots[_rng.nextInt(_mots.length)];
    _casActuel = casDepuisLibelle(categorie.$1);
    _plurielActuel = categorie.$2;
  }

  void _valider() {
    if (_feedback != null || _controleur.text.trim().isEmpty) return;

    final bonneReponse = _motActuel.forme(_casActuel, pluriel: _plurielActuel);
    final correct = _controleur.text.trim().toLowerCase() == bonneReponse.toLowerCase();

    if (!correct) {
      final confusion = formeConfondue(_motActuel, _controleur.text, _casActuel, _plurielActuel);
      enregistrerErreurDeclinaison(
        casCible: _casActuel.libelle,
        plurielCible: _plurielActuel,
        casConfondu: confusion?.$1.libelle,
        plurielConfondu: confusion?.$2,
      );
    }

    setState(() {
      _correct = correct;
      _feedback = correct ? 'Correct !' : 'Faux — c\'était : $bonneReponse';
      if (correct) _score++;
    });
  }

  void _suivant() {
    if (_index + 1 >= _totalQuestions) {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Pratique terminée'),
          content: Text('$_score / $_totalQuestions bonnes réponses'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Terminer'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _index++;
      _controleur.clear();
      _feedback = null;
      _genererQuestion();
    });
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pratique ciblée (${_index + 1}/$_totalQuestions)')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Score : $_score', style: const TextStyle(color: texteAttenue)),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      _motActuel.lemme,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(_motActuel.traduction, style: TextStyle(color: texteAttenue)),
                    const SizedBox(height: 16),
                    Text(
                      '${_casActuel.libelle} ${_plurielActuel ? 'pluriel' : 'singulier'} ?',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controleur,
              focusNode: _focus,
              autofocus: true,
              enabled: _feedback == null,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(labelText: 'Ta réponse'),
              onSubmitted: (_) => _valider(),
            ),
            const SizedBox(height: 16),
            if (_feedback != null)
              Text(
                _feedback!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _correct ? Colors.green : Colors.red,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(foregroundColor: texteClair),
              onPressed: _feedback == null ? _valider : _suivant,
              child: Text(
                _feedback == null
                    ? 'Valider'
                    : (_index + 1 >= _totalQuestions ? 'Terminer' : 'Suivant'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
