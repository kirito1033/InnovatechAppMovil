import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/oferta_model.dart';
import '../services/oferta_service.dart';

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
                    onTap: () {
                      // Navegar al detalle del producto
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(productId: oferta.productoId)))
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://rosybrown-ape-589569.hostingersite.com/uploads/${oferta.imagen}",
                        fit: BoxFit.cover,
                        width: double.infinity,
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
