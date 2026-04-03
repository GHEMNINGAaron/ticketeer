import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/team.dart';

class TeamService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Créer une équipe
  Future<void> createTeam(Team team) async {
    try {
      await _firestore.collection('teams').doc(team.id).set(team.toJson());
    } catch (e) {
      throw 'Error creating team: $e';
    }
  }

  // Récupérer une équipe par ID
  Future<Team?> getTeamById(String teamId) async {
    try {
      final doc = await _firestore.collection('teams').doc(teamId).get();
      if (doc.exists) {
        return Team.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Error fetching team: $e';
    }
  }

  // Récupérer les équipes d'un utilisateur
  Stream<List<Team>> getUserTeams(String userId) {
    return _firestore
      .collection('teams')
      .where('members', arrayContains: userId)
      .snapshots()
      .map((snapshot) {
        for (var doc in snapshot.docs) {
          print('  - doc: ${doc.id} → ${doc.data()}');
        }
        return snapshot.docs.map((doc) {
          try {
            return Team.fromJson(doc.data());
          } catch (e) {
            print('❌ Erreur fromJson sur doc ${doc.id}: $e');
            rethrow;
          }
        }).toList();
      });
  }

  // Ajouter un membre à une équipe
  Future<void> addMemberToTeam(String teamId, String userId) async {
    try {
      await _firestore.collection('teams').doc(teamId).update({
        'members': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw 'Error adding member to team: $e';
    }
  }

  // Retirer un membre d'une équipe
  Future<void> removeMemberFromTeam(String teamId, String userId) async {
    try {
      await _firestore.collection('teams').doc(teamId).update({
        'members': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      throw 'Error removing member from team: $e';
    }
  }

  // Mettre à jour une équipe
  Future<void> updateTeam(Team team) async {
    try {
      await _firestore.collection('teams').doc(team.id).update(team.toJson());
    } catch (e) {
      throw 'Error updating team: $e';
    }
  }
}