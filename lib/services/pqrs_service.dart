// archivo: lib/services/pqrs_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/base_url.dart';

class PqrsService {
  static const String baseUrl = BaseUrlService.baseUrl;

  // 🔹 Obtener PQRS de un usuario
  static Future<List<dynamic>> getUserPqrs(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/pqrs/usuario/$userId"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final pqrs = jsonDecode(response.body);
        print("✅ PQRS obtenidas para usuario $userId: $pqrs");
        return pqrs;
      } else {
        throw Exception("Error al obtener PQRS: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  static Future<void> createPqrs({
  required String descripcion,
  required int tipoPqrsId,
  required int usuarioId,
  int estadoPqrsId = 1,
    String comentarioRespuesta = "",
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/pqrs"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "descripcion": descripcion,
          "comentario_respuesta": comentarioRespuesta,
          "tipo_pqrs_id": tipoPqrsId,
          "usuario_id": usuarioId,
          "estado_pqrs_id": estadoPqrsId,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception("Error al crear PQRS: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }
}
