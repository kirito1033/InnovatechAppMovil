import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../screens/home_screen.dart';
import '../services/base_url.dart';
import '../services/factus_service.dart';
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
  Future<CartResponse>? _futureCart;
  final NumberFormat _currencyFormatter = NumberFormat("#,###", "es_CO");
  bool _paymentProcessed = false;
  bool _isLoadingCart = false;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    if (_isLoadingCart) return;
    
    setState(() {
      _isLoadingCart = true;
    });

    try {
      final userId = await AuthService.getUserId();
      if (userId != null && mounted) {
        setState(() {
          _futureCart = CartService.fetchCart(userId);
        });
      }
    } catch (e) {
      print("❌ Error al cargar carrito: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCart = false;
        });
      }
    }
  }

  Future<void> _removeProductFromCart(int productoId) async {
    final userId = await AuthService.getUserId();
    if (userId == null) return;

    try {
      await CartService.removeFromCart(usuarioId: userId, productoId: productoId);
      
      if (mounted) {
        _loadCart();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Producto eliminado del carrito"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al eliminar: $e")),
        );
      }
    }
  }

  Future<void> _updateQuantity(int productoId, int cantidad) async {
    final userId = await AuthService.getUserId();
    if (userId == null) return;

    try {
      await CartService.updateQuantity(
          usuarioId: userId, productoId: productoId, cantidad: cantidad);
      if (mounted) {
        _loadCart();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al actualizar cantidad: $e")),
        );
      }
    }
  }

  String generatePayUForm(Map<String, dynamic> data) {
    return """
    <html>
      <body onload="document.forms[0].submit()">
        <form method="post" action="${data['urlPayU']}">
          <input type="hidden" name="merchantId" value="${data['merchantId']}"/>
          <input type="hidden" name="accountId" value="${data['accountId']}"/>
          <input type="hidden" name="description" value="${data['description']}"/>
          <input type="hidden" name="referenceCode" value="${data['referenceCode']}"/>
          <input type="hidden" name="amount" value="${data['amount']}"/>
          <input type="hidden" name="tax" value="${data['tax']}"/>
          <input type="hidden" name="taxReturnBase" value="${data['taxReturnBase']}"/>
          <input type="hidden" name="currency" value="${data['currency']}"/>
          <input type="hidden" name="signature" value="${data['signature']}"/>
          <input type="hidden" name="test" value="${data['test']}"/>
          <input type="hidden" name="buyerEmail" value="${data['email']}"/>
          <input type="hidden" name="responseUrl" value="${data['responseUrl']}"/>
          <input type="hidden" name="confirmationUrl" value="${data['confirmationUrl']}"/>
        </form>
      </body>
    </html>
    """;
  }

  Future<void> _clearCart(int userId) async {
    try {
      print("Vaciando carrito...");
      await CartService.clearCart(userId);
      print("Carrito vaciado correctamente");
      
      if (mounted) {
        await _loadCart();
      }
    } catch (e) {
      print("Error al vaciar carrito: $e");
      rethrow;
    }
  }

  void _navigateToHome() {
    if (!mounted) return;
    
    try {
      print("Navegando al Home...");
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } catch (e) {
      print("Error al navegar: $e");
      try {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } catch (e2) {
        print("Error alternativo: $e2");
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  void _showProcessingScreen(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF048d94)),
                    strokeWidth: 5,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF048d94),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _startPayUProcess() async {
    final userId = await AuthService.getUserId();
    
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario no identificado")),
        );
      }
      return;
    }

    try {
      final cartSnapshot = await _futureCart;
      if (cartSnapshot == null || cartSnapshot.productos.isEmpty) {
        throw Exception("El carrito está vacío");
      }

      final productos = cartSnapshot.productos.map((p) => {
        'productoId': p.productoId,
        'nombre': p.nom,
        'precio': p.precio,
        'cantidad': p.cantidad,
      }).toList();

      final datosCliente = await AuthService.getClienteDataForFactura();

      final response = await http.post(
        Uri.parse('$baseUrl/productos/carrito/preparar-pago'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario_id': userId, 
          'email': datosCliente['email'], // Email real del usuario
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final referenceCode = data['referenceCode'];
        final htmlForm = generatePayUForm(data);
        
        _paymentProcessed = false;

        final controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) async {
                
                if (url.contains("respuesta-pago") && !_paymentProcessed) {
                  _paymentProcessed = true;
                  
                  final uri = Uri.parse(url);
                  final transactionState = uri.queryParameters['transactionState'];
                  final amount = uri.queryParameters['TX_VALUE'];
                  
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                  
                  if (transactionState == '4') {
                    try {
                      if (mounted) {
                        _showProcessingScreen(context, "Generando factura electrónica...");
                      }

                      
                      final resultadoFactus = await FactusService.enviarFactura(
                        usuarioId: userId,
                        productos: productos,
                        datosCliente: datosCliente, // Datos reales del usuario
                        referenceCode: referenceCode,
                      );

                      String mensajeFinal;
                      Color colorMensaje;

                      if (resultadoFactus['success'] == true) {
                        final invoiceNumber = resultadoFactus['invoice_number'];
                        print("Factura Factus creada: $invoiceNumber");
                        mensajeFinal = "Pago aprobado\n Factura: $invoiceNumber";
                        colorMensaje = Colors.green;
                      } else {
                        print("Error en Factus: ${resultadoFactus['message']}");
                        mensajeFinal = "Pago aprobado\n Factura pendiente";
                        colorMensaje = Colors.orange;
                      }

                      await _clearCart(userId);
                      
                      if (mounted) {
                        Navigator.of(context).pop(); // Cerrar procesamiento
                      }

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(mensajeFinal),
                            backgroundColor: colorMensaje,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                        
                        await Future.delayed(const Duration(milliseconds: 500));
                        _navigateToHome();
                      }
                      
                    } catch (e) {
                      print("Error al procesar: $e");
                      
                      if (mounted) {
                        Navigator.of(context).pop(); // Cerrar procesamiento
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Pago aprobado\nError: ${e.toString()}"),
                            backgroundColor: Colors.orange,
                            duration: const Duration(seconds: 4),
                          ),
                        );
                        
                        await Future.delayed(const Duration(seconds: 2));
                        _navigateToHome();
                      }
                    }
                  } else if (transactionState == '6') {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Pago rechazado por el banco"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  } else if (transactionState == '7') {
                    // ⏳ PAGO PENDIENTE
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Pago pendiente de confirmación"),
                          backgroundColor: Colors.orange,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Error en la transacción"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                }
              },
              onNavigationRequest: (request) {
                print("Navegando a: ${request.url}");
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadHtmlString(htmlForm);

        if (mounted) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text("Procesar pago con PayU"),
                  backgroundColor: const Color(0xFF048d94),
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Pago cancelado por el usuario"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  ),
                ),
                body: WebViewWidget(controller: controller),
              ),
            ),
          );
        }
        
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error al preparar pago: ${response.body}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print("Error crítico: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Aún no has agregado productos",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Explora nuestro catálogo y agrega productos",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _navigateToHome,
            icon: const Icon(Icons.shopping_bag, color: Colors.white),
            label: const Text(
              "Explorar productos",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF048d94),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: const CustomAppBar(),
      endDrawer: const CustomDrawer(currentIndex: -1),
      bottomNavigationBar: CustomBottomNavBar(scaffoldKey: _scaffoldKey),
      body: _futureCart == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<CartResponse>(
              future: _futureCart,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } 
                
                if (snapshot.hasError) {
                  final errorMessage = snapshot.error.toString().toLowerCase();
                  
                  if (errorMessage.contains('404') || 
                      errorMessage.contains('no existe') ||
                      errorMessage.contains('vacío')) {
                    return _buildEmptyCart();
                  }
                  
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(
                          "Error al cargar el carrito",
                          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _loadCart,
                          child: const Text("Reintentar"),
                        ),
                      ],
                    ),
                  );
                } 
                
                if (!snapshot.hasData || snapshot.data!.productos.isEmpty) {
                  return _buildEmptyCart();
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
                                      "https://innovatech-mvc-v-2-0.onrender.com/uploads/${producto.imagen}",
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 90,
                                          height: 90,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image_not_supported),
                                        );
                                      },
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
                            icon: const Icon(Icons.payment, color: Colors.white),
                            label: const Text(
                              "Pagar con PayU",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF048d94),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
