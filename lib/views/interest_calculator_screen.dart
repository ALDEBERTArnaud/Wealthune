import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealthune/services/interest_calculator_service.dart';
import 'package:wealthune/utils/colors.dart';

class InterestCalculatorScreen extends StatefulWidget {
  const InterestCalculatorScreen({super.key});

  @override
  // Crée l'état pour le widget InterestCalculatorScreen
  // ignore: library_private_types_in_public_api
  _InterestCalculatorScreenState createState() => _InterestCalculatorScreenState();
}

class _InterestCalculatorScreenState extends State<InterestCalculatorScreen> {
  // Contrôleurs pour les champs de texte
  final _amountController = TextEditingController();
  final _rateController = TextEditingController();
  final _yearsController = TextEditingController();
  final _monthlyContributionController = TextEditingController();

  // Mode de calcul des intérêts par défaut
  String _interestCalculationMode = 'Annuel';
  final List<String> _interestCalculationOptions = ['Annuel', 'Mensuel', 'Journalier'];

  // Variables pour stocker les résultats du calcul
  double _totalAmount = 0;
  double _totalInvestment = 0;
  double _totalInterestEarned = 0;
  List<Map<String, dynamic>> _tableData = [];

  // Fonction pour effectuer le calcul des intérêts
  void _calculateInterest() {
    // Récupération des valeurs des champs de texte
    final double principal = double.tryParse(_amountController.text) ?? 0;
    final double annualRate = double.tryParse(_rateController.text) ?? 0;
    final int years = int.tryParse(_yearsController.text) ?? 0;
    final double monthlyContribution = double.tryParse(_monthlyContributionController.text) ?? 0;

    // Appel de la fonction de calcul des intérêts
    var calculationResults = calculateInterest(
      principal,
      annualRate,
      years,
      monthlyContribution,
      _interestCalculationMode,
    );

    // Mise à jour des données et de l'état
    _tableData = calculationResults['tableData'];
    _totalAmount = calculationResults['totalAmount'];
    _totalInterestEarned = calculationResults['totalInterestEarned'];
    _totalInvestment = calculationResults['totalInvestment'];

    setState(() {});
  }

  // Fonction pour formater un nombre en tant que chaîne de caractères
  String _formatNumber(double number) {
    final NumberFormat numberFormat = NumberFormat('#,##0', 'fr_FR');
    return numberFormat.format(number);
  }

  @override
  void dispose() {
    // Libération des ressources des contrôleurs
    _amountController.dispose();
    _rateController.dispose();
    _yearsController.dispose();
    _monthlyContributionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        title: const Text('Calcul d\'intérêts composés', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Champs de texte pour les données d'entrée
              TextFormField(
                style: const TextStyle(color: AppColors.primaryColor),
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Montant initial (€)',
                  labelStyle: TextStyle(color: AppColors.primaryColor),
                  suffixIconColor: AppColors.primaryColor,
                  suffixIcon: Icon(Icons.euro_symbol),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                style: const TextStyle(color: AppColors.primaryColor),
                controller: _rateController,
                decoration: const InputDecoration(
                  labelText: 'Rendements (%)',
                  labelStyle: TextStyle(color: AppColors.primaryColor),
                  suffixIconColor: AppColors.primaryColor,
                  suffixIcon: Icon(Icons.percent),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                style: const TextStyle(color: AppColors.primaryColor),
                controller: _yearsController,
                decoration: const InputDecoration(
                  labelText: 'Durée d\'épargne (Année(s))',
                  labelStyle: TextStyle(color: AppColors.primaryColor),
                  suffixIconColor: AppColors.primaryColor,
                  suffixIcon: Icon(Icons.calendar_month),
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                style: const TextStyle(color: AppColors.primaryColor),
                controller: _monthlyContributionController,
                decoration: const InputDecoration(
                  labelText: 'Contribution mensuelle (€)',
                  labelStyle: TextStyle(color: AppColors.primaryColor),
                  suffixIcon: Icon(Icons.euro_symbol),
                  suffixIconColor: AppColors.primaryColor,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),

              const SizedBox(height: 20),

              // Sélection du mode de calcul des intérêts
              const Text(
                'Fréquence du calcul des intérêts :',
                style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
              ),

              DropdownButton<String>(
                value: _interestCalculationMode,
                dropdownColor: AppColors.secondaryColor,
                items: _interestCalculationOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: AppColors.primaryColor)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _interestCalculationMode = newValue!;
                  });
                },
              ),

              Center(
                child: ElevatedButton(
                  onPressed: _calculateInterest,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                  child: const Text('Calculer', style: TextStyle(color: AppColors.secondaryColor)),
                ),
              ),

              const SizedBox(height: 20),

              // Affichage du montant total à la fin
              Text(
                'Capital total : ${_formatNumber(_totalAmount)} €',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryColor),
              ),

              // Affichage du total investi sur toute la période
              Text(
                'Investissement : ${_formatNumber(_totalInvestment)} €',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryColor),
              ),

              // Affichage du total des intérêts gagnés sur toute la période
              Text(
                'Intérêts gagnés : ${_formatNumber(_totalInterestEarned)} €',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryColor),
              ),

              const SizedBox(height: 20),

              // Tableau des résultats annuels
              DataTable(
                columnSpacing: 35, // Réduire l'espacement entre les colonnes
                columns: const [
                  DataColumn(label: Expanded(child: Text('Année', style: TextStyle(color: AppColors.primaryColor)))),
                  DataColumn(label: Expanded(child: Text('Investi', style: TextStyle(color: AppColors.primaryColor)))),
                  DataColumn(label: Expanded(child: Text('Intérêts', style: TextStyle(color: AppColors.primaryColor)))),
                  DataColumn(label: Expanded(child: Text('Solde', style: TextStyle(color: AppColors.primaryColor)))),
                ],
                rows: _tableData.map<DataRow>((data) => DataRow(
                  cells: [
                    DataCell(Text(data['year'].toString(), style: const TextStyle(color: AppColors.primaryColor))),
                    DataCell(Text(_formatNumber(data['investment']), style: const TextStyle(color: AppColors.primaryColor))),
                    DataCell(Text(_formatNumber(data['interest']), style: const TextStyle(color: AppColors.primaryColor))),
                    DataCell(Text(_formatNumber(data['balance']), style: const TextStyle(color: AppColors.primaryColor))),
                  ],
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
