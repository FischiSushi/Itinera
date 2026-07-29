import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// Avatar équipé : soit un simple emoji (comportement historique), soit une
// tête de chat achetable en boutique, recadrée depuis l'une des deux
// planches fournies par l'utilisateur — reconnues par un préfixe dans la
// chaîne stockée (ex. 'chatpfp:7', 'chatlecons:2'). Un seul widget
// centralise l'affichage pour ne pas dupliquer ce test dans chaque écran
// qui montre un avatar (Boutique, Compte, Classement, Défis...).

const prefixeChatPfp = 'chatpfp:';
const prefixeChatLecons = 'chatlecons:';

const _cheminChatPfp = 'assets/chat_pfp.png';
const _colonnesChatPfp = 5;
const _lignesChatPfp = 8;

const _cheminChatStickers = 'assets/chat_stickers.png';

// La planche "chat_stickers.png" n'est pas une grille régulière (autocollants
// de tailles et positions très variables) : chaque pose utilisée a donc sa
// propre zone de recadrage (fractions 0..1), estimée visuellement, plutôt
// qu'un calcul de grille.
enum PoseChatStickers {
  oreillesPointues(Rect.fromLTRB(0.77, 0.06, 0.99, 0.20)),
  appareilPhoto(Rect.fromLTRB(0.015, 0.335, 0.205, 0.425)),
  yinYang(Rect.fromLTRB(0.76, 0.30, 0.99, 0.44)),
  boule(Rect.fromLTRB(0.775, 0.46, 0.975, 0.535)),
  casqueAudio(Rect.fromLTRB(0.595, 0.225, 0.775, 0.30)),
  visageSimple(Rect.fromLTRB(0.22, 0.905, 0.42, 0.985));

  final Rect zone;

  const PoseChatStickers(this.zone);
}

bool estAvatarChatPfp(String valeur) => valeur.startsWith(prefixeChatPfp);
bool estAvatarChatLecons(String valeur) => valeur.startsWith(prefixeChatLecons);
bool estAvatarImage(String valeur) =>
    estAvatarChatPfp(valeur) || estAvatarChatLecons(valeur);

String idChatPfp(int index) => '$prefixeChatPfp$index';
String idChatStickers(PoseChatStickers pose) =>
    '$prefixeChatLecons${pose.index}';

class AvatarGlyphe extends StatelessWidget {
  final String valeur;
  final double taille;

  // Fond clair derrière l'image, pour que le trait noir + blanc de la
  // silhouette reste lisible même posé directement sur un fond sombre
  // (sans lui, seul le fin contour blanc des yeux ressort).
  final bool fondClair;

  const AvatarGlyphe({
    super.key,
    required this.valeur,
    this.taille = 24,
    this.fondClair = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!estAvatarImage(valeur)) {
      return Text(valeur, style: TextStyle(fontSize: taille));
    }

    final image = SizedBox(
      width: taille,
      height: taille,
      child: FutureBuilder<ui.Image>(
        future: estAvatarChatPfp(valeur)
            ? _chargerImage(_cheminChatPfp)
            : _chargerImage(_cheminChatStickers),
        builder: (context, snapshot) {
          final image = snapshot.data;
          if (image == null) return const SizedBox.shrink();

          return CustomPaint(
            painter: _RecadragePainter(
              image: image,
              zone: estAvatarChatPfp(valeur)
                  ? _zoneGrilleChatPfp(valeur)
                  : PoseChatStickers
                        .values[int.tryParse(
                              valeur.substring(prefixeChatLecons.length),
                            ) ??
                            0]
                        .zone,
            ),
          );
        },
      ),
    );

    if (!fondClair) return image;

    return Container(
      width: taille,
      height: taille,
      padding: EdgeInsets.all(taille * 0.08),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFFDFBF5),
      ),
      child: image,
    );
  }

  Rect _zoneGrilleChatPfp(String valeur) {
    final index = int.tryParse(valeur.substring(prefixeChatPfp.length)) ?? 0;
    final colonne = (index % _colonnesChatPfp) / _colonnesChatPfp;
    final ligne = (index ~/ _colonnesChatPfp) / _lignesChatPfp;
    return Rect.fromLTWH(
      colonne,
      ligne,
      1 / _colonnesChatPfp,
      1 / _lignesChatPfp,
    );
  }
}

final Map<String, Future<ui.Image>> _imagesChargees = {};

Future<ui.Image> _chargerImage(String chemin) {
  return _imagesChargees[chemin] ??= () async {
    final donnees = await rootBundle.load(chemin);
    final codec = await ui.instantiateImageCodec(donnees.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }();
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
