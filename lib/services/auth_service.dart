import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/base_url.dart';

class AuthService {
  static const String baseUrl = BaseUrlService.baseUrl;

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
        await prefs.setString("usuarioData", jsonEncode(data));

        if (data["user"] != null && data["user"]["id"] != null) {
          await prefs.setInt("userId", data["user"]["id"]);
          print("userId guardado: ${data["user"]["id"]}");
        }

        print("Usuario guardado en SharedPreferences");

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


  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("Sesión cerrada");
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("token");
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("userId")) {
      return prefs.getInt("userId");
    }

    if (prefs.containsKey("usuarioData")) {
      final data = jsonDecode(prefs.getString("usuarioData")!);
      return data["user"]["id"];
    }

    return null;
  }

  static Future<Map<String, dynamic>?> getUserDataFromBackend(int userId) async {
    try {
      print("Obteniendo datos del usuario: $userId");
      
      final response = await http.get(
        Uri.parse("$baseUrl/usuario/$userId"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Datos del usuario obtenidos: ${data['user']['primer_nombre']}");
        return data['user'];
      } else {
        print("Error obteniendo usuario: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>> getClienteDataForFactura() async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        throw Exception("Usuario no identificado");
      }

      // Obtener datos completos del backend
      final userData = await getUserDataFromBackend(userId);
      
      if (userData == null) {
        throw Exception("No se pudieron obtener los datos del usuario");
      }

      // Preparar datos para la factura
      final nombreCompleto = [
        userData['primer_nombre'],
        userData['segundo_nombre'],
        userData['primer_apellido'],
        userData['segundo_apellido'],
      ].where((n) => n != null && n.toString().isNotEmpty).join(' ');

      return {
        'documento': userData['documento']?.toString() ?? '0000000000',
        'nombre': nombreCompleto,
        'direccion': userData['direccion'] ?? 'Sin dirección',
        'email': userData['correo'] ?? 'cliente@email.com',
        'telefono': userData['telefono1'] ?? '0000000000',
      };
    } catch (e) {
      print("❌ Error preparando datos del cliente: $e");
      
      // Fallback con datos por defecto
      return {
        'documento': '0000000000',
        'nombre': 'Cliente Innovatech',
        'direccion': 'Sin dirección',
        'email': 'cliente@email.com',
        'telefono': '0000000000',
      };
    }
  }
static Future<bool> updateUserData(Map<String, dynamic> data) async {
  try {
    final userId = await getUserId();
    if (userId == null) return false;

    final response = await http.put(
      Uri.parse("$baseUrl/usuario/$userId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Opcional: actualizar los datos guardados en el dispositivo
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("usuarioData", response.body);
      return true;
    } else {
      print("Error actualizando usuario: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("Error updateUserData: $e");
    return false;
  }
}

}

