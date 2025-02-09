import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bo/cart.dart';
import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: MyApp(),
    ),
  );
}