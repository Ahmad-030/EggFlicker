import 'package:eggflicker/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Hide status bar for immersive experience
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Init shared preferences
  await SharedPreferences.getInstance();

  runApp(const EggFlickerApp());
}

class EggFlickerApp extends StatelessWidget {
  const EggFlickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EggFlicker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}