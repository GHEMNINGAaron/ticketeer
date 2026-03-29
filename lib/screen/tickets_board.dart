import 'package:flutter/material.dart';
import 'package:ticketeer/screen/create_ticket_screen.dart';
import '../models/ticket.dart';
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

  final List<Ticket> tickets = [
    Ticket(
      id: '#GH-102',
      project: 'GITHUB: WEB-APP-CORE',
      title: 'Implement OAuth2 flow for production environment',
      priority: 'HIGH',
      assignedTo: 'Alex M.',
      status: 'NEW',
      iconPath: '📱',
      description: 'Integrate OAuth2 authentication for secure user login in production.',
      createdBy: 'Alex M.',
      createdAt: DateTime.now().subtract(Duration(hours: 5)),
    ),
    Ticket(
      id: '#IT-45',
      project: 'INTERNAL TICKETING',
      title: 'Fix race condition in ticket assignment logic',
      priority: 'MEDIUM',
      assignedTo: 'Sarah K.',
      status: 'NEW',
      updatedTime: '2H AGO',
      iconPath: '🔧',
      description: 'Resolve race condition in ticket assignment logic.',
      createdBy: 'Sarah K.',
      createdAt: DateTime.now().subtract(Duration(hours: 3)),
    ),
    Ticket(
      id: '#DOC-23',
      project: 'DOCS REPOSITORY',
      title: 'Update API v2 documentation for endpoints',
      priority: 'LOW',
      assignedTo: null,
      status: 'NEW',
      helpWanted: 'HELP WANTED',
      iconPath: '📄',
      description: 'Update API v2 documentation for endpoints.',
      createdBy: 'John D.',
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
    ),
  ];

  List<Ticket> get filteredTickets {
    return tickets.where((t) => t.status == selectedTab.toUpperCase()).toList();
  }

    void _navigateToCreateTicket() async {
    final newTicket = await Navigator.push<Ticket>(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTicketScreen(),
      ),
    );

    if (newTicket != null) {
      setState(() {
        tickets.add(newTicket);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredTickets.length,
                itemBuilder: (context, index) {
                  return TicketCard(
                    ticket: filteredTickets[index],
                    onViewDetails: () {
                      print('View details: ${filteredTickets[index].id}');
                    },
                  );
                },
              ),
            ),
            const SyncFooter(),
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
  }
}