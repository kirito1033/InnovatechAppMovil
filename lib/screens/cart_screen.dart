import 'package:flutter/material.dart';
import '../widgets/appbar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Lista simulada de productos
  final List<Map<String, dynamic>> _productos = [
    {
      "id": 1,
      "nombre": "Laptop InovaTech",
      "descripcion": "Portátil potente para trabajo y estudio",
      "precio": 3500000,
      "cantidad": 1,
      "imagen": "assets/img/laptop.png"
    },
    {
      "id": 2,
      "nombre": "Mouse Gamer",
      "descripcion": "Ergonómico con luces RGB",
      "precio": 120000,
      "cantidad": 2,
      "imagen": "assets/img/mouse.png"
    }
  ];

  void _cambiarCantidad(int index, int delta) {
    setState(() {
      int nuevaCantidad = _productos[index]["cantidad"] + delta;
      if (nuevaCantidad > 0) {
        _productos[index]["cantidad"] = nuevaCantidad;
      }
    });
  }

  void _eliminarProducto(int index) {
    setState(() {
      _productos.removeAt(index);
    });
  }

  double get _subtotal {
    double total = 0;
    for (var p in _productos) {
      total += p["precio"] * p["cantidad"];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _productos.isEmpty
            ? Center(
                child: Text(
                  "🛒 Aún no tienes productos en tu carrito",
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _productos.length,
                      itemBuilder: (context, index) {
                        final producto = _productos[index];
                        return Card(
                          color: theme.colorScheme.surface,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    producto["imagen"],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        producto["nombre"],
                                        style: theme.textTheme.titleLarge,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        producto["descripcion"],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "\$${producto["precio"]} x ${producto["cantidad"]}",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            color: theme.colorScheme.primary,
                                            onPressed: () =>
                                                _cambiarCantidad(index, -1),
                                          ),
                                          Text(
                                            producto["cantidad"].toString(),
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            color: theme.colorScheme.primary,
                                            onPressed: () =>
                                                _cambiarCantidad(index, 1),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: theme.colorScheme.error,
                                  onPressed: () => _eliminarProducto(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Subtotal: \$${_subtotal.toStringAsFixed(0)}",
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Procesando pago..."),
                              ),
                            );
                          },
                          icon: const Icon(Icons.payment),
                          label: const Text("Pagar"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
