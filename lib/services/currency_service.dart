import 'package:shared_preferences/shared_preferences.dart';

class CurrencyService {
  static const String _currencyKey = 'selectedCurrency';

  Future<void> setCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency);
  }

  Future<String> getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey) ?? 'EUR';
  }
}