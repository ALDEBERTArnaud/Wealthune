import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cryptocurrency.dart';

/// Service pour gérer les opérations liées aux cryptomonnaies.
class CryptoService {
  // Clés de stockage pour les SharedPreferences.
  static const String _storageKeyCryptocurrencies = 'cryptocurrencies';
  static const String _storageKeyTotalCrypto = 'totalCrypto';

  /// Récupère la liste des cryptomonnaies depuis les SharedPreferences.
  Future<List<Cryptocurrency>> getCryptocurrencies() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKeyCryptocurrencies);
    if (data != null) {
      Iterable l = json.decode(data);
      return List<Cryptocurrency>.from(l.map((model) => Cryptocurrency.fromJson(model)));
    }
    return [];
  }

  /// Calcule la valeur totale des cryptomonnaies et la sauvegarde.
  Future<double> getTotalCryptoValue() async {
    final cryptocurrencies = await getCryptocurrencies();
    final totalCryptoValue = cryptocurrencies.fold(0.0, (sum, crypto) => sum + (crypto.quantity * crypto.currentPrice));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_storageKeyTotalCrypto, totalCryptoValue);
    return totalCryptoValue;
  }

  /// Sauvegarde une nouvelle cryptomonnaie dans les SharedPreferences.
  Future<void> saveCryptocurrency(Cryptocurrency cryptocurrency) async {
    final cryptocurrencies = await getCryptocurrencies();
    cryptocurrencies.add(cryptocurrency);
    await _saveToPrefs(cryptocurrencies);
  }

  /// Aide à sauvegarder la liste des cryptomonnaies dans les SharedPreferences.
  Future<void> _saveToPrefs(List<Cryptocurrency> cryptocurrencies) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(cryptocurrencies.map((e) => e.toJson()).toList());
    prefs.setString(_storageKeyCryptocurrencies, data);
  }

  /// Met à jour une cryptomonnaie existante dans les SharedPreferences.
  Future<void> updateCryptocurrency(Cryptocurrency updatedCryptocurrency) async {
    final cryptocurrencies = await getCryptocurrencies();
    final cryptoIndex = cryptocurrencies.indexWhere((crypto) => crypto.id == updatedCryptocurrency.id);
    if (cryptoIndex != -1) {
      cryptocurrencies[cryptoIndex] = updatedCryptocurrency;
      await _saveToPrefs(cryptocurrencies);
    }
  }

  /// Supprime une cryptomonnaie spécifique des SharedPreferences.
  Future<void> deleteCryptocurrency(String cryptocurrencyId) async {
    final cryptocurrencies = await getCryptocurrencies();
    cryptocurrencies.removeWhere((crypto) => crypto.id == cryptocurrencyId);
    await _saveToPrefs(cryptocurrencies);
  }

}
