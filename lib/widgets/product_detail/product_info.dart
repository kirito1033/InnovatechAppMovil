import 'package:flutter/material.dart';

class ProductInfo extends StatelessWidget {
  final String name;
  final String price;
  final String color;
  final String description;

  const ProductInfo({
    super.key,
    required this.name,
    required this.price,
    required this.color,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(price, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text("Color: $color"),
        const SizedBox(height: 8),
        const Text("Lo que tienes que saber de este producto:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(description),
      ],
    );
  }
}
