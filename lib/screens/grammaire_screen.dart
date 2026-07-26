import 'package:flutter/material.dart';

import 'package:itinera/grammaire_tableaux_data.dart';
import 'package:itinera/main.dart';
import 'package:itinera/screens/declinaisons_screen.dart';
import 'package:itinera/screens/generateur_declinaison_screen.dart';
import 'package:itinera/screens/morphologie_screen.dart';
import 'package:itinera/screens/points_faibles_screen.dart';
import 'package:itinera/screens/speed_declinaison_screen.dart';
import 'package:itinera/screens/stamm_trainer_screen.dart';

// Préfixe commun à toutes les formes d'un temps donné (calculé plutôt que
// stocké) : ce qui reste après ce préfixe est la terminaison personnelle,
// mise en évidence dans le tableau — même principe que pour les
// déclinaisons (voir declinaisons_screen.dart).
String _radicalCommunConjugaison(Map<String, String> formes) {
  final valeurs = formes.values.toList();

  var prefixe = valeurs.first;

  for (final forme in valeurs.skip(1)) {
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

Widget _celluleFormeConjugaison(String forme, String radical) {
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

Widget tableauConjugaison(Conjugaison conj) {
  final radical = _radicalCommunConjugaison(conj.present);

  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            conj.titre,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          Text(
            '${conj.tempsPrimitifs} « ${conj.traduction} »',
            style: const TextStyle(color: texteAttenue),
          ),

          const SizedBox(height: 12),

          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.3),
              1: FlexColumnWidth(1),
            },

            children: [
              for (final personne in personnesLatines)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        personne,
                        style: const TextStyle(color: texteAttenue),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _celluleFormeConjugaison(
                        conj.present[personne]!,
                        radical,
                      ),
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

Widget tableauImparfait(Conjugaison conj) {
  final imparfait = conj.imparfait;
  if (imparfait == null) return const SizedBox.shrink();

  final radical = _radicalCommunConjugaison(imparfait);

  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            conj.titre,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          Text(
            '${conj.tempsPrimitifs} « ${conj.traduction} »',
            style: const TextStyle(color: texteAttenue),
          ),

          const SizedBox(height: 12),

          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.3),
              1: FlexColumnWidth(1),
            },

            children: [
              for (final personne in personnesLatines)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        personne,
                        style: const TextStyle(color: texteAttenue),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _celluleFormeConjugaison(
                        imparfait[personne]!,
                        radical,
                      ),
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

// ============================================================
// GRAMMAIRE : ÉCRAN D'ACCUEIL
// ============================================================

class GrammaireScreen extends StatelessWidget {
  const GrammaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grammaire')),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.rule),
              title: const Text('Morphologie'),
              subtitle: const Text('Reconnaître le cas et le nombre'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MorphologieScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Déclinaisons'),
              subtitle: const Text('Tableaux de référence des 5 déclinaisons'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeclinaisonsScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Stammtrainer (verbes)'),
              subtitle: const Text('Reconnaître les radicaux des verbes'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StammTrainerScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.auto_awesome_mosaic),
              title: const Text('Générateur de déclinaisons'),
              subtitle: const Text('Choisis un nom, vois son tableau complet et teste-toi'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GenerateurDeclinaisonScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.bolt),
              title: const Text('Déclinaison rapide'),
              subtitle: const Text('30 secondes, le plus de bonnes réponses possible'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SpeedDeclinaisonScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.insights),
              title: const Text('Points faibles'),
              subtitle: const Text('Tes confusions les plus fréquentes, et de la pratique ciblée'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PointsFaiblesScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
