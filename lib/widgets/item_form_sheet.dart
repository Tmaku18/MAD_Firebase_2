import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/item.dart';

/// Reusable add/edit form (ICA #12 Phase C).
///
/// Callers supply [initial] for edit mode, or `null` for create.
/// [onSubmit] receives the composed [Item] (empty [Item.id] when creating).
class ItemFormSheet extends StatefulWidget {
  const ItemFormSheet({
    super.key,
    this.initial,
    required this.onSubmit,
  });

  final Item? initial;
  final Future<void> Function(Item item) onSubmit;

  @override
  State<ItemFormSheet> createState() => _ItemFormSheetState();
}

class _ItemFormSheetState extends State<ItemFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _nameController = TextEditingController(text: i?.name ?? '');
    _quantityController = TextEditingController(
      text: i != null ? '${i.quantity}' : '',
    );
    _priceController = TextEditingController(
      text: i != null ? _priceText(i.price) : '',
    );
  }

  static String _priceText(double p) {
    if (p == p.roundToDouble()) {
      return p.toInt().toString();
    }
    return p.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _validateQuantity(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) {
      return 'Quantity is required';
    }
    final n = int.tryParse(t);
    if (n == null) {
      return 'Enter a whole number';
    }
    if (n < 0) {
      return 'Quantity cannot be negative';
    }
    return null;
  }

  String? _validatePrice(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) {
      return 'Price is required';
    }
    final n = double.tryParse(t);
    if (n == null) {
      return 'Enter a valid number';
    }
    if (n < 0) {
      return 'Price cannot be negative';
    }
    return null;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final name = _nameController.text.trim();
    final qty = int.parse(_quantityController.text.trim());
    final price = double.parse(_priceController.text.trim());
    final id = widget.initial?.id ?? '';
    final item = Item(id: id, name: name, quantity: qty, price: price);
    await widget.onSubmit(item);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isEdit ? 'Edit item' : 'Add item',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              validator: _validateName,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _validateQuantity,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Unit price',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _validatePrice,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _save,
              child: Text(isEdit ? 'Save changes' : 'Add item'),
            ),
          ],
        ),
      ),
    );
  }
}
