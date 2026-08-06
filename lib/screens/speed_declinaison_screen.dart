import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:itinera/latin/declinaison.dart';
import 'package:itinera/latin/erreurs_declinaison.dart';
import 'package:itinera/main.dart' show accentViolet;
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';

const _meilleurScoreSpeedKey = 'meilleurScoreDeclinaisonRapide';

int meilleurScoreDeclinaisonRapide() {
  final box = Hive.box('vocabBox');
  return (box.get(_meilleurScoreSpeedKey) as int?) ?? 0;
}

class SpeedDeclinaisonScreen extends StatefulWidget {
  const SpeedDeclinaisonScreen({super.key});

  @override
  State<SpeedDeclinaisonScreen> createState() => _SpeedDeclinaisonScreenState();
}

class _SpeedDeclinaisonScreenState extends State<SpeedDeclinaisonScreen> {
  static const _dureeTotale = 30;

  final _rng = Random();
  late final List<ParadigmeNominal> _mots = paradigmesDisponibles();

  final _controleur = TextEditingController();
  final _focus = FocusNode();

  Timer? _minuteur;
  int _tempsRestant = _dureeTotale;
  int _correctes = 0;
  int _total = 0;
  bool? _dernierResultat;
  bool _termine = false;

  late ParadigmeNominal _motActuel;
  late Cas _casActuel;
  late bool _plurielActuel;

  @override
  void initState() {
    super.initState();
    _genererQuestion();
    _minuteur = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  @override
  void dispose() {
    _minuteur?.cancel();
    _controleur.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _tick(Timer timer) {
    setState(() {
      _tempsRestant--;
      if (_tempsRestant <= 0) _terminer();
    });
  }

  void _genererQuestion() {
    _motActuel = _mots[_rng.nextInt(_mots.length)];
    _casActuel = ordreCas[_rng.nextInt(ordreCas.length)];
    _plurielActuel = _rng.nextBool();
  }

  void _valider() {
    if (_termine || _controleur.text.trim().isEmpty) return;

    final bonneReponse = _motActuel.forme(_casActuel, pluriel: _plurielActuel);
    final correct =
        _controleur.text.trim().toLowerCase() == bonneReponse.toLowerCase();

    if (!correct) {
      final confusion = formeConfondue(
        _motActuel,
        _controleur.text,
        _casActuel,
        _plurielActuel,
      );
      enregistrerErreurDeclinaison(
        casCible: _casActuel.libelle,
        plurielCible: _plurielActuel,
        casConfondu: confusion?.$1.libelle,
        plurielConfondu: confusion?.$2,
      );
    }

    setState(() {
      _total++;
      if (correct) _correctes++;
      _dernierResultat = correct;
      _controleur.clear();
      _genererQuestion();
    });

    _focus.requestFocus();
  }

  void _terminer() {
    _minuteur?.cancel();
    _termine = true;

    if (_correctes > meilleurScoreDeclinaisonRapide()) {
      Hive.box('vocabBox').put(_meilleurScoreSpeedKey, _correctes);
    }
  }

  void _rejouer() {
    setState(() {
      _tempsRestant = _dureeTotale;
      _correctes = 0;
      _total = 0;
      _dernierResultat = null;
      _termine = false;
      _controleur.clear();
      _genererQuestion();
    });
    _minuteur = Timer.periodic(const Duration(seconds: 1), _tick);
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    if (_termine) {
      final record = meilleurScoreDeclinaisonRapide();
      final nouveauRecord = _correctes > 0 && _correctes >= record;

      return Scaffold(
        backgroundColor: designFond,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          title: const Text('Déclinaison rapide'),
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: designGradientFond),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    nouveauRecord ? Icons.emoji_events : Icons.timer_off,
                    size: 56,
                    color: accentViolet,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$_correctes bonnes réponses',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'sur $_total tentatives en ${_dureeTotale}s',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  if (nouveauRecord) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Nouveau record !',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: accentViolet,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    Text(
                      'Record : $record',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: styleBoutonAccent,
                    onPressed: _rejouer,
                    child: const Text('Rejouer'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Déclinaison rapide'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '✅ $_correctes / $_total',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    '${_tempsRestant}s',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: _tempsRestant <= 10 ? Colors.red : Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _dernierResultat == null
                      ? designBlanc
                      : (_dernierResultat! ? Colors.green : Colors.red),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_casActuel.libelle} ${_plurielActuel ? 'pluriel' : 'singulier'} — ${_motActuel.lemme}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _dernierResultat == null ? designNoir : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controleur,
                focusNode: _focus,
                autofocus: true,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'Ta réponse'),
                onSubmitted: (_) => _valider(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: styleBoutonAccent,
                onPressed: _valider,
                child: const Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
