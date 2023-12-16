import 'package:flutter/material.dart';
import 'package:wealthune/utils/colors.dart';
import 'package:wealthune/views/investments/investment_details_screen.dart';
import 'package:wealthune/views/investments/create_investment_screen.dart';
import '../models/investment.dart';
import '../services/investment_service.dart';
import '../widgets/investment_card.dart';

class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({super.key});

  @override
  // Crée l'état pour le widget InvestmentsScreen
  // ignore: library_private_types_in_public_api
  _InvestmentsScreenState createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> {
  // Service pour gérer les investissements
  final InvestmentService _investmentService = InvestmentService();
  late Future<List<Investment>> _investmentsFuture;

  @override
  void initState() {
    super.initState();
    // Initialise le Future avec la liste des investissements
    _investmentsFuture = _investmentService.getInvestments();
  }

  // Fonction pour naviguer et créer un nouvel investissement
  void _navigateAndCreateInvestment(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateInvestmentScreen()),
    );
    // Rafraîchit la liste des investissements après la création
    setState(() {
      _investmentsFuture = _investmentService.getInvestments();
    });
  }

  // Fonction pour naviguer vers les détails d'un investissement
  void _navigateToInvestmentDetails(Investment investment) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvestmentDetailsScreen(investment: investment, onInvestmentUpdated: () {
          // Rafraîchit la liste des investissements après la mise à jour
          setState(() {
            _investmentsFuture = _investmentService.getInvestments();
          });
        },
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/logo_wealthune.png', height: 50,),
        title: const Text('Actions & ETFs', style: TextStyle(color: AppColors.primaryColor)),
        backgroundColor: AppColors.secondaryColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            color: AppColors.primaryColor,
            onPressed: () => _navigateAndCreateInvestment(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Investment>>(
        future: _investmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun investissement trouvé."));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final investment = snapshot.data![index];
                return InvestmentCard(
                  investment: investment,
                  onTap: () => _navigateToInvestmentDetails(investment),
                );
              },
            );
          }
        },
      ),
    );
  }
}
