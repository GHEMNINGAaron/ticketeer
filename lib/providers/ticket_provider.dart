import 'package:flutter/material.dart';
import '../models/ticket.dart';
import '../services/ticket_service.dart';

class TicketProvider extends ChangeNotifier {
  final TicketService _ticketService = TicketService();

  List<Ticket> _tickets = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentTeamId;

  List<Ticket> get tickets => _tickets;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get currentTeamId => _currentTeamId;

  // Définir l'équipe courante
  void setCurrentTeam(String teamId) {
    _currentTeamId = teamId;
    loadTeamTickets(teamId);
  }

  // Charger les tickets d'une équipe
  void loadTeamTickets(String teamId) {
    _isLoading = true;
    notifyListeners();

    _ticketService.getTeamTickets(teamId).listen(
      (tickets) {
        _tickets = tickets;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Créer un ticket
  Future<bool> createTicket(Ticket ticket) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _ticketService.createTicket(ticket);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Mettre à jour un ticket
  Future<bool> updateTicket(Ticket ticket) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _ticketService.updateTicket(ticket);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Changer le statut d'un ticket
  Future<bool> updateTicketStatus(String ticketId, String newStatus) async {
    try {
      await _ticketService.updateTicketStatus(ticketId, newStatus);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Assigner un ticket
  Future<bool> assignTicket(String ticketId, String userId, String userName) async {
    try {
      await _ticketService.assignTicket(ticketId, userId, userName);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Supprimer un ticket
  Future<bool> deleteTicket(String ticketId) async {
    try {
      await _ticketService.deleteTicket(ticketId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Filtrer les tickets par statut
  List<Ticket> getTicketsByStatus(String status) {
    return _tickets.where((ticket) => ticket.status == status).toList();
  }

  // Effacer les erreurs
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}