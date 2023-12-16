import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/investment.dart';

/// Service pour gérer les opérations liées aux investissements.
class InvestmentService {
  // Clés pour les SharedPreferences.
  static const String _storageKeyInvestments = 'investments';
  static const String _storageKeyTotalInvestments = 'totalInvestments';

  /// Récupère la liste des investissements depuis les SharedPreferences.
  Future<List<Investment>> getInvestments() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKeyInvestments);
    if (data != null) {
      Iterable l = json.decode(data);
      return List<Investment>.from(l.map((model) => Investment.fromJson(model)));
    }
    return [];
  }

  /// Calcule la valeur totale des investissements et la sauvegarde.
  Future<double> getTotalInvestmentValue() async {
    final investments = await getInvestments();
    final totalInvestmentValue = investments.fold(0.0, (sum, investment) => sum + (investment.quantity * investment.currentPrice));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_storageKeyTotalInvestments, totalInvestmentValue);
    return totalInvestmentValue;
  }

  /// Sauvegarde un nouvel investissement dans les SharedPreferences.
  Future<void> saveInvestment(Investment investment) async {
    final investments = await getInvestments();
    investments.add(investment);
    await _saveToPrefs(investments);
  }

  /// Aide à sauvegarder la liste des investissements dans les SharedPreferences.
  Future<void> _saveToPrefs(List<Investment> investments) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(investments.map((e) => e.toJson()).toList());
    prefs.setString(_storageKeyInvestments, data);
  }

  /// Met à jour un investissement existant dans les SharedPreferences.
  Future<void> updateInvestment(Investment updatedInvestment) async {
    final investments = await getInvestments();
    final investmentIndex = investments.indexWhere((investment) => investment.id == updatedInvestment.id);
    if (investmentIndex != -1) {
      investments[investmentIndex] = updatedInvestment;
      await _saveToPrefs(investments);
    }
  }

  /// Supprime un investissement spécifique des SharedPreferences.
  Future<void> deleteInvestment(String investmentId) async {
    final investments = await getInvestments();
    investments.removeWhere((investment) => investment.id == investmentId);
    await _saveToPrefs(investments);
  }
}
