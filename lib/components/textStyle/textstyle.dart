import 'package:flutter/material.dart';

TextStyle normalTextStyle({color= Colors.white , fontSize= 14}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: 'Poppins',
    height: 1.71,
    fontWeight: FontWeight.normal,
  );
}

TextStyle titleTextStyle({Color color = Colors.white, double fontSize = 20, fontWeight= FontWeight.w200}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: 'Poppins',
    fontWeight: fontWeight,
    height: 1.71,
  );
}
