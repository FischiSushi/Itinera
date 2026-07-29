import 'package:flutter/material.dart';

// Forme organique "blob" (tache d'encre arrondie) inspirée d'une référence
// visuelle fournie par l'utilisateur : des panneaux blancs à contour
// irrégulier et arrondi flottant sur un fond sombre, plutôt que des
// rectangles à coins arrondis classiques.
//
// Le contour est défini par une poignée de points normalisés (0..1) reliés
// par des courbes de Bézier quadratiques passant par le milieu de chaque
// segment : une technique simple qui donne un contour lisse et bosselé à
// partir de n'importe quel nuage de points, sans dépendance externe.

class BlobClipper extends CustomClipper<Path> {
  final List<Offset> pointsNormalises;

  const BlobClipper(this.pointsNormalises);

  @override
  Path getClip(Size size) {
    final points = pointsNormalises
        .map((p) => Offset(p.dx * size.width, p.dy * size.height))
        .toList();

    Offset milieu(Offset a, Offset b) =>
        Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);

    final n = points.length;
    final depart = milieu(points[n - 1], points[0]);

    final path = Path()..moveTo(depart.dx, depart.dy);

    for (var i = 0; i < n; i++) {
      final courant = points[i];
      final suivant = points[(i + 1) % n];
      final m = milieu(courant, suivant);
      path.quadraticBezierTo(courant.dx, courant.dy, m.dx, m.dy);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant BlobClipper oldClipper) =>
      oldClipper.pointsNormalises != pointsNormalises;
}

// Quelques variantes de contour prêtes à l'emploi (points en sens horaire).
const blobDouce = [
  Offset(0.48, 0.01),
  Offset(0.82, 0.08),
  Offset(0.99, 0.38),
  Offset(0.92, 0.72),
  Offset(0.64, 0.99),
  Offset(0.30, 0.94),
  Offset(0.03, 0.68),
  Offset(0.06, 0.28),
  Offset(0.22, 0.04),
];

const blobRonde = [
  Offset(0.5, 0.0),
  Offset(0.87, 0.15),
  Offset(1.0, 0.5),
  Offset(0.87, 0.85),
  Offset(0.5, 1.0),
  Offset(0.13, 0.85),
  Offset(0.0, 0.5),
  Offset(0.13, 0.15),
];

// Panneau à contour "blob" avec une couleur de fond unie — le composant de
// base pour reproduire les cartes blanches flottantes de la référence.
class BlobPanel extends StatelessWidget {
  final Widget child;
  final Color couleur;
  final List<Offset> forme;
  final EdgeInsetsGeometry padding;

  const BlobPanel({
    super.key,
    required this.child,
    required this.couleur,
    this.forme = blobDouce,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BlobClipper(forme),
      child: Container(color: couleur, padding: padding, child: child),
    );
  }
}
