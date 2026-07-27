import 'package:flutter/material.dart';

import 'package:itinera/lecons_grammaire_data.dart';
import 'package:itinera/main.dart';
import 'package:itinera/screens/succes_screen.dart';
import 'package:itinera/vocabulaire_data.dart';
import 'package:itinera/widgets/graphique_activite.dart';

// ============================================================
// STATISTIQUES
// ============================================================

class StatistiquesScreen extends StatefulWidget {
  const StatistiquesScreen({super.key});

  @override
  State<StatistiquesScreen> createState() => _StatistiquesScreenState();
}

class _StatistiquesScreenState extends State<StatistiquesScreen> {
  @override
  Widget build(BuildContext context) {
    final maintenant = DateTime.now().toUtc();

    final totalMots = vocabulaire.length;

    final totalARevoir = vocabulaire
        .where((mot) => mot.estDu(maintenant))
        .length;

    final totalNouveaux = vocabulaire.where((mot) => mot.estNouveau).length;

    final totalAppris = totalMots - totalNouveaux;

    final unites = vocabulaire.map((mot) => mot.unite).toSet().toList();

    final totalLecons = construireParcoursComplet().length;
    final leconsTerminees = construireParcoursComplet()
        .where(leconEstCompletee)
        .length;

    final succesTotal = succesDisponibles.length;
    final succesTermines = succesDebloques().length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Réinitialiser toute la progression',
            onPressed: () async {
              final reinitialise = await confirmerReinitialisation(context);
              if (reinitialise) setState(() {});
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          Row(
            children: [
              statTile(
                icone: Icons.school,
                valeur: '$totalMots',
                label: 'mots au total',
              ),
              const SizedBox(width: 12),
              statTile(
                icone: Icons.check_circle,
                valeur: '$totalAppris',
                label: 'déjà appris',
              ),
              const SizedBox(width: 12),
              statTile(
                icone: Icons.refresh,
                valeur: '$totalARevoir',
                label: 'à revoir',
              ),
            ],
          ),

          const SizedBox(height: 20),

          GraphiqueActivite(revisionsParJour: historiqueRevisions()),

          const SizedBox(height: 28),

          const Text(
            'Progression par unité',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          for (final unite in unites) ...[
            _barreProgressionUnite(unite),
            const SizedBox(height: 12),
          ],

          const SizedBox(height: 16),

          const Text(
            'Leçons de grammaire',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceWidget,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Parcours terminé',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('$leconsTerminees / $totalLecons'),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: totalLecons == 0
                        ? 0
                        : leconsTerminees / totalLecons,
                    minHeight: 8,
                    backgroundColor: fond,
                    valueColor: const AlwaysStoppedAnimation(accentViolet),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Succès',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events, color: orAntique),
              title: Text('$succesTermines / $succesTotal débloqués'),
              subtitle: const Text('Voir tous les succès'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SuccesScreen(),
                  ),
                );
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _barreProgressionUnite(String unite) {
    final motsDeCetteUnite = vocabulaire
        .where((mot) => mot.unite == unite)
        .toList();

    final apprisDeCetteUnite = motsDeCetteUnite
        .where((mot) => !mot.estNouveau)
        .length;

    final total = motsDeCetteUnite.length;
    final pourcentage = total == 0 ? 0.0 : apprisDeCetteUnite / total;

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: surfaceWidget,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Expanded(
                child: Text(
                  nomAffiche(unite),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text('$apprisDeCetteUnite / $total'),
            ],
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),

            child: LinearProgressIndicator(
              value: pourcentage,
              minHeight: 8,
              backgroundColor: fond,
              valueColor: const AlwaysStoppedAnimation(accentViolet),
            ),
          ),
        ],
      ),
    );
  }
}
