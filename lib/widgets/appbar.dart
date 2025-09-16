import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    return AppBar(
      backgroundColor: appBarTheme.backgroundColor,
      elevation: appBarTheme.elevation ?? 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      toolbarHeight: preferredSize.height,
      leading: Padding(
        padding: const EdgeInsets.only(left: 1),
        child: Image.asset(
          "assets/img/logo.png",
          width: 100, 
          fit: BoxFit.contain,
        ),
      ),
      title: Image.asset(
        "assets/img/InovaTecHText.png",
        height: 160,
        fit: BoxFit.contain,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Icon(
            Icons.search,
            color: appBarTheme.iconTheme?.color,
            size: 30,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
