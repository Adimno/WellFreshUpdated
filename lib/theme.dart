import 'package:flutter/material.dart';

// Theme variables
const surfaceColor = Color.fromRGBO(248, 250, 255, 1);
const accentColor = Color.fromRGBO(81, 168, 255, 1);
const primaryTextColor = Color.fromRGBO(8, 12, 47, 1);
const secondaryTextColor = Color.fromRGBO(94, 97, 119, 1);
const tertiaryTextColor = Color.fromRGBO(8, 12, 47, .65);
const titleTextColor = Color.fromRGBO(8, 12, 47, 1);
const accentTextColor = Color.fromRGBO(81, 168, 255, 1);

const cardColor = Color.fromRGBO(255, 255, 255, 1);
const boxShadowColor = Color.fromRGBO(178, 178, 178, 0.2);

const containerShadow = BoxShadow(
  color: boxShadowColor,
  blurRadius: 30,
  offset: Offset(0, 5),
);

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: surfaceColor,
    fontFamily: 'Poppins',
    textTheme: textTheme(),
  );
}

TextTheme textTheme() {
  return const TextTheme(
    displayLarge: TextStyle(
      color: primaryTextColor,
      fontSize: 32,
    ),
    displayMedium: TextStyle(
      color: primaryTextColor,
      fontSize: 24,
    ),
    displaySmall: TextStyle(
      color: primaryTextColor,
      fontSize: 20,
    ),
    titleMedium: TextStyle(
      color: primaryTextColor,
      fontSize: 16,
    ),
    titleSmall: TextStyle(
      color: primaryTextColor,
      fontSize: 14,
    ),
    bodyLarge: TextStyle(
      color: primaryTextColor,
      fontSize: 14,
    ),
    bodyMedium: TextStyle(
      color: primaryTextColor,
      fontSize: 12,
    ),
    bodySmall: TextStyle(
      color: primaryTextColor,
      fontSize: 10,
    ),
  );
}