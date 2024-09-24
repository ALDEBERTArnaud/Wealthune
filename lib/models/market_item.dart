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