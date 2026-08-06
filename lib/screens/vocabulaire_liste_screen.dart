import 'package:flutter/material.dart';

import 'package:itinera/main.dart';
import 'package:itinera/vocabulaire_data.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/screens/vocabulaire_screen.dart';

// ============================================================
// LISTE DER VOKABELN EINER UNITÉ
// ============================================================

class VocabulaireListeScreen extends StatefulWidget {
  final String unite;

  const VocabulaireListeScreen({super.key, required this.unite});

  @override
  State<VocabulaireListeScreen> createState() => _VocabulaireListeScreenState();
}

class _VocabulaireListeScreenState extends State<VocabulaireListeScreen> {
  String get unite => widget.unite;

  @override
  Widget build(BuildContext context) {
    final maintenant = DateTime.now().toUtc();

    final vocabulaireDeCetteUnite = vocabulaire
        .where((mot) => mot.unite == unite)
        .toList();

    final dueDeCetteUnite = vocabulaireDeCetteUnite
        .where((mot) => mot.estDu(maintenant))
        .toList();

    final categories = <String>[];
    final motsParCategorie = <String, List<Vocabulaire>>{};

    for (final mot in vocabulaireDeCetteUnite) {
      if (!motsParCategorie.containsKey(mot.categorie)) {
        categories.add(mot.categorie);
        motsParCategorie[mot.categorie] = [];
      }
      motsParCategorie[mot.categorie]!.add(mot);
    }

    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(nomAffiche(unite)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Réviser les cartes dues (${dueDeCetteUnite.length})',
            onPressed: dueDeCetteUnite.isEmpty
                ? null
                : () => demarrerRevision(context, dueDeCetteUnite),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_fill),
            tooltip: 'Réviser toute l\'unité',
            onPressed: vocabulaireDeCetteUnite.isEmpty
                ? null
                : () => demarrerRevision(context, vocabulaireDeCetteUnite),
          ),
          IconButton(
            icon: const Icon(Icons.extension),
            tooltip: 'Jeux (choix multiple, association)',
            onPressed: vocabulaireDeCetteUnite.isEmpty
                ? null
                : () => choisirJeu(context, vocabulaireDeCetteUnite),
          ),
        ],
      ),

      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),

          itemCount: categories.length,

          itemBuilder: (context, indexCategorie) {
            final categorie = categories[indexCategorie];
            final motsDeCetteCategorie = motsParCategorie[categorie]!;
            final dueDeCetteCategorie = motsDeCetteCategorie
                .where((mot) => mot.estDu(maintenant))
                .toList();

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: designBlanc,
                borderRadius: BorderRadius.circular(20),
              ),

              child: ExpansionTile(
                shape: const RoundedRectangleBorder(side: BorderSide.none),
                collapsedShape: const RoundedRectangleBorder(
                  side: BorderSide.none,
                ),
                iconColor: designNoir,
                collapsedIconColor: designNoir.withValues(alpha: 0.5),
                title: Text(
                  categorie,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: designNoir,
                  ),
                ),

                subtitle: Text(
                  '${motsDeCetteCategorie.length} mots · ${dueDeCetteCategorie.length} à revoir',
                  style: TextStyle(color: designNoir.withValues(alpha: 0.6)),
                ),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      color: designAccent,
                      tooltip:
                          'Réviser les cartes dues (${dueDeCetteCategorie.length})',
                      onPressed: dueDeCetteCategorie.isEmpty
                          ? null
                          : () =>
                                demarrerRevision(context, dueDeCetteCategorie),
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_circle_outline),
                      color: designAccent,
                      tooltip: 'Réviser cette catégorie',
                      onPressed: () =>
                          demarrerRevision(context, motsDeCetteCategorie),
                    ),
                    Icon(
                      Icons.expand_more,
                      color: designNoir.withValues(alpha: 0.5),
                    ),
                  ],
                ),

                children: motsDeCetteCategorie.map((mot) {
                  final index = vocabulaireDeCetteUnite.indexOf(mot);

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),

                    title: Text(
                      mot.latin,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: designNoir,
                      ),
                    ),

                    subtitle: Text(
                      mot.francais,
                      style: TextStyle(
                        color: designNoir.withValues(alpha: 0.6),
                      ),
                    ),

                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: designNoir.withValues(alpha: 0.4),
                    ),

                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) {
                            return VocabulaireScreen(
                              vocabulaire: vocabulaireDeCetteUnite,
                              startIndex: index,
                            );
                          },
                        ),
                      );
                    },

                    onLongPress: () async {
                      final supprime = await confirmerSuppression(context, mot);

                      if (supprime) setState(() {});
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
