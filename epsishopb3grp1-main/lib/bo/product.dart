import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final String image;
  final num price;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.image,
    required this.price,
  });

  /// 📌 **Formater le prix en euros**
  String getPrice() => "${price.toStringAsFixed(2)}€";

  /// 📌 **Convertir un `Product` en `Map`**
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'image': image,
      'price': price,
    };
  }

  /// 📌 **Créer un `Product` à partir d'un `Map`**
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      image: map['image'] as String,
      price: map['price'] as num,
    );
  }

  /// 📌 **Créer un `Product` à partir d'une chaîne JSON**
  factory Product.fromJson(String source) => Product.fromMap(jsonDecode(source));

  /// 📌 **Récupérer tous les produits depuis l'API**
  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse("https://fakestoreapi.com/products"));

      if (response.statusCode == 200) {
        List<dynamic> listMapProducts = jsonDecode(response.body);
        return listMapProducts.map((map) => Product.fromMap(map)).toList();
      } else {
        throw Exception("Erreur de téléchargement des produits : ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur lors de la récupération des produits : $e");
    }
  }

  /// 📌 **Récupérer un produit spécifique par ID depuis l'API**
  static Future<Product> fetchById(int idProduct) async {
    try {
      final response = await http.get(Uri.parse("https://fakestoreapi.com/products/$idProduct"));

      if (response.statusCode == 200) {
        return Product.fromJson(response.body);
      } else {
        throw Exception("Produit introuvable (ID: $idProduct)");
      }
    } catch (e) {
      throw Exception("Erreur lors de la récupération du produit : $e");
    }
  }
}
