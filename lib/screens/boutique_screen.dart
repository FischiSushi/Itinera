import 'package:flutter/material.dart';

import 'package:itinera/main.dart';
import 'package:itinera/widgets/avatar_glyphe.dart';

// ============================================================
// BOUTIQUE
// ============================================================

class BoutiqueScreen extends StatefulWidget {
  const BoutiqueScreen({super.key});

  @override
  State<BoutiqueScreen> createState() => _BoutiqueScreenState();
}

class _BoutiqueScreenState extends State<BoutiqueScreen> {
  void acheter(ArticleBoutique article) {
    final reussi = acheterArticle(article);

    final message = reussi
        ? '${article.nom} acheté !'
        : 'Pas assez de deniers pour ${article.nom}.';

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final possedes = avatarsPossedes();
    final equipe = avatarEquipe();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boutique'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: badgeDeniers(coins())),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          if (gelsDeSerie() > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                '🧊 ${gelsDeSerie()} gel(s) de série en réserve — '
                'protège ta série un jour manqué',
                style: const TextStyle(color: texteAttenue),
              ),
            ),

          for (final article in articlesBoutique) ...[
            Card(
              child: ListTile(
                leading: AvatarGlyphe(valeur: article.emoji, taille: 40),

                title: Text(article.nom),

                subtitle: Text(
                  article.estAvatar
                      ? 'Avatar cosmétique'
                      : 'Protège ta série un jour manqué',
                ),

                trailing: article.estAvatar && possedes.contains(article.emoji)
                    ? (equipe == article.emoji
                          ? const Chip(label: Text('Équipé'))
                          : ElevatedButton(
                              onPressed: () {
                                equiperAvatar(article.emoji);
                                setState(() {});
                              },
                              child: const Text('Équiper'),
                            ))
                    : ElevatedButton(
                        onPressed: () => acheter(article),
                        child: Text('${article.prix} deniers'),
                      ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
