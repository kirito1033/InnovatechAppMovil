import 'package:flutter/material.dart';
import '../models/producto_model.dart';
import '../services/producto.dart';
import '../widgets/appbar.dart';
import '../widgets/bottom_navbar.dart';
import 'product_detail_screen.dart';

class BusquedaScreen extends StatefulWidget {
  final String query;
  const BusquedaScreen({super.key, required this.query});

  @override
  State<BusquedaScreen> createState() => _BusquedaScreenState();
}

class _BusquedaScreenState extends State<BusquedaScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Producto>> productosFuture;

  // 🔹 Filtros seleccionados
  String? selectedColor;
  String? selectedMarca;
  String? selectedCategoria;
  String? selectedRam;
  String? selectedAlmacenamiento;
  String? selectedSO;
  String? selectedResolucion;
  double? precioMin;
  double? precioMax;

  static const Color appBarBackground = Color.fromARGB(255, 2, 15, 31);

  @override
  void initState() {
    super.initState();
    _buscarProductos();
  }

  void _buscarProductos() {
    setState(() {
      productosFuture = apiService.buscarProductos(
        widget.query,
        color: selectedColor,
        marca: selectedMarca,
        categoria: selectedCategoria,
        ram: selectedRam,
        almacenamiento: selectedAlmacenamiento,
        sistemaOperativo: selectedSO,
        resolucion: selectedResolucion,
        precioMin: precioMin,
        precioMax: precioMax,
      );
    });
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: appBarBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomBottomNavBar(),
      backgroundColor: appBarBackground,
      body: FutureBuilder<List<Producto>>(
        future: productosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF048d94)),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.white)),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // 🔹 Filtros
                DropdownButtonFormField<String>(
                  dropdownColor: appBarBackground,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Filtrar por color"),
                  value: selectedColor,
                  items: ["Rojo", "Negro", "Blanco", "Azul"]
                      .map((color) => DropdownMenuItem(
                            value: color,
                            child: Text(color),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedColor = value;
                    _buscarProductos();
                  },
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  dropdownColor: appBarBackground,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Filtrar por marca"),
                  value: selectedMarca,
                  items: ["Samsung", "Apple", "Xiaomi", "Huawei"]
                      .map((marca) => DropdownMenuItem(
                            value: marca,
                            child: Text(marca),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedMarca = value;
                    _buscarProductos();
                  },
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  dropdownColor: appBarBackground,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Filtrar por categoría"),
                  value: selectedCategoria,
                  items: ["Celulares", "Tablets", "Accesorios"]
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedCategoria = value;
                    _buscarProductos();
                  },
                ),
                const SizedBox(height: 8),

                // Filtros de precio
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration("Precio mínimo"),
                        keyboardType: TextInputType.number,
                        onSubmitted: (value) {
                          precioMin = double.tryParse(value);
                          _buscarProductos();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration("Precio máximo"),
                        keyboardType: TextInputType.number,
                        onSubmitted: (value) {
                          precioMax = double.tryParse(value);
                          _buscarProductos();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  dropdownColor: appBarBackground,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Filtrar por RAM"),
                  value: selectedRam,
                  items: ["4", "6", "8", "12"]
                      .map((ram) => DropdownMenuItem(
                            value: ram,
                            child: Text("$ram GB"),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedRam = value;
                    _buscarProductos();
                  },
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  dropdownColor: appBarBackground,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Filtrar por almacenamiento"),
                  value: selectedAlmacenamiento,
                  items: ["64", "128", "256", "512"]
                      .map((alm) => DropdownMenuItem(
                            value: alm,
                            child: Text("$alm GB"),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedAlmacenamiento = value;
                    _buscarProductos();
                  },
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  dropdownColor: appBarBackground,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Filtrar por sistema operativo"),
                  value: selectedSO,
                  items: ["Android", "iOS", "Windows"]
                      .map((so) => DropdownMenuItem(
                            value: so,
                            child: Text(so),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedSO = value;
                    _buscarProductos();
                  },
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  dropdownColor: appBarBackground,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Filtrar por resolución"),
                  value: selectedResolucion,
                  items: ["HD", "Full HD", "2K", "4K"]
                      .map((res) => DropdownMenuItem(
                            value: res,
                            child: Text(res),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedResolucion = value;
                    _buscarProductos();
                  },
                ),
                const SizedBox(height: 12),

                // 🔹 Resultados
                if (!snapshot.hasData || snapshot.data!.isEmpty)
                  const Center(
                    child: Text("No se encontraron productos",
                        style: TextStyle(color: Colors.white)),
                  )
                else
                  Column(
                    children: snapshot.data!.map((producto) {
                      return InkWell(
                          onTap: () async {
                            // 🔹 Mostrar preload
                            showDialog(
                              context: context,
                              barrierDismissible: false, // No cerrar al hacer tap afuera
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(color: Color(0xFF048d94)),
                              ),
                            );

                            // 🔹 Simulación de carga (puedes quitar el delay si no hace falta)
                            await Future.delayed(const Duration(seconds: 1));

                            // 🔹 Ir al detalle
                            Navigator.pop(context); // Cerrar el preload
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(producto: producto),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    "https://rosybrown-ape-589569.hostingersite.com/uploads/${producto.imagen}",
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          producto.nom,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "\$${producto.precio}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          producto.descripcion ?? "Sin descripción",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
