import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../textStyle/textstyle.dart';

class ForwardLunges extends StatelessWidget {
  const ForwardLunges({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          'Forward Lunges',
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
                  'images/png/fentes.png',
                ),
                SizedBox(height: 20),
                Text(
                  'Lunges (forward or backward) are effective exercises that target the thighs and glutes.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Technique'),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stand with your feet hip-width apart, hands on your hips (you can place your hands on your waist or let them hang by your sides): ',
                      style: normalTextStyle(),
                    ),
                    SizedBox(height: 8),
                    ...[
                      'Take a big step forward while keeping your back straight (your other foot stays behind);\n',
                      'Lower your body until your back knee nearly touches the floor (control the descent to avoid hitting your knee);\n',
                      'The shin of your front leg should be perpendicular to the floor, with your knee above your foot (don’t let the knee go past your toes);\n',
                      'Return to the starting position and alternate the movement on the other side.',
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
                      'Notes: Keep your torso upright and engage your abs; maintain your feet hip-width apart during the movement to keep your balance; look straight ahead (not at the floor).',
                      style: normalTextStyle(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Muscles Worked'),
                SizedBox(height: 20),
                Image(
                 image: AssetImage('images/png/fents_muscle.png'),
                ),
                Text(
                  'The main muscles worked during lunges are the quadriceps (the muscles at the front of the thigh) and the glutes.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Demonstration'),
                Image(
                 image: AssetImage('images/gif/fents.gif'),
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