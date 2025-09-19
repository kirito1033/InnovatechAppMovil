import 'package:flutter/material.dart';
import '../widgets/registerwidget.dart';

// ---- THEME CENTRALIZADO ----
class AppTheme {
  static const Color primary = Color(0xFF00E5FF); // Cyan
  static const Color backgroundDark = Color.fromRGBO(2, 15, 31, 1);
  static const Color inputDark = Color(0xFF1F2937);

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputDark,
      hintStyle: const TextStyle(color: Colors.white70),
      labelStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: const Color.fromRGBO(11, 68, 84, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
  );
}

// ---- PANTALLA DE REGISTRO ----
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController secondLastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController documentController = TextEditingController();
  final TextEditingController phone1Controller = TextEditingController();
  final TextEditingController phone2Controller = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? documentType;
  String? city;

  void _register() {
    print("Registrado: ${firstNameController.text} ${lastNameController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Logo
                Image.asset(
                  "assets/logo/logo_inn.jpg",
                  height: 200,
                ),
                const SizedBox(height: 20),

                // Título
                Text(
                  "Registro de Usuario",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 30),

                // Campos
                CustomTextField(hint: "Primer Nombre", controller: firstNameController),
                const SizedBox(height: 16),
                CustomTextField(hint: "Segundo Nombre", controller: secondNameController),
                const SizedBox(height: 16),
                CustomTextField(hint: "Primer Apellido", controller: lastNameController),
                const SizedBox(height: 16),
                CustomTextField(hint: "Segundo Apellido", controller: secondLastNameController),
                const SizedBox(height: 16),
                CustomTextField(hint: "Correo Electrónico", controller: emailController),
                const SizedBox(height: 16),
                CustomTextField(hint: "Documento", controller: documentController),
                const SizedBox(height: 16),

                // Selector de tipo de documento
                DropdownButtonFormField<String>(
                  value: documentType,
                  decoration: const InputDecoration(
                    labelText: "Tipo de Documento",
                  ),
                  dropdownColor: AppTheme.inputDark,
                  items: ["DNI", "Pasaporte", "Cédula"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => documentType = value),
                ),
                const SizedBox(height: 16),

                CustomTextField(hint: "Teléfono 1", controller: phone1Controller),
                const SizedBox(height: 16),
                CustomTextField(hint: "Teléfono 2", controller: phone2Controller),
                const SizedBox(height: 16),
                CustomTextField(hint: "Dirección", controller: addressController),
                const SizedBox(height: 16),

                // Selector de ciudad
                DropdownButtonFormField<String>(
                  value: city,
                  decoration: const InputDecoration(
                    labelText: "Ciudad",
                  ),
                  dropdownColor: AppTheme.inputDark,
                  items: ["Ciudad 1", "Ciudad 2", "Ciudad 3"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => city = value),
                ),
                const SizedBox(height: 16),
                CustomTextField(hint: "Usuario", controller: usernameController),
                const SizedBox(height: 16),
                CustomTextField(hint: "Contraseña", controller: passwordController, isPassword: true),
                const SizedBox(height: 30),

                // Botón
                ElevatedButton(
                  onPressed: _register,
                  child: const Text("Registrarse"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}