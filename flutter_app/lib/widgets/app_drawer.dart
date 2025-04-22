import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ThemeProvider.dart';
import '../widgets/svg_icon.dart';

class AppDrawer extends StatefulWidget {
  final bool isDarkMode;
  final Color purpleColor;
  final Color textColor;
  final Color textColorSecondary;
  final Color bgColor;
  final Color borderColor;
  final Color cardBgColor;
  final Map<String, dynamic>? userData;
  final Function handleLogin;
  final Function handleLogout;

  const AppDrawer({
    Key? key,
    required this.isDarkMode,
    required this.purpleColor,
    required this.textColor,
    required this.textColorSecondary,
    required this.bgColor,
    required this.borderColor,
    required this.cardBgColor,
    required this.userData,
    required this.handleLogin,
    required this.handleLogout,
  }) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _currentLanguage = "Français";
  final List<Map<String, dynamic>> _languages = [
    {
      'name': 'Français',
      'code': 'fr',
      'flag': 'M0 0h512v512H0z;M0 0h170.7v512H0z;M341.3 0H512v512H341.3z',
      'colors': ['#fff', '#00267f', '#f31830'],
    },
    {
      'name': 'English',
      'code': 'en',
      'flag':
          'M0 0h512v512H0z;M512 0v64L322 256l190 187v69h-67L254 324 68 512H0v-68l186-187L0 74V0h62l192 188L440 0z;M184 324l11 34L42 512H0v-3l184-185zm124-12l54 8 150 147v45L308 312zM512 0L320 196l-4-44L466 0h46zM0 1l193 189-59-8L0 49V1z;M176 0v512h160V0H176zM0 176v160h512V176H0z;M0 208v96h512v-96H0zM208 0v512h96V0h-96z',
      'colors': ['#012169', '#FFF', '#C8102E', '#FFF', '#C8102E'],
    },
    {
      'name': 'Deutsch',
      'code': 'de',
      'flag': 'M0 341.3h512V512H0z;M0 0h512v170.7H0z;M0 170.7h512v170.6H0z',
      'colors': ['#ffce00', '#000', '#d00'],
    },
    {
      'name': 'Italiano',
      'code': 'it',
      'flag': 'M0 0h512v512H0z;M0 0h170.7v512H0z;M341.3 0H512v512H341.3z',
      'colors': ['#fff', '#009246', '#ce2b37'],
    },
  ];

  bool _languageMenuOpen = false;

  Widget _buildFlag(Map<String, dynamic> language) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        size: const Size(20, 20),
        painter: FlagPainter(
          paths: language['flag'].toString().split(';'),
          colors: (language['colors'] as List<String>)
              .map((color) =>
                  Color(int.parse(color.substring(1), radix: 16) + 0xFF000000))
              .toList(),
        ),
      ),
    );
  }

  // Widget helper pour créer des éléments de menu cohérents
  Widget _buildMenuItemContainer({
    required Widget child,
    bool isActive = false,
    bool isSpecial = false,
    EdgeInsetsGeometry margin = const EdgeInsets.only(bottom: 8),
  }) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: isActive
            ? (widget.isDarkMode
                ? const Color(0xFF1F2937)
                : const Color(0xFFF9FAFB))
            : widget.cardBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.borderColor,
          width: 1,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tabs = [
      {
        'name': 'Chat',
        'path': '/',
        'icon': Icons.chat,
        'isActive': true,
      },
      {
        'name': 'Historique',
        'path': '/history',
        'icon': Icons.history,
        'isActive': false,
      },
      {
        'name': 'Paramètres',
        'path': '/settings',
        'icon': Icons.settings,
        'isActive': false,
      },
    ];

    return Drawer(
      backgroundColor: widget.bgColor,
      child: Column(
        children: [
          // Menu Header
          Container(
            color: widget.purpleColor,
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scrollable content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // User Profile Card - Visible quand l'utilisateur est connecté
                if (widget.userData != null)
                  _buildMenuItemContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          widget.userData!['image'] != null
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(widget.userData!['image']),
                                  radius: 24,
                                )
                              : CircleAvatar(
                                  backgroundColor: widget.isDarkMode
                                      ? const Color(0xFF4C1D95)
                                      : const Color(0xFFDDD6FE),
                                  child: Text(
                                    widget.userData!['displayName']
                                            ?.substring(0, 1)
                                            .toUpperCase() ??
                                        'U',
                                    style: TextStyle(
                                      color: widget.isDarkMode
                                          ? const Color(0xFFDDD6FE)
                                          : const Color(0xFF4C1D95),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  radius: 24,
                                ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.userData!['displayName'] ?? 'User',
                                  style: TextStyle(
                                    color: widget.textColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Navigation Tabs
                ...tabs.map((tab) => _buildMenuItemContainer(
                      isActive: tab['isActive'] as bool,
                      child: ListTile(
                        leading: Icon(
                          tab['icon'] as IconData,
                          color: tab['isActive'] as bool
                              ? widget.purpleColor
                              : widget.textColorSecondary,
                        ),
                        title: Text(
                          tab['name'] as String,
                          style: TextStyle(
                            color: tab['isActive'] as bool
                                ? widget.purpleColor
                                : widget.textColor,
                            fontWeight: tab['isActive'] as bool
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          // Navigation logic
                        },
                      ),
                    )),

                const SizedBox(height: 16),

                // Theme Toggle
                _buildMenuItemContainer(
                  child: ListTile(
                    leading: Icon(
                      widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: widget.isDarkMode
                          ? const Color(0xFFFBBF24)
                          : widget.textColorSecondary,
                    ),
                    title: Text(
                      widget.isDarkMode ? 'Mode clair' : 'Mode sombre',
                      style: TextStyle(color: widget.textColor),
                    ),
                    onTap: () {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                      Navigator.pop(context);
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Language Selector - Header with selected language
                _buildMenuItemContainer(
                  child: ListTile(
                    leading: Text(
                      'Langue',
                      style: TextStyle(
                        color: widget.textColorSecondary,
                        fontSize: 14,
                      ),
                    ),
                    title: Row(
                      children: [
                        _buildFlag(_languages.firstWhere(
                            (lang) => lang['name'] == _currentLanguage)),
                        const SizedBox(width: 8),
                        Text(
                          _currentLanguage,
                          style: TextStyle(color: widget.textColor),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      _languageMenuOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: widget.textColorSecondary,
                    ),
                    onTap: () {
                      setState(() {
                        _languageMenuOpen = !_languageMenuOpen;
                      });
                    },
                  ),
                ),

                // Language Options - only visible when expanded
                if (_languageMenuOpen)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: widget.cardBgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: widget.borderColor,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: _languages
                          .map((language) => ListTile(
                                leading: _buildFlag(language),
                                title: Text(
                                  language['name'] as String,
                                  style: TextStyle(
                                    color: _currentLanguage == language['name']
                                        ? widget.purpleColor
                                        : widget.textColor,
                                  ),
                                ),
                                selected: _currentLanguage == language['name'],
                                selectedTileColor: widget.isDarkMode
                                    ? const Color(0xFF1F2937)
                                    : const Color(0xFFF9FAFB),
                                dense: true,
                                onTap: () {
                                  setState(() {
                                    _currentLanguage =
                                        language['name'] as String;
                                    _languageMenuOpen = false;
                                  });
                                },
                              ))
                          .toList(),
                    ),
                  ),

                const SizedBox(height: 24),

                // Actions supplémentaires et bouton de déconnexion
                if (widget.userData != null)
                  Column(
                    children: [
                      // Profile link
                      _buildMenuItemContainer(
                        child: ListTile(
                          leading: SvgIcon(
                            'M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z',
                            color: widget.textColorSecondary,
                          ),
                          title: Text(
                            'Profil',
                            style: TextStyle(color: widget.textColor),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            // Navigate to profile
                          },
                        ),
                      ),

                      // Logout button
                      _buildMenuItemContainer(
                        child: ListTile(
                          leading: const Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          title: const Text(
                            'Déconnexion',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          onTap: () => widget.handleLogout(),
                        ),
                      ),
                    ],
                  )
                else
                  // Login button
                  _buildMenuItemContainer(
                    child: InkWell(
                      onTap: () => widget.handleLogin(),
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
                                color: widget.textColor,
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
        ],
      ),
    );
  }
}

// Painter personnalisé pour dessiner les drapeaux
class FlagPainter extends CustomPainter {
  final List<String> paths;
  final List<Color> colors;

  FlagPainter({required this.paths, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < paths.length; i++) {
      final path = parseSvgPath(paths[i], size);
      final paint = Paint()
        ..color = i < colors.length ? colors[i] : Colors.grey
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, paint);
    }
  }

  Path parseSvgPath(String svgPath, Size size) {
    final path = Path();
    final parts = svgPath.split(' ');

    for (int i = 0; i < parts.length; i++) {
      final cmd = parts[i];

      if (cmd == 'M') {
        final x = double.parse(parts[i + 1]) * size.width / 512;
        final y = double.parse(parts[i + 2]) * size.height / 512;
        path.moveTo(x, y);
        i += 2;
      } else if (cmd == 'L') {
        final x = double.parse(parts[i + 1]) * size.width / 512;
        final y = double.parse(parts[i + 2]) * size.height / 512;
        path.lineTo(x, y);
        i += 2;
      } else if (cmd == 'H') {
        final x = double.parse(parts[i + 1]) * size.width / 512;
        path.lineTo(x, path.getBounds().top);
        i += 1;
      } else if (cmd == 'V') {
        final y = double.parse(parts[i + 1]) * size.height / 512;
        path.lineTo(path.getBounds().left, y);
        i += 1;
      } else if (cmd == 'z' || cmd == 'Z') {
        path.close();
      }
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
