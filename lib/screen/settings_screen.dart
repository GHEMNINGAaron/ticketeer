import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketeer/providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Avatar
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage("asset/Image/profile.png"),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Name
            const Center(
              child: Text(
                "Alexandre Dupont",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 4),

            const Center(
              child: Text(
                "Senior Developer",
                style: TextStyle(color: Colors.blue),
              ),
            ),

            const SizedBox(height: 6),

            const Center(
              child: Text(
                "alexandre.dupont@devteam.com",
                style: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "ACCOUNT SETTINGS",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 10),

            _settingTile(
              icon: Icons.person,
              title: "Edit Profile",
              onTap: () {},
            ),

            _settingTile(
              icon: Icons.notifications,
              title: "Notifications",
              onTap: () {},
            ),

            _settingTile(
              icon: Icons.lock,
              title: "Security",
              onTap: () {},
            ),

            const SizedBox(height: 30),

            const Text(
              "CONNECTED ACCOUNTS",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1C2333),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "asset/Image/Git.png",
                    height: 22,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "GitHub",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "@alex-dupont • Synced",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Active",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Logout
            OutlinedButton.icon(
              onPressed: () {
                _handleLogout();
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                "Déconnexion",
                style: TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2333),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  void _handleLogout() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF1C2333),
      title: const Text(
        'Déconnexion',
        style: TextStyle(color: Colors.white),
      ),
      content: const Text(
        'Êtes-vous sûr de vouloir vous déconnecter ?',
        style: TextStyle(color: Colors.grey),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () async {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            await authProvider.signOut();
            if (mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text(
            'Déconnexion',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}
}