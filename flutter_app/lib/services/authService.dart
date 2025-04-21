import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AuthService {
  final String _backendUrl =
      'http://10.0.2.2:5000'; // Ajustez selon votre configuration

  // Initialiser le processus d'authentification Google
  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      // Méthode 1: Utiliser WebView pour l'OAuth complet
      final result = await FlutterWebAuth.authenticate(
        url: '$_backendUrl/api/auth/google',
        callbackUrlScheme:
            'myapp', // Doit correspondre à votre configuration d'URL de redirection
      );

      // Vérifiez que le résultat contient une URL de succès
      if (result.contains('success')) {
        // Stockez l'état d'authentification
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        return true;
      }
      return false;
    } catch (e) {
      print('Erreur d\'authentification Google: $e');
      return false;
    }
  }

  // Vérifier si l'utilisateur est déjà connecté
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Déconnexion
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }
}
