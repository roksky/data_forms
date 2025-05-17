import 'package:flutter/material.dart';

import 'colors.dart';

class FormTheme {
  static TextTheme textThemeStyle = const TextTheme(
    displayLarge: TextStyle(
      color: FormColors.textColorHeader,
      fontWeight: FontWeight.w700,
      fontSize: 12.0,
    ),
    displayMedium: TextStyle(
      color: FormColors.textColor,
      fontWeight: FontWeight.w700,
      fontSize: 11.0,
    ),
    displaySmall: TextStyle(
      color: FormColors.hintTextColor,
      fontWeight: FontWeight.w500,
      fontSize: 9.0,
    ),
    headlineMedium: TextStyle(
      color: FormColors.hintTextColor,
      fontWeight: FontWeight.w400,
      fontSize: 7.0,
    ),
    headlineSmall: TextStyle(
      color: FormColors.red,
      fontWeight: FontWeight.w400,
      fontSize: 7.0,
    ),
    bodyMedium: TextStyle(
      color: FormColors.hintTextColor,
      fontWeight: FontWeight.w400,
      fontSize: 11.0,
    ),
  );

  static TextTheme textThemeDarkStyle = const TextTheme(
    displayLarge: TextStyle(
      color: FormColors.textDarkColorHeader,
      fontWeight: FontWeight.w700,
      fontSize: 12.0,
    ),
    displayMedium: TextStyle(
      color: FormColors.textColorDark,
      fontWeight: FontWeight.w700,
      fontSize: 11.0,
    ),
    displaySmall: TextStyle(
      color: FormColors.hintTextDarkColor,
      fontWeight: FontWeight.w500,
      fontSize: 9.0,
    ),
    headlineMedium: TextStyle(
      color: FormColors.hintTextDarkColor,
      fontWeight: FontWeight.w400,
      fontSize: 7.0,
    ),
    headlineSmall: TextStyle(
      color: FormColors.red,
      fontWeight: FontWeight.w400,
      fontSize: 7.0,
    ),
    bodyMedium: TextStyle(
      color: FormColors.hintTextDarkColor,
      fontWeight: FontWeight.w400,
      fontSize: 11.0,
    ),
  );
}
