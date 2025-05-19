import 'package:flutter/material.dart';
import 'package:fitness/pages/bottomNavBar.dart';
// import 'package:fitness/pages/progress_photo.dart';
// import 'package:fitness/pages/welcome.dart';
import 'package:fitness/pages/chatbot/chat_bot_welcome.dart';

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
        child: BottomNavBar(),
        //child: ChatBotWelcome(),
      ),
    );
  }
}
