class CartResponse {
  final String usuarioId;
  final int totalGeneral;
  final List<CartProduct> productos;

  CartResponse({
    required this.usuarioId,
    required this.totalGeneral,
    required this.productos,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      usuarioId: json['usuario_id'].toString(),
      totalGeneral: json['total_general'],
      productos: (json['productos'] as List)
          .map((p) => CartProduct.fromJson(p))
          .toList(),
    );
  }
}

class CartProduct {
  final int carritoId;
  final int usuarioId;
  final int productoId;
  final String nom;
  final String descripcion;
  final int cantidad;
  final int precio;
  final String imagen;
  final String marca;
  final String estado;
  final String categoria;
  final String almacenamiento;
  final String ram;
  final String sistemaOperativo;
  final String resolucion;
  final int totalProducto;

  CartProduct({
    required this.carritoId,
    required this.usuarioId,
    required this.productoId,
    required this.nom,
    required this.descripcion,
    required this.cantidad,
    required this.precio,
    required this.imagen,
    required this.marca,
    required this.estado,
    required this.categoria,
    required this.almacenamiento,
    required this.ram,
    required this.sistemaOperativo,
    required this.resolucion,
    required this.totalProducto,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      carritoId: json['carrito_id'],
      usuarioId: json['usuario_id'],
      productoId: json['producto_id'],
      nom: json['nom'],
      descripcion: json['descripcion'],
      cantidad: json['cantidad'],
      precio: json['precio'],
      imagen: json['imagen'],
      marca: json['marca'],
      estado: json['estado'],
      categoria: json['categoria'],
      almacenamiento: json['almacenamiento'],
      ram: json['ram'],
      sistemaOperativo: json['sistema_operativo'],
      resolucion: json['resolucion'],
      totalProducto: json['total_producto'],
    );
  }
}
