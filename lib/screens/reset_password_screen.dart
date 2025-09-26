import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/base_url.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String correo = '';
  bool _isLoading = false;

  Future<void> _solicitarRestablecimiento() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse("${BaseUrlService.baseUrl}/usuario/solicitar-reset"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"correo": correo}),
        );

        setState(() => _isLoading = false);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Correo enviado con éxito. Revisa tu bandeja 📬"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Regresar al login
        } else {
          final body = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(body["error"] ?? "Error al enviar correo"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error de conexión: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B4454),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: const Color(0xFF020F1F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Recuperar contraseña',
                        style: TextStyle(
                          color: Color(0xFF04EBEC),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),

                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          labelStyle: const TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFF04EBEC)),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFF04EBEC), width: 2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'El correo es obligatorio' : null,
                        onSaved: (value) => correo = value!,
                      ),
                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _solicitarRestablecimiento,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF04EBEC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Enviar enlace',
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Volver al inicio de sesión",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
