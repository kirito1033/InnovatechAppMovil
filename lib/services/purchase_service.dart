import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/purchase_model.dart';
import 'base_url.dart';

class PurchaseService {
  static const String baseUrl = BaseUrlService.baseUrl;

  /// Obtiene las facturas/compras de un usuario específico
  /// Equivalente a: WHERE usuario_id = $usuarioId ORDER BY created_at DESC
  static Future<List<Purchase>> fetchPurchases(int userId) async {
    try {
      print("📡 Obteniendo compras para usuario ID: $userId");
      
      final response = await http.get(
        Uri.parse('$baseUrl/usuario/compras/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      print("📊 Status Code: ${response.statusCode}");
      print("📦 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        
        if (data.isEmpty) {
          print("⚠️ No se encontraron compras para el usuario");
          return [];
        }
        
        print("✅ ${data.length} compras encontradas");
        return data.map((json) => Purchase.fromJson(json)).toList();
        
      } else if (response.statusCode == 404) {
        print("ℹ️ Usuario sin compras (404)");
        return [];
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Error en fetchPurchases: $e");
      rethrow;
    }
  }
}
