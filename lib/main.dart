import 'package:flutter/material.dart';  // Importation du package Flutter
import 'package:wealthune/utils/colors.dart';  // Importation du fichier de couleurs personnalisées
import 'views/home_screen.dart';  // Importation de l'écran d'accueil
import 'views/accounts_screen.dart';  // Importation de l'écran des comptes
import 'views/crypto_screen.dart';  // Importation de l'écran des cryptomonnaies
import 'views/savings_screen.dart';  // Importation de l'écran d'épargne
import 'views/investments_screen.dart';  // Importation de l'écran des investissements

void main() {
  runApp(const MyApp());  // Point d'entrée de l'application Flutter, lance le widget racine (MyApp)
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wealthune',  // Titre de l'application
      theme: ThemeData(
        // Configuration du thème de l'application
        scaffoldBackgroundColor: AppColors.secondaryColor,  // Couleur de fond globale
        fontFamily: 'Montserrat',  // Police de caractères par défaut
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          // Configuration du thème de la barre de navigation inférieure
          selectedItemColor: AppColors.primaryColor,  // Couleur de l'élément sélectionné
          unselectedItemColor: Colors.grey,  // Couleur des éléments non sélectionnés
        )
      ),
      home: const MainScreen(),  // Page d'accueil de l'application
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();  // Création de l'état de l'écran principal
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;  // Indice de l'élément actuellement sélectionné dans la barre de navigation

  // Liste des widgets à afficher pour chaque élément de la barre de navigation
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    AccountsScreen(),
    CryptoScreen(),
    SavingsScreen(),
    InvestmentsScreen(),
  ];

  // Méthode appelée lorsque l'utilisateur sélectionne un élément dans la barre de navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // Met à jour l'indice de l'élément sélectionné
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),  // Affiche le widget correspondant à l'élément sélectionné
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 1,
            color: Colors.white.withAlpha(50),  // Barre blanche légère en dessous de la barre de navigation
          ),
          BottomNavigationBar(
            type: BottomNavigationBarType.shifting,  // Type de la barre de navigation (avec des animations)
            items: const <BottomNavigationBarItem>[
              // Liste des éléments de la barre de navigation avec des icônes et des libellés
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil', backgroundColor: AppColors.secondaryColor),
              BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: 'Comptes', backgroundColor: AppColors.secondaryColor),
              BottomNavigationBarItem(icon: Icon(Icons.currency_bitcoin), label: 'Crypto', backgroundColor: AppColors.secondaryColor),
              BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'Épargne', backgroundColor: AppColors.secondaryColor),
              BottomNavigationBarItem(icon: Icon(Icons.candlestick_chart), label: 'Actions & ETFs', backgroundColor: AppColors.secondaryColor),
            ],
            currentIndex: _selectedIndex,  // Indice de l'élément actuellement sélectionné
            onTap: _onItemTapped,  // Appelle la méthode _onItemTapped lorsque l'utilisateur sélectionne un élément
          ),
        ],
      ),
    );
  }
}
