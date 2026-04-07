/// Inventory row stored in Firestore collection `items`.
class Item {
  const Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  final String id;
  final String name;
  final int quantity;
  final double price;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  factory Item.fromMap(String id, Map<String, dynamic> data) {
    return Item(
      id: id,
      name: data['name'] as String? ?? '',
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Item copyWith({
    String? id,
    String? name,
    int? quantity,
    double? price,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  double get lineTotal => quantity * price;

  bool get isLowStock => quantity < 5;
}
