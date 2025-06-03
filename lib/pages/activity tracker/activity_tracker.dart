import 'package:fitness/components/personalized_widget.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:fitness/services/latest_activity.dart';
import 'package:fitness/models/latest_activity.dart';
import 'package:flutter/material.dart';

// final manager = LatestActivityManager();
// manager.addActivity(LatestActivity(
//   nameActivity: 'Nouvelle activité',
//   imageUrl: 'assets/images/activity.jpg',
//   createdAt: DateTime.now().millisecondsSinceEpoch,
// ));
// await manager.saveActivities();

class ActivityTracker extends StatefulWidget {
  const ActivityTracker({super.key});

  @override
  State<ActivityTracker> createState() => _ActivityTrackerState();
}

class _ActivityTrackerState extends State<ActivityTracker> {
  // final activityManager = LatestActivityManager();
  List<LatestActivity> latestActivities = [];

  @override
  void initState() {
    super.initState();
    // loadDataLatestActivities();
  }

  // void loadDataLatestActivities() async {
  //   await activityManager.loadActivities();
  //   setState(() {
  //     latestActivities = activityManager.activities;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'Activity Tracker',
              style: titleTextStyle(),
            ),
          ),
          body: SingleChildScrollView(
            child: latestActivity(latestActivities, context, false),
          ),
        ),
      ),
    );
  }
}
