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
  // Colores reutilizables
  static const Color primary = Color(0xFF00E5FF);
  static const Color backgroundDark = Color.fromARGB(255, 11, 68, 84);
  static const Color inputDark = Color(0xFF1F2937);
  static const Color textLight = Colors.white;
  static const Color textMuted = Color(0xB3FFFFFF); 
  static const Color AppbarBackgroundColor = Color(0xFF020F1F);


  // Tema oscuro
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: backgroundDark,
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppbarBackgroundColor,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      headlineSmall: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputDark,
      hintStyle: const TextStyle(color: textMuted),
      labelStyle: const TextStyle(color: textMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: const Color.fromRGBO(11, 68, 84, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
  );


  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primary,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: primary),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}