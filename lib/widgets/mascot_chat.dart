import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// Planche de silhouettes de chat fournie par l'utilisateur (une seule image,
// 9 poses) — recadrée à la demande via des rectangles (fractions 0..1 de
// l'image source) plutôt que par des fichiers séparés. Les poses ne
// remplissent pas une grille 3x3 parfaitement égale, donc chaque zone a été
// estimée visuellement plutôt que déduite d'un découpage en tiers.
const _cheminChatsSilhouettes = 'assets/chats_silhouettes.png';

enum PoseChat {
  ventreEnRond(Rect.fromLTRB(0.02, 0.13, 0.31, 0.35)),
  jeuAvecLaQueue(Rect.fromLTRB(0.33, 0.09, 0.66, 0.37)),
  assisDeFace(Rect.fromLTRB(0.67, 0.13, 0.98, 0.37)),
  marche(Rect.fromLTRB(0.02, 0.37, 0.31, 0.59)),
  couche(Rect.fromLTRB(0.34, 0.39, 0.64, 0.61)),
  dosRond(Rect.fromLTRB(0.65, 0.37, 0.99, 0.61)),
  allongeSurLeDos(Rect.fromLTRB(0.02, 0.64, 0.31, 0.87)),
  peloteRoulee(Rect.fromLTRB(0.33, 0.69, 0.65, 0.87)),
  assisDeFaceQueueLevee(Rect.fromLTRB(0.69, 0.65, 0.98, 0.87));

  final Rect zoneFractionnelle;

  const PoseChat(this.zoneFractionnelle);
}

Future<ui.Image>? _imageChargee;

Future<ui.Image> _chargerImage() {
  return _imageChargee ??= () async {
    final donnees = await rootBundle.load(_cheminChatsSilhouettes);
    final codec = await ui.instantiateImageCodec(
      donnees.buffer.asUint8List(),
    );
    final frame = await codec.getNextFrame();
    return frame.image;
  }();
}

class MascotteChat extends StatelessWidget {
  final PoseChat pose;
  final double taille;

  const MascotteChat({
    super.key,
    this.pose = PoseChat.assisDeFaceQueueLevee,
    this.taille = 64,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: taille,
      height: taille,
      child: FutureBuilder<ui.Image>(
        future: _chargerImage(),
        builder: (context, snapshot) {
          final image = snapshot.data;
          if (image == null) return const SizedBox.shrink();

          return CustomPaint(
            painter: _RecadragePainter(
              image: image,
              zone: pose.zoneFractionnelle,
            ),
          );
        },
      ),
    );
  }
}

class _RecadragePainter extends CustomPainter {
  final ui.Image image;
  final Rect zone;

  _RecadragePainter({required this.image, required this.zone});

  @override
  void paint(Canvas canvas, Size size) {
    final source = Rect.fromLTRB(
      zone.left * image.width,
      zone.top * image.height,
      zone.right * image.width,
      zone.bottom * image.height,
    );
    final destination = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(
      image,
      source,
      destination,
      Paint()..filterQuality = FilterQuality.high,
    );
  }

  @override
  bool shouldRepaint(covariant _RecadragePainter oldDelegate) =>
      oldDelegate.image != image || oldDelegate.zone != zone;
}
