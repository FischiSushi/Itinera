import 'package:flutter/material.dart';

import 'package:itinera/main.dart';
import 'package:itinera/textes_data.dart';
import 'package:itinera/screens/mes_textes_screen.dart';

class TextesHubScreen extends StatelessWidget {
  const TextesHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Textes latins')),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('Textes du manuel'),
              subtitle: const Text('Lectio 1 & 2, glosées'),
              trailing: const Icon(Icons.arrow_forward_ios),
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
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.edit_note),
              title: const Text('Mes textes'),
              subtitle: const Text(
                'Tes propres textes latins, à analyser et traduire',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MesTextesScreen(),
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
      appBar: AppBar(title: Text(titre)),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: textes.length,

        itemBuilder: (context, index) {
          final texte = textes[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                texte.titre,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(nomAffiche(texte.unite)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TexteDetailScreen(texte: texte),
                  ),
                );
              },
            ),
          );
        },
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
      appBar: AppBar(title: Text(texte.titre)),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          for (final paragraphe in texte.paragraphes) ...[
            Text(
              paragraphe.texte,
              style: const TextStyle(fontSize: 17, height: 1.5),
            ),
            if (paragraphe.glose != null) ...[
              const SizedBox(height: 4),
              Text(
                paragraphe.glose!,
                style: const TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: texteAttenue,
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],

          if (texte.banqueDeMots.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'Banque de mots',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: accentViolet,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final mot in texte.banqueDeMots) Chip(label: Text(mot)),
              ],
            ),
          ],

          if (texte.motsAConnaitre.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              'Mots à connaître',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: accentViolet,
              ),
            ),
            const SizedBox(height: 8),
            for (final mot in texte.motsAConnaitre)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mot.latin,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(mot.francais),
                      if (mot.etymologie != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          mot.etymologie!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: texteAttenue,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
