// archivo: lib/screens/login_screen.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/auth_service.dart';
import '../screens/reset_password_screen.dart';
// ignore: unused_import
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String usuario = '';
  String password = '';
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _acceptedTerms = false;

 Future<void> _login() async {
  if (!_acceptedTerms) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Debes aceptar las condiciones de uso"),
        backgroundColor: Colors.orange,
      ),
    );
    return;
  }

  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    final result = await AuthService.login(usuario, password);

    setState(() => _isLoading = false);

    if (result["success"]) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Login exitoso"),
      backgroundColor: Colors.green,
    ),
  );

  // Guardado ya hecho en AuthService.login()
  Navigator.pushReplacementNamed(context, '/home'); 
}
 else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${result["message"]}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}


  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "No se pudo abrir $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF0B4454),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: const Color(0xFF020F1F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/img/logo_inn.jpg', height: 160),
                      const SizedBox(height: 20),

                      const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          color: Color(0xFF04EBEC),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),

                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Usuario',
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
                            value == null || value.isEmpty ? 'El usuario es obligatorio' : null,
                        onSaved: (value) => usuario = value!,
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: const TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFF04EBEC)),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFF04EBEC), width: 2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'La contraseña es obligatoria' : null,
                        onSaved: (value) => password = value!,
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Checkbox(
                            value: _acceptedTerms,
                            activeColor: const Color(0xFF04EBEC),
                            onChanged: (value) {
                              setState(() {
                                _acceptedTerms = value ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                                children: [
                                  const TextSpan(text: "Aceptas las "),
                                  TextSpan(
                                    text: "Condiciones de uso ",
                                    style: const TextStyle(color: Color(0xFF04EBEC)),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _openUrl("https://innovatech-mvc-v-2-0.onrender.com/condiciones");
                                      },
                                  ),
                                  const TextSpan(text: "y el "),
                                  TextSpan(
                                    text: "Aviso de privacidad",
                                    style: const TextStyle(color: Color(0xFF04EBEC)),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _openUrl("https://innovatech-mvc-v-2-0.onrender.com/terminos");
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF04EBEC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Ingresar',
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                          );
                        },
                        child: const Text(
                          "¿Olvidaste tu contraseña?",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF04EBEC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Crear Cuenta',
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
