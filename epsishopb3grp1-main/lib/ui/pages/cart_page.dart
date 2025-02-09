import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:epsi_shop/bo/cart.dart';
import 'package:http/http.dart' as http;

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

          double totalHT = cart.getTotalPriceWithoutTax();
          double totalTTC = cart.getTotalPriceWithTax();
          double tva = totalTTC - totalHT;

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

              /// 📌 **Total du panier avec TVA**
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Sous-total: ${totalHT.toStringAsFixed(2)}€",
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      "TVA (20%): ${tva.toStringAsFixed(2)}€",
                      style: const TextStyle(fontSize: 18, color: Colors.orange),
                    ),
                    Text(
                      "Total TTC: ${totalTTC.toStringAsFixed(2)}€",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
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

                    /// 📌 **Bouton "Procéder au paiement"**
                    if (cart.getTotalQuantity() > 0)
                      ElevatedButton(
                        onPressed: () {
                          _processPayment(cart, context);
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

  /// 📌 **Envoyer une requête d'achat lors du paiement**
  void _processPayment(Cart cart, BuildContext context) async {
    String apiUrl1 = "http://ptsv3.com/t/EPSISHOPC1/";
    String apiUrl2 = "http://ptsv3.com/t/EPSISHOPC2/";

    Map<String, dynamic> orderData = {
      "total_ht": cart.getTotalPriceWithoutTax(),
      "tva": cart.getTotalPriceWithTax() - cart.getTotalPriceWithoutTax(),
      "total_ttc": cart.getTotalPriceWithTax(),
      "products": cart.getAllProducts().map((product) {
        return {
          "id": product.id,
          "title": product.title,
          "price": product.price,
          "quantity": cart.getQuantity(product.id),
        };
      }).toList(),
    };

    String jsonOrder = jsonEncode(orderData);

    try {
      await http.post(Uri.parse(apiUrl1), body: jsonOrder, headers: {"Content-Type": "application/json"});
      await http.post(Uri.parse(apiUrl2), body: jsonOrder, headers: {"Content-Type": "application/json"});

      _showPaymentDialog(context);
      cart.clearCart();
    } catch (e) {
      print("Erreur lors du paiement: $e");
    }
  }

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
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
