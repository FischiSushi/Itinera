import 'package:flutter/material.dart';

import 'package:itinera/lecons_grammaire_data.dart';
import 'package:itinera/main.dart';
import 'package:itinera/vocabulaire_data.dart';
import 'package:itinera/screens/accueil_screen.dart';
import 'package:itinera/screens/unite_screen.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';

// ============================================================
// SÉLECTEUR D'UNITÉ (change quel parcours — leçons ou vocabulaire — est
// affiché)
// ============================================================

enum ModeSelecteurUnite { lecons, vocabulaire }

class SelecteurUniteScreen extends StatefulWidget {
  final ModeSelecteurUnite mode;

  const SelecteurUniteScreen({
    super.key,
    this.mode = ModeSelecteurUnite.lecons,
  });

  @override
  State<SelecteurUniteScreen> createState() => _SelecteurUniteScreenState();
}

class _SelecteurUniteScreenState extends State<SelecteurUniteScreen> {
  @override
  Widget build(BuildContext context) {
    final pourVocabulaire = widget.mode == ModeSelecteurUnite.vocabulaire;
    // Une entrée par année (Vol. I/II/III), pas par unité précise : les
    // leçons de toutes les unités d'une même année s'enchaînent dans un
    // seul chemin, l'une en dessous de l'autre.
    final volumes = vocabulaire
        .map((mot) => volumeDe(mot.unite))
        .toSet()
        .toList();

    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Choisir une année'),
      ),

      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),

          itemCount: volumes.length,

          itemBuilder: (context, index) {
            final volume = volumes[index];
            final nombreLecons = construireParcoursComplet()
                .where((lecon) => volumeDe(lecon.unite) == volume)
                .length;
            final nombreMots = vocabulaire
                .where((mot) => volumeDe(mot.unite) == volume)
                .length;
            final nombre = pourVocabulaire ? nombreMots : nombreLecons;
            // Seuls les volumes qui ne font pas partie du programme officiel
            // (Vol. I/II/III) peuvent être supprimés — typiquement une entrée
            // créée par erreur via l'ajout de vocabulaire libre.
            final estSupprimable = !anneesParVolume.containsKey(volume);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CarteDesign(
                padding: EdgeInsets.zero,
                child: ListTile(
                  iconColor: designAccent,
                  textColor: designNoir,
                  leading: CircleAvatar(
                    backgroundColor: designAccent,
                    foregroundColor: Colors.white,
                    child: Text('$index'),
                  ),
                  title: Text(
                    anneesParVolume[volume] ?? volume,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    nombre > 0
                        ? pourVocabulaire
                              ? '$nombre mot(s) de vocabulaire'
                              : '$nombre leçon(s) de grammaire'
                        : estSupprimable
                        ? 'Bientôt disponible · appui long pour supprimer'
                        : 'Bientôt disponible',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => pourVocabulaire
                            ? UniteScreen(unite: volume)
                            : AccueilScreen(unite: volume),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
