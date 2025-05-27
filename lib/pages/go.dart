import 'dart:async';
import 'package:fitness/components/personalized_widget.dart';
import 'package:fitness/pages/entrainements/congratulation.dart';
import 'package:flutter/material.dart';
import '../components/textStyle/textstyle.dart';
import 'package:fitness/models/activity.dart';

class GoPage extends StatefulWidget {
  final Activity activity;
  final String titleExercice;
  final String quote;
  const GoPage(
      {super.key,
      required this.activity,
      required this.titleExercice,
      required this.quote});
  @override
  State<GoPage> createState() => _GoPageState();
}

class _GoPageState extends State<GoPage> {
  Duration _selectedDuration = Duration(hours: 0, minutes: 0, seconds: 0);
  bool start = false;
  int seconds = 0;
  Timer? timer;

  void startTime() {
    setState(() {
      start = !start;
    });

    if (start) {
      timer = Timer.periodic(Duration(seconds: 1), (t) {
        setState(() {
          seconds++;

          if (seconds >= _selectedDuration.inSeconds) {
            timer?.cancel();
            start = false;

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
          }
        });
      });
    } else {
      timer?.cancel();
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
                        image: NetworkImage(
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
}
