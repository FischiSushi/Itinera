import 'package:flutter/material.dart';

import 'package:itinera/design/palette.dart';
import 'package:itinera/screens/accueil_screen.dart';
import 'package:itinera/screens/plus_screen.dart';
import 'package:itinera/screens/statistiques_screen.dart';
import 'package:itinera/screens/textes_hub_screen.dart';
import 'package:itinera/screens/unite_screen.dart';

// ============================================================
// NAVIGATION PRINCIPALE
// ============================================================

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;

  // Recréée à chaque build, et surtout PAS const : IndexedStack garde
  // chaque onglet monté même quand il n'est pas affiché, mais deux
  // instances `const AccueilScreen()` sont le même objet canonicalisé
  // (identical() == true), donc Flutter saute le rebuild par optimisation
  // — sans jamais relire des réglages modifiés ailleurs (ex. le fond
  // étoilé) en revenant sur l'onglet Parcours. Une instance fraîche à
  // chaque accès force le rebuild tout en réutilisant le même State (même
  // type, pas de clé), donc sans perdre l'état interne de l'écran.
  List<Widget> get _ecrans => [
    AccueilScreen(),
    const UniteScreen(),
    const TextesHubScreen(),
    const StatistiquesScreen(),
    const PlusScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _ecrans),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: designFondProfond,
          indicatorColor: designAccent,
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.55),
            ),
          ),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontSize: 12,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w600
                  : FontWeight.normal,
              color: states.contains(WidgetState.selected)
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.55),
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (index) => setState(() => _index = index),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.route), label: 'Parcours'),
            NavigationDestination(
              icon: Icon(Icons.menu_book),
              label: 'Vocabulaire',
            ),
            NavigationDestination(
              icon: Icon(Icons.import_contacts),
              label: 'Textes',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Stats',
            ),
            NavigationDestination(icon: Icon(Icons.more_horiz), label: 'Plus'),
          ],
        ),
      ),
    );
  }
}
