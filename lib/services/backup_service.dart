import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// Sauvegarde / restauration de la progression locale (streak, pièces,
// succès, cartes FSRS, vocabulaire personnalisé...) : tout vocabBox est
// stocké en clé/valeur JSON-compatible, donc un simple dump du box suffit.
//
// L'app ne relit le box qu'au démarrage (voir main()), donc après un import
// il faut redémarrer l'app pour que les changements soient pris en compte.

const _formatSauvegarde = 1;

enum ResultatImport { succes, annule, invalide }

class BackupService {
  Future<void> exporterEtPartager() async {
    final box = Hive.box('vocabBox');

    final contenu = jsonEncode({
      'format': _formatSauvegarde,
      'exporteLe': DateTime.now().toIso8601String(),
      'donnees': Map<String, dynamic>.from(box.toMap()),
    });

    final dossier = await getTemporaryDirectory();
    final horodatage = DateTime.now()
        .toIso8601String()
        .replaceAll(RegExp(r'[:.]'), '-');
    final fichier = File('${dossier.path}/itinera_sauvegarde_$horodatage.json');
    await fichier.writeAsString(contenu);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(fichier.path)],
        subject: 'Sauvegarde Itinera',
        text: 'Ma progression Itinera (à réimporter dans l\'app).',
      ),
    );
  }

  Future<ResultatImport> importerDepuisFichier() async {
    final fichier = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(label: 'Sauvegarde Itinera', extensions: ['json']),
      ],
    );

    if (fichier == null) return ResultatImport.annule;

    final Map<String, dynamic> racine;
    try {
      racine = jsonDecode(await fichier.readAsString()) as Map<String, dynamic>;
    } catch (_) {
      return ResultatImport.invalide;
    }

    final donnees = racine['donnees'];
    if (donnees is! Map) return ResultatImport.invalide;

    final box = Hive.box('vocabBox');
    await box.clear();
    await box.putAll(Map<String, dynamic>.from(donnees));

    return ResultatImport.succes;
  }
}
