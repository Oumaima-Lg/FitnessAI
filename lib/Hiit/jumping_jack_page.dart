import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../textStyle/textstyle.dart';

class JumpingJackPage extends StatelessWidget {
  const JumpingJackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          'Jumping Jack',
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
                  'images/png/jumping_jacks.png',
                ),
                SizedBox(height: 20),
                Text(
                  'Jumping jacks are vertical jumps performed on the spot with arms and legs spread apart. This exercise gets its name from the articulated puppet, a wooden toy where the arms raise and the legs spread when you pull the string 😉.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Technique'),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stand with your feet hip-width apart, hands by your sides:',
                      style: normalTextStyle(),
                    ),
                    SizedBox(height: 8),
                    ...[
                      'Jump vertically, spreading your feet and raising your arms to the sides above your head.',
                      'Touch your hands together.',
                      'Keep your body straight.',
                      'Jump again, returning to the starting position, arms by your sides and feet together.',
                      'Repeat.',
                    ].map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            ' •  $item',
                            style: normalTextStyle(),
                          ),
                        )),
                    SizedBox(height: 12),
                    Text(
                      'Point to watch: don\'t tuck your head into your shoulders (keep your shoulders away from your ears).',
                      style: normalTextStyle(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Muscles Worked'),
                SizedBox(height: 20),
                Image(
                 image: AssetImage('images/png/Jumping_jacks_muscles.png'),
                ),
                Text(
                  'The main muscles worked during jumping jacks are the leg muscles: quadriceps (muscles in the front of the thighs), glutes, and hip flexors.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Demonstration'),
                Image(
                 image: AssetImage('images/gif/jumping_jacks.gif'),
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