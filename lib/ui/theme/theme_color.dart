import 'package:flutter/material.dart';

class ThemeColors {
  static const MaterialColor blue = MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
      50: Color(0xFFE3F3FD),
      100: Color(0xFFB9E1FA),
      200: Color(0xFF8BCEF7),
      300: Color(0xFF5CBAF3),
      400: Color(0xFF39ABF1),
      500: Color(_bluePrimaryValue),
      600: Color(0xFF1394EC),
      700: Color(0xFF108AE9),
      800: Color(0xFF0C80E7),
      900: Color(0xFF066EE2),
    },
  );
  static const int _bluePrimaryValue = 0xFF169CEE;
}
