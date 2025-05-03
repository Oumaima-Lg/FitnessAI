import 'package:fitness/pages/bottomNavBar.dart';
import 'package:fitness/pages/home.dart';
import 'package:fitness/pages/welcome.dart';
// import 'package:fitness/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'pages/exercice_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2E2F55),
              Color(0xFF23253C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Welcome(),
      ),
    );
  }
}
