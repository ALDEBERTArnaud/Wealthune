/// Classe représentant un compte d'épargne.
class SavingsAccount {
  // Propriétés du compte d'épargne.
  String id;            // Identifiant unique du compte.
  String name;          // Nom du compte.
  double balance;       // Solde actuel du compte.
  double interestRate;  // Taux d'intérêt du compte.

  /// Constructeur pour initialiser un compte d'épargne.
  SavingsAccount({
    required this.id,
    required this.name,
    required this.balance,
    required this.interestRate,
  });

  /// Convertit un objet SavingsAccount en Map pour la sérialisation JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'interestRate': interestRate,
    };
  }

  /// Crée une instance de SavingsAccount à partir de données JSON.
  factory SavingsAccount.fromJson(Map<String, dynamic> jsonData) {
    return SavingsAccount(
      id: jsonData['id'],
      name: jsonData['name'],
      balance: jsonData['balance'],
      interestRate: jsonData['interestRate'],
    );
  }
}
