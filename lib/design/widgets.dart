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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: designNoir,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: designNoir.withValues(alpha: 0.6)),
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
                    style: const TextStyle(
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
