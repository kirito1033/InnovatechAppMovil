class Oferta {
  final int id;
  final int productoId;
  final String imagen;

  Oferta({
    required this.id,
    required this.productoId,
    required this.imagen,
  });

  factory Oferta.fromJson(Map<String, dynamic> json) {
    return Oferta(
      id: int.parse(json['id'].toString()),
      productoId: int.parse(json['productos_id'].toString()),
      imagen: json['imagen'] ?? '',
    );
  }
}
