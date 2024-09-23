import 'dart:convert';

class Investment {
  final String id;
  final String name;
  final double quantity;
  final double currentPrice;

  Investment({
    required this.id,
    required this.name,
    required this.quantity,
    required this.currentPrice,
  });

  // Méthode pour convertir un objet Investment en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'currentPrice': currentPrice,
    };
  }

  // Méthode pour créer un objet Investment à partir du JSON
  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      id: json['id'],
      name: json['name'],
      quantity: (json['quantity'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
    );
  }
}