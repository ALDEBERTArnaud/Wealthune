import 'dart:convert';

class Cryptocurrency {
  final String id;
  final String name;
  final double quantity;
  final double currentPrice;

  Cryptocurrency({
    required this.id,
    required this.name,
    required this.quantity,
    required this.currentPrice,
  });

  // Méthode pour convertir un objet Cryptocurrency en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'currentPrice': currentPrice,
    };
  }

  // Méthode pour créer un objet Cryptocurrency à partir du JSON
  factory Cryptocurrency.fromJson(Map<String, dynamic> json) {
    return Cryptocurrency(
      id: json['id'],
      name: json['name'],
      quantity: (json['quantity'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
    );
  }
}