// file for all aplications themes
// right now there is MASSA themeing
// ignore_for_file: annotate_overrides

import 'package:flutter/material.dart';
import 'package:template/globals.dart';
import 'package:template/template_modules/theme/application_theme.dart';

class DesignSystemColors {
  bool get isDark => brightness == Brightness.dark;

  Brightness get brightness => Brightness.dark;
  Color get background => const Color(0xff181D21);
  Color get surface => const Color(0xff263237);
  Color get onSurface => const Color(0xffFFFFFF);
  Color get onBackground => const Color(0xffFFFFFF);
  Color get icon => const Color(0xffFFFFFF);
  Color get primary => const Color(0xff009DFF);
  Color get onPrimary => const Color(0xffFFFFFF);
  Color get secondary => const Color(0xff515A5F);
  Color get onSecondary => const Color(0xffFFFFFF);
}

class DesignSystemColorsDarkOled implements DesignSystemColors {
  bool get isDark => brightness == Brightness.dark;

  Brightness get brightness => Brightness.dark;
  Color get background => Colors.black;
  Color get surface => const Color(0xff181D21);
  Color get onSurface => const Color(0xffFFFFFF);
  Color get onBackground => const Color(0xffFFFFFF);
  Color get icon => const Color(0xffFFFFFF);
  Color get primary => const Color(0xff009DFF);
  Color get onPrimary => const Color(0xffFFFFFF);
  Color get secondary => const Color(0xff515A5F);
  Color get onSecondary => const Color(0xffFFFFFF);
}

class DesignSystemColorsLight extends DesignSystemColors {
  Brightness get brightness => Brightness.light;
  Color get background => const Color(0xffEBEDEE);
  Color get surface => const Color(0xffffffff);
  Color get onBackground => const Color(0xff181D21);
  Color get onSurface => const Color(0xff263237);
  Color get icon => const Color(0xff37474F);
  Color get primary => const Color(0xff009DFF);
  Color get onPrimary => const Color(0xffFFFFFF);
  Color get secondary => const Color(0xff515A5F);
  Color get onSecondary => const Color(0xffFFFFFF);
}

ThemeData buildTheme(DesignSystemColors colors) {
  return ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: colors.primary,
      brightness: colors.brightness,
      background: colors.background,
      surface: colors.surface,
      onSurface: colors.onSurface,
      onBackground: colors.onBackground,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      secondary: colors.secondary,
      onSecondary: colors.onSecondary,
      error: Colors.red,
      onError: Colors.white,
    ),
  ).copyWith(
    scaffoldBackgroundColor: colors.background,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.resolveWith(
          (v) => !v.contains(MaterialState.disabled)
              ? colors.secondary
              : colors.secondary.withOpacity(0.5),
        ),
        foregroundColor: MaterialStateProperty.resolveWith(
          (v) => !v.contains(MaterialState.disabled)
              ? colors.onSecondary
              : colors.onSecondary.withOpacity(0.5),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        foregroundColor: MaterialStateProperty.resolveWith(
          (v) => !v.contains(MaterialState.disabled)
              ? colors.primary
              : colors.primary.withOpacity(0.5),
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.isDark ? colors.surface : colors.onSurface,
      elevation: 0,
    ),
    indicatorColor: colors.isDark ? colors.primary : colors.onSurface,
    toggleableActiveColor: colors.isDark ? colors.primary : colors.onSurface,
    sliderTheme: SliderThemeData(
      activeTrackColor: colors.isDark ? colors.primary : colors.onSurface,
      thumbColor: colors.isDark ? colors.primary : colors.onSurface,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: colors.icon,
    ),
    cardTheme: const CardTheme(elevation: 0),
  );
}

final _lightColors = DesignSystemColorsLight();
final _darkColor = DesignSystemColors();
final _oledDarkColor = DesignSystemColorsDarkOled();

final _applicationTheme = buildTheme(_lightColors);
final _applicationDarkTheme = buildTheme(_darkColor);
final _applicationOledDarkTheme = buildTheme(_oledDarkColor);

final applicationThemes = [
  ApplicationTheme.system(
    'system',
    _applicationTheme,
    _applicationOledDarkTheme,
    () => staticLocalization.theme.systemTheme,
    () => null,
    () => const Icon(Icons.brightness_auto),
  ),
  ApplicationTheme.light(
    'light',
    _applicationTheme,
    () => staticLocalization.theme.lightThemeTitle,
    () => null,
    () => const Icon(Icons.light_mode),
  ),
  ApplicationTheme.dark(
    'dark',
    _applicationDarkTheme,
    () => staticLocalization.theme.darkThemeTitle,
    () => null,
    () => const Icon(Icons.dark_mode),
  ),
  ApplicationTheme.dark(
    'oled-dark',
    _applicationOledDarkTheme,
    () => staticLocalization.theme.darkThemeOledTitle,
    () => staticLocalization.theme.darkThemeOledHint,
    () => const Icon(Icons.mode_night),
  ),
];
