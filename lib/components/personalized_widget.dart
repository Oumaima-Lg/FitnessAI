import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:fitness/models/activity.dart';
import 'package:fitness/models/step.dart';
import 'package:fitness/pages/go.dart';
import 'package:flutter/material.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({
    super.key,
    required this.activity,
  });
  final Activity activity;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF2E2F55),
      centerTitle: true,
      title: Text(
        activity.title,
        style: titleTextStyle(),
      ),
    );
  }
}

// titre li roze u sfer
class GradientTitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Alignment alignment;
  final TextAlign textAlign;

  const GradientTitleText({
    super.key,
    required this.text,
    this.alignment = Alignment.topLeft,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w600,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFFFFA992), Color(0xFFFD0D92)],
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: 'Poppins',
          ),
          textAlign: textAlign, // Centrer le texte
        ),
      ),
    );
  }
}

// Button lmove li kayt3awed
class GradientButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final double maxWidth;
  final double maxHeight;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.title,
    required this.icon,
    required this.maxWidth,
    required this.maxHeight,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth,
      height: maxHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4023D7), Color(0xFF983BCB)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Etoile extends StatelessWidget {
  final double size;
  const Etoile({
    super.key,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '★',
      style: TextStyle(
        color: Color(0xFFFFA992),
        fontSize: size,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// ellipse tht tswira
class EllipseOverlayImage extends StatelessWidget {
  final String ellipseImage;
  final String mainImage;
  final double height;
  final double width;
  final double imageWidth;
  final double imageHeight;

  const EllipseOverlayImage({
    super.key,
    required this.ellipseImage,
    required this.mainImage,
    this.height = 325,
    this.width = double.infinity,
    this.imageWidth = 325,
    this.imageHeight = 361,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              ellipseImage,
              fit: BoxFit.cover,
            ),
          ),
          Image.asset(
            mainImage,
            width: imageWidth,
            height: imageHeight,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class StepWidget extends StatelessWidget {
  const StepWidget({
    super.key,
    required this.activity,
    required this.index,
    required this.step,
    required this.currentStep,
  });

  final Activity activity;
  final StepItem step;
  final int index;
  final bool currentStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text(
                    (index + 1).toString().padLeft(2, '0'),
                    style: titleTextStyle(
                      color:
                          currentStep ? Color(0xFFC58BF2) : Color(0xFFADA4A5),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          currentStep ? Color(0xFFC58BF2) : Color(0xFFADA4A5),
                    ),
                    child: Center(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentStep
                                  ? Color(0xFFC58BF2)
                                  : Color(0xFFADA4A5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              if (index < activity.steps!.length - 1)
                Padding(
                  padding: const EdgeInsets.only(left: 33),
                  child: Column(
                    children: List.generate(15, (i) {
                      return Container(
                        width: 2,
                        height: 5,
                        color: i % 2 == 0
                            ? (currentStep
                                ? Color(0xFFC58BF2)
                                : Color(0xFFADA4A5))
                            : Colors.transparent,
                      );
                    }),
                  ),
                ),
            ],
          ),
          SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.stepTitle,
                  style: titleTextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  step.stepDescription,
                  style: normalTextStyle(
                    color: Color(0xC4E8ACFF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// La description affiché avant les étapes
Widget stepDescription({required String titleStep, required String stepCount}) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titleStep,
          style: titleTextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          stepCount,
          style: titleTextStyle(fontWeight: FontWeight.w100, fontSize: 13),
        ),
      ],
    ),
  );
}

// Le bouton GO =>
GradientButton goButton(BuildContext context, {required Activity activity}) {
  return GradientButton(
    title: 'Go',
    icon: Icons.arrow_forward,
    maxWidth: 120,
    maxHeight: 42,
    onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoPage(activity: activity),
        )),
  );
}
