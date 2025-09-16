import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const InovaTechApp());
}

class InovaTechApp extends StatelessWidget {
  const InovaTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "InovaTech",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
