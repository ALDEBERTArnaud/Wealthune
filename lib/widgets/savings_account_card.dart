import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealthune/utils/colors.dart';
import '../models/savings_account.dart';

class SavingsAccountCard extends StatelessWidget {
  final SavingsAccount account; // Le compte d'épargne à afficher dans la carte
  final VoidCallback onTap; // La fonction à exécuter lorsque la carte est tapée

  const SavingsAccountCard({super.key, required this.account, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,##0', 'fr_FR'); // Format français pour les nombres
    return Card(
      elevation: 4,
      color: AppColors.primaryColor,
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.secondaryColor,
          child: Icon(
            Icons.savings,
            color: AppColors.primaryColor,
          ),
        ),
        title: Text(
          account.name, // Nom du compte d'épargne
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
        ),
        subtitle: Text(
          "Solde: ${numberFormat.format(account.balance)}€", // Solde du compte formaté en euros
          style: const TextStyle(color: AppColors.secondaryColor, fontSize: 15),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.secondaryColor,
        ),
        onTap: onTap, // Action à effectuer lorsque la carte est tapée (à définir dans l'endroit où ce widget est utilisé)
      ),
    );
  }
}
