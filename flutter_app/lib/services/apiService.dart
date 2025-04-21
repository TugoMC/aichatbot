import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio();
  final CookieJar _cookieJar = CookieJar();
  final String _baseUrl =
      'http://10.0.2.2:5000/api'; // Pour l'émulateur Android

  ApiService() {
    _dio.interceptors.add(CookieManager(_cookieJar));
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
    // Activer la gestion des cookies et le suivi des redirections
    _dio.options.followRedirects = true;
    _dio.options.maxRedirects = 5;
    _dio.options.receiveDataWhenStatusError = true;
    _dio.options.validateStatus = (status) {
      return status != null && status < 500;
    };
  }

  // Vérifier si l'utilisateur est authentifié
  Future<bool> isAuthenticated() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/auth/check',
        options: Options(
          extra: {'withCredentials': true},
        ),
      );

      if (response.statusCode == 200) {
        return response.data['authenticated'] == true;
      }
      return false;
    } catch (e) {
      print('Erreur de vérification d\'authentification: $e');
      return false;
    }
  }

  // Récupérer les informations de l'utilisateur
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/auth/user',
        options: Options(
          extra: {'withCredentials': true},
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['user'];
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur: $e');
      return null;
    }
  }

  // Initier le processus d'authentification Google
  String getGoogleAuthUrl() {
    return '$_baseUrl/auth/google';
  }

  // Déconnexion
  Future<bool> logout() async {
    try {
      await _dio.get(
        '$_baseUrl/auth/logout',
        options: Options(
          extra: {'withCredentials': true},
        ),
      );

      // Supprimer tous les cookies stockés
      _cookieJar.deleteAll();

      // Nettoyer les préférences locales
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');

      return true;
    } catch (e) {
      print('Erreur de déconnexion: $e');
      return false;
    }
  }

  // Stocker les cookies de session après une authentification réussie
  Future<void> storeSessionCookies(String cookieHeader) async {
    if (cookieHeader.isNotEmpty) {
      // Traitement manuel des cookies si nécessaire
      // Pour les applications réelles, il faudrait analyser le header et stocker les cookies
      print('Cookies reçus: $cookieHeader');
    }
  }
}
