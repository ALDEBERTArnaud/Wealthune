/// Classe représentant un objectif d'épargne.
class SavingGoal {
  // Propriétés de l'objectif d'épargne.
  String id;              // Identifiant unique de l'objectif.
  String name;            // Nom de l'objectif d'épargne.
  double targetAmount;    // Montant cible à atteindre.
  double currentAmount;   // Montant actuellement épargné.
  DateTime targetDate;    // Date cible pour atteindre l'objectif.

  /// Constructeur pour initialiser un objectif d'épargne.
  SavingGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
  });

  /// Convertit un objet SavingGoal en Map pour la sérialisation JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate.toIso8601String(), // Conversion de DateTime en String pour JSON.
    };
  }

  /// Crée une instance de SavingGoal à partir de données JSON.
  factory SavingGoal.fromJson(Map<String, dynamic> jsonData) {
    return SavingGoal(
      id: jsonData['id'],
      name: jsonData['name'],
      targetAmount: jsonData['targetAmount'],
      currentAmount: jsonData['currentAmount'],
      targetDate: DateTime.parse(jsonData['targetDate']), // Conversion de String en DateTime.
    );
  }
}
