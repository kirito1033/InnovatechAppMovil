import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/oferta_model.dart';
import '../services/base_url.dart';

class OfertaService {
  final String baseUrl = BaseUrlService.baseUrl;

  Future<List<Oferta>> getOfertas() async {
    final response = await http.get(Uri.parse("$baseUrl/ofertas"));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Oferta.fromJson(json)).toList();
    } else {
      throw Exception("Error al cargar ofertas: ${response.statusCode}");
    }
  }
}
