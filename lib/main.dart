import 'package:fitness/manager/latest_activity.dart';
import 'package:fitness/pages/bottomNavBar.dart';
import 'package:fitness/pages/register.dart';
// import 'package:fitness/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:fitness/pages/completeRegister.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LatestActivityManager().initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
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
      ),
    );
  }
}
