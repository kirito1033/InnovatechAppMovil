import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/producto_model.dart';
import '../widgets/appbar.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/product_detail/product_image.dart';
import '../widgets/product_detail/product_features.dart';
import '../theme/app_theme.dart';
import '../screens/cart_screen.dart';
import '../services/base_url.dart';
import '../services/auth_service.dart'; 

class ProductDetailScreen extends StatefulWidget {
  final Producto producto;

  const ProductDetailScreen({super.key, required this.producto});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  int cantidadSeleccionada = 1;
  int? usuarioId; 
  static const String base = BaseUrlService.baseUrl;
  final String baseUrl = "$base/productos/carrito/agregar";

  @override
  void initState() {
    super.initState();
    _cargarUsuario(); 
  }

  Future<void> _cargarUsuario() async {
    final id = await AuthService.getUserId();
    if (id != null) {
      setState(() {
        usuarioId = id;
      });
      print("Usuario ID cargado dinámicamente: $usuarioId");
    } else {
      print("No se encontró usuario, redirigiendo al login...");
  
    }
  }

  Future<void> agregarAlCarrito({bool irAlCarrito = false}) async {
    if (usuarioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Debes iniciar sesión para agregar al carrito"),
        ),
      );
      return;
    }

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usuario_id": usuarioId, 
        "producto_id": widget.producto.id,
        "cantidad": cantidadSeleccionada 
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green.shade700,
          content: const Text(
            "Producto agregado al carrito",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

      if (irAlCarrito) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
      }
    } else {
      print("Producto agregado al carrito: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(255, 114, 215, 86),
          content: const Text("Producto agregado al carrito"),
        ),
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
      body: usuarioId == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                      ProductImage(
                        imageUrl:
                            "https://innovatech-mvc-v-2-0.onrender.com/uploads/${widget.producto.imagen}",
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.producto.nom,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

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
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(widget.producto.descripcion),
                      const Divider(height: 24),

                      const Text(
                        "Características del producto",
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.producto.caracteristicas.isNotEmpty
                            ? widget.producto.caracteristicas
                            : "No disponible",
                      ),
                      const Divider(height: 24),

                      const Text(
                        "Detalles técnicos",
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      ProductFeatures(producto: widget.producto),
                      const Divider(height: 24),

                      Row(
                        children: const [
                          Icon(Icons.replay, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            "Devolución gratis (30 días)",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.assignment_turned_in,
                              color: AppColors.primary),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Recibe el producto que esperabas o te devolvemos tu dinero.",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

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
