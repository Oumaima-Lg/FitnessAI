import 'package:flutter/material.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:fitness/pages/statistics/sleepAnalytics.dart';
import 'package:fitness/pages/statistics/TimePickerField.dart';
import 'package:fitness/models/userStats.dart';
import 'package:fitness/firebase_service.dart'; 
import 'package:fitness/components/gradient.dart';
import 'package:firebase_auth/firebase_auth.dart';

String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

// Import your Firebase service
class SleepLog extends StatefulWidget {
  final UserStats stats;

  SleepLog({super.key, UserStats? stats})
      : stats = stats ?? UserStats();

  @override
  State<SleepLog> createState() => _SleepLogState();
}

class _SleepLogState extends State<SleepLog> {
  TimeOfDay sleepTime = TimeOfDay(hour: 22, minute: 0);
  TimeOfDay wakeTime = TimeOfDay(hour: 7, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          'Sleep Log',  // Changed from 'Statistics' to be more specific
          style: titleTextStyle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20), // Added top spacing
                Text(
                  'Please log your sleep and wake-up time.',
                  style: titleTextStyle(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40), // Spacing after title
                
                // Sleep Time Section
                _buildTimeSection(
                  icon: 'images/statistics/night.png',
                  label: 'Sleep Time',
                  time: sleepTime,
                  onTimeChanged: (newTime) {
                    setState(() => sleepTime = newTime);
                    print("Sleep time updated: ${newTime.format(context)}");
                  },
                ),
                
                SizedBox(height: 30), // Spacing between sections
                
                // Wake Time Section
                _buildTimeSection(
                  icon: 'images/statistics/day.png',
                  label: 'Wake Time',
                  time: wakeTime,
                  onTimeChanged: (newTime) {
                    setState(() => wakeTime = newTime);
                    print("Wake time updated: ${newTime.format(context)}");
                  },
                ),
                
                SizedBox(height: 40), // Bottom spacing
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6B5DAD),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  _updateSleepStats(); // met à jour stats.sleep
                  await saveDailyStats(widget.stats); // appelle ta fonction Firebase
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Données de sommeil sauvegardées')),
                  );
                },
                child: Text("Enregistrer", style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 50), // Spacing before the button
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: GradientComponent.gradientButton(
                  text: 'See your sleep analytics',
                  maxWidth: 315,
                  maxHeight: 50,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SleepStatsWidget()),
                  ),
                ),
              ),  
           ],
            
            ),
          ),
        ),
      ),
    );
  }

  void _updateSleepStats() {
    Duration sleepDuration = _calculateSleepDuration();
    widget.stats.sleep = sleepDuration;
  }

  Widget _buildTimeSection({
    required String icon,
    required String label,
    required TimeOfDay time,
    required Function(TimeOfDay) onTimeChanged,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFF2E2B5A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFF6B5DAD), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                icon,
                width: 20,
                height: 20,
              ),
              SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12), // Reduced spacing
        CustomTimeInputPicker(
          initialTime: time,
          onTimeChanged: (newTime) {
            onTimeChanged(newTime);
            _updateSleepStats(); // Update stats whenever time changes
          },
        ),
      ],
      
    );
  }
  
  

  Duration _calculateSleepDuration() {
    DateTime sleepDateTime = DateTime(2024, 1, 1, sleepTime.hour, sleepTime.minute);
    DateTime wakeDateTime = DateTime(2024, 1, 1, wakeTime.hour, wakeTime.minute);
    
    // If wake time is earlier than sleep time, it means wake time is next day
    if (wakeDateTime.isBefore(sleepDateTime)) {
      wakeDateTime = wakeDateTime.add(Duration(days: 1));
    }
    
    return wakeDateTime.difference(sleepDateTime);
  }
}