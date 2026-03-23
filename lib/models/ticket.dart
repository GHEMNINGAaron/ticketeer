class Ticket {
  final String id;
  final String project;
  final String title;
  final String priority; // HIGH, MEDIUM, LOW
  final String? assignedTo;
  final String status; // NEW, ACTIVE, RESOLVED
  final String? updatedTime;
  final String? helpWanted;
  final String iconPath;

  Ticket({
    required this.id,
    required this.project,
    required this.title,
    required this.priority,
    this.assignedTo,
    required this.status,
    this.updatedTime,
    this.helpWanted,
    required this.iconPath,
  });
}