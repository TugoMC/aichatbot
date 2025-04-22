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
    try {
      // Afficher un dialogue de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Connexion en cours...'),
                ],
              ),
            ),
          );
        },
      );

      // Démarrer le processus de connexion Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Si l'utilisateur annule, retourner false
      if (googleUser == null) {
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.of(context, rootNavigator: true).pop();
        }
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

      // Utiliser ce token pour authentifier avec notre backend
      if (idToken != null) {
        _apiService.setAuthToken(idToken);

        // Synchroniser avec le backend
        await _apiService.syncUserWithBackend();
      }

      // Fermer le dialogue
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Stocker l'état de connexion localement
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      return true;
    } catch (e) {
      debugPrint('Erreur d\'authentification Google: $e');

      // Fermer le dialogue en cas d'erreur
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Montrer l'erreur
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Erreur: ${e.toString().substring(0, min(e.toString().length, 100))}'),
            backgroundColor: Colors.red,
          ),
        );
      }

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
