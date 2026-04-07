import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/item.dart';

/// All Firestore access for inventory lives here (app API for the UI).
class ItemFirestoreService {
  ItemFirestoreService({FirebaseFirestore? firestore})
      : _itemsRef =
            (firestore ?? FirebaseFirestore.instance).collection('items');

  final CollectionReference<Map<String, dynamic>> _itemsRef;

  Future<void> addItem(Item item) async {
    await _itemsRef.add(item.toMap());
  }

  Stream<List<Item>> streamItems() {
    return _itemsRef.snapshots().map(
          (snap) => snap.docs
              .map((d) => Item.fromMap(d.id, d.data()))
              .toList(growable: false),
        );
  }

  Future<void> updateItem(Item item) async {
    await _itemsRef.doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String id) async {
    await _itemsRef.doc(id).delete();
  }
}
