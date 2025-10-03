import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart_model.dart';
import '../services/base_url.dart';

class CartService {
  static const String baseUrl = BaseUrlService.baseUrl;

  
    static Future<void> updateQuantity({
      required int usuarioId,
      required int productoId,
      required int cantidad,
    }) async {
      final url = Uri.parse("$baseUrl/productos/carrito/actualizar");
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usuario_id": usuarioId,   
          "producto_id": productoId, 
          "cantidad": cantidad,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Error al actualizar cantidad: ${response.body}");
      }
    }

  // 🛒 Obtener carrito de un usuario
  static Future<CartResponse> fetchCart(int usuarioId) async {
    final url = Uri.parse("$baseUrl/productos/carrito/$usuarioId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CartResponse.fromJson(data);
    } else {
      throw Exception("Error al cargar el carrito: ${response.statusCode}");
    }
  }

  // ➕ Agregar producto al carrito
  static Future<void> addToCart({
    required int usuarioId,
    required int productoId,
    required int cantidad,
  }) async {
    final url = Uri.parse("$baseUrl/productos/carrito/agregar");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usuario_id": usuarioId,
        "producto_id": productoId,
        "cantidad": cantidad,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(
          "Error al agregar producto al carrito: ${response.statusCode}");
    }
  }

  // 🗑️ Eliminar producto del carrito
  static Future<void> removeFromCart({
    required int usuarioId,
    required int productoId,
  }) async {
    final url = Uri.parse("$baseUrl/productos/carrito/eliminar");

    final response = await http.delete(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usuario_id": usuarioId,
        "producto_id": productoId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          "Error al eliminar producto del carrito: ${response.statusCode}");
    }
  }


  static Future<Map<String, dynamic>> fetchProductDetail(int productoId) async {
    final url = Uri.parse("$baseUrl/productos/$productoId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error al obtener detalle: ${response.statusCode}");
    }
  }

   
}

