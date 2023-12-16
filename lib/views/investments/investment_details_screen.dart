import 'package:flutter/material.dart';
import 'package:wealthune/models/investment.dart';
import 'package:wealthune/services/investment_service.dart';
import 'package:wealthune/utils/colors.dart';

/// Écran pour afficher et modifier les détails d'un investissement spécifique.
class InvestmentDetailsScreen extends StatefulWidget {
  final Investment investment; // L'investissement à afficher et modifier.
  final Function onInvestmentUpdated; // Callback pour les mises à jour de l'investissement.

  const InvestmentDetailsScreen({super.key, required this.investment, required this.onInvestmentUpdated});

  @override
  // ignore: library_private_types_in_public_api
  _InvestmentDetailsScreenState createState() => _InvestmentDetailsScreenState();
}

class _InvestmentDetailsScreenState extends State<InvestmentDetailsScreen> {
  final InvestmentService _investmentService = InvestmentService(); // Service pour gérer les données d'investissement.
  // Contrôleurs pour les champs de texte.
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _currentPriceController;
  late TextEditingController _interestRateController;

  @override
  void initState() {
    super.initState();
    // Initialisation des contrôleurs avec les valeurs actuelles de l'investissement.
    _nameController = TextEditingController(text: widget.investment.name);
    _quantityController = TextEditingController(text: widget.investment.quantity.toString());
    _purchasePriceController = TextEditingController(text: widget.investment.purchasePrice.toString());
    _currentPriceController = TextEditingController(text: widget.investment.currentPrice.toString());
    _interestRateController = TextEditingController(text: widget.investment.interestRate.toString());
  }

  /// Met à jour les informations de l'investissement.
  void _updateInvestment() {
    final updatedInvestment = Investment(
      id: widget.investment.id,
      name: _nameController.text,
      quantity: double.tryParse(_quantityController.text) ?? widget.investment.quantity,
      purchasePrice: double.tryParse(_purchasePriceController.text) ?? widget.investment.purchasePrice,
      currentPrice: double.tryParse(_currentPriceController.text) ?? widget.investment.currentPrice,
      interestRate: double.tryParse(_interestRateController.text) ?? widget.investment.interestRate,
    );

    // Appel au service pour mettre à jour l'investissement.
    _investmentService.updateInvestment(updatedInvestment).then((_) {
      widget.onInvestmentUpdated(); // Appeler le callback après la mise à jour.
      Navigator.of(context).pop(); // Retour à l'écran précédent.
    }).catchError((error) {
      // Gérer l'erreur ici.
    });
  }

  /// Supprime l'investissement actuel.
  void _deleteInvestment() {
    _investmentService.deleteInvestment(widget.investment.id).then((_) {
      widget.onInvestmentUpdated(); // Appeler le callback après la suppression.
      Navigator.of(context).pop(); // Retour à l'écran précédent.
    }).catchError((error) {
      // Gérer l'erreur ici.
    });
  }

  @override
  Widget build(BuildContext context) {
    // Construction de l'interface utilisateur de l'écran.
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        title: const Text('Détails de l\'Action/ETF', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Champ de texte pour le nom de l'investissement.
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: AppColors.primaryColor),
              decoration: const InputDecoration(
                labelText: 'Nom de l\'Investissement',
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
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            // Bouton pour mettre à jour l'investissement.
            ElevatedButton(
              onPressed: _updateInvestment,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.confirmationColor),
              child: const Text('Modifier', style: TextStyle(color: AppColors.secondaryColor)),
            ),
            const SizedBox(height: 10),
            // Bouton pour supprimer l'investissement.
            ElevatedButton(
              onPressed: _deleteInvestment,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorColor),
              child: const Text('Supprimer', style: TextStyle(color: AppColors.secondaryColor)),
            ),
          ],
        ),
      ),
    );
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
}
