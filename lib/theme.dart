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
const fadeTextColor = Color.fromRGBO(255, 255, 255, .75);
const titleTextColor = Color.fromRGBO(8, 12, 47, 1);
const accentTextColor = Color.fromRGBO(81, 168, 255, 1);
const warningTextColor = Color.fromRGBO(255, 187, 14, 1);
const errorTextColor = Color.fromRGBO(255, 69, 69, 1);

const cardColor = Color.fromRGBO(255, 255, 255, 1);
const boxShadowColor = Color.fromRGBO(178, 178, 178, 0.2);
const borderColor = Color.fromRGBO(178, 178, 178, .65);

const containerShadow = BoxShadow(
  color: boxShadowColor,
  blurRadius: 30,
  offset: Offset(0, 5),
);

// Theme variables (Dark)
// const surfaceColor = Color.fromRGBO(0, 0, 0, 1);
// const tertiaryColor = Color.fromRGBO(20, 55, 106, .45);
// const accentColor = Color.fromRGBO(81, 168, 255, 1);
// const warningColor = Color.fromRGBO(255, 187, 14, 1);
// const errorColor = Color.fromRGBO(255, 69, 69, 1);

// const primaryTextColor = Color.fromRGBO(255, 255, 255, 1);
// const secondaryTextColor = Color.fromRGBO(255, 255, 255, .8);
// const tertiaryTextColor = Color.fromRGBO(255, 255, 255, .65);
// const invertTextColor = Color.fromRGBO(255, 255, 255, 1);
// const fadeTextColor = Color.fromRGBO(255, 255, 255, .75);
// const titleTextColor = primaryTextColor;
// const accentTextColor = Color.fromRGBO(81, 168, 255, 1);
// const warningTextColor = Color.fromRGBO(255, 187, 14, 1);
// const errorTextColor = Color.fromRGBO(255, 69, 69, 1);

// const cardColor = Color.fromRGBO(34, 34, 34, 1);
// const boxShadowColor = Colors.transparent;
// const borderColor = Color.fromRGBO(178, 178, 178, .35);

// const containerShadow = BoxShadow(
//   color: Colors.transparent,
//   blurRadius: 0,
//   offset: Offset.zero,
// );

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: surfaceColor,
    fontFamily: 'Poppins',
    textTheme: textTheme().apply(
      displayColor: primaryTextColor,
    ),
  );
}

TextTheme textTheme() {
  return const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
    ),
    displayMedium: TextStyle(
      fontSize: 24,
    ),
    displaySmall: TextStyle(
      fontSize: 20,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
    ),
    bodyLarge: TextStyle(
      fontSize: 14,
    ),
    bodyMedium: TextStyle(
      fontSize: 12,
    ),
    bodySmall: TextStyle(
      fontSize: 10,
    ),
  );
}