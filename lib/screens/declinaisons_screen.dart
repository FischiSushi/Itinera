import 'package:flutter/material.dart';

import 'package:itinera/grammaire_tableaux_data.dart';
import 'package:itinera/main.dart';

// ============================================================
// GRAMMAIRE : TABLEAUX DE DÉCLINAISON
// ============================================================

class DeclinaisonsScreen extends StatelessWidget {
  const DeclinaisonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Déclinaisons')),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          for (final decl in declinaisons) ...[
            tableauDeclinaison(decl),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

Widget tableauDeclinaison(Declinaison decl) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            decl.titre,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          Text(
            '${decl.exempleLatin} — ${decl.exempleFrancais}',
            style: const TextStyle(color: texteAttenue),
          ),

          const SizedBox(height: 12),

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
                    child: Text(
                      'Singulier',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      'Pluriel',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              for (final cas in casLatins)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        cas,
                        style: const TextStyle(color: texteAttenue),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(decl.singulier[cas]!),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(decl.pluriel[cas]!),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
