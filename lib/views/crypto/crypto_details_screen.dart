import 'package:flutter/material.dart';
import 'package:wealthune/models/cryptocurrency.dart';
import 'package:wealthune/services/crypto_service.dart';
import 'package:wealthune/utils/colors.dart';

/// Écran pour afficher et modifier les détails d'une cryptomonnaie spécifique.
class CryptoDetailsScreen extends StatefulWidget {
  final Cryptocurrency cryptocurrency; // La cryptomonnaie à afficher et modifier.
  final Function onCryptoUpdated; // Callback pour les mises à jour de la cryptomonnaie.

  const CryptoDetailsScreen({super.key, required this.cryptocurrency, required this.onCryptoUpdated});

  @override
  // ignore: library_private_types_in_public_api
  _CryptoDetailsScreenState createState() => _CryptoDetailsScreenState();
}

class _CryptoDetailsScreenState extends State<CryptoDetailsScreen> {
  final CryptoService _cryptocurrencyService = CryptoService(); // Service pour gérer les données de cryptomonnaie.
  late TextEditingController _nameController; // Contrôleur pour le nom de la cryptomonnaie.
  late TextEditingController _quantityController; // Contrôleur pour la quantité.
  late TextEditingController _currentPriceController; // Contrôleur pour le prix actuel.
  late TextEditingController _interestRateController; // Contrôleur pour le taux d'intérêt.

  @override
  void initState() {
    super.initState();
    // Initialisation des contrôleurs avec les valeurs actuelles de la cryptomonnaie.
    _nameController = TextEditingController(text: widget.cryptocurrency.name);
    _quantityController = TextEditingController(text: widget.cryptocurrency.quantity.toString());
    _currentPriceController = TextEditingController(text: widget.cryptocurrency.currentPrice.toString());
    _interestRateController = TextEditingController(text: widget.cryptocurrency.interestRate.toString());
  }

  /// Met à jour les informations de la cryptomonnaie.
  void _updateCryptocurrency() {
    final updatedCryptocurrency = Cryptocurrency(
      id: widget.cryptocurrency.id,
      name: _nameController.text,
      quantity: double.tryParse(_quantityController.text) ?? widget.cryptocurrency.quantity,
      currentPrice: double.tryParse(_currentPriceController.text) ?? widget.cryptocurrency.currentPrice,
      interestRate: double.tryParse(_interestRateController.text) ?? widget.cryptocurrency.interestRate,
    );

    // Appel au service pour mettre à jour la cryptomonnaie.
    _cryptocurrencyService.updateCryptocurrency(updatedCryptocurrency).then((_) {
      widget.onCryptoUpdated(); // Appeler le callback après la mise à jour.
      Navigator.of(context).pop(); // Retour à l'écran précédent.
    }).catchError((error) {
      // Gérer l'erreur ici.
    });
  }

  /// Supprime la cryptomonnaie actuelle.
  void _deleteCryptocurrency() {
    _cryptocurrencyService.deleteCryptocurrency(widget.cryptocurrency.id).then((_) {
      widget.onCryptoUpdated(); // Appeler le callback après la suppression.
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
        title: const Text('Détails de la Crypto', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Champ de texte pour le nom de la cryptomonnaie.
            TextFormField(
              controller: _nameController,
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
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            // Bouton pour mettre à jour la cryptomonnaie.
            ElevatedButton(
              onPressed: _updateCryptocurrency,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.confirmationColor),
              child: const Text('Modifier', style: TextStyle(color: AppColors.secondaryColor)),
            ),
            const SizedBox(height: 10),
            // Bouton pour supprimer la cryptomonnaie.
            ElevatedButton(
              onPressed: _deleteCryptocurrency,
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
    _currentPriceController.dispose();
    _interestRateController.dispose();
    super.dispose();
  }
}
