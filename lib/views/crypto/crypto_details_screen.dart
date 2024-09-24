import 'package:flutter/material.dart';
import 'package:wealthune/models/cryptocurrency.dart';
import 'package:wealthune/services/crypto_service.dart';
import 'package:wealthune/utils/colors.dart';

class CryptoDetailsScreen extends StatefulWidget {
  final Cryptocurrency cryptocurrency;
  final Function onCryptoUpdated;

  const CryptoDetailsScreen({
    Key? key,
    required this.cryptocurrency,
    required this.onCryptoUpdated,
  }) : super(key: key);

  @override
  _CryptoDetailsScreenState createState() => _CryptoDetailsScreenState();
}

class _CryptoDetailsScreenState extends State<CryptoDetailsScreen> {
  final CryptoService _cryptoService = CryptoService();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.cryptocurrency.name);
    _quantityController = TextEditingController(text: widget.cryptocurrency.quantity.toString());
  }

  void _updateCryptocurrency() {
    if (_formKey.currentState!.validate()) {
      final updatedCryptocurrency = Cryptocurrency(
        id: widget.cryptocurrency.id,
        name: _nameController.text,
        quantity: double.tryParse(_quantityController.text) ?? widget.cryptocurrency.quantity,
        currentPrice: widget.cryptocurrency.currentPrice,
      );

      _cryptoService.updateCryptocurrency(updatedCryptocurrency).then((_) {
        widget.onCryptoUpdated();
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour: $error')),
        );
      });
    }
  }

  void _deleteCryptocurrency() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette cryptomonnaie?'),
        actions: [
          TextButton(
            onPressed: () {
                            Navigator.of(ctx).pop();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              _cryptoService.deleteCryptocurrency(widget.cryptocurrency.id).then((_) {
                widget.onCryptoUpdated();
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la cryptomonnaie'),
        backgroundColor: AppColors.secondaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteCryptocurrency,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom'),
              readOnly: true,
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
            const SizedBox(height: 30),
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
                  'Mettre à jour',
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
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}