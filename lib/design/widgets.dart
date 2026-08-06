import 'package:flutter/material.dart';

import 'package:itinera/design/palette.dart';

// Petits blocs réutilisables pour la palette "blob" (cf. palette.dart),
// factorisés dès le 3e écran migré pour éviter de retricoter la même
// carte crème à chaque nouvel écran.

Widget statTileDesign({
  required IconData icone,
  required String valeur,
  required String label,
}) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: designNoir.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icone, color: designAccent),
          const SizedBox(height: 4),
          Text(
            valeur,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: designNoir,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: designNoir.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget carteActionDesign({
  required IconData icone,
  required String titre,
  required String sousTitre,
  required VoidCallback onTap,
}) {
  return Material(
    color: designBlanc,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icone, color: designAccent),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titre,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: designNoir,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sousTitre,
                    style: TextStyle(
                      fontSize: 12,
                      color: designNoir.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: designNoir.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    ),
  );
}

// Style de bouton principal (fond accent, texte blanc) partagé par tous les
// écrans migrés — évite de retricoter le même ElevatedButton.styleFrom.
final ButtonStyle styleBoutonAccent = ElevatedButton.styleFrom(
  backgroundColor: designAccent,
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(vertical: 14),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
);

// Style de bouton secondaire (contour clair, pour poser sur le fond sombre
// directement plutôt que sur une carte crème — designAccent n'y serait pas
// assez lisible, cf. les boutons de notation dans vocabulaire_screen.dart).
final ButtonStyle styleBoutonContour = OutlinedButton.styleFrom(
  foregroundColor: Colors.white,
  side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
);

// Petit badge pilule (fond crème, texte/icône accent) pour un repère ponctuel
// posé directement sur le fond sombre — voir "Vérification rapide" dans
// lecon_detail_screen.dart.
Widget badgeDesign({required IconData icone, required String texte}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: designBlanc,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icone, color: designAccent, size: 18),
        const SizedBox(width: 6),
        Text(
          texte,
          style: TextStyle(color: designAccent, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

// Enveloppe un AlertDialog/showModalBottomSheet du "vieux" code (main.dart)
// pour qu'il suive la palette active (fond crème, texte/icônes foncés,
// accent thématique) au lieu du thème sombre global — sans ça, ces
// dialogues/feuilles restent gris foncé même quand tout le reste de l'écran
// a basculé sur la palette blob. ListTile/TextButton lisent leurs couleurs
// par défaut dans le ColorScheme ambiant (recoloré via ce Theme local), mais
// un Text() sans style explicite lit plutôt le DefaultTextStyle posé par le
// Material le plus proche — pour showModalBottomSheet, ce Material englobant
// est construit par le framework avec le Theme du site d'appel, *avant*
// notre propre Theme (donc backgroundColor du sheet doit être passé
// directement à showModalBottomSheet, ce Theme-ci ne peut pas l'atteindre) —
// le Material(transparency) ci-dessous recrée un DefaultTextStyle à jour pour
// tout ce qui vient après, dans notre propre sous-arbre.
class FeuilleDesign extends StatelessWidget {
  final Widget child;

  const FeuilleDesign({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final themeParent = Theme.of(context);

    return Theme(
      data: themeParent.copyWith(
        colorScheme: themeParent.colorScheme.copyWith(
          surface: designBlanc,
          onSurface: designNoir,
          // ListTile (icônes leading/trailing en M3) lit onSurfaceVariant,
          // pas onSurface — sans ça, ses icônes restent dans la teinte pâle
          // de l'ancien thème sombre, illisibles sur le fond crème.
          onSurfaceVariant: designNoir.withValues(alpha: 0.7),
          primary: designAccent,
          onPrimary: Colors.white,
          secondary: designAccent,
          onSecondary: Colors.white,
        ),
        // ThemeData.copyWith() ne recalcule pas textTheme à partir du nouveau
        // colorScheme — sans ça, un Text() sans couleur explicite (ou le
        // titre/contenu par défaut d'AlertDialog, qui lisent textTheme) reste
        // dans la teinte pâle héritée du thème sombre d'origine, illisible
        // sur le fond crème.
        textTheme: themeParent.textTheme.apply(
          bodyColor: designNoir,
          displayColor: designNoir,
        ),
        primaryTextTheme: themeParent.primaryTextTheme.apply(
          bodyColor: designNoir,
          displayColor: designNoir,
        ),
        dialogTheme: DialogThemeData(backgroundColor: designBlanc),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: designBlanc,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        ),
      ),
      child: Material(type: MaterialType.transparency, child: child),
    );
  }
}

// Carte crème générique (panneau blanc arrondi), pour envelopper du contenu
// libre sans redéfinir le décor à chaque écran.
class CarteDesign extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const CarteDesign({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: designBlanc,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
