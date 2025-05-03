import 'package:fitness/models/activity.dart';
import 'package:flutter/material.dart';
import '../components/personalized_widget.dart';
import '../textStyle/textstyle.dart';

class Hiit extends StatelessWidget {
  final Activity activity;

  const Hiit({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          activity.title,
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
                  activity.imageUrl,
                ),
                SizedBox(height: 20),
                Text(
                  activity.description,
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Technique'),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Stand with your feet hip-width apart, hands by your sides:',
                    //   style: normalTextStyle(),
                    // ),
                    SizedBox(height: 8),
                    ...activity.techniques.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            ' •  $item',
                            style: normalTextStyle(),
                          ),
                        )),
                    SizedBox(height: 12),
                    // Text(
                    //   'Point to watch: don\'t tuck your head into your shoulders (keep your shoulders away from your ears).',
                    //   style: normalTextStyle(),
                    // ),
                  ],
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Muscles Worked'),
                SizedBox(height: 20),
                Image(
                  image: AssetImage(activity.muscleImageUrl!),
                ),
                Text(
                  activity.muscleDescription!,
                  style: normalTextStyle(),
                ),
                SizedBox(height: 20),
                GradientTitleText(text: 'Demonstration'),
                Image(
                  image: AssetImage(activity.videoDemonstartionUrl!),
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
