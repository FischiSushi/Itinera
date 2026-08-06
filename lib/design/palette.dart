import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Palette "blob" validée sur l'écran Parcours (fond marine profond, panneaux
// crème, accent rose, or réservé aux petits accents ponctuels) — partagée
// ici pour être réutilisée écran par écran sans dupliquer les constantes
// locales à chaque fichier. Volontairement à part de main.dart/ThemeData :
// le thème global suppose encore des cartes sombres avec texte clair
// (surfaceWidget + texteClair), donc basculer ThemeData directement
// casserait le contraste de tous les écrans pas encore migrés vers cette
// palette. Chaque écran migré importe ce fichier et applique les couleurs
// explicitement jusqu'à ce que tout l'app soit passé dessus.
//
// Système de thèmes : chaque thème ne fixe à la main que 2 couleurs (une
// foncée pour l'accent, une claire pour les cartes) — le reste (fond
// sombre de l'écran, variante encore plus sombre, texte foncé sur carte
// claire) est dérivé automatiquement à partir de la teinte de la couleur
// foncée via DesignTheme.depuis, pour que choisir un thème reste "deux
// couleurs en entrée" plutôt que huit valeurs à recalculer à la main à
// chaque fois qu'on en propose un nouveau.

class DesignTheme {
  final String nom;
  final Color fond;
  final Color fondProfond;
  final Color blanc;
  final Color accent;
  final Color noir;
  final Color or;
  // Même famille que `or`, mais bien plus sombre : `or` n'a pas assez de
  // contraste sur `blanc`, seulement sur le fond — celle-ci est réservée au
  // texte/icônes sur fond clair (deniers/gemmes/succès).
  final Color orTexte;

  const DesignTheme({
    required this.nom,
    required this.fond,
    required this.fondProfond,
    required this.blanc,
    required this.accent,
    required this.noir,
    this.or = const Color(0xFFE8BE6E),
    this.orTexte = const Color(0xFF9C6F1B),
  });

  factory DesignTheme.depuis({
    required String nom,
    required Color sombre,
    required Color clair,
    Color? or,
    Color? orTexte,
  }) {
    final teinte = HSLColor.fromColor(sombre);

    Color derive({required double saturation, required double luminosite}) {
      return teinte
          .withSaturation(saturation)
          .withLightness(luminosite)
          .toColor();
    }

    return DesignTheme(
      nom: nom,
      fond: derive(saturation: 0.18, luminosite: 0.16),
      fondProfond: derive(saturation: 0.20, luminosite: 0.10),
      blanc: clair,
      accent: sombre,
      noir: derive(saturation: 0.30, luminosite: 0.14),
      or: or ?? const Color(0xFFE8BE6E),
      orTexte: orTexte ?? const Color(0xFF9C6F1B),
    );
  }

  // Pas de fondu : mêmes deux couleurs identiques pour laisser le type
  // LinearGradient (utilisé partout via `gradient: designGradientFond`) mais
  // obtenir un fond bien uni.
  LinearGradient get gradientFond => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [fond, fond],
  );
}

const themeParDefaut = DesignTheme(
  nom: 'Claret',
  fond: Color(0xFF25202D),
  fondProfond: Color(0xFF18141D),
  blanc: Color(0xFFFDFBF5),
  accent: Color(0xFF670626),
  noir: Color(0xFF241F3D),
);

// Fourni à la main (comme Moonscape) plutôt que dérivé via DesignTheme.depuis
// : cette factory tire fond/fondProfond/noir de la teinte (hue) de la
// couleur sombre, or le noir/blanc n'a pas de teinte définie — le résultat
// dérivé virait légèrement rouge au lieu de rester neutre. Noir et blanc
// francs, aucune teinte verte ni autre.
const themeMidnightGreen = DesignTheme(
  nom: 'Midnight',
  fond: Color(0xFF121212),
  fondProfond: Color(0xFF090909),
  blanc: Color(0xFFFAFAFA),
  accent: Color(0xFF000000),
  noir: Color(0xFF1C1C1C),
  // Gris argenté plutôt que l'or classique, pour rester dans le noir et
  // blanc plutôt que d'introduire une troisième teinte.
  or: Color(0xFFBDBDBD),
  orTexte: Color(0xFF4A4A4A),
);

// Palette entièrement fournie à la main (5 couleurs — fond et accents
// compris) plutôt que dérivée via DesignTheme.depuis : contrairement aux 2
// thèmes ci-dessus, celui-ci ne se contente pas de 2 couleurs, donc chaque
// rôle est assigné explicitement plutôt que recalculé par teinte.
const themeMoonscape = DesignTheme(
  nom: 'Moonscape',
  fond: Color(0xFF16131F), // Back in Black
  fondProfond: Color(0xFF0E0C12), // encore plus sombre, même teinte
  blanc: Color(0xFFF0D9E4), // Mountain Heather
  // Decanting/Funkie Friday échangées à la demande, mais chacune telle
  // quelle n'était lisible que dans son rôle d'origine (Decanting trop
  // claire pour du texte/bouton, Funkie Friday trop sombre pour un accent
  // sur fond déjà sombre) — même teinte, luminosité réajustée pour rester
  // lisible dans son nouveau rôle.
  accent: Color(0xFF6C4754), // Decanting, assombrie
  noir: Color(0xFF16131F), // Back in Black, réutilisé pour le texte sur carte
  or: Color(0xFFBCA7BE), // Funkie Friday, éclaircie
  // Moonscape (806C79) telle quelle manque de contraste sur la carte claire
  // (texte de citation illisible) — même teinte, assombrie.
  orTexte: Color(0xFF584150),
);

// "Plus rose, moins marron" (retour utilisateur sur la 1ère version, qui
// posait Dark Chocolate/Aloewood/Milk Tea en fond+accent) : le marron du
// palette d'origine est abandonné, tout est maintenant dérivé de la teinte
// de Sakura elle-même (fond/accent = Sakura assombrie à différents niveaux)
// + Misty Rose pour les cartes, comme DesignTheme.depuis mais calculé à la
// main pour garder or/orTexte proches du rose d'origine plutôt que dérivés
// de l'accent.
// La teinte brute de Sakura (EC9C9D) est à ~359° — quasiment du rouge pur
// (vert et bleu presque égaux) — donc l'assombrir donne du brique/marron,
// pas du rose, quelle que soit la saturation. accent/orTexte utilisent une
// teinte décalée vers ~340° (bleu plus présent que le vert) pour rester
// "rose foncé" une fois assombris ; or/fond restent sur la teinte d'origine.
const themeSakura = DesignTheme(
  nom: 'Sakura',
  fond: Color(0xFF302222), // Sakura assombrie (teinte 359°, L16%)
  fondProfond: Color(0xFF1F1415), // encore plus sombre, même teinte
  blanc: Color(0xFFF3DCDD), // Misty Rose
  accent: Color(0xFF8E294B), // rose foncé (teinte 340°, L36%) — pas du brique
  noir: Color(0xFF302222), // même valeur que fond, pour le texte sur carte
  or: Color(0xFFEC9C9D), // Sakura
  orTexte: Color(0xFF8E294B), // même valeur que accent
);

final themesDisponibles = <DesignTheme>[
  themeParDefaut,
  themeMidnightGreen,
  themeMoonscape,
  themeSakura,
];

const _temaChoisiKey = 'temaChoisi';

// Thème actif, observable : notifier permet un rebuild global (voir
// AnimatedBuilder autour de MaterialApp dans main.dart) quand l'utilisateur
// change de thème depuis Paramètres.
final temaActifNotifier = ValueNotifier<DesignTheme>(themeParDefaut);

void chargerTemaSauvegarde() {
  final nom = Hive.box('vocabBox').get(_temaChoisiKey) as String?;
  if (nom == null) return;

  for (final theme in themesDisponibles) {
    if (theme.nom == nom) {
      temaActifNotifier.value = theme;
      return;
    }
  }
}

void choisirTema(DesignTheme theme) {
  temaActifNotifier.value = theme;
  Hive.box('vocabBox').put(_temaChoisiKey, theme.nom);
}

Color get designFond => temaActifNotifier.value.fond;
Color get designFondProfond => temaActifNotifier.value.fondProfond;
Color get designBlanc => temaActifNotifier.value.blanc;
Color get designAccent => temaActifNotifier.value.accent;
Color get designNoir => temaActifNotifier.value.noir;
Color get designOr => temaActifNotifier.value.or;
Color get designOrTexte => temaActifNotifier.value.orTexte;
LinearGradient get designGradientFond => temaActifNotifier.value.gradientFond;
