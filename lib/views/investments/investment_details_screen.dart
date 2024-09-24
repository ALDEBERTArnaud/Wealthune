import 'package:flutter/material.dart';
import 'package:wealthune/models/investment.dart';
import 'package:wealthune/services/investment_service.dart';
import 'package:wealthune/utils/colors.dart';

class InvestmentDetailsScreen extends StatefulWidget {
  final Investment investment;
  final Function onInvestmentUpdated;

  const InvestmentDetailsScreen({
    Key? key,
    required this.investment,
    required this.onInvestmentUpdated,
  }) : super(key: key);

  @override
  _InvestmentDetailsScreenState createState() => _InvestmentDetailsScreenState();
}

class _InvestmentDetailsScreenState extends State<InvestmentDetailsScreen> {
  final InvestmentService _investmentService = InvestmentService();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.investment.name);
    _quantityController = TextEditingController(text: widget.investment.quantity.toString());
  }

  void _updateInvestment() {
    if (_formKey.currentState!.validate()) {
      final updatedInvestment = Investment(
        id: widget.investment.id,
        name: _nameController.text,
        quantity: double.tryParse(_quantityController.text) ?? widget.investment.quantity,
        currentPrice: widget.investment.currentPrice,
      );

      _investmentService.updateInvestment(updatedInvestment).then((_) {
        widget.onInvestmentUpdated();
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour: $error')),
        );
      });
    }
  }

  void _deleteInvestment() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cet investissement?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              _investmentService.deleteInvestment(widget.investment.id).then((_) {
                widget.onInvestmentUpdated();
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
        title: const Text('Détails de l\'investissement'),
        backgroundColor: AppColors.secondaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteInvestment,
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
                onPressed: _updateInvestment,
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