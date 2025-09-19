import 'package:flutter/material.dart';
import '/widgets/custom_drawer.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(BuildContext context, int index) {
    if (index == 4) {
      // 🔹 Abrir el Drawer
      Scaffold.of(context).openEndDrawer();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (navContext) => BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(navContext, index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: ""), // 👈 Quinto ícono
        ],
      ),
    );
  }
}