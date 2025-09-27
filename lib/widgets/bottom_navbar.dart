import 'package:flutter/material.dart';
import '/widgets/custom_drawer.dart';
import '../screens/busqueda_screen.dart';
import '../screens/home_screen.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;
  static const Color navBarColor = Color.fromARGB(255, 2, 15, 31);
  static const Duration animDuration = Duration(milliseconds: 250);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context)?.settings.name;

    // Detecta en qué ruta estás y ajusta el índice seleccionado
    if (route?.contains('home') ?? false) {
      _selectedIndex = 0;
    } else if (route?.contains('busqueda') ?? false) {
      _selectedIndex = 2;
    }
  }

  Future<void> _showPreloadAndNavigate(BuildContext context, Widget page,
      {bool removeStack = false}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF048d94)),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 800));

    if (context.mounted) {
      Navigator.pop(context);

      if (removeStack) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => page,
            settings: const RouteSettings(name: 'home'),
          ),
          (route) => false,
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => page,
            settings: const RouteSettings(name: 'busqueda'),
          ),
        );
      }
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == _selectedIndex) return; // 👈 Evita recargar si ya está seleccionado

    setState(() {
      _selectedIndex = index;
    });

    if (index == 4) {
      Scaffold.of(context).openEndDrawer();
    } else if (index == 0) {
      _showPreloadAndNavigate(context, const HomeScreen(), removeStack: true);
    } else if (index == 2) {
      _showPreloadAndNavigate(
        context,
        const BusquedaScreen(
          query: '',
          categoria: 'Ofertas',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (navContext) => AnimatedContainer(
        duration: animDuration,
        curve: Curves.easeInOut,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => _onItemTapped(navContext, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: navBarColor,
          selectedItemColor: const Color(0xFF04ebec),
          unselectedItemColor: Colors.white70,
          showUnselectedLabels: true,
          elevation: 8,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          selectedIconTheme: const IconThemeData(size: 30),
          unselectedIconTheme: const IconThemeData(size: 26),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Carrito",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer),
              label: "Ofertas",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Perfil",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: "Más",
            ),
          ],
        ),
      ),
    );
  }
}
