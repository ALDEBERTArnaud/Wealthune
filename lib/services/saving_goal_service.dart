import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saving_goal.dart';

/// Service pour gérer les opérations liées aux objectifs d'épargne.
class SavingGoalService {
  // Clé de stockage pour les SharedPreferences.
  static const String _storageKey = 'savingGoals';

  /// Récupère la liste des objectifs d'épargne depuis les SharedPreferences.
  Future<List<SavingGoal>> getSavingGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data != null) {
      Iterable l = json.decode(data);
      return List<SavingGoal>.from(l.map((model) => SavingGoal.fromJson(model)));
    }
    return [];
  }

  /// Sauvegarde un nouvel objectif d'épargne dans les SharedPreferences.
  Future<void> saveSavingGoal(SavingGoal goal) async {
    final goals = await getSavingGoals();
    goals.add(goal);
    await _saveToPrefs(goals);
  }

  /// Met à jour un objectif d'épargne existant dans les SharedPreferences.
  Future<void> updateSavingGoal(SavingGoal updatedGoal) async {
    final goals = await getSavingGoals();
    final goalIndex = goals.indexWhere((goal) => goal.id == updatedGoal.id);
    if (goalIndex != -1) {
      goals[goalIndex] = updatedGoal;
      await _saveToPrefs(goals);
    }
  }

  /// Supprime un objectif d'épargne spécifique des SharedPreferences.
  Future<void> deleteSavingGoal(String goalId) async {
    final goals = await getSavingGoals();
    goals.removeWhere((goal) => goal.id == goalId);
    await _saveToPrefs(goals);
  }

  /// Aide à sauvegarder la liste des objectifs d'épargne dans les SharedPreferences.
  Future<void> _saveToPrefs(List<SavingGoal> goals) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(goals.map((e) => e.toJson()).toList());
    prefs.setString(_storageKey, data);
  }
}
