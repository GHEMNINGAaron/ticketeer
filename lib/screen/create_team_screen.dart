import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/team.dart';
import '../providers/auth_provider.dart';
import '../providers/team_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/section_label.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({Key? key}) : super(key: key);

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _emailsController = TextEditingController();

  final List<String> _invitedEmails = [];

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _emailsController.dispose();
    super.dispose();
  }

  void _addEmail() {
    final email = _emailsController.text.trim();
    if (email.isNotEmpty && _isValidEmail(email)) {
      setState(() {
        _invitedEmails.add(email);
        _emailsController.clear();
      });
    }
  }

  void _removeEmail(String email) {
    setState(() {
      _invitedEmails.remove(email);
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _handleCreateTeam() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final teamProvider = Provider.of<TeamProvider>(context, listen: false);

      final newTeam = Team(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _urlController.text.trim(),
        members: [authProvider.user!.id], 
        createdBy: authProvider.user!.id,
        createdAt: DateTime.now(),
      );

      final success = await teamProvider.createTeam(newTeam);

      if (success && mounted) {
        // TODO: Envoyer des invitations aux emails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Team created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(teamProvider.errorMessage ?? 'Failed to create team'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1220),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ticketeer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'WORKSPACE SETUP',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Créer une équipe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Collaborez avec vos collègues en centralisant vos tickets et vos indicateurs de performance.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Nom de l'équipe
                  const SectionLabel(text: "NOM DE L'ÉQUIPE", isUppercase: true),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _nameController,
                    hint: 'ex: Design System',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a team name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // URL du workspace
                  const SectionLabel(text: 'URL DU WORKSPACE', isUppercase: true),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C2333),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'ticketeer.com/',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _urlController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "nom-de-l-equipe",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Inviter des membres
                  Row(
                    children: [
                      const SectionLabel(text: 'INVITER DES MEMBRES', isUppercase: true),
                      const Spacer(),
                      Icon(Icons.group_add, color: Colors.grey, size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ajoutez les adresses email séparées par une virgule.',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  
                  // Champ d'invitation
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C2333),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _emailsController,
                          style: const TextStyle(color: Colors.white),
                          onSubmitted: (_) => _addEmail(),
                          decoration: const InputDecoration(
                            hintText: 'collaborateur@entreprise.com, ...',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        
                        // Liste des emails invités
                        if (_invitedEmails.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _invitedEmails.map((email) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.blue),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      email,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () => _removeEmail(email),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.blue,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Message de finalisation
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          'Prêt à transformer votre workflow ?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ÉTAPE FINALE : VALIDATION',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Bouton Créer l'équipe
                  ElevatedButton(
                    onPressed: teamProvider.isLoading ? null : _handleCreateTeam,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: teamProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Créer l'équipe",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('🚀', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                  ),

                  const SizedBox(height: 16),

                  // Conditions d'utilisation
                  const Center(
                    child: Text(
                      "EN CRÉANT CETTE ÉQUIPE, VOUS ACCEPTEZ NOS\nCONDITIONS D'UTILISATION.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}