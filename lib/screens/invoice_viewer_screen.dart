import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InvoiceViewerScreen extends StatefulWidget {
  final String numero;
  final String referenceCode;

  const InvoiceViewerScreen({
    super.key,
    required this.numero,
    required this.referenceCode,
  });

  @override
  State<InvoiceViewerScreen> createState() => _InvoiceViewerScreenState();
}

class _InvoiceViewerScreenState extends State<InvoiceViewerScreen> {
  late WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isDownloading = false;
  int _loadAttempts = 0;
  static const int _maxLoadAttempts = 2;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    
    // Timeout de seguridad - si después de 15 segundos sigue cargando, mostrar error
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    });
  }

  void _initializeWebView() {
    // URL del PDF original
    final pdfUrl = 'https://innovatech-mvc-v-2-0.onrender.com/facturas/pdf/${widget.numero}';
    
    // Usar Google Docs Viewer para mejor compatibilidad
    final viewerUrl = 'https://docs.google.com/viewer?url=${Uri.encodeComponent(pdfUrl)}&embedded=true';
    
    print("📄 Cargando factura: $viewerUrl");

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print("🔄 Iniciando carga: $url");
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            }
          },
          onPageFinished: (String url) {
            print("✅ Página cargada: $url");
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            print("❌ Error al cargar: ${error.description}");
            _loadAttempts++;
            
            if (mounted) {
              setState(() {
                _isLoading = false;
                if (_loadAttempts >= _maxLoadAttempts) {
                  _hasError = true;
                }
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            print("🔗 Navegación solicitada: ${request.url}");
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(viewerUrl));
  }

  // Abrir en navegador externo
  Future<void> _openInBrowser() async {
    final url = Uri.parse('https://innovatech-mvc-v-2-0.onrender.com/facturas/pdf/${widget.numero}');
    
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('No se puede abrir la URL');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error al abrir navegador: $e")),
        );
      }
    }
  }

  // Descargar factura
  Future<void> _downloadInvoice() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    final url = Uri.parse('https://innovatech-mvc-v-2-0.onrender.com/facturas/pdf/${widget.numero}');
    
    try {
      // Mostrar mensaje de inicio de descarga
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Text("Iniciando descarga..."),
              ],
            ),
            backgroundColor: Color(0xFF04b3b3),
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Abrir el PDF con la opción de descarga
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication, // Abre en navegador/visor que permite descargar
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Abriendo PDF para descarga..."),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        throw Exception('No se puede abrir la URL');
      }
    } catch (e) {
      print("❌ Error al descargar: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Error al descargar: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Factura",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.numero,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF04b3b3),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Botón de descarga
          IconButton(
            icon: _isDownloading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.download),
            tooltip: "Descargar factura",
            onPressed: _isDownloading ? null : _downloadInvoice,
          ),
          // Botón de recargar
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Recargar",
            onPressed: () {
              setState(() {
                _loadAttempts = 0;
                _hasError = false;
              });
              _initializeWebView();
            },
          ),
          // Botón de abrir en navegador
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            tooltip: "Abrir en navegador",
            onPressed: _openInBrowser,
          ),
        ],
      ),
      body: Stack(
        children: [
          // WebView
          if (!_hasError)
            WebViewWidget(controller: _controller),

          // Error state
          if (_hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Error al cargar la factura",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "El PDF está tardando demasiado en cargar",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _loadAttempts = 0;
                              _hasError = false;
                            });
                            _initializeWebView();
                          },
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text(
                            "Reintentar",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF04b3b3),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: _openInBrowser,
                          icon: const Icon(Icons.open_in_browser),
                          label: const Text("Abrir\nen navegador"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF04b3b3),
                            side: const BorderSide(color: Color(0xFF04b3b3)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Loading indicator (SIN el botón de "¿Tarda mucho?")
          if (_isLoading && !_hasError)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFF04b3b3),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Cargando factura...",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Esto puede tardar unos segundos",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
