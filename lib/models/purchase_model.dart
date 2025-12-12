class Purchase {
  final String numero;
  final String referenceCode;
  final DateTime createdAt;
  final double total;
  final Map<String, dynamic> facturaJson;
  final int usuarioId;

  Purchase({
    required this.numero,
    required this.referenceCode,
    required this.createdAt,
    required this.total,
    required this.facturaJson,
    required this.usuarioId,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    // Calcular total desde factura_json (igual que en PHP)
    double total = 0.0;
    
    try {
      final factura = json['factura_json'];
      
      if (factura != null && factura['items'] != null && factura['items'] is List) {
        for (var item in factura['items']) {
          final precio = double.tryParse(item['price']?.toString() ?? '0') ?? 0.0;
          final cantidad = int.tryParse(item['quantity']?.toString() ?? '0') ?? 0;
          total += precio * cantidad;
        }
      }
    } catch (e) {
      print("Error al calcular total: $e");
    }

    return Purchase(
      numero: json['numero']?.toString() ?? '',
      referenceCode: json['reference_code']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      total: total,
      facturaJson: json['factura_json'] ?? {},
      usuarioId: int.tryParse(json['usuario_id']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numero': numero,
      'reference_code': referenceCode,
      'created_at': createdAt.toIso8601String(),
      'total': total,
      'factura_json': facturaJson,
      'usuario_id': usuarioId,
    };
  }
}
