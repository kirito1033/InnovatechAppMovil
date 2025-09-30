import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/producto_model.dart';
import '../widgets/appbar.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/product_detail/product_image.dart';
import '../widgets/product_detail/product_features.dart';
import '../theme/app_theme.dart'; // 👈 importa tu theme

class ProductDetailScreen extends StatefulWidget {
  final Producto producto;

  const ProductDetailScreen({super.key, required this.producto});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int cantidadSeleccionada = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final precioFormateado =
        NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0)
            .format(widget.producto.precio);

    return Scaffold(
      key: _scaffoldKey,
      appBar: const CustomAppBar(),
      bottomNavigationBar: CustomBottomNavBar(scaffoldKey: _scaffoldKey),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: theme.cardColor, // 👈 usa color de tarjeta del tema
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

                /// Nombre
                Text(
                  widget.producto.nom,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),

                /// Precio
                Text(
                  precioFormateado,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    color: AppColors.primary, // 👈 color del theme
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
                          : theme.colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.producto.existencias > 0
                          ? "Stock disponible (${widget.producto.existencias} unidades)"
                          : "Sin stock disponible",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: widget.producto.existencias > 0
                            ? Colors.green
                            : theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                /// Selector de cantidad
                Row(
                  children: [
                    Text(
                      "Cantidad:",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                Text(
                  "Descripción",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.producto.descripcion,
                  style: theme.textTheme.bodyMedium,
                ),
                const Divider(height: 24),

                /// Características
                Text(
                  "Características del producto",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.producto.caracteristicas.isNotEmpty
                      ? widget.producto.caracteristicas
                      : "No disponible",
                  style: theme.textTheme.bodyMedium,
                ),
                const Divider(height: 24),

                /// Detalles técnicos
                Text(
                  "Detalles técnicos",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                ProductFeatures(producto: widget.producto),
                const Divider(height: 24),

                /// Política de devolución
                Row(
                  children: [
                    Icon(Icons.replay, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      "Devolución gratis (30 días)",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.assignment_turned_in, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Recibe el producto que esperabas o te devolvemos tu dinero.",
                        style: theme.textTheme.bodyMedium,
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
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Producto agregado al carrito 🛒 x$cantidadSeleccionada"),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text("Agregar al carrito"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.buttonText,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Compra realizada ✅ x$cantidadSeleccionada"),
                            ),
                          );
                        },
                        icon: const Icon(Icons.payment),
                        label: const Text(
                          "Comprar ahora",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
