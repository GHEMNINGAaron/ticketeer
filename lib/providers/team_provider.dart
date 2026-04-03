import 'package:flutter/material.dart';
import '../models/team.dart';
import '../services/team_service.dart';

class TeamProvider extends ChangeNotifier {
  final TeamService _teamService = TeamService();

  List<Team> _teams = [];
  Team? _currentTeam;
  bool _isLoading = false;
  String? _errorMessage;

  List<Team> get teams => _teams;
  Team? get currentTeam => _currentTeam;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Charger les équipes d'un utilisateur
  void loadUserTeams(String userId) {
    _isLoading = true;
    notifyListeners();

    _teamService.getUserTeams(userId).listen(
      (teams) {
        _teams = teams;
        
        // Définir la première équipe comme équipe courante si elle n'est pas déjà définie
        if (_currentTeam == null && teams.isNotEmpty) {
          _currentTeam = teams.first;
        }
        
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

  // Définir l'équipe courante
  void setCurrentTeam(Team team) {
    _currentTeam = team;
    notifyListeners();
  }

  // Créer une équipe
  Future<bool> createTeam(Team team) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _teamService.createTeam(team);

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

  // Ajouter un membre à une équipe
  Future<bool> addMember(String teamId, String userId) async {
    try {
      await _teamService.addMemberToTeam(teamId, userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Retirer un membre d'une équipe
  Future<bool> removeMember(String teamId, String userId) async {
    try {
      await _teamService.removeMemberFromTeam(teamId, userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Effacer les erreurs
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}