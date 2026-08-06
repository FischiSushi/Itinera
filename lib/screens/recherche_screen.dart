import 'package:flutter/material.dart';

import 'package:itinera/main.dart';
import 'package:itinera/vocabulaire_data.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';

// ============================================================
// RECHERCHE
// ============================================================

Future<bool> afficherDetailVocabulaire(
  BuildContext context,
  Vocabulaire mot,
) async {
  final supprime = await showModalBottomSheet<bool>(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mot.latin,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${mot.categorie} · ${nomAffiche(mot.unite)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(mot.francais, style: const TextStyle(fontSize: 18)),
            if (mot.etymologie != null) ...[
              const SizedBox(height: 16),
              Text(
                'Étymologie',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SelectableText(mot.etymologie!),
            ],
            const SizedBox(height: 24),
            TextButton.icon(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: const Text(
                'Supprimer ce mot',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                final confirme = await confirmerSuppression(context, mot);

                if (confirme && context.mounted) {
                  Navigator.pop(context, true);
                }
              },
            ),
          ],
        ),
      );
    },
  );

  return supprime ?? false;
}

class RechercheScreen extends StatefulWidget {
  const RechercheScreen({super.key});

  @override
  State<RechercheScreen> createState() => _RechercheScreenState();
}

class _RechercheScreenState extends State<RechercheScreen> {
  String recherche = '';

  @override
  Widget build(BuildContext context) {
    final resultats = chercherDansVocabulaire(recherche);

    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Rechercher un mot...',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            border: InputBorder.none,
          ),
          onChanged: (valeur) {
            setState(() {
              recherche = valeur;
            });
          },
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: resultats.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final mot = resultats[index];

            return carteActionDesign(
              icone: Icons.menu_book_outlined,
              titre: mot.latin,
              sousTitre:
                  '${mot.categorie} · ${nomAffiche(mot.unite)} · ${mot.francais}',
              onTap: () async {
                final supprime = await afficherDetailVocabulaire(context, mot);

                if (supprime) setState(() {});
              },
            );
          },
        ),
      ),
    );
  }
}
