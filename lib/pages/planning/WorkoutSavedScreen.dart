import 'package:fitness/components/gradient.dart';
import 'package:fitness/pages/bottomnavbar.dart';
import 'package:fitness/pages/planning/AddScheduleScreen%20.dart';
import 'package:flutter/material.dart';

class WorkoutSavedScreen extends StatelessWidget {
  const WorkoutSavedScreen({super.key});

  void navigateToPlanningPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2E2F55),
                Color(0xFF23253C),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: page,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('images/saveSchedule.png'),
                const SizedBox(height: 44),
                const Text(
                  "Workout saved! Keep pushing!\nyou're one step closer to your\ngoals!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 70),
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Calcul de l'espace disponible
                    final buttonWidth = 163.0;
                    final spacing = 16.0;
                    final totalWidthNeeded = 2 * buttonWidth + spacing;

                    // Choix de la disposition en fonction de l'espace
                    if (constraints.maxWidth > totalWidthNeeded) {
                      return _buildRowLayout(); // Version horizontale
                    } else {
                      return _buildColumnLayout(context); // Version verticale
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Version horizontale
  Widget _buildRowLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: GradientComponent.gradientButton2(
              text: 'Add Schedule',
              maxWidth: 163,
              maxHeight: 60,
              color1: const Color(0xFF364FCE),
              color2: const Color(0xFF9DCEFF),
              onPressed: () => print("")),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: GradientComponent.gradientButton2(
              text: 'Back To Home',
              maxWidth: 163,
              maxHeight: 60,
              color1: const Color(0xFF0A1653),
              color2: const Color(0xFF9DCEFF),
              onPressed: () => print("")),
        ),
      ],
    );
  }

// Version verticale
  Widget _buildColumnLayout(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GradientComponent.gradientButton2(
            text: 'Add Schedule',
            maxWidth: 163,
            maxHeight: 60,
            color1: const Color(0xFF364FCE),
            color2: const Color(0xFF9DCEFF),
            onPressed: () =>
                navigateToPlanningPage(context, AddScheduleScreen())),
        const SizedBox(height: 16),
        GradientComponent.gradientButton2(
            text: 'Back To Home',
            maxWidth: 163,
            maxHeight: 60,
            color1: const Color(0xFF0A1653),
            color2: const Color(0xFF9DCEFF),
            onPressed: () => navigateToPlanningPage(context, BottomNavBar())),
      ],
    );
  }
}
