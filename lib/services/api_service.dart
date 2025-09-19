import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/categoria_model.dart';
import '../models/producto_model.dart';
import '../services/base_url.dart';

class ApiService {
  static const String baseUrl = BaseUrlService.baseUrl; 

  
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
  
  Future<Producto> fetchProductoById(int id) async {
  final url = "$baseUrl/productos/$id";
  print("URL generada: $url");
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print("JSON recibido: ${response.body}"); 
    return Producto.fromJson(jsonDecode(response.body));
  } else {
    print("Error: ${response.statusCode} - ${response.reasonPhrase}");
    throw Exception("Error al cargar el producto con ID $id");
  }
}

}
