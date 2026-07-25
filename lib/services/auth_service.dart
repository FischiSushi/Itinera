import 'dart:async' show unawaited;

import 'package:firebase_auth/firebase_auth.dart';

// Fine enveloppe autour de FirebaseAuth : centralise la gestion des erreurs
// et traduit les messages en français pour l'UI (CompteScreen).

class AuthException implements Exception {
  final String message;
  final String? code;
  const AuthException(this.message, {this.code});

  @override
  String toString() => message;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get utilisateurActuel => _auth.currentUser;

  Stream<User?> get changementsUtilisateur => _auth.authStateChanges();

  Future<User> inscrire({
    required String email,
    required String motDePasse,
  }) async {
    try {
      final identifiants = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: motDePasse,
      );

      unawaited(identifiants.user?.sendEmailVerification());

      return identifiants.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageErreur(e), code: e.code);
    }
  }

  Future<User> connecter({
    required String email,
    required String motDePasse,
  }) async {
    try {
      final identifiants = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: motDePasse,
      );
      return identifiants.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageErreur(e), code: e.code);
    }
  }

  Future<void> deconnecter() => _auth.signOut();

  // Lève AuthException(code: 'requires-recent-login') si Firebase exige une
  // reconnexion récente avant de supprimer le compte — l'appelant doit alors
  // proposer reauthentifierEtSupprimer() avec le mot de passe.
  Future<void> supprimerCompte() async {
    final utilisateur = _auth.currentUser;
    if (utilisateur == null) return;

    try {
      await utilisateur.delete();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageErreur(e), code: e.code);
    }
  }

  Future<void> reauthentifierEtSupprimer(String motDePasse) async {
    final utilisateur = _auth.currentUser;
    if (utilisateur == null || utilisateur.email == null) return;

    try {
      final identifiants = EmailAuthProvider.credential(
        email: utilisateur.email!,
        password: motDePasse,
      );
      await utilisateur.reauthenticateWithCredential(identifiants);
      await utilisateur.delete();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageErreur(e), code: e.code);
    }
  }

  Future<void> reinitialiserMotDePasse(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageErreur(e), code: e.code);
    }
  }

  String _messageErreur(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Adresse e-mail invalide.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'user-not-found':
        return 'Aucun compte ne correspond à cette adresse.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Mot de passe incorrect.';
      case 'email-already-in-use':
        return 'Un compte existe déjà avec cette adresse.';
      case 'weak-password':
        return 'Le mot de passe est trop faible (6 caractères minimum).';
      case 'network-request-failed':
        return 'Pas de connexion internet.';
      case 'requires-recent-login':
        return 'Reconnexion nécessaire pour confirmer cette action.';
      default:
        return 'Une erreur est survenue (${e.code}).';
    }
  }
}
