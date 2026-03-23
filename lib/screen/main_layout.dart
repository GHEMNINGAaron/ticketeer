import 'package:flutter/material.dart';
import 'package:ticketeer/screen/insights_screen.dart';
import 'package:ticketeer/screen/settings_screen.dart';
import 'package:ticketeer/screen/team_screen.dart';
import 'package:ticketeer/screen/tickets_board.dart';
import '../widgets/custom_bottom_nav.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  // Liste des écrans
  final List<Widget> screens = const [
    TeamTicketsBoard(),
    InsightsScreen(),
    TeamScreen(),
    SettingsScreen(),
  ];

  // Liste des titres pour chaque page
  final List<String> pageTitles = const [
    'Team Tickets',
    'Insights',
    'Team',
    'Settings'
  ];

  // Liste pour savoir si la page a un bouton de recherche
  final List<bool> hasSearchButton = const [
    true,  
    false, 
    true,  
    false, 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: _buildAppBar(),
      body: screens[currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
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
      title: Text(
        pageTitles[currentIndex],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        if (hasSearchButton[currentIndex])
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white70),
            onPressed: () {
              // Action de recherche
              print('Search on ${pageTitles[currentIndex]}');
            },
          ),
      ],
    );
  }
}