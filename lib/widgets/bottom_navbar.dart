import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/busqueda_screen.dart';
import '../screens/profile_screen.dart';

class CustomBottomNavBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey; // ✅ para abrir el drawer desde cualquier vista

  const CustomBottomNavBar({super.key, required this.scaffoldKey});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;
  static const Duration animDuration = Duration(milliseconds: 250);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context)?.settings.name;

    if (route?.contains('home') ?? false) {
      _selectedIndex = 0;
    } else if (route?.contains('carrito') ?? false) {
      _selectedIndex = 1;
    } else if (route?.contains('busqueda') ?? false) {
      _selectedIndex = 2;
    } else if (route?.contains('perfil') ?? false) {
      _selectedIndex = 3;
    }
  }

  Future<void> _showPreloadAndNavigate(BuildContext context, Widget page,
      {bool removeStack = false, required String routeName}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
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
            settings: RouteSettings(name: routeName),
          ),
          (route) => false,
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => page,
            settings: RouteSettings(name: routeName),
          ),
        );
      }
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        _showPreloadAndNavigate(context, const HomeScreen(),
            removeStack: true, routeName: 'home');
        break;
      case 1:
        _showPreloadAndNavigate(context, const CartScreen(),
            routeName: 'carrito');
        break;
      case 2:
        _showPreloadAndNavigate(
          context,
          const BusquedaScreen(query: '', categoria: 'Ofertas'),
          routeName: 'busqueda',
        );
        break;
      case 3:
        _showPreloadAndNavigate(context, const ProfileScreen(),
            routeName: 'perfil');
        break;
      case 4:
        widget.scaffoldKey.currentState?.openEndDrawer();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: animDuration,
      curve: Curves.easeInOut,
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
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
    );
  }
}
