import 'package:flutter/material.dart';
import 'package:fitness/models/activity.dart';
import '../components/personalized_widget.dart';
import '../components/textStyle/textstyle.dart';

class Cardio extends StatelessWidget {
  final Activity activity;

  const Cardio({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: Appbar(activity: activity),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  activity.imageUrl!,
                  fit: BoxFit.cover,
                  width: 316,
                  height: 415,
                ),
                SizedBox(height: 20),
                Text(
                  activity.description!,
                  style: normalTextStyle(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25),
                stepDescription(titleStep: 'How To Do It', stepCount: '4 Steps'),
                SizedBox(height: 15),
                Column(
                  children: List.generate(activity.steps!.length, (index) {
                    final step = activity.steps![index];
                    return StepWidget(
                      activity: activity,
                      step: step,
                      index: index,
                      currentStep: true,
                    );
                  }),
                ),
                SizedBox(height: 20),
                goButton(
                  context, 
                  activity: activity, 
                  titleExercice: 'cardio', 
                  quote: 'Cardio doesn’t just build stamina — it builds character, breath by breath, beat by beat.'
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
