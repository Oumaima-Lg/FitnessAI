import 'dart:async';
import 'package:fitness/components/personalized_widget.dart';
import 'package:flutter/material.dart';
import '../components/textStyle/textstyle.dart';
import 'package:fitness/models/activity.dart';

class GoPage extends StatefulWidget {
  final Activity activity;
  final bool image;
  const GoPage({super.key, required this.activity, this.image = true});
  @override
  State<GoPage> createState() => _GoPageState();
}

class _GoPageState extends State<GoPage> {
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
    final minutes =
        (seconds ~/ 60).toString().padLeft(2, '0'); // hadi katzid 0 flbdya
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
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
                        image: widget.image
                            ? AssetImage(widget
                                .activity.videoDemonstartionUrl!) // Asset local
                            : NetworkImage(
                                    widget.activity.videoDemonstartionUrl!)
                                as ImageProvider, // Image réseau
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
          GradientButton(
            title: '',
            icon: start ? Icons.pause : Icons.play_arrow,
            maxWidth: 103,
            maxHeight: 42,
            onPressed: startTime,
          ),
          SizedBox(height: 10),
          Icon(
            Icons.watch_later_outlined,
            color: Color(0xFF983BCB),
            size: 54,
          ),
          SizedBox(height: 10),
          Stack(
            children: [
              Text(
                formattedTime,
                style: titleTextStyle(fontSize: 36, fontWeight: FontWeight.w600)
                    .copyWith(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3
                    ..color = Colors.black,
                ),
              ),
              Text(
                formattedTime,
                style:
                    titleTextStyle(fontSize: 36, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
