import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

import 'package:itinera/main.dart';
import 'package:itinera/screens/boutique_screen.dart';
import 'package:itinera/screens/classement_screen.dart';
import 'package:itinera/screens/defis_screen.dart';
import 'package:itinera/screens/succes_screen.dart';
import 'package:itinera/services/auth_service.dart';
import 'package:itinera/services/duel_service.dart';
import 'package:itinera/services/social_service.dart';
import 'package:itinera/widgets/avatar_glyphe.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';

class CompteScreen extends StatefulWidget {
  const CompteScreen({super.key});

  @override
  State<CompteScreen> createState() => _CompteScreenState();
}

class _CompteScreenState extends State<CompteScreen> {
  final _auth = AuthService();
  final _social = SocialService();

  @override
  Widget build(BuildContext context) {
    if (!firebaseDisponible) {
      return const _EcranNonConfigure();
    }

    return StreamBuilder<User?>(
      stream: _auth.changementsUtilisateur,
      builder: (context, snapshot) {
        final utilisateur = snapshot.data;

        if (utilisateur == null) {
          return _EcranConnexion(auth: _auth);
        }

        return _EcranProfil(
          utilisateur: utilisateur,
          auth: _auth,
          social: _social,
        );
      },
    );
  }
}

// ------------------------------------------------------------
// Firebase pas encore configuré (voir FIREBASE_SETUP.md)
// ------------------------------------------------------------

class _EcranNonConfigure extends StatelessWidget {
  const _EcranNonConfigure();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Mon compte'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, size: 48, color: Colors.white70),
                const SizedBox(height: 16),
                const Text(
                  'La fonction Compte n\'est pas encore configurée.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Voir FIREBASE_SETUP.md à la racine du projet pour '
                  'l\'activer.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Connexion / inscription
// ------------------------------------------------------------

class _EcranConnexion extends StatefulWidget {
  final AuthService auth;
  const _EcranConnexion({required this.auth});

  @override
  State<_EcranConnexion> createState() => _EcranConnexionState();
}

class _EcranConnexionState extends State<_EcranConnexion> {
  final _formKey = GlobalKey<FormState>();
  final _emailControleur = TextEditingController();
  final _motDePasseControleur = TextEditingController();
  final _nomControleur = TextEditingController();

  bool _modeInscription = false;
  bool _enCours = false;
  String? _erreur;

  @override
  void dispose() {
    _emailControleur.dispose();
    _motDePasseControleur.dispose();
    _nomControleur.dispose();
    super.dispose();
  }

  Future<void> _valider() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _enCours = true;
      _erreur = null;
    });

    try {
      final User utilisateur;
      if (_modeInscription) {
        utilisateur = await widget.auth.inscrire(
          email: _emailControleur.text,
          motDePasse: _motDePasseControleur.text,
        );
        final nom = _nomControleur.text.trim();
        if (nom.isNotEmpty) {
          await utilisateur.updateDisplayName(nom);
        }
      } else {
        utilisateur = await widget.auth.connecter(
          email: _emailControleur.text,
          motDePasse: _motDePasseControleur.text,
        );
      }
    } on AuthException catch (e) {
      setState(() => _erreur = e.message);
    } finally {
      if (mounted) setState(() => _enCours = false);
    }
  }

  Future<void> _motDePasseOublie() async {
    if (_emailControleur.text.trim().isEmpty) {
      setState(
        () => _erreur = 'Indique ton adresse e-mail ci-dessus d\'abord.',
      );
      return;
    }

    try {
      await widget.auth.reinitialiserMotDePasse(_emailControleur.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail de réinitialisation envoyé.')),
        );
      }
    } on AuthException catch (e) {
      setState(() => _erreur = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Mon compte'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.account_circle, size: 64, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  _modeInscription ? 'Créer un compte' : 'Se connecter',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                if (_modeInscription) ...[
                  TextFormField(
                    controller: _nomControleur,
                    decoration: const InputDecoration(
                      labelText: 'Nom affiché (optionnel)',
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                TextFormField(
                  controller: _emailControleur,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  validator: (valeur) =>
                      (valeur == null || !valeur.contains('@'))
                      ? 'Adresse e-mail invalide'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _motDePasseControleur,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                  validator: (valeur) => (valeur == null || valeur.length < 6)
                      ? '6 caractères minimum'
                      : null,
                ),
                if (_erreur != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _erreur!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  style: styleBoutonAccent,
                  onPressed: _enCours ? null : _valider,
                  child: _enCours
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _modeInscription
                              ? 'Créer mon compte'
                              : 'Se connecter',
                        ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() {
                    _modeInscription = !_modeInscription;
                    _erreur = null;
                  }),
                  child: Text(
                    _modeInscription
                        ? 'J\'ai déjà un compte'
                        : 'Créer un nouveau compte',
                  ),
                ),
                if (!_modeInscription)
                  TextButton(
                    onPressed: _motDePasseOublie,
                    child: const Text('Mot de passe oublié ?'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Profil connecté : aperçu + follower/following
// ------------------------------------------------------------

class _EcranProfil extends StatefulWidget {
  final User utilisateur;
  final AuthService auth;
  final SocialService social;

  const _EcranProfil({
    required this.utilisateur,
    required this.auth,
    required this.social,
  });

  @override
  State<_EcranProfil> createState() => _EcranProfilState();
}

class _EcranProfilState extends State<_EcranProfil> {
  final _duel = DuelService();

  @override
  void initState() {
    super.initState();
    // Garde le profil public à jour avec les valeurs locales (streak,
    // deniers, avatar) à chaque ouverture, pour que les abonnés voient des
    // chiffres récents.
    widget.social.synchroniserProfil(
      uid: widget.utilisateur.uid,
      displayName: widget.utilisateur.displayName?.isNotEmpty == true
          ? widget.utilisateur.displayName!
          : (widget.utilisateur.email?.split('@').first ?? 'Sans nom'),
      email: widget.utilisateur.email ?? '',
      avatarEmoji: emojiAvatarEquipe(),
      streak: streakActuel(),
      achievementsCount: succesDebloques().length,
      coins: coins(),
    );
  }

  Future<void> _chercherEtSuivre() async {
    final controleur = TextEditingController();

    final email = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chercher quelqu\'un'),
        content: TextField(
          controller: controleur,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Adresse e-mail'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controleur.text),
            child: const Text('Chercher'),
          ),
        ],
      ),
    );

    if (email == null || email.trim().isEmpty || !mounted) return;

    final profil = await widget.social.chercherParEmail(email);

    if (!mounted) return;

    if (profil == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Personne ne correspond à cette adresse.'),
        ),
      );
      return;
    }

    if (profil.uid == widget.utilisateur.uid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('C\'est toi !')));
      return;
    }

    final dejaSuivi = await widget.social.estAbonne(
      moi: widget.utilisateur.uid,
      autre: profil.uid,
    );

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AvatarGlyphe(valeur: profil.avatarEmoji, taille: 28),
            const SizedBox(width: 8),
            Flexible(child: Text(profil.displayName)),
          ],
        ),
        content: Text('🔥 ${profil.streak} · 🏆 ${profil.achievementsCount}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          TextButton(
            onPressed: () async {
              if (dejaSuivi) {
                await widget.social.neplusSuivre(
                  moi: widget.utilisateur.uid,
                  autre: profil.uid,
                );
              } else {
                await widget.social.suivre(
                  moi: widget.utilisateur.uid,
                  autre: profil.uid,
                );
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(dejaSuivi ? 'Ne plus suivre' : 'Suivre'),
          ),
        ],
      ),
    );
  }

  Future<void> _afficherListe(String titre, Stream<List<String>> uids) async {
    final valeurs = await uids.first;
    final profils = await Future.wait(
      valeurs.map((uid) => widget.social.profil(uid)),
    );
    final trouves = profils.whereType<ProfilPublic>().toList();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (trouves.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('Personne pour l\'instant.'),
                  )
                else
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: trouves
                          .map(
                            (p) => ListTile(
                              leading: AvatarGlyphe(
                                valeur: p.avatarEmoji,
                                taille: 32,
                              ),
                              title: Text(p.displayName),
                              subtitle: Text(
                                '🔥 ${p.streak} · 🏆 ${p.achievementsCount}',
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = widget.utilisateur.uid;
    final nom = widget.utilisateur.displayName?.isNotEmpty == true
        ? widget.utilisateur.displayName!
        : (widget.utilisateur.email ?? 'Sans nom');

    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Mon compte'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () => widget.auth.deconnecter(),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    child: AvatarGlyphe(
                      valeur: emojiAvatarEquipe(),
                      taille: 46,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nom,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                  if (widget.utilisateur.email != null)
                    Text(
                      widget.utilisateur.email!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            CarteDesign(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatTuile(
                    icone: Icons.local_fire_department,
                    couleur: couleurStreak(streakActuel()),
                    valeur: '${streakActuel()}',
                    label: 'Série',
                  ),
                  _StatTuile(
                    icone: Icons.diamond,
                    couleur: designOrTexte,
                    valeur: '${coins()}',
                    label: 'Deniers',
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SuccesScreen(),
                      ),
                    ),
                    child: _StatTuile(
                      icone: Icons.emoji_events,
                      couleur: designAccent,
                      valeur:
                          '${succesDebloques().length}/${succesDisponibles.length}',
                      label: 'Succès',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            CarteDesign(
              padding: EdgeInsets.zero,
              child: ListTile(
                iconColor: designAccent,
                textColor: designNoir,
                leading: const Icon(Icons.storefront),
                title: const Text('Changer d\'avatar'),
                subtitle: const Text('Ouvrir la boutique'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BoutiqueScreen(),
                    ),
                  );
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 12),

            CarteDesign(
              padding: EdgeInsets.zero,
              child: StreamBuilder<List<Defi>>(
                stream: _duel.defisRecus(uid),
                builder: (context, snap) {
                  final enAttente = snap.data?.length ?? 0;

                  return ListTile(
                    iconColor: designAccent,
                    textColor: designNoir,
                    leading: const Icon(Icons.sports_kabaddi),
                    title: const Text('Défis'),
                    subtitle: Text(
                      enAttente > 0
                          ? '$enAttente en attente de réponse'
                          : 'Défie tes amis en quiz',
                    ),
                    trailing: enAttente > 0
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: designAccent,
                            child: Text(
                              '$enAttente',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DefisScreen(monUid: uid),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            CarteDesign(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  StreamBuilder<int>(
                    stream: widget.social.nombreAbonnes(uid),
                    builder: (context, snap) => ListTile(
                      iconColor: designAccent,
                      textColor: designNoir,
                      leading: const Icon(Icons.group),
                      title: const Text('Abonnés'),
                      trailing: Text('${snap.data ?? 0}'),
                      onTap: () => _afficherListe(
                        'Abonnés',
                        widget.social.abonnesUids(uid),
                      ),
                    ),
                  ),
                  Divider(height: 1, color: designNoir.withValues(alpha: 0.1)),
                  StreamBuilder<int>(
                    stream: widget.social.nombreAbonnements(uid),
                    builder: (context, snap) => ListTile(
                      iconColor: designAccent,
                      textColor: designNoir,
                      leading: const Icon(Icons.person_add_alt),
                      title: const Text('Abonnements'),
                      trailing: Text('${snap.data ?? 0}'),
                      onTap: () => _afficherListe(
                        'Abonnements',
                        widget.social.abonnementsUids(uid),
                      ),
                    ),
                  ),
                  Divider(height: 1, color: designNoir.withValues(alpha: 0.1)),
                  ListTile(
                    iconColor: designAccent,
                    textColor: designNoir,
                    leading: const Icon(Icons.leaderboard),
                    title: const Text('Classement'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassementScreen(
                          monUid: uid,
                          social: widget.social,
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 1, color: designNoir.withValues(alpha: 0.1)),
                  ListTile(
                    iconColor: designAccent,
                    textColor: designNoir,
                    leading: const Icon(Icons.search),
                    title: const Text('Chercher quelqu\'un'),
                    onTap: _chercherEtSuivre,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            CarteDesign(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(
                  'Supprimer mon compte',
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: Text(
                  'Efface ton profil et tes abonnements, définitivement',
                  style: TextStyle(color: designNoir.withValues(alpha: 0.6)),
                ),
                onTap: _supprimerCompte,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _supprimerCompte() async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ton compte ?'),
        content: const Text(
          'Ton profil, tes abonnements et tes abonnés seront définitivement '
          'supprimés. Ta progression locale (vocabulaire, série, deniers) '
          'reste sur cet appareil. Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirme != true || !mounted) return;

    try {
      await widget.social.supprimerProfil(widget.utilisateur.uid);
      await widget.auth.supprimerCompte();
    } on AuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        await _reauthentifierEtSupprimer();
        return;
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _reauthentifierEtSupprimer() async {
    final controleur = TextEditingController();

    final motDePasse = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirme ton mot de passe'),
        content: TextField(
          controller: controleur,
          obscureText: true,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Mot de passe'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controleur.text),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );

    if (motDePasse == null || motDePasse.isEmpty || !mounted) return;

    try {
      await widget.auth.reauthentifierEtSupprimer(motDePasse);
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }
}

class _StatTuile extends StatelessWidget {
  final IconData icone;
  final Color couleur;
  final String valeur;
  final String label;

  const _StatTuile({
    required this.icone,
    required this.couleur,
    required this.valeur,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icone, color: couleur),
        const SizedBox(height: 4),
        Text(
          valeur,
          style: TextStyle(fontWeight: FontWeight.bold, color: designNoir),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: designNoir.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
