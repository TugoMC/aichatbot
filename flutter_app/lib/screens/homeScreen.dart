import 'package:flutter/material.dart';
import 'package:flutter_app/providers/ThemeProvider.dart';

import 'package:provider/provider.dart';

import '../services/apiService.dart';
import '../services/authService.dart';
import '../widgets/app_drawer.dart';
import '../widgets/chat_input.dart';
import '../widgets/service_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  bool _isFocused = false;
  String _selectedCategory = 'General';
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
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 768; // md breakpoint in Tailwind

    // Service Cards as in React
    final List<Map<String, String>> serviceCards = [
      {
        'title': 'Sales Strategies',
        'description':
            'Get tailored advice on increasing company visibility and driving sales.',
        'category': 'Sales'
      },
      {
        'title': 'Negotiation Tactics',
        'description':
            'Learn expert negotiation tips to close deals efficiently.',
        'category': 'Negotiation'
      },
      {
        'title': 'Marketing Insights',
        'description':
            'Discover the best marketing strategies to showcase your products.',
        'category': 'Marketing'
      },
      {
        'title': 'General Support',
        'description':
            'Need help with something else? Ask here and we\'ll guide you.',
        'category': 'General'
      }
    ];

    // Tailwind colors reproduced
    final Color purpleColor =
        isDarkMode ? const Color(0xFF9F7AEA) : const Color(0xFF5521B5);
    final Color bgColor = isDarkMode ? const Color(0xFF111827) : Colors.white;
    final Color cardBgColor =
        isDarkMode ? const Color(0xFF1F2937) : Colors.white;
    final Color textColor =
        isDarkMode ? const Color(0xFFF9FAFB) : const Color(0xFF1F2937);
    final Color textColorSecondary =
        isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF4B5563);
    final Color borderColor =
        isDarkMode ? const Color(0xFF374151) : const Color(0xFFE5E7EB);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
        title: Text(
          'Negotio',
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
      ),
      body: Column(
        children: [
          // Main content - vertically centered
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 768),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main title
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'How can we ',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              TextSpan(
                                text: 'assist',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: purpleColor,
                                ),
                              ),
                              TextSpan(
                                text: ' you today?',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Service Cards - tablet and desktop only
                      if (!isMobile)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 48),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 24,
                            childAspectRatio: 1.5,
                            children: serviceCards
                                .where((card) =>
                                    _selectedCategory == 'General' ||
                                    card['category'] == _selectedCategory)
                                .map((card) => ServiceCard(
                                      card: card,
                                      cardBgColor: cardBgColor,
                                      textColor: textColor,
                                      textColorSecondary: textColorSecondary,
                                      borderColor: borderColor,
                                    ))
                                .toList(),
                          ),
                        ),

                      // Input field for desktop/tablet
                      if (!isMobile)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: ChatInput(
                            messageController: _messageController,
                            isFocused: _isFocused,
                            onFocusChanged: (value) {
                              setState(() {
                                _isFocused = value;
                              });
                            },
                            cardBgColor: cardBgColor,
                            textColor: textColor,
                            textColorSecondary: textColorSecondary,
                            borderColor: borderColor,
                            purpleColor: purpleColor,
                            onSend: () {
                              // Message send logic
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Fixed input field at bottom for mobile
          if (isMobile)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ChatInput(
                messageController: _messageController,
                isFocused: _isFocused,
                onFocusChanged: (value) {
                  setState(() {
                    _isFocused = value;
                  });
                },
                cardBgColor: cardBgColor,
                textColor: textColor,
                textColorSecondary: textColorSecondary,
                borderColor: borderColor,
                purpleColor: purpleColor,
                onSend: () {
                  // Message send logic
                },
              ),
            ),

          // Space to prevent content from being hidden by fixed input on mobile
          if (isMobile) const SizedBox(height: 24),
        ],
      ),
    );
  }
}
