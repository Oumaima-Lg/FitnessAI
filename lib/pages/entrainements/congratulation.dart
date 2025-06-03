import 'package:fitness/components/gradient.dart';
import 'package:fitness/components/personalized_widget.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:fitness/pages/bottomnavbar.dart';
import 'package:flutter/material.dart';

class Congratulation extends StatelessWidget {
  String imageUrl, title, description;

  Congratulation({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
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
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    EllipseOverlayImage(
                      ellipseImage: 'images/Ellipse_2.png',
                      mainImage: 'images/$imageUrl.png',
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Text(
                            title,
                            style: titleTextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            description,
                            style: normalTextStyle(
                                color: Color(0xB3E8ACFF), fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: GradientComponent.gradientButton(
                    text: 'Back To Home',
                    maxWidth: 315,
                    maxHeight: 50,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GradientComponent.switchBetweenPages(
                                    BottomNavBar())),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
