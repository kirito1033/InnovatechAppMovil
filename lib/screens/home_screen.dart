import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/ofertas_carousel.dart';
import '../widgets/productos_carrusel.dart';
import '../widgets/bottom_navbar.dart';
import '../services/api_service.dart';
import '../models/categoria_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      appBar: const CustomAppBar(),
      body: FutureBuilder<List<Categoria>>(
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
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
