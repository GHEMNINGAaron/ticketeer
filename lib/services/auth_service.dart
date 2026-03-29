import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as app_models;

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream pour écouter les changements d'authentification
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  // Utilisateur actuel
  firebase_auth.User? get currentUser => _auth.currentUser;

  // Inscription avec email et mot de passe
  Future<app_models.User?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);

      final user = app_models.User(
        id: credential.user!.uid,
        name: name,
        email: email,
        role: role,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.id).set(user.toJson());

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An error occurred during sign up: $e';
    }
  }

  // Connexion avec email et mot de passe
  Future<app_models.User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (userDoc.exists) {
        return app_models.User.fromJson(userDoc.data()!);
      }

      return null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An error occurred during sign in: $e';
    }
  }

// Connexion avec GitHub
  Future<app_models.User?> signInWithGitHub() async {
    try {
      final githubProvider = firebase_auth.GithubAuthProvider();
      
      // Pour le web
      final credential = await _auth.signInWithPopup(githubProvider);

      // Vérifier si l'utilisateur existe dans Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (userDoc.exists) {
        // Utilisateur existant
        return app_models.User.fromJson(userDoc.data()!);
      } else {
        // Nouvel utilisateur GitHub - créer son profil
        final user = app_models.User(
          id: credential.user!.uid,
          name: credential.user!.displayName ?? 'GitHub User',
          email: credential.user!.email ?? '',
          role: 'Developer', // Rôle par défaut
          avatar: credential.user!.photoURL,
          createdAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(user.id).set(user.toJson());
        return user;
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An error occurred during GitHub sign in: $e';
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Réinitialisation du mot de passe
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Récupérer les données utilisateur depuis Firestore
  Future<app_models.User?> getUserData(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return app_models.User.fromJson(userDoc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Error fetching user data: $e';
    }
  }

  // Mettre à jour les données utilisateur
  Future<void> updateUserData(app_models.User user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (e) {
      throw 'Error updating user data: $e';
    }
  }

  // Gestion des erreurs Firebase
  String _handleAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in credentials.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}