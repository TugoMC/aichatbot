import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ThemeProvider.dart';
import '../services/authService.dart';
import '../services/apiService.dart';
import '../widgets/app_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Contrôleurs pour les champs de texte
  final TextEditingController _displayNameController =
      TextEditingController(text: 'Utilisateur');
  final TextEditingController _emailController =
      TextEditingController(text: 'user@example.com');

  // État des champs d'édition
  bool _isEditingName = false;
  bool _isEditingEmail = false;
  bool _isLoading = false;

  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _displayNameController.text = _userData['displayName'] ?? 'Utilisateur';
    _emailController.text = _userData['email'] ?? 'user@example.com';
    _checkUserStatus();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    super.dispose();
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
            'createdAt': DateTime.now(),
            'lastLogin': DateTime.now(),
          };

          if (mounted) {
            setState(() {
              _userData = localUserData;
            });
          }
        } else if (user != null && mounted) {
          setState(() {
            _userData = user;
            _displayNameController.text = user['displayName'] ?? 'Utilisateur';
            _emailController.text = user['email'] ?? 'user@example.com';
          });
        }
      }
    } catch (e) {
      debugPrint('Error checking user status: $e');
    }
  }

  Future<void> _handleLogout() async {
    final scaffold = ScaffoldMessenger.of(context);

    // Indiquer que la déconnexion est en cours
    scaffold.showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            SizedBox(width: 16),
            Text('Déconnexion en cours...'),
          ],
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Color(0xFF6D28D9),
      ),
    );

    // Mettre à jour l'UI immédiatement pour une impression de rapidité
    setState(() {
      _isLoading = true;
    });

    // Lancer les requêtes de déconnexion en parallèle
    await Future.wait([
      _apiService.logout(),
      _authService.signOut(),
    ]);

    setState(() {
      _userData = {
        'displayName': 'Utilisateur',
        'email': 'user@example.com',
        'image': null,
        'createdAt': DateTime.now().subtract(const Duration(days: 90)),
        'lastLogin': DateTime.now().subtract(const Duration(hours: 2)),
      };
      _isLoading = false;
    });

    // Cacher le SnackBar de chargement
    scaffold.hideCurrentSnackBar();

    // Navigation immédiate
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _saveProfile() {
    setState(() {
      _userData['displayName'] = _displayNameController.text;
      _userData['email'] = _emailController.text;
      _isEditingName = false;
      _isEditingEmail = false;
    });

    // Afficher une confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil mis à jour avec succès!'),
        backgroundColor: Color(0xFF6D28D9),
        behavior: SnackBarBehavior.floating,
      ),
    );
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

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
        title: Text(
          'Profil',
          style: TextStyle(
            color: purpleColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: textColor),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
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
        userData: _userData.isNotEmpty ? _userData : null,
        handleLogin: _handleLogin,
        handleLogout: _handleLogout,
        currentRoute: '/profile',
      ),
      body: _userData.isNotEmpty
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo de profil et nom
                  Center(
                    child: Column(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: isDarkMode
                              ? const Color(0xFF4C1D95)
                              : const Color(0xFFDDD6FE),
                          child: Text(
                            _userData['displayName']
                                    ?.substring(0, 1)
                                    .toUpperCase() ??
                                'U',
                            style: TextStyle(
                              color: isDarkMode
                                  ? const Color(0xFFDDD6FE)
                                  : const Color(0xFF4C1D95),
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Bouton de changement de photo
                        TextButton.icon(
                          onPressed: () {
                            // Logique pour changer la photo
                          },
                          icon: Icon(Icons.camera_alt,
                              color: purpleColor, size: 16),
                          label: Text(
                            'Changer la photo',
                            style: TextStyle(
                              color: purpleColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Informations personnelles
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      'Informations personnelles',
                      style: TextStyle(
                        color: textColorSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Nom d'utilisateur
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Nom d\'utilisateur',
                              style: TextStyle(
                                color: textColorSecondary,
                                fontSize: 13,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                _isEditingName ? Icons.check : Icons.edit,
                                color: purpleColor,
                                size: 20,
                              ),
                              onPressed: () {
                                if (_isEditingName) {
                                  _saveProfile();
                                } else {
                                  setState(() {
                                    _isEditingName = true;
                                  });
                                }
                              },
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _isEditingName
                            ? TextField(
                                controller: _displayNameController,
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: borderColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: purpleColor),
                                  ),
                                ),
                              )
                            : Text(
                                _userData['displayName'] ?? 'Utilisateur',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ],
                    ),
                  ),

                  // Email
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Email',
                              style: TextStyle(
                                color: textColorSecondary,
                                fontSize: 13,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                _isEditingEmail ? Icons.check : Icons.edit,
                                color: purpleColor,
                                size: 20,
                              ),
                              onPressed: () {
                                if (_isEditingEmail) {
                                  _saveProfile();
                                } else {
                                  setState(() {
                                    _isEditingEmail = true;
                                  });
                                }
                              },
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _isEditingEmail
                            ? TextField(
                                controller: _emailController,
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: borderColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: purpleColor),
                                  ),
                                ),
                              )
                            : Text(
                                _userData['email'] ?? 'user@example.com',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                ),
                              ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Informations du compte
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      'Informations du compte',
                      style: TextStyle(
                        color: textColorSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Date de création
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date de création',
                          style: TextStyle(
                            color: textColorSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDate(_userData['createdAt']),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Dernière connexion
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dernière connexion',
                          style: TextStyle(
                            color: textColorSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDate(_userData['lastLogin']),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Boutons d'action
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Modifier le mot de passe
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: purpleColor.withOpacity(0.1),
                            child: Icon(
                              Icons.lock_outline,
                              color: purpleColor,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            'Modifier le mot de passe',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: textColorSecondary,
                          ),
                          onTap: () {
                            // Navigation vers la page de changement de mot de passe
                          },
                        ),

                        // Suppression du compte
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                          title: const Text(
                            'Supprimer mon compte',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.red,
                          ),
                          onTap: () {
                            // Afficher une boîte de dialogue de confirmation
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Supprimer votre compte?'),
                                content: const Text(
                                  'Cette action est irréversible. Toutes vos données seront définitivement supprimées.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Annuler',
                                      style:
                                          TextStyle(color: textColorSecondary),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Logique de suppression de compte
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Supprimer'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 64,
                    color: textColorSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Connectez-vous pour voir votre profil',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Bouton de connexion copié de AppDrawer
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: borderColor,
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () => _handleLogin(),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/google_logo.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Se connecter avec Google',
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
