import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealthune/utils/colors.dart';
import '../models/bank_account.dart';

class BankAccountCard extends StatelessWidget {
  final BankAccount account; // Le compte bancaire à afficher dans la carte
  final VoidCallback onTap; // La fonction à exécuter lorsque la carte est tapée

  const BankAccountCard({super.key, required this.account, required this.onTap});

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
            Icons.account_balance, // Icône du compte bancaire
            color: AppColors.primaryColor, // Couleur de l'icône
          ),
        ),
        title: Text(
          account.name, // Nom du compte bancaire
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
        ),
        subtitle: Text(
          "Solde: ${numberFormat.format(account.balance)}€", // Solde du compte formaté en euros
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
