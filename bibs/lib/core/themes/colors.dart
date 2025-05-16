import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primaryColor = Color.fromARGB(255, 99, 99, 99);
  static const secondaryColor = Color.fromARGB(255, 154, 154, 154);
  static const ternaryColor = Color.fromARGB(255, 176, 176, 176);
  static const textColor = Color.fromARGB(255, 0, 0, 0);
  static const black = Color.fromARGB(255, 0, 0, 0);
  static const white = Color.fromARGB(255, 255, 255, 255);
  static const red = Color.fromARGB(255, 200, 20, 0);

  static const defaultLightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryColor,
    onPrimary: Color.fromARGB(255, 60, 0, 255),
    // onPrimary: AppColors.white,
    secondary: Color.fromARGB(255, 30, 255, 0),
    // secondary: AppColors.black,
    onSecondary: Color.fromARGB(255, 229, 255, 0),
    // onSecondary: AppColors.white,
    surface: AppColors.secondaryColor,
    onSurface: AppColors.black,
    error: Colors.purple,
    // error: Colors.white,
    onError: Colors.red,
  );

  static const defaultDarkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.white,
    onPrimary: AppColors.black,
    secondary: AppColors.white,
    onSecondary: AppColors.black,
    surface: AppColors.black,
    onSurface: Colors.white,
    error: Colors.black,
    onError: AppColors.red,
  );
}
