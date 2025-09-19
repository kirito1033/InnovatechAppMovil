import 'package:flutter/material.dart';
import '../../models/producto_model.dart';

class ProductFeatures extends StatelessWidget {
  final Producto producto; 

  const ProductFeatures({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
      },
      children: [
        _buildTableRow("Marca:", producto.marca),
        _buildTableRow("Modelo:", producto.nom),
        _buildTableRow("Categoría:", producto.categoria),
        _buildTableRow("Pantalla:", "${producto.tampantalla}\" AMOLED"),
        _buildTableRow("Almacenamiento:", producto.almacenamiento),
        _buildTableRow("RAM:", producto.ram),
        _buildTableRow("Sistema operativo:", producto.sistemaOperativo),
        _buildTableRow("Resolución:", producto.resolucion),
      ],
    );
  }

  // 🔹 Método para construir filas de la tabla
  TableRow _buildTableRow(String title, String value) {
    return TableRow(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value.isNotEmpty ? value : "No disponible"),
      ],
    );
  }
}