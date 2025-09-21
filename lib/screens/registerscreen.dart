import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../models/ciudad_model.dart';
import '../models/tipo_documento_model.dart';

// Custom TextField con validación y mensaje debajo personalizado
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isPassword;
  final bool isError;
  final bool isValid;
  final String? errorMessage; // Añadido para el mensaje de error dinámico
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.isPassword = false,
    this.isError = false,
    this.isValid = false,
    this.errorMessage, // Añadido al constructor
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    if (isError) {
      borderColor = Colors.red;
    } else if (isValid) {
      borderColor = Colors.green;
    } else {
      borderColor = Colors.grey;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.appBarBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        // Muestra el mensaje de error personalizado si existe
        if (isError && errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4),
            child: Text(
              errorMessage!,
              style: TextStyle(color: Colors.red[300], fontSize: 12),
            ),
          ),
      ],
    );
  }
}

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

  List<TipoDocumento> tiposDocumento = [];
  bool isLoadingDocs = true;
  bool isRegistering = false;

  Map<String, String?> _fieldValidationStatus = {};

  @override
  void initState() {
    super.initState();
    _loadTiposDocumento();

    // Listeners de validación en tiempo real
    firstNameController.addListener(() => _validateField("Primer Nombre", firstNameController.text));
    lastNameController.addListener(() => _validateField("Primer Apellido", lastNameController.text));
    emailController.addListener(() => _validateField("Correo Electrónico", emailController.text));
    usernameController.addListener(() => _validateField("Usuario", usernameController.text));
    passwordController.addListener(() => _validateField("Contraseña", passwordController.text));
    documentController.addListener(() => _validateField("Documento", documentController.text));
    phone1Controller.addListener(() => _validateField("Teléfono 1", phone1Controller.text));
    addressController.addListener(() => _validateField("Dirección", addressController.text));
  }

  Future<void> _loadTiposDocumento() async {
    try {
      final docs = await ApiService.getTiposDocumento();
      setState(() {
        tiposDocumento = docs;
        isLoadingDocs = false;
      });
    } catch (e) {
      print("Error cargando tipos de documento: $e");
      setState(() {
        isLoadingDocs = false;
      });
    }
  }

  // Lógica de validación con mensajes de error específicos
  void _validateField(String field, String value) {
    String? status;

    switch (field) {
      case "Primer Nombre":
      case "Primer Apellido":
        if (value.isEmpty) {
          status = null;
        } else {
          status = value.length > 2 ? "valid" : "Debe tener más de 2 caracteres";
        }
        break;

      case "Documento":
      case "Teléfono 1":
      case "Dirección":
        status = value.isEmpty ? null : "valid";
        break;

      case "Correo Electrónico":
        status = value.isEmpty ? null : (_validateEmail(value) ? "valid" : "El formato del correo no es válido");
        break;

      case "Usuario":
        status = value.isEmpty ? null : (value.length >= 4 && value.length <= 12 ? "valid" : "Debe tener entre 4 y 12 caracteres");
        break;

      case "Contraseña":
        if (value.isEmpty) {
          status = null;
        } else if (value.length < 8 || value.length > 16) {
          status = "Debe tener entre 8 y 16 caracteres";
        } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
          status = "Debe incluir al menos una mayúscula (A-Z)";
        } else if (!RegExp(r'[a-z]').hasMatch(value)) {
          status = "Debe incluir al menos una minúscula (a-z)";
        } else if (!RegExp(r'[0-9]').hasMatch(value)) {
          status = "Debe incluir al menos un número (0-9)";
        } else if (!RegExp(r'[\W_]').hasMatch(value)) {
          status = "Debe incluir un caracter especial (ej. !@#\$%)";
        } else if (value.contains(' ')) {
          status = "No puede contener espacios";
        } else {
          status = "valid";
        }
        break;
    }

    setState(() {
      _fieldValidationStatus[field] = status;
    });
  }


  bool _validateEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return regex.hasMatch(email);
  }

  bool _validateForm() {
    List<String> requiredFields = [
      "Primer Nombre",
      "Primer Apellido",
      "Correo Electrónico",
      "Documento",
      "Teléfono 1",
      "Dirección",
      "Usuario",
      "Contraseña",
    ];

    for (var field in requiredFields) {
      if (_fieldValidationStatus[field] != "valid") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Revisa el campo: $field")),
        );
        return false;
      }
    }

    if (documentType == null || city == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seleccione tipo de documento y ciudad")),
      );
      return false;
    }

    return true;
  }

  Future<void> _register() async {
    if (!_validateForm()) return;

    final userData = {
      "primer_nombre": firstNameController.text.trim(),
      "segundo_nombre": secondNameController.text.trim(),
      "primer_apellido": lastNameController.text.trim(),
      "segundo_apellido": secondLastNameController.text.trim(),
      "documento": documentController.text.trim(),
      "correo": emailController.text.trim(),
      "telefono1": phone1Controller.text.trim(),
      "telefono2": phone2Controller.text.trim(),
      "direccion": addressController.text.trim(),
      "usuario": usernameController.text.trim(),
      "password": passwordController.text.trim(),
      "tipo_documento_id": documentType,
      "ciudad_id": city,
      "rol_id": "1",
      "estado_usuario_id": "1"
    };

    setState(() => isRegistering = true);

    try {
      await ApiService.registerUser(userData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario registrado con éxito")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isRegistering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBarBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Image.asset("assets/img/logo_inn.jpg", height: 200),
                const SizedBox(height: 20),
                Text(
                  "Registro de Usuario",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 30),

                CustomTextField(
                  hint: "Primer Nombre",
                  controller: firstNameController,
                  isValid: _fieldValidationStatus["Primer Nombre"] == "valid",
                  isError: _fieldValidationStatus["Primer Nombre"] != null && _fieldValidationStatus["Primer Nombre"] != "valid",
                  errorMessage: _fieldValidationStatus["Primer Nombre"],
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  hint: "Segundo Nombre",
                  controller: secondNameController,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  hint: "Primer Apellido",
                  controller: lastNameController,
                  isValid: _fieldValidationStatus["Primer Apellido"] == "valid",
                  isError: _fieldValidationStatus["Primer Apellido"] != null && _fieldValidationStatus["Primer Apellido"] != "valid",
                  errorMessage: _fieldValidationStatus["Primer Apellido"],
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  hint: "Segundo Apellido",
                  controller: secondLastNameController,
                ),
                const SizedBox(height: 16),

                isLoadingDocs
                    ? const CircularProgressIndicator()
                    : DropdownSearch<TipoDocumento>(
                        items: tiposDocumento,
                        itemAsString: (td) => td.nom,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(labelText: "Tipo de Documento"),
                        ),
                        onChanged: (value) => setState(() => documentType = value?.id.toString()),
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Buscar tipo de documento...",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          fit: FlexFit.loose,
                        ),
                      ),
                const SizedBox(height: 16),

                CustomTextField(
                  hint: "Número de Documento",
                  controller: documentController,
                  isValid: _fieldValidationStatus["Documento"] == "valid",
                  isError: _fieldValidationStatus["Documento"] != null && _fieldValidationStatus["Documento"] != "valid",
                  errorMessage: _fieldValidationStatus["Documento"],
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  hint: "Correo Electrónico",
                  controller: emailController,
                  isValid: _fieldValidationStatus["Correo Electrónico"] == "valid",
                  isError: _fieldValidationStatus["Correo Electrónico"] != null && _fieldValidationStatus["Correo Electrónico"] != "valid",
                  errorMessage: _fieldValidationStatus["Correo Electrónico"],
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  hint: "Teléfono 1",
                  controller: phone1Controller,
                  isValid: _fieldValidationStatus["Teléfono 1"] == "valid",
                  isError: _fieldValidationStatus["Teléfono 1"] != null && _fieldValidationStatus["Teléfono 1"] != "valid",
                  errorMessage: _fieldValidationStatus["Teléfono 1"],
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  hint: "Teléfono 2",
                  controller: phone2Controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  hint: "Dirección",
                  controller: addressController,
                  isValid: _fieldValidationStatus["Dirección"] == "valid",
                  isError: _fieldValidationStatus["Dirección"] != null && _fieldValidationStatus["Dirección"] != "valid",
                  errorMessage: _fieldValidationStatus["Dirección"],
                ),
                const SizedBox(height: 16),

                DropdownSearch<Ciudad>(
                  asyncItems: (String? filter) async {
                    final allCities = await ApiService.getCiudades();
                    if (filter == null || filter.isEmpty) return allCities;
                    return allCities
                        .where((c) => c.name.toLowerCase().contains(filter.toLowerCase()))
                        .toList();
                  },
                  itemAsString: (Ciudad c) => "${c.name} - ${c.department}",
                  onChanged: (value) => setState(() => city = value?.id.toString()),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(labelText: "Ciudad"),
                  ),
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: "Buscar ciudad...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    fit: FlexFit.loose,
                  ),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  hint: "Usuario",
                  controller: usernameController,
                  isValid: _fieldValidationStatus["Usuario"] == "valid",
                  isError: _fieldValidationStatus["Usuario"] != null && _fieldValidationStatus["Usuario"] != "valid",
                  errorMessage: _fieldValidationStatus["Usuario"],
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  hint: "Contraseña",
                  controller: passwordController,
                  isPassword: true,
                  isValid: _fieldValidationStatus["Contraseña"] == "valid",
                  isError: _fieldValidationStatus["Contraseña"] != null && _fieldValidationStatus["Contraseña"] != "valid",
                  errorMessage: _fieldValidationStatus["Contraseña"],
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: isRegistering ? null : _register,
                  child: isRegistering
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Registrarse"),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Regresar al Login",
                      style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}