import 'package:fitness/pages/planning/AddScheduleScreen%20.dart';
import 'package:flutter/material.dart';

class FocusScreen extends StatelessWidget {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 56.0, vertical: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Ready to get started? Choose your primary focus: nutrition or training, and begin your journey today!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30),
              FocusItem(
                imageUrl:
                    'images/Training.png', // Remplacez par l'image du training
                label: 'Training',
                onTap: () {
                  navigateToPlanningPage(context, AddScheduleScreen());
                },
              ),
              SizedBox(height: 20),
              FocusItem(
                imageUrl:
                    'images/Healthy Eating.png', // Remplacez par l'image de Healthy Eating
                label: 'Healthy Eating',
                onTap: () {
                  print("Healthy Eating Focus Selected");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FocusItem extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback onTap;

  const FocusItem({
    required this.imageUrl,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 30.0),
          child: Column(
            children: [
              Container(
                height: 105, // Ajustez la taille de l'image
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.contain,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
