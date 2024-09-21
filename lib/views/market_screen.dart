import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wealthune/services/market_service.dart';
import 'package:wealthune/providers/currency_provider.dart';
import 'package:wealthune/utils/colors.dart';
import 'package:wealthune/widgets/market_item_card.dart';


class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> with SingleTickerProviderStateMixin {
  final MarketService _marketService = MarketService();
  List<MarketItem> _stocks = [];
  List<MarketItem> _etfs = [];
  List<MarketItem> _cryptos = [];
  List<MarketItem> _filteredStocks = [];
  List<MarketItem> _filteredEtfs = [];
  List<MarketItem> _filteredCryptos = [];
  bool _isLoading = true;
  String _searchQuery = '';
  double _loadingProgress = 0.0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _loadingProgress = 0.0;
    });

    try {
      final currency = Provider.of<CurrencyProvider>(context, listen: false).currency;
      
      final stocks = await _marketService.getStocks(currency, (progress) {
        setState(() {
          _loadingProgress = progress / 3;
        });
      });
      
      final etfs = await _marketService.getETFs(currency, (progress) {
        setState(() {
          _loadingProgress = 1/3 + progress / 3;
        });
      });
      
      final cryptos = await _marketService.getCryptocurrencies(currency, (progress) {
        setState(() {
          _loadingProgress = 2/3 + progress / 3;
        });
      });

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
        title: const Text('Marché', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Actions'),
            Tab(text: 'ETFs'),
            Tab(text: 'Crypto'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(value: _loadingProgress),
                  const SizedBox(height: 16),
                  Text('${(_loadingProgress * 100).toInt()}%'),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _filterItems,
                    decoration: const InputDecoration(
                      labelText: 'Rechercher',
                      prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildListView(_filteredStocks),
                      _buildListView(_filteredEtfs),
                      _buildListView(_filteredCryptos),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildListView(List<MarketItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return MarketItemCard(item: items[index]);
      },
    );
  }
}