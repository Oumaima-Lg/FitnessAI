import 'package:flutter/material.dart';

// titre li roze u sfer
class GradientTitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Alignment alignment;
  // final TextAlign textAlign;

  const GradientTitleText({
    super.key,
    required this.text,
    this.alignment = Alignment.center,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment, // Aligner à gauche
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFFFFA992), Color(0xFFFD0D92)],
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
        child: Text(
          text,
          // textAlign: textAlign,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: 'Poppins',
          ),
          textAlign: TextAlign.center, // Centrer le texte
        ),
      ),
    );
  }
}

// Button lmove li kayt3awed
class GradientButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final double width;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.title,
    required this.icon,
    this.width = 120,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF983BCB), Color(0xFF4023D7)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
