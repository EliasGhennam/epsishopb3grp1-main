import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:epsi_shop/bo/product.dart';
import 'package:epsi_shop/bo/cart.dart';

class DetailPage extends StatelessWidget {
  final int idProduct;

  DetailPage({super.key, required this.idProduct});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détails du produit")),
      body: FutureBuilder<Product>(
        future: Product.fetchById(idProduct),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Produit introuvable"));
          }

          final product = snapshot.data!;
          return Column(
            children: [
              Image.network(product.image),
              Text(product.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(product.getPrice(), style: const TextStyle(fontSize: 20, color: Colors.green)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(product.description),
              ),
              const SizedBox(height: 20),

              /// 📌 **Bouton pour ajouter au panier**
              Consumer<Cart>(
                builder: (context, cart, child) {
                  return ElevatedButton(
                    onPressed: () {
                      cart.addProduct(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${product.title} ajouté au panier !")),
                      );
                    },
                    child: const Text("Ajouter au panier"),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
