import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketeer/screen/insights_screen.dart';
import 'package:ticketeer/screen/settings_screen.dart';
import 'package:ticketeer/screen/team_list_screen.dart';
import 'package:ticketeer/screen/tickets_board.dart';
import 'package:ticketeer/providers/team_provider.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/team_selector.dart'; 

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    TeamTicketsBoard(),
    InsightsScreen(),
    TeamsListScreen(),
    SettingsScreen(),
  ];

  final List<String> pageTitles = const [
    'Team Tickets',
    'Insights',
    'Team',
    'Settings',
  ];

  final List<bool> hasSearchButton = const [
    true,
    false,
    true,
    false,
  ];

  // Pages où le TeamSelector remplace le titre
  final List<bool> hasTeamSelector = const [
    true,  // Board
    false,
    true,  // TeamList
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
        child: Consumer<TeamProvider>(
          builder: (context, teamProvider, _) {
            final name = teamProvider.currentTeam?.name ?? 'U';
            return CircleAvatar(
              backgroundColor: const Color(0xFFE8A87C),
              child: Text(
                name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
      title: hasTeamSelector[currentIndex]
          ? const TeamSelector()
          : Text(
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
              print('Search on ${pageTitles[currentIndex]}');
            },
          ),
      ],
    );
  }
}