import 'package:flutter/material.dart';

class ApplicationTheme {
  const ApplicationTheme.system(
    this.id,
    this.lightData,
    this.darkData,
    this.getTitle,
    this.getSubtitle,
    this.getIcon,
  ) : themeMode = ThemeMode.system;

  const ApplicationTheme.light(
    this.id,
    this.lightData,
    this.getTitle,
    this.getSubtitle,
    this.getIcon,
  )   : themeMode = ThemeMode.light,
        darkData = null;

  const ApplicationTheme.dark(
    this.id,
    this.darkData,
    this.getTitle,
    this.getSubtitle,
    this.getIcon,
  )   : themeMode = ThemeMode.dark,
        lightData = null;

  final String id;

  // functions allow get reactive values after rebuild
  final ThemeMode themeMode;

  final ThemeData? lightData;
  final ThemeData? darkData;

  final String Function() getTitle;
  final String? Function() getSubtitle;
  final Widget? Function() getIcon;

  ThemeData getThemeData(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return ((isDark ? darkData : lightData) ?? lightData ?? darkData)!;
  }
}
