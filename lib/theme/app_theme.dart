import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.cyan;
  static const Color background = Color.fromARGB(255, 11, 68, 84);
  static const Color textPrimary = Colors.white;
  static const Color buttonText = Colors.black;
  static const Color appBarBackground = Color.fromARGB(255, 2, 15, 31);
  static const Color appBarIcon = Colors.white;

  static const Color navBarBackground = Color.fromARGB(255, 2, 15, 31);
  static const Color navBarSelected = Colors.cyan;
  static const Color navBarUnselected = Colors.white;
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false, // si usas Material 3 ponlo en true
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: Colors.black, // texto sobre el cyan
      secondary: AppColors.primary,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      background: AppColors.background,
      onBackground: AppColors.textPrimary,
      surface: AppColors.appBarBackground,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.background,

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.textPrimary),
      bodySmall: TextStyle(fontSize: 12, color: Colors.white70),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.buttonText,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBarBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.appBarIcon),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.navBarBackground,
      selectedItemColor: AppColors.navBarSelected,
      unselectedItemColor: AppColors.navBarUnselected,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    ),
  );
}