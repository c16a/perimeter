import 'package:flutter/material.dart';

class NiceTextField extends StatelessWidget {
  const NiceTextField(
      {super.key, required this.controller, required this.hintText});

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          hintText: hintText,
          border: const OutlineInputBorder()),
    );
  }
}