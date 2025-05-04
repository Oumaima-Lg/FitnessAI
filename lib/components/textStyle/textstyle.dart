import 'package:flutter/material.dart';

TextStyle normalTextStyle({double size = 14}) {
  return TextStyle(
    color: Colors.white,
    fontSize: size,
    fontFamily: 'Poppins',
    height: 1.71,
    fontWeight: FontWeight.normal,
  );
}

TextStyle titleTextStyle({Color color = Colors.white, double fontSize = 20}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w200,
    height: 1.71,
  );
}
