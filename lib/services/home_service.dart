import 'package:wealthune/services/bank_account_service.dart';
import 'package:wealthune/services/crypto_service.dart';
import 'package:wealthune/services/savings_account_service.dart';
import 'package:wealthune/services/investment_service.dart';

Future<Map<String, double>> getTotalWealth() async {
  final bankAccountService = BankAccountService();
  final cryptoService = CryptoService();
  final savingsService = SavingsAccountService();
  final investmentService = InvestmentService();

  final accounts = await bankAccountService.getAccounts();
  final cryptos = await cryptoService.getCryptocurrencies();
  final savings = await savingsService.getSavingsAccounts();
  final investments = await investmentService.getInvestments();

  double bankAccountsTotal = accounts.fold(0, (sum, account) => sum + account.balance);
  double cryptoTotal = cryptos.fold(0, (sum, crypto) => sum + (crypto.quantity * crypto.currentPrice));
  double savingsTotal = savings.fold(0, (sum, saving) => sum + saving.balance);
  double investmentsTotal = investments.fold(0, (sum, investment) => sum + (investment.quantity * investment.currentPrice));

  return {
    'bankAccountsTotal': bankAccountsTotal,
    'cryptoTotal': cryptoTotal,
    'savingsTotal': savingsTotal,
    'investmentsTotal': investmentsTotal,
  };
}
