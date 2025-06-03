import 'package:flutter/material.dart';

class ReturnButton {
  static IconButton returnButton(
      {IconData icon = Icons.arrow_back_ios, VoidCallback? onPressed}) {
    return IconButton(
      onPressed: onPressed ??
          () {
            // Action when button is
          },
      icon: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border:
              Border.all(color: Color.fromARGB(255, 232, 172, 255), width: 1.0),
        ),
        child: Center(
          child: Icon(
            icon,
            color: const Color.fromARGB(186, 255, 255, 255),
            size: 10,
          ),
        ),
      ),
    );
  }

  static ElevatedButton gradientButton(String text, {VoidCallback? onPressed}) {
    // gradiant dyal lbouton with rounded corners
    return ElevatedButton(
      onPressed: onPressed ??
          () {
            // Action when button is pressed
          },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9DCEFF), Color(0xFF92A3FD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        constraints: BoxConstraints(
          minWidth: 95,
          minHeight: 35,
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
}
