import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/purchase_model.dart';
import 'base_url.dart';

class PurchaseService {
  static const String baseUrl = BaseUrlService.baseUrl;
  static Future<List<Purchase>> fetchPurchases(int userId) async {
    try {
      
      final response = await http.get(
        Uri.parse('$baseUrl/usuario/compras/$userId'),
        headers: {'Content-Type': 'application/json'},
      );


      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        
        if (data.isEmpty) {
          print("No se encontraron compras para el usuario");
          return [];
        }
        
        print("${data.length} compras encontradas");
        return data.map((json) => Purchase.fromJson(json)).toList();
        
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      print("Error en fetchPurchases: $e");
      rethrow;
    }
  }
}
