import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/custom_drawer.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController segundoNombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController segundoApellidoController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController documentoController = TextEditingController();
  final TextEditingController telefono1Controller = TextEditingController();
  final TextEditingController telefono2Controller = TextEditingController();
  final TextEditingController direccionController = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() { _loading = true; });

    final userId = await AuthService.getUserId();
    if (userId != null) {
      final userData = await AuthService.getUserDataFromBackend(userId);
      if (userData != null) {
        setState(() {
          nombreController.text = userData['primer_nombre'] ?? '';
          segundoNombreController.text = userData['segundo_nombre'] ?? '';
          apellidoController.text = userData['primer_apellido'] ?? '';
          segundoApellidoController.text = userData['segundo_apellido'] ?? '';
          usuarioController.text = userData['usuario'] ?? '';
          correoController.text = userData['correo'] ?? '';
          documentoController.text = userData['documento']?.toString() ?? '';
          telefono1Controller.text = userData['telefono1'] ?? '';
          telefono2Controller.text = userData['telefono2'] ?? '';
          direccionController.text = userData['direccion'] ?? '';
        });
      }
    }

    setState(() { _loading = false; });
  }

  Future<void> _saveUserData() async {
    setState(() { _loading = true; });

    final updated = await AuthService.updateUserData({
      'primer_nombre': nombreController.text,
      'segundo_nombre': segundoNombreController.text,
      'primer_apellido': apellidoController.text,
      'segundo_apellido': segundoApellidoController.text,
      'usuario': usuarioController.text,
      'correo': correoController.text,
      // 'documento': documentoController.text, // Por lo general, no se deja editar el documento
      'telefono1': telefono1Controller.text,
      'telefono2': telefono2Controller.text,
      'direccion': direccionController.text,
    });

    setState(() { _loading = false; });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
        updated ? "Cambios guardados" : "No se pudo actualizar el perfil"
      )),
    );
    if (updated) _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: const CustomAppBar(),
      endDrawer: const CustomDrawer(currentIndex: 1),
      bottomNavigationBar: CustomBottomNavBar(scaffoldKey: _scaffoldKey),
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
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

                // Campos de perfil
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

                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                      ),
                      onPressed: () { _loadUserData(); },
                      child: Text("Cancelar", style: TextStyle(color: theme.colorScheme.onSecondary)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                      ),
                      onPressed: _saveUserData,
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

  @override
  void dispose() {
    nombreController.dispose();
    segundoNombreController.dispose();
    apellidoController.dispose();
    segundoApellidoController.dispose();
    usuarioController.dispose();
    correoController.dispose();
    documentoController.dispose();
    telefono1Controller.dispose();
    telefono2Controller.dispose();
    direccionController.dispose();
    super.dispose();
  }
}
