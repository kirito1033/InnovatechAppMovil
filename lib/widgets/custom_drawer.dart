import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String username;
  final String correo;
  final Function(int) onItemSelected;
  final VoidCallback onLogout;
  final int currentIndex;

  const CustomDrawer({
    super.key,
    required this.username,
    required this.correo,
    required this.onItemSelected,
    required this.onLogout,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context, theme),
          _buildMenuItems(context, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.colorScheme.onPrimary,
            child: Icon(
              Icons.person,
              size: 40,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            username,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            correo,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        _buildListTile(context, theme, Icons.home, 'Inicio', 0),
        _buildListTile(context, theme, Icons.person, 'Mi Perfil', 1),
        _buildListTile(context, theme, Icons.settings, 'Configuración', 2),
        const Divider(),
        _buildListTile(context, theme, Icons.notifications, 'Notificaciones', 3),

        // ✅ Ayuda ya no afecta la selección
        ListTile(
          leading: Icon(Icons.help, color: theme.iconTheme.color),
          title: Text(
            'Ayuda',
            style: theme.textTheme.bodyMedium,
          ),
          onTap: () {
            Navigator.pop(context);
            // ✅ No cambiamos el índice del navbar
            Navigator.pushNamed(context, '/pqrs');
          },
        ),

        _buildListTile(context, theme, Icons.info, 'Acerca de', 5),
        const Divider(),
        _buildLogoutTile(context, theme),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context,
    ThemeData theme,
    IconData icon,
    String title,
    int index,
  ) {
    final bool isSelected = currentIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? theme.colorScheme.primary : theme.iconTheme.color,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.textTheme.bodyMedium?.color,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.arrow_forward, color: theme.colorScheme.primary, size: 20)
          : null,
      onTap: () {
        // ✅ Cambiamos el índice ANTES de cerrar el Drawer
        onItemSelected(index);

        // ✅ Esperamos un instante y luego cerramos el Drawer
        Future.delayed(const Duration(milliseconds: 150), () {
          Navigator.pop(context);
        });
      },
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primary.withOpacity(0.1),
    );
  }

  Widget _buildLogoutTile(BuildContext context, ThemeData theme) {
    return ListTile(
      leading: Icon(Icons.logout, color: theme.colorScheme.error),
      title: Text(
        'Cerrar Sesión',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onLogout();
      },
    );
  }
}
