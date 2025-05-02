import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../textStyle/textstyle.dart';

class SidePlank extends StatelessWidget {
  const SidePlank({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          'Side Plank',
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
                  'images/png/planche_laterale.png',
                ),
                SizedBox(height: 20),
                Text(
                  'The side plank or side plank hold is an isometric exercise targeting the oblique abdominals. It is the plank exercise performed on the side.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Technique'),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                       'Lying on the floor on your side:',
                      style: normalTextStyle(),
                    ),
                    SizedBox(height: 8),
                    ...[
                      'Support your weight on your forearm (elbow under the shoulder) and the outer side of your foot (with legs joined, stacked, and extended), the opposite hand placed on your hip or along your thigh;\n',
                      'Engage your abdominals, glutes, and thighs to maintain your body alignment in a straight line (ankles, knees, hips, spine, and head);\n',
                      'Hold the position for the work time and switch sides.',
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
                      'Breathe normally.\n',
                      'Push with your elbow into the ground (not “on the elbow,” your forearm remains in contact and flat on the ground).\n',
                      'Keep your abdominals, glutes, and thighs engaged to avoid letting your hips drop towards the ground.\n',
                      'Avoid tilting your body forward or backward (on the frontal plane, the body should be perpendicular to the ground).\n',
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
                 image: AssetImage('images/png/planche_laterale_muscle.png'),
                ),
                Text(
                  'The main muscles worked in the side plank are the obliques.',
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Demonstration'),
                Image(
                 image: AssetImage('images/gif/planche_lateral.gif'),
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