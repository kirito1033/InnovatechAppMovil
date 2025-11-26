import 'package:flutter/material.dart';
import '../services/user_helper.dart';
import '/theme/app_theme.dart'; // tus colores

class CustomDrawer extends StatefulWidget {
  final int currentIndex;
  const CustomDrawer({super.key, required this.currentIndex});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String username = "Usuario";
  String correo = "correo@ejemplo.com";

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final data = await UserHelper.getUserData();
    if (mounted) {
      setState(() {
        username = data["username"]!;
        correo = data["correo"]!;
      });
    }
  }

  void _handleNavigation(int index) {
    Navigator.pop(context); // cerrar drawer
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/notifications');
        break;
      case 4:  // 🆕 NUEVO
        Navigator.pushReplacementNamed(context, '/purchases');
        break;
      case 5:
        Navigator.pushReplacementNamed(context, '/about');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.appBarBackground,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(),
          _buildMenuItems(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.appBarBackground,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 15),
          Text(
            username,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            correo,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        _buildListTile(Icons.home, 'Inicio', 0),
        _buildListTile(Icons.person, 'Mi Perfil', 1),
        _buildListTile(Icons.settings, 'Configuración', 2),
        const Divider(color: Colors.white30),
        _buildListTile(Icons.notifications, 'Notificaciones', 3),
        _buildListTile(Icons.receipt_long, 'Mis Compras', 4),
        ListTile(
          leading: const Icon(Icons.help, color: Colors.white70),
          title: const Text(
            'Ayuda',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/pqrs');
          },
        ),
        _buildListTile(Icons.info, 'Acerca de', 5),
        const Divider(color: Colors.white30),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            'Cerrar Sesión',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () => UserHelper.logout(context),
        ),
      ],
    );
  }

  Widget _buildListTile(IconData icon, String title, int index) {
    final bool isSelected = widget.currentIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : Colors.white70,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.arrow_forward, color: AppColors.primary, size: 20)
          : null,
      selected: isSelected,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
      onTap: () => _handleNavigation(index),
    );
  }
}
