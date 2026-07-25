import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:itinera/main.dart' show accentViolet, orAntique, texteAttenue, texteClair;

const _onboardingVuKey = 'onboardingVu';

bool onboardingTermine() {
  final box = Hive.box('vocabBox');
  return (box.get(_onboardingVuKey) as bool?) ?? false;
}

void marquerOnboardingTermine() {
  Hive.box('vocabBox').put(_onboardingVuKey, true);
}

class _PageOnboarding {
  final IconData icone;
  final Color couleur;
  final String titre;
  final String texte;

  const _PageOnboarding({
    required this.icone,
    required this.couleur,
    required this.titre,
    required this.texte,
  });
}

const _pages = [
  _PageOnboarding(
    icone: Icons.auto_stories,
    couleur: accentViolet,
    titre: 'Bienvenue dans Itinera',
    texte: 'Apprends le latin pas à pas : vocabulaire, grammaire, textes '
        'et exercices, organisés comme ton année scolaire.',
  ),
  _PageOnboarding(
    icone: Icons.local_fire_department,
    couleur: Colors.orange,
    titre: 'Ta série',
    texte: 'Chaque jour où tu révises au moins une carte de vocabulaire '
        'compte pour ta série. Reviens régulièrement pour la faire grandir '
        '— un rappel quotidien peut t\'aider (réglable dans Paramètres).',
  ),
  _PageOnboarding(
    icone: Icons.diamond,
    couleur: orAntique,
    titre: 'Deniers et boutique',
    texte: 'Réussis des révisions et débloque des succès pour gagner des '
        'deniers. Dépense-les dans la boutique pour changer d\'avatar ou '
        'protéger ta série avec un gel.',
  ),
  _PageOnboarding(
    icone: Icons.emoji_events,
    couleur: accentViolet,
    titre: 'Succès et progression',
    texte: 'Consulte tes succès et tes statistiques à tout moment depuis '
        'l\'onglet Plus. Prêt à commencer ?',
  ),
];

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onTermine;

  const OnboardingScreen({super.key, required this.onTermine});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controleur = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controleur.dispose();
    super.dispose();
  }

  void _terminer() {
    marquerOnboardingTermine();
    widget.onTermine();
  }

  void _suivant() {
    if (_index + 1 >= _pages.length) {
      _terminer();
      return;
    }
    _controleur.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final derniere = _index == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _terminer,
                child: Text('Passer', style: TextStyle(color: texteAttenue)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controleur,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(page.icone, size: 72, color: page.couleur),
                        const SizedBox(height: 32),
                        Text(
                          page.titre,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: texteClair,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.texte,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: texteAttenue, height: 1.4),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _pages.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _index ? accentViolet : texteAttenue.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _suivant,
                  child: Text(derniere ? 'Commencer' : 'Suivant'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
