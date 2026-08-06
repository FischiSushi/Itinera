import 'package:flutter/material.dart';

import 'package:itinera/latin/erreurs_declinaison.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';
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
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Points faibles'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: categories.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.insights,
                        size: 48,
                        color: Colors.white70,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Pas encore assez de données.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Fais quelques exercices de déclinaison (Morphologie, '
                        'Teste-moi, Déclinaison rapide) pour voir apparaître '
                        'tes points faibles ici.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (var i = 0; i < confusions.length; i++) ...[
                      CarteDesign(
                        padding: EdgeInsets.zero,
                        child: ListTile(
                          textColor: designNoir,
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: designNoir,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    const SizedBox(height: 16),
                  ],
                  const Text(
                    'Catégories à travailler',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CarteDesign(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (final c in categories)
                          ListTile(
                            textColor: designNoir,
                            title: Text(
                              '${c.$1} ${c.$2 ? 'pluriel' : 'singulier'}',
                            ),
                            trailing: Text(
                              '${c.$3} erreur${c.$3 > 1 ? 's' : ''}',
                              style: TextStyle(
                                color: designNoir.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: styleBoutonAccent,
                    icon: const Icon(Icons.fitness_center),
                    label: const Text('Réviser mes points faibles'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PratiqueCibleeScreen(categories: categories),
                      ),
                    ).then((_) => setState(() {})),
                  ),
                ],
              ),
      ),
    );
  }
}
