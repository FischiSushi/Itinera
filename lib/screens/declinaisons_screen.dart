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

// Préfixe commun à toutes les formes de la déclinaison (calculé plutôt que
// stocké dans les données) : ce qui reste après ce préfixe est la
// terminaison propre à chaque cas, mise en évidence dans le tableau.
String _radicalCommun(Declinaison decl) {
  final formes = [...decl.singulier.values, ...decl.pluriel.values];

  var prefixe = formes.first;

  for (final forme in formes.skip(1)) {
    var longueur = 0;
    while (longueur < prefixe.length &&
        longueur < forme.length &&
        prefixe[longueur] == forme[longueur]) {
      longueur++;
    }
    prefixe = prefixe.substring(0, longueur);
  }

  return prefixe;
}

Widget _celluleForme(String forme, String radical) {
  final terminaison = forme.substring(radical.length);

  return Text.rich(
    TextSpan(
      children: [
        TextSpan(text: radical),
        TextSpan(
          text: terminaison,
          style: const TextStyle(
            color: accentViolet,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget tableauDeclinaison(Declinaison decl) {
  final radical = _radicalCommun(decl);

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cas,
                            style: const TextStyle(color: texteAttenue),
                          ),
                          if (roleCourtCas[cas] != null)
                            Text(
                              roleCourtCas[cas]!,
                              style: TextStyle(
                                fontSize: 11,
                                color: texteAttenue.withValues(alpha: 0.65),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _celluleForme(decl.singulier[cas]!, radical),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _celluleForme(decl.pluriel[cas]!, radical),
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
