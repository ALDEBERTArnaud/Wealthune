import 'package:flutter/material.dart';
import 'package:wealthune/models/cryptocurrency.dart';
import 'package:wealthune/services/crypto_service.dart';
import 'package:wealthune/utils/colors.dart';
import 'package:wealthune/services/market_service.dart';
import 'package:wealthune/models/market_item.dart';

class CreateCryptoScreen extends StatefulWidget {
  final Function onCryptoCreated;

  const CreateCryptoScreen({super.key, required this.onCryptoCreated});

  @override
  _CreateCryptoScreenState createState() => _CreateCryptoScreenState();
}

class _CreateCryptoScreenState extends State<CreateCryptoScreen> {
  final CryptoService _cryptoService = CryptoService();
  final MarketService _marketService = MarketService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _quantityController;
  late TextEditingController _searchController;

  List<MarketItem> _allCryptos = [];
  List<MarketItem> _filteredCryptos = [];
  MarketItem? _selectedCrypto;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _searchController = TextEditingController();
    _loadCryptos();
  }

  void _loadCryptos() async {
    final cryptos = await _marketService.getCryptocurrencies((progress) {});
    setState(() {
      _allCryptos = cryptos;
      _filteredCryptos = cryptos;
    });
  }

  void _filterCryptos(String query) {
    setState(() {
      _filteredCryptos = _allCryptos.where((crypto) {
        return crypto.name.toLowerCase().contains(query.toLowerCase()) ||
               crypto.symbol.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedCrypto != null) {
      final newCrypto = Cryptocurrency(
        id: DateTime.now().toString(),
        name: _selectedCrypto!.name,
        quantity: double.parse(_quantityController.text),
        currentPrice: _selectedCrypto!.price,
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
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _searchController,
              decoration: const InputDecoration(labelText: 'Rechercher une cryptomonnaie'),
              onChanged: _filterCryptos,
            ),
            const SizedBox(height: 16.0),
            if (_filteredCryptos.isNotEmpty)
              ..._filteredCryptos.map((crypto) => ListTile(
                title: Text(crypto.name),
                subtitle: Text(crypto.symbol),
                onTap: () {
                  setState(() {
                    _selectedCrypto = crypto;
                    _searchController.text = crypto.name;
                    _filteredCryptos = [];
                  });
                },
              )),
            const SizedBox(height: 16.0),
            if (_selectedCrypto != null)
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
    _quantityController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}