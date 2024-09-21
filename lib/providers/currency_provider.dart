import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider with ChangeNotifier {
  String _currency = 'EUR';

  String get currency => _currency;

  CurrencyProvider() {
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _currency = prefs.getString('currency') ?? 'EUR';
    notifyListeners();
  }

  Future<void> setCurrency(String newCurrency) async {
    if (_currency != newCurrency) {
      _currency = newCurrency;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('currency', newCurrency);
      notifyListeners();
    }
  }
}