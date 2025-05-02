import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../textStyle/textstyle.dart';

class TPushUps extends StatelessWidget {
  const TPushUps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          'T-Push-Ups',
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
                  'images/png/pompes_T.png',
                ),
                SizedBox(height: 20),
                Text(
                  'T-push-ups are variations of push-ups that combine a full push-up with a side plank. This exercise strengthens the abdominals in addition to the triceps, shoulders, and chest.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Technique'),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'In the top push-up position, with your hands under your shoulders, arms extended, and body engaged:',
                      style: normalTextStyle(),
                    ),
                    SizedBox(height: 8),
                    ...[
                      'Pivot your body to one side and raise your arm towards the ceiling to form a "T" (arms extended perpendicular to your engaged body);\n',
                      'You are in a side plank position with both arms extended and aligned;\n',
                      'Return to the starting position, arms extended;\n',
                      'Perform a full push-up.',
                      'Repeat',
                    ].map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            ' •  $item',
                            style: normalTextStyle(),
                          ),
                        )),
                    SizedBox(height: 12),
                    Text(
                      'Notes: ',
                      style: normalTextStyle(),
                    ),
                    SizedBox(height: 8),
                    ...[
                      'Engage your abs, thighs, and glutes to keep your body tight and aligned (your hips should not drop towards the floor during the push-up or side plank).\n',
                      'Your hips, chest, shoulders, and feet rotate together as a single unit.\n',
                      'Control the rotation movement to avoid going too far and exceeding the side plank position (perpendicular to the floor in the frontal plane).\n',
                      'Keep your shoulders away from your ears and squeeze your shoulder blades.\n',
                      'The thumb of your raised hand should be aligned with your legs.\n',
                    ].map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            ' •  $item',
                            style: normalTextStyle(),
                          ),
                        )),
                    SizedBox(height: 12),
                    Text(
                      'Tip: To work on your balance more, look at your raised hand.',
                      style: normalTextStyle(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Muscles Worked'),
                SizedBox(height: 20),
                Image(
                 image: AssetImage('images/png/pompes_T_muscles.png'),
                ),
                Text(
                  'The main muscles worked in T-push-ups are the pectorals, deltoids, triceps, and abdominals (obliques and rectus abdominis).',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Demonstration'),
                Image(
                 image: AssetImage('images/gif/pompes_T.gif'),
                ),
                Text(
                  'Then alternate the same movement to the other side.',
                  style: normalTextStyle(),
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