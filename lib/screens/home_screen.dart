import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/ofertas_carousel.dart';
import '../widgets/productos_carrusel.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/custom_drawer.dart';
import '../services/producto.dart';
import '../models/categoria_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService apiService = ApiService();
  
  // 🆕 Future combinado para cargar todo en paralelo
  late Future<Map<String, dynamic>> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = _loadAllContent();
  }

  /// 🆕 Carga ofertas y categorías en paralelo
  Future<Map<String, dynamic>> _loadAllContent() async {
    try {
      // Ejecutar ambas peticiones al mismo tiempo
      final results = await Future.wait([
        apiService.fetchCategoriasConProductos(),
        _loadOfertas(), // Función que simula la carga de ofertas
      ]);

      return {
        'categorias': results[0] as List<Categoria>,
        'ofertas_loaded': results[1] as bool,
      };
    } catch (e) {
      print("❌ Error al cargar contenido: $e");
      rethrow;
    }
  }

  /// Simula la carga de ofertas (ajusta según tu implementación)
  Future<bool> _loadOfertas() async {
    // Si OfertasCarousel hace su propia petición,
    // esta función puede simplemente esperar un poco
    // para sincronizar tiempos
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: const CustomAppBar(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _contentFuture,
        builder: (context, snapshot) {
          // 🔹 Estado de carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Cargando contenido...",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // 🔹 Estado de error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    "Error al cargar contenido",
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _contentFuture = _loadAllContent();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reintentar"),
                  ),
                ],
              ),
            );
          }

          // 🔹 Contenido cargado
          if (!snapshot.hasData) {
            return const Center(child: Text("No hay datos disponibles"));
          }

          final data = snapshot.data!;
          final categorias = data['categorias'] as List<Categoria>;

          if (categorias.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No hay categorías disponibles",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // 🔹 Renderizar todo junto
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _contentFuture = _loadAllContent();
              });
            },
            child: ListView.builder(
              itemCount: categorias.length + 1,
              itemBuilder: (context, index) {
                // 🔹 Primer elemento: Carrusel de ofertas
                if (index == 0) {
                  return const Column(
                    children: [
                      OfertasCarousel(),
                      SizedBox(height: 20),
                    ],
                  );
                }

                // 🔹 Resto de elementos: Categorías con productos
                final categoria = categorias[index - 1];

                if (categoria.productos.isEmpty) {
                  return const SizedBox.shrink();
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
            ),
          );
        },
      ),
      endDrawer: const CustomDrawer(currentIndex: 0),
      bottomNavigationBar: CustomBottomNavBar(scaffoldKey: _scaffoldKey),
    );
  }
}
