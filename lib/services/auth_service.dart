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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);

        // 🚨 Guardamos TODO el objeto (no solo el user)
        await prefs.setString("usuarioData", jsonEncode(data));

        // Guardamos el userId aparte para fácil acceso
        if (data["user"] != null && data["user"]["id"] != null) {
          await prefs.setInt("userId", data["user"]["id"]);
          print("✅ userId guardado: ${data["user"]["id"]}");
        } else {
          print("⚠️ No se encontró userId en la respuesta del backend");
        }

        print("✅ Usuario guardado en SharedPreferences: ${jsonEncode(data)}");

        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data["error"] ?? "Credenciales inválidas"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error de conexión: $e"};
    }
  }

  // 🔹 Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("🚪 Sesión cerrada y datos eliminados de SharedPreferences");
  }

  // 🔹 Verificar sesión
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("token");
  }

  // 🔹 Obtener nombre de usuario
  static Future<Map<String, String?>> getUserData() async {
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey("usuarioData")) return {"nombre": null, "correo": null};

  final data = jsonDecode(prefs.getString("usuarioData")!);
  return {
    "nombre": data["user"]["nombre"],
    "correo": data["user"]["correo"], 
  };
}

  // 🔹 Obtener ID de usuario
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("userId")) {
      final id = prefs.getInt("userId");
      print("✅ ID de usuario obtenido: $id");
      return id;
    }

    if (prefs.containsKey("usuarioData")) {
      final data = jsonDecode(prefs.getString("usuarioData")!);
      print("📦 Datos completos del usuario desde SharedPreferences: $data");
      return data["user"]["id"];
    }

    print("❌ No hay userId en SharedPreferences");
    return null;
  }
}
