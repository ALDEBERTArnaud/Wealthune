import 'package:flutter/material.dart';
import 'package:wealthune/models/cryptocurrency.dart';
import 'package:wealthune/services/crypto_service.dart';
import 'package:wealthune/utils/colors.dart';

/// Écran pour créer une nouvelle cryptomonnaie.
class CreateCryptoScreen extends StatefulWidget {
  const CreateCryptoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateCryptoScreenState createState() => _CreateCryptoScreenState();
}

class _CreateCryptoScreenState extends State<CreateCryptoScreen> {
  final _formKey = GlobalKey<FormState>(); // Clé globale pour le formulaire.
  final _nameController = TextEditingController(); // Contrôleur pour le nom de la cryptomonnaie.
  final _quantityController = TextEditingController(); // Contrôleur pour la quantité.
  final _currentPriceController = TextEditingController(); // Contrôleur pour le prix actuel.
  final _interestRateController = TextEditingController(); // Contrôleur pour le taux d'intérêt.
  final CryptoService _cryptoService = CryptoService(); // Service pour gérer les données de cryptomonnaie.

  /// Soumet le formulaire et crée une nouvelle cryptomonnaie.
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Création d'une nouvelle instance de Cryptocurrency.
      final newCrypto = Cryptocurrency(
        id: DateTime.now().toString(), // Utilisation du temps actuel pour générer un ID unique.
        name: _nameController.text,
        quantity: double.parse(_quantityController.text),
        currentPrice: double.parse(_currentPriceController.text),
        interestRate: double.parse(_interestRateController.text),
      );

      // Appel au service pour sauvegarder la nouvelle cryptomonnaie.
      _cryptoService.saveCryptocurrency(newCrypto).then((_) {
        Navigator.of(context).pop(); // Retour à l'écran précédent après la création.
      }).catchError((error) {
        // Gestion d'erreur ici.
      });
    }
  }

  @override
  void dispose() {
    // Nettoyage des contrôleurs lors de la destruction de l'état.
    _nameController.dispose();
    _quantityController.dispose();
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
        title: const Text('Ajouter une Crypto', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Champ de texte pour le nom de la cryptomonnaie.
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom de cryptomonnaie';
                  }
                  return null;
                },
                style: const TextStyle(color: AppColors.primaryColor),
                decoration: const InputDecoration(
                  labelText: 'Nom de la Cryptomonnaie',
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
              // Champ de texte pour la quantité.
              TextFormField(
                controller: _quantityController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une quantité valide';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
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
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              // Champ de texte pour le prix actuel.
              TextFormField(
                controller: _currentPriceController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix actuel valide';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
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
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              // Champ de texte pour le taux d'intérêt.
              TextFormField(
                controller: _interestRateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un taux d\'intérêt valide';
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
              // Bouton pour soumettre le formulaire et ajouter la cryptomonnaie.
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
