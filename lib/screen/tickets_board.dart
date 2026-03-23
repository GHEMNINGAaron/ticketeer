import 'package:flutter/material.dart';
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
    ),
  ];

  List<Ticket> get filteredTickets {
    return tickets.where((t) => t.status == selectedTab.toUpperCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Column(
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
    );
  }

  
    
}