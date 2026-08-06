import 'package:flutter/material.dart';

import 'package:itinera/grammaire_tableaux_data.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';

// ============================================================
// GRAMMAIRE : TABLEAUX DE DÉCLINAISON
// ============================================================

class DeclinaisonsScreen extends StatelessWidget {
  const DeclinaisonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Déclinaisons'),
      ),

      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [
            for (final decl in declinaisons) ...[
              tableauDeclinaison(decl),
              const SizedBox(height: 16),
            ],
          ],
        ),
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
        TextSpan(
          text: radical,
          style: TextStyle(color: designNoir),
        ),
        TextSpan(
          text: terminaison,
          style: TextStyle(color: designAccent, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget tableauDeclinaison(Declinaison decl) {
  final radical = _radicalCommun(decl);

  return CarteDesign(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          decl.titre,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: designNoir,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          '${decl.exempleLatin} — ${decl.exempleFrancais}',
          style: TextStyle(color: designNoir.withValues(alpha: 0.6)),
        ),

        const SizedBox(height: 12),

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
                          style: TextStyle(
                            color: designNoir.withValues(alpha: 0.6),
                          ),
                        ),
                        if (roleCourtCas[cas] != null)
                          Text(
                            roleCourtCas[cas]!,
                            style: TextStyle(
                              fontSize: 11,
                              color: designNoir.withValues(alpha: 0.4),
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
  );
}
