import 'package:flutter/material.dart';

import 'package:itinera/main.dart';
import 'package:itinera/vocabulaire_data.dart';
import 'package:itinera/screens/ajouter_vocabulaire_screen.dart';
import 'package:itinera/screens/recherche_screen.dart';
import 'package:itinera/screens/vocabulaire_liste_screen.dart';
import 'package:itinera/screens/vocabulaire_screen.dart';

// ============================================================
// ÉCRAN DES UNITÉS
// ============================================================

class UniteScreen extends StatefulWidget {
  const UniteScreen({super.key});

  @override
  State<UniteScreen> createState() => _UniteScreenState();
}

class _UniteScreenState extends State<UniteScreen> {
  bool _actionsOuvertes = true;

  final ScrollController _scrollControllerUnites = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollControllerUnites.addListener(_replierReviserAuScroll);
  }

  @override
  void dispose() {
    _scrollControllerUnites.removeListener(_replierReviserAuScroll);
    _scrollControllerUnites.dispose();
    super.dispose();
  }

  // Referme automatiquement le bloc « Réviser » dès qu'on fait défiler la
  // liste des unités, pour libérer de la place à l'écran.
  void _replierReviserAuScroll() {
    if (_actionsOuvertes && _scrollControllerUnites.position.pixels > 10) {
      setState(() => _actionsOuvertes = false);
    }
  }

  List<String> get unites =>
      vocabulaire.map((mot) => mot.unite).toSet().toList();

  int compterARevoir() {
    final maintenant = DateTime.now().toUtc();

    return vocabulaire.where((mot) {
      return mot.fsrsCard.due.isBefore(maintenant);
    }).length;
  }

  int compterNouveaux() {
    return vocabulaire.where((mot) {
      return mot.fsrsCard.lastReview == null;
    }).length;
  }

  List<Vocabulaire> vocabulaireARevoir() {
    final maintenant = DateTime.now().toUtc();

    return vocabulaire.where((mot) {
      return !mot.fsrsCard.due.isAfter(maintenant);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulaire latin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RechercheScreen(),
                ),
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Ajouter un mot'),
        onPressed: () async {
          final ajoute = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AjouterVocabulaireScreen(),
            ),
          );

          if (ajoute == true) {
            setState(() {});
            if (context.mounted) verifierSuccesEtNotifier(context);
          }
        },
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () =>
                      setState(() => _actionsOuvertes = !_actionsOuvertes),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Réviser',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: _actionsOuvertes ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.expand_more),
                      ),
                    ],
                  ),
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 220),
                  crossFadeState: _actionsOuvertes
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox(width: double.infinity),
                  secondChild: Column(
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          statTile(
                            icone: Icons.refresh,
                            valeur: '${compterARevoir()}',
                            label: 'à revoir',
                          ),
                          const SizedBox(width: 12),
                          statTile(
                            icone: Icons.fiber_new,
                            valeur: '${compterNouveaux()}',
                            label: 'nouveaux',
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.refresh),
                          title: const Text('Révision du jour'),
                          subtitle: Text('${compterARevoir()} cartes à revoir'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            final cartesARevoir = vocabulaireARevoir();

                            if (cartesARevoir.isEmpty) return;

                            final direction = await choisirDirection(context);

                            if (direction == null || !context.mounted) return;

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return VocabulaireScreen(
                                    vocabulaire: cartesARevoir,
                                    startIndex: 0,
                                    direction: direction,
                                  );
                                },
                              ),
                            );
                            setState(() {});
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.shuffle),
                          title: const Text('Session mélangée'),
                          subtitle: Text(
                            '${vocabulaireARevoir().length} cartes, toutes unités mélangées',
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            final cartesMelangees = vocabulaireARevoir()
                              ..shuffle();

                            if (cartesMelangees.isNotEmpty) {
                              final direction = await choisirDirection(context);

                              if (direction == null || !context.mounted) return;

                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return VocabulaireScreen(
                                      vocabulaire: cartesMelangees,
                                      startIndex: 0,
                                      direction: direction,
                                    );
                                  },
                                ),
                              );
                              setState(() {});
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.tune),
                          title: const Text('Réviser par difficulté'),
                          subtitle: const Text(
                            'Uniquement les mots faciles, moyens ou difficiles',
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            await choisirEtReviserParDifficulte(context);
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              controller: _scrollControllerUnites,
              padding: const EdgeInsets.all(16),

              itemCount: unites.length,

              itemBuilder: (context, index) {
                final unite = unites[index];

                final maintenant = DateTime.now().toUtc();

                final nombreVocabulaire = vocabulaire
                    .where((mot) => mot.unite == unite)
                    .length;

                final nombreARevoir = vocabulaire
                    .where(
                      (mot) =>
                          mot.unite == unite &&
                          !mot.fsrsCard.due.isAfter(maintenant),
                    )
                    .length;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),

                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),

                    leading: CircleAvatar(
                      backgroundColor: accentViolet,
                      foregroundColor: texteClair,
                      child: Text('$index'),
                    ),

                    title: Text(
                      nomAffiche(unite),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      '$nombreVocabulaire mots · $nombreARevoir à revoir',
                    ),

                    trailing: const Icon(Icons.arrow_forward_ios),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return VocabulaireListeScreen(unite: unite);
                          },
                        ),
                      );
                    },

                    onLongPress: () async {
                      await gererUnite(context, unite);
                      setState(() {});
                    },
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
