import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  final String _themeKey = 'isDarkMode';

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData {
    return _isDarkMode ? _buildDarkTheme() : _buildLightTheme();
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF5521B5),
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF5521B5),
        secondary: Color(0xFF4A1D96),
        surface: Colors.white,
        background: Colors.white,
        error: Colors.red,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF1F2937)),
        bodyMedium: TextStyle(color: Color(0xFF4B5563)),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF9F7AEA),
      scaffoldBackgroundColor: const Color(0xFF111827),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF9F7AEA),
        secondary: Color(0xFF805AD5),
        surface: Color(0xFF1F2937),
        background: Color(0xFF111827),
        error: Colors.red,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFF9FAFB)),
        bodyMedium: TextStyle(color: Color(0xFFD1D5DB)),
      ),
    );
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
  }
}
