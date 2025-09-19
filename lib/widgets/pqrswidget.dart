import 'package:flutter/material.dart';

class PqrsTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final int maxLines;

  const PqrsTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
