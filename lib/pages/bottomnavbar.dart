import 'package:fitness/pages/Alimentation/alim_home.dart';
import 'package:fitness/pages/exercice_page.dart';
import 'package:fitness/pages/home.dart';
import 'package:fitness/pages/profile.dart';
import 'package:fitness/pages/statisticsPage.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fitness/models/userStats.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNavBar> {
  late List<Widget> pages;

  late HomePage homePage;
  // late ProgressePage homePage;
  late ExercicePage exercicePage;
  late Statistics statistics;
  late ProfilePage profilePage;
  late AlimHomePage alimentationPage;

  int currentTabIndex = 0;

  @override
  void initState() {
    homePage = HomePage();
    // homePage = ProgressePage();
    exercicePage = ExercicePage();
    profilePage = ProfilePage();
    alimentationPage = AlimHomePage();
    statistics = Statistics(
      stats: UserStats(
        trainingTime: 2628,
        steps: 2628,
        calories: 510.43,
        sleep: "08:00",
        water: 2.1,
        heartRate: 105,
      ),
    );

    pages = [homePage, exercicePage, alimentationPage, statistics, profilePage];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        backgroundColor: const Color.fromARGB(0, 201, 13, 13),
        buttonBackgroundColor: Color(0xffEB62BC).withAlpha(170),
        color: Color(0xff373856),
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Image.asset('images/Home.png', width: 30.0, height: 30.0),
          Image.asset('images/sportIcon.png', width: 30.0, height: 30.0),
          Image.asset('images/food.png', width: 30.0, height: 30.0),
          Image.asset('images/statisticIcon.png', width: 30.0, height: 30.0),
          Image.asset('images/userIcon.png', width: 30.0, height: 30.0),
        ],
      ),
      body: Container(
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
        child: pages[currentTabIndex],
      ),
    );
  }
}
