import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const PingloopApp());
}

class PingloopApp extends StatelessWidget {
  const PingloopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PINGLOOP',
      theme: ThemeData(
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF14B8A6),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}