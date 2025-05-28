import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primaryColor = Color.fromARGB(255, 0, 166, 214);
  static const secondaryColor = Color.fromARGB(255, 255, 255, 255);
  static const ternaryColor = Color.fromARGB(255, 0, 111, 142);
  static const textColor = Color.fromARGB(255, 0, 0, 0);
  static const black = Color.fromARGB(255, 0, 0, 0);
  static const white = Color.fromARGB(255, 255, 255, 255);
  static const alertColor = Color.fromARGB(255, 163, 16, 0);

  static const defaultLightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryColor,
    onPrimary: AppColors.secondaryColor,
    // onPrimary: AppColors.white,
    secondary: Color.fromARGB(255, 30, 255, 0),
    // secondary: AppColors.black,
    onSecondary: Color.fromARGB(255, 229, 255, 0),
    // onSecondary: AppColors.white,
    surface: AppColors.secondaryColor,
    onSurface: AppColors.black,
    error: AppColors.alertColor,
    // error: Colors.white,
    onError: AppColors.alertColor,
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
    onError: AppColors.alertColor,
  );
}
