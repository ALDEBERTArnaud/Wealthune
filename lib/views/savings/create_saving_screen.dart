import 'package:flutter/material.dart';
import 'package:wealthune/models/savings_account.dart';
import 'package:wealthune/services/savings_account_service.dart';
import 'package:wealthune/utils/colors.dart';

/// Écran pour créer un nouveau compte d'épargne.
class CreateSavingScreen extends StatefulWidget {
  const CreateSavingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateSavingScreenState createState() => _CreateSavingScreenState();
}

class _CreateSavingScreenState extends State<CreateSavingScreen> {
  final _formKey = GlobalKey<FormState>(); // Clé pour la validation du formulaire.
  // Contrôleurs pour les champs de texte.
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _interestRateController = TextEditingController();
  // Service pour la gestion des comptes d'épargne.
  final SavingsAccountService _savingsAccountService = SavingsAccountService();

  /// Soumet le formulaire et crée un nouveau compte d'épargne.
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Création d'un nouvel objet SavingsAccount.
      final newSavingsAccount = SavingsAccount(
        id: DateTime.now().toString(), // Génération d'un ID unique.
        name: _nameController.text,
        balance: double.parse(_balanceController.text),
        interestRate: double.parse(_interestRateController.text),
      );

      // Appel au service pour sauvegarder le compte d'épargne.
      _savingsAccountService.saveSavingsAccount(newSavingsAccount).then((_) {
        Navigator.of(context).pop(); // Retour à l'écran précédent après la création.
      }).catchError((error) {
        // Gérer l'erreur ici.
      });
    }
  }

  @override
  void dispose() {
    // Nettoyage des contrôleurs lors de la destruction de l'état.
    _nameController.dispose();
    _balanceController.dispose();
    _interestRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Construction de l'interface utilisateur de l'écran.
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        title: const Text('Ajouter une Épargne', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Champ de texte pour le nom du compte d'épargne.
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom de compte';
                  }
                  return null;
                },
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
              // Champ de texte pour le solde initial.
              TextFormField(
                controller: _balanceController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un solde initial';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
                style: const TextStyle(color: AppColors.primaryColor),
                decoration: const InputDecoration(
                  labelText: 'Solde Initial',
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
              const SizedBox(height: 10),
              // Champ de texte pour le taux d'intérêt.
              TextFormField(
                controller: _interestRateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un taux d\'intérêt';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
                style: const TextStyle(color: AppColors.primaryColor),
                decoration: const InputDecoration(
                  labelText: 'Taux d\'Intérêt',
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
              // Bouton pour soumettre le formulaire et ajouter le compte d'épargne.
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                child: const Text('Ajouter', style: TextStyle(color: AppColors.secondaryColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
