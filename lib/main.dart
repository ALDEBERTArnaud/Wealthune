import 'package:flutter/material.dart';
import 'package:wealthune/utils/colors.dart';
import 'views/home_screen.dart';
import 'views/portfolio_screen.dart';
import 'views/market_screen.dart';
import 'views/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wealthune',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.secondaryColor,
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.accentColor),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    PortfolioScreen(),
    MarketScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Portefeuille'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Marché'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}