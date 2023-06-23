
import 'package:flutter/material.dart';
import 'package:conversor_moeda/pages/main_page.dart';

void main() {
  runApp(MaterialApp(
    home: const MainPage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber),
        ),
        hintStyle: TextStyle(color: Colors.amber),
      ),
    ),
  ));
}

// https://api.hgbrasil.com/finace?format=json&key=3bc3d890

