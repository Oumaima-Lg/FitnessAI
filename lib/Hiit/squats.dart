import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../textStyle/textstyle.dart';

class Squats extends StatelessWidget {
  const Squats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          'Squats',
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
                  'images/png/squats.png',
                ),
                SizedBox(height: 20),
                Text(
                  'A classic in bodybuilding, squats target the entire lower body.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Technique'),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...[ 
                      'Stand up straight with your legs fully extended, feet shoulder-width apart, with your toes slightly turned outward;\n',
                      'Look straight ahead;\n',
                      'Bend your knees by "breaking" the vertical line of your body at the knees and hips;\n',
                      'Emphasize the lumbar curve by contracting your abs and pushing your hips back to keep your lower back flat;\n',
                      'Think "lower the hips" rather than "lower the torso" while controlling the descent;\n',
                      'Keep your knees slightly outward, aligned with your thighs and feet (your knees should be above and in the middle of your feet);\n',
                      'Place your weight on your heels (you should be able to wiggle your toes);\n',
                      'Lift your arms in front of you as you lower (this will help with balance and overall positioning);\n',
                      'At the lowest position, think about puffing out your chest;\n',
                      'Lower your hips below knee level (as long as you can keep your back flat); your thighs should be at least parallel to the floor;\n',
                      'Stand back up to the starting position, bringing your arms alongside your body (your back, hips, and legs should be aligned and your legs extended);\n',
                      'Contract your glutes at the top position to align your hips with your back and legs.',
                    ]
                    .map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            ' •  $item',
                            style: normalTextStyle(),
                          ),
                        )),
                    SizedBox(height: 12),
                  ],
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Things not to do'),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...[ 
                      'Do not look down;\n',
                      'Do not raise your shoulders;\n',
                      'Do not lift your heels off the floor;\n',
                      'Do not spread or bring your knees inward.',
                    ]
                    .map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            ' •  $item',
                            style: normalTextStyle(),
                          ),
                        )),
                    SizedBox(height: 12),
                  ],
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Muscles Worked'),
                SizedBox(height: 20),
                Image(
                 image: AssetImage('images/png/squats_muscles.png'),
                ),
                Text(
                  'The main muscles worked during squats are the quadriceps (muscles at the front of the thigh) and secondarily the glutes, hamstrings (muscles at the back of the thigh).',
                   style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Demonstration'),
                Image(
                 image: AssetImage('images/gif/squats.gif'),
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