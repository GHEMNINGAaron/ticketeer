class Ticket {
  final String id;
  final String title;
  final String description;
  final String project;
  final String priority; // LOW, MEDIUM, HIGH
  final String status; // NEW, ACTIVE, RESOLVED
  final String? assignedTo; // User ID
  final String? assignedToName; // User name for display
  final String createdBy; // User ID
  final String? teamId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? updatedTime;
  final String? helpWanted;
  final String iconPath;
  final bool linkToGithub;
  final String? githubIssueId;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.project,
    required this.priority,
    required this.status,
    this.assignedTo,
    this.assignedToName,
    required this.createdBy,
    this.teamId,
    required this.createdAt,
    this.updatedAt,
    this.updatedTime,
    this.helpWanted,
    required this.iconPath,
    this.linkToGithub = false,
    this.githubIssueId,
  });

  // Convertir en JSON pour Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'project': project,
      'priority': priority,
      'status': status,
      'assignedTo': assignedTo,
      'assignedToName': assignedToName,
      'createdBy': createdBy,
      'teamId': teamId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedTime': updatedTime,
      'helpWanted': helpWanted,
      'iconPath': iconPath,
      'linkToGithub': linkToGithub,
      'githubIssueId': githubIssueId,
    };
  }

  // Créer depuis JSON
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      project: json['project'] ?? '',
      priority: json['priority'] ?? 'LOW',
      status: json['status'] ?? 'NEW',
      assignedTo: json['assignedTo'],
      assignedToName: json['assignedToName'],
      createdBy: json['createdBy'] ?? '',
      teamId: json['teamId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      updatedTime: json['updatedTime'],
      helpWanted: json['helpWanted'],
      iconPath: json['iconPath'] ?? '📋',
      linkToGithub: json['linkToGithub'] ?? false,
      githubIssueId: json['githubIssueId'],
    );
  }

  // Copier avec modifications
  Ticket copyWith({
    String? id,
    String? title,
    String? description,
    String? project,
    String? priority,
    String? status,
    String? assignedTo,
    String? assignedToName,
    String? createdBy,
    String? teamId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? updatedTime,
    String? helpWanted,
    String? iconPath,
    bool? linkToGithub,
    String? githubIssueId,
  }) {
    return Ticket(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      project: project ?? this.project,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedToName: assignedToName ?? this.assignedToName,
      createdBy: createdBy ?? this.createdBy,
      teamId: teamId ?? this.teamId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedTime: updatedTime ?? this.updatedTime,
      helpWanted: helpWanted ?? this.helpWanted,
      iconPath: iconPath ?? this.iconPath,
      linkToGithub: linkToGithub ?? this.linkToGithub,
      githubIssueId: githubIssueId ?? this.githubIssueId,
    );
  }
}