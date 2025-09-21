import 'package:flutter/material.dart';
import '/theme/app_theme.dart'; // importa tu AppColors

class CustomDrawer extends StatelessWidget {
  final String username;
  final Function(int) onItemSelected;
  final VoidCallback onLogout;
  final int currentIndex;

  const CustomDrawer({
    super.key,
    required this.username,
    required this.onItemSelected,
    required this.onLogout,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.appBarBackground,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(),
          _buildMenuItems(context),
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
        children: const [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: AppColors.primary),
          ),
          SizedBox(height: 15),
          Text(
            "Cliente Demo",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            "usuario@demo.com",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Column(
      children: [
        _buildListTile(Icons.home, 'Inicio', 0, currentIndex == 0),
        _buildListTile(Icons.person, 'Mi Perfil', 1, currentIndex == 1),
        _buildListTile(Icons.settings, 'Configuración', 2, currentIndex == 2),
        const Divider(color: Colors.white30),
        _buildListTile(Icons.notifications, 'Notificaciones', 3, false),
        _buildListTile(Icons.help, 'Ayuda', 4, false),
        _buildListTile(Icons.info, 'Acerca de', 5, false),
        const Divider(color: Colors.white30),
        _buildLogoutTile(),
      ],
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title,
    int index,
    bool isSelected,
  ) {
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
      onTap: () => onItemSelected(index),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text(
        'Cerrar Sesión',
        style: TextStyle(color: Colors.red),
      ),
      onTap: onLogout,
    );
  }
}