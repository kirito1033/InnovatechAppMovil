class Usuario {
  final int idUsuario;
  final String primerNombre;
  final String? segundoNombre;
  final String primerApellido;
  final String? segundoApellido;
  final int documento;
  final String correo;
  final String telefono1;
  final String? telefono2;
  final String direccion;
  final String usuario;
  final String? fotoPerfil;

  Usuario({
    required this.idUsuario,
    required this.primerNombre,
    this.segundoNombre,
    required this.primerApellido,
    this.segundoApellido,
    required this.documento,
    required this.correo,
    required this.telefono1,
    this.telefono2,
    required this.direccion,
    required this.usuario,
    this.fotoPerfil,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json["id_usuario"],
      primerNombre: json["primer_nombre"],
      segundoNombre: json["segundo_nombre"],
      primerApellido: json["primer_apellido"],
      segundoApellido: json["segundo_apellido"],
      documento: json["documento"],
      correo: json["correo"],
      telefono1: json["telefono1"],
      telefono2: json["telefono2"],
      direccion: json["direccion"],
      usuario: json["usuario"],
      fotoPerfil: json["foto_perfil"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_usuario": idUsuario,
      "primer_nombre": primerNombre,
      "segundo_nombre": segundoNombre,
      "primer_apellido": primerApellido,
      "segundo_apellido": segundoApellido,
      "documento": documento,
      "correo": correo,
      "telefono1": telefono1,
      "telefono2": telefono2,
      "direccion": direccion,
      "usuario": usuario,
      "foto_perfil": fotoPerfil,
    };
  }
}
