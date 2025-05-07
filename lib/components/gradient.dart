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
}
