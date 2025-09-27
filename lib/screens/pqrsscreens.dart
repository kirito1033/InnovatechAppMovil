import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/bottom_navbar.dart';
import '../services/auth_service.dart';
import '../services/pqrs_service.dart';

class PqrsScreen extends StatefulWidget {
  const PqrsScreen({super.key});

  @override
  State<PqrsScreen> createState() => _PqrsScreenState();
}

class _PqrsScreenState extends State<PqrsScreen> {
  List<Map<String, dynamic>> userPqrs = [];
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descripcionController = TextEditingController();
  String _tipoSeleccionado = "Petición";

  @override
  void initState() {
    super.initState();
    _loadUserPqrs();
  }

  Future<void> _loadUserPqrs() async {
    try {
      final userId = await AuthService.getUserId();
      if (userId == null) {
        if (mounted) setState(() => isLoading = false);
        return;
      }

      final data = await PqrsService.getUserPqrs(userId);

      if (mounted) {
        setState(() {
          userPqrs = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  int _mapTipoToId(String tipo) {
    switch (tipo) {
      case "Queja":
        return 2;
      case "Reclamo":
        return 3;
      case "Sugerencia":
        return 4;
      default:
        return 1;
    }
  }

  Future<void> _crearPqrs() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = await AuthService.getUserId();
    if (userId == null) return;

    try {
      await PqrsService.createPqrs(
        descripcion: _descripcionController.text,
        tipoPqrsId: _mapTipoToId(_tipoSeleccionado),
        usuarioId: userId,
      );

      _descripcionController.clear();
      setState(() => _tipoSeleccionado = "Petición");

      await _loadUserPqrs();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ PQRS creada con éxito")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error creando PQRS: $e")),
        );
      }
    }
  }

  void _showPqrsDetails(Map<String, dynamic> pqrs) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 11, 68, 84),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Detalle de PQRS",
          style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailItem("ID", pqrs["id"].toString()),
            _detailItem("Descripción", pqrs["descripcion"] ?? ""),
            _detailItem("Tipo", pqrs["tipo_pqrs"] ?? ""),
            _detailItem("Estado", pqrs["estado_pqrs"] ?? ""),
            if (pqrs["created_at"] != null)
              _detailItem(
                "Fecha",
                "${DateTime.parse(pqrs["created_at"]).day}/${DateTime.parse(pqrs["created_at"]).month}/${DateTime.parse(pqrs["created_at"]).year}",
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar", style: TextStyle(color: Colors.cyan)),
          )
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        "$label: $value",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 68, 84),
      appBar: const CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: _loadUserPqrs,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🔹 Formulario
              Card(
                color: const Color(0xFF1F2937),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Formulario PQRS",
                          style: TextStyle(
                            color: Colors.cyan,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _tipoSeleccionado,
                          dropdownColor: const Color(0xFF1F2937),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF111827),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Tipo de PQRS",
                            labelStyle: const TextStyle(color: Colors.cyan),
                          ),
                          items: ["Petición", "Queja", "Reclamo", "Sugerencia"]
                              .map((tipo) => DropdownMenuItem(
                                    value: tipo,
                                    child: Text(tipo),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() => _tipoSeleccionado = val!);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descripcionController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF111827),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Descripción",
                            labelStyle: const TextStyle(color: Colors.cyan),
                          ),
                          maxLines: 3,
                          validator: (value) => value == null || value.isEmpty
                              ? "La descripción es obligatoria"
                              : null,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _crearPqrs,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.send),
                          label: const Text(
                            "Enviar PQRS",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 🔹 Tabla con PQRS
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (userPqrs.isEmpty)
                Card(
                  color: const Color(0xFF1F2937),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: const SizedBox(
                    height: 150,
                    child: Center(
                      child: Text(
                        "No hay PQRS disponibles",
                        style: TextStyle(
                          color: Colors.white54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor:
                        MaterialStateProperty.all(Colors.cyan.shade700),
                    dataRowColor:
                        MaterialStateProperty.all(const Color(0xFF1F2937)),
                    border: TableBorder.all(
                        color: Colors.cyan.withOpacity(0.3)),
                    columns: const [
                      DataColumn(label: Text("ID", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Descripción", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Tipo", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Estado", style: TextStyle(color: Colors.white))),
                      DataColumn(label: Text("Fecha", style: TextStyle(color: Colors.white))),
                    ],
                    rows: userPqrs.map((pqrs) {
                      final fecha = DateTime.tryParse(pqrs["created_at"] ?? "");
                      final fechaStr = fecha != null
                          ? "${fecha.day}/${fecha.month}/${fecha.year}"
                          : "N/A";

                      return DataRow(
                        cells: [
                          DataCell(Text(pqrs["id"].toString(),
                              style: const TextStyle(color: Colors.white)), onTap: () => _showPqrsDetails(pqrs)),
                          DataCell(Text(pqrs["descripcion"] ?? "",
                              style: const TextStyle(color: Colors.white)), onTap: () => _showPqrsDetails(pqrs)),
                          DataCell(Text(pqrs["tipo_pqrs"] ?? "",
                              style: const TextStyle(color: Colors.white)), onTap: () => _showPqrsDetails(pqrs)),
                          DataCell(Text(pqrs["estado_pqrs"] ?? "",
                              style: const TextStyle(color: Colors.white)), onTap: () => _showPqrsDetails(pqrs)),
                          DataCell(Text(fechaStr,
                              style: const TextStyle(color: Colors.white)), onTap: () => _showPqrsDetails(pqrs)),
                        ],
                      );
                    }).toList(),
                  ),
                ),

              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadUserPqrs,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text("Actualizar PQRS"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
