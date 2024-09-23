import 'package:flutter/material.dart';
import 'package:wealthune/models/cryptocurrency.dart';
import 'package:wealthune/services/crypto_service.dart';
import 'package:wealthune/utils/colors.dart';

/// Écran pour afficher et modifier les détails d'une cryptomonnaie spécifique.
class CryptoDetailsScreen extends StatefulWidget {
  final Cryptocurrency cryptocurrency; // La cryptomonnaie à afficher et modifier.
  final Function onCryptoUpdated; // Callback pour les mises à jour de la cryptomonnaie.

  const CryptoDetailsScreen({
    Key? key,
    required this.cryptocurrency,
    required this.onCryptoUpdated,
  }) : super(key: key);

  @override
  _CryptoDetailsScreenState createState() => _CryptoDetailsScreenState();
}

class _CryptoDetailsScreenState extends State<CryptoDetailsScreen> {
  final CryptoService _cryptoService = CryptoService(); // Service pour gérer les données de cryptomonnaie.
  late TextEditingController _nameController; // Contrôleur pour le nom de la cryptomonnaie.
  late TextEditingController _quantityController; // Contrôleur pour la quantité.
  late TextEditingController _currentPriceController; // Contrôleur pour le prix actuel.

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialisation des contrôleurs avec les valeurs actuelles de la cryptomonnaie.
    _nameController = TextEditingController(text: widget.cryptocurrency.name);
    _quantityController = TextEditingController(text: widget.cryptocurrency.quantity.toString());
    _currentPriceController = TextEditingController(text: widget.cryptocurrency.currentPrice.toString());
  }

  /// Met à jour les informations de la cryptomonnaie.
  void _updateCryptocurrency() {
    if (_formKey.currentState!.validate()) {
      final updatedCryptocurrency = Cryptocurrency(
        id: widget.cryptocurrency.id,
        name: _nameController.text,
        quantity: double.tryParse(_quantityController.text) ?? widget.cryptocurrency.quantity,
        currentPrice: double.tryParse(_currentPriceController.text) ?? widget.cryptocurrency.currentPrice,
      );

      // Appel au service pour mettre à jour la cryptomonnaie.
      _cryptoService.updateCryptocurrency(updatedCryptocurrency).then((_) {
        widget.onCryptoUpdated(); // Appeler le callback après la mise à jour.
        Navigator.of(context).pop(); // Retour à l'écran précédent.
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour: $error')),
        );
      });
    }
  }

  /// Supprime la cryptomonnaie actuelle.
  void _deleteCryptocurrency() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette cryptomonnaie?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Fermer le dialogue
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              _cryptoService.deleteCryptocurrency(widget.cryptocurrency.id).then((_) {
                widget.onCryptoUpdated(); // Appeler le callback après la suppression.
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
    double totalValue = widget.cryptocurrency.quantity * widget.cryptocurrency.currentPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Détails de la Cryptomonnaie",
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
              // Champ de texte pour le nom de la cryptomonnaie.
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
              // Bouton pour mettre à jour la cryptomonnaie.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateCryptocurrency,
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
              // Bouton pour supprimer la cryptomonnaie.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _deleteCryptocurrency,
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