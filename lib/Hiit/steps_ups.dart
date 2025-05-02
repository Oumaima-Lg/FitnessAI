import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../textStyle/textstyle.dart';

class StepsUps extends StatelessWidget {
  const StepsUps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          'Steps UPS',
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
                  'images/png/montee_sur_chaise.png',
                ),
                SizedBox(height: 20),
                Text(
                  'Step-ups, whether on a chair, bench, or box, are exercises that particularly target the glutes and thighs.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Technique'),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Standing facing a chair or bench, feet shoulder-width apart, hands by your sides:',
                      style: normalTextStyle(),
                    ),
                    SizedBox(height: 8),
                    ...[
                      'Place one foot flat on the support;\n',
                      'Shift your weight forward by pushing only with your bent leg;\n',
                      'Raise the knee of the opposite leg high towards the ceiling, squeezing your glute (without swinging);\n',
                      'Shift your weight back by placing the raised leg directly on the floor;\n',
                      'Repeat the movement during the work period;\n',
                      'Switch sides during the next round;\n',
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
                      'Notes :',
                      style: normalTextStyle(),
                    ),
                    SizedBox(height: 8),
                    ...[
                      'You can alternate legs or perform consecutive repetitions (in this case, keep your foot on the support);\n',
                      'Your foot should be fully on the support to push through the heel;\n',
                      'Engage your abs and keep your back straight;\n',
                      'The higher the support, the more intense and difficult the exercise will be. Always maintain a straight back, if your lower back rounds, your support is too high.'
                    ]
                    .map((item) => Padding(
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
                 image: AssetImage('images/png/montees_sur_chaise_muscle.png'),
                ),
                Text(
                  'The main muscles worked during step-ups are the glutes and quadriceps.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Demonstration'),
                Image(
                 image: AssetImage('images/gif/montee_sur_chaise.gif'),
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