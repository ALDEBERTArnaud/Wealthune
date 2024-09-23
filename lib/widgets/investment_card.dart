import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealthune/utils/colors.dart';
import '../models/investment.dart';

class InvestmentCard extends StatelessWidget {
  final Investment investment; // L'investissement à afficher dans la carte
  final VoidCallback onTap; // La fonction à exécuter lorsque la carte est tapée

  const InvestmentCard({
    Key? key,
    required this.investment,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,##0.00', 'fr_FR'); // Format français pour les nombres

    double totalValue = investment.quantity * investment.currentPrice;

    return Card(
      elevation: 4, // Ombre légère pour la carte
      color: AppColors.primaryColor, // Couleur de fond de la carte
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Coins arrondis pour la carte
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        leading: CircleAvatar(
          backgroundColor: AppColors.secondaryColor, // Couleur de fond du cercle d'avatar
          child: const Icon(
            Icons.trending_up, // Icône de l'investissement (graphique en tendance)
            color: AppColors.primaryColor, // Couleur de l'icône
          ),
        ),
        title: Text(
          investment.name, // Nom de l'investissement
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.secondaryColor,
          ),
        ),
        subtitle: Text(
          "Solde: ${numberFormat.format(totalValue)} €", // Solde de l'investissement formaté en euros
          style: const TextStyle(
            color: AppColors.secondaryColor,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios, // Icône de la flèche vers la droite pour la navigation
          color: AppColors.secondaryColor, // Couleur de l'icône de la flèche
        ),
        onTap: onTap, // Action à effectuer lorsque la carte est tapée
      ),
    );
  }
}