import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealthune/utils/colors.dart';
import '../models/cryptocurrency.dart';

class CryptoCard extends StatelessWidget {
  final Cryptocurrency crypto; // La cryptomonnaie à afficher dans la carte
  final VoidCallback onTap; // La fonction à exécuter lorsque la carte est tapée

  const CryptoCard({
    Key? key,
    required this.crypto,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,##0.00', 'fr_FR'); // Format français pour les nombres

    double totalValue = crypto.quantity * crypto.currentPrice;

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
            Icons.currency_bitcoin, // Icône de la cryptomonnaie (Bitcoin)
            color: AppColors.primaryColor, // Couleur de l'icône
          ),
        ),
        title: Text(
          crypto.name, // Nom de la cryptomonnaie
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.secondaryColor,
          ),
        ),
        subtitle: Text(
          "Solde: ${numberFormat.format(totalValue)} €", // Solde de la cryptomonnaie formaté en euros
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