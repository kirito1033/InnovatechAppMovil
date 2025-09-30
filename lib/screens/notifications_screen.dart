import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/custom_drawer.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: const CustomAppBar(),
      endDrawer: const CustomDrawer(currentIndex: 3),
      bottomNavigationBar: CustomBottomNavBar(scaffoldKey: _scaffoldKey),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_active, size: 80, color: theme.colorScheme.primary),
            const SizedBox(height: 20),
            Text(
              "Módulo en construcción",
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Aquí podrás ver tus notificaciones próximamente.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}