import 'package:flutter/material.dart';

import 'package:itinera/screens/defi_quiz_screen.dart';
import 'package:itinera/services/duel_service.dart';
import 'package:itinera/services/social_service.dart';
import 'package:itinera/widgets/avatar_glyphe.dart';
import 'package:itinera/design/palette.dart';

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
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Classement'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: FutureBuilder<List<ProfilPublic>>(
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
                    const Icon(
                      Icons.leaderboard,
                      size: 48,
                      color: Colors.white70,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Suis quelqu\'un pour voir un classement.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ouvre "Chercher quelqu\'un" depuis Mon compte.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            }

            // Peut être absent si le profil public n'a pas encore fini de se
            // synchroniser (synchroniserProfil() dans CompteScreen n'est pas
            // attendu) : on se contente alors de masquer le bouton "Défier"
            // plutôt que de planter tout l'écran sur un firstWhere() sans
            // correspondance.
            ProfilPublic? monProfil;
            for (final p in classement) {
              if (p.uid == widget.monUid) {
                monProfil = p;
                break;
              }
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
                  final moi = monProfil;

                  return Container(
                    decoration: BoxDecoration(
                      color: designBlanc,
                      borderRadius: BorderRadius.circular(20),
                      border: cestMoi
                          ? Border.all(color: designAccent, width: 2)
                          : null,
                    ),
                    child: ListTile(
                      iconColor: designAccent,
                      textColor: designNoir,
                      leading: _MedailleOuRang(rang: rang),
                      title: Row(
                        children: [
                          AvatarGlyphe(valeur: profil.avatarEmoji, taille: 28),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              cestMoi
                                  ? '${profil.displayName} (toi)'
                                  : profil.displayName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: cestMoi
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: designNoir,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        '🔥 ${profil.streak} · 🏆 ${profil.achievementsCount} · 💎 ${profil.coins}',
                        style: TextStyle(
                          color: designNoir.withValues(alpha: 0.6),
                        ),
                      ),
                      trailing: cestMoi || moi == null
                          ? null
                          : IconButton(
                              icon: Icon(
                                Icons.sports_kabaddi,
                                color: designAccent,
                              ),
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
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: designNoir,
        ),
      ),
    );
  }
}
