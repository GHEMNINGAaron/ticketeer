import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/team_provider.dart';
import '../providers/auth_provider.dart';
import '../models/team.dart';
import 'create_team_screen.dart';

class TeamsListScreen extends StatefulWidget {
  const TeamsListScreen({Key? key}) : super(key: key);

  @override
  State<TeamsListScreen> createState() => _TeamsListScreenState();
}

class _TeamsListScreenState extends State<TeamsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final teamProvider = Provider.of<TeamProvider>(context, listen: false);
      
      if (authProvider.user != null) {
        teamProvider.loadUserTeams(authProvider.user!.id);
      }
    });
  }

  void _navigateToCreateTeam() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateTeamScreen()),
    );
  }

  Color _getTeamColor(int index) {
    final colors = [
      const Color(0xFF4A90E2), // Bleu
      const Color(0xFF9B59B6), // Violet
      const Color(0xFFE74C3C), // Rouge
    ];
    return colors[index % colors.length];
  }

  String _getTeamIcon(int index) {
    final icons = ['💻', '📱', '🎨'];
    return icons[index % icons.length];
  }

  String _getStatusLabel(Team team, int totalTickets) {
    // Logique simple : si > 15 tickets = URGENT, sinon ACTIF
    if (totalTickets > 15) {
      return 'URGENT';
    }
    return 'ACTIF';
  }

  Color _getStatusColor(String status) {
    if (status == 'URGENT') {
      return Colors.red;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TeamProvider>(
      builder: (context, teamProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            // Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Vos Équipes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Gérez vos collaborations et suivez les performances de vos différents pôles de développement.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bouton créer une équipe
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: _navigateToCreateTeam,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Créer une nouvelle équipe',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Liste des équipes
            if (teamProvider.isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                ),
              )
            else if (teamProvider.teams.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.groups, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Aucune équipe',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Créez votre première équipe pour commencer',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: teamProvider.teams.length,
                  itemBuilder: (context, index) {
                    final team = teamProvider.teams[index];
                    // Données fictives pour l'exemple
                    final memberCount = team.members.length;
                    final ticketCount = (index + 1) * 8 + 4; // Fictif
                    final status = _getStatusLabel(team, ticketCount);

                    return _TeamCard(
                      team: team,
                      icon: _getTeamIcon(index),
                      color: _getTeamColor(index),
                      memberCount: memberCount,
                      ticketCount: ticketCount,
                      status: status,
                      statusColor: _getStatusColor(status),
                      onTap: () {
                        teamProvider.setCurrentTeam(team);
                        // Retourner au Board avec l'équipe sélectionnée
                        DefaultTabController.of(context).animateTo(1); // Index du Board
                      },
                    );
                  },
                ),
              ),

          ],
        );
      },
    );
  }
}

class _TeamCard extends StatelessWidget {
  final Team team;
  final String icon;
  final Color color;
  final int memberCount;
  final int ticketCount;
  final String status;
  final Color statusColor;
  final VoidCallback onTap;

  const _TeamCard({
    required this.team,
    required this.icon,
    required this.color,
    required this.memberCount,
    required this.ticketCount,
    required this.status,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: const Color(0xFF1C2333),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icône de l'équipe
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(icon, style: const TextStyle(fontSize: 24)),
                    ),
                    const Spacer(),
                    // Badge de statut
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  team.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  team.description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B1220),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MEMBRES',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$memberCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B1220),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TICKETS',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$ticketCount',
                              style: TextStyle(
                                color: ticketCount > 15 ? Colors.red : Colors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Avatars des membres (fictif pour l'exemple)
                    Row(
                      children: List.generate(
                        memberCount > 3 ? 3 : memberCount,
                        (i) => Container(
                          margin: EdgeInsets.only(left: i > 0 ? 4 : 0),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF1C2333),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + i),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}