import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/about_screen.dart';
import 'screens/registerscreen.dart';
import 'screens/change_password_screen.dart';
import 'screens/pqrsscreens.dart';
import 'theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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

    // ✅ Verificamos si hay un enlace al iniciar
    final Uri? initialLink = await _appLinks.getInitialAppLink();
    if (initialLink != null) {
      _handleDeepLink(initialLink);
    }

    // ✅ Escuchamos enlaces mientras la app está abierta
    _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    debugPrint("📩 Deep link recibido: $uri");

    if (uri.host == 'restablecer-password') {
      final token = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
      debugPrint("🔑 Token recibido: $token");

      if (token.isNotEmpty) {
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
      navigatorKey: navigatorKey,
      home: const SplashScreen(), // ✅ Solo renderiza el SplashScreen al inicio
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/about': (context) => const AboutScreen(),
        '/pqrs': (context) => const PqrsScreen(),
        '/reset-password': (context) {
          final token = ModalRoute.of(context)!.settings.arguments as String;
          return ChangePasswordScreen(token: token);
        },
      },
    );
  }
}
