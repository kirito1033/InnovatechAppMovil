// services/user_helper.dart
import 'package:flutter/material.dart';
import 'auth_service.dart';

class UserHelper {
  /// Obtiene datos del usuario desde el AuthService
  static Future<Map<String, String>> getUserData() async {
    final data = await AuthService.getUserData();
    return {
      "username": data["nombre"] ?? "Usuario",
      "correo": data["correo"] ?? "correo@ejemplo.com",
    };
  }

  /// Cierra sesión y redirige al login
  static Future<void> logout(BuildContext context) async {
    await AuthService.logout();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
