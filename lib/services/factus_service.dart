import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_url.dart';

class FactusService {
  static const String baseUrl = BaseUrlService.baseUrl;

  /// Envía la factura a través del backend Node.js
  /// El backend se encarga de autenticarse con Factus
  static Future<Map<String, dynamic>> enviarFactura({
    required int usuarioId,
    required List<Map<String, dynamic>> productos,
    required Map<String, dynamic> datosCliente,
    required String referenceCode,
  }) async {
    try {
      print("📄 Preparando factura para enviar al backend...");
      print("🆔 Usuario: $usuarioId");
      print("📝 Referencia: $referenceCode");

      // Preparar datos de la factura
      final facturaData = {
        "numbering_range_id": 8,
        "reference_code": referenceCode, // ✅ Usar el referenceCode de PayU directamente
        "usuario_id": usuarioId,
        "observation": "Compra desde app móvil Innovatech",
        "payment_form": "1",
        "payment_due_date": _getFechaVencimiento(),
        "payment_method_code": "10",
        "operation_type": 10,
        "order_reference": {
          "reference_code": "ref-$referenceCode",
          "issue_date": ""
        },
        "billing_period": {
          "start_date": _getFechaInicioFacturacion(),
          "start_time": "00:00:00",
          "end_date": _getFechaFinFacturacion(),
          "end_time": "23:59:59"
        },
        "customer": {
          "identification": datosCliente['documento'] ?? '0000000000',
          "dv": "3",
          "company": "",
          "trade_name": "",
          "names": datosCliente['nombre'] ?? 'Cliente',
          "address": datosCliente['direccion'] ?? 'Sin dirección',
          "email": datosCliente['email'] ?? 'cliente@email.com',
          "phone": datosCliente['telefono'] ?? '0000000000',
          "legal_organization_id": "2",
          "tribute_id": "21",
          "identification_document_id": "3",
          "municipality_id": "980"
        },
        "items": _prepararProductos(productos),
      };

      print("📦 Productos a facturar: ${productos.length}");
      print("💰 Total: \$${_calcularTotal(productos).toStringAsFixed(2)}");
      print("🔗 URL: $baseUrl/facturas");

      // Enviar al backend Node.js
      final response = await http.post(
        Uri.parse('$baseUrl/facturas'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(facturaData),
      );

      print("📡 Respuesta del backend: ${response.statusCode}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final result = jsonDecode(response.body);
        
        print("✅ Factura creada exitosamente");
        print("📄 Datos: ${response.body}");

        // Extraer número de factura
        final invoiceNumber = result['data']?['invoice_number'] ?? 
                             result['data']?['number'] ??
                             'TEMP-${DateTime.now().millisecondsSinceEpoch}';

        print("📄 Número de factura: $invoiceNumber");

        return {
          'success': true,
          'data': result['data'],
          'message': 'Factura generada correctamente',
          'invoice_number': invoiceNumber,
        };
      } else {
        final errorBody = response.body;
        print("❌ Error del backend: ${response.statusCode}");
        print("📄 Body: $errorBody");

        try {
          final error = jsonDecode(errorBody);
          return {
            'success': false,
            'message': error['message'] ?? 'Error desconocido',
            'error': error,
          };
        } catch (e) {
          return {
            'success': false,
            'message': 'Error al crear factura',
            'error': errorBody,
          };
        }
      }
    } catch (e) {
      print("❌ Error crítico: $e");
      return {
        'success': false,
        'message': 'Error al conectar con el servidor',
        'error': e.toString(),
      };
    }
  }

  /// Prepara el formato de productos para Factus
  static List<Map<String, dynamic>> _prepararProductos(List<Map<String, dynamic>> productos) {
    return productos.map((producto) {
      final precio = double.parse(producto['precio'].toString());
      final cantidad = int.parse(producto['cantidad'].toString());
      
      return {
        "scheme_id": "0",
        "note": "",
        "code_reference": producto['productoId'].toString(),
        "name": producto['nombre'],
        "quantity": cantidad,
        "discount_rate": 0, // ✅ Siempre número
        "price": precio,
        "tax_rate": "19.00",
        "unit_measure_id": 70,
        "standard_code_id": 1,
        "is_excluded": 0,
        "tribute_id": 1,
        "withholding_taxes": [] // ✅ Array vacío
      };
    }).toList();
  }

  /// Calcula el total de los productos
  static double _calcularTotal(List<Map<String, dynamic>> productos) {
    double total = 0;
    for (var producto in productos) {
      final precio = double.parse(producto['precio'].toString());
      final cantidad = int.parse(producto['cantidad'].toString());
      total += precio * cantidad;
    }
    return total;
  }

  /// Fecha de vencimiento (30 días después de hoy)
  static String _getFechaVencimiento() {
    final fecha = DateTime.now().add(const Duration(days: 30));
    return "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
  }

  /// Fecha de inicio del periodo de facturación
  static String _getFechaInicioFacturacion() {
    final fecha = DateTime.now();
    return "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-01";
  }

  /// Fecha de fin del periodo de facturación
  static String _getFechaFinFacturacion() {
    final fecha = DateTime.now();
    final siguienteMes = DateTime(fecha.year, fecha.month + 1, 1);
    final ultimoDia = siguienteMes.subtract(const Duration(days: 1));
    return "${ultimoDia.year}-${ultimoDia.month.toString().padLeft(2, '0')}-${ultimoDia.day.toString().padLeft(2, '0')}";
  }

  /// Consulta una factura por su número (a través del backend)
  static Future<Map<String, dynamic>> consultarFactura(String numeroFactura) async {
    try {
      print('🔍 Consultando factura: $numeroFactura');
      
      final response = await http.get(
        Uri.parse('$baseUrl/facturas/$numeroFactura'),
        headers: {'Accept': 'application/json'},
      );

      print('📡 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Factura encontrada');
        return {
          'success': true,
          'data': jsonDecode(response.body)['data'],
        };
      } else {
        print('❌ Factura no encontrada');
        return {
          'success': false,
          'message': 'Factura no encontrada',
        };
      }
    } catch (e) {
      print('❌ Error: $e');
      return {
        'success': false,
        'message': 'Error al consultar factura',
        'error': e.toString(),
      };
    }
  }

  /// Descarga el PDF de una factura (a través del backend)
  static Future<List<int>?> descargarPDF(String numeroFactura) async {
    try {
      print('📥 Descargando PDF: $numeroFactura');
      
      final response = await http.get(
        Uri.parse('$baseUrl/facturas/$numeroFactura/pdf'),
      );

      if (response.statusCode == 200) {
        print('✅ PDF descargado (${response.bodyBytes.length} bytes)');
        return response.bodyBytes;
      } else {
        print('❌ Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Error: $e');
      return null;
    }
  }
}
