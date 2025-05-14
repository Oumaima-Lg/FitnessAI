import 'package:fitness/activity%20tracker/activity_tracker.dart';
import 'package:fitness/components/gradient.dart';
import 'package:fitness/components/personalized_widget.dart';
import 'package:fitness/data/exercice_data.dart';
import 'package:fitness/manager/latest_activity.dart';
import 'package:fitness/models/exercice.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:fitness/models/latest_activity.dart';
import 'package:fitness/pages/PlanningPage.dart';
import 'package:fitness/pages/notifications.dart';
import 'package:fitness/pages/progress_photo.dart';
import 'package:fitness/planning/focus.dart';
import 'package:flutter/material.dart';

// final int completedTasks;
// final int totalTasks;
// value: completedTasks/totalTasks.toDouble(),

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final activityManager = LatestActivityManager();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController(
    viewportFraction: 0.9,
  );
  int _currentPage = 0;
  List<Exercice> exercices = [];
  List<LatestActivity> latestActivities = [];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadDataExercice();
    loadDataLatestActivities();
  }

  void loadDataLatestActivities() async {
    await activityManager.loadActivities();
    setState(() {
      // latestActivities = activityManager.activities;
      if (activityManager.activities.length >= 2) {
        latestActivities = activityManager.activities.take(2).toList();
      } else if (activityManager.activities.isNotEmpty) {
        latestActivities = activityManager.activities.take(1).toList();
      } else {
        latestActivities = activityManager.activities;
      }
    });
  }

  void loadDataExercice() async {
    List<Exercice> data = await ExerciceData.getExercices();
    setState(() {
      exercices = data;
    });
  }

  void navigateToPlanningPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Container(
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
          child: page,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (exercices.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: Image.asset('images/gif/Animation.gif')),
      );
    }
    return Stack(
      children: [
        Positioned(
          height: MediaQuery.of(context).size.height * 0.32,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'images/Ellipse.png',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(top: 25, left: 15),
              child: IconButton(
                icon: const Icon(
                  Icons.sort,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15, top: 25),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 20,
                  child: ClipOval(
                    child: Image.asset(
                      'images/img.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                ),
              ),
            ],
          ),
          drawer: Drawer(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1F2036),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(left: 25, top: 70, bottom: 30),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFF3A3B5C), width: 1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Daniel Matt',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Mophsic',
                          style: TextStyle(
                            color: Color(0xFFC4C4C4),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Beijing Haidian-District',
                          style: TextStyle(
                            color: Colors.white.withAlpha(178),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _drawerItem('Activity Tracker', Icons.auto_graph, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ActivityTracker()));
                  }),
                  _drawerItem('Progress Photo', Icons.photo_camera, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProgressePage()));
                    // print("Progress Photo");
                  }),
                  _drawerItem('Coach', Icons.person, () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => Coach()));
                    print("Coach");
                  }),
                  _drawerItem('Notifications', Icons.notifications, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPage()));
                    // print("Notifications");
                  }),
                  _drawerItem('AI Conversation', Icons.chat, () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => AIConversation()));
                    print("AI Conversation");
                  }),
                  _drawerItem('Planning', Icons.calendar_today, () {
                    navigateToPlanningPage(context, PlanningPage());
                  }),
                  const SizedBox(height: 60),
                  Center(
                    child: Image.asset(
                      'images/slideBarImage.png',
                      width: 155,
                      height: 101,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              margin: const EdgeInsets.only(left: 22, right: 22, top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hello, Daniel Matt',
                      style: TextStyle(
                        color: Color.fromARGB(179, 255, 255, 255),
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      )),
                  const Text("let's Get Exercise",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 150,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return itemBuilder(context, index);
                      },
                    ),
                  ),
                  const SizedBox(height: 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn,
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: _currentPage == index
                                  ? [
                                      Color(0xFFFFA992),
                                      Color(0xFFFD0D92),
                                    ]
                                  : [
                                      Color(0xFFFFA992).withAlpha(76),
                                      Color(0xFFFD0D92).withAlpha(76),
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 35),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1B32),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(0xFF3A3B5C),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My Plan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '0%',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          'For Today',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        LinearProgressIndicator(
                          value: 0,
                          backgroundColor: Color(0xFF2A2C4F),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF8B78FF)),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '0/7 Complete',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    'Fitness Exercises & Activities',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: SizedBox(
                      height: 130,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: exercices
                              .map((exercise) => Padding(
                                    padding: const EdgeInsets.only(right: 30),
                                    child: exerciceType(
                                      title: exercise.title,
                                      imageName: exercise.imageUrl,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                      child: GradientComponent.gradientButton(
                          text: 'Start',
                          maxWidth: 100,
                          maxHeight: 35,
                          onPressed: () {
                            navigateToPlanningPage(context, FocusScreen());
                          })),
                  const SizedBox(height: 20),
                  latestActivity(latestActivities, context, true),
                  const SizedBox(height: 75),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'images/welcome${index + 1}.png',
        ),
      ),
    );
  }

  Widget exerciceType({
    required String title,
    required String imageName,
  }) {
    return GestureDetector(
        child: Container(
      width: 115,
      height: 112,
      decoration: BoxDecoration(
        color: Color(0xFF2E2F55),
        border: Border.all(color: Color(0xFFE8ACFF).withAlpha(51), width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              title,
              style: titleTextStyle(color: Color(0xFFE9E3E4), fontSize: 15),
            ),
            SizedBox(height: 10),
            Image.asset(
              imageName,
              width: 51,
              height: 51,
            ),
          ],
        ),
      ),
    ));
  }

  Widget _drawerItem(String title, IconData icon, VoidCallback onPressed) {
    return ListTile(
      leading: Icon(icon, color: Colors.white.withAlpha(203)),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white.withAlpha(229),
          fontSize: 16,
        ),
      ),
      onTap: onPressed,
    );
  }
}
