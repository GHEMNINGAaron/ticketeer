import 'package:flutter/material.dart';
import '../models/ticket.dart';
import 'priority_badge.dart';
import 'user_avatar.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback? onViewDetails;

  const TicketCard({
    Key? key,
    required this.ticket,
    this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2F42),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildTitle(),
          const SizedBox(height: 16),
          _buildMetadata(),
          const SizedBox(height: 20),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.category, color: Colors.white38, size: 20),
            const SizedBox(width: 8),
            Text(
              ticket.project,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF2D4A5E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              ticket.iconPath,
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      ticket.title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
    );
  }

  Widget _buildMetadata() {
    return Row(
      children: [
        PriorityBadge(priority: ticket.priority),
        const SizedBox(width: 12),
        Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          ticket.assignedTo != null
              ? 'Assigned to ${ticket.assignedTo}'
              : 'Unassigned',
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLeftFooter(),
        _buildViewButton(),
      ],
    );
  }

  Widget _buildLeftFooter() {
    if (ticket.updatedTime != null) {
      return Row(
        children: [
          const Icon(Icons.access_time, color: Colors.white38, size: 16),
          const SizedBox(width: 6),
          Text(
            'UPDATED ${ticket.updatedTime}',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),
        ],
      );
    } else if (ticket.helpWanted != null) {
      return Row(
        children: [
          const Icon(Icons.bolt, color: Color(0xFF4A90E2), size: 16),
          const SizedBox(width: 6),
          Text(
            ticket.helpWanted!,
            style: const TextStyle(
              color: Color(0xFF4A90E2),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: const [
          UserAvatar(letter: 'A'),
          SizedBox(width: 4),
          UserAvatar(letter: 'S'),
        ],
      );
    }
  }

  Widget _buildViewButton() {
    return ElevatedButton(
      onPressed: onViewDetails,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2D4A5E),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        children: const [
          Text('View Details'),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, size: 16),
        ],
      ),
    );
  }
}