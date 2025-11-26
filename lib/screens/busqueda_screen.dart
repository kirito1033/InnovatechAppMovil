import 'package:flutter/material.dart';
import '../models/producto_model.dart';
import '../services/producto.dart';
import '../widgets/appbar.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/custom_drawer.dart';
import 'product_detail_screen.dart';

class BusquedaScreen extends StatefulWidget {
  final String query;
  final String? categoria;
  const BusquedaScreen({
    super.key,
    required this.query,
    this.categoria,
  });

  @override
  State<BusquedaScreen> createState() => _BusquedaScreenState();
}

class _BusquedaScreenState extends State<BusquedaScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  bool mostrarFiltros = false; // 👈 Nuevo: controla si los filtros están visibles

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
        categoria: widget.categoria ?? selectedCategoria ?? widget.query,
        color: selectedColor,
        marca: selectedMarca,
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
      fillColor: const Color.fromARGB(255, 11, 68, 84),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 11, 68, 84),
      appBar: const CustomAppBar(),
      endDrawer: const CustomDrawer(currentIndex: -1),
      bottomNavigationBar: CustomBottomNavBar(scaffoldKey: _scaffoldKey),

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

          final productos = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // 🔹 Botón para mostrar/ocultar filtros
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF048d94),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(
                      mostrarFiltros ? Icons.filter_alt_off : Icons.filter_alt,
                      color: Colors.white,
                    ),
                    label: Text(
                      mostrarFiltros ? "Ocultar filtros" : "Mostrar filtros",
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        mostrarFiltros = !mostrarFiltros;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // 🔹 Filtros (visibles solo si mostrarFiltros = true)
                if (mostrarFiltros)
                  Expanded(
                    flex: 0,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildDropdown(
                            label: "Color",
                            value: selectedColor,
                            items: ["Rojo", "Negro", "Blanco", "Azul"],
                            onChanged: (val) {
                              selectedColor = val;
                              _buscarProductos();
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildDropdown(
                            label: "Marca",
                            value: selectedMarca,
                            items: ["Samsung", "Apple", "Xiaomi", "Huawei"],
                            onChanged: (val) {
                              selectedMarca = val;
                              _buscarProductos();
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildDropdown(
                            label: "Categoría",
                            value: selectedCategoria,
                            items: ["Celulares", "Tablets", "Accesorios"],
                            onChanged: (val) {
                              selectedCategoria = val;
                              _buscarProductos();
                            },
                          ),
                          const SizedBox(height: 12),
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
                              const SizedBox(width: 12),
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
                          const SizedBox(height: 12),
                          _buildDropdown(
                            label: "RAM",
                            value: selectedRam,
                            items: ["4", "6", "8", "12"],
                            onChanged: (val) {
                              selectedRam = val;
                              _buscarProductos();
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildDropdown(
                            label: "Almacenamiento",
                            value: selectedAlmacenamiento,
                            items: ["64", "128", "256", "512"],
                            onChanged: (val) {
                              selectedAlmacenamiento = val;
                              _buscarProductos();
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildDropdown(
                            label: "Sistema operativo",
                            value: selectedSO,
                            items: ["Android", "iOS", "Windows"],
                            onChanged: (val) {
                              selectedSO = val;
                              _buscarProductos();
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildDropdown(
                            label: "Resolución",
                            value: selectedResolucion,
                            items: ["HD", "Full HD", "2K", "4K"],
                            onChanged: (val) {
                              selectedResolucion = val;
                              _buscarProductos();
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 12),

                // 🔹 Resultados
                Expanded(
                  flex: 1,
                  child: productos.isEmpty
                      ? const Center(
                          child: Text(
                            "No se encontraron productos",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: productos.length,
                          itemBuilder: (context, index) {
                            final producto = productos[index];
                            return InkWell(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: CircularProgressIndicator(
                                        color: Color(0xFF048d94)),
                                  ),
                                );

                                await Future.delayed(
                                    const Duration(milliseconds: 500));

                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailScreen(producto: producto),
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.white,
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        "https://innovatech-mvc-v-2-0.onrender.com/uploads/${producto.imagen}",
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              producto.descripcion ??
                                                  "Sin descripción",
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
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      dropdownColor: appBarBackground,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration("Filtrar por $label"),
      value: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
