import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:flutter/material.dart';

ThemeData lightThemeData() {
  return ThemeData.light();
}

ThemeData darkThemeData() {
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: backgroundColor,
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Montserrat',
        ),
    canvasColor: backgroundColorDark,
    colorScheme: const ColorScheme.dark(
      primary: backgroundPink,
      secondary: backgroundColorLight
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColorDark,
      iconTheme: IconThemeData(
        size: Dimensions.ICON_SIZE,
      ),
    ),
  );
}
