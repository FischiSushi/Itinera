import 'package:flutter/material.dart';

import 'package:itinera/latin/declinaison.dart';
import 'package:itinera/latin/erreurs_declinaison.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';

class TestDeclinaisonScreen extends StatefulWidget {
  final ParadigmeNominal paradigme;

  const TestDeclinaisonScreen({super.key, required this.paradigme});

  @override
  State<TestDeclinaisonScreen> createState() => _TestDeclinaisonScreenState();
}

class _TestDeclinaisonScreenState extends State<TestDeclinaisonScreen> {
  late final List<(Cas, bool)> _questions = [
    for (final cas in ordreCas) (cas, false),
    for (final cas in ordreCas) (cas, true),
  ]..shuffle();

  final _controleur = TextEditingController();
  final _focus = FocusNode();

  int _index = 0;
  int _score = 0;
  String? _feedback;
  bool _correct = false;

  @override
  void dispose() {
    _controleur.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _valider() {
    if (_feedback != null || _controleur.text.trim().isEmpty) return;

    final (cas, pluriel) = _questions[_index];
    final bonneReponse = widget.paradigme.forme(cas, pluriel: pluriel);
    final correct =
        _controleur.text.trim().toLowerCase() == bonneReponse.toLowerCase();

    if (!correct) {
      final confusion = formeConfondue(
        widget.paradigme,
        _controleur.text,
        cas,
        pluriel,
      );
      enregistrerErreurDeclinaison(
        casCible: cas.libelle,
        plurielCible: pluriel,
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
    if (_index + 1 >= _questions.length) {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Teste-moi terminé'),
          content: Text('$_score / ${_questions.length} bonnes réponses'),
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
    });
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final (cas, pluriel) = _questions[_index];

    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text('Teste-moi (${_index + 1}/${_questions.length})'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Score : $_score',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              CarteDesign(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      widget.paradigme.lemme,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: designNoir,
                      ),
                    ),
                    Text(
                      widget.paradigme.traduction,
                      style: TextStyle(
                        color: designNoir.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${cas.libelle} ${pluriel ? 'pluriel' : 'singulier'} ?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: designNoir,
                      ),
                    ),
                  ],
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
                style: styleBoutonAccent,
                onPressed: _feedback == null ? _valider : _suivant,
                child: Text(
                  _feedback == null
                      ? 'Valider'
                      : (_index + 1 >= _questions.length
                            ? 'Terminer'
                            : 'Suivant'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
