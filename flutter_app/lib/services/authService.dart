import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../services/apiService.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Constantes pour les schemes et URLs d'authentification
  static const String _callbackUrlScheme = 'myapp';

  // Initialiser le processus d'authentification Google

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

      // URL d'authentification
      final String authUrl = _apiService.getGoogleAuthUrl();
      debugPrint('Auth URL: $authUrl');

      // Lancer l'authentification
      final result = await FlutterWebAuth.authenticate(
        url: authUrl,
        callbackUrlScheme: _callbackUrlScheme,
        preferEphemeral: true,
      );

      debugPrint('Auth Result: $result');

      // Fermer le dialogue
      if (Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Valider l'authentification
      final bool success = await _apiService.validateAuthSuccess(result);
      return success;
    } catch (e) {
      debugPrint('Erreur d\'authentification Google: $e');

      // Fermer le dialogue en cas d'erreur
      if (Navigator.canPop(context)) {
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

  // Vérifier si l'utilisateur est déjà connecté
  Future<bool> isLoggedIn() async {
    // Vérifier d'abord avec l'API
    final bool isAuthServer = await _apiService.isAuthenticated();

    if (isAuthServer) {
      return true;
    }

    // Si le serveur dit non, vérifier localement
    final prefs = await SharedPreferences.getInstance();
    final bool isAuthLocal = prefs.getBool('isLoggedIn') ?? false;

    // Si contradiction, suivre le serveur
    if (isAuthLocal && !isAuthServer) {
      await prefs.setBool('isLoggedIn', false);
      return false;
    }

    return isAuthLocal;
  }

  // Déconnexion
  Future<bool> signOut() async {
    // Essayer d'abord de se déconnecter du serveur
    final bool success = await _apiService.logout();

    // Même si la déconnexion du serveur échoue, nettoyer localement
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    return success;
  }

  // Utilitaire pour limiter la longueur d'une chaîne
  int min(int a, int b) {
    return a < b ? a : b;
  }
}
