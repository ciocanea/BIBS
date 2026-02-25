import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primaryColor = Color.fromARGB(255, 0, 166, 214);
  static const secondaryColor = Color.fromARGB(255, 255, 255, 255);
  static const ternaryColor = Color.fromARGB(255, 0, 111, 142);
  static const textColor = Color.fromARGB(255, 0, 0, 0);
  static const black = Color.fromARGB(255, 0, 0, 0);
  static const white = Color.fromARGB(255, 255, 255, 255);
  static const alertColor = Color.fromARGB(255, 163, 16, 0);

  static const darkPrimaryColor = Color.fromARGB(255, 0, 166, 214);
  static const darkSecondaryColor = Color.fromARGB(255, 44, 44, 44);
  static const darkTernaryColor = Color.fromARGB(255, 0, 111, 142);
  static const darkTextColor = Color.fromARGB(255, 255, 255, 255);


  static const defaultLightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryColor,
    onPrimary: AppColors.secondaryColor,
    // onPrimary: AppColors.white,
    secondary: AppColors.secondaryColor,
    // secondary: AppColors.black,
    onSecondary: AppColors.black,
    // onSecondary: AppColors.white,
    surface: AppColors.secondaryColor,
    onSurface: AppColors.black,
    error: AppColors.alertColor,
    // error: Colors.white,
    onError: AppColors.alertColor,
  );

  static const defaultDarkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkPrimaryColor,
    onPrimary: AppColors.darkSecondaryColor,
    secondary: AppColors.darkTernaryColor,
    onSecondary: AppColors.white,
    surface: AppColors.darkSecondaryColor,
    onSurface: Colors.white,
    error: AppColors.alertColor,
    onError: AppColors.alertColor,
  );
}
