import 'package:flutter/material.dart';

class SyncFooter extends StatelessWidget {
  final String message;

  const SyncFooter({
    Key? key,
    this.message = 'Github synced 5 minutes ago',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.sync, color: Colors.white24, size: 16),
          const SizedBox(width: 8),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white24,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}