import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface:  Colors.grey[300]!,
    primary: Colors.grey[900]!,
    secondary:Colors.grey[700]!,
    tertiary: const Color(0xFFFF6600),
    inversePrimary: const Color(0xFFFFFFFA),
  ),
  scaffoldBackgroundColor: Colors.grey[300],
);
