import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.isTitle = false,
    this.isDescription = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final bool isTitle;
  final bool isDescription;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        hintText: hintText,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(18),
      ),
      maxLines: isDescription ? 5 : 1,
      maxLength: isTitle ? 30 : null,
    );
  }
}