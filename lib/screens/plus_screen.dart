import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

import 'package:itinera/main.dart';
import 'package:itinera/textes_data.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';
import 'package:itinera/screens/a_propos_luna_screen.dart';
import 'package:itinera/screens/boutique_screen.dart';
import 'package:itinera/screens/grammaire_screen.dart';
import 'package:itinera/screens/locutions_screen.dart';
import 'package:itinera/screens/parametres_screen.dart';
import 'package:itinera/screens/pomodoro_screen.dart';
import 'package:itinera/screens/succes_screen.dart';
import 'package:itinera/screens/textes_hub_screen.dart';

// ============================================================
// PLUS (bibliothèque des sections restantes)
// ============================================================

class PlusScreen extends StatefulWidget {
  const PlusScreen({super.key});

  @override
  State<PlusScreen> createState() => _PlusScreenState();
}

class _PlusScreenState extends State<PlusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Plus'),
      ),

      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            carteActionDesign(
              icone: Icons.local_cafe,
              titre: 'Minuteur cozy',
              sousTitre: 'Pomodoro pour rester concentré',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PomodoroScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            carteActionDesign(
              icone: Icons.emoji_events,
              titre: 'Succès',
              sousTitre:
                  '${succesDebloques().length}/${succesDisponibles.length} débloqués',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SuccesScreen()),
                );
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            carteActionDesign(
              icone: Icons.storefront,
              titre: 'Boutique',
              sousTitre: '${coins()} denier${coins() == 1 ? '' : 's'}',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BoutiqueScreen(),
                  ),
                );
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            carteActionDesign(
              icone: Icons.auto_stories,
              titre: 'Grammaire',
              sousTitre: 'Apprendre la grammaire latine',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GrammaireScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            carteActionDesign(
              icone: Icons.format_quote,
              titre: 'Phrases & proverbes',
              sousTitre: 'Des expressions latines utiles dans la vraie vie',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LocutionsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            carteActionDesign(
              icone: Icons.edit,
              titre: 'Exercices',
              sousTitre: 'Pratiquer le latin',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TexteListeScreen(
                      textes: exercicesTraduction,
                      titre: 'Exercices de traduction',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            carteActionDesign(
              icone: Icons.settings,
              titre: 'Paramètres',
              sousTitre: 'Rappels, sauvegarde de la progression',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ParametresScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const _CarteNachhilfe(),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Petite carte promo : Luna donne des cours particuliers
// ------------------------------------------------------------

class _CarteNachhilfe extends StatelessWidget {
  const _CarteNachhilfe();

  static const _rose = Color(0xFFC2185B);
  static const _roseTexte = Color(0xFF8E2456);
  static const _roseFond = Color(0xFFFFE1F0);
  static const _roseBordure = Color(0xFFFF8FC7);
  static const _rosePuce = Color(0xFFFFC1E3);

  static const _email = 'myitineraapp@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _roseFond,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: _roseBordure, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('💕', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                const Text(
                  'Cours particuliers avec Luna',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _rose,
                  ),
                ),
                const SizedBox(width: 2),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: _rose, size: 20),
                  tooltip: 'À propos de Luna',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AProposLunaScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Je donne des cours en luxembourgeois, français, anglais et '
              'allemand.',
              style: TextStyle(color: _roseTexte, height: 1.4),
            ),
            const SizedBox(height: 8),
            const Text(
              '15–20 €/heure — gratuit pour celles et ceux qui n\'en ont '
              'pas les moyens.',
              style: TextStyle(
                color: _roseTexte,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'N\'hésite pas à me contacter si ça t\'intéresse 💌',
              style: TextStyle(color: _roseTexte, height: 1.4),
            ),
            const SizedBox(height: 14),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                await Clipboard.setData(const ClipboardData(text: _email));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Adresse e-mail copiée 💌')),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _rosePuce,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.mail_outline, color: _rose, size: 18),
                    SizedBox(width: 8),
                    Text(
                      _email,
                      style: TextStyle(
                        color: _rose,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
