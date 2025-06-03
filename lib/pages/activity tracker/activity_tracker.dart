import 'dart:async';
import 'package:fitness/components/personalized_widget.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:fitness/services/fire_base_service.dart';
import 'package:fitness/models/latest_activity.dart';
import 'package:flutter/material.dart';
import 'package:fitness/services/fonctions.dart';

class ActivityTracker extends StatefulWidget {
  const ActivityTracker({super.key});

  @override
  State<ActivityTracker> createState() => _ActivityTrackerState();
}

class _ActivityTrackerState extends State<ActivityTracker> {
  List<LatestActivity> latestActivities = [];
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    loadActivities();

    // Mettre à jour l'affichage toutes les 60 secondes
    _refreshTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {}); // Rebuild pour mettre à jour les "x min ago"
    });
  }

  void loadActivities() async {
    final activities = await loadUserLatestActivities();
    setState(() {
      latestActivities = activities;
    });
  }

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
            child: latestActivity(latestActivities, context, false, timeAgo),
          ),
        ),
      ),
    );
  }
}
