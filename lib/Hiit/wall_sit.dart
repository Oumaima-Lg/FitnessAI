import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../textStyle/textstyle.dart';

class WallSit extends StatelessWidget {
  const WallSit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          'Wall Sit',
          style: titleTextStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'images/png/wall_sits.png',
                ),
                SizedBox(height: 20),
                Text(
                  'The chair exercise is an isometric exercise that primarily works the thighs.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Technique'),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Standing with your back against a wall:',
                      style: normalTextStyle(),
                    ),
                    SizedBox(height: 8),
                    ...[
                      'Press your back against the wall, feet flat on the ground in front of you;',
                      'Lower your body by sliding your back down the wall until you reach an intermediate squat position;',
                      'Your thighs should be parallel to the ground and your shins perpendicular to the floor;',
                      'Your hips should be aligned with your thighs and knees with your ankles;',
                      'Hold the position for the duration of the exercise.',
                    ].map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            ' •  $item',
                            style: normalTextStyle(),
                          ),
                        )),
                    SizedBox(height: 12),
                    Text(
                      'Notes :',
                      style: normalTextStyle(),
                    ),
                    SizedBox(height: 8),
                    ...[
                      'If your shins are not perpendicular to the ground, your feet are too close or too far from the wall;',
                      'Do not arch your lower back;',
                      'Keep your lower back flat against the wall.'
                    ].map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            ' •  $item',
                            style: normalTextStyle(),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Muscles Worked'),
                SizedBox(height: 20),
                Image(
                 image: AssetImage('images/png/wall_sits_muscles.png'),
                ),
                SizedBox(height: 20),
                Text(
                  'The main muscles worked for the wall sit exercise are the quadriceps, as well as the glutes and hamstrings (muscles at the back of the thigh).',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Demonstration'),
                Image(
                 image: AssetImage('images/gif/wall_sits.gif'),
                ),
                SizedBox(height: 20),
                GradientButton(
                  title: 'Go',
                  icon: Icons.arrow_forward,
                  width: 120,
                  onPressed: () {
                    print('Go pressed');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}