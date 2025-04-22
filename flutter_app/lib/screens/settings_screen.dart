import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ThemeProvider.dart';
import '../widgets/app_drawer.dart';
import '../services/apiService.dart';
import '../services/authService.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = "Français";
  final List<Map<String, String>> _languages = [
    {'name': 'Français', 'code': 'fr'},
    {'name': 'English', 'code': 'en'},
    {'name': 'Deutsch', 'code': 'de'},
    {'name': 'Italiano', 'code': 'it'},
  ];

  final Map<String, bool> _notifications = {
    'email': true,
    'app': true,
    'summary': false,
  };

  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  Map<String, dynamic>? userData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    try {
      // First check Firebase directly
      final firebaseUser = _authService.getCurrentFirebaseUser();
      final isAuth =
          firebaseUser != null || await _apiService.isAuthenticated();

      if (isAuth) {
        // Try to get user from API first
        final user = await _apiService.getCurrentUser();

        // If no user from API but Firebase has a user, create minimal userData
        if (user == null && firebaseUser != null) {
          final localUserData = {
            'displayName': firebaseUser.displayName ?? 'User',
            'email': firebaseUser.email ?? '',
            'image': firebaseUser.photoURL ?? '',
          };

          if (mounted) {
            setState(() {
              userData = localUserData;
            });
          }
        } else if (user != null && mounted) {
          setState(() {
            userData = user;
          });
        }

        // Print debug info
        debugPrint('User authentication status: $isAuth');
        debugPrint('User data: $userData');
      }
    } catch (e) {
      debugPrint('Error checking user status: $e');
    }
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoading = true;
    });

    await _apiService.logout();
    await _authService.signOut();

    setState(() {
      userData = null;
      _isLoading = false;
    });

    Navigator.of(context).pop(); // Close drawer
  }

  Future<void> _handleLogin() async {
    Navigator.of(context).pop(); // Close drawer

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _authService.signInWithGoogle(context);

      if (success) {
        await _checkUserStatus();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Couleurs basées sur le thème actuel
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final textColorSecondary = isDarkMode ? Colors.white70 : Colors.black54;
    final bgColor = isDarkMode ? const Color(0xFF111827) : Colors.white;
    final borderColor =
        isDarkMode ? const Color(0xFF374151) : const Color(0xFFE5E7EB);
    final cardBgColor = isDarkMode ? const Color(0xFF1F2937) : Colors.white;
    final purpleColor =
        isDarkMode ? const Color(0xFF9F7AEA) : const Color(0xFF5521B5);

    // Simuler si l'utilisateur est connecté (à remplacer par votre logique réelle)
    final bool isLoggedIn = true;

    if (!isLoggedIn) {
      return _buildNotLoggedInScreen(bgColor, textColorSecondary);
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
        title: Text(
          'Paramètres',
          style: TextStyle(
            color: purpleColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: textColorSecondary,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      drawer: AppDrawer(
        isDarkMode: isDarkMode,
        purpleColor: purpleColor,
        textColor: textColor,
        textColorSecondary: textColorSecondary,
        bgColor: bgColor,
        borderColor: borderColor,
        cardBgColor: cardBgColor,
        userData: userData,
        handleLogin: _handleLogin,
        handleLogout: _handleLogout,
        currentRoute: '/settings',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Affichage
            _buildSectionHeader("Affichage", textColorSecondary),

            // Option Thème
            _buildSettingItem(
              icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
              title: "Thème",
              bgColor: cardBgColor,
              borderColor: borderColor,
              textColor: textColor,
              iconBgColor: purpleColor,
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
                activeColor: purpleColor,
              ),
            ),

            // Option Langue
            _buildSettingItem(
              icon: Icons.translate,
              title: "Langue",
              bgColor: cardBgColor,
              borderColor: borderColor,
              textColor: textColor,
              iconBgColor: purpleColor,
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedLanguage = newValue;
                    });
                  }
                },
                items: _languages.map<DropdownMenuItem<String>>(
                    (Map<String, String> language) {
                  return DropdownMenuItem<String>(
                    value: language['name'],
                    child: Text(
                      language['name']!,
                      style: TextStyle(
                        color: textColor,
                      ),
                    ),
                  );
                }).toList(),
                style: TextStyle(color: textColor),
                icon: Icon(Icons.arrow_drop_down, color: textColorSecondary),
                underline: Container(),
                dropdownColor: cardBgColor,
              ),
            ),

            const SizedBox(height: 20),

            // Section Notifications
            _buildSectionHeader("Notifications", textColorSecondary),

            // Option Email
            _buildSettingItem(
              icon: Icons.email_outlined,
              title: "Notifications par email",
              subtitle: "Recevoir des mises à jour par email",
              bgColor: cardBgColor,
              borderColor: borderColor,
              textColor: textColor,
              textColorSecondary: textColorSecondary,
              iconBgColor: purpleColor,
              trailing: Switch(
                value: _notifications['email'] ?? false,
                onChanged: (value) {
                  setState(() {
                    _notifications['email'] = value;
                  });
                },
                activeColor: purpleColor,
              ),
            ),

            // Option App
            _buildSettingItem(
              icon: Icons.notifications_none,
              title: "Notifications dans l'application",
              subtitle: "Afficher des notifications dans l'application",
              bgColor: cardBgColor,
              borderColor: borderColor,
              textColor: textColor,
              textColorSecondary: textColorSecondary,
              iconBgColor: purpleColor,
              trailing: Switch(
                value: _notifications['app'] ?? false,
                onChanged: (value) {
                  setState(() {
                    _notifications['app'] = value;
                  });
                },
                activeColor: purpleColor,
              ),
            ),

            // Option Summary
            _buildSettingItem(
              icon: Icons.description_outlined,
              title: "Rapports hebdomadaires",
              subtitle: "Recevoir un résumé hebdomadaire des activités",
              bgColor: cardBgColor,
              borderColor: borderColor,
              textColor: textColor,
              textColorSecondary: textColorSecondary,
              iconBgColor: purpleColor,
              trailing: Switch(
                value: _notifications['summary'] ?? false,
                onChanged: (value) {
                  setState(() {
                    _notifications['summary'] = value;
                  });
                },
                activeColor: purpleColor,
              ),
            ),

            // Bouton Sauvegarder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purpleColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Sauvegarder les modifications",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotLoggedInScreen(Color bgColor, Color textColorSecondary) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 64,
              color: textColorSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              "Veuillez vous connecter pour accéder aux paramètres",
              style: TextStyle(
                color: textColorSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color textColorSecondary) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: textColorSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
    Color? textColorSecondary,
    required Color iconBgColor,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Icône avec fond rond
                CircleAvatar(
                  backgroundColor: iconBgColor,
                  radius: 16,
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),

                // Titre et sous-titre (optionnel)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: textColorSecondary ??
                                textColor.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Widget trailing (switch, dropdown, etc.)
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveSettings() {
    // Afficher une confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Paramètres sauvegardés avec succès!'),
        backgroundColor: Color(0xFF6D28D9),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
