import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../textStyle/textstyle.dart';

class Plank extends StatelessWidget {
  const Plank({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          'Plank',
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
                  'images/png/planches.png',
                ),
                SizedBox(height: 20),
                Text(
                  'The plank is a classic core exercise performed on the forearms.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Technique'),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...[
                        'Lie face down, supporting your weight on your forearms and toes;\n',
                        'You can place your hands flat on the floor or interlace them as you prefer;\n',
                        'Position your elbows under your shoulders;\n',
                        'Keep your body straight from head to toe (aligning ankles/knees/hips and shoulders);\n',
                        'Contract your abs to maintain a straight body and prevent arching (don\'t let your hips sag towards the ground);\n',
                        'Contract your glutes and thighs to maintain a straight body and prevent lifting your hips (don\'t let your hips rise);\n',
                        'Look at the floor to avoid creating tension in your neck and to keep alignment with your back.',
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
                      'Contract your glutes and thighs.\n',
                      'Do not arch your back.\n',
                      'Do not lower your hips towards the ground (do not raise them in an inverted "V" shape either).',
                    ].map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            ' •  $item',
                            style: normalTextStyle(),
                          ),
                        )),
                    SizedBox(height: 12),
                    Text(
                      'Tip: Breathe normally without holding your breath.',
                      style: normalTextStyle(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Muscles Worked'),
                SizedBox(height: 20),
                Image(
                 image: AssetImage('images/png/planche_muscles.png'),
                ),
                Text(
                  'The primary muscle worked in the plank is the rectus abdominis (the abdominal muscles). The glutes and obliques are worked secondarily.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Demonstration'),
                Image(
                 image: AssetImage('images/gif/planche.gif'),
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