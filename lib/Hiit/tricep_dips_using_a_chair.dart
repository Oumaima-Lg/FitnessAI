import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../textStyle/textstyle.dart';

class TricepDipsUsingAChair extends StatelessWidget {
  const TricepDipsUsingAChair({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          'Tricep Dips Using a Chair',
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
                  'images/png/dips_sur_chaise.png',
                ),
                SizedBox(height: 20),
                Text(
                  'Chair dips or bench dips are an exercise that targets the triceps.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Technique'),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'With your hands placed behind you on the edge of a chair or bench; legs and arms extended, you support your weight on your heels and hands:',
                      style: normalTextStyle(),
                    ),
                    SizedBox(height: 8),
                    ...[
                      'Bend your arms while controlling the descent;\n',
                      'Lower yourself until your triceps are parallel to the ground;\n',
                      'Push up by fully extending your arms;\n',
                      'Keep your back straight and puff your chest out during the movement.\n',
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
                      'Note :',
                      style: normalTextStyle(),
                    ),
                    SizedBox(height: 8),
                    ...[
                      'Do not lower yourself too deeply to avoid injury (limit: upper arms parallel to the ground).',
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
                 image: AssetImage('images/png/dips_sur_chaise_muscles.png'),
                ),
                Text(
                  'The main muscles worked for chair dips are the triceps.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Demonstration'),
                Image(
                 image: AssetImage('images/gif/dips_sur_chaise.gif'),
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