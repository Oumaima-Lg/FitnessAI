import 'package:fitness/components/gradient.dart';
import 'package:fitness/pages/register.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        width: double.infinity,

        /* background degrade : */
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
        /******************************/
        child: Column(
          spacing: 10,
          children: [
            SizedBox(
              // margin: EdgeInsets.only(top: 80),
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 1.95,
              child: Stack(
                children: [
                  GradientComponent.gradientCircle(
                      10, 90, Color(0xFFFFB19A), Color(0xFFFF4902)),
                  GradientComponent.gradientCircle(
                      20, 175, Color(0xFF3A3464), Color(0xFF1B1C2A)),
                  GradientComponent.gradientCircle(
                      150, 30, Color(0xFF3A3464), Color(0xFF1B1C2A)),
                  GradientComponent.gradientCircle(
                      255, 60, Color(0xFF3A3464), Color(0xFF1B1C2A)),
                  GradientComponent.gradientCircle(
                      255, 20, Color(0xFFE8ACFF), Color(0xFF7800FF)),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 75, left: 35, right: 35),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(0xFFE8ACFF).withAlpha(51), width: 2),
                        borderRadius: BorderRadius.circular(41),
                        color: Color(0xFF4023D7).withAlpha(38),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                            'Without health, \neverything else loses its meaning. \nTake care of it, \nyour health is the key to everything.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GradientComponent.gradientButton(
                text: 'Next',
                maxWidth: 220,
                maxHeight: 50,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(),
                    ))),
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                maxHeight: 200,
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Image.asset(
                'images/fitness.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
