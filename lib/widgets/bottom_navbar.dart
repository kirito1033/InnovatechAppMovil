import 'package:flutter/material.dart';
import '/widgets/custom_drawer.dart';
import '/screens/home_screen.dart';
import '/screens/profile_screen.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  // Key para acceder al Scaffold y abrir el Drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = const [
    HomeScreen(),
    Placeholder(), // Carrito
    Placeholder(), // Ofertas
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 4) {
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // 🔑 vincular el key al Scaffold
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Carrito"),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: "Ofertas"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "Más"),
        ],
      ),
      endDrawer: CustomDrawer(
        username: "Cliente Demo",
        currentIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          Navigator.pop(context);
        },
        onLogout: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sesión cerrada")),
          );
        },
      ),
    );
  }
}