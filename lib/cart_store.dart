import 'package:flutter/foundation.dart';

class CartItem {
  CartItem({
    required this.name,
    required this.price,
    required this.imagePath,
    this.quantity = 1,
  });

  final String name;
  final double price;
  final String imagePath;
  int quantity;

  double get total => price * quantity;
}

class CartStore extends ChangeNotifier {
  CartStore._();

  static final CartStore instance = CartStore._();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (total, item) => total + item.quantity);
  double get subtotal => _items.fold(0, (total, item) => total + item.total);

  void add({
    required String name,
    required String price,
    required String imagePath,
    required int quantity,
  }) {
    final parsedPrice = double.tryParse(
      price.replaceAll(RegExp(r'[^0-9.]'), ''),
    );
    if (parsedPrice == null || parsedPrice <= 0 || quantity < 1) {
      throw FormatException('Invalid product price or quantity.');
    }

    final existingIndex = _items.indexWhere((item) => item.name == name);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          name: name,
          price: parsedPrice,
          imagePath: imagePath,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void setQuantity(CartItem item, int quantity) {
    if (!_items.contains(item)) return;
    if (quantity < 1) {
      remove(item);
      return;
    }
    item.quantity = quantity;
    notifyListeners();
  }

  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
