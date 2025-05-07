import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GoPage extends StatefulWidget {
  const GoPage({super.key});

  @override
  State<GoPage> createState() => _GoPageState();
}

class _GoPageState extends State<GoPage> with SingleTickerProviderStateMixin {
  bool isRunning = false;
  int time = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  void toggleTimer() {
    setState(() {
      if (isRunning) {
        timer?.cancel();
      } else {
        timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            time++;
          });
        });
      }
      isRunning = !isRunning;
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
        ),
        title: Text('Titre de la page',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        width: double.infinity,
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
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Stack(
                children: [
                  GradientComponent.gradientCircle(
                    0,
                    35,
                    Color.fromARGB(255, 255, 2, 225),
                    Color(0xFFFFB19A),
                  ),
                  GradientComponent.gradientCircle(
                    MediaQuery.of(context).size.width * 0.55,
                    35,
                    Color(0xFF23253C),
                    Color.fromARGB(255, 7, 6, 54),
                  ),
                  GradientComponent.gradientCircle(
                    22,
                    MediaQuery.of(context).size.height * 0.4,
                    Color(0xFF23253C),
                    Color.fromARGB(255, 7, 6, 54),
                  ),
                  GradientComponent.gradientCircle(
                    MediaQuery.of(context).size.width * 0.55,
                    MediaQuery.of(context).size.height * 0.4,
                    Color(0xFFE8ACFF),
                    Color(0xFF7800FF),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 75, left: 35, right: 35),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFE8ACFF).withAlpha(51),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(41),
                      color: const Color.fromARGB(255, 203, 200, 200),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60,
            ),
            GradientComponent.gradientIconButton(
              isRunning ? Icons.pause : Icons.play_arrow,
              Color(0xFFE8ACFF),
              Color(0xFF7800FF),
              80,
              30,
              onPressed: toggleTimer,
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [Color(0xFFE8ACFF), Color(0xFF7800FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: Icon(
                        Icons.history,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      formatTime(time),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GradientComponent {
  static ElevatedButton gradientButton(
      String text, double maxWidth, double maxHeight) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: () {},
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4023D7), Color(0xFF983BCB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Widget gradientCircle(
      double left, double top, Color color1, Color color2) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  static Widget gradientIconButton(
      IconData icon, Color color1, Color color2, double width, double height,
      {VoidCallback? onPressed}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: MaterialButton(
        onPressed: onPressed ?? () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
