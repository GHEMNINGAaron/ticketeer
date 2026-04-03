import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  final String id;
  final String name;
  final String description;
  final List<String> members; // User IDs
  final String createdBy;
  final DateTime createdAt;

  Team({
    required this.id,
    required this.name,
    required this.description,
    required this.members,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'members': members,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      members: List<String>.from(json['members'] ?? []),
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] is Timestamp
        ? (json['createdAt'] as Timestamp).toDate()
        : DateTime.parse(json['createdAt'] as String),
    );
  }

  Team copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? members,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      members: members ?? this.members,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}