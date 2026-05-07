import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/history.dart';
import 'repositories/local_history_repository.dart';
import 'providers/history_provider.dart';

import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/developer_info_screen.dart';
import 'screens/donation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for path_provider and Hive

  await Hive.initFlutter();
  Hive.registerAdapter(HistoryAdapter());
  await Hive.openBox<History>('history');

  final repository = LocalHistoryRepository(); // Local-only history storage

  runApp(
    ChangeNotifierProvider(
      create: (_) => HistoryProvider(repository: repository),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alfred AI Voice App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        primaryColor: Colors.blueAccent,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),               // Custom banner splash
        '/home': (_) => const HomeScreen(),             // Main voice generation screen
        '/history': (_) => const HistoryScreen(),       // Playback history
        '/developer': (_) => const DeveloperInfoScreen(), // Developer branding
        '/donate': (_) => const DonationScreen(),       // Support screen
      },
    );
  }
}