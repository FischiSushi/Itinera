import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';

import 'package:itinera/lecons_grammaire_data.dart';
import 'package:itinera/main.dart';
import 'package:itinera/services/duel_service.dart';
import 'package:itinera/screens/compte_screen.dart';
import 'package:itinera/screens/lecon_detail_screen.dart';
import 'package:itinera/screens/selecteur_unite_screen.dart';

// ============================================================
// PARCOURS DE LEÇONS : ÉCRAN DU CHEMIN
// ============================================================

class AccueilScreen extends StatefulWidget {
  // Un préfixe de volume (ex. 'Vol. I'), pas une unité précise : toutes
  // les leçons de toutes les unités de cette année s'enchaînent dans un
  // seul et même chemin, l'une en dessous de l'autre.
  final String unite;

  const AccueilScreen({super.key, this.unite = 'Vol. I'});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  Future<void> _ouvrirLecon(Lecon lecon) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LeconDetailScreen(lecon: lecon)),
    );

    setState(() {});
  }

  Future<void> _afficherPopupLecon(Lecon lecon, bool complete) async {
    final demarrer = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fermer',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: surfaceWidget,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: complete
                          ? accentViolet
                          : accentViolet.withValues(alpha: 0.2),
                    ),
                    child: Icon(
                      lecon.icone,
                      size: 30,
                      color: complete ? Colors.white : accentViolet,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    lecon.titre,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lecon.sousTitre,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: texteAttenue, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(complete ? 'Revoir' : 'Commencer'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
            child: child,
          ),
        );
      },
    );

    if (demarrer == true) {
      await _ouvrirLecon(lecon);
    }
  }

  static const _motifZigzag = [0.0, 0.55, 0.8, 0.55, 0.0, -0.55, -0.8, -0.55];

  double _decalage(int index) => _motifZigzag[index % _motifZigzag.length];

  // Petit point rouge sur l'avatar dès qu'un défi attend une réponse, pour
  // qu'on le remarque sans avoir à ouvrir l'écran Compte.
  Widget _avatarCompteAvecBadge() {
    const avatar = CircleAvatar(
      radius: 18,
      backgroundColor: Color(0x269F7AEA),
      child: Icon(Icons.account_circle, color: accentViolet),
    );

    final utilisateur = firebaseDisponible
        ? FirebaseAuth.instance.currentUser
        : null;

    if (utilisateur == null) return avatar;

    return StreamBuilder<List<Defi>>(
      stream: DuelService().defisRecus(utilisateur.uid),
      builder: (context, snap) {
        if ((snap.data?.length ?? 0) == 0) return avatar;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            avatar,
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: fond, width: 2),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final parcours = construireParcoursComplet()
        .where((lecon) => volumeDe(lecon.unite) == widget.unite)
        .toList();
    final leconsTermineesVolume = parcours.where(leconEstCompletee).length;
    final streak = streakActuel();

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CompteScreen()),
            );
            setState(() {});
          },
          child: _avatarCompteAvecBadge(),
        ),
        actions: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: streak > 0 ? couleurStreak(streak) : texteAttenue,
              ),
              const SizedBox(width: 4),
              Text(
                '$streak',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 16),
          badgeDeniers(coins()),
          const SizedBox(width: 16),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  anneeDe(widget.unite).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: accentViolet,
                    letterSpacing: 1.2,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelecteurUniteScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.swap_horiz, size: 18),
                    label: const Text('Changer d\'année'),
                  ),
                ),
                if (parcours.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: leconsTermineesVolume / parcours.length,
                            minHeight: 8,
                            backgroundColor: surfaceWidget,
                            valueColor: const AlwaysStoppedAnimation(
                              accentViolet,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '$leconsTermineesVolume/${parcours.length} leçons',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: texteAttenue,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          if (parcours.isEmpty)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'Pas encore de leçons de grammaire pour cette unité — '
                    'bientôt disponible.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: texteAttenue),
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 32),

                itemCount: parcours.length,

                itemBuilder: (context, index) {
                  final lecon = parcours[index];
                  final complete = leconEstCompletee(lecon);
                  // Pas de verrouillage séquentiel : toutes les leçons
                  // sont accessibles directement, pour naviguer vite
                  // pendant la relecture/l'ajout de contenu.
                  final deverrouille = index >= 0;

                  final decalage = _decalage(index);
                  final nouvelleUnite =
                      index == 0 || lecon.unite != parcours[index - 1].unite;

                  return Column(
                    children: [
                      if (nouvelleUnite)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: texteAttenue.withValues(alpha: 0.4),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  lecon.unite.split(' – ').last,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: texteAttenue,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: texteAttenue.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 168,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment(decalage, -0.4),
                              child: _NoeudAnime(
                                index: index,
                                enfant: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: deverrouille
                                      ? () =>
                                            _afficherPopupLecon(lecon, complete)
                                      : null,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 76,
                                        height: 76,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: complete
                                              ? accentViolet
                                              : surfaceWidget.withValues(
                                                  alpha: deverrouille ? 1 : 0.5,
                                                ),
                                          border: Border.all(
                                            color: deverrouille
                                                ? accentViolet
                                                : Colors.transparent,
                                            width: 3,
                                          ),
                                        ),
                                        child: Icon(
                                          deverrouille
                                              ? lecon.icone
                                              : Icons.lock,
                                          size: 32,
                                          color: deverrouille
                                              ? (complete
                                                    ? Colors.white
                                                    : accentViolet)
                                              : texteAttenue,
                                        ),
                                      ),

                                      if (complete)
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                        ),

                                      const SizedBox(height: 6),

                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 170,
                                        ),
                                        child: Text(
                                          lecon.titre,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: deverrouille
                                                ? texteClair
                                                : texteAttenue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _NoeudAnime extends StatefulWidget {
  final int index;
  final Widget enfant;

  const _NoeudAnime({required this.index, required this.enfant});

  @override
  State<_NoeudAnime> createState() => _NoeudAnimeState();
}

class _NoeudAnimeState extends State<_NoeudAnime> {
  bool visible = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 60 * widget.index), () {
      if (mounted) setState(() => visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: visible ? 1 : 0.4,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 280),
        child: widget.enfant,
      ),
    );
  }
}
