import 'package:flutter/material.dart';
import '../widgets/pqrswidget.dart';
import '../widgets/appbar.dart';
import '../widgets/bottom_navbar.dart';

class PqrsScreen extends StatefulWidget {
  const PqrsScreen({super.key});

  @override
  State<PqrsScreen> createState() => _PqrsScreenState();
}

class _PqrsScreenState extends State<PqrsScreen> {
  String? selectedType;
  final TextEditingController descriptionController = TextEditingController();

  final List<String> pqrsTypes = [
    "Petición",
    "Queja",
    "Reclamo",
    "Sugerencia"
  ];

  void _sendPQRS() {
    print("Tipo: $selectedType");
    print("Descripción: ${descriptionController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black54),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                      dropdownColor: const Color(0xFF1F2937),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Tipo de PQRS",
                      ),
                      value: selectedType,
                      items: pqrsTypes
                          .map((type) =>
                              DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedType = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    PqrsTextField(
                      hint: "Descripción",
                      controller: descriptionController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _sendPQRS,
                      child: const Text("Enviar PQRS"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.cyan.withOpacity(0.2),
              child: SizedBox(
                height: 150,
                child: Center(
                  child: Text(
                    "No hay PQRS disponibles",
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
