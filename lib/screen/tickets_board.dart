import 'package:flutter/material.dart';
import '../models/ticket.dart';
import '../widgets/custom_tab_bar.dart';
import '../widgets/ticket_card.dart';
import '../widgets/sync_footer.dart';
import '../widgets/custom_bottom_nav.dart';

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
      appBar: _buildAppBar(),
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
                    // Action quand on clique sur "View Details"
                    print('View details: ${filteredTickets[index].id}');
                  },
                );
              },
            ),
          ),
          const SyncFooter(),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentNavIndex,
        onTap: (index) {
          setState(() {
            currentNavIndex = index;
          });
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0D1B2A),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: const Color(0xFFE8A87C),
          child: const Text(
            'U',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      title: const Text(
        'Team Tickets',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white70),
          onPressed: () {},
        ),
      ],
    );
  }
}