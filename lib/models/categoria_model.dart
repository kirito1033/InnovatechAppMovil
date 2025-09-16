import 'producto_model.dart'; 
class Categoria {
  final int id;
  final String nom;
  final List<Producto> productos;

  Categoria({required this.id, required this.nom, required this.productos});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nom: json['nom'],
      productos: (json['productos'] as List)
          .map((p) => Producto.fromJson(p))
          .toList(),
    );
  }
}
