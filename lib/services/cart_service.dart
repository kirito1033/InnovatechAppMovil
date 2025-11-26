import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart_model.dart';
import '../services/base_url.dart';

class CartService {
  static const String baseUrl = BaseUrlService.baseUrl;

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

  // 🔄 Actualizar cantidad de producto en el carrito
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

  // 🧹 Vaciar todo el carrito (POST - Ruta: /productos/carrito/borrar/:usuario_id)
  static Future<void> clearCart(int usuarioId) async {
  try {
    print("🧹 Vaciando carrito para usuario: $usuarioId");
    
    final url = Uri.parse('https://innovatech-api-nodejs.onrender.com/api_v1/productos/carrito/borrar/$usuarioId');
    print("🔗 URL: $url");
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    print("📡 Status: ${response.statusCode}");
    print("📄 Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("✅ ${data['message']}");
    } else {
      throw Exception('Error: ${response.body}');
    }
  } catch (e) {
    print("❌ Error: $e");
    throw e;
  }
}

  // 📱 Obtener detalle de un producto
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
