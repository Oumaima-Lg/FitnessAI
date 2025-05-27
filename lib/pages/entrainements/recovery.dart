import 'package:fitness/pages/entrainements/congratulation.dart';
import 'package:flutter/material.dart';
import 'package:fitness/components/personalized_widget.dart';
import 'package:fitness/models/activity.dart';

class Recovery extends StatefulWidget {
  final Activity activity;
  const Recovery({super.key, required this.activity});

  @override
  State<Recovery> createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  int indexCurrentStep = 0;

  void nexStep() {
    if (indexCurrentStep < widget.activity.steps!.length - 1) {
      setState(() {
        indexCurrentStep++;
      });
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Congratulation(
                imageUrl: 'congratulation_BE',
                title: 'Congratulations, You Have Finished Your Workout !',
                description:
                    'Exercises is king and nutrition is queen. Combine the two and you will have a kingdom.\n-Jack Lalanne'),
          ));
    }
  }

  void previousStep() {
    if (indexCurrentStep > 0) {
      setState(() {
        indexCurrentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2F55),
      appBar: Appbar(activity: widget.activity),
      body: Center(
        child: Column(
          children: [
            EllipseOverlayImage(
              ellipseImage: 'images/Ellipse_2.png',
              mainImage: widget.activity.steps![indexCurrentStep].stepImage!,
              height: 250,
            ),
            stepDescription(titleStep: 'Step By Step', stepCount: '14 Steps'),
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: widget.activity.steps!.length,
                    itemBuilder: (context, index) {
                      final step = widget.activity.steps![index];
                      return StepWidget(
                        activity: widget.activity,
                        step: step,
                        index: index,
                        currentStep: index == indexCurrentStep,
                      );
                    },
                  ),
                  Positioned(
                    bottom: 20,
                    left: 40,
                    right: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GradientButton(
                          title: '',
                          icon: Icons.arrow_back,
                          maxWidth: 120,
                          maxHeight: 50,
                          onPressed: () {
                            previousStep();
                          },
                        ),
                        GradientButton(
                          title: '',
                          icon: Icons.arrow_forward,
                          maxWidth: 120,
                          maxHeight: 50,
                          onPressed: () {
                            nexStep();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
