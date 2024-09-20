import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketItem {
  final String symbol;
  final String name;
  final double price;
  final double change24h;

  MarketItem({required this.symbol, required this.name, required this.price, required this.change24h});
}

class MarketService {
  final String _fmpApiKey = '9DOLwLwXmyDNbuH4u9R4NqSHhM0HiSOg';
  final String _fmpBaseUrl = 'https://financialmodelingprep.com/api/v3';
  final String _coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';

  Future<List<MarketItem>> getStocks(String currency) async {
    print('Début de la récupération des actions');
    return _fetchQuotes('$_fmpBaseUrl/stock-screener?marketCapMoreThan=1000000000&exchange=NASDAQ,NYSE&limit=100&apikey=$_fmpApiKey', currency);
  }

  Future<List<MarketItem>> getETFs(String currency) async {
    print('Début de la récupération des ETFs');
    return _fetchQuotes('$_fmpBaseUrl/etf/list?apikey=$_fmpApiKey', currency);
  }

  Future<List<MarketItem>> _fetchQuotes(String url, String currency) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<String> symbols = data.map((item) => item['symbol'] as String).take(5).toList(); // Limite à 5 symboles pour éviter le dépassement de limite
        
        List<MarketItem> items = [];
        for (var symbol in symbols) {
          final priceResponse = await http.get(Uri.parse('$_fmpBaseUrl/quote-short/$symbol?apikey=$_fmpApiKey'));
          if (priceResponse.statusCode == 200) {
            List<dynamic> priceData = json.decode(priceResponse.body);
            if (priceData.isNotEmpty) {
              var priceInfo = priceData[0];
              final price = (priceInfo['price'] ?? 0).toDouble();
              final change = (priceInfo['change'] ?? 0).toDouble();
              final changePercent = price != 0 ? (change / price) * 100 : 0.0;
              items.add(MarketItem(
                symbol: symbol,
                name: data.firstWhere((item) => item['symbol'] == symbol)['name'] ?? '',
                price: price,
                change24h: changePercent,
              ));
            }
          } else if (priceResponse.statusCode == 429) {
            print('Limite de requêtes atteinte pour le symbole: $symbol');
            continue; // Passe au symbole suivant
          } else {
            print('Erreur lors de la récupération des données pour le symbole $symbol: ${priceResponse.statusCode}');
          }
        }
        
        print('Fin de la récupération. Nombre d\'éléments: ${items.length}');
        return items;
      } else if (response.statusCode == 429) {
        print('Limite de requêtes atteinte');
        return [];
      } else {
        print('Erreur de statut HTTP: ${response.statusCode}');
        throw Exception('Échec du chargement des données');
      }
    } catch (e) {
      print('Erreur lors de la récupération des données: $e');
      return [];
    }
  }

  Future<List<MarketItem>> getCryptocurrencies(String currency) async {
    print('Début de la récupération des cryptomonnaies');
    try {
      final response = await http.get(Uri.parse('$_coinGeckoBaseUrl/coins/markets?vs_currency=${currency.toLowerCase()}&order=market_cap_desc&per_page=100&page=1&sparkline=false'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<MarketItem> items = data.map((item) => MarketItem(
          symbol: item['symbol']?.toUpperCase() ?? '',
          name: item['name'] ?? '',
          price: (item['current_price'] ?? 0).toDouble(),
          change24h: (item['price_change_percentage_24h'] ?? 0).toDouble(),
        )).toList();
        print('Fin de la récupération des cryptomonnaies. Nombre d\'éléments: ${items.length}');
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