import 'package:flutter/material.dart';
import 'package:sales_app/core/models/product_model.dart';

class CartViewModel extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => _items;

  void addProduct(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id!] = CartItem(product: product, quantity: 1);
    }
    notifyListeners();
  }

  void removeProduct(int productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.quantity -= 1;
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  void updateQuantity(int productId, int quantity) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity = quantity;
      notifyListeners(); // biar UI rebuild & total price update
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice {
    double total = 0;
    _items.forEach((key, cartItem) {
      total += (cartItem.product.sellingPrice ?? 0) * cartItem.quantity;
    });
    return total;
  }

  int get totalItems {
    return _items.values.fold<int>(0, (sum, item) => sum + item.quantity);
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}
