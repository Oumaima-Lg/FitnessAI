import 'package:flutter/material.dart';

TextStyle normalTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontFamily: 'Poppins',
    height: 1.71,
    fontWeight: FontWeight.normal,
  );
}

TextStyle titleTextStyle({Color color = Colors.white}) {
  return TextStyle(
    color: color,
    fontSize: 20,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    height: 1.71,
  );
}

