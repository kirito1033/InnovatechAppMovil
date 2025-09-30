import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.cyan;

  // Fondo general oscuro
  static const Color background = Color.fromARGB(255, 11, 68, 84);

  // Textos oscuros/claro
  static const Color textPrimary = Colors.white;
  static const Color textDark = Colors.black; // 👈 nuevo

  // Tarjetas claras
  static const Color cardLight = Colors.white; // 👈 nuevo

  static const Color buttonText = Colors.black;

  static const Color appBarBackground = Color.fromARGB(255, 2, 15, 31);
  static const Color appBarIcon = Colors.white;

  static const Color navBarBackground = Color.fromARGB(255, 2, 15, 31);
  static const Color navBarSelected = Colors.cyan;
  static const Color navBarUnselected = Colors.white;
}

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: Colors.black,
      secondary: AppColors.primary,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      background: AppColors.background,
      onBackground: AppColors.textPrimary,
      surface: AppColors.cardLight, // 👈 tarjetas claras
      onSurface: AppColors.textDark, // 👈 textos oscuros en tarjetas
    ),
    scaffoldBackgroundColor: AppColors.background,

    cardColor: AppColors.cardLight, // 👈 importante para tarjetas claras

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark, // 👈 títulos en negro
      ),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.textDark), // 👈 negro
      bodySmall: TextStyle(fontSize: 12, color: Colors.black54), // 👈 gris oscuro
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.buttonText,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );
}