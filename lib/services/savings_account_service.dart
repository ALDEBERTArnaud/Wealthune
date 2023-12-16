import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/savings_account.dart';

/// Service pour gérer les opérations liées aux comptes d'épargne.
class SavingsAccountService {
  // Clés de stockage pour les SharedPreferences.
  static const String _storageKeySavingsAccounts = 'savingsAccounts';
  static const String _storageKeyTotalSavings = 'totalSavings';

  /// Récupère la liste des comptes d'épargne depuis les SharedPreferences.
  Future<List<SavingsAccount>> getSavingsAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKeySavingsAccounts);
    if (data != null) {
      Iterable l = json.decode(data);
      return List<SavingsAccount>.from(l.map((model) => SavingsAccount.fromJson(model)));
    }
    return [];
  }

  /// Calcule le solde total des comptes d'épargne et le sauvegarde.
  Future<double> getTotalSavings() async {
    final savingsAccounts = await getSavingsAccounts();
    final totalSavings = savingsAccounts.fold(0.0, (sum, savings) => sum + savings.balance);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_storageKeyTotalSavings, totalSavings);
    return totalSavings;
  }

  /// Sauvegarde un nouveau compte d'épargne dans les SharedPreferences.
  Future<void> saveSavingsAccount(SavingsAccount savingsAccount) async {
    final savingsAccounts = await getSavingsAccounts();
    savingsAccounts.add(savingsAccount);
    await _saveToPrefs(savingsAccounts);
  }

  /// Aide à sauvegarder la liste des comptes d'épargne dans les SharedPreferences.
  Future<void> _saveToPrefs(List<SavingsAccount> savingsAccounts) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(savingsAccounts.map((e) => e.toJson()).toList());
    prefs.setString(_storageKeySavingsAccounts, data);
  }

  /// Met à jour un compte d'épargne existant dans les SharedPreferences.
  Future<void> updateSavingsAccount(SavingsAccount updatedSavingsAccount) async {
    final savingsAccounts = await getSavingsAccounts();
    final savingsIndex = savingsAccounts.indexWhere((savings) => savings.id == updatedSavingsAccount.id);
    if (savingsIndex != -1) {
      savingsAccounts[savingsIndex] = updatedSavingsAccount;
      await _saveToPrefs(savingsAccounts);
    }
  }

  /// Supprime un compte d'épargne spécifique des SharedPreferences.
  Future<void> deleteSavingsAccount(String savingsAccountId) async {
    final savingsAccounts = await getSavingsAccounts();
    savingsAccounts.removeWhere((savings) => savings.id == savingsAccountId);
    await _saveToPrefs(savingsAccounts);
  }
}
