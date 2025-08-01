import 'package:fitness/models/activity.dart';
import 'package:flutter/material.dart';
import '../../components/personalized_widget.dart';
import '../../components/textStyle/textstyle.dart';

class Hiit extends StatelessWidget {
  final Activity activity;

  const Hiit({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                  activity.imageUrl!,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                Text(
                  activity.description!,
                  style: normalTextStyle(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25),
                GradientTitleText(text: 'Technique'),
                SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    ...(activity.techniques ?? []).map((item) => Padding(
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
                  image: AssetImage(activity.muscleImageUrl!),
                ),
                SizedBox(height: 10),
                Text(
                  activity.muscleDescription!,
                  style: normalTextStyle(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25),
                GradientTitleText(text: 'Demonstration'),
                SizedBox(height: 20),
                Stack(
                  children: [
                    Positioned(
                        left: 0,
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(23),
                            color: Color(0xFFF4E3DF),
                          ),
                        )),
                    Image(
                      image: AssetImage(activity.videoDemonstartionUrl!),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                goButton(context,
                    activity: activity,
                    titleExercice: 'hiit',
                    quote:
                        'HIIT is the throne, discipline is the crown. Master both, and you’ll rule your fitness kingdom.\nInspired by the spirit of Jack LaLanne.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
