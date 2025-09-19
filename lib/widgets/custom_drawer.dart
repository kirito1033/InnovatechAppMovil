import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF020f1f),
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF0b4454),
            ),
            child: UserInfoSection(),
          ),
          Expanded(child: MenuOptionsSection()),
        ],
      ),
    );
  }
}

/// 🔹 Sección del usuario (foto + correo)
class UserInfoSection extends StatelessWidget {
  const UserInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(
            "https://i.pravatar.cc/150?img=8", 
          ),
        ),
        SizedBox(height: 10),
        Text(
          "usuario@correo.com",
          style: TextStyle(color: Colors.white, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// 🔹 Menú de opciones
class MenuOptionsSection extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = const [
    {"icon": Icons.home, "title": "Inicio"},
    {"icon": Icons.category, "title": "Categorias"},
    {"icon": Icons.shopping_bag, "title": "Mis Compras"},
    {"icon": Icons.local_offer, "title": "Ofertas"},
    {"icon": Icons.help, "title": "Ayuda / PQRS"},
    {"icon": Icons.login, "title": "Iniciar Sesión"},
  ];

  const MenuOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return ListTile(
          leading: Icon(item["icon"], color: const Color(0xFF04ebec)),
          title: Text(
            item["title"],
            style: const TextStyle(
              color: Color(0xFF04ebec),
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            Navigator.pop(context); 
   
          },
        );
      },
      separatorBuilder: (_, __) => const Divider(color: Colors.white24),
    );
  }
}
