import 'package:flutter/material.dart';
import 'auth/splash_screen.dart';
import 'auth/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/face_screen.dart';
import 'screens/riwayat_screen.dart';
import 'screens/izin_screen.dart';
import 'screens/data_diri_screen.dart';
import 'theme.dart';

void main() => runApp(const HadirkuApp());

class HadirkuApp extends StatelessWidget {
  const HadirkuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hadirku',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      initialRoute: '/',
      // Named routes
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/main': (_) => const MainScreen(),
        '/face': (_) => const FaceScreen(),
        '/riwayat': (_) => const RiwayatScreen(),
        '/izin': (_) => const IzinScreen(),
        '/datadiri': (_) => const DataDiriScreen(),
      },
    );
  }
}