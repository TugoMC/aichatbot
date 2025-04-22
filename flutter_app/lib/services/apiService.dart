import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio();
  String? _authToken;

  // URL de base de l'API
  final String _baseUrl = kReleaseMode
      ? 'https://aichatbot-86xs.onrender.com/api'
      : 'https://aichatbot-86xs.onrender.com/api';

  ApiService() {
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.followRedirects = true;
    _dio.options.maxRedirects = 5;
    _dio.options.receiveDataWhenStatusError = true;
    _dio.options.validateStatus = (status) {
      return status != null && status < 500;
    };
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  // Définir le token d'authentification
  void setAuthToken(String token) {
    _authToken = token;
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Effacer le token d'authentification
  void clearAuthToken() {
    _authToken = null;
    _dio.options.headers.remove('Authorization');
  }

  // Vérifier si l'utilisateur est authentifié
  Future<bool> isAuthenticated() async {
    try {
      if (_authToken == null) {
        return false;
      }

      final response = await _dio.get(
        '$_baseUrl/auth/check',
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

  // Synchroniser l'utilisateur avec le backend
  Future<bool> syncUserWithBackend() async {
    try {
      if (_authToken == null) {
        return false;
      }

      final response = await _dio.get('$_baseUrl/auth/user');

      if (response.statusCode == 200 && response.data['success'] == true) {
        // Stocker les informations utilisateur localement
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'userName', response.data['user']['displayName'] ?? '');
        await prefs.setString(
            'userEmail', response.data['user']['email'] ?? '');
        await prefs.setString(
            'userImage', response.data['user']['image'] ?? '');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Erreur de synchronisation avec le backend: $e');
      return false;
    }
  }

  // Récupérer les informations de l'utilisateur
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      if (_authToken == null) {
        // Si aucun token, essayer d'utiliser les données locales
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

      final response = await _dio.get('$_baseUrl/auth/user');

      if (response.statusCode == 200 && response.data['success'] == true) {
        // Stocker les informations utilisateur localement
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'userName', response.data['user']['displayName'] ?? '');
        await prefs.setString(
            'userEmail', response.data['user']['email'] ?? '');
        await prefs.setString(
            'userImage', response.data['user']['image'] ?? '');
        return response.data['user'];
      }

      // Si la requête échoue mais que nous avons des données locales
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

  // Déconnexion
  Future<bool> logout() async {
    try {
      final response = await _dio.get('$_baseUrl/auth/logout');

      // Nettoyer le token
      clearAuthToken();

      // Nettoyer les préférences locales
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('userName');
      await prefs.remove('userEmail');
      await prefs.remove('userImage');

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Erreur de déconnexion: $e');

      // Même en cas d'erreur, nettoyer les données locales
      clearAuthToken();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('userName');
      await prefs.remove('userEmail');
      await prefs.remove('userImage');

      return false;
    }
  }
}
