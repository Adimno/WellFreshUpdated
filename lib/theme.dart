import 'package:flutter/material.dart';

// Theme variables
const surfaceColor = Color.fromRGBO(248, 250, 255, 1);
const tertiaryColor = Color.fromRGBO(20, 55, 106, .45);
const accentColor = Color.fromRGBO(81, 168, 255, 1);
const warningColor = Color.fromRGBO(255, 187, 14, 1);
const errorColor = Color.fromRGBO(255, 69, 69, 1);

const primaryTextColor = Color.fromRGBO(8, 12, 47, 1);
const secondaryTextColor = Color.fromRGBO(94, 97, 119, 1);
const tertiaryTextColor = Color.fromRGBO(8, 12, 47, .65);
const invertTextColor = Color.fromRGBO(255, 255, 255, 1);
const titleTextColor = Color.fromRGBO(8, 12, 47, 1);
const accentTextColor = Color.fromRGBO(81, 168, 255, 1);
const warningTextColor = Color.fromRGBO(255, 187, 14, 1);
const errorTextColor = Color.fromRGBO(255, 69, 69, 1);

const cardColor = Color.fromRGBO(255, 255, 255, 1);
const boxShadowColor = Color.fromRGBO(178, 178, 178, 0.2);
const borderColor = Color.fromRGBO(178, 178, 178, 1);

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
    titleLarge: TextStyle(
      color: primaryTextColor,
      fontSize: 18,
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