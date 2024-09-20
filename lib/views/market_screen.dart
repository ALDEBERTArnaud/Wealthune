import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wealthune/utils/colors.dart';
import 'package:wealthune/services/market_service.dart';
import 'package:wealthune/widgets/market_item_card.dart';
import 'package:wealthune/providers/currency_provider.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MarketService _marketService = MarketService();
  List<MarketItem> _stocks = [];
  List<MarketItem> _etfs = [];
  List<MarketItem> _cryptos = [];
  List<MarketItem> _filteredStocks = [];
  List<MarketItem> _filteredEtfs = [];
  List<MarketItem> _filteredCryptos = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currency = Provider.of<CurrencyProvider>(context, listen: false).currency;
      final stocks = await _marketService.getStocks(currency);
      final etfs = await _marketService.getETFs(currency);
      final cryptos = await _marketService.getCryptocurrencies(currency);

      setState(() {
        _stocks = stocks;
        _etfs = etfs;
        _cryptos = cryptos;
        _filteredStocks = _stocks;
        _filteredEtfs = _etfs;
        _filteredCryptos = _cryptos;
        _isLoading = false;
      });

      print('Nombre d\'actions: ${_stocks.length}');
      print('Nombre d\'ETFs: ${_etfs.length}');
      print('Nombre de cryptomonnaies: ${_cryptos.length}');
    } catch (e) {
      print('Erreur lors de la récupération des données: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des données: $e')),
      );
    }
  }

  void _filterItems(String query) {
    setState(() {
      _searchQuery = query;
      _filteredStocks = _stocks.where((item) =>
          item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.symbol.toLowerCase().contains(query.toLowerCase())).toList();
      _filteredEtfs = _etfs.where((item) =>
          item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.symbol.toLowerCase().contains(query.toLowerCase())).toList();
      _filteredCryptos = _cryptos.where((item) =>
          item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.symbol.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/logo_wealthune.png', height: 50),
        title: const Text('Marché', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String currency) {
              Provider.of<CurrencyProvider>(context, listen: false).setCurrency(currency);
              _fetchData();
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'EUR',
                child: Text('Euro (€)'),
              ),
              const PopupMenuItem<String>(
                value: 'USD',
                child: Text('Dollar (\$)'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Actions'),
            Tab(text: 'ETFs'),
            Tab(text: 'Cryptomonnaies'),
          ],
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _filterItems,
                    decoration: InputDecoration(
                      labelText: 'Rechercher',
                      labelStyle: TextStyle(color: AppColors.primaryColor),
                      prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
                      fillColor: AppColors.secondaryColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                      ),
                    ),
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildMarketList(_filteredStocks, 'stock'),
                      _buildMarketList(_filteredEtfs, 'etf'),
                      _buildMarketList(_filteredCryptos, 'crypto'),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMarketList(List<MarketItem> items, String type) {
    return items.isEmpty
        ? const Center(child: Text('Aucune donnée disponible'))
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return MarketItemCard(item: items[index], type: type);
            },
          );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
