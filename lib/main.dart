import 'package:fitness/pages/profile.dart';
import 'package:fitness/pages/statisticsPage.dart';
import 'package:fitness/services/latest_activity.dart';
// import 'package:fitness/pages/PlanningPage.dart';
import 'package:fitness/pages/bottomnavbar.dart';
import 'package:fitness/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:fitness/models/userStats.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase initialized");
  } catch (e, stacktrace) {
    print("❌ Firebase init error: $e");
    print("📌 Stacktrace: $stacktrace");
  }

  try {
    await LatestActivityManager().initialize();
    print("✅ LatestActivityManager initialized");
  } catch (e) {
    print("❌ LatestActivityManager error: $e");
  }

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
        child: Welcome(),
      ),
    );
  }
}
