import 'package:flutter/material.dart';
import 'package:wealthune/models/cryptocurrency.dart';
import 'package:wealthune/services/crypto_service.dart';
import 'package:wealthune/utils/colors.dart';

/// Écran pour créer une nouvelle cryptomonnaie.
class CreateCryptoScreen extends StatefulWidget {
  final Function onCryptoCreated; // Callback pour après la création de la cryptomonnaie.

  const CreateCryptoScreen({super.key, required this.onCryptoCreated});

  @override
  _CreateCryptoScreenState createState() => _CreateCryptoScreenState();
}

class _CreateCryptoScreenState extends State<CreateCryptoScreen> {
  final CryptoService _cryptoService = CryptoService(); // Service pour gérer les données de cryptomonnaie.
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

  /// Crée une nouvelle cryptomonnaie.
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newCrypto = Cryptocurrency(
        id: DateTime.now().toString(),
        name: _nameController.text,
        quantity: double.parse(_quantityController.text),
        currentPrice: double.parse(_currentPriceController.text),
      );

      _cryptoService.saveCryptocurrency(newCrypto).then((_) {
        widget.onCryptoCreated();
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création de la cryptomonnaie: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une cryptomonnaie'),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom de la cryptomonnaie'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom de cryptomonnaie';
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
            // Bouton pour créer la cryptomonnaie.
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
                  'Créer la cryptomonnaie',
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