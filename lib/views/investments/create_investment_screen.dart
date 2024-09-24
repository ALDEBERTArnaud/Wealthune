import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wealthune/models/investment.dart';
import 'package:wealthune/services/investment_service.dart';
import 'package:wealthune/utils/colors.dart';
import 'package:wealthune/services/market_service.dart';
import 'package:wealthune/models/market_item.dart';

class CreateInvestmentScreen extends StatefulWidget {
  final Function onInvestmentCreated;

  const CreateInvestmentScreen({super.key, required this.onInvestmentCreated});

  @override
  _CreateInvestmentScreenState createState() => _CreateInvestmentScreenState();
}

class _CreateInvestmentScreenState extends State<CreateInvestmentScreen> {
  final InvestmentService _investmentService = InvestmentService();
  final MarketService _marketService = MarketService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _quantityController;
  late TextEditingController _searchController;

  List<MarketItem> _allInvestments = [];
  List<MarketItem> _filteredInvestments = [];
  MarketItem? _selectedInvestment;
  String _investmentType = 'action';

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _searchController = TextEditingController();
    _loadInvestments();
  }

  void _loadInvestments() async {
    List<MarketItem> investments;
    if (_investmentType == 'action') {
      investments = await _marketService.getStocks((progress) {});
    } else {
      investments = await _marketService.getETFs((progress) {});
    }
    setState(() {
      _allInvestments = investments;
      _filteredInvestments = investments;
    });
  }

  void _filterInvestments(String query) {
    setState(() {
      _filteredInvestments = _allInvestments.where((investment) {
        return investment.name.toLowerCase().contains(query.toLowerCase()) ||
               investment.symbol.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedInvestment != null) {
      final newInvestment = Investment(
        id: DateTime.now().toString(),
        name: _selectedInvestment!.name,
        quantity: double.parse(_quantityController.text),
        currentPrice: _selectedInvestment!.price,
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
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            DropdownButtonFormField<String>(
              value: _investmentType,
              items: [
                DropdownMenuItem(value: 'action', child: Text('Action')),
                DropdownMenuItem(value: 'etf', child: Text('ETF')),
              ],
              onChanged: (value) {
                setState(() {
                  _investmentType = value!;
                  _loadInvestments();
                });
              },
              decoration: const InputDecoration(labelText: 'Type d\'investissement'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _searchController,
              decoration: const InputDecoration(labelText: 'Rechercher un investissement'),
              onChanged: _filterInvestments,
            ),
            const SizedBox(height: 16.0),
            if (_filteredInvestments.isNotEmpty)
              ..._filteredInvestments.map((investment) => ListTile(
                title: Text(investment.name),
                subtitle: Text(investment.symbol),
                onTap: () {
                  setState(() {
                    _selectedInvestment = investment;
                    _searchController.text = investment.name;
                    _filteredInvestments = [];
                  });
                },
              )),
            const SizedBox(height: 16.0),
            if (_selectedInvestment != null)
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
    _quantityController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}