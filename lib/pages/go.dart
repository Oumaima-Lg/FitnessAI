import 'dart:async';
import 'package:fitness/components/personalized_widget.dart';
import 'package:fitness/models/planning.dart';
import 'package:fitness/pages/entrainements/congratulation.dart';
import 'package:fitness/services/planning_service.dart';
import 'package:fitness/services/fire_base_service.dart';
import 'package:flutter/material.dart';
import '../components/textStyle/textstyle.dart';
import 'package:fitness/models/activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:fitness/pages/statistics/calorieCalculator.dart';

class GoPage extends StatefulWidget {
  final Activity activity;
  final String titleExercice;
  final String quote;
  final bool isGym;
  const GoPage(
      {super.key,
      required this.activity,
      required this.titleExercice,
      required this.quote,
      required this.isGym});
  @override
  State<GoPage> createState() => _GoPageState();
}

class _GoPageState extends State<GoPage> {
  Duration _selectedDuration = Duration(hours: 0, minutes: 0, seconds: 0);
  bool start = false;
  int seconds = 0;
  Timer? timer;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  Future<void> _saveWorkoutData() async {
    if (_user == null) return;

    final today = DateTime.now();
    final dateKey = DateFormat('yyyy-MM-dd').format(today);

    // Create workout data without serverTimestamp
    final workoutData = {
      'activity_id': widget.activity.id,
      'duration': seconds,
      'timestamp': DateTime.now().toIso8601String(),
      'activity_name': widget.activity.title,
      'target_muscle': widget.activity.target,
    };

    // Sauvegarder le workout
    final docRef = _firestore
        .collection('user_workouts')
        .doc(_user.uid)
        .collection('daily_sessions')
        .doc(dateKey);

    await docRef.set({
      'workouts': FieldValue.arrayUnion([workoutData]),
      'user_id': _user.uid,
      'date': dateKey,
      'last_update': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Calculer et sauvegarder les calories
    final calories =
        await CalorieCalculator.calculateTotalCaloriesBurned(_user.uid);

    print('\n=== Workout Summary ===');
    print('Activity: ${widget.activity.title}');
    print('Duration: $seconds seconds');
    print('Calories burned this session: ${calories.toStringAsFixed(1)} Kcal');
    print('Total calories burned today: ${calories.toStringAsFixed(1)} Kcal');
    print('=====================\n');

    // Ajouter ces informations dans le message de félicitation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Congratulation(
          imageUrl: 'congratulation_${widget.titleExercice}',
          title: 'Congratulations, You Have Finished Your Workout!',
          description:
              '${widget.quote}\n\nCalories burned: ${calories.toStringAsFixed(1)} Kcal',
        ),
      ),
    );
  }

  void startTime() {
    setState(() {
      start = !start;
    });

    if (start) {
      timer = Timer.periodic(Duration(seconds: 1), (t) async {
        setState(() {
          seconds++;

          // if (seconds >= _selectedDuration.inSeconds) {
          //   timer?.cancel();
          //   start = false;
          //   _saveWorkoutData().then((_) {
          //     // Navigate to Congratulation page after saving workout data
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => Congratulation(
          //         imageUrl: 'congratulation_${widget.titleExercice}',
          //         title: 'Congratulations, You Have Finished Your Workout !',
          //         description: widget.quote,
          //                ),
          //       ),
          //     );
          //   });
          // }
        });

        // Then handle the completion logic asynchronously outside of setState

        // Perform async operations after setState

        if (seconds >= _selectedDuration.inSeconds) {
          timer?.cancel();
          start = false;

          await PlanningService.markActivityAsCompleted(
              widget.titleExercice, widget.activity.title);

          try {
            await saveLatestActivity(
              title: widget.isGym
                  ? "Gym - ${widget.activity.title}"
                  : widget.activity.title,
              icon: widget.isGym
                  ? "images/icons/Gym.png"
                  : widget.activity.iconUrl,
            );
          } catch (e) {
            print('Erreur sauvegarde activité : $e');
          }
          _saveWorkoutData().then((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Congratulation(
                  imageUrl: 'congratulation_${widget.titleExercice}',
                  title: 'Congratulations, You Have Finished Your Workout !',
                  description: widget.quote,
                ),
              ),
            );
          });
        }
      });
    } else {
      timer?.cancel();
      if (seconds > 0) _saveWorkoutData();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String get formattedTime {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: Appbar(activity: widget.activity),
      body: Column(
        spacing: 10,
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 1.95,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(23),
                      color: Color(0xFFF4E3DF),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(23),
                      child: Image(
                        image: widget.isGym
                            ? NetworkImage(widget.activity.imageUrl!)
                            : AssetImage(
                                widget.activity.videoDemonstartionUrl!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error_outline, color: Colors.red),
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DurationPicker(
            maxHours: 23,
            onDurationChanged: (duration) {
              setState(() {
                _selectedDuration = duration;
              });
            },
          ),
          GradientButton(
            title: '',
            icon: start ? Icons.pause : Icons.play_arrow,
            maxWidth: 103,
            maxHeight: 40,
            onPressed: startTime,
          ),
          Stack(
            children: [
              Text(
                formattedTime,
                style: titleTextStyle(fontSize: 36, fontWeight: FontWeight.w600)
                    .copyWith(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.grey.shade500,
                ),
              ),
              Text(
                formattedTime,
                style: titleTextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E2F55)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> getWorkoutsByDate(DateTime date) async {
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    final doc = await _firestore
        .collection('user_workouts')
        .doc(_user!.uid)
        .collection('daily_sessions')
        .doc(dateKey)
        .get();

    return doc.data() ?? {};
  }
}
