import 'package:flutter/material.dart';
import 'package:wealthune/models/investment.dart';
import 'package:wealthune/services/investment_service.dart';
import 'package:wealthune/utils/colors.dart';

/// Écran pour afficher et modifier les détails d'un investissement spécifique.
class InvestmentDetailsScreen extends StatefulWidget {
  final Investment investment; // L'investissement à afficher et modifier.
  final Function onInvestmentUpdated; // Callback pour les mises à jour de l'investissement.

  const InvestmentDetailsScreen({
    Key? key,
    required this.investment,
    required this.onInvestmentUpdated,
  }) : super(key: key);

  @override
  _InvestmentDetailsScreenState createState() => _InvestmentDetailsScreenState();
}

class _InvestmentDetailsScreenState extends State<InvestmentDetailsScreen> {
  final InvestmentService _investmentService = InvestmentService(); // Service pour gérer les données d'investissement.
  // Contrôleurs pour les champs de texte.
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _currentPriceController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialisation des contrôleurs avec les valeurs actuelles de l'investissement.
    _nameController = TextEditingController(text: widget.investment.name);
    _quantityController = TextEditingController(text: widget.investment.quantity.toString());
    _currentPriceController = TextEditingController(text: widget.investment.currentPrice.toString());
  }

  /// Met à jour les informations de l'investissement.
  void _updateInvestment() {
    if (_formKey.currentState!.validate()) {
      final updatedInvestment = Investment(
        id: widget.investment.id,
        name: _nameController.text,
        quantity: double.tryParse(_quantityController.text) ?? widget.investment.quantity,
        currentPrice: double.tryParse(_currentPriceController.text) ?? widget.investment.currentPrice,
      );

      // Appel au service pour mettre à jour l'investissement.
      _investmentService.updateInvestment(updatedInvestment).then((_) {
        widget.onInvestmentUpdated(); // Appeler le callback après la mise à jour.
        Navigator.of(context).pop(); // Retour à l'écran précédent.
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour: $error')),
        );
      });
    }
  }

  /// Supprime l'investissement actuel.
  void _deleteInvestment() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cet investissement?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Fermer le dialogue
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              _investmentService.deleteInvestment(widget.investment.id).then((_) {
                widget.onInvestmentUpdated(); // Appeler le callback après la suppression.
                Navigator.of(ctx).pop(); // Fermer le dialogue
                Navigator.of(context).pop(); // Retour à l'écran précédent
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur lors de la suppression: $error')),
                );
              });
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalValue = widget.investment.quantity * widget.investment.currentPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Détails de l'Investissement",
          style: TextStyle(color: AppColors.primaryColor),
        ),
        backgroundColor: AppColors.secondaryColor,
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Champ de texte pour le nom de l'investissement.
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom de l\'investissement'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom d\'investissement';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Champ de texte pour la quantité.
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantité'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une quantité';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Champ de texte pour le prix actuel.
              TextFormField(
                controller: _currentPriceController,
                decoration: const InputDecoration(labelText: 'Prix actuel'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix actuel';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Affichage de la valeur totale.
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Valeur Totale: ${totalValue.toStringAsFixed(2)} €',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              // Bouton pour mettre à jour l'investissement.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateInvestment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.confirmationColor,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Modifier',
                    style: TextStyle(color: AppColors.secondaryColor, fontSize: 16.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Bouton pour supprimer l'investissement.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _deleteInvestment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorColor,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Supprimer',
                    style: TextStyle(color: AppColors.secondaryColor, fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Nettoyage des contrôleurs lors de la destruction de l'état.
    _nameController.dispose();
    _quantityController.dispose();
    _currentPriceController.dispose();
    super.dispose();
  }
}