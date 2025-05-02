import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../textStyle/textstyle.dart';

class HighKnees extends StatelessWidget {
  const HighKnees({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          'High Knees',
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
                  'images/png/leves_genoux.png',
                ),
                SizedBox(height: 20),
                Text(
                  'The knee raises or knee lifts exercise involves running in place; it is a very effective cardio exercise that will also work the legs and abs.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 10),
                Text(
                  'If you don\'t have space to run or the weather doesn\'t allow you to train outside, it can be a good substitute for sprints.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Technique'),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stand with your feet hip-width apart, arms by your sides:',
                      style: normalTextStyle(),
                    ),
                    SizedBox(height: 8),
                    ...[
                      'Start running in place by lifting your knees high;\n',
                      'Run on the balls of your feet;\n',
                      'Swing the opposite arm to the raised knee to maintain balance;\n',
                      'Look straight ahead;\n',
                      'Keep your back straight and engage your core.',
                    ]
                    .map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            ' •  $item',
                            style: normalTextStyle(),
                          ),
                        )),
                    SizedBox(height: 12),
                    Text(
                      'Note: Lift your knees with your core, not by leaning backward.',
                      style: normalTextStyle(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Things not to do'),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...[
                      'Do not lean forward to raise your knees (you might lose balance).\n',
                      'Do not lean backward to raise your knees (you could arch your back and get injured).\n',
                      'Do not look down.',
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
                 image: AssetImage('images/png/leve_genoux_muscles.png'),
                ),
                Text(
                  'The main muscles worked during knee lifts / running in place are the quadriceps, calves, and abdominals.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Demonstration'),
                Image(
                 image: AssetImage('images/gif/levee_genoux.gif'),
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