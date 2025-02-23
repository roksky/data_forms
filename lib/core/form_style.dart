import 'package:data_forms/values/colors.dart';
import 'package:data_forms/values/theme.dart';
import 'package:flutter/material.dart';

class FormStyle {
  TextStyle titleTextStyle;
  TextStyle fieldHintStyle;
  TextStyle fieldTextStyle;
  TextStyle errorTextStyle;
  TextStyle helpTextStyle;
  TextStyle sectionTitleStyle;
  Color backgroundFieldColor;
  Color backgroundFieldColorDisable;
  Color backgroundSectionColor;
  Color fieldBorderColor;

  double fieldRadius;
  double sectionRadius;
  double sectionCardElevation;
  double sectionCardPadding;
  String requiredText;

  FormStyle({
    TextStyle? titleStyle,
    Color? backgroundFieldColor,
    Color? backgroundSectionColor,
    Color? fieldBorderColor,
    Color? backgroundFieldColorDisable,
    double? fieldRadius,
    double? sectionRadius,
    double? sectionCardElevation,
    double? sectionCardPadding,
    TextStyle? fieldHintStyle,
    TextStyle? fieldTextStyle,
    TextStyle? errorTextStyle,
    TextStyle? helpTextStyle,
    String? requiredText,
    TextStyle? sectionTitleStyle,
  })  : backgroundSectionColor = backgroundSectionColor ?? FormColors.white,
        backgroundFieldColor =
            backgroundFieldColor ?? FormColors.colorBackground,
        backgroundFieldColorDisable =
            backgroundFieldColorDisable ?? FormColors.colorBackgroundDisable,
        titleTextStyle = titleStyle ?? FormTheme.textThemeStyle.displayMedium!,
        fieldRadius = fieldRadius ?? 10.0,
        sectionRadius = sectionRadius ?? 4.0,
        sectionCardElevation = sectionCardElevation ?? 2.0,
        sectionCardPadding = sectionCardPadding ?? 2.0,
        requiredText = requiredText ?? '',
        fieldHintStyle = fieldHintStyle ?? FormTheme.textThemeStyle.bodyMedium!,
        fieldTextStyle =
            fieldTextStyle ?? FormTheme.textThemeStyle.displayMedium!,
        errorTextStyle =
            errorTextStyle ?? FormTheme.textThemeStyle.headlineSmall!,
        helpTextStyle =
            helpTextStyle ?? FormTheme.textThemeStyle.headlineMedium!,
        sectionTitleStyle =
            sectionTitleStyle ?? FormTheme.textThemeStyle.displayLarge!,
        fieldBorderColor = fieldBorderColor ?? FormColors.white;

  static FormStyle singleSectionFormDefaultStyle = FormStyle(
    backgroundFieldColor: FormColors.white,
    sectionCardElevation: 0.0,
    backgroundSectionColor: Colors.transparent,
    sectionCardPadding: 0.0,
    titleStyle: FormTheme.textThemeStyle.displayMedium,
    fieldTextStyle: FormTheme.textThemeStyle.displayMedium,
    fieldHintStyle: FormTheme.textThemeStyle.bodyMedium!,
    errorTextStyle: FormTheme.textThemeStyle.headlineSmall,
    helpTextStyle: FormTheme.textThemeStyle.headlineMedium,
    sectionTitleStyle: FormTheme.textThemeStyle.displayLarge,
    sectionRadius: 8,
    fieldRadius: 8,
    fieldBorderColor: Colors.white,
  );

  static FormStyle singleSectionFormDefaultDarkStyle = FormStyle(
    backgroundFieldColor: FormColors.black,
    sectionCardElevation: 0.0,
    backgroundSectionColor: Colors.transparent,
    sectionCardPadding: 0.0,
    sectionTitleStyle: FormTheme.textThemeDarkStyle.displayLarge,
    titleStyle: FormTheme.textThemeDarkStyle.displayMedium,
    fieldTextStyle: FormTheme.textThemeDarkStyle.displayMedium,
    fieldHintStyle: FormTheme.textThemeDarkStyle.bodyMedium,
    errorTextStyle: FormTheme.textThemeDarkStyle.headlineSmall,
    helpTextStyle: FormTheme.textThemeDarkStyle.headlineMedium,
    sectionRadius: 8,
    fieldRadius: 8,
    fieldBorderColor: Colors.white,
  );

  static FormStyle multiSectionFormDefaultStyle = FormStyle(
    backgroundFieldColor: FormColors.colorBackground,
    sectionCardElevation: 2.0,
    backgroundSectionColor: FormColors.white,
    sectionCardPadding: 8.0,
    titleStyle: FormTheme.textThemeStyle.displayMedium,
    fieldTextStyle: FormTheme.textThemeStyle.displayMedium,
    fieldHintStyle: FormTheme.textThemeStyle.bodyMedium,
    errorTextStyle: FormTheme.textThemeStyle.headlineSmall,
    helpTextStyle: FormTheme.textThemeStyle.headlineMedium,
    sectionTitleStyle: FormTheme.textThemeStyle.displayLarge,
    sectionRadius: 8,
    fieldRadius: 8,
    fieldBorderColor: Colors.white,
  );

  static FormStyle multiSectionFormDefaultDarkStyle = FormStyle(
    backgroundFieldColor: FormColors.colorBackgroundDark,
    backgroundSectionColor: FormColors.black,
    titleStyle: FormTheme.textThemeDarkStyle.displayMedium,
    fieldTextStyle: FormTheme.textThemeDarkStyle.displayMedium,
    fieldHintStyle: FormTheme.textThemeDarkStyle.bodyMedium,
    errorTextStyle: FormTheme.textThemeDarkStyle.headlineSmall,
    helpTextStyle: FormTheme.textThemeDarkStyle.headlineMedium,
    sectionTitleStyle: FormTheme.textThemeDarkStyle.displayLarge,
    sectionRadius: 8,
    sectionCardElevation: 2.0,
    sectionCardPadding: 8.0,
    fieldRadius: 8,
    fieldBorderColor: Colors.white,
  );
}
