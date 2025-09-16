import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/producto_model.dart';

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
                return Card(
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
                              return const Icon(Icons.broken_image,
                                  size: 80, color: Colors.grey);
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
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                    ],
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
