import 'package:flutter/material.dart';
import '../widgets/appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nombreController = TextEditingController(text: "Cliente");
  final TextEditingController segundoNombreController = TextEditingController(text: "Cliente2");
  final TextEditingController apellidoController = TextEditingController(text: "Apellido");
  final TextEditingController segundoApellidoController = TextEditingController(text: "Apellido2");
  final TextEditingController usuarioController = TextEditingController(text: "cliente");
  final TextEditingController correoController = TextEditingController(text: "cliente2@gmail.com");
  final TextEditingController documentoController = TextEditingController(text: "12321435565");
  final TextEditingController telefono1Controller = TextEditingController(text: "1242356666");
  final TextEditingController telefono2Controller = TextEditingController();
  final TextEditingController direccionController = TextEditingController(text: "calle 12, #31-85");

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: const AssetImage("assets/img/icon.png"),
                    backgroundColor: theme.colorScheme.surfaceVariant,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary,
                      child: Icon(Icons.camera_alt, color: theme.colorScheme.onPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Campos
            _buildTextField(context, "Primer Nombre", nombreController),
            _buildTextField(context, "Segundo Nombre", segundoNombreController),
            _buildTextField(context, "Primer Apellido", apellidoController),
            _buildTextField(context, "Segundo Apellido", segundoApellidoController),
            _buildTextField(context, "Nombre de Usuario", usuarioController),
            _buildTextField(context, "Correo Electrónico", correoController, keyboardType: TextInputType.emailAddress),
            _buildTextField(context, "Documento", documentoController, enabled: false),
            _buildTextField(context, "Primer Teléfono", telefono1Controller, keyboardType: TextInputType.phone),
            _buildTextField(context, "Segundo Teléfono", telefono2Controller, keyboardType: TextInputType.phone),
            _buildTextField(context, "Dirección", direccionController),

            const SizedBox(height: 20),

            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                  onPressed: () {
                    // 🔹 Resetear valores de ejemplo
                    setState(() {
                      nombreController.text = "Cliente";
                      segundoNombreController.text = "Cliente2";
                      apellidoController.text = "Apellido";
                      segundoApellidoController.text = "Apellido2";
                      usuarioController.text = "cliente";
                      correoController.text = "cliente2@gmail.com";
                      documentoController.text = "12321435565";
                      telefono1Controller.text = "1242356666";
                      telefono2Controller.clear();
                      direccionController.text = "calle 12, #31-85";
                    });
                  },
                  child: Text("Cancelar", style: TextStyle(color: theme.colorScheme.onSecondary)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    // 🔹 Guardar cambios (futuro API)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Cambios guardados")),
                    );
                  },
                  child: Text("Guardar Cambios", style: TextStyle(color: theme.colorScheme.onPrimary)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: theme.colorScheme.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}