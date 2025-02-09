import 'package:epsi_shop/bo/cart.dart';
import 'package:epsi_shop/bo/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ListProductPage extends StatelessWidget {
  ListProductPage({super.key});

  /// 🔥 Récupère les produits depuis l'API
  Future<List<Product>> getProducts() async {
    try {
      return await Product.fetchProducts();
    } catch (e) {
      return Future.error("Erreur de téléchargement : ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('EPSI Shop'),
        actions: [
          Consumer<Cart>(
            builder: (context, cart, child) {
              return IconButton(
                onPressed: () => context.go("/cart"),
                icon: Badge(
                  label: Text(cart.getAllProducts().length.toString()),
                  child: const Icon(Icons.shopping_cart),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // 🔄 Chargement propre
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun produit disponible."));
          } else {
            final listProducts = snapshot.data!;
            return ListViewProducts(listProducts: listProducts);
          }
        },
      ),
    );
  }
}

class ListViewProducts extends StatelessWidget {
  const ListViewProducts({super.key, required this.listProducts});

  final List<Product> listProducts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listProducts.length,
      itemBuilder: (ctx, index) {
        final product = listProducts[index];

        return InkWell(
          onTap: () => ctx.go("/detail/${product.id}"),
          child: ListTile(
            leading: Image.network(
              product.image,
              width: 90,
              height: 90,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image), // 🚀 Gère les images cassées
            ),
            title: Text(product.title),
            subtitle: Text(product.getPrice(), style: TextStyle(color: Colors.green)),
          ),
        );
      },
    );
  }
}
