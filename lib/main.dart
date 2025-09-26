import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/registerscreen.dart';
import 'screens/change_password_screen.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loggedIn = await AuthService.isLoggedIn();
  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatefulWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // ✅ Verificamos si hay un enlace al iniciar la app
    final Uri? initialLink = await _appLinks.getInitialAppLink();
    if (initialLink != null) {
      _handleDeepLink(initialLink);
    }

    // ✅ Escuchamos los enlaces que llegan mientras la app está abierta
    _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    debugPrint("📩 Deep link recibido: $uri");

    if (uri.host == 'restablecer-password') {
      // Extraemos el token desde la última parte del path
      final token = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
      debugPrint("🔑 Token recibido: $token");

      if (token.isNotEmpty) {
        // ✅ Usamos navigatorKey para evitar el error del contexto
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => ChangePasswordScreen(token: token),
          ),
        );
      } else {
        debugPrint("⚠️ No se encontró token en el enlace");
      }
    } else {
      debugPrint("❌ Host no reconocido: ${uri.host}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InovaTech',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      navigatorKey: navigatorKey, // ✅ Esto es clave para que Navigator funcione fuera del contexto
      home: widget.loggedIn ? const HomeScreen() : const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/reset-password': (context) {
          final token = ModalRoute.of(context)!.settings.arguments as String;
          return ChangePasswordScreen(token: token);
        },
      },
    );
  }
}
