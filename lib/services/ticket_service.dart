import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ticket.dart';

class TicketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Créer un nouveau ticket
  Future<void> createTicket(Ticket ticket) async {
    try {
      await _firestore.collection('tickets').doc(ticket.id).set(ticket.toJson());
    } catch (e) {
      throw 'Error creating ticket: $e';
    }
  }

  // Récupérer les tickets d'une équipe
  Stream<List<Ticket>> getTeamTickets(String teamId) {
    print('🔍 Recherche tickets pour teamId: $teamId');
    return _firestore
        .collection('tickets')
        .where('teamId', isEqualTo: teamId)
        //.orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      print('📦 Snapshot reçu: ${snapshot.docs.length} docs');
      for (var doc in snapshot.docs) {
        print('  - doc: ${doc.id} → ${doc.data()}');
      }
      return snapshot.docs.map((doc) {
        try {
          return Ticket.fromJson(doc.data());
        } catch (e) {
          print('❌ Erreur fromJson sur doc ${doc.id}: $e');
          rethrow;
        }
      }).toList();
    });
  }

  // Récupérer les tickets par statut pour une équipe
  Stream<List<Ticket>> getTeamTicketsByStatus(String teamId, String status) {
    return _firestore
        .collection('tickets')
        .where('teamId', isEqualTo: teamId)
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          return Ticket.fromJson(doc.data());
        } catch (e) {
          print('❌ Erreur fromJson sur doc ${doc.id}: $e');
          rethrow;
        }
      }).toList();
    });
  }

  // Récupérer un ticket par ID
  Future<Ticket?> getTicketById(String ticketId) async {
    try {
      final doc = await _firestore.collection('tickets').doc(ticketId).get();
      if (doc.exists) {
        return Ticket.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Error fetching ticket: $e';
    }
  }

  // Mettre à jour un ticket
  Future<void> updateTicket(Ticket ticket) async {
    try {
      await _firestore.collection('tickets').doc(ticket.id).update(
            ticket.copyWith(updatedAt: DateTime.now()).toJson(),
          );
    } catch (e) {
      throw 'Error updating ticket: $e';
    }
  }

  // Changer le statut d'un ticket
  Future<void> updateTicketStatus(String ticketId, String newStatus) async {
    try {
      await _firestore.collection('tickets').doc(ticketId).update({
        'status': newStatus,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw 'Error updating ticket status: $e';
    }
  }

  // Assigner un ticket à un utilisateur
  Future<void> assignTicket(String ticketId, String userId, String userName) async {
    try {
      await _firestore.collection('tickets').doc(ticketId).update({
        'assignedTo': userId,
        'assignedToName': userName,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw 'Error assigning ticket: $e';
    }
  }

  // Supprimer un ticket
  Future<void> deleteTicket(String ticketId) async {
    try {
      await _firestore.collection('tickets').doc(ticketId).delete();
    } catch (e) {
      throw 'Error deleting ticket: $e';
    }
  }

  // Récupérer les tickets assignés à un utilisateur
  Stream<List<Ticket>> getUserAssignedTickets(String userId) {
    return _firestore
        .collection('tickets')
        .where('assignedTo', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          return Ticket.fromJson(doc.data());
        } catch (e) {
          print('❌ Erreur fromJson sur doc ${doc.id}: $e');
          rethrow;
        }
      }).toList();
    });
  }

  // Récupérer les tickets créés par un utilisateur
  Stream<List<Ticket>> getUserCreatedTickets(String userId) {
    return _firestore
        .collection('tickets')
        .where('createdBy', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          return Ticket.fromJson(doc.data());
        } catch (e) {
          print('❌ Erreur fromJson sur doc ${doc.id}: $e');
          rethrow;
        }
      }).toList();
    });
  }
}