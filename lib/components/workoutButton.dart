import 'package:flutter/material.dart';

class WorkoutElevatedButton extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  const WorkoutElevatedButton({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 319,
      height: 89,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: const Color(0xFFE3ACFF).withAlpha((0.4 * 255).toInt()), // Opacité 40%
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0, // optionnel : enlever l'ombre
        ),
        child: Row(
          children: [
            // Conteneur de l'icône avec fond
            Container(
              width: 68,
              height: 70,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF282A47).withAlpha((0.56 * 255).toInt()), // Opacité 56%
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 11),
            // Textes
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Color(0xFFA3A8AC),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
