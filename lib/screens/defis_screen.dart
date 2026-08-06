import 'package:flutter/material.dart';

import 'package:itinera/screens/defi_quiz_screen.dart';
import 'package:itinera/services/duel_service.dart';
import 'package:itinera/widgets/avatar_glyphe.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';

class DefisScreen extends StatefulWidget {
  final String monUid;

  const DefisScreen({super.key, required this.monUid});

  @override
  State<DefisScreen> createState() => _DefisScreenState();
}

class _DefisScreenState extends State<DefisScreen> {
  final _duel = DuelService();
  late Future<List<Defi>> _historique;

  @override
  void initState() {
    super.initState();
    _historique = _duel.historiqueDefis(widget.monUid);
  }

  Future<void> _rafraichirHistorique() async {
    final future = _duel.historiqueDefis(widget.monUid);
    setState(() => _historique = future);
    await future;
  }

  Future<void> _repondre(Defi defi) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DefiQuizScreen(
          mode: ModeDefi.reponse,
          mots: defi.mots,
          defiId: defi.id,
        ),
      ),
    );

    if (mounted) _rafraichirHistorique();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: designFond,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          title: const Text('Défis'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Reçus'),
              Tab(text: 'Envoyés'),
              Tab(text: 'Terminés'),
            ],
          ),
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: designGradientFond),
          child: TabBarView(
            children: [_ongletRecus(), _ongletEnvoyes(), _ongletTermines()],
          ),
        ),
      ),
    );
  }

  Widget _ongletRecus() {
    return StreamBuilder<List<Defi>>(
      stream: _duel.defisRecus(widget.monUid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final defis = snapshot.data!;

        if (defis.isEmpty) {
          return _etatVide(
            icone: Icons.mail_outline,
            texte: 'Aucun défi en attente.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: defis.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final defi = defis[i];
            return CarteDesign(
              padding: EdgeInsets.zero,
              child: ListTile(
                iconColor: designAccent,
                textColor: designNoir,
                leading: AvatarGlyphe(valeur: defi.fromAvatar, taille: 32),
                title: Text(defi.fromNom),
                subtitle: Text(
                  'Son score : ${defi.scoreFrom} / ${defi.mots.length}',
                ),
                trailing: const Icon(Icons.play_arrow),
                onTap: () => _repondre(defi),
              ),
            );
          },
        );
      },
    );
  }

  Widget _ongletEnvoyes() {
    return StreamBuilder<List<Defi>>(
      stream: _duel.defisEnvoyes(widget.monUid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final defis = snapshot.data!;

        if (defis.isEmpty) {
          return _etatVide(
            icone: Icons.send_outlined,
            texte: 'Aucun défi envoyé en attente.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: defis.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final defi = defis[i];
            return CarteDesign(
              padding: EdgeInsets.zero,
              child: ListTile(
                iconColor: designAccent,
                textColor: designNoir,
                leading: AvatarGlyphe(valeur: defi.toAvatar, taille: 32),
                title: Text(defi.toNom),
                subtitle: Text(
                  'Ton score : ${defi.scoreFrom} / ${defi.mots.length} · en attente de réponse',
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _ongletTermines() {
    return RefreshIndicator(
      onRefresh: _rafraichirHistorique,
      child: FutureBuilder<List<Defi>>(
        future: _historique,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final defis = snapshot.data!;

          if (defis.isEmpty) {
            return ListView(
              children: [
                _etatVide(
                  icone: Icons.history,
                  texte: 'Aucun défi terminé pour l\'instant.',
                ),
              ],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: defis.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final defi = defis[i];
              final monScore = defi.monScore(widget.monUid);
              final scoreAdversaire = defi.scoreAdversaire(widget.monUid);

              final String resultat;
              final Color couleur;
              if (monScore > scoreAdversaire) {
                resultat = 'Gagné 🏆';
                couleur = Colors.green;
              } else if (monScore < scoreAdversaire) {
                resultat = 'Perdu';
                couleur = Colors.red;
              } else {
                resultat = 'Égalité';
                couleur = designNoir.withValues(alpha: 0.6);
              }

              return CarteDesign(
                padding: EdgeInsets.zero,
                child: ListTile(
                  iconColor: designAccent,
                  textColor: designNoir,
                  leading: AvatarGlyphe(
                    valeur: defi.adversaireAvatar(widget.monUid),
                    taille: 32,
                  ),
                  title: Text(defi.adversaireNom(widget.monUid)),
                  subtitle: Text('$monScore - $scoreAdversaire'),
                  trailing: Text(
                    resultat,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: couleur,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _etatVide({required IconData icone, required String texte}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 48, color: Colors.white70),
            const SizedBox(height: 12),
            Text(
              texte,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
