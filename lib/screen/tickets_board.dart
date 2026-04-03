import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketeer/providers/auth_provider.dart';
import 'package:ticketeer/providers/team_provider.dart';
import 'package:ticketeer/providers/ticket_provider.dart';
import 'package:ticketeer/screen/create_ticket_screen.dart';
import '../widgets/custom_tab_bar.dart';
import '../widgets/ticket_card.dart';
import '../widgets/sync_footer.dart';

class TeamTicketsBoard extends StatefulWidget {
  const TeamTicketsBoard({Key? key}) : super(key: key);

  @override
  State<TeamTicketsBoard> createState() => _TeamTicketsBoardState();
}

class _TeamTicketsBoardState extends State<TeamTicketsBoard> {
  String selectedTab = 'New';
  int currentNavIndex = 0;


  @override
  void initState() {
    super.initState();
    // Charger les équipes et tickets au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final teamProvider = Provider.of<TeamProvider>(context, listen: false);
      final ticketProvider = Provider.of<TicketProvider>(context, listen: false);

      if (authProvider.user != null) {
        // Charger les équipes de l'utilisateur
        teamProvider.loadUserTeams(authProvider.user!.id);
        print('Loading teams for user: ${authProvider.user!.email}');
        print(teamProvider.teams);
        
        // Écouter les changements d'équipe pour charger les tickets
        teamProvider.addListener(() {
          if (teamProvider.currentTeam != null) {
            ticketProvider.setCurrentTeam(teamProvider.currentTeam!.id);
          }
        });
      }
    });
  }

   void _navigateToCreateTicket() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTicketScreen(),
      ),
    );
  }

  String _getStatusFromTab(String tab) {
    switch (tab) {
      case 'New':
        return 'NEW';
      case 'Active':
        return 'ACTIVE';
      case 'Resolved':
        return 'RESOLVED';
      default:
        return 'NEW';
    }
  }

@override
  Widget build(BuildContext context) {
    return Consumer2<TicketProvider, TeamProvider>(
      builder: (context, ticketProvider, teamProvider, _) {
        final filteredTickets = ticketProvider.getTicketsByStatus(
          _getStatusFromTab(selectedTab),
        );

        // Afficher un message si aucune équipe n'est sélectionnée
        if (teamProvider.currentTeam == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.group_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No team selected',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Please create or join a team to view tickets',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            Column(
              children: [
                CustomTabBar(
                  selectedTab: selectedTab,
                  tabs: const ['New', 'Active', 'Resolved'],
                  onTabSelected: (tab) {
                    setState(() {
                      selectedTab = tab;
                    });
                  },
                ),
                
                // Afficher un loader pendant le chargement
                if (ticketProvider.isLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
                  )
                else if (filteredTickets.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            selectedTab == 'New'
                                ? Icons.inbox
                                : selectedTab == 'Active'
                                    ? Icons.hourglass_empty
                                    : Icons.check_circle_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No ${selectedTab.toLowerCase()} tickets',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Create a new ticket to get started',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredTickets.length,
                      itemBuilder: (context, index) {
                        return TicketCard(
                          ticket: filteredTickets[index],
                          onViewDetails: () {
                            // TODO: Naviguer vers les détails du ticket
                            print('View details: ${filteredTickets[index].id}');
                          },
                        );
                      },
                    ),
                  ),
                
                SyncFooter(
                  message: teamProvider.currentTeam != null
                      ? '${teamProvider.currentTeam!.name} • Synced just now'
                      : 'Synced just now',
                ),
              ],
            ),

            // Bouton flottant pour créer un ticket
            Positioned(
              bottom: 80,
              right: 16,
              child: FloatingActionButton(
                onPressed: _navigateToCreateTicket,
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add, size: 28),
              ),
            ),
          ],
        );
      },
    );
  }

}