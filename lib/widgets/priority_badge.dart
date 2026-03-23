import 'package:flutter/material.dart';

class PriorityBadge extends StatelessWidget {
  final String priority;

  const PriorityBadge({
    Key? key,
    required this.priority,
  }) : super(key: key);

  Color _getPriorityColor() {
    switch (priority) {
      case 'HIGH':
        return const Color(0xFFE74C3C);
      case 'MEDIUM':
        return const Color(0xFFF39C12);
      case 'LOW':
        return const Color(0xFF27AE60);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getPriorityColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: _getPriorityColor(),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}