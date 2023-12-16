/// Classe représentant une cryptomonnaie.
class Cryptocurrency {
  // Propriétés d'une cryptomonnaie.
  String id;             // Identifiant de la cryptomonnaie.
  String name;           // Nom de la cryptomonnaie.
  double quantity;       // Quantité possédée.
  double currentPrice;   // Prix actuel de la cryptomonnaie.
  double interestRate;   // Taux d'intérêt (si applicable).

  /// Constructeur pour initialiser une cryptomonnaie.
  Cryptocurrency({
    required this.id,
    required this.name,
    required this.quantity,
    required this.currentPrice,
    required this.interestRate,
  });

  /// Convertit un objet Cryptocurrency en Map pour la sérialisation JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'currentPrice': currentPrice,
      'interestRate': interestRate,
    };
  }

  /// Crée une instance de Cryptocurrency à partir de données JSON.
  factory Cryptocurrency.fromJson(Map<String, dynamic> jsonData) {
    return Cryptocurrency(
      id: jsonData['id'],
      name: jsonData['name'],
      quantity: jsonData['quantity'],
      currentPrice: jsonData['currentPrice'],
      interestRate: jsonData['interestRate'],
    );
  }
}
