import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/investment.dart';

class InvestmentService {
  static const String _storageKeyInvestments = 'investments';

  Future<List<Investment>> getInvestments() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKeyInvestments);
    if (data != null) {
      List<dynamic> jsonData = jsonDecode(data);
      return jsonData.map((item) => Investment.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> saveInvestment(Investment investment) async {
    final prefs = await SharedPreferences.getInstance();
    List<Investment> investments = await getInvestments();
    investments.add(investment);
    List<Map<String, dynamic>> jsonData =
        investments.map((inv) => inv.toJson()).toList();
    await prefs.setString(_storageKeyInvestments, jsonEncode(jsonData));
  }

  Future<void> updateInvestment(Investment updatedInvestment) async {
    final prefs = await SharedPreferences.getInstance();
    List<Investment> investments = await getInvestments();
    int index =
        investments.indexWhere((investment) => investment.id == updatedInvestment.id);
    if (index != -1) {
      investments[index] = updatedInvestment;
      List<Map<String, dynamic>> jsonData =
          investments.map((inv) => inv.toJson()).toList();
      await prefs.setString(_storageKeyInvestments, jsonEncode(jsonData));
    }
  }

  Future<void> deleteInvestment(String investmentId) async {
    final prefs = await SharedPreferences.getInstance();
    List<Investment> investments = await getInvestments();
    investments.removeWhere((investment) => investment.id == investmentId);
    List<Map<String, dynamic>> jsonData =
        investments.map((inv) => inv.toJson()).toList();
    await prefs.setString(_storageKeyInvestments, jsonEncode(jsonData));
  }
}