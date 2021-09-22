import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:flutter/material.dart';

const headline1 = 96.0;
const headline2 = 60.0;
const headline3 = 48.0;
const headline4 = 34.0;
const headline5 = 24.0;
const headline6 = 20.0;
const title = 18.0;
const subtitle1 = 16.0;
const subtitle2 = 14.0;
const caption = 12.0;
const overline = 10.0;

TextStyle bannerTitleStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: headline6,
    fontWeight: FontWeight.w700,
  );
}

TextStyle bannerSubtitleStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w400,
  );
}

TextStyle sideMenuTitleStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w500,
  );
}

TextStyle footerTextStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.5),
  );
}

TextStyle errorTitleStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: headline6,
    fontWeight: FontWeight.w500,
  );
}

TextStyle buttonTextStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w500,
  );
}

TextStyle tokensTitleStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w700,
  );
}

TextStyle tokensAssetIdStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: caption,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.5),
  );
}

TextStyle tokensPriceStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: title,
    fontWeight: FontWeight.w700,
    color: backgroundPink,
  );
}

TextStyle searchTextFieldHintStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w400,
    color: Colors.white.withOpacity(0.5),
  );
}

TextStyle searchTextFieldTextStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

TextStyle pairsLabelStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

TextStyle pairsInfoStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.5),
  );
}

TextStyle pairsLiquidityStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w700,
    color: backgroundPink,
  );
}

TextStyle farmingLabelStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: title,
    fontWeight: FontWeight.w300,
    color: Colors.white.withOpacity(0.7),
  );
}

TextStyle farmingInfoStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: title,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}
