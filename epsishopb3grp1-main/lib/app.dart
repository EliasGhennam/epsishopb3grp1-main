import 'package:epsi_shop/ui/pages/detail_page.dart';
import 'package:epsi_shop/ui/pages/list_product_page.dart';
import 'package:epsi_shop/ui/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: "/",
            builder: (_, __) => ListProductPage(),
            routes: [
              GoRoute(
                name: "detail",
                path: "detail/:idProduct",
                builder: (_, state) {
                  int idProduct = int.tryParse(state.pathParameters["idProduct"] ?? "0") ?? 0;
                  return DetailPage(idProduct: idProduct);
                },
              ),
            ],
          ),

          /// 📌 **Ajout de la route du panier (en dehors de ListProductPage)**
          GoRoute(
            name: "cart",
            path: "/cart",
            builder: (_, __) => const CartPage(),
          ),
        ],
      ),
      title: 'EPSI Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
