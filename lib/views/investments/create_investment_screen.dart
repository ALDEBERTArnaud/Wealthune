import 'package:flutter/material.dart';
import 'package:wealthune/models/investment.dart';
import 'package:wealthune/services/investment_service.dart';
import 'package:wealthune/utils/colors.dart';

/// Écran pour créer un nouvel investissement.
class CreateInvestmentScreen extends StatefulWidget {
  final Function onInvestmentCreated; // Callback pour après la création de l'investissement.

  const CreateInvestmentScreen({super.key, required this.onInvestmentCreated});

  @override
  _CreateInvestmentScreenState createState() => _CreateInvestmentScreenState();
}

class _CreateInvestmentScreenState extends State<CreateInvestmentScreen> {
  final InvestmentService _investmentService = InvestmentService(); // Service pour gérer les données d'investissement.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _currentPriceController;

  @override
  void initState() {
    super.initState();
    // Initialisation des contrôleurs.
    _nameController = TextEditingController();
    _quantityController = TextEditingController();
    _currentPriceController = TextEditingController();
  }

  /// Crée un nouvel investissement.
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newInvestment = Investment(
        id: DateTime.now().toString(),
        name: _nameController.text,
        quantity: double.parse(_quantityController.text),
        currentPrice: double.parse(_currentPriceController.text),
      );

      _investmentService.saveInvestment(newInvestment).then((_) {
        widget.onInvestmentCreated();
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création de l\'investissement: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un investissement'),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
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
            const SizedBox(height: 30),
            // Bouton pour créer l'investissement.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.confirmationColor,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Créer l\'investissement',
                  style: TextStyle(color: AppColors.secondaryColor, fontSize: 16.0),
                ),
              ),
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
    _currentPriceController.dispose();
    super.dispose();
  }
}