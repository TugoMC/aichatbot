import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/apiService.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ApiService _apiService = ApiService();

  // Se connecter avec Google
  Future<bool> signInWithGoogle(BuildContext context) async {
    // Montrer un indicateur de chargement non-bloquant
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            SizedBox(width: 16),
            Text('Connexion en cours...'),
          ],
        ),
        duration: Duration(seconds: 5),
        backgroundColor: Color(0xFF6D28D9),
      ),
    );

    try {
      // Démarrer le processus de connexion Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Si l'utilisateur annule, retourner false
      if (googleUser == null) {
        scaffold.hideCurrentSnackBar();
        return false;
      }

      // Obtenir les détails d'authentification du compte Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Créer des identifiants Firebase avec le token
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Connecter l'utilisateur avec Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Obtenir le token Firebase pour l'API
      final String? idToken = await userCredential.user?.getIdToken();

      // Utiliser ce token pour l'API
      if (idToken != null) {
        _apiService.setAuthToken(idToken);

        // Ne pas attendre la synchronisation complète pour améliorer la vitesse perçue
        _apiService.syncUserWithBackend().then((_) {
          // Notification silencieuse quand la synchro est terminée
        });
      }

      // Stocker l'état de connexion localement
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Cacher le SnackBar de chargement
      scaffold.hideCurrentSnackBar();
      return true;
    } catch (e) {
      scaffold.hideCurrentSnackBar();
      // Message d'erreur plus court et plus clair
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Erreur de connexion'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  // Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      // Rafraîchir le token si nécessaire et mettre à jour l'API
      final String? idToken = await currentUser.getIdToken(true);
      if (idToken != null) {
        _apiService.setAuthToken(idToken);
      }
      return true;
    }

    // En dernier recours, vérifier localement
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Déconnexion
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();

      // Supprimer le token de l'API
      _apiService.clearAuthToken();

      // Nettoyer les préférences locales
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('userName');
      await prefs.remove('userEmail');
      await prefs.remove('userImage');

      return true;
    } catch (e) {
      debugPrint('Erreur lors de la déconnexion: $e');
      return false;
    }
  }

  // Récupérer l'utilisateur actuel de Firebase
  User? getCurrentFirebaseUser() {
    return _auth.currentUser;
  }

  // Utilitaire pour limiter la longueur d'une chaîne
  int min(int a, int b) {
    return a < b ? a : b;
  }
}
