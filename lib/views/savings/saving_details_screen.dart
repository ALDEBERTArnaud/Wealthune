import 'package:flutter/material.dart';
import 'package:wealthune/models/savings_account.dart';
import 'package:wealthune/services/savings_account_service.dart';
import 'package:wealthune/utils/colors.dart';

class SavingsDetailsScreen extends StatefulWidget {
  final SavingsAccount savingsAccount; // Le compte d'épargne à afficher
  final Function onSavingUpdated; // Fonction de mise à jour appelée après modification

  const SavingsDetailsScreen({super.key, required this.savingsAccount, required this.onSavingUpdated});

  @override
  // ignore: library_private_types_in_public_api
  _SavingsDetailsScreenState createState() => _SavingsDetailsScreenState();
}

class _SavingsDetailsScreenState extends State<SavingsDetailsScreen> {
  final SavingsAccountService _savingsAccountService = SavingsAccountService();
  late TextEditingController _nameController; // Contrôleur pour le nom
  late TextEditingController _balanceController; // Contrôleur pour le solde
  late TextEditingController _interestRateController; // Contrôleur pour le taux d'intérêt

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.savingsAccount.name); // Initialiser le nom
    _balanceController = TextEditingController(text: widget.savingsAccount.balance.toString()); // Initialiser le solde
    _interestRateController = TextEditingController(text: widget.savingsAccount.interestRate.toString()); // Initialiser le taux d'intérêt
  }

  void _updateSavingsAccount() {
    final updatedSavingsAccount = SavingsAccount(
      id: widget.savingsAccount.id,
      name: _nameController.text, // Nom mis à jour
      balance: double.tryParse(_balanceController.text) ?? widget.savingsAccount.balance, // Solde mis à jour
      interestRate: double.tryParse(_interestRateController.text) ?? widget.savingsAccount.interestRate, // Taux d'intérêt mis à jour
    );

    _savingsAccountService.updateSavingsAccount(updatedSavingsAccount).then((_) {
    widget.onSavingUpdated(); // Appeler le callback de mise à jour
    Navigator.of(context).pop(); // Fermer l'écran de détails
  }).catchError((error) {
    // Gérer l'erreur
  });
}

  void _deleteSavingsAccount() {
    _savingsAccountService.deleteSavingsAccount(widget.savingsAccount.id).then((_) {
      widget.onSavingUpdated(); // Appeler le callback de suppression
    Navigator.of(context).pop(); // Fermer l'écran de détails
  }).catchError((error) {
    // Gérer l'erreur
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        title: const Text('Détails de l\'Épargne', style: TextStyle(color: AppColors.primaryColor)), // Titre de l'écran
        backgroundColor: AppColors.secondaryColor, // Couleur de l'arrière-plan de l'app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: AppColors.primaryColor),
              decoration: const InputDecoration(
                labelText: 'Nom du Compte',
                labelStyle: TextStyle(color: AppColors.primaryColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _balanceController,
              style: const TextStyle(color: AppColors.primaryColor),
              decoration: const InputDecoration(
                labelText: 'Solde',
                labelStyle: TextStyle(color: AppColors.primaryColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.number, // Clavier numérique pour le solde
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _interestRateController,
              style: const TextStyle(color: AppColors.primaryColor),
              decoration: const InputDecoration(
                labelText: 'Taux d\'Intérêt (%)',
                labelStyle: TextStyle(color: AppColors.primaryColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.number, // Clavier numérique pour le taux d'intérêt
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _updateSavingsAccount,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.confirmationColor),
              child: const Text('Modifier', style: TextStyle(color: AppColors.secondaryColor)), // Bouton de modification
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _deleteSavingsAccount,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorColor),
              child: const Text('Supprimer', style: TextStyle(color: AppColors.secondaryColor)), // Bouton de suppression
            ),
          ],
        ),
      ),
      
    );
  }

  @override
  void dispose() {
    _nameController.dispose(); // Libérer le contrôleur du nom
    _balanceController.dispose(); // Libérer le contrôleur du solde
    _interestRateController.dispose(); // Libérer le contrôleur du taux d'intérêt
    super.dispose();
  }
}
