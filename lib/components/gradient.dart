import 'package:flutter/material.dart';

class GradientComponent {
  static ElevatedButton gradientButton(
      {required String text,
      required double maxWidth,
      required double maxHeight,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4023D7), Color(0xFF983BCB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            // fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Positioned gradientCircle(
      double top, double right, Color color1, Color color2) {
    return Positioned(
      top: top,
      right: right,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color1,
              color2,
            ],
            // begin: Alignment.topRight,
            // end: Alignment.bottomLeft,
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  static Widget gradientText({
    required String text,
    required TextStyle style,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [Color(0xFF000000), Color(0xFF361E6F)],
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }

  static ElevatedButton gradientButton2(
      {required String text,
      required double maxWidth,
      required double maxHeight,
      required Color color1,
      required Color color2,
      // required BuildContext context,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // elevation: 1,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey, // Couleur de l'ombre
          //     spreadRadius: 0, // Étendue de l'ombre
          //     blurRadius: 4, // Flou de l'ombre
          //     offset: const Offset(0, 1), // Position (horizontal, vertical)
          //   ),
          // ],
          gradient: LinearGradient(
            colors: [color2, color1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(99),
        ),
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Widget switchBetweenPages(Widget page) {
    return Container(
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
    );
  }
}
