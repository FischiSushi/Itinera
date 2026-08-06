import 'package:flutter/material.dart';

import 'package:itinera/main.dart';
import 'package:itinera/textes_data.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';
import 'package:itinera/screens/mes_textes_screen.dart';

class TextesHubScreen extends StatelessWidget {
  const TextesHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Textes latins'),
      ),

      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            carteActionDesign(
              icone: Icons.menu_book,
              titre: 'Textes du manuel',
              sousTitre: 'Lectio 1 & 2, glosées',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TexteListeScreen(
                      textes: lectures,
                      titre: 'Textes du manuel',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            carteActionDesign(
              icone: Icons.edit_note,
              titre: 'Mes textes',
              sousTitre: 'Tes propres textes latins, à analyser et traduire',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MesTextesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TexteListeScreen extends StatelessWidget {
  final List<Texte> textes;
  final String titre;

  const TexteListeScreen({
    super.key,
    required this.textes,
    required this.titre,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(titre),
      ),

      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),

          itemCount: textes.length,

          itemBuilder: (context, index) {
            final texte = textes[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: designBlanc,
                borderRadius: BorderRadius.circular(20),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    texte.titre,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: designNoir,
                    ),
                  ),
                  subtitle: Text(
                    nomAffiche(texte.unite),
                    style: TextStyle(color: designNoir.withValues(alpha: 0.6)),
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
                        builder: (context) => TexteDetailScreen(texte: texte),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TexteDetailScreen extends StatelessWidget {
  final Texte texte;

  const TexteDetailScreen({super.key, required this.texte});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(texte.titre),
      ),

      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: ListView(
          padding: const EdgeInsets.all(20),

          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: designBlanc,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final paragraphe in texte.paragraphes) ...[
                    Text(
                      paragraphe.texte,
                      style: TextStyle(
                        fontSize: 17,
                        height: 1.5,
                        color: designNoir,
                      ),
                    ),
                    if (paragraphe.glose != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        paragraphe.glose!,
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: designNoir.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],

                  if (texte.banqueDeMots.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Banque de mots',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: designOrTexte,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final mot in texte.banqueDeMots)
                          Chip(
                            label: Text(mot),
                            backgroundColor: designNoir.withValues(alpha: 0.05),
                            labelStyle: TextStyle(color: designNoir),
                            side: BorderSide.none,
                          ),
                      ],
                    ),
                  ],

                  if (texte.motsAConnaitre.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Mots à connaître',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: designOrTexte,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final mot in texte.motsAConnaitre)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: designNoir.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mot.latin,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: designNoir,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              mot.francais,
                              style: TextStyle(color: designNoir),
                            ),
                            if (mot.etymologie != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                mot.etymologie!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: designNoir.withValues(alpha: 0.6),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
