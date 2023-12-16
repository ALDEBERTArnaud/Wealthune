import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bank_account.dart';

/// Service pour gérer les opérations liées aux comptes bancaires.
class BankAccountService {
  // Clés de stockage pour les SharedPreferences.
  static const String _storageKeyBankAccounts = 'bankAccounts';
  static const String _storageKeyTotalBalance = 'totalBalance';

  /// Récupère la liste des comptes bancaires depuis les SharedPreferences.
  Future<List<BankAccount>> getAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKeyBankAccounts);
    if (data != null) {
      Iterable l = json.decode(data);
      return List<BankAccount>.from(l.map((model) => BankAccount.fromJson(model)));
    }
    return [];
  }

  /// Calcule le solde total de tous les comptes et le sauvegarde.
  Future<double> getTotalBalance() async {
    final accounts = await getAccounts();
    final totalBalance = accounts.fold(0.0, (sum, account) => sum + account.balance);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_storageKeyTotalBalance, totalBalance);
    return totalBalance;
  }

  /// Sauvegarde un nouveau compte dans les SharedPreferences.
  Future<void> saveAccount(BankAccount account) async {
    final accounts = await getAccounts();
    accounts.add(account);
    await _saveToPrefs(accounts);
  }

  /// Aide à sauvegarder la liste des comptes dans les SharedPreferences.
  Future<void> _saveToPrefs(List<BankAccount> accounts) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(accounts.map((e) => e.toJson()).toList());
    prefs.setString(_storageKeyBankAccounts, data);
  }

  /// Met à jour un compte existant dans les SharedPreferences.
  Future<void> updateAccount(BankAccount updatedAccount) async {
    final accounts = await getAccounts();
    final accountIndex = accounts.indexWhere((account) => account.id == updatedAccount.id);
    if (accountIndex != -1) {
      accounts[accountIndex] = updatedAccount;
      await _saveToPrefs(accounts);
    }
  }

  /// Supprime un compte spécifique des SharedPreferences.
  Future<void> deleteAccount(String accountId) async {
    final accounts = await getAccounts();
    accounts.removeWhere((account) => account.id == accountId);
    await _saveToPrefs(accounts);
  }

}
