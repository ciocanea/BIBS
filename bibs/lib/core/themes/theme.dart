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
      side: WidgetStatePropertyAll(BorderSide(color: AppColors.primaryColor, width: 1.5)),
    ),
  );

  static const _lightTextButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.textColor),
      backgroundColor: WidgetStatePropertyAll<Color>(AppColors.secondaryColor),
    ),
  );

  static const _lightListTileTheme = ListTileThemeData(
    shape: BeveledRectangleBorder(side: BorderSide(color: AppColors.primaryColor, width: 1.0))
  );

  static const _inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(Dimentions.borderRadius)),
      borderSide: BorderSide(color: AppColors.primaryColor, width: 3.0),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryColor, width: 3.0),
      borderRadius: BorderRadius.all(Radius.circular(Dimentions.borderRadius)),
    ),
    hintStyle: TextStyle(
      color: AppColors.textColor,
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
    ),
  );

  static const _darkTextTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.darkTextColor),
    headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkTextColor),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkTextColor),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkTextColor),
    bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkTextColor),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkTextColor),
    bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkTextColor),
    labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkTextColor),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.darkTextColor),
  );

  static const _darkAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.darkPrimaryColor,
    shadowColor: AppColors.black,
    titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textColor),
    elevation: Dimentions.elevation,
  );

  static const _darkBottomNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkPrimaryColor,
    selectedItemColor: AppColors.darkSecondaryColor,
    elevation: Dimentions.elevation,
    type: BottomNavigationBarType.fixed
  );

  static const _darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.textColor),
      backgroundColor: WidgetStatePropertyAll<Color>(AppColors.darkTernaryColor),
      elevation: WidgetStatePropertyAll(Dimentions.elevation),
      side: WidgetStatePropertyAll(BorderSide(color: AppColors.darkPrimaryColor, width: 1.5)),
    ),
  );

  static const _darkTextButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.textColor),
      backgroundColor: WidgetStatePropertyAll<Color>(AppColors.darkSecondaryColor),
    ),
  );

  static const _darkListTileTheme = ListTileThemeData(
    tileColor: AppColors.darkTernaryColor,
    shape: BeveledRectangleBorder(side: BorderSide(color: AppColors.darkPrimaryColor, width: 1.0)),
  );

  static const _darkInputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkTernaryColor,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(Dimentions.borderRadius)),
      borderSide: BorderSide(color: AppColors.darkPrimaryColor, width: 3.0),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.darkPrimaryColor, width: 3.0),
      borderRadius: BorderRadius.all(Radius.circular(Dimentions.borderRadius)),
    ),
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
    textButtonTheme: _lightTextButtonTheme,
    listTileTheme: _lightListTileTheme,
    inputDecorationTheme: _inputDecorationTheme,
  );

  static ThemeData defaultDarkTheme = ThemeData(
    // brightness: Brightness.dark,
    colorScheme: AppColors.defaultDarkColorScheme,
    textTheme: _darkTextTheme,
    appBarTheme: _darkAppBarTheme,
    bottomNavigationBarTheme: _darkBottomNavigationBarTheme,
    elevatedButtonTheme: _darkElevatedButtonTheme,
    textButtonTheme: _darkTextButtonTheme,
    listTileTheme: _darkListTileTheme,
    inputDecorationTheme: _darkInputDecorationTheme,
  );
}
