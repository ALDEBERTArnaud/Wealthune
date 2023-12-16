import 'package:flutter/material.dart';
import 'package:wealthune/utils/colors.dart';
import 'package:wealthune/views/savings/saving_details_screen.dart';
import 'package:wealthune/views/savings/create_saving_screen.dart';
import '../models/savings_account.dart';
import '../services/savings_account_service.dart';
import '../widgets/savings_account_card.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  // Crée l'état pour le widget SavingsScreen
  // ignore: library_private_types_in_public_api
  _SavingsScreenState createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  // Service pour gérer les comptes d'épargne
  final SavingsAccountService _savingsAccountService = SavingsAccountService();
  late Future<List<SavingsAccount>> _savingsAccountsFuture;

  @override
  void initState() {
    super.initState();
    // Initialise le Future avec la liste des comptes d'épargne
    _savingsAccountsFuture = _savingsAccountService.getSavingsAccounts();
  }

  // Fonction pour naviguer et créer un nouveau compte d'épargne
  void _navigateAndCreateSavingsAccount(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateSavingScreen()),
    );
    // Rafraîchit la liste des comptes d'épargne après la création
    setState(() {
      _savingsAccountsFuture = _savingsAccountService.getSavingsAccounts();
    });
  }

  // Fonction pour naviguer vers les détails d'un compte d'épargne
  void _navigateToSavingsAccountDetails(SavingsAccount savingsAccount) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SavingsDetailsScreen(savingsAccount: savingsAccount,
        onSavingUpdated: () {
          // Rafraîchit la liste des comptes d'épargne après la mise à jour
          setState(() {
            _savingsAccountsFuture = _savingsAccountService.getSavingsAccounts();
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
        title: const Text('Épargne', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            color: AppColors.primaryColor,
            onPressed: () => _navigateAndCreateSavingsAccount(context),
          ),
        ],
      ),
      body: FutureBuilder<List<SavingsAccount>>(
        future: _savingsAccountsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun compte d'épargne trouvé."));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final savingsAccount = snapshot.data![index];
                return SavingsAccountCard(
                  account: savingsAccount,
                  onTap: () => _navigateToSavingsAccountDetails(savingsAccount),
                );
              },
            );
          }
        },
      ),
    );
  }
}
