import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cryptocurrency.dart';

class CryptoService {
  static const String _storageKeyCryptocurrencies = 'cryptocurrencies';

  Future<List<Cryptocurrency>> getCryptocurrencies() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKeyCryptocurrencies);
    if (data != null) {
      List<dynamic> jsonData = jsonDecode(data);
      return jsonData.map((item) => Cryptocurrency.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> saveCryptocurrency(Cryptocurrency crypto) async {
    final prefs = await SharedPreferences.getInstance();
    List<Cryptocurrency> cryptos = await getCryptocurrencies();
    cryptos.add(crypto);
    List<Map<String, dynamic>> jsonData =
        cryptos.map((c) => c.toJson()).toList();
    await prefs.setString(_storageKeyCryptocurrencies, jsonEncode(jsonData));
  }

  Future<void> updateCryptocurrency(Cryptocurrency updatedCrypto) async {
    final prefs = await SharedPreferences.getInstance();
    List<Cryptocurrency> cryptos = await getCryptocurrencies();
    int index =
        cryptos.indexWhere((crypto) => crypto.id == updatedCrypto.id);
    if (index != -1) {
      cryptos[index] = updatedCrypto;
      List<Map<String, dynamic>> jsonData =
          cryptos.map((c) => c.toJson()).toList();
      await prefs.setString(_storageKeyCryptocurrencies, jsonEncode(jsonData));
    }
  }

  Future<void> deleteCryptocurrency(String cryptoId) async {
    final prefs = await SharedPreferences.getInstance();
    List<Cryptocurrency> cryptos = await getCryptocurrencies();
    cryptos.removeWhere((crypto) => crypto.id == cryptoId);
    List<Map<String, dynamic>> jsonData =
        cryptos.map((c) => c.toJson()).toList();
    await prefs.setString(_storageKeyCryptocurrencies, jsonEncode(jsonData));
  }

  // Méthode pour obtenir les symboles des cryptomonnaies si nécessaire
  Future<List<String>> getCryptoSymbols() async {
    List<Cryptocurrency> cryptos = await getCryptocurrencies();
    return cryptos.map((crypto) => crypto.name).toList();
  }
}