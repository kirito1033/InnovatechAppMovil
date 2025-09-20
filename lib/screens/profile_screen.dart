import 'package:flutter/material.dart';

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Avatar
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: const AssetImage("assets/avatar.png"), // Cambia por tu imagen
                  backgroundColor: Colors.grey.shade300,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Campos
          _buildTextField("Primer Nombre", nombreController),
          _buildTextField("Segundo Nombre", segundoNombreController),
          _buildTextField("Primer Apellido", apellidoController),
          _buildTextField("Segundo Apellido", segundoApellidoController),
          _buildTextField("Nombre de Usuario", usuarioController),
          _buildTextField("Correo Electrónico", correoController, keyboardType: TextInputType.emailAddress),
          _buildTextField("Documento", documentoController, enabled: false),
          _buildTextField("Primer Teléfono", telefono1Controller, keyboardType: TextInputType.phone),
          _buildTextField("Segundo Teléfono", telefono2Controller, keyboardType: TextInputType.phone),
          _buildTextField("Dirección", direccionController),

          const SizedBox(height: 20),

          // Botones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade600),
                onPressed: () {
                  // simplemente resetea valores de ejemplo
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
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () {
                  // TODO: Guardar cambios en API
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Cambios guardados")),
                  );
                },
                child: const Text("Guardar Cambios"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.teal),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.teal, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}