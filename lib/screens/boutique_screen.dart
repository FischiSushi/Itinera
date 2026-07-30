import 'package:flutter/material.dart';

import 'package:itinera/main.dart';
import 'package:itinera/design/palette.dart';
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
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Boutique'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.diamond, size: 20, color: designOr),
                  const SizedBox(width: 6),
                  Text(
                    '${coins()} denier${coins() == 1 ? '' : 's'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: designGradientFond),
        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [
            if (gelsDeSerie() > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '🧊 ${gelsDeSerie()} gel(s) de série en réserve — '
                  'protège ta série un jour manqué',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),

            for (final article in articlesBoutique) ...[
              Material(
                color: designBlanc,
                borderRadius: BorderRadius.circular(20),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  leading: AvatarGlyphe(valeur: article.emoji, taille: 40),

                  title: Text(
                    article.nom,
                    style: const TextStyle(color: designNoir),
                  ),

                  subtitle: Text(
                    article.estAvatar
                        ? 'Avatar cosmétique'
                        : 'Protège ta série un jour manqué',
                    style: TextStyle(color: designNoir.withValues(alpha: 0.6)),
                  ),

                  trailing:
                      article.estAvatar && possedes.contains(article.emoji)
                      ? (equipe == article.emoji
                            ? Chip(
                                label: const Text('Équipé'),
                                backgroundColor: designAccent.withValues(
                                  alpha: 0.15,
                                ),
                                labelStyle: const TextStyle(
                                  color: designOrTexte,
                                ),
                                side: BorderSide.none,
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: designAccent,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  equiperAvatar(article.emoji);
                                  setState(() {});
                                },
                                child: const Text('Équiper'),
                              ))
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: designAccent,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => acheter(article),
                          child: Text('${article.prix} deniers'),
                        ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
