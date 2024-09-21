import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wealthune/services/cache_service.dart';

class MarketItem {
  final String symbol;
  final String name;
  final double price;
  final double change24h;
  final String type;

  MarketItem({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change24h,
    required this.type,
  });

  factory MarketItem.fromJson(Map<String, dynamic> json) {
    return MarketItem(
      symbol: json['symbol'],
      name: json['name'],
      price: json['price'],
      change24h: json['change24h'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'price': price,
      'change24h': change24h,
      'type': type,
    };
  }
}

class MarketService {
  final CacheService _cacheService = CacheService();
  final String _fmpApiKey = '9DOLwLwXmyDNbuH4u9R4NqSHhM0HiSOg';
  final String _fmpBaseUrl = 'https://financialmodelingprep.com/api/v3';
  final String _coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';

  Future<List<MarketItem>> getStocks(String currency, Function(double) updateProgress) async {
    print('Début de la récupération des actions');
    return _fetchQuotesWithCache('stocks_$currency', '$_fmpBaseUrl/stock-screener?marketCapMoreThan=1000000000&exchange=NASDAQ,NYSE&limit=100&apikey=$_fmpApiKey', currency, updateProgress, 'stock');
  }

  Future<List<MarketItem>> getETFs(String currency, Function(double) updateProgress) async {
    print('Début de la récupération des ETFs');
    return _fetchQuotesWithCache('etfs_$currency', '$_fmpBaseUrl/etf/list?apikey=$_fmpApiKey', currency, updateProgress, 'etf');
  }

  Future<List<MarketItem>> _fetchQuotesWithCache(String cacheKey, String url, String currency, Function(double) updateProgress, String type) async {
    final cachedData = await _cacheService.getFromCache(cacheKey);
    if (cachedData != null) {
      print('Utilisation des données en cache pour $cacheKey');
      updateProgress(1.0);
      return cachedData.map((item) => MarketItem.fromJson(item)).toList();
    }

    final items = await _fetchQuotes(url, currency, updateProgress, type);
    await _cacheService.saveToCache(cacheKey, items.map((item) => item.toJson()).toList());
    return items;
  }

  Future<List<MarketItem>> _fetchQuotes(String url, String currency, Function(double) updateProgress, String type) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<MarketItem> items = [];
      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        items.add(MarketItem(
          symbol: item['symbol'] ?? '',
          name: item['companyName'] ?? item['name'] ?? '',
          price: (item['price'] ?? 0).toDouble(),
          change24h: (item['changesPercentage'] ?? 0).toDouble(),
          type: type,
        ));
        updateProgress((i + 1) / data.length);
      }

      print('Fin de la récupération. Nombre d\'éléments: ${items.length}');
      return items;
    } else {
      print('Erreur de statut HTTP: ${response.statusCode}');
      throw Exception('Échec du chargement des données');
    }
  } catch (e) {
    print('Erreur lors de la récupération des données: $e');
    return [];
  }
}

  Future<List<MarketItem>> getCryptocurrencies(String currency, Function(double) updateProgress) async {
    print('Début de la récupération des cryptomonnaies');
    final cacheKey = 'crypto_$currency';
    final cachedData = await _cacheService.getFromCache(cacheKey);
    if (cachedData != null) {
      print('Utilisation des données en cache pour les cryptomonnaies');
      updateProgress(1.0);
      return cachedData.map((item) => MarketItem.fromJson(item)).toList();
    }

    try {
      final response = await http.get(Uri.parse('$_coinGeckoBaseUrl/coins/markets?vs_currency=${currency.toLowerCase()}&order=market_cap_desc&per_page=100&page=1&sparkline=false'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<MarketItem> items = data.map((item) => MarketItem(
          symbol: item['symbol']?.toUpperCase() ?? '',
          name: item['name'] ?? '',
          price: (item['current_price'] ?? 0).toDouble(),
          change24h: (item['price_change_percentage_24h'] ?? 0).toDouble(),
          type: 'crypto',
        )).toList();
        print('Fin de la récupération des cryptomonnaies. Nombre d\'éléments: ${items.length}');
        await _cacheService.saveToCache(cacheKey, items.map((item) => item.toJson()).toList());
        updateProgress(1.0);
        return items;
      } else {
        print('Erreur de statut HTTP pour les cryptomonnaies: ${response.statusCode}');
        throw Exception('Échec du chargement des données des cryptomonnaies');
      }
    } catch (e) {
      print('Erreur lors de la récupération des données des cryptomonnaies: $e');
      return [];
    }
  }
}