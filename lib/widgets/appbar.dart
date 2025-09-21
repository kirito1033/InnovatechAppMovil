import 'package:flutter/material.dart';
import '../screens/busqueda_screen.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  void _startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      isSearching = false;
      _searchController.clear();
    });
  }

  void _submitSearch(BuildContext context) {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BusquedaScreen(query: query),
        ),
      );
      _stopSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    return AppBar(
      backgroundColor: appBarTheme.backgroundColor,
      elevation: appBarTheme.elevation ?? 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      toolbarHeight: widget.preferredSize.height,
      leading: Padding(
        padding: const EdgeInsets.only(left: 1),
        child: Image.asset(
          "assets/img/logo.png",
          width: 100,
          fit: BoxFit.contain,
        ),
      ),
      title: isSearching
    ? TextField(
        controller: _searchController,
        autofocus: true,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _submitSearch(context),
        style: const TextStyle(
          color: Colors.white, // 🔹 Texto blanco
          fontSize: 18,
        ),
        decoration: InputDecoration(
          hintText: "Buscar producto...",
          hintStyle: TextStyle(color: Colors.white70), 
          filled: true,
          fillColor: Colors.black26, 
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), 
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
          ),
        ),
      )
    : Image.asset(
        "assets/img/InovaTecHText.png",
        height: 160,
        fit: BoxFit.contain,
      ),
      actions: [
        if (isSearching)
          IconButton(
            icon: const Icon(Icons.close, size: 28),
            color: appBarTheme.iconTheme?.color,
            onPressed: _stopSearch,
          )
        else
          IconButton(
            icon: const Icon(Icons.search, size: 28),
            color: appBarTheme.iconTheme?.color,
            onPressed: _startSearch,
          ),
      ],
    );
  }
}
