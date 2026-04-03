import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketeer/providers/team_provider.dart';
import 'package:ticketeer/providers/ticket_provider.dart';
import '../models/ticket.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/priority_selector.dart';
import '../widgets/github_link_card.dart';
import '../widgets/section_label.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({Key? key}) : super(key: key);

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _githubIssueController = TextEditingController();

  String _selectedPriority = 'LOW';
  String _selectedStatus = 'NEW';
  String? _selectedDeveloper;
  bool _linkToGithub = false;

  // Liste fictive de développeurs (à remplacer par des données réelles)
  final List<Map<String, String>> _developers = [
    {'id': '1', 'name': 'Alex M.'},
    {'id': '2', 'name': 'Sarah K.'},
    {'id': '3', 'name': 'John D.'},
    {'id': '4', 'name': 'Emma W.'},
  ];

  static const Map<String, String> _statusDisplayNames = {
    'NEW': 'To Do',
    'ACTIVE': 'In Progress',
    'RESOLVED': 'Done',
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _githubIssueController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateTicket() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
      final teamProvider = Provider.of<TeamProvider>(context, listen: false);

      if (teamProvider.currentTeam == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No team selected. Please select a team first.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final newTicket = Ticket(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        project: 'INTERNAL TICKETING',
        priority: _selectedPriority,
        status: _selectedStatus,
        assignedTo: _selectedDeveloper,
        assignedToName: _selectedDeveloper != null
            ? _developers.firstWhere(
                (dev) => dev['id'] == _selectedDeveloper,
              )['name']
            : null,
        createdBy: authProvider.user?.id ?? '',
        createdAt: DateTime.now(),
        iconPath: '📋',
        linkToGithub: _linkToGithub,
        githubIssueId:
            _linkToGithub ? _githubIssueController.text.trim() : null,
        teamId: teamProvider.currentTeam!.id,
      );

      print('New ticket created: ${newTicket.toJson()}');
      final success = await ticketProvider.createTicket(newTicket);


      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ticket created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ticketProvider.errorMessage ?? 'Failed to create ticket'),
            backgroundColor: Colors.red,
          ),
        );
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),
                  const SizedBox(height: 24),
                  _buildDescriptionSection(),
                  const SizedBox(height: 24),
                  _buildAssignedToSection(),
                  const SizedBox(height: 24),
                  _buildPrioritySection(),
                  const SizedBox(height: 24),
                  _buildStatusSection(),
                  const SizedBox(height: 24),
                  _buildGitHubSection(),
                  const SizedBox(height: 32),
                  _buildCreateButton(ticketProvider.isLoading),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0B1220),
      elevation: 0,
      leading: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'Cancel',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
      title: const Text(
        'New Ticket',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Ticket Title'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _titleController,
          hint: 'Enter ticket title...',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Description'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _descriptionController,
          hint: 'Provide details about the task...',
          maxLines: 6,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAssignedToSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Assigned To'),
        const SizedBox(height: 8),
        CustomDropdown<String>(
          value: _selectedDeveloper,
          hint: 'Select a developer',
          items: _developers.map((dev) {
            return DropdownMenuItem<String>(
              value: dev['id'],
              child: Text(dev['name']!),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedDeveloper = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Priority'),
        const SizedBox(height: 12),
        PrioritySelector(
          selectedPriority: _selectedPriority,
          onPriorityChanged: (priority) {
            setState(() {
              _selectedPriority = priority;
            });
          },
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'Status'),
        const SizedBox(height: 8),
        CustomDropdown<String>(
          value: _selectedStatus,
          hint: 'Select status',
          items: _statusDisplayNames.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedStatus = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildGitHubSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GitHubLinkCard(
          isLinked: _linkToGithub,
          onChanged: (value) {
            setState(() {
              _linkToGithub = value;
            });
          },
        ),
        if (_linkToGithub) ...[
          const SizedBox(height: 16),
          const SectionLabel(text: 'GitHub Issue ID', isUppercase: true),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _githubIssueController,
            hint: '#1402',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter GitHub issue ID';
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  Widget _buildCreateButton(bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : _handleCreateTicket,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.add, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Create Ticket',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}