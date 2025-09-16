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
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.buttonText),
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
