import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const darkPrimary = Color(0XFF2D3250);
const lightPrimary = Color(0XFFFAF8FC);
const darkSecondary = Color(0XFF7077A1);
const lightSecondary = Color(0XFFB2E4F0);
const successColor = Color(0XFF198754);
const errorColor = Color(0XFFFF3333);
const darkColor = Colors.black;
const lightColor = Colors.white;
const shadowColor = Colors.grey;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: darkPrimary,
  ),
  iconTheme: const IconThemeData(color: darkPrimary),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: MaterialStateProperty.all<Color?>(darkPrimary),
    ),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: darkColor,
    unselectedLabelColor: shadowColor,
    dividerColor: darkPrimary,
  ),
  scaffoldBackgroundColor: lightPrimary,
  appBarTheme: AppBarTheme(
    elevation: 4,
    titleTextStyle: TextStyle(
      color: lightColor,
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
    ),
    actionsIconTheme: const IconThemeData(color: lightColor),
    backgroundColor: darkPrimary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color?>(darkPrimary),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color?>(darkPrimary),
      overlayColor: MaterialStateProperty.all<Color?>(shadowColor),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: darkColor),
    displayMedium: TextStyle(color: darkColor),
    displaySmall: TextStyle(color: darkColor),
    headlineLarge: TextStyle(color: darkColor),
    headlineMedium: TextStyle(color: darkColor),
    headlineSmall: TextStyle(color: darkColor),
    bodyLarge: TextStyle(color: darkColor),
    bodyMedium: TextStyle(color: darkColor),
    bodySmall: TextStyle(color: darkColor),
    titleSmall: TextStyle(color: darkColor),
    titleMedium: TextStyle(color: darkColor),
    titleLarge: TextStyle(color: darkColor),
    labelSmall: TextStyle(color: darkColor),
    labelMedium: TextStyle(color: darkColor),
    labelLarge: TextStyle(color: darkColor),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: lightPrimary,
  ),
  iconTheme: const IconThemeData(color: lightPrimary),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: MaterialStateProperty.all<Color?>(lightPrimary),
    ),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: lightColor,
    unselectedLabelColor: shadowColor,
    dividerColor: lightPrimary,
  ),
  scaffoldBackgroundColor: darkPrimary,
  appBarTheme: AppBarTheme(
    elevation: 0,
    titleTextStyle: TextStyle(
      color: lightPrimary,
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
    ),
    actionsIconTheme: const IconThemeData(color: lightPrimary),
    backgroundColor: darkPrimary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color?>(darkPrimary),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: lightColor),
    displayMedium: TextStyle(color: lightColor),
    displaySmall: TextStyle(color: lightColor),
    headlineLarge: TextStyle(color: lightColor),
    headlineMedium: TextStyle(color: lightColor),
    headlineSmall: TextStyle(color: lightColor),
    bodyLarge: TextStyle(color: lightColor),
    bodyMedium: TextStyle(color: lightColor),
    bodySmall: TextStyle(color: lightColor),
    titleSmall: TextStyle(color: lightColor),
    titleMedium: TextStyle(color: lightColor),
    titleLarge: TextStyle(color: lightColor),
    labelSmall: TextStyle(color: lightColor),
    labelMedium: TextStyle(color: lightColor),
    labelLarge: TextStyle(color: lightColor),
  ),
);
