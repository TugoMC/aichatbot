import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/ThemeProvider.dart';
import 'screens/homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAGJIWcngpXVDaVMTkdzXDeVHYfcje6Q3w",
      appId: "1:401898447850:android:32b3c57aa335ec6d0b4893",
      messagingSenderId: "401898447850",
      projectId: "aichatbot1-a2159",
      storageBucket: "aichatbot1-a2159.firebasestorage.app",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Negotio',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
