/// Classe représentant un compte bancaire.
class BankAccount {
  // Propriétés du compte bancaire.
  String id;       // Identifiant du compte.
  String name;     // Nom du compte.
  double balance;  // Solde du compte.

  /// Constructeur pour initialiser un compte bancaire.
  BankAccount({required this.id, required this.name, required this.balance});

  /// Crée un compte à partir de données JSON.
  factory BankAccount.fromJson(Map<String, dynamic> jsonData) {
    return BankAccount(
      id: jsonData['id'],
      name: jsonData['name'],
      balance: jsonData['balance'],
    );
  }

  /// Convertit un compte en format JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
    };
  }
}
