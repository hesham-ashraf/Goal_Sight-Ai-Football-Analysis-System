import 'package:flutter/foundation.dart';
import '../models/match.dart';
import '../database/database_helper.dart';
import '../services/api_service.dart';

class MatchProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final ApiService _apiService = ApiService();

  List<Match> _matches = [];
  bool _isLoading = false;
  String? _error;

  List<Match> get matches => _matches;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMatches() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _matches = await _dbHelper.getAllMatches();
      _error = null;
    } catch (e) {
      _error = 'Failed to load matches: $e';
      _matches = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addMatch(Match match) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _dbHelper.insertMatch(match);
      await loadMatches();
      return true;
    } catch (e) {
      _error = 'Failed to add match: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateMatch(Match match) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _dbHelper.updateMatch(match);
      await loadMatches();
      return true;
    } catch (e) {
      _error = 'Failed to update match: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteMatch(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _dbHelper.deleteMatch(id);
      await loadMatches();
      return true;
    } catch (e) {
      _error = 'Failed to delete match: $e';
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>?> fetchMatchDataFromAPI() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.fetchMatchData();
      _error = null;
      return data;
    } catch (e) {
      _error = 'Failed to fetch data from API: $e';
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

