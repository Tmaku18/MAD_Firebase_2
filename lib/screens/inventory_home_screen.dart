import 'package:flutter/material.dart';

import '../models/item.dart';
import '../services/item_firestore_service.dart';
import '../widgets/item_form_sheet.dart';

/// Main inventory UI: StreamBuilder, search filter, low-stock styling, totals.
class InventoryHomeScreen extends StatefulWidget {
  const InventoryHomeScreen({
    super.key,
    required this.service,
  });

  final ItemFirestoreService service;

  @override
  State<InventoryHomeScreen> createState() => _InventoryHomeScreenState();
}

class _InventoryHomeScreenState extends State<InventoryHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Item> _filter(List<Item> items) {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) {
      return items;
    }
    return items
        .where((e) => e.name.toLowerCase().contains(q))
        .toList(growable: false);
  }

  Future<void> _openForm({Item? existing}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return ItemFormSheet(
          initial: existing,
          onSubmit: (item) async {
            if (existing == null) {
              await widget.service.addItem(item);
            } else {
              await widget.service.updateItem(item);
            }
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(Item item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete item?'),
        content: Text('Remove "${item.name}" from inventory?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await widget.service.deleteItem(item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Item>>(
              stream: widget.service.streamItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                final items = snapshot.data ?? [];
                final visible = _filter(items);
                if (items.isEmpty) {
                  return const Center(child: Text('No items yet.'));
                }
                if (visible.isEmpty) {
                  return const Center(child: Text('No matching items.'));
                }
                return ListView.builder(
                  itemCount: visible.length,
                  itemBuilder: (_, i) {
                    final item = visible[i];
                    final low = item.isLowStock;
                    return ListTile(
                      title: Text(
                        item.name,
                        style: TextStyle(
                          fontWeight: low ? FontWeight.bold : null,
                          color: low ? Colors.deepOrange : null,
                        ),
                      ),
                      subtitle: Text(
                        low
                            ? 'Qty ${item.quantity} · \$${item.price.toStringAsFixed(2)} · low stock'
                            : 'Qty ${item.quantity} · \$${item.price.toStringAsFixed(2)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _openForm(existing: item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _confirmDelete(item),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          StreamBuilder<List<Item>>(
            stream: widget.service.streamItems(),
            builder: (context, snapshot) {
              final items = snapshot.data ?? [];
              final visible = _filter(items);
              final totalValue = visible.fold<double>(
                0,
                (sum, e) => sum + e.lineTotal,
              );
              return Material(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Filtered items: ${visible.length} · '
                          'Total value \$${totalValue.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
