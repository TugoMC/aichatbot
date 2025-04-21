import 'package:flutter/material.dart';
import '../services/apiService.dart';
import '../services/authService.dart';
import 'loginScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  Map<String, dynamic>? userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    final isAuth = await _apiService.isAuthenticated();
    if (isAuth) {
      final user = await _apiService.getCurrentUser();
      setState(() {
        userData = user;
        _isLoading = false;
      });
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoading = true;
    });

    await _apiService.logout();
    await _authService.signOut();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Aucune donnée utilisateur disponible'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadUserData,
                        child: const Text('Réessayer'),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userData!['image'] ?? ''),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userData!['displayName'] ?? 'Utilisateur',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userData!['email'] ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Vous êtes connecté avec succès !',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
    );
  }
}
