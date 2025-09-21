class TipoDocumento {
  final int id;
  final String nom;

  TipoDocumento({required this.id, required this.nom});

  factory TipoDocumento.fromJson(Map<String, dynamic> json) {
    return TipoDocumento(
      id: json['id'],
      nom: json['nom'] ?? '',
    );
  }
}
