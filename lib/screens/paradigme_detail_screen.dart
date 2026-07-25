import 'package:flutter/material.dart';

import 'package:itinera/latin/declinaison.dart';
import 'package:itinera/main.dart' show texteAttenue;
import 'package:itinera/screens/test_declinaison_screen.dart';

class ParadigmeDetailScreen extends StatelessWidget {
  final ParadigmeNominal paradigme;

  const ParadigmeDetailScreen({super.key, required this.paradigme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(paradigme.lemme)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${paradigme.declinaison}e déclinaison',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(paradigme.traduction, style: TextStyle(color: texteAttenue)),
                    const SizedBox(height: 16),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.3),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                      },
                      children: [
                        const TableRow(
                          children: [
                            SizedBox(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Text('Singulier', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Text('Pluriel', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        for (final cas in ordreCas)
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(cas.libelle, style: TextStyle(color: texteAttenue)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(paradigme.singulier[cas]!),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(paradigme.pluriel[cas]!),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.quiz),
              label: const Text('Teste-moi'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestDeclinaisonScreen(paradigme: paradigme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
