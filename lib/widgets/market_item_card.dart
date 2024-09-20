import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wealthune/services/market_service.dart';
import 'package:wealthune/utils/colors.dart';
import 'package:wealthune/providers/currency_provider.dart';

class MarketItemCard extends StatelessWidget {
  final MarketItem item;
  final String type;

  const MarketItemCard({Key? key, required this.item, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<CurrencyProvider>(context).currency;
    final currencySymbol = currency == 'EUR' ? '€' : '\$';

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.secondaryColor,
          child: _getLeadingIcon(),
        ),
        title: Text(item.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(item.symbol, style: TextStyle(color: Colors.grey[600])),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('$currencySymbol${item.price.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(
              '${item.change24h >= 0 ? '+' : ''}${item.change24h.toStringAsFixed(2)}%',
              style: TextStyle(
                color: item.change24h >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getLeadingIcon() {
    IconData iconData;
    switch (type) {
      case 'stock':
        iconData = Icons.show_chart;
        break;
      case 'etf':
        iconData = Icons.pie_chart;
        break;
      case 'crypto':
        iconData = Icons.currency_bitcoin;
        break;
      default:
        iconData = Icons.attach_money;
    }
    return Icon(iconData, color: AppColors.primaryColor);
  }
}
