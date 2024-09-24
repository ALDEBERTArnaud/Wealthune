import 'package:flutter/material.dart';
import 'package:wealthune/models/market_item.dart';
import 'package:wealthune/services/market_service.dart';
import 'package:wealthune/utils/colors.dart';
import 'package:wealthune/widgets/market_item_card.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  double _loadingProgress = 0.0;
  List<MarketItem> _stocks = [];
  List<MarketItem> _etfs = [];
  List<MarketItem> _cryptos = [];
  List<MarketItem> _filteredStocks = [];
  List<MarketItem> _filteredEtfs = [];
  List<MarketItem> _filteredCryptos = [];
  String _searchQuery = '';
  final MarketService _marketService = MarketService();

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
      final stocks = await _marketService.getStocks((progress) {
        setState(() {
          _loadingProgress = progress / 3;
        });
      });
      
      final etfs = await _marketService.getETFs((progress) {
        setState(() {
          _loadingProgress = 1/3 + progress / 3;
        });
      });
      
      final cryptos = await _marketService.getCryptocurrencies((progress) {
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
        title: const Text('Marché'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Actions'),
            Tab(text: 'ETFs'),
            Tab(text: 'Cryptomonnaies'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(value: _loadingProgress))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _filterItems,
                    decoration: InputDecoration(
                      labelText: 'Rechercher',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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
        final item = items[index];
        return MarketItemCard(item: item);
      },
    );
  }
}