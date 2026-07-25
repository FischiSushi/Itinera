import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:itinera/main.dart';

// ============================================================
// MINUTEUR COZY (POMODORO)
// ============================================================

const _couleurCozy = Color(0xFFE0A458);
const _fondCozy = Color(0xFF1E1912);

const _dureeTravailMinKey = 'pomodoroDureeTravailMin';
const _dureePauseMinKey = 'pomodoroDureePauseMin';

class _TassePainter extends CustomPainter {
  final double remplissage;
  final Color couleurTasse;
  final Color couleurCafe;

  _TassePainter({
    required this.remplissage,
    required this.couleurTasse,
    required this.couleurCafe,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final largeurCorps = size.width * 0.7;
    final hauteurCorps = size.height * 0.8;
    final gauche = (size.width - largeurCorps) / 2;
    final haut = size.height * 0.06;

    final corps = RRect.fromLTRBAndCorners(
      gauche,
      haut,
      gauche + largeurCorps,
      haut + hauteurCorps,
      topLeft: const Radius.circular(10),
      topRight: const Radius.circular(10),
      bottomLeft: const Radius.circular(30),
      bottomRight: const Radius.circular(30),
    );

    final traitTasse = Paint()
      ..color = couleurTasse
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    // Café, rempli du bas vers le haut selon la progression.
    canvas.save();
    canvas.clipRRect(corps);

    final hauteurCafe = hauteurCorps * remplissage.clamp(0.0, 1.0);

    canvas.drawRect(
      Rect.fromLTWH(
        gauche,
        haut + hauteurCorps - hauteurCafe,
        largeurCorps,
        hauteurCafe,
      ),
      Paint()..color = couleurCafe,
    );

    canvas.restore();

    // Anse de la tasse.
    final anse = Rect.fromLTWH(
      gauche + largeurCorps - 10,
      haut + hauteurCorps * 0.2,
      size.width * 0.24,
      hauteurCorps * 0.5,
    );
    canvas.drawArc(anse, -1.4, 2.8, false, traitTasse);

    // Contour de la tasse, par-dessus le café.
    canvas.drawRRect(corps, traitTasse);
  }

  @override
  bool shouldRepaint(covariant _TassePainter oldDelegate) =>
      oldDelegate.remplissage != remplissage;
}

// État global du minuteur : vit en dehors du widget pour continuer à
// tourner (et ne pas se réinitialiser) même si on quitte cet écran.
class PomodoroEtat extends ChangeNotifier {
  static const _dureePauseLongue = 15 * 60;

  int dureeTravail;
  int dureePause;

  late int secondesRestantes;
  late int secondesTotalPhase;
  bool enPause = false;
  bool enCours = false;
  int cyclesTermines = 0;

  Timer? _minuteur;

  PomodoroEtat()
    : dureeTravail = _chargerDureeMinutes(_dureeTravailMinKey, 25) * 60,
      dureePause = _chargerDureeMinutes(_dureePauseMinKey, 5) * 60 {
    secondesRestantes = dureeTravail;
    secondesTotalPhase = dureeTravail;
  }

  static int _chargerDureeMinutes(String cle, int defaut) {
    final box = Hive.box('vocabBox');
    return (box.get(cle) as int?) ?? defaut;
  }

  void definirDurees({required int travailMinutes, required int pauseMinutes}) {
    final box = Hive.box('vocabBox');
    box.put(_dureeTravailMinKey, travailMinutes);
    box.put(_dureePauseMinKey, pauseMinutes);

    dureeTravail = travailMinutes * 60;
    dureePause = pauseMinutes * 60;

    if (!enCours) {
      secondesRestantes = enPause ? dureePause : dureeTravail;
      secondesTotalPhase = secondesRestantes;
    }

    notifyListeners();
  }

  void demarrer() {
    if (enCours) return;

    enCours = true;

    _minuteur = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondesRestantes > 0) {
        secondesRestantes--;
      } else {
        _terminerPhase();
      }
      notifyListeners();
    });

    notifyListeners();
  }

  void mettreEnPause() {
    _minuteur?.cancel();
    enCours = false;
    notifyListeners();
  }

  void reinitialiser() {
    _minuteur?.cancel();

    enCours = false;
    enPause = false;
    secondesRestantes = dureeTravail;
    secondesTotalPhase = dureeTravail;

    notifyListeners();
  }

  void _terminerPhase() {
    _minuteur?.cancel();

    if (!enPause) {
      cyclesTermines++;
      enregistrerPomodoroTermine();
      ajouterCoins(10);
      verifierNouveauxSucces();
    }

    final prochainePause = !enPause;
    final pauseLongue = prochainePause && cyclesTermines % 4 == 0;

    final duree = prochainePause
        ? (pauseLongue ? _dureePauseLongue : dureePause)
        : dureeTravail;

    enPause = prochainePause;
    secondesRestantes = duree;
    secondesTotalPhase = duree;
    enCours = false;
  }
}

final pomodoroEtat = PomodoroEtat();

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _dernierCyclesTermines = pomodoroEtat.cyclesTermines;

  @override
  void initState() {
    super.initState();
    pomodoroEtat.addListener(_surMiseAJour);
  }

  @override
  void dispose() {
    pomodoroEtat.removeListener(_surMiseAJour);
    super.dispose();
  }

  void _surMiseAJour() {
    if (!mounted) return;

    if (pomodoroEtat.cyclesTermines != _dernierCyclesTermines) {
      _dernierCyclesTermines = pomodoroEtat.cyclesTermines;
      verifierSuccesEtNotifier(context);
    }

    setState(() {});
  }

  Future<void> _ouvrirReglages() async {
    int travail = (pomodoroEtat.dureeTravail / 60).round();
    int pause = (pomodoroEtat.dureePause / 60).round();

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Durées',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _ligneStepper(
                      label: 'Concentration',
                      valeur: travail,
                      onMoins: () {
                        setSheetState(() {
                          travail = (travail - 5).clamp(5, 90);
                        });
                      },
                      onPlus: () {
                        setSheetState(() {
                          travail = (travail + 5).clamp(5, 90);
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    _ligneStepper(
                      label: 'Pause',
                      valeur: pause,
                      onMoins: () {
                        setSheetState(() {
                          pause = (pause - 5).clamp(5, 30);
                        });
                      },
                      onPlus: () {
                        setSheetState(() {
                          pause = (pause + 5).clamp(5, 30);
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _couleurCozy,
                          foregroundColor: _fondCozy,
                        ),
                        onPressed: () {
                          pomodoroEtat.definirDurees(
                            travailMinutes: travail,
                            pauseMinutes: pause,
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Appliquer'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _ligneStepper({
    required String label,
    required int valeur,
    required VoidCallback onMoins,
    required VoidCallback onPlus,
  }) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
        IconButton(
          onPressed: onMoins,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        SizedBox(
          width: 56,
          child: Text(
            '$valeur min',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          onPressed: onPlus,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }

  String get texteTemps {
    final s = pomodoroEtat.secondesRestantes;
    final minutes = (s ~/ 60).toString().padLeft(2, '0');
    final secondes = (s % 60).toString().padLeft(2, '0');
    return '$minutes:$secondes';
  }

  @override
  Widget build(BuildContext context) {
    final progression =
        1 - (pomodoroEtat.secondesRestantes / pomodoroEtat.secondesTotalPhase);

    return Scaffold(
      backgroundColor: _fondCozy,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Minuteur cozy'),
        actions: [
          IconButton(
            onPressed: pomodoroEtat.enCours ? null : _ouvrirReglages,
            icon: const Icon(Icons.tune),
            tooltip: 'Choisir la durée',
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              pomodoroEtat.enPause ? Icons.local_cafe : Icons.menu_book,
              size: 40,
              color: _couleurCozy,
            ),

            const SizedBox(height: 12),

            Text(
              pomodoroEtat.enPause ? 'Pause' : 'Concentration',
              style: const TextStyle(
                fontSize: 18,
                color: texteAttenue,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              texteTemps,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: texteClair,
              ),
            ),

            const SizedBox(height: 16),

            CustomPaint(
              size: const Size(220, 240),
              painter: _TassePainter(
                remplissage: progression.clamp(0, 1).toDouble(),
                couleurTasse: _couleurCozy,
                couleurCafe: const Color(0xFF6F4423),
              ),
            ),

            const SizedBox(height: 32),

            Text(
              '🍅 ${pomodoroEtat.cyclesTermines} session(s) terminée(s) aujourd\'hui',
              style: const TextStyle(color: texteAttenue),
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 32,
                  onPressed: pomodoroEtat.reinitialiser,
                  icon: const Icon(Icons.replay, color: texteAttenue),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _couleurCozy,
                    foregroundColor: _fondCozy,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(24),
                  ),
                  onPressed: pomodoroEtat.enCours
                      ? pomodoroEtat.mettreEnPause
                      : pomodoroEtat.demarrer,
                  child: Icon(
                    pomodoroEtat.enCours ? Icons.pause : Icons.play_arrow,
                    size: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
