import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/base_url.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String token;
  const ChangePasswordScreen({super.key, required this.token});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String nuevaPassword = '';
  bool _isLoading = false;

  Future<void> _cambiarPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      final response = await http.post(
        Uri.parse("${BaseUrlService.baseUrl}/usuario/restablecer-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "token": widget.token,
          "nuevaPassword": nuevaPassword,
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Contraseña actualizada correctamente"),
            backgroundColor: Colors.green,
          ),
        );

        // 👇 Redirigir al login después del cambio exitoso
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        final body = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(body["error"] ?? "❌ Error al actualizar contraseña"),
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
                        'Nueva contraseña',
                        style: TextStyle(
                          color: Color(0xFF04EBEC),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),

                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Nueva contraseña',
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
                            value == null || value.length < 6 ? 'Debe tener al menos 6 caracteres' : null,
                        onSaved: (value) => nuevaPassword = value!,
                      ),
                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _cambiarPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF04EBEC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Cambiar contraseña',
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                ),
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
