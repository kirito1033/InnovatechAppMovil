class Producto {
  final int id;
  final String nom;
  final double precio;
  final String imagen;
  final String nombreCategoria;

  Producto({
    required this.id,
    required this.nom,
    required this.precio,
    required this.imagen,
    required this.nombreCategoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: int.parse(json['id'].toString()),
      nom: json['nom'] ?? '',
      precio: double.tryParse(json['precio'].toString()) ?? 0.0,
      imagen: json['imagen'] ?? '',
      nombreCategoria: json['nombre_categoria'] ?? '', 
    );
  }
}
