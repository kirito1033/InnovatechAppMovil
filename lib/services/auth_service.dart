// archivo: lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/base_url.dart';

class AuthService {
  static const String baseUrl = BaseUrlService.baseUrl; 

  // 🔹 Login
  static Future<Map<String, dynamic>> login(String usuario, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/usuario/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"usuario": usuario, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 🔹 Guardamos el token para mantener la sesión
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]); 
        await prefs.setString("usuario", jsonEncode(data["usuario"])); 

        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": data["error"] ?? "Credenciales inválidas"};
      }
    } catch (e) {
      return {"success": false, "message": "Error de conexión: $e"};
    }
  }

  // 🔹 Logout (borrar token y datos guardados)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("usuario");
  }

  // 🔹 Verificar si hay sesión iniciada
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("token");
  }
  
  static Future<String?> getUsername() async {
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey("usuario")) return null;
  final usuarioData = jsonDecode(prefs.getString("usuario")!);
  return usuarioData["nombre"];
}
}

