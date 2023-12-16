import 'package:flutter/material.dart';
import 'package:wealthune/models/investment.dart';
import 'package:wealthune/services/investment_service.dart';
import 'package:wealthune/utils/colors.dart';

/// Écran pour créer un nouvel investissement (Action/ETF).
class CreateInvestmentScreen extends StatefulWidget {
  const CreateInvestmentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateInvestmentScreenState createState() => _CreateInvestmentScreenState();
}

class _CreateInvestmentScreenState extends State<CreateInvestmentScreen> {
  final _formKey = GlobalKey<FormState>(); // Clé pour la validation du formulaire.
  // Contrôleurs pour les champs de texte.
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _currentPriceController = TextEditingController();
  final _interestRateController = TextEditingController();
  // Service pour la gestion des investissements.
  final InvestmentService _investmentService = InvestmentService();

  /// Soumet le formulaire et crée un nouvel investissement.
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Création d'un nouvel objet Investment.
      final newInvestment = Investment(
        id: DateTime.now().toString(), // Génération d'un ID unique.
        name: _nameController.text,
        quantity: double.parse(_quantityController.text),
        purchasePrice: double.parse(_purchasePriceController.text),
        currentPrice: double.parse(_currentPriceController.text),
        interestRate: double.parse(_interestRateController.text),
      );

      // Appel au service pour sauvegarder l'investissement.
      _investmentService.saveInvestment(newInvestment).then((_) {
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
    _quantityController.dispose();
    _purchasePriceController.dispose();
    _currentPriceController.dispose();
    _interestRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Construction de l'interface utilisateur de l'écran.
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        title: const Text('Ajouter une Action/ETF ', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Champ de texte pour le nom de l'investissement.
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
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
              ),
              const SizedBox(height: 10),
              // Champ de texte pour la quantité.
              TextFormField(
                controller: _quantityController,
                validator: (value) => value == null || value.isEmpty || double.tryParse(value) == null ? 'Veuillez entrer une quantité valide' : null,
                style: const TextStyle(color: AppColors.primaryColor),
                decoration: const InputDecoration(
                  labelText: 'Quantité',
                  labelStyle: TextStyle(color: AppColors.primaryColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              // Champ de texte pour le prix d'achat.
              TextFormField(
                controller: _purchasePriceController,
                validator: (value) => value == null || value.isEmpty || double.tryParse(value) == null ? 'Veuillez entrer un prix d\'achat valide' : null,
                style: const TextStyle(color: AppColors.primaryColor),
                decoration: const InputDecoration(
                  labelText: 'Prix d\'Achat',
                  labelStyle: TextStyle(color: AppColors.primaryColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              // Champ de texte pour le prix actuel.
              TextFormField(
                controller: _currentPriceController,
                validator: (value) => value == null || value.isEmpty || double.tryParse(value) == null ? 'Veuillez entrer un prix actuel valide' : null,
                style: const TextStyle(color: AppColors.primaryColor),
                decoration: const InputDecoration(
                  labelText: 'Prix Actuel',
                  labelStyle: TextStyle(color: AppColors.primaryColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              // Champ de texte pour le taux d'intérêt.
              TextFormField(
                controller: _interestRateController,
                validator: (value) => value == null || value.isEmpty || double.tryParse(value) == null ? 'Veuillez entrer un taux d\'intérêt valide' : null,
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
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              // Bouton pour soumettre le formulaire et ajouter l'investissement.
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
