import 'package:flutter/material.dart';

import 'package:itinera/main.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';
import 'package:itinera/services/backup_service.dart';
import 'package:itinera/services/notification_service.dart';

class ParametresScreen extends StatefulWidget {
  const ParametresScreen({super.key});

  @override
  State<ParametresScreen> createState() => _ParametresScreenState();
}

class _ParametresScreenState extends State<ParametresScreen> {
  final _notifications = NotificationService();
  final _backup = BackupService();

  late bool _rappelActif;
  late TimeOfDay _heureRappel;
  late bool _fondEtoileActif;
  bool _enCours = false;

  @override
  void initState() {
    super.initState();
    _rappelActif = _notifications.rappelActif();
    final heure = _notifications.heureRappel();
    _heureRappel = TimeOfDay(hour: heure.heure, minute: heure.minute);
    _fondEtoileActif = fondEtoileActif();
  }

  Future<void> _basculerRappel(bool valeur) async {
    if (!valeur) {
      await _notifications.desactiverRappel();
      setState(() => _rappelActif = false);
      return;
    }

    final autorise = await _notifications.activerRappel(
      heure: _heureRappel.hour,
      minute: _heureRappel.minute,
    );

    if (!mounted) return;

    if (!autorise) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Notifications refusées : active-les dans les réglages du système.',
          ),
        ),
      );
      return;
    }

    setState(() => _rappelActif = true);
  }

  Future<void> _choisirHeure() async {
    final choisie = await showTimePicker(
      context: context,
      initialTime: _heureRappel,
    );

    if (choisie == null) return;

    setState(() => _heureRappel = choisie);

    if (_rappelActif) {
      await _notifications.activerRappel(heure: choisie.hour, minute: choisie.minute);
    }
  }

  void _basculerFondEtoile(bool valeur) {
    definirFondEtoileActif(valeur);
    setState(() => _fondEtoileActif = valeur);
  }

  Future<void> _exporter() async {
    setState(() => _enCours = true);
    try {
      await _backup.exporterEtPartager();
    } finally {
      if (mounted) setState(() => _enCours = false);
    }
  }

  Future<void> _importer() async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Importer une sauvegarde'),
        content: const Text(
          'Ça va remplacer ta progression actuelle (vocabulaire, série, '
          'pièces, succès) par celle du fichier choisi. Continuer ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remplacer'),
          ),
        ],
      ),
    );

    if (confirme != true || !mounted) return;

    setState(() => _enCours = true);
    final ResultatImport resultat;
    try {
      resultat = await _backup.importerDepuisFichier();
    } finally {
      if (mounted) setState(() => _enCours = false);
    }

    if (!mounted || resultat == ResultatImport.annule) return;

    if (resultat == ResultatImport.invalide) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fichier de sauvegarde invalide.')),
      );
      return;
    }

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import terminé'),
        content: const Text(
          'Redémarre l\'app pour que la progression importée soit prise en compte.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Paramètres'),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: designGradientFond),
        child: AbsorbPointer(
          absorbing: _enCours,
          child: Opacity(
            opacity: _enCours ? 0.6 : 1,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CarteDesign(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: const Icon(
                          Icons.notifications_active,
                          color: designAccent,
                        ),
                        title: const Text(
                          'Rappel quotidien',
                          style: TextStyle(color: designNoir),
                        ),
                        subtitle: Text(
                          'Un message pour ne pas perdre ta série',
                          style: TextStyle(color: designNoir.withValues(alpha: 0.6)),
                        ),
                        activeThumbColor: designAccent,
                        value: _rappelActif,
                        onChanged: _basculerRappel,
                      ),
                      if (_rappelActif) ...[
                        Divider(height: 1, color: designNoir.withValues(alpha: 0.1)),
                        ListTile(
                          leading: const Icon(Icons.access_time, color: designAccent),
                          title: const Text(
                            'Heure du rappel',
                            style: TextStyle(color: designNoir),
                          ),
                          trailing: Text(
                            _heureRappel.format(context),
                            style: const TextStyle(color: designNoir),
                          ),
                          onTap: _choisirHeure,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Apparence',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                CarteDesign(
                  padding: EdgeInsets.zero,
                  child: SwitchListTile(
                    secondary: const Icon(Icons.auto_awesome, color: designAccent),
                    title: const Text(
                      'Fond étoilé',
                      style: TextStyle(color: designNoir),
                    ),
                    subtitle: Text(
                      'Photo de ciel étoilé derrière le Parcours (sinon, fond uni)',
                      style: TextStyle(color: designNoir.withValues(alpha: 0.6)),
                    ),
                    activeThumbColor: designAccent,
                    value: _fondEtoileActif,
                    onChanged: _basculerFondEtoile,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sauvegarde',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                CarteDesign(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.upload, color: designAccent),
                        title: const Text(
                          'Exporter ma progression',
                          style: TextStyle(color: designNoir),
                        ),
                        subtitle: Text(
                          'Envoie un fichier de sauvegarde (Drive, mail...)',
                          style: TextStyle(color: designNoir.withValues(alpha: 0.6)),
                        ),
                        onTap: _exporter,
                      ),
                      Divider(height: 1, color: designNoir.withValues(alpha: 0.1)),
                      ListTile(
                        leading: const Icon(Icons.download, color: designAccent),
                        title: const Text(
                          'Importer une sauvegarde',
                          style: TextStyle(color: designNoir),
                        ),
                        subtitle: Text(
                          'Remplace la progression actuelle',
                          style: TextStyle(color: designNoir.withValues(alpha: 0.6)),
                        ),
                        onTap: _importer,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
