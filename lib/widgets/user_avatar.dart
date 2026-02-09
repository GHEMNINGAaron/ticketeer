import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String letter;
  final double size;

  const UserAvatar({
    Key? key,
    required this.letter,
    this.size = 32,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF2D4A5E),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF0D1B2A), width: 2),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}