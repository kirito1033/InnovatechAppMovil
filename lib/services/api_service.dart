import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/categoria_model.dart';
import '../models/producto_model.dart';

class ApiService {
  static const String baseUrl = "https://040946db3cfe.ngrok-free.app/api_v1"; 

  // 🔹 Obtener todas las categorías
    Future<List<Categoria>> fetchCategoriasConProductos() async {
      final response = await http.get(
        Uri.parse("$baseUrl/productos/categorias-con-productos"),
      );

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((json) => Categoria.fromJson(json)).toList();
      } else {
        throw Exception("Error al cargar categorías con productos");
      }
    }



  Future<List<Producto>> fetchProductosByCategoria(int categoriaId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/productos/categoria/$categoriaId"));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      // Ya no filtramos en el cliente porque la API lo hace por nosotros
      return data.map((json) => Producto.fromJson(json)).toList();
    } else {
      throw Exception("Error al cargar productos");
    }
  }
}
