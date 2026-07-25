import 'package:flutter/material.dart';

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

  late final List<Widget> _ecrans = [
    const AccueilScreen(),
    const UniteScreen(),
    const TextesHubScreen(),
    const StatistiquesScreen(),
    const PlusScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _ecrans),
      bottomNavigationBar: NavigationBar(
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
    );
  }
}
