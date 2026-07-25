import 'package:flutter/material.dart';

import 'package:itinera/latin/erreurs_declinaison.dart';
import 'package:itinera/main.dart' show accentViolet, texteAttenue, texteClair;
import 'package:itinera/screens/pratique_ciblee_screen.dart';

class PointsFaiblesScreen extends StatefulWidget {
  const PointsFaiblesScreen({super.key});

  @override
  State<PointsFaiblesScreen> createState() => _PointsFaiblesScreenState();
}

class _PointsFaiblesScreenState extends State<PointsFaiblesScreen> {
  static const _medailles = ['🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    final confusions = confusionsFrequentes();
    final categories = categoriesFaibles();

    return Scaffold(
      appBar: AppBar(title: const Text('Points faibles')),
      body: categories.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.insights, size: 48, color: texteAttenue),
                    const SizedBox(height: 16),
                    const Text(
                      'Pas encore assez de données.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fais quelques exercices de déclinaison (Morphologie, '
                      'Teste-moi, Déclinaison rapide) pour voir apparaître '
                      'tes points faibles ici.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: texteAttenue),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (confusions.isNotEmpty) ...[
                  const Text(
                    'Tes confusions fréquentes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  for (var i = 0; i < confusions.length; i++)
                    Card(
                      child: ListTile(
                        leading: Text(
                          i < _medailles.length ? _medailles[i] : '${i + 1}.',
                          style: const TextStyle(fontSize: 20),
                        ),
                        title: Text(
                          '${confusions[i].libelleCible} confondu avec '
                          '${confusions[i].libelleConfondu}',
                        ),
                        trailing: Text(
                          '${confusions[i].occurrences}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
                Text(
                  'Catégories à travailler',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      for (final c in categories)
                        ListTile(
                          title: Text('${c.$1} ${c.$2 ? 'pluriel' : 'singulier'}'),
                          trailing: Text(
                            '${c.$3} erreur${c.$3 > 1 ? 's' : ''}',
                            style: TextStyle(color: texteAttenue),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentViolet,
                    foregroundColor: texteClair,
                  ),
                  icon: const Icon(Icons.fitness_center),
                  label: const Text('Réviser mes points faibles'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PratiqueCibleeScreen(categories: categories),
                    ),
                  ).then((_) => setState(() {})),
                ),
              ],
            ),
    );
  }
}
