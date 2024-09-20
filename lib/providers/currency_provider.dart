import 'package:flutter/foundation.dart';
import 'package:wealthune/services/currency_service.dart';

class CurrencyProvider with ChangeNotifier {
  String _currency = 'EUR';
  final CurrencyService _currencyService = CurrencyService();

  String get currency => _currency;

  CurrencyProvider() {
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    _currency = await _currencyService.getCurrency();
    notifyListeners();
  }

  Future<void> setCurrency(String currency) async {
    await _currencyService.setCurrency(currency);
    _currency = currency;
    notifyListeners();
  }
}