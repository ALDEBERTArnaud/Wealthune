import 'package:flutter/material.dart';
import 'package:wealthune/models/bank_account.dart';
import 'package:wealthune/services/bank_account_service.dart';
import 'package:wealthune/utils/colors.dart';

/// Écran pour créer un nouveau compte bancaire.
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  // Clé pour identifier le formulaire et gérer la validation.
  final _formKey = GlobalKey<FormState>();
  // Contrôleurs pour les champs de texte du nom et du solde du compte.
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  // Service pour interagir avec la couche de données des comptes bancaires.
  final BankAccountService _accountService = BankAccountService();

  /// Soumet le formulaire et crée un nouveau compte bancaire.
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Création d'un nouvel objet BankAccount avec un ID unique.
      final newAccount = BankAccount(
        id: DateTime.now().toString(), // Générer un ID unique pour le compte.
        name: _nameController.text,
        balance: double.parse(_balanceController.text),
      );

      // Appel au service pour sauvegarder le nouveau compte.
      _accountService.saveAccount(newAccount).then((_) {
        Navigator.of(context).pop(); // Retour à l'écran précédent après la création.
      }).catchError((error) {
        // Gérer l'erreur ici, par exemple en affichant une snackbar.
      });
    }
  }

  @override
  void dispose() {
    // Nettoyage des contrôleurs lors de la destruction de l'état.
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Construction de l'interface utilisateur de l'écran.
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        title: const Text('Ajouter un Compte', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Champ de texte pour le nom du compte.
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
              // Champ de texte pour le solde du compte.
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
              // Bouton pour soumettre le formulaire et ajouter le compte.
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
