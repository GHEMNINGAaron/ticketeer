import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketeer/models/team.dart';
import 'package:ticketeer/providers/team_provider.dart';

class TeamSelector extends StatelessWidget {
  const TeamSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TeamProvider>(
      builder: (context, teamProvider, _) {
        if (teamProvider.teams.isEmpty) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => _showTeamDropdown(context, teamProvider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1C2333),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.groups, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text(
                  teamProvider.currentTeam?.name ?? 'Sélectionner',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 18),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTeamDropdown(BuildContext context, TeamProvider teamProvider) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<Team>(
      context: context,
      position: position,
      color: const Color(0xFF1C2333),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white12),
      ),
      items: teamProvider.teams.map((team) {
        final isSelected = team.id == teamProvider.currentTeam?.id;
        return PopupMenuItem<Team>(
          value: team,
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.blue : Colors.transparent,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                team.name,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ).then((selectedTeam) {
      if (selectedTeam != null) {
        teamProvider.setCurrentTeam(selectedTeam);
      }
    });
  }
}