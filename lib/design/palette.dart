import 'package:flutter/material.dart';

// Palette "blob" validée sur l'écran Parcours (fond marine profond, panneaux
// crème, accent rose, or réservé aux petits accents ponctuels) — partagée
// ici pour être réutilisée écran par écran sans dupliquer les constantes
// locales à chaque fichier. Volontairement à part de main.dart/ThemeData :
// le thème global suppose encore des cartes sombres avec texte clair
// (surfaceWidget + texteClair), donc basculer ThemeData directement
// casserait le contraste de tous les écrans pas encore migrés vers cette
// palette. Chaque écran migré importe ce fichier et applique les couleurs
// explicitement jusqu'à ce que tout l'app soit passé dessus.

const designFond = Color(0xFF1D1B31);
const designFondProfond = Color(0xFF16142A);
const designBlanc = Color(0xFFFDFBF5);
const designAccent = Color(0xFFF3A9C6);
const designOr = Color(0xFFE8BE6E);
// Même famille de or que designOr, mais bien plus sombre : designOr n'a pas
// assez de contraste sur designBlanc, seulement sur le fond marine — celui-ci
// est réservé au texte/icônes sur fond clair.
const designOrTexte = Color(0xFF9C6F1B);
const designNoir = Color(0xFF241F3D);

const designGradientFond = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [designFond, designFondProfond],
);
