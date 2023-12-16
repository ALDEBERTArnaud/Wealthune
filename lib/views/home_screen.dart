import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wealthune/utils/colors.dart';
import 'package:wealthune/views/interest_calculator_screen.dart';
import 'package:wealthune/services/home_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // Crée l'état pour le widget HomeScreen
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double bankAccountsTotal = 0;
  double cryptoTotal = 0;
  double savingsTotal = 0;
  double investmentsTotal = 0;

  @override
  void initState() {
    super.initState();
    fetchData(); // Appel de la fonction pour récupérer les données
  }

  final numberFormat = NumberFormat('#,##0', 'fr_FR');

  // Fonction pour récupérer les données
  void fetchData() async {
    var totals = await getTotalWealth();
    bankAccountsTotal = totals['bankAccountsTotal']!;
    cryptoTotal = totals['cryptoTotal']!;
    savingsTotal = totals['savingsTotal']!;
    investmentsTotal = totals['investmentsTotal']!;
    setState(() {});
  }

  // Fonction pour obtenir la valeur totale depuis les préférences partagées
  Future<double> getTotalFromService(SharedPreferences prefs, String key) async {
    final stringValue = prefs.getString(key);
    if (stringValue != null) {
      // Si la valeur n'est pas nulle, essayez de la convertir en double
      return double.tryParse(stringValue) ?? 0.0;
    }
    return 0.0; // Retourne 0.0 si la clé n'existe pas ou si la conversion échoue
  }

  @override
  Widget build(BuildContext context) {
    // Calcul du patrimoine total
    final double totalWealth = bankAccountsTotal + cryptoTotal + savingsTotal + investmentsTotal;

    // Création des sections pour le PieChart
    final List<PieChartSectionData> sections = [
      PieChartSectionData(
        color: Colors.blue,
        value: bankAccountsTotal,
        title: '${(bankAccountsTotal / totalWealth * 100).toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: cryptoTotal,
        title: '${(cryptoTotal / totalWealth * 100).toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: savingsTotal,
        title: '${(savingsTotal / totalWealth * 100).toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: investmentsTotal,
        title: '${(investmentsTotal / totalWealth * 100).toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/logo_wealthune.png', height: 50,),
        title: const Text('Wealthune', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligner les widgets enfants à gauche
          children: <Widget>[
            Container(
              height: 1,
              color: Colors.white.withAlpha(50), // Légère barre blanche
            ),
            Container(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12.0), // Ajouter une marge tout autour
              child: Text(
                'Patrimoine Actuel :', // Texte fixe
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0), // Ajouter une marge à gauche
              child: Text(
                '${numberFormat.format(totalWealth)} €', // Remplacez par le total calculé
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 40, // Taille de police plus grande pour le montant
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 60),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: sections
                ),
              ),
            ),
            const SizedBox(height: 80),
            buildWealthList(), // Nouvelle méthode pour afficher la liste
            const SizedBox(height: 40),
            Center( // Centrer le bouton
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InterestCalculatorScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                child: const Text('Calculateur d\'intérêts composés', style: TextStyle(color: AppColors.secondaryColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour construire la liste des éléments de patrimoine
  Widget buildWealthList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildWealthListItem(Colors.blue, 'Total des comptes', bankAccountsTotal),
        buildWealthListItem(Colors.red, 'Total des cryptos', cryptoTotal),
        buildWealthListItem(Colors.green, 'Total des épargnes', savingsTotal),
        buildWealthListItem(Colors.orange, 'Total des actions & ETFs', investmentsTotal),
      ],
    );
  }

  // Fonction pour construire un élément de patrimoine
  Widget buildWealthListItem(Color color, String title, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$title : ${numberFormat.format(amount)} €',
            style: const TextStyle(fontSize: 16, color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }
}
