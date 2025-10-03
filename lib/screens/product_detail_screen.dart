import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/producto_model.dart';
import '../widgets/appbar.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/product_detail/product_image.dart';
import '../widgets/product_detail/product_features.dart';
import '../theme/app_theme.dart';
import '../screens/cart_screen.dart';
import '../services/base_url.dart';

class ProductDetailScreen extends StatefulWidget {
  final Producto producto;

  const ProductDetailScreen({super.key, required this.producto});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int cantidadSeleccionada = 1;

  final int usuarioId = 38; // 🔧 Puedes hacerlo dinámico luego
  static const String base = BaseUrlService.baseUrl;
  final String baseUrl = "$base/productos/carrito/agregar";

  Future<void> agregarAlCarrito({bool irAlCarrito = false}) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usuario_id": usuarioId,
        "producto_id": widget.producto.id,
        "cantidad": cantidadSeleccionada
      }),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green.shade700,
        content: const Text(
          "✅ Producto agregado al carrito",
          style: TextStyle(color: Colors.white), // 👈 texto blanco visible
        ),
      ),
    );

    if (irAlCarrito) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final precioFormateado = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    ).format(widget.producto.precio);

    return Scaffold(
      key: _scaffoldKey,
      appBar: const CustomAppBar(),
      bottomNavigationBar: CustomBottomNavBar(scaffoldKey: _scaffoldKey),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: theme.cardColor,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🖼 Imagen
                ProductImage(
                  imageUrl:
                      "https://rosybrown-ape-589569.hostingersite.com/uploads/${widget.producto.imagen}",
                ),
                const SizedBox(height: 16),

                /// 📦 Nombre
                Text(
                  widget.producto.nom,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                /// 💵 Precio + botones cantidad y eliminar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      precioFormateado,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 22,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              color: Colors.blue, size: 28),
                          onPressed: cantidadSeleccionada > 1
                              ? () => setState(() => cantidadSeleccionada--)
                              : null,
                        ),
                        Text(
                          "$cantidadSeleccionada",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline,
                              color: Colors.blue, size: 28),
                          onPressed: () =>
                              setState(() => cantidadSeleccionada++),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const Text(
                  "Descripción",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(widget.producto.descripcion),
                const Divider(height: 24),

                /// ⚙️ Características
                const Text(
                  "Características del producto",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.producto.caracteristicas.isNotEmpty
                      ? widget.producto.caracteristicas
                      : "No disponible",
                ),
                const Divider(height: 24),

                /// 🧰 Detalles técnicos
                const Text(
                  "Detalles técnicos",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                ProductFeatures(producto: widget.producto),
                const Divider(height: 24),

                /// 🔁 Política
                Row(
                  children: const [
                    Icon(Icons.replay, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      "Devolución gratis (30 días)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.assignment_turned_in, color: AppColors.primary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Recibe el producto que esperabas o te devolvemos tu dinero.",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// 🛒 BOTÓN AGREGAR AL CARRITO
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.buttonText,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => agregarAlCarrito(irAlCarrito: true),
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text(
                      "Agregar al carrito",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
