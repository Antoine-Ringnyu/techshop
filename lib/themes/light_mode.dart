import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade900,
    secondary: Colors.grey.shade500,
    tertiary: const Color.fromARGB(255, 255, 0, 0),
    inversePrimary: Colors.grey.shade900,
  ),
  scaffoldBackgroundColor: Colors.orange.shade50,
);
