import 'package:flutter/material.dart';
import 'package:social_network/module/splash_page.dart';

void main() {
  runApp(MaterialApp(
    title: 'Social',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const SplashPage(),
  ));
}
