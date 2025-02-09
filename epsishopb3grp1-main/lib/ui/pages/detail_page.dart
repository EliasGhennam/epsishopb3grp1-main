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

          return LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth = constraints.maxWidth; // Largeur de l'écran

              return Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: maxWidth > 600 ? 600 : maxWidth * 0.9, // ✅ Max 600px sur grand écran
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// 📌 **Image du produit (adaptative)**
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            product.image,
                            width: maxWidth > 600 ? 400 : maxWidth * 0.8, // ✅ Ajuste l'image
                            height: 300,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => 
                                const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 📌 **Titre du produit**
                        Text(
                          product.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 10),

                        /// 📌 **Prix**
                        Text(
                          product.getPrice(),
                          style: const TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 20),

                        /// 📌 **Description du produit**
                        Text(
                          product.description,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),

                        const SizedBox(height: 30),

                        /// 📌 **Bouton "Ajouter au panier"**
                        Consumer<Cart>(
                          builder: (context, cart, child) {
                            return ElevatedButton(
                              onPressed: () {
                                cart.addProduct(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${product.title} ajouté au panier !")),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              ),
                              child: const Text(
                                "Ajouter au panier",
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
