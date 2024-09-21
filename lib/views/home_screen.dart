import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:wealthune/utils/colors.dart';
import 'package:wealthune/views/interest_calculator_screen.dart';
import 'package:wealthune/services/home_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double bankAccountsTotal = 0;
  double cryptoTotal = 0;
  double savingsTotal = 0;
  double investmentsTotal = 0;
  final numberFormat = NumberFormat('#,##0', 'fr_FR');

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var totals = await getTotalWealth();
    setState(() {
      bankAccountsTotal = totals['bankAccountsTotal']!;
      cryptoTotal = totals['cryptoTotal']!;
      savingsTotal = totals['savingsTotal']!;
      investmentsTotal = totals['investmentsTotal']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double totalWealth = bankAccountsTotal + cryptoTotal + savingsTotal + investmentsTotal;

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
        leading: Image.asset('assets/logo_wealthune.png', height: 50),
        title: const Text('Wealthune', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 1,
              color: Colors.white.withAlpha(50),
            ),
            Container(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                'Patrimoine Actuel :',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text(
                '${numberFormat.format(totalWealth)} €',
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 40,
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
                  sections: sections,
                ),
              ),
            ),
            const SizedBox(height: 80),
            buildWealthList(),
            const SizedBox(height: 40),
            Center(
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

  Widget buildWealthListItem(Color color, String title, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(title),
          const Spacer(),
          Text('${numberFormat.format(amount)} €'),
        ],
      ),
    );
  }
}