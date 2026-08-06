import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';

import 'package:itinera/lecons_grammaire_data.dart';
import 'package:itinera/locutions_data.dart';
import 'package:itinera/main.dart';
import 'package:itinera/services/duel_service.dart';
import 'package:itinera/screens/compte_screen.dart';
import 'package:itinera/screens/lecon_detail_screen.dart';
import 'package:itinera/screens/locutions_screen.dart';
import 'package:itinera/screens/recherche_lecons_screen.dart';
import 'package:itinera/screens/selecteur_unite_screen.dart';
import 'package:itinera/widgets/avatar_glyphe.dart';
import 'package:itinera/widgets/blob_shape.dart';
import 'package:itinera/design/palette.dart';

// ============================================================
// PARCOURS DE LEÇONS : ÉCRAN DU CHEMIN
// ============================================================
//
// Palette "blob" (fond marine profond, panneaux crème à contour organique,
// accent rose, tête de chat achetable en boutique en guise d'avatar) —
// voir lib/design/palette.dart pour les couleurs partagées avec les autres
// écrans migrés vers cette direction visuelle.

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
  // Tirée une fois par ouverture de l'écran (pas à chaque rebuild), pour
  // remplir l'espace vide entre l'avatar et la série/les deniers.
  late final Locution _citation = locutions[Random().nextInt(locutions.length)];

  // Petit bouton en forme de pastille arrondie (blanc cassé sur le panneau
  // clair), inspiré des boutons-pilule de la référence visuelle.
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

  Future<void> _ouvrirLecon(Lecon lecon) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LeconDetailScreen(lecon: lecon)),
    );

    setState(() {});
  }

  Future<void> _afficherPopupLecon(
    Lecon lecon,
    bool complete,
    int index,
  ) async {
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
                color: designBlanc,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _NoeudCoeur(
                    complete: complete,
                    deverrouille: true,
                    taille: 64,
                    index: index,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    lecon.titre,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: designNoir,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lecon.sousTitre,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: designNoir.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: designAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
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
    // Reflète l'avatar réellement équipé (achat en boutique) plutôt qu'une
    // mascotte figée : par défaut ('👤', rien acheté), une icône neutre ;
    // sinon l'emoji ou la tête de chat choisie, via AvatarGlyphe.
    final equipe = emojiAvatarEquipe();
    final estParDefaut = equipe == '👤';

    // Le fond "blob" est purement décoratif (derrière l'avatar) : la
    // découpe organique n'a pas à contenir de texte, donc pas de risque de
    // rogner du contenu.
    final avatar = SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          BlobPanel(
            forme: blobRonde,
            couleur: designAccent.withValues(alpha: 0.16),
            padding: EdgeInsets.zero,
            child: const SizedBox(width: 52, height: 52),
          ),
          estParDefaut
              ? Icon(Icons.account_circle, color: designAccent, size: 36)
              : AvatarGlyphe(valeur: equipe, taille: 44),
        ],
      ),
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
                  border: Border.all(color: designBlanc, width: 2),
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
    final etoiles = fondEtoileActif();

    return Scaffold(
      backgroundColor: designFond,
      body: Stack(
        children: [
          // Fond uni par défaut ; la photo de ciel étoilé (réglable dans
          // Paramètres > Apparence) vient se superposer par-dessus.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: designGradientFond),
            ),
          ),
          if (etoiles) ...[
            // La photo d'origine est très sombre (essentiellement noire,
            // avec de petites étoiles éparses) : on éclaircit un peu le
            // contraste pour que les étoiles restent visibles une fois le
            // voile posé dessus, sinon l'ensemble lit comme un fond noir uni.
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  1.35,
                  0,
                  0,
                  0,
                  6,
                  0,
                  1.35,
                  0,
                  0,
                  6,
                  0,
                  0,
                  1.35,
                  0,
                  10,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]),
                child: Image.asset(
                  'assets/stars_starry_sky_night_182857_3840x2160.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Voile par-dessus la photo pour que le texte blanc du chemin
            // de leçons reste lisible sans perdre le ciel étoilé.
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      designFond.withValues(alpha: 0.35),
                      designFondProfond.withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),
            ),
          ],
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: designBlanc,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CompteScreen(),
                                  ),
                                );
                                setState(() {});
                              },
                              child: _avatarCompteAvecBadge(),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LocutionsScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  '« ${_citation.latin} »',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w700,
                                    color: designOrTexte,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.local_fire_department,
                              color: streak > 0
                                  ? couleurStreak(streak)
                                  : designNoir.withValues(alpha: 0.3),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$streak',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: designNoir,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Icon(Icons.diamond, size: 18, color: designOrTexte),
                            const SizedBox(width: 4),
                            Text(
                              '${coins()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: designNoir,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          anneeDe(widget.unite).toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: designAccent,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _boutonPastille(
                              icone: Icons.search,
                              libelle: 'Rechercher',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RechercheLeconsScreen(),
                                  ),
                                );
                              },
                            ),
                            _boutonPastille(
                              icone: Icons.swap_horiz,
                              libelle: 'Changer d\'année',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SelecteurUniteScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        if (parcours.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value:
                                        leconsTermineesVolume / parcours.length,
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
                                '$leconsTermineesVolume/${parcours.length} leçons',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: designNoir.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
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
                          style: TextStyle(
                            color: texteClair.withValues(alpha: 0.6),
                          ),
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
                            index == 0 ||
                            lecon.unite != parcours[index - 1].unite;

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
                                        color: Colors.white.withValues(
                                          alpha: 0.15,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 6,
                                            color: designAccent,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            lecon.unite.split(' – ').last,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: texteClair.withValues(
                                                alpha: 0.8,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.white.withValues(
                                          alpha: 0.15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(
                              height: 168,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Align(
                                    alignment: Alignment(decalage, -0.4),
                                    child: _NoeudAnime(
                                      index: index,
                                      enfant: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: deverrouille
                                            ? () => _afficherPopupLecon(
                                                lecon,
                                                complete,
                                                index,
                                              )
                                            : null,
                                        child: Column(
                                          children: [
                                            _NoeudCoeur(
                                              complete: complete,
                                              deverrouille: deverrouille,
                                              index: index,
                                            ),

                                            if (complete)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 4,
                                                ),
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: designOr,
                                                  size: 20,
                                                ),
                                              ),

                                            const SizedBox(height: 14),

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
                                                      : texteClair.withValues(
                                                          alpha: 0.4,
                                                        ),
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
    // Pas d'AnimatedOpacity ici : sur certains GPU, Impeller compose ce
    // fondu via un calque hors-écran qui peut laisser apparaître un
    // contour carré autour du sceau rond pendant la transition (visible
    // sur du matériel réel, pas reproduit sur l'émulateur).
    return AnimatedScale(
      scale: visible ? 1 : 0.4,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      child: widget.enfant,
    );
  }
}

// Nœud de leçon "cœur" façon Duolingo : tant que la leçon n'est pas
// terminée, juste un contour vide (rien à l'intérieur) ; une fois
// terminée, un disque 3D plein — rebord plus sombre qui dépasse en
// dessous + reflet clair en haut du disque principal, décalé vers le
// haut de quelques pixels pour laisser voir le rebord, comme un bouton
// physique vu de face.
class _NoeudCoeur extends StatelessWidget {
  final bool complete;
  final bool deverrouille;
  final double taille;
  // Quelle leçon ce nœud représente dans le chemin (pas d'identité propre à
  // la leçon) — sert uniquement à choisir un sceau différent à chaque fois
  // en thème Sakura, voir _sceauxDisponibles ci-dessous.
  final int index;

  const _NoeudCoeur({
    required this.complete,
    required this.deverrouille,
    this.taille = 76,
    this.index = 0,
  });

  Color _teinte(Color base, double decalageLuminosite) {
    final hsl = HSLColor.fromColor(base);
    final luminosite = (hsl.lightness + decalageLuminosite).clamp(0.0, 1.0);
    return hsl.withLightness(luminosite).toColor();
  }

  // Réservé au thème Sakura : de vrais sceaux de cire (assets/sceaux_rose),
  // un par leçon (cyclique) plutôt que toujours le même — les autres
  // thèmes gardent le cœur 3D codé plus bas.
  static const _sceauxDisponibles = [
    'assets/sceaux_rose/sceau_rose_cygnes.png',
    'assets/sceaux_rose/sceau_rose_noeud.png',
    'assets/sceaux_rose/sceau_rose_bouquet.png',
    'assets/sceaux_rose/sceau_rose_lilas.png',
    'assets/sceaux_rose/sceau_rose_noeud_or.png',
    'assets/sceaux_rose/sceau_rose_simple.png',
    'assets/sceaux_rose/sceau_rose_medaillon_angelot.png',
    'assets/sceaux_rose/sceau_rose_branche.png',
    'assets/sceaux_rose/sceau_rose_medaillon_ruban.png',
    'assets/sceaux_rose/sceau_rose_tourbillon.png',
    'assets/sceaux_rose/sceau_rose_fleur.png',
    'assets/sceaux_rose/sceau_rose_lapin.png',
    'assets/sceaux_rose/sceau_rose_tige.png',
    'assets/sceaux_rose/sceau_rose_flamant.png',
    'assets/sceaux_rose/sceau_rose_coeur.png',
    'assets/sceaux_rose/sceau_rose_assiette_florale.png',
  ];

  // Thème Claret (le thème par défaut) : mêmes sceaux de cire que Sakura,
  // en rouge — seuls les plus propres (fond bien détouré) du lot importé
  // ont été gardés. Les autres thèmes (Midnight, Moonscape) gardent
  // le cœur 3D codé plus bas.
  static const _sceauxRougeDisponibles = [
    'assets/sceaux_rouge/sceau_rouge_rose_emblem.png',
    'assets/sceaux_rouge/sceau_rouge_pavot.png',
    'assets/sceaux_rouge/sceau_rouge_coeurs_bouquet.png',
    'assets/sceaux_rouge/sceau_rouge_feuilles.png',
    'assets/sceaux_rouge/sceau_rouge_rose.png',
    'assets/sceaux_rouge/sceau_rouge_rose_ombre.png',
    'assets/sceaux_rouge/sceau_rouge_tulipe.png',
    'assets/sceaux_rouge/sceau_rouge_rose_duo.png',
    'assets/sceaux_rouge/sceau_rouge_fleur_sauvage.png',
  ];

  // Thème Midnight (noir et blanc) : sceaux blancs, planche détourée
  // fournie par l'utilisateur. Variante "_sombre" générée à l'avance (RVB ×
  // 0.45, voir scratchpad/darken_sigils.ps1 dans l'historique de session)
  // plutôt que recalculée au rendu, même contrainte Impeller que les autres
  // planches de sceaux.
  static const _sceauxBlancDisponibles = [
    'assets/white sigils/white sigil 1-no-bg.png',
    'assets/white sigils/white sigil 2-no-bg.png',
    'assets/white sigils/white sigil 3-no-bg.png',
    'assets/white sigils/white sigil 4-no-bg.png',
    'assets/white sigils/white sigil 5-no-bg.png',
    'assets/white sigils/white sigil 6-no-bg.png',
  ];

  // Thème Moonscape : sceaux violets, même traitement "_sombre" que
  // ci-dessus.
  static const _sceauxVioletDisponibles = [
    'assets/purple sigils/purple sigil 1-no-bg.png',
    'assets/purple sigils/purple sigil 2-no-bg.png',
    'assets/purple sigils/purple sigil 3-no-bg.png',
    'assets/purple sigils/purple sigil 4-no-bg.png',
    'assets/purple sigils/purple sigil 6-no-bg.png',
  ];

  // "Assombri" tant que la leçon n'est pas terminée : un second fichier
  // déjà assombri (RVB × 0.45, généré une fois à l'avance), pas un
  // ColorFiltered/Opacity au moment du rendu — ces widgets composent
  // toujours via un calque hors-écran, et Impeller y laissait parfois
  // apparaître le contour carré du calque autour du sceau rond (même en
  // remplaçant BlendMode par ColorFilter.matrix, le calque reste). Pas
  // d'ombre portée non plus : sur un sceau déjà texturé/en relief, le
  // flou circulaire lisait comme si tout le fond autour s'assombrissait
  // au lieu de rester juste sous le bouton.
  Widget _sceauImage(List<String> disponibles) {
    final chemin = disponibles[index % disponibles.length];
    final cheminAffiche = complete
        ? chemin
        : chemin.replaceFirst('.png', '_sombre.png');

    return SizedBox(
      width: taille,
      height: taille,
      child: Center(
        child: Image.asset(
          cheminAffiche,
          width: taille,
          height: taille,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (temaActifNotifier.value.nom == 'Sakura') {
      return _sceauImage(_sceauxDisponibles);
    }

    if (temaActifNotifier.value.nom == 'Claret') {
      return _sceauImage(_sceauxRougeDisponibles);
    }

    if (temaActifNotifier.value.nom == 'Midnight') {
      return _sceauImage(_sceauxBlancDisponibles);
    }

    if (temaActifNotifier.value.nom == 'Moonscape') {
      return _sceauImage(_sceauxVioletDisponibles);
    }

    if (!complete) {
      return Container(
        width: taille,
        height: taille,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: designBlanc.withValues(alpha: deverrouille ? 1 : 0.4),
          border: Border.all(
            color: deverrouille
                ? designAccent.withValues(alpha: 0.5)
                : designNoir.withValues(alpha: 0.2),
            width: 3,
          ),
        ),
        child: Icon(
          deverrouille ? Icons.favorite_border : Icons.lock,
          size: 32,
          color: deverrouille
              ? designAccent.withValues(alpha: 0.6)
              : designNoir.withValues(alpha: 0.4),
        ),
      );
    }

    final rebord = _teinte(designAccent, -0.16);
    final reflet = _teinte(designAccent, 0.16);

    return SizedBox(
      width: taille,
      height: taille,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: taille,
            height: taille,
            decoration: BoxDecoration(shape: BoxShape.circle, color: rebord),
          ),
          Transform.translate(
            offset: const Offset(0, -5),
            child: Container(
              width: taille,
              height: taille,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [reflet, designAccent],
                  stops: const [0, 0.65],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.favorite, size: 32, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
