import 'package:flutter/material.dart';
import 'package:wealthune/utils/colors.dart';
import 'package:wealthune/views/account/account_details_screen.dart';
import 'package:wealthune/views/account/create_account_screen.dart';
import '../models/bank_account.dart';
import '../services/bank_account_service.dart';
import '../widgets/bank_account_card.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final BankAccountService _accountService = BankAccountService();
  late Future<List<BankAccount>> _accountsFuture;

  @override
  void initState() {
    super.initState();
    _accountsFuture = _accountService.getAccounts(); // Initialisation de la liste de comptes
  }

  void _navigateAndCreateAccount(BuildContext context) async {
    // Naviguer vers CreateAccountScreen
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateAccountScreen()),
    );
    // Recharger les comptes après la création
    setState(() {
      _accountsFuture = _accountService.getAccounts();
    });
  }

  void _navigateToAccountDetails(BankAccount account) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AccountDetailsScreen(
        account: account,
        onAccountUpdated: () {
          // Rafraîchir la liste des comptes
          setState(() {
            _accountsFuture = _accountService.getAccounts();
          });
        },
      ),
    ),
  );
  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/logo_wealthune.png', height: 50,),
        title: const Text('Comptes en Banque', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            color: AppColors.primaryColor,
            onPressed: () => _navigateAndCreateAccount(context),
          ),
        ],
      ),
       body: FutureBuilder<List<BankAccount>>(
        future: _accountsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Afficher une icône de chargement en cas d'attente
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}')); // Afficher un message d'erreur en cas d'erreur
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun compte bancaire trouvé.")); // Afficher un message si aucun compte n'est trouvé
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final account = snapshot.data![index];
                return BankAccountCard(
                  account: account,
                  onTap: () => _navigateToAccountDetails(account),
                );
              },
            );
          }
        },
      ),
    );
  }
}
