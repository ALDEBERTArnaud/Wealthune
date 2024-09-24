import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wealthune/services/cache_service.dart';
import 'package:wealthune/models/market_item.dart';

class MarketService {
  final CacheService _cacheService = CacheService();
  final String _fmpApiKey = '9DOLwLwXmyDNbuH4u9R4NqSHhM0HiSOg';
  final String _fmpBaseUrl = 'https://financialmodelingprep.com/api/v3';
  final String _coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';

  Future<List<MarketItem>> getStocks(Function(double) updateProgress) async {
    print('Début de la récupération des actions');
    return _fetchQuotesWithCache('stocks_eur', '$_fmpBaseUrl/stock-screener?marketCapMoreThan=1000000000&exchange=NASDAQ,NYSE&apikey=$_fmpApiKey', updateProgress, 'stock');
  }

  Future<List<MarketItem>> getETFs(Function(double) updateProgress) async {
    print('Début de la récupération des ETFs');
    return _fetchQuotesWithCache('etfs_eur', '$_fmpBaseUrl/etf/list?apikey=$_fmpApiKey', updateProgress, 'etf');
  }

  Future<List<MarketItem>> _fetchQuotesWithCache(String cacheKey, String url, Function(double) updateProgress, String type) async {
    final cachedData = await _cacheService.getFromCache(cacheKey);
    if (cachedData != null) {
      print('Utilisation des données en cache pour $cacheKey');
      updateProgress(1.0);
      return cachedData.map((item) => MarketItem.fromJson(item)).toList();
    }

    final items = await _fetchQuotes(url, updateProgress, type);
    await _cacheService.saveToCache(cacheKey, items.map((item) => item.toJson()).toList());
    return items;
  }

  Future<List<MarketItem>> _fetchQuotes(String url, Function(double) updateProgress, String type) async {
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

  Future<List<MarketItem>> getCryptocurrencies(Function(double) updateProgress) async {
    print('Début de la récupération des cryptomonnaies');
    final cacheKey = 'crypto_eur';
    final cachedData = await _cacheService.getFromCache(cacheKey);
    if (cachedData != null) {
      print('Utilisation des données en cache pour les cryptomonnaies');
      updateProgress(1.0);
      return cachedData.map((item) => MarketItem.fromJson(item)).toList();
    }

    try {
      List<MarketItem> allItems = [];
      int page = 1;
      bool hasMore = true;

      while (hasMore) {
        final response = await http.get(Uri.parse('$_coinGeckoBaseUrl/coins/markets?vs_currency=eur&order=market_cap_desc&per_page=250&page=$page&sparkline=false'));
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          if (data.isEmpty) {
            hasMore = false;
          } else {
            List<MarketItem> items = data.map((item) => MarketItem(
              symbol: item['symbol']?.toUpperCase() ?? '',
              name: item['name'] ?? '',
              price: (item['current_price'] ?? 0).toDouble(),
              change24h: (item['price_change_percentage_24h'] ?? 0).toDouble(),
              type: 'crypto',
            )).toList();
            allItems.addAll(items);
            page++;
            updateProgress(allItems.length / (allItems.length + data.length));
          }
        } else {
          print('Erreur de statut HTTP pour les cryptomonnaies: ${response.statusCode}');
          throw Exception('Échec du chargement des données des cryptomonnaies');
        }
      }

      print('Fin de la récupération des cryptomonnaies. Nombre d\'éléments: ${allItems.length}');
      await _cacheService.saveToCache(cacheKey, allItems.map((item) => item.toJson()).toList());
      updateProgress(1.0);
      return allItems;
    } catch (e) {
      print('Erreur lors de la récupération des données des cryptomonnaies: $e');
      return [];
    }
  }
}