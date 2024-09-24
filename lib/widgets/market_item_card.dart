import 'package:flutter/material.dart';
import 'package:wealthune/models/market_item.dart';

class MarketItemCard extends StatelessWidget {
  final MarketItem item;

  const MarketItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData getIconForType() {
      switch (item.type) {
        case 'stock':
          return Icons.show_chart;
        case 'etf':
          return Icons.pie_chart;
        case 'crypto':
          return Icons.currency_bitcoin;
        default:
          return Icons.help_outline;
      }
    }

    return Card(
      child: ListTile(
        leading: Icon(getIconForType()),
        title: Text(item.name),
        subtitle: Text(item.symbol),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${item.price.toStringAsFixed(2)} EUR',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${item.change24h.toStringAsFixed(2)}%',
              style: TextStyle(
                color: item.change24h >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}