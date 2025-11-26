// services/user_helper.dart
import 'package:flutter/material.dart';
import 'auth_service.dart';

class UserHelper {
  /// Obtiene datos del usuario desde SharedPreferences
  static Future<Map<String, String>> getUserData() async {
    try {
      final userId = await AuthService.getUserId();
      
      if (userId == null) {
        return {
          "username": "Usuario",
          "correo": "correo@ejemplo.com",
        };
      }

      // Obtener datos completos del backend
      final userData = await AuthService.getUserDataFromBackend(userId);
      
      if (userData == null) {
        return {
          "username": "Usuario",
          "correo": "correo@ejemplo.com",
        };
      }

      // Construir nombre completo
      final nombreCompleto = [
        userData['primer_nombre'],
        userData['segundo_nombre'],
        userData['primer_apellido'],
        userData['segundo_apellido'],
      ].where((n) => n != null && n.toString().isNotEmpty).join(' ');

      return {
        "username": nombreCompleto.isNotEmpty ? nombreCompleto : "Usuario",
        "correo": userData['correo'] ?? "correo@ejemplo.com",
      };
    } catch (e) {
      print("❌ Error obteniendo datos del usuario: $e");
      return {
        "username": "Usuario",
        "correo": "correo@ejemplo.com",
      };
    }
  }

  /// Cierra sesión y redirige al login
  static Future<void> logout(BuildContext context) async {
    await AuthService.logout();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
