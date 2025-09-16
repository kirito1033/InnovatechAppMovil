import 'package:flutter/material.dart';

class CategoryTitle extends StatelessWidget {
  final String title;
  const CategoryTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        width: 240,
        height: 55,
        decoration: BoxDecoration(
          color: appBarTheme.backgroundColor,
          border: Border.all(
            color: const Color.fromARGB(255, 2, 15, 31),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(30), // esquinas suaves
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.cyan,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
