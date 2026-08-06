import 'package:flutter/material.dart';

import 'package:itinera/main.dart';
import 'package:itinera/vocabulaire_data.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';
import 'package:itinera/screens/ajouter_vocabulaire_screen.dart';
import 'package:itinera/screens/recherche_screen.dart';
import 'package:itinera/screens/selecteur_unite_screen.dart';
import 'package:itinera/screens/vocabulaire_liste_screen.dart';
import 'package:itinera/screens/vocabulaire_screen.dart';

// ============================================================
// ÉCRAN DES UNITÉS
// ============================================================

class UniteScreen extends StatefulWidget {
  // Un préfixe de volume (ex. 'Vol. I'), comme AccueilScreen.unite — le
  // vocabulaire de cette année s'affiche seul, avec un sélecteur pour
  // changer d'année (voir SelecteurUniteScreen).
  final String unite;

  const UniteScreen({super.key, this.unite = 'Vol. I'});

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

  List<Vocabulaire> get _vocabulaireVolume =>
      vocabulaire.where((mot) => volumeDe(mot.unite) == widget.unite).toList();

  List<String> get unites =>
      _vocabulaireVolume.map((mot) => mot.unite).toSet().toList();

  // Volontairement PAS limités à widget.unite, contrairement à `unites` :
  // les dates d'échéance FSRS ne connaissent pas les volumes, réviser sur
  // "ce qui est dû aujourd'hui" doit donc rester global à tout le
  // vocabulaire, peu importe l'année affichée.
  int compterARevoir() {
    final maintenant = DateTime.now().toUtc();
    return vocabulaire.where((mot) => mot.estDu(maintenant)).length;
  }

  int compterNouveaux() {
    return vocabulaire.where((mot) => mot.estNouveau).length;
  }

  int compterAppris() {
    return _vocabulaireVolume.where((mot) => !mot.estNouveau).length;
  }

  List<Vocabulaire> vocabulaireARevoir() {
    final maintenant = DateTime.now().toUtc();
    return vocabulaire.where((mot) => mot.estDu(maintenant)).toList();
  }

  // Petit bouton en forme de pastille arrondie, même style que le bouton
  // « Changer d'année » d'AccueilScreen — posé sur le même panneau crème,
  // donc même traitement visuel pour rester cohérent entre les deux écrans.
  Widget _boutonPastille({
    required IconData icone,
    required String libelle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: designNoir.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icone, size: 16, color: designNoir),
              const SizedBox(width: 6),
              Text(
                libelle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: designNoir,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
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
        backgroundColor: designAccent,
        foregroundColor: Colors.white,
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

      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: designBlanc,
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            anneeDe(widget.unite).toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: designAccent,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        _boutonPastille(
                          icone: Icons.swap_horiz,
                          libelle: 'Changer d\'année',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SelecteurUniteScreen(
                                      mode: ModeSelecteurUnite.vocabulaire,
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    if (_vocabulaireVolume.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value:
                                    compterAppris() / _vocabulaireVolume.length,
                                minHeight: 8,
                                backgroundColor: designNoir.withValues(
                                  alpha: 0.1,
                                ),
                                valueColor: AlwaysStoppedAnimation(
                                  designAccent,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${compterAppris()}/${_vocabulaireVolume.length} mots',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: designNoir.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 16),

                    InkWell(
                      onTap: () =>
                          setState(() => _actionsOuvertes = !_actionsOuvertes),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Réviser',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: designNoir,
                              ),
                            ),
                          ),
                          AnimatedRotation(
                            turns: _actionsOuvertes ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(Icons.expand_more, color: designNoir),
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
                              statTileDesign(
                                icone: Icons.refresh,
                                valeur: '${compterARevoir()}',
                                label: 'à revoir',
                              ),
                              const SizedBox(width: 12),
                              statTileDesign(
                                icone: Icons.fiber_new,
                                valeur: '${compterNouveaux()}',
                                label: 'nouveaux',
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          carteActionDesign(
                            icone: Icons.refresh,
                            titre: 'Révision du jour',
                            sousTitre: '${compterARevoir()} cartes à revoir',
                            onTap: () async {
                              final cartesARevoir = vocabulaireARevoir();

                              if (cartesARevoir.isEmpty) return;

                              final direction = await choisirDirection(context);

                              if (direction == null || !context.mounted) {
                                return;
                              }

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

                          const SizedBox(height: 10),

                          carteActionDesign(
                            icone: Icons.shuffle,
                            titre: 'Session mélangée',
                            sousTitre:
                                '${vocabulaireARevoir().length} cartes, toutes unités mélangées',
                            onTap: () async {
                              final cartesMelangees = vocabulaireARevoir()
                                ..shuffle();

                              if (cartesMelangees.isNotEmpty) {
                                final direction = await choisirDirection(
                                  context,
                                );

                                if (direction == null || !context.mounted) {
                                  return;
                                }

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

                          const SizedBox(height: 10),

                          carteActionDesign(
                            icone: Icons.tune,
                            titre: 'Réviser par difficulté',
                            sousTitre:
                                'Uniquement les mots faciles, moyens ou difficiles',
                            onTap: () async {
                              await choisirEtReviserParDifficulte(context);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                        (mot) => mot.unite == unite && mot.estDu(maintenant),
                      )
                      .length;

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

                        leading: CircleAvatar(
                          backgroundColor: designAccent,
                          foregroundColor: Colors.white,
                          child: Text('$index'),
                        ),

                        title: Text(
                          nomAffiche(unite),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: designNoir,
                          ),
                        ),

                        subtitle: Text(
                          '$nombreVocabulaire mots · $nombreARevoir à revoir',
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
