import 'package:flutter/material.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  final bool isUppercase;

  const SectionLabel({
    Key? key,
    required this.text,
    this.isUppercase = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      isUppercase ? text.toUpperCase() : text,
      style: TextStyle(
        color: isUppercase ? Colors.grey : Colors.white,
        fontSize: isUppercase ? 12 : 16,
        fontWeight: isUppercase ? FontWeight.w500 : FontWeight.w500,
        letterSpacing: isUppercase ? 1.2 : 0,
      ),
    );
  }
}