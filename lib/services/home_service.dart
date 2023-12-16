import 'package:wealthune/services/bank_account_service.dart';
import 'package:wealthune/services/crypto_service.dart';
import 'package:wealthune/services/investment_service.dart';
import 'package:wealthune/services/savings_account_service.dart';

/// Calcule la valeur totale du patrimoine en additionnant les soldes de différents comptes et investissements.
Future<Map<String, double>> getTotalWealth() async {
  // Utilisation du service BankAccountService pour obtenir le solde total des comptes bancaires.
  final bankAccountService = BankAccountService();
  double bankAccountsTotal = await bankAccountService.getTotalBalance();

  // Utilisation du service CryptoService pour obtenir la valeur totale des cryptomonnaies.
  final cryptoService = CryptoService();
  double cryptoTotal = await cryptoService.getTotalCryptoValue();

  // Utilisation du service InvestmentService pour obtenir la valeur totale des investissements.
  final investmentService = InvestmentService();
  double investmentsTotal = await investmentService.getTotalInvestmentValue();

  // Utilisation du service SavingsAccountService pour obtenir le solde total des comptes d'épargne.
  final savingsAccountService = SavingsAccountService();
  double savingsTotal = await savingsAccountService.getTotalSavings();

  // Retourne un Map avec la valeur totale de chaque catégorie d'actifs.
  return {
    'bankAccountsTotal': bankAccountsTotal,
    'cryptoTotal': cryptoTotal,
    'savingsTotal': savingsTotal,
    'investmentsTotal': investmentsTotal,
  };
}
