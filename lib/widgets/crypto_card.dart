import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealthune/utils/colors.dart';
import '../models/cryptocurrency.dart';

class CryptoCard extends StatelessWidget {
  final Cryptocurrency crypto; // La cryptomonnaie à afficher dans la carte
  final VoidCallback onTap; // La fonction à exécuter lorsque la carte est tapée

  const CryptoCard({super.key, required this.crypto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,##0', 'fr_FR'); // Format français pour les nombres

    return Card(
      elevation: 4, // Ombre légère pour la carte
      color: AppColors.primaryColor, // Couleur de fond de la carte

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Coins arrondis pour la carte
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.secondaryColor, // Couleur de fond du cercle d'avatar
          child: Icon(
            Icons.currency_bitcoin, // Icône de la cryptomonnaie (Bitcoin)
            color: AppColors.primaryColor, // Couleur de l'icône
          ),
        ),
        title: Text(
          crypto.name, // Nom de la cryptomonnaie
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
        ),
        subtitle: Text(
          "Solde: ${numberFormat.format(crypto.quantity * crypto.currentPrice)}€", // Solde de la cryptomonnaie formaté en euros
          style: const TextStyle(color: AppColors.secondaryColor, fontSize: 15),
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
