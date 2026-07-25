import 'package:flutter/material.dart';

import 'package:itinera/screens/journal_henri_kugener_screen.dart';

// ------------------------------------------------------------
// À propos de Luna + lien vers le journal du concours
// Henri Kugener
// ------------------------------------------------------------

class AProposLunaScreen extends StatelessWidget {
  const AProposLunaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('À propos de Luna')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('👋💕', style: TextStyle(fontSize: 28)),
          const SizedBox(height: 16),
          const Text(
            'Salut ! Je m\'appelle Luna, je suis en 3e (troisième) au LCD.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'J\'ai programmé cette application moi-même, parce que '
            'j\'adore le latin et que je voulais un outil qui m\'aide à '
            'réviser — et qui puisse aussi être utile à d\'autres élèves.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'Avec deux camarades, j\'ai remporté le Concours Henri '
            'Kugener 🏆 : nous avons rédigé un journal sur les femmes et '
            'l\'amour dans la Rome antique.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.newspaper),
              title: const Text('Notre journal (on a gagné !) 🏆'),
              subtitle: const Text(
                'Lunae, Annae Devaeque — les femmes et l\'amour dans la '
                'Rome antique',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JournalHenriKugenerScreen(),
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
