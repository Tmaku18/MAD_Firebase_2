import 'package:flutter_test/flutter_test.dart';
import 'package:mad_firebase_2/models/item.dart';

void main() {
  test('Item round-trips through toMap and fromMap', () {
    const original = Item(
      id: 'abc',
      name: 'Notebook',
      quantity: 3,
      price: 4.5,
    );
    final map = original.toMap();
    final restored = Item.fromMap('abc', map);
    expect(restored.id, 'abc');
    expect(restored.name, 'Notebook');
    expect(restored.quantity, 3);
    expect(restored.price, 4.5);
    expect(restored.lineTotal, 13.5);
    expect(restored.isLowStock, true);
  });

  test('isLowStock false when quantity >= 5', () {
    const item = Item(id: 'x', name: 'Pen', quantity: 5, price: 1);
    expect(item.isLowStock, false);
  });
}
