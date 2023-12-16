import 'package:flutter/material.dart';
import 'package:wealthune/models/bank_account.dart';
import 'package:wealthune/services/bank_account_service.dart';
import 'package:wealthune/utils/colors.dart';

/// Écran pour afficher et modifier les détails d'un compte bancaire.
class AccountDetailsScreen extends StatefulWidget {
  final BankAccount account; // Le compte bancaire à afficher et modifier.
  final Function onAccountUpdated; // Callback pour les mises à jour du compte.

  // Constructeur avec des paramètres requis pour le compte et le callback.
  const AccountDetailsScreen({super.key, required this.account, required this.onAccountUpdated});

  @override
  // ignore: library_private_types_in_public_api
  _AccountDetailsScreenState createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final BankAccountService _accountService = BankAccountService(); // Service pour gérer les comptes bancaires.
  late TextEditingController _nameController; // Contrôleur pour le nom du compte.
  late TextEditingController _balanceController; // Contrôleur pour le solde du compte.

  @override
  void initState() {
    super.initState();
    // Initialisation des contrôleurs de texte avec les valeurs actuelles du compte.
    _nameController = TextEditingController(text: widget.account.name);
    _balanceController = TextEditingController(text: widget.account.balance.toString());
  }

  /// Met à jour les informations du compte bancaire.
  void _updateAccount() {
    final updatedAccount = BankAccount(
      id: widget.account.id,
      name: _nameController.text,
      balance: double.tryParse(_balanceController.text) ?? widget.account.balance,
    );

    // Appel au service de mise à jour du compte.
    _accountService.updateAccount(updatedAccount).then((_) {
      widget.onAccountUpdated(); // Appeler le callback après la mise à jour.
      Navigator.of(context).pop(); // Retour à l'écran précédent.
    }).catchError((error) {
      // Gestion des erreurs ici.
    });
  }

  /// Supprime le compte bancaire actuel.
  void _deleteAccount() {
    _accountService.deleteAccount(widget.account.id).then((_) {
      widget.onAccountUpdated(); // Appeler le callback après la suppression.
      Navigator.of(context).pop(); // Retour à l'écran précédent.
    }).catchError((error) {
      // Gestion des erreurs ici.
    });
  }

  @override
  Widget build(BuildContext context) {
    // Construction de l'interface utilisateur de l'écran.
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        title: const Text('Détails du compte', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Champ de texte pour le nom du compte.
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
            // Champ de texte pour le solde du compte.
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
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            // Bouton pour mettre à jour le compte.
            ElevatedButton(
              onPressed: _updateAccount,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.confirmationColor),
              child: const Text('Modifier', style: TextStyle(color: AppColors.secondaryColor)), // Couleur du texte ici
            ),
            const SizedBox(height: 10),
            // Bouton pour supprimer le compte.
            ElevatedButton(
              onPressed: _deleteAccount,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorColor),
              child: const Text('Supprimer', style: TextStyle(color: AppColors.secondaryColor)), // Couleur du texte ici
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Nettoyage des contrôleurs lors de la suppression de l'état.
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }
}
