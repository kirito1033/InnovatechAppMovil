import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/producto_model.dart';
import '../widgets/appbar.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/product_detail/product_image.dart';
import '../widgets/product_detail/product_features.dart';

class ProductDetailScreen extends StatefulWidget {
  final Producto producto;

  const ProductDetailScreen({super.key, required this.producto});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int cantidadSeleccionada = 1;

  @override
  Widget build(BuildContext context) {
    final precioFormateado =
        NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0)
            .format(widget.producto.precio);

    return Scaffold(
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomBottomNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Imagen del producto
                ProductImage(
                  imageUrl:
                      "https://rosybrown-ape-589569.hostingersite.com/uploads/${widget.producto.imagen}",
                ),
                const SizedBox(height: 16),

                /// Nombre y precio
                Text(
                  widget.producto.nom,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  precioFormateado,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF048d94),
                  ),
                ),
                const SizedBox(height: 16),

                /// Stock
                Row(
                  children: [
                    Icon(
                      widget.producto.existencias > 0
                          ? Icons.check_circle
                          : Icons.error,
                      color: widget.producto.existencias > 0
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.producto.existencias > 0
                          ? "Stock disponible (${widget.producto.existencias} unidades)"
                          : "Sin stock disponible",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: widget.producto.existencias > 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                /// Selector de cantidad
                Row(
                  children: [
                    const Text(
                      "Cantidad:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<int>(
                      value: cantidadSeleccionada,
                      items: List.generate(
                        widget.producto.existencias > 0
                            ? widget.producto.existencias
                            : 1,
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text("${index + 1}"),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          cantidadSeleccionada = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                /// Descripción
                const Text(
                  "Descripción",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.producto.descripcion,
                  style: const TextStyle(fontSize: 14),
                ),
                const Divider(height: 24),

                /// Características
                const Text(
                  "Características del producto",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.producto.caracteristicas.isNotEmpty
                      ? widget.producto.caracteristicas
                      : "No disponible",
                  style: const TextStyle(fontSize: 14),
                ),
                const Divider(height: 24),

                /// Detalles técnicos
                const Text(
                  "Detalles técnicos",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                ProductFeatures(producto: widget.producto),
                const Divider(height: 24),

                /// Política de devolución
                Row(
                  children: const [
                    Icon(Icons.replay, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      "Devolución gratis (30 días)",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.assignment_turned_in, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Recibe el producto que esperabas o te devolvemos tu dinero.",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25cff2),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Producto agregado al carrito 🛒 x$cantidadSeleccionada"),
                            ),
                          );
                        },
                        icon:
                            const Icon(Icons.shopping_cart, color: Colors.white),
                        label: const Text(
                          "Agregar al carrito",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Compra realizada ✅ x$cantidadSeleccionada"),
                            ),
                          );
                        },
                        icon:
                            const Icon(Icons.payment, color: Colors.white),
                        label: const Text(
                          "Comprar ahora",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
