class Producto {
  final int id;
  final String nom;
  final String descripcion;
  final int existencias;
  final double precio;
  final String imagen;
  final String caracteristicas;
  final int tam;
  final int tampantalla;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String marca;
  final String estado;
  final String color;
  final String categoria;
  final String garantia;
  final String almacenamiento;
  final String ram;
  final String sistemaOperativo;
  final String resolucion;

  Producto({
    required this.id,
    required this.nom,
    required this.descripcion,
    required this.existencias,
    required this.precio,
    required this.imagen,
    required this.caracteristicas,
    required this.tam,
    required this.tampantalla,
    required this.createdAt,
    required this.updatedAt,
    required this.marca,
    required this.estado,
    required this.color,
    required this.categoria,
    required this.garantia,
    required this.almacenamiento,
    required this.ram,
    required this.sistemaOperativo,
    required this.resolucion,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      descripcion: json['descripcion'] ?? '',
      existencias: json['existencias'] ?? 0,
      precio: (json['precio'] as num?)?.toDouble() ?? 0.0,
      imagen: json['imagen'] ?? '',
      caracteristicas: json['caracteristicas'] ?? '',
      tam: json['tam'] ?? 0,
      tampantalla: json['tampantalla'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      marca: json['marca'] ?? '',
      estado: json['estado'] ?? '',
      color: json['color'] ?? '',
      categoria: json['categoria'] ?? '',
      garantia: json['garantia'] ?? '',
      almacenamiento: json['almacenamiento'] ?? '',
      ram: json['ram'] ?? '',
      sistemaOperativo: json['sistema_operativo'] ?? '',
      resolucion: json['resolucion'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'descripcion': descripcion,
      'existencias': existencias,
      'precio': precio,
      'imagen': imagen,
      'caracteristicas': caracteristicas,
      'tam': tam,
      'tampantalla': tampantalla,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'marca': marca,
      'estado': estado,
      'color': color,
      'categoria': categoria,
      'garantia': garantia,
      'almacenamiento': almacenamiento,
      'ram': ram,
      'sistema_operativo': sistemaOperativo,
      'resolucion': resolucion,
    };
  }
}