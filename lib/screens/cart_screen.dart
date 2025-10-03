import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../services/base_url.dart';
import '../widgets/appbar.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/custom_drawer.dart';
import '../models/cart_model.dart';
import '../services/cart_service.dart';
import '../services/auth_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const String baseUrl = BaseUrlService.baseUrl;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<CartResponse> _futureCart;
  final NumberFormat _currencyFormatter = NumberFormat("#,###", "es_CO");

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final userId = await AuthService.getUserId();
    if (userId != null) {
      setState(() {
        _futureCart = CartService.fetchCart(userId);
      });
    }
  }

  Future<void> _removeProductFromCart(int productoId) async {
    final userId = await AuthService.getUserId();
    if (userId == null) return;

    try {
      await CartService.removeFromCart(usuarioId: userId, productoId: productoId);
      _loadCart();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error al eliminar: $e")),
      );
    }
  }

  Future<void> _updateQuantity(int productoId, int cantidad) async {
    final userId = await AuthService.getUserId();
    if (userId == null) return;

    try {
      await CartService.updateQuantity(
          usuarioId: userId, productoId: productoId, cantidad: cantidad);
      _loadCart();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error al actualizar cantidad: $e")),
      );
    }
  }

  // 🔹 Generar HTML del formulario PayU
  String generatePayUForm(Map<String, dynamic> data) {
    return """
    <html>
      <body onload="document.forms[0].submit()">
        <form method="post" action="${data['urlPayU']}">
          <input type="hidden" name="merchantId" value="${data['merchantId']}"/>
          <input type="hidden" name="accountId" value="${data['accountId']}"/>
          <input type="hidden" name="description" value="Compra en mi tienda"/>
          <input type="hidden" name="referenceCode" value="${data['referenceCode']}"/>
          <input type="hidden" name="amount" value="${data['amount']}"/>
          <input type="hidden" name="tax" value="0"/>
          <input type="hidden" name="taxReturnBase" value="0"/>
          <input type="hidden" name="currency" value="${data['currency']}"/>
          <input type="hidden" name="signature" value="${data['signature']}"/>
          <input type="hidden" name="test" value="1"/>
          <input type="hidden" name="buyerEmail" value="${data['email']}"/>
        </form>
      </body>
    </html>
    """;
  }

  // 🔹 Función para vaciar carrito desde Flutter
  Future<void> _clearCart(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/productos/carrito/clear'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'usuario_id': userId}),
      );
      if (response.statusCode == 200) {
        print("Carrito vaciado correctamente");
        _loadCart();
      } else {
        print("Error al vaciar carrito: ${response.body}");
      }
    } catch (e) {
      print("Error al vaciar carrito: $e");
    }
  }

  // 🔹 Función para iniciar pago
  Future<void> _startPayUProcess() async {
    final userId = await AuthService.getUserId();
    final email = "so1959373@gmail.com";
    if (userId == null || email == null) return;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/productos/carrito/preparar-pago'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'usuario_id': userId, 'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final htmlForm = generatePayUForm(data);

        final controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (request) async {
                final url = request.url;
                if (url.contains("response")) {
                  if (url.contains("transactionState=4")) {
                    // ✅ Pago aprobado
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("✅ Pago aprobado")),
                    );

                    // 🔹 Borrar carrito en backend
                    await _clearCart(userId);

                    // 🔹 Volver a la pantalla del carrito
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("❌ Pago rechazado o cancelado")),
                    );
                    Navigator.pop(context);
                  }
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadHtmlString(htmlForm);

        // 🔹 Abrir WebView
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text("Procesar pago")),
              body: WebViewWidget(controller: controller),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error al preparar pago: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: const CustomAppBar(),
      endDrawer: const CustomDrawer(currentIndex: -1),
      bottomNavigationBar: CustomBottomNavBar(scaffoldKey: _scaffoldKey),
      body: FutureBuilder<CartResponse>(
        future: _futureCart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.productos.isEmpty) {
            // 🛒 Carrito vacío
            return Center(
              child: Text(
                "El carrito está vacío",
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              ),
            );
          }

          final cart = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.productos.length,
                  itemBuilder: (context, index) {
                    final producto = cart.productos[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 6,
                      shadowColor: Colors.blue.withOpacity(0.3),
                      child: Container(
                        height: 160,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                "https://rosybrown-ape-589569.hostingersite.com/uploads/${producto.imagen}",
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    producto.nom,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Precio: \$${_currencyFormatter.format(producto.precio)}",
                                    style: const TextStyle(
                                        color: Color(0xFF0f838c),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline,
                                            color: Color(0xFF048d94), size: 28),
                                        onPressed: producto.cantidad > 1
                                            ? () => _updateQuantity(
                                                producto.productoId, producto.cantidad - 1)
                                            : null,
                                      ),
                                      Text(
                                        "${producto.cantidad}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline,
                                            color: Color(0xFF048d94), size: 28),
                                        onPressed: () => _updateQuantity(
                                            producto.productoId, producto.cantidad + 1),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent, size: 30),
                              onPressed: () => _removeProductFromCart(producto.productoId),
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
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, -2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Total: \$${_currencyFormatter.format(cart.totalGeneral)}",
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: const Color(0xFF0f838c),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: cart.totalGeneral > 0 ? _startPayUProcess : null,
                      icon: const Icon(Icons.payment),
                      label: const Text("Pagar"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF048d94),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
