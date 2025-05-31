import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Connexion
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Inscription
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Gestion des erreurs
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "Aucun utilisateur trouvé pour cet email";
      case 'wrong-password':
        return "Mot de passe incorrect";
      case 'email-already-in-use':
        return "Un compte existe déjà avec cet email";
      case 'weak-password':
        return "Le mot de passe est trop faible";
      default:
        return "Erreur d'authentification: ${e.message}";
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Écoute des changements d'état
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}