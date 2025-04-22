import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ThemeProvider.dart';
import '../services/apiService.dart';
import '../services/authService.dart';
import '../widgets/app_drawer.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isFocused = false;
  bool _isLoading = false;

  // Services
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Données utilisateur
  Map<String, dynamic>? userData;

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

  // Données d'historique regroupées par date
  final Map<String, List<Map<String, dynamic>>> _historyData = {
    "Aujourd'hui": [
      {
        'id': 1,
        'title': "Erreur de configuration Tailwind",
        'icon': Icons.chat_bubble_outline,
      },
      {
        'id': 2,
        'title': "SVG Logo Google",
        'icon': Icons.chat_bubble_outline,
      },
      {
        'id': 3,
        'title': "AI Chatbot MERN Optimisé",
        'icon': Icons.chat_bubble_outline,
      }
    ],
    "Hier": [
      {
        'id': 4,
        'title': "Perdur les cookies de session",
        'icon': Icons.chat_bubble_outline,
      },
      {
        'id': 5,
        'title': "MongoDB Atlas IP Whitelist",
        'icon': Icons.chat_bubble_outline,
      },
      {
        'id': 6,
        'title': "Erreur commande build",
        'icon': Icons.chat_bubble_outline,
      }
    ]
  };

  Map<String, List<Map<String, dynamic>>> _filterItems(String searchTerm) {
    if (searchTerm.isEmpty) {
      return _historyData;
    }

    final result = <String, List<Map<String, dynamic>>>{};

    _historyData.forEach((date, items) {
      final filteredItems = items
          .where((item) => item['title']
              .toString()
              .toLowerCase()
              .contains(searchTerm.toLowerCase()))
          .toList();

      if (filteredItems.isNotEmpty) {
        result[date] = filteredItems;
      }
    });

    return result;
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

    // Filtrer les éléments en fonction de la recherche
    final filteredData = _filterItems(_searchController.text);

    // Vérifier si l'utilisateur est connecté
    final bool isUserLoggedIn = userData != null;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
        title: Text(
          'Historique',
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
        userData: userData,
        handleLogin: _handleLogin,
        handleLogout: _handleLogout,
        currentRoute: '/history',
      ),
      body: isUserLoggedIn
          ? Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  // Barre de recherche
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isFocused ? purpleColor : borderColor,
                          width: 1,
                        ),
                        boxShadow: _isFocused
                            ? [
                                BoxShadow(
                                  color: purpleColor.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          setState(() {
                            _isFocused = hasFocus;
                          });
                        },
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: textColor),
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'Rechercher des conversations...',
                            hintStyle: TextStyle(color: textColorSecondary),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: textColorSecondary,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: textColorSecondary,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                      });
                                    },
                                  )
                                : null,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Liste de l'historique
                  Expanded(
                    child: filteredData.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredData.length,
                            itemBuilder: (context, sectionIndex) {
                              final date =
                                  filteredData.keys.elementAt(sectionIndex);
                              final items = filteredData[date]!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // En-tête de la section (date)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 8, bottom: 4),
                                    child: Text(
                                      date,
                                      style: TextStyle(
                                        color: textColorSecondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  // Éléments de la section
                                  ...items
                                      .map((item) => _buildHistoryItem(
                                            item: item,
                                            textColor: textColor,
                                            borderColor: borderColor,
                                            cardBgColor: cardBgColor,
                                            purpleColor: purpleColor,
                                          ))
                                      .toList(),
                                ],
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 48,
                                  color: textColorSecondary,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Aucun résultat trouvé',
                                  style: TextStyle(
                                    color: textColorSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
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
                    Icons.history,
                    size: 64,
                    color: textColorSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Connectez-vous pour voir votre historique',
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

  Widget _buildHistoryItem({
    required Map<String, dynamic> item,
    required Color textColor,
    required Color borderColor,
    required Color cardBgColor,
    required Color purpleColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () {
          // Navigation vers la conversation sélectionnée
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: cardBgColor,
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
                backgroundColor: purpleColor,
                radius: 16,
                child: Icon(
                  item['icon'] as IconData,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),

              // Titre de la conversation
              Expanded(
                child: Text(
                  item['title'] as String,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
