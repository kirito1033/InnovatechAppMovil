import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/appbar.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/custom_drawer.dart';
import '../models/purchase_model.dart';
import '../services/purchase_service.dart';
import '../services/auth_service.dart';
import 'invoice_viewer_screen.dart'; // 🆕 Nuevo import

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({super.key});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<Purchase>>? _futurePurchases;
  final NumberFormat _currencyFormatter = NumberFormat("#,###", "es_CO");
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPurchases();
  }

  Future<void> _loadPurchases() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = await AuthService.getUserId();
      
      if (userId == null) {
        print("❌ Usuario no autenticado");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("⚠️ Sesión expirada. Inicia sesión nuevamente"),
              backgroundColor: Colors.orange,
            ),
          );
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }

      print("👤 Usuario logueado ID: $userId");

      if (mounted) {
        setState(() {
          _futurePurchases = PurchaseService.fetchPurchases(userId);
        });
      }
    } catch (e) {
      print("❌ Error al cargar compras: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al cargar compras: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// 🆕 Abre el PDF de la factura dentro de la app
  void _openPDF(String numero, String referenceCode) {
    if (numero.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Número de factura no disponible")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceViewerScreen(
          numero: numero,
          referenceCode: referenceCode,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No has realizado compras aún",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Cuando realices tu primera compra,\naparecerá aquí",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            icon: const Icon(Icons.shopping_bag, color: Colors.white),
            label: const Text(
              "Explorar productos",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF04b3b3),
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: const CustomAppBar(),
      endDrawer: const CustomDrawer(currentIndex: 4),
      bottomNavigationBar: CustomBottomNavBar(scaffoldKey: _scaffoldKey),
      body: _futurePurchases == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Purchase>>(
              future: _futurePurchases,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF04b3b3),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  final errorMessage = snapshot.error.toString().toLowerCase();
                  
                  if (errorMessage.contains('404') || 
                      errorMessage.contains('no existe') ||
                      errorMessage.contains('vacío')) {
                    return _buildEmptyState();
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(
                          "Error al cargar compras",
                          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadPurchases,
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text(
                            "Reintentar",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF04b3b3),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                final purchases = snapshot.data!;

                return RefreshIndicator(
                  onRefresh: _loadPurchases,
                  color: const Color(0xFF04b3b3),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF04ebec), Color(0xFF04b3b3)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "🧾 Historial de Compras",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0b4454),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${purchases.length} ${purchases.length == 1 ? 'compra' : 'compras'}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF0b4454),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: purchases.length,
                          itemBuilder: (context, index) {
                            final purchase = purchases[index];
                            return Card(
                              color: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoRow("Número:", purchase.numero),
                                    const SizedBox(height: 8),
                                    _buildInfoRow("Referencia:", purchase.referenceCode),
                                    const SizedBox(height: 8),
                                    _buildInfoRow(
                                      "Fecha:",
                                      DateFormat('yyyy-MM-dd HH:mm').format(purchase.createdAt),
                                    ),
                                    const SizedBox(height: 8),
                                    const Spacer(),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: purchase.numero.isNotEmpty
                                            ? () => _openPDF(purchase.numero, purchase.referenceCode)
                                            : null,
                                        icon: const Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        label: const Text(
                                          "Ver Factura",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: purchase.numero.isNotEmpty
                                              ? const Color(0xFF04b3b3)
                                              : Colors.grey,
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + " ",
          style: const TextStyle(
            color: Color(0xFF04b3b3),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0b4454),
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
