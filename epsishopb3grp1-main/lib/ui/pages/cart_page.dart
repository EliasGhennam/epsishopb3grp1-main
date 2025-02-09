import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:epsi_shop/bo/cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Votre panier")),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          if (cart.getTotalQuantity() == 0) {
            return const Center(child: Text("Votre panier est vide."));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.getAllProducts().length,
                  itemBuilder: (context, index) {
                    final product = cart.getAllProducts()[index];
                    final quantity = cart.getQuantity(product.id);

                    return ListTile(
                      leading: Image.network(product.image, width: 50, height: 50),
                      title: Text(product.title),
                      subtitle: Text("Quantité: $quantity | ${product.getPrice()}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => cart.removeProduct(product.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => cart.addProduct(product),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// 📌 **Total du panier**
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Total: ${cart.getTotalPrice().toStringAsFixed(2)}€",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    /// 📌 **Bouton "Vider le panier"**
                    ElevatedButton(
                      onPressed: () {
                        cart.clearCart();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Panier vidé !")),
                        );
                      },
                      child: const Text("Vider le panier"),
                    ),
                    const SizedBox(height: 10),

                    /// 📌 **Bouton "Procéder au paiement"** (Visible seulement si le panier n'est pas vide)
                    if (cart.getTotalQuantity() > 0)
                      ElevatedButton(
                        onPressed: () {
                          _showPaymentDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Couleur verte pour paiement
                        ),
                        child: const Text(
                          "Procéder au paiement",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 📌 **Afficher un message de confirmation après paiement**
  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Paiement confirmé"),
          content: const Text("Votre commande a été traitée avec succès !"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<Cart>(context, listen: false).clearCart(); // Vider le panier après paiement
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
