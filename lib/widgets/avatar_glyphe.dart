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
  appareilPhoto(Rect.fromLTRB(0.0041, 0.3328, 0.1848, 0.4389)),
  yinYang(Rect.fromLTRB(0.7473, 0.3160, 0.9647, 0.4437)),
  boule(Rect.fromLTRB(0.775, 0.46, 0.975, 0.535)),
  casqueAudio(Rect.fromLTRB(0.5612, 0.2115, 0.7459, 0.3200)),
  visageSimple(Rect.fromLTRB(0.2120, 0.8867, 0.4049, 1.0));

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

    final personnalisee = _zonesPersonaliseesChatPfp[index];
    if (personnalisee != null) return personnalisee;

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

// Recadrages sur mesure pour les cases de la grille chat_pfp utilisées en
// boutique : la case brute (1/5 x 1/8 de la planche) ne centre pas
// forcément le dessin (texte "Zzz", "OK"...), donc chaque zone ici est la
// vraie boîte englobante du dessin (détection de forme connexe, carrée,
// centrée) plutôt que la case entière — voir scratchpad/center_avatars.ps1
// pour la méthode si de nouveaux avatars sont ajoutés.
const _zonesPersonaliseesChatPfp = {
  0: Rect.fromLTRB(0.0353, 0.0187, 0.2228, 0.1418), // chat câlin
  7: Rect.fromLTRB(0.4063, 0.1392, 0.5938, 0.2632), // chat émerveillé
  13: Rect.fromLTRB(0.5910, 0.2614, 0.7799, 0.3854), // chat rêveur
  22: Rect.fromLTRB(0.4076, 0.5049, 0.5938, 0.6271), // chat en boule
  27: Rect.fromLTRB(0.4063, 0.6333, 0.5924, 0.7556), // chat sauvage
  37: Rect.fromLTRB(0.4076, 0.8752, 0.5924, 0.9964), // chat classique
};

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
