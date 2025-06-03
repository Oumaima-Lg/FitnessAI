import 'package:flutter/material.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:fitness/models/userStats.dart';
import 'package:fitness/components/gradient.dart';
import 'package:fitness/components/workoutButton.dart';
import 'package:fitness/pages/statistics/caloriesBurned.dart';
import 'package:fitness/pages/statistics/steps.dart';
import 'package:fitness/pages/statistics/TrainingTime.dart';
import 'package:fitness/pages/statistics/sleepLog.dart';
import 'package:fitness/pages/statistics/waterTracker.dart';
import 'package:fitness/firebase_service.dart'; // Import your Firebase service
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/pages/go.dart';
import 'package:fitness/pages/statistics/StepsCalculator.dart';

class Statistics extends StatefulWidget {
  final UserStats stats;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  
  Statistics({Key? key, required this.stats}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
 
}
class _StatisticsState extends State<Statistics> {
  final StepCounterService _stepCounterService = StepCounterService();
 
  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _stepCounterService.onStepsUpdated = (steps) {
      setState(() {
        widget.stats.steps = steps;
      });
    };
      _stepCounterService.onError = (error) {
            print("Erreur podomètre : $error");
          };

          _stepCounterService.start();
        }
  Future<void> _loadInitialData() async {
    // Charger d'abord les stats générales
    final today = DateTime.now().toIso8601String().split('T')[0];
    final stats = await getTodayStats();
    
    if (mounted && stats != null) {
      setState(() {
        widget.stats.sleep = stats.sleep;
        widget.stats.calories = stats.calories;
        widget.stats.steps = stats.steps;
        widget.stats.water = stats.water;
        widget.stats.heartRate = stats.heartRate;
        // Ne pas écraser trainingTime ici
      });
    }

    // Ensuite charger le training time spécifiquement
    final int todayTotal = await getDailyWorkoutTotal(DateTime.now());
    if (mounted) {
      setState(() {
        widget.stats.trainingTime = todayTotal;
        print("Training time updated: $todayTotal seconds"); // Debug log
      });
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2F55),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'images/Ellipse Profil.png',
              fit: BoxFit.cover,
              height: 290,
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Statistics',
                        style: titleTextStyle(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GradientComponent.gradientText(
                      text: "For Today",
                      
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      Stack(
                        children: [
                          
                          _buildCircleCard("Training Time",
                              widget.stats.trainingTime.toString(), ""),
                        ],
                      ),
                      Stack(
                        children: [
                          _buildCircleCard("Walk", widget.stats.steps.toString(),
                              "   Steps \n Completed"),
                        ],
                      ),
                      
                      _buildInfoCard("Calories", "${widget.stats.calories}\n  Kcal"),
                      _buildInfoCard(
                        "Sleep",
                        "${((widget.stats.sleep?.inMinutes ?? 0) / 60).toStringAsFixed(1)} \n  hours",
                      ),
                      
                      _buildImageCard(
                          "Water",
                          "images/statistics/water_img.png",
                          "${widget.stats.water} \n glass"),
                      _buildImageCard(
                          "Heart",
                          "images/statistics/heart_img.png",
                          "${widget.stats.heartRate} \n  bpm"),
                    ],
                  ),
                  const SizedBox(height: 30),
                  WorkoutElevatedButton(
                    iconPath: 'images/statistics/training.png',
                    title: 'Training Time',
                    subtitle: 'You started a new workout session.\nKeep it up!',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Training(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  WorkoutElevatedButton(
                    iconPath: 'images/statistics/steps.png',
                    title: 'Steps',
                    subtitle:
                        'Tap to view your daily and monthly step count trends.',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Steps(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  WorkoutElevatedButton(
                    iconPath: 'images/statistics/calories.png',
                    title: 'Calories Burned',
                    subtitle:
                        'Great job! You`ve already burned a good amount of calories today.',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Calorie(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  WorkoutElevatedButton(
                    iconPath: 'images/statistics/cup.png',
                    title: 'Water Tracker',
                    subtitle:
                        'Don`t forget to stay hydrated throughout the day.',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WaterTracker(stats: widget.stats),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  WorkoutElevatedButton(
                    iconPath: 'images/statistics/sleep.png',
                    title: 'Sleep Log',
                    subtitle:
                        'Log your sleep details to analyze your sleep patterns.',
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SleepLog(stats: widget.stats),
                      ),
                    );

                  },

                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Modifier _buildCircleCard pour afficher correctement les minutes
  Widget _buildCircleCard(String title, String value, String text) {
    String displayValue = value;
    if (title == "Training Time") {
      int timeInSeconds = int.tryParse(value) ?? 0;
      int minutes = (timeInSeconds / 60).round();
      displayValue = "$minutes";
      print("Displaying training time: $minutes minutes"); // Debug log
    }
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                color: Color(0xFFE3DBDB),
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins'),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(109, 109),
                  painter: EllipticalProgressPainter(
                    progress: 0.6,
                    strokeWidth: 10,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    progressColor: const Color(0xFF00F2FE),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (title == "Training Time")
                      const Icon(
                        Icons.timer_outlined,
                        size: 24,
                        color: Color(0xFF5DCCFC),
                      ),
                    Text(
                      value,
                      style: const TextStyle(
                          fontSize: 25,
                          color: Color(0xFF5DCCFC),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins'),
                    ),
                    if (text.isNotEmpty)
                      Text(text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFE3DBDB),
                            fontSize: 12,
                          )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    // Split the value into number and unit
    final parts = value.split('\n');
    print("UID actuel: ${widget.uid}"); 
    return Container(
      width: 154,
      height: 157,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                color: Color(0xFFE3DBDB),
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins'),
          ),
          Expanded(
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: parts[0],
                      style: const TextStyle(
                          fontSize: 25,
                          color: Color(0xFF5DCCFC),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins'),
                    ),
                    TextSpan(
                      text: parts[1],
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFE3DBDB),
                          fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String title, String imagePath, String value) {
    // Split the value into number and unit parts
    final parts = value.split('\n');
    return Container(
      width: 154,
      height: 231,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 12,
            top: 12,
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFE3DBDB),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins'),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 12,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: parts[0],
                    style: TextStyle(
                        fontSize: 25,
                        color: title == "Heart"
                            ? const Color(0xFF00F2FE)
                            : const Color(0xFFE3DBDB),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins'),
                  ),
                  TextSpan(
                    text: parts.length > 1 ? parts[1] : "",
                    style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFE3DBDB),
                        fontFamily: 'Poppins'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EllipticalProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  EllipticalProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawOval(rect, backgroundPaint);

    final progressRect = rect;
    canvas.drawArc(
      progressRect,
      -90 * (3.14159 / 180), // Start from top
      progress * 2 * 3.14159, // Convert progress to radians
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
