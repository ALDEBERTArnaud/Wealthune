import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wealthune/providers/currency_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Devise'),
            subtitle: Text(Provider.of<CurrencyProvider>(context).currency),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: const Text('Choisir une devise'),
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () {
                          Provider.of<CurrencyProvider>(context, listen: false).setCurrency('EUR');
                          Navigator.pop(context);
                        },
                        child: const Text('EUR'),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          Provider.of<CurrencyProvider>(context, listen: false).setCurrency('USD');
                          Navigator.pop(context);
                        },
                        child: const Text('USD'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}