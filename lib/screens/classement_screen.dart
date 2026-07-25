import 'package:flutter/material.dart';

import 'package:itinera/main.dart';
import 'package:itinera/screens/defi_quiz_screen.dart';
import 'package:itinera/services/duel_service.dart';
import 'package:itinera/services/social_service.dart';

class ClassementScreen extends StatefulWidget {
  final String monUid;
  final SocialService social;

  const ClassementScreen({
    super.key,
    required this.monUid,
    required this.social,
  });

  @override
  State<ClassementScreen> createState() => _ClassementScreenState();
}

class _ClassementScreenState extends State<ClassementScreen> {
  late Future<List<ProfilPublic>> _classement;

  @override
  void initState() {
    super.initState();
    _classement = widget.social.classementAmis(widget.monUid);
  }

  Future<void> _rafraichir() async {
    setState(() {
      _classement = widget.social.classementAmis(widget.monUid);
    });
    await _classement;
  }

  Future<void> _defier(ProfilPublic moi, ProfilPublic adversaire) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DefiQuizScreen(
          mode: ModeDefi.creation,
          mots: tirerMotsDefi(),
          moi: moi.uid,
          monNom: moi.displayName,
          monAvatar: moi.avatarEmoji,
          adversaireUid: adversaire.uid,
          adversaireNom: adversaire.displayName,
          adversaireAvatar: adversaire.avatarEmoji,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Classement')),
      body: FutureBuilder<List<ProfilPublic>>(
        future: _classement,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final classement = snapshot.data!;

          if (classement.length <= 1) {
            return RefreshIndicator(
              onRefresh: _rafraichir,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 80),
                  Icon(Icons.leaderboard, size: 48, color: texteAttenue),
                  const SizedBox(height: 16),
                  const Text(
                    'Suis quelqu\'un pour voir un classement.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ouvre "Chercher quelqu\'un" depuis Mon compte.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: texteAttenue),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _rafraichir,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: classement.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final profil = classement[index];
                final rang = index + 1;
                final cestMoi = profil.uid == widget.monUid;
                final moi = classement.firstWhere((p) => p.uid == widget.monUid);

                return Card(
                  color: cestMoi ? accentViolet.withValues(alpha: 0.12) : null,
                  child: ListTile(
                    leading: _MedailleOuRang(rang: rang),
                    title: Row(
                      children: [
                        Text(profil.avatarEmoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cestMoi ? '${profil.displayName} (toi)' : profil.displayName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: cestMoi ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      '🔥 ${profil.streak} · 🏆 ${profil.achievementsCount} · 💎 ${profil.coins}',
                    ),
                    trailing: cestMoi
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.sports_kabaddi, color: accentViolet),
                            tooltip: 'Défier',
                            onPressed: () => _defier(moi, profil),
                          ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _MedailleOuRang extends StatelessWidget {
  final int rang;
  const _MedailleOuRang({required this.rang});

  @override
  Widget build(BuildContext context) {
    const medailles = {1: '🥇', 2: '🥈', 3: '🥉'};
    final medaille = medailles[rang];

    return SizedBox(
      width: 32,
      child: Text(
        medaille ?? '$rang',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
