import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimentions.dart';

abstract final class AppTheme {
  static const _textTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.black),
    headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.black),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
    bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
    bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.black),
    labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.black),
  );

  static const _lightAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    shadowColor: AppColors.black,
    titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textColor),
    elevation: Dimentions.elevation,
  );

  static const _lightBottomNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: AppColors.primaryColor,
    selectedItemColor: AppColors.secondaryColor,
    elevation: Dimentions.elevation,
    type: BottomNavigationBarType.fixed
  );

  static const _lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.textColor),
      backgroundColor: WidgetStatePropertyAll<Color>(AppColors.secondaryColor),
      elevation: WidgetStatePropertyAll(Dimentions.elevation),
      side: WidgetStatePropertyAll(BorderSide(color: AppColors.primaryColor, width: 2.0)),
    ),
  );

  static const _lightListTileTheme = ListTileThemeData(
    shape: BeveledRectangleBorder(side: BorderSide(color: AppColors.primaryColor, width: 1.0))
  );

  static const _inputDecorationTheme = InputDecorationTheme(
    hintStyle: TextStyle(
      color: AppColors.textColor,
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
    ),
  );


  static ThemeData defaultLightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: AppColors.defaultLightColorScheme,
    textTheme: _textTheme,
    appBarTheme: _lightAppBarTheme,
    bottomNavigationBarTheme: _lightBottomNavigationBarTheme,
    elevatedButtonTheme: _lightElevatedButtonTheme,
    listTileTheme: _lightListTileTheme,
    inputDecorationTheme: _inputDecorationTheme,
  );

  static ThemeData defaultDarkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: AppColors.defaultDarkColorScheme,
    textTheme: _textTheme,
    inputDecorationTheme: _inputDecorationTheme,
  );
}
