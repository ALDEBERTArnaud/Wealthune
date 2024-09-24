import 'package:flutter/material.dart';
import 'package:wealthune/utils/colors.dart';
import 'package:wealthune/models/bank_account.dart';
import 'package:wealthune/models/cryptocurrency.dart';
import 'package:wealthune/models/savings_account.dart';
import 'package:wealthune/models/investment.dart';
import 'package:wealthune/services/bank_account_service.dart';
import 'package:wealthune/services/crypto_service.dart';
import 'package:wealthune/services/savings_account_service.dart';
import 'package:wealthune/services/investment_service.dart';
import 'package:wealthune/views/account/account_details_screen.dart';
import 'package:wealthune/views/crypto/crypto_details_screen.dart';
import 'package:wealthune/views/savings/saving_details_screen.dart';
import 'package:wealthune/views/investments/investment_details_screen.dart';
import 'package:wealthune/views/account/create_account_screen.dart';
import 'package:wealthune/views/crypto/create_crypto_screen.dart';
import 'package:wealthune/views/savings/create_saving_screen.dart';
import 'package:wealthune/views/investments/create_investment_screen.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final BankAccountService _accountService = BankAccountService();
  final CryptoService _cryptoService = CryptoService();
  final SavingsAccountService _savingsService = SavingsAccountService();
  final InvestmentService _investmentService = InvestmentService();

  late Future<List<BankAccount>> _accountsFuture;
  late Future<List<Cryptocurrency>> _cryptosFuture;
  late Future<List<SavingsAccount>> _savingsFuture;
  late Future<List<Investment>> _investmentsFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _accountsFuture = _accountService.getAccounts();
      _cryptosFuture = _cryptoService.getCryptocurrencies();
      _savingsFuture = _savingsService.getSavingsAccounts();
      _investmentsFuture = _investmentService.getInvestments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portefeuille', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: ListView(
        children: [
          _buildSection('Comptes bancaires', _accountsFuture, (account) => Text('${account.name}: ${account.balance} €')),
          _buildSection('Cryptomonnaies', _cryptosFuture, (crypto) => Text('${crypto.name}: ${crypto.quantity}')),
          _buildSection('Épargnes', _savingsFuture, (savings) => Text('${savings.name}: ${savings.balance} €')),
          _buildSection('Investissements', _investmentsFuture, (investment) => Text('${investment.name}: ${investment.quantity} actions')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAssetMenu(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildSection<T>(String title, Future<List<T>> future, Widget Function(T) itemBuilder) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(color: AppColors.primaryColor)),
      children: [
        FutureBuilder<List<T>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Aucune donnée disponible');
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  return ListTile(
                    title: itemBuilder(item),
                    onTap: () {
                      _navigateToDetailsScreen(context, item);
                    },
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }

  void _navigateToDetailsScreen(BuildContext context, dynamic item) {
    if (item is BankAccount) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AccountDetailsScreen(account: item, onAccountUpdated: _refreshData)),
      );
    } else if (item is Cryptocurrency) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CryptoDetailsScreen(cryptocurrency: item, onCryptoUpdated: _refreshData)),
      );
    } else if (item is SavingsAccount) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SavingsDetailsScreen(savingsAccount: item, onSavingUpdated: _refreshData)),
      );
    } else if (item is Investment) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InvestmentDetailsScreen(investment: item, onInvestmentUpdated: _refreshData)),
      );
    }
  }

  void _showAddAssetMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.account_balance),
                title: const Text('Ajouter un compte bancaire'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAccountScreen(onAccountCreated: _refreshData)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.currency_bitcoin),
                title: const Text('Ajouter une cryptomonnaie'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateCryptoScreen(onCryptoCreated: _refreshData)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.savings),
                title: const Text('Ajouter une épargne'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateSavingScreen(onSavingsCreated: _refreshData)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.trending_up),
                title: const Text('Ajouter un investissement'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateInvestmentScreen(onInvestmentCreated: _refreshData)),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}