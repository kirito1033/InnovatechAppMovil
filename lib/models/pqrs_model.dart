class Pqrs {
  final int id;
  final String descripcion;
  final String? comentarioRespuesta;
  final int tipoPqrsId;
  final int usuarioId;
  final int estadoPqrsId;
  final String createdAt;
  final String? updatedAt;
  final String tipoPqrs;
  final String estadoPqrs;

  Pqrs({
    required this.id,
    required this.descripcion,
    this.comentarioRespuesta,
    required this.tipoPqrsId,
    required this.usuarioId,
    required this.estadoPqrsId,
    required this.createdAt,
    this.updatedAt,
    required this.tipoPqrs,
    required this.estadoPqrs,
  });

  factory Pqrs.fromJson(Map<String, dynamic> json) {
    return Pqrs(
      id: json["id"],
      descripcion: json["descripcion"],
      comentarioRespuesta: json["comentario_respuesta"],
      tipoPqrsId: json["tipo_pqrs_id"],
      usuarioId: json["usuario_id"],
      estadoPqrsId: json["estado_pqrs_id"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      tipoPqrs: json["tipo_pqrs"],
      estadoPqrs: json["estado_pqrs"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "comentario_respuesta": comentarioRespuesta,
      "tipo_pqrs_id": tipoPqrsId,
      "usuario_id": usuarioId,
      "estado_pqrs_id": estadoPqrsId,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "tipo_pqrs": tipoPqrs,
      "estado_pqrs": estadoPqrs,
    };
  }
}
