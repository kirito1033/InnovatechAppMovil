// home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/ofertas_carousel.dart';
import '../widgets/productos_carrusel.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/custom_drawer.dart';
import '../services/producto.dart';
import '../models/categoria_model.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Categoria>> categoriasFuture;
  String? username;

  @override
  void initState() {
    super.initState();
    categoriasFuture = apiService.fetchCategoriasConProductos();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final name = await AuthService.getUsername();
    if (mounted) {
      setState(() {
        username = name ?? "Usuario";
      });
    }
  }

  Future<void> _handleLogout() async {
    await AuthService.logout(); // 🔹 Borra token y datos
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          if (username != null)
            Padding(
              padding: const EdgeInsets.all(16.0),

            ),
          Expanded(
            child: FutureBuilder<List<Categoria>>(
              future: categoriasFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No hay categorías"));
                }

                final categorias = snapshot.data!;

                return ListView.builder(
                  itemCount: categorias.length + 1,
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

                    if (categoria.productos.isEmpty) return const SizedBox();

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
          ),
        ],
      ),
      endDrawer: CustomDrawer(
        username: username ?? "Usuario",
        currentIndex: 0,
        onItemSelected: (index) => Navigator.pop(context),
        onLogout: _handleLogout, // 🔹 Pasamos la función correcta
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
