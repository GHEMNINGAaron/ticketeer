import 'package:flutter/material.dart';

class PrioritySelector extends StatelessWidget {
  final String selectedPriority;
  final Function(String) onPriorityChanged;

  const PrioritySelector({
    Key? key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  }) : super(key: key);

  static const List<String> priorities = ['LOW', 'MEDIUM', 'HIGH'];

  String _getDisplayName(String priority) {
    switch (priority) {
      case 'LOW':
        return 'Low';
      case 'MEDIUM':
        return 'Medium';
      case 'HIGH':
        return 'High';
      default:
        return priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: priorities.map((priority) {
        final isSelected = selectedPriority == priority;
        return Expanded(
          child: GestureDetector(
            onTap: () => onPriorityChanged(priority),
            child: Container(
              margin: EdgeInsets.only(
                right: priority != priorities.last ? 12 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : const Color(0xFF1C2333),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getDisplayName(priority),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}