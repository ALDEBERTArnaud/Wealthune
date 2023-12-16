import 'package:flutter/material.dart';
import '../models/saving_goal.dart';

class SavingGoalCard extends StatelessWidget {
  final SavingGoal goal; // L'objectif d'épargne à afficher dans la carte
  final VoidCallback onTap; // La fonction à exécuter lorsque la carte est tapée

  const SavingGoalCard({super.key, required this.goal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(goal.name), // Nom de l'objectif d'épargne
        subtitle: Text("Objectif: \$${goal.targetAmount.toStringAsFixed(2)}"), // Montant cible formaté en dollars
        trailing: CircularProgressIndicator(
          value: goal.currentAmount / goal.targetAmount, // Valeur de la barre de progression calculée en fonction de l'objectif actuel et de l'objectif cible
        ),
        onTap: onTap, // Action à effectuer lorsque la carte est tapée (à définir dans l'endroit où ce widget est utilisé)
      ),
    );
  }
}
