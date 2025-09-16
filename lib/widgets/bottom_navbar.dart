import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: ""),
      ],
    );
  }
}
