import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ciudad_model.dart';
import '../models/tipo_documento_model.dart';
import '../services/base_url.dart';

class ApiService {
  static const String baseUrl = BaseUrlService.baseUrl;
  static String? _token;
  static Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/apiUserLogin"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"api_user": email, "api_password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
    } else {
      throw Exception("Error al iniciar sesión");
    }
  }

  static Map<String, String> get headers => {
        "Content-Type": "application/json",
        if (_token != null) "Authorization": "Bearer $_token",
      };

  static Future<List<Ciudad>> getCiudades() async {
    final response = await http.get(Uri.parse("$baseUrl/ciudad"), headers: headers);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Ciudad.fromJson(e)).toList();
    } else {
      throw Exception("Error al cargar ciudades");
    }
  }

  static Future<List<TipoDocumento>> getTiposDocumento() async {
    final response = await http.get(Uri.parse("$baseUrl/tipoDocumento"), headers: headers);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => TipoDocumento.fromJson(e)).toList();
    } else {
      throw Exception("Error al cargar tipos de documento");
    }
  }

  static Future<void> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/usuario"),
      headers: headers,
      body: jsonEncode(userData),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Error al registrar usuario: ${response.body}");
    }
  }

  static Future<void> solicitarResetPassword(String correo) async {
    final response = await http.post(
      Uri.parse("$baseUrl/usuario/solicitar-reset"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"correo": correo}),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al solicitar restablecimiento: ${response.body}");
    }
  }

  static Future<bool> validarTokenReset(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/usuario/validar-token?token=$token"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['valid'] == true;
    } else {
      return false;
    }
  }

  static Future<void> restablecerPassword(String token, String nuevaPassword) async {
    final response = await http.post(
      Uri.parse("$baseUrl/usuario/restablecer-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": token,
        "nuevaPassword": nuevaPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al restablecer contraseña: ${response.body}");
    }
  }
}
