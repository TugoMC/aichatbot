import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final Dio _dio = Dio();
  final CookieJar _cookieJar = CookieJar();

  // URL mise à jour pour pointer vers votre backend déployé
  final String _baseUrl = kReleaseMode
      ? 'https://aichatbot-86xs.onrender.com/api'
      : 'https://aichatbot-86xs.onrender.com/api'; // Pour l'émulateur Android

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
    // Augmenter le timeout pour tenir compte des serveurs gratuits Render qui peuvent être lents
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  // Vérifier si l'utilisateur est authentifié
  Future<bool> isAuthenticated() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/auth/check',
        options: Options(
          extra: {'withCredentials': true},
          followRedirects: true,
        ),
      );

      if (response.statusCode == 200) {
        final bool isAuth = response.data['authenticated'] == true;
        // Synchroniser avec les SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', isAuth);
        return isAuth;
      }
      return false;
    } catch (e) {
      debugPrint('Erreur de vérification d\'authentification: $e');
      // En cas d'erreur réseau, utiliser la valeur en cache
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isLoggedIn') ?? false;
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
        // Stocker certaines informations utilisateur localement
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'userName', response.data['user']['displayName'] ?? '');
        await prefs.setString(
            'userEmail', response.data['user']['email'] ?? '');
        await prefs.setString(
            'userImage', response.data['user']['image'] ?? '');
        return response.data['user'];
      }

      // Si la requête a échoué mais que nous avons des données locales, les renvoyer
      final prefs = await SharedPreferences.getInstance();
      final String? name = prefs.getString('userName');
      final String? email = prefs.getString('userEmail');
      final String? image = prefs.getString('userImage');

      if (name != null && email != null) {
        return {
          'displayName': name,
          'email': email,
          'image': image ?? '',
        };
      }

      return null;
    } catch (e) {
      debugPrint('Erreur lors de la récupération de l\'utilisateur: $e');

      // En cas d'erreur, essayer d'utiliser les données locales
      final prefs = await SharedPreferences.getInstance();
      final String? name = prefs.getString('userName');
      final String? email = prefs.getString('userEmail');
      final String? image = prefs.getString('userImage');

      if (name != null && email != null) {
        return {
          'displayName': name,
          'email': email,
          'image': image ?? '',
        };
      }

      return null;
    }
  }

  // Initier le processus d'authentification Google
  String getGoogleAuthUrl() {
    return '$_baseUrl/auth/google?platform=mobile';
  }

  // Déconnexion
  Future<bool> logout() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/auth/logout?platform=mobile',
        options: Options(
          extra: {'withCredentials': true},
        ),
      );

      // Supprimer tous les cookies stockés
      _cookieJar.deleteAll();

      // Nettoyer les préférences locales
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('userName');
      await prefs.remove('userEmail');
      await prefs.remove('userImage');

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Erreur de déconnexion: $e');

      // Même en cas d'erreur, on nettoie les données locales
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('userName');
      await prefs.remove('userEmail');
      await prefs.remove('userImage');

      return false;
    }
  }

  // Valider l'authentification après redirection depuis OAuth
  Future<bool> validateAuthSuccess(String url) async {
    try {
      // Vérifier si l'URL contient un identifiant utilisateur
      Uri uri = Uri.parse(url);
      String? userId = uri.queryParameters['userId'];

      if (userId != null && userId.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Pour une sécurité supplémentaire, vérifier avec le serveur
        return await isAuthenticated();
      }
      return false;
    } catch (e) {
      debugPrint('Erreur de validation d\'authentification: $e');
      return false;
    }
  }
}
