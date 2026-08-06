import 'package:flutter/material.dart';

import 'package:itinera/latin/declinaison.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';
import 'package:itinera/screens/test_declinaison_screen.dart';

class ParadigmeDetailScreen extends StatelessWidget {
  final ParadigmeNominal paradigme;

  const ParadigmeDetailScreen({super.key, required this.paradigme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(paradigme.lemme),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CarteDesign(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${paradigme.declinaison}e déclinaison',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: designNoir,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      paradigme.traduction,
                      style: TextStyle(
                        color: designNoir.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.3),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          children: [
                            const SizedBox(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                'Singulier',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: designNoir,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                'Pluriel',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: designNoir,
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (final cas in ordreCas)
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Text(
                                  cas.libelle,
                                  style: TextStyle(
                                    color: designNoir.withValues(alpha: 0.6),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Text(
                                  paradigme.singulier[cas]!,
                                  style: TextStyle(color: designNoir),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Text(
                                  paradigme.pluriel[cas]!,
                                  style: TextStyle(color: designNoir),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: styleBoutonAccent,
                icon: const Icon(Icons.quiz),
                label: const Text('Teste-moi'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TestDeclinaisonScreen(paradigme: paradigme),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
