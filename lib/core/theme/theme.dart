import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:flutter/material.dart';

ThemeData lightThemeData() {
  return ThemeData.light();
}

ThemeData darkThemeData() {
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: backgroundColor,
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Sora',
        ),
    canvasColor: backgroundColorDark,
    colorScheme: const ColorScheme.dark(
      primary: backgroundPink,
      secondary: backgroundColorLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColorDark,
      iconTheme: IconThemeData(
        size: Dimensions.ICON_SIZE,
      ),
    ),
    datePickerTheme: const DatePickerThemeData(
      headerBackgroundColor: backgroundColor,
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: backgroundColor,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
      ),
      contentTextStyle: const TextStyle(color: Colors.white),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: backgroundPink,
      unselectedItemColor: Colors.white.withOpacity(.5),
    ),
  );
}
