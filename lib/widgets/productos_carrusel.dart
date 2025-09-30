import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/appbar.dart';
import '../widgets/ofertas_carousel.dart';
import '../widgets/bottom_navbar.dart';
import '../services/producto.dart';
import '../models/categoria_model.dart';
import '../models/producto_model.dart';
import '../screens/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService apiService = ApiService();
  late Future<List<Categoria>> categoriasFuture;

  @override
  void initState() {
    super.initState();
    categoriasFuture = apiService.fetchCategoriasConProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: const CustomAppBar(),
      body: FutureBuilder<List<Categoria>>(
        future: categoriasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 🔹 Pantalla de carga inicial
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF048d94), // color de la app
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay categorías"));
          }

          final categorias = snapshot.data!;
          return ListView.builder(
            itemCount: categorias.length + 1, // +1 para ofertas
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Column(
                  children: [
                    OfertasCarousel(),
                    SizedBox(height: 20),
                  ],
                );
              }

              final categoria = categorias[index - 1];
              if (categoria.productos.isEmpty) {
                return const SizedBox(); // no renderizar categorías vacías
              }

              return Column(
                children: [
                  ProductosCarrusel(
                    categoriaId: categoria.id,
                    categoriaNom: categoria.nom,
                    productos: categoria.productos,
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(scaffoldKey: _scaffoldKey),
    );
  }
}

/// 🔹 Carrusel de productos con navegación a detalle
class ProductosCarrusel extends StatelessWidget {
  final int categoriaId;
  final String categoriaNom;
  final List<Producto> productos;

  const ProductosCarrusel({
    super.key,
    required this.categoriaId,
    required this.categoriaNom,
    required this.productos,
  });

  @override
  Widget build(BuildContext context) {
    if (productos.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 🔹 Caja de título de la categoría
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: 280,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            border: Border.all(
              color: const Color.fromARGB(255, 2, 15, 31),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            categoriaNom,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
            textAlign: TextAlign.center,
          ),
        ),

        // 🔹 Carrusel de productos
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            autoPlay: true,
            enlargeCenterPage: false,
            viewportFraction: 0.6,
            enableInfiniteScroll: true,
          ),
          items: productos.map((producto) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () async {
                    // 🔹 Mostrar pantalla de carga antes de ir al detalle
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF048d94), // color de la app
                        ),
                      ),
                    );

                    try {
                      final productoDetalle = await ApiService().fetchProductoById(producto.id);
                      
                      if (context.mounted) {
                        Navigator.pop(context); // cerrar el loading
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(producto: productoDetalle),
                          ),
                        );
                      }
                    } catch (e) {
                      Navigator.pop(context); // cerrar el loading
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error al cargar producto: $e")),
                      );
                    }
                  },
                  child: Card(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              "https://rosybrown-ape-589569.hostingersite.com/uploads/${producto.imagen}",
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  size: 80,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          producto.nom,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "\$${producto.precio}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF048d94),
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
