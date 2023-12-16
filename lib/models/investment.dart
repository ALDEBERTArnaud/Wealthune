/// Classe représentant un investissement.
class Investment {
  // Propriétés d'un investissement.
  String id;             // Identifiant unique de l'investissement.
  String name;           // Nom de l'investissement.
  double quantity;       // Quantité de l'investissement.
  double purchasePrice;  // Prix d'achat de l'investissement.
  double currentPrice;   // Prix actuel de l'investissement.
  double interestRate;   // Taux d'intérêt de l'investissement.

  /// Constructeur pour initialiser un investissement.
  Investment({
    required this.id,
    required this.name,
    required this.quantity,
    required this.purchasePrice,
    required this.currentPrice,
    required this.interestRate,
  });

  /// Convertit un objet Investment en Map pour la sérialisation JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'purchasePrice': purchasePrice,
      'currentPrice': currentPrice,
      'interestRate': interestRate,
    };
  }

  /// Crée une instance de Investment à partir de données JSON.
  factory Investment.fromJson(Map<String, dynamic> jsonData) {
    return Investment(
      id: jsonData['id'],
      name: jsonData['name'],
      quantity: jsonData['quantity'],
      purchasePrice: jsonData['purchasePrice'],
      currentPrice: jsonData['currentPrice'],
      interestRate: jsonData['interestRate'],
    );
  }
}
