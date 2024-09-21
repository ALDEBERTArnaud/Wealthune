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
          _buildSection('Comptes bancaires', _accountsFuture, (account) => Text(account.name)),
          _buildSection('Cryptomonnaies', _cryptosFuture, (crypto) => Text(crypto.name)),
          _buildSection('Épargnes', _savingsFuture, (savings) => Text(savings.name)),
          _buildSection('Investissements', _investmentsFuture, (investment) => Text(investment.name)),
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
              return Column(
                children: snapshot.data!.map((item) => itemBuilder(item)).toList(),
              );
            }
          },
        ),
      ],
    );
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
                  // Naviguer vers l'écran d'ajout de compte bancaire
                },
              ),
              ListTile(
                leading: const Icon(Icons.currency_bitcoin),
                title: const Text('Ajouter une cryptomonnaie'),
                onTap: () {
                  Navigator.pop(context);
                  // Naviguer vers l'écran d'ajout de cryptomonnaie
                },
              ),
              ListTile(
                leading: const Icon(Icons.savings),
                title: const Text('Ajouter une épargne'),
                onTap: () {
                  Navigator.pop(context);
                  // Naviguer vers l'écran d'ajout d'épargne
                },
              ),
              ListTile(
                leading: const Icon(Icons.trending_up),
                title: const Text('Ajouter un investissement'),
                onTap: () {
                  Navigator.pop(context);
                  // Naviguer vers l'écran d'ajout d'investissement
                },
              ),
            ],
          ),
        );
      },
    );
  }
}