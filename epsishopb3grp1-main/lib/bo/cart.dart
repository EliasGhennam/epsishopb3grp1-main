import 'package:flutter/material.dart';
import 'product.dart';

class Cart with ChangeNotifier {
  final Map<int, int> _items = {}; // Stocke l'ID du produit et sa quantité
  final Map<int, Product> _products = {}; // Stocke les produits pour récupération facile

  /// 📌 **Ajouter un produit au panier**
  void addProduct(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id] = _items[product.id]! + 1;
    } else {
      _items[product.id] = 1;
      _products[product.id] = product;
    }
    notifyListeners();
  }

  /// 📌 **Retirer un produit du panier**
  void removeProduct(int productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]! > 1) {
        _items[productId] = _items[productId]! - 1;
      } else {
        _items.remove(productId);
        _products.remove(productId);
      }
      notifyListeners();
    }
  }

  /// 📌 **Vider le panier**
  void clearCart() {
    _items.clear();
    _products.clear();
    notifyListeners();
  }

  /// 📌 **Obtenir la liste des produits dans le panier**
  List<Product> getAllProducts() => _items.keys.map((id) => _products[id]!).toList();

  /// 📌 **Obtenir la quantité totale des produits**
  int getTotalQuantity() => _items.values.fold(0, (total, quantity) => total + quantity);

  /// 📌 **Obtenir le prix total (hors TVA)**
  double getTotalPriceWithoutTax() {
    return _items.entries.fold(
      0.0,
      (total, entry) => total + (_products[entry.key]!.price * entry.value),
    );
  }

  /// 📌 **Obtenir le prix total avec TVA (20%)**
  double getTotalPriceWithTax() {
    double totalWithoutTax = getTotalPriceWithoutTax();
    return totalWithoutTax * 1.20; // Ajout de la TVA de 20%
  }

  /// 📌 **Obtenir la quantité spécifique d'un produit**
  int getQuantity(int productId) => _items[productId] ?? 0;
}
