import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/oferta_model.dart';
import '../services/oferta_service.dart';
import '../services/producto.dart';
import '../screens/product_detail_screen.dart';

class OfertasCarousel extends StatefulWidget {
  const OfertasCarousel({super.key});

  @override
  State<OfertasCarousel> createState() => _OfertasCarouselState();
}

class _OfertasCarouselState extends State<OfertasCarousel> {
  final OfertaService _ofertaService = OfertaService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Oferta>>(
      future: _ofertaService.getOfertas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error cargando ofertas"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No hay ofertas disponibles"));
        }

        final ofertas = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(top: 15),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 130,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.97,
            ),
            items: ofertas.map((oferta) {
              return Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () async {
                      // 🔹 Mostrar loader mientras carga
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF048d94),
                          ),
                        ),
                      );

                      try {
                        final productoDetalle =
                            await ApiService().fetchProductoById(oferta.productoId);

                        if (context.mounted) {
                          Navigator.pop(context); // cerrar loader
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(producto: productoDetalle),
                            ),
                          );
                        }
                      } catch (e) {
                        Navigator.pop(context); // cerrar loader
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error al cargar producto: $e")),
                        );
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://rosybrown-ape-589569.hostingersite.com/uploads/${oferta.imagen}",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
