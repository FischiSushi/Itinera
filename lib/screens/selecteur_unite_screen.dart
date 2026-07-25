import 'package:flutter/material.dart';

import 'package:itinera/lecons_grammaire_data.dart';
import 'package:itinera/main.dart';
import 'package:itinera/vocabulaire_data.dart';
import 'package:itinera/screens/accueil_screen.dart';

// ============================================================
// SÉLECTEUR D'UNITÉ (change quel parcours de leçons est affiché)
// ============================================================

class SelecteurUniteScreen extends StatefulWidget {
  const SelecteurUniteScreen({super.key});

  @override
  State<SelecteurUniteScreen> createState() => _SelecteurUniteScreenState();
}

class _SelecteurUniteScreenState extends State<SelecteurUniteScreen> {
  @override
  Widget build(BuildContext context) {
    // Une entrée par année (Vol. I/II/III), pas par unité précise : les
    // leçons de toutes les unités d'une même année s'enchaînent dans un
    // seul chemin, l'une en dessous de l'autre.
    final volumes = vocabulaire
        .map((mot) => volumeDe(mot.unite))
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Choisir une année')),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: volumes.length,

        itemBuilder: (context, index) {
          final volume = volumes[index];
          final nombreLecons = construireParcoursComplet()
              .where((lecon) => volumeDe(lecon.unite) == volume)
              .length;
          // Seuls les volumes qui ne font pas partie du programme officiel
          // (Vol. I/II/III) peuvent être supprimés — typiquement une entrée
          // créée par erreur via l'ajout de vocabulaire libre.
          final estSupprimable = !anneesParVolume.containsKey(volume);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: accentViolet,
                foregroundColor: texteClair,
                child: Text('$index'),
              ),
              title: Text(
                anneesParVolume[volume] ?? volume,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                nombreLecons > 0
                    ? '$nombreLecons leçon(s) de grammaire'
                    : estSupprimable
                    ? 'Bientôt disponible · appui long pour supprimer'
                    : 'Bientôt disponible',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccueilScreen(unite: volume),
                  ),
                );
              },
              onLongPress: estSupprimable
                  ? () async {
                      final supprime = await confirmerSuppressionVolume(
                        context,
                        volume,
                      );
                      if (supprime) setState(() {});
                    }
                  : null,
            ),
          );
        },
      ),
    );
  }
}
