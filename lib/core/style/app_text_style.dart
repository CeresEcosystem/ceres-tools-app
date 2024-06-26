import 'package:ceres_tools_app/core/enums/device_screen_type.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:flutter/material.dart';

const headline1 = 96.0;
const headline2 = 60.0;
const headline3 = 48.0;
const headline4 = 34.0;
const headline45 = 30.0;
const headline5 = 24.0;
const headline6 = 20.0;
const title = 18.0;
const subtitle1 = 16.0;
const subtitle2 = 14.0;
const caption = 12.0;
const overline = 10.0;
const overline2 = 8.0;

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

TextStyle buttonLightTextStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: subtitle2,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );
}

TextStyle tokensTitleStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Desktop
        ? title
        : subtitle1,
    fontWeight: FontWeight.w700,
  );
}

TextStyle currentSupplyTextStyle() {
  return const TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

TextStyle tokensAssetIdStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Desktop
        ? subtitle2
        : caption,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.5),
  );
}

TextStyle tokensPriceStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Desktop
        ? headline6
        : title,
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

TextStyle dateTimeFieldTextStyle() {
  return const TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

TextStyle pairsLabelStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
        ? caption
        : subtitle1,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

TextStyle pairsInfoStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
        ? caption
        : subtitle1,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.5),
  );
}

TextStyle pairsLiquidityStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
        ? caption
        : title,
    fontWeight: FontWeight.w700,
    color: backgroundPink,
  );
}

TextStyle farmingLabelStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
        ? title
        : headline6,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

TextStyle farmingInfoStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
        ? title
        : headline6,
    fontWeight: FontWeight.w700,
    color: backgroundPink,
  );
}

TextStyle pairsSumContainerLabelStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
        ? caption
        : title,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.5),
  );
}

TextStyle pairsSumContainerInfoStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
        ? subtitle1
        : headline6,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}

TextStyle tbcReservesSumContainerInfoStyle(
    SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
        ? subtitle2
        : headline4,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}

TextStyle pageTitleStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: headline45,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}

TextStyle pageSubtitleStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w400,
    color: Colors.white.withOpacity(0.5),
  );
}

TextStyle buttonFilterStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: subtitle2,
  );
}

TextStyle trackerBlockLabelTitleStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.5),
  );
}

TextStyle trackerBlockPriceStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: headline5,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}

TextStyle trackerBlockPriceLabelStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: headline5,
    fontWeight: FontWeight.w700,
    color: Colors.white.withOpacity(0.5),
  );
}

TextStyle trackerBlockBlockStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
}

TextStyle trackerBlockHeaderStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.5),
  );
}

TextStyle trackerTitleStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: headline5,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}

TextStyle trackerSubtitleStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w400,
    color: Colors.white.withOpacity(0.5),
  );
}

TextStyle faqsTitleStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}

TextStyle faqsDescriptionStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
}

TextStyle trackerContactTitleStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w500,
    color: backgroundOrange,
  );
}

TextStyle graphTooltipTextStyle() {
  return const TextStyle(
    fontSize: overline,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

TextStyle graphTitleTextStyle() {
  return TextStyle(
    color: Colors.white.withOpacity(0.5),
    fontWeight: FontWeight.w500,
    fontSize: overline2,
  );
}

TextStyle allButtonTextStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

TextStyle tokenButtonTextStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: overline,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

TextStyle emptyListTextStyle(SizingInformation sizingInformation) {
  return const TextStyle(
    fontSize: subtitle2,
    color: Colors.white,
  );
}

TextStyle selectTextStyle() {
  return const TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

TextStyle tvlLabel() {
  return TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w700,
    color: Colors.white.withOpacity(0.5),
  );
}

TextStyle farmingTVL() {
  return const TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w700,
    color: backgroundPink,
  );
}

TextStyle gridHeadingTextStyle() {
  return const TextStyle(
    fontSize: headline45,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}

TextStyle gridItemTitleTextStyle() {
  return const TextStyle(
    fontSize: caption,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}

TextStyle tokenTabTextStyle() {
  return const TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

TextStyle portfolioTabTextStyle() {
  return const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

TextStyle dataTableTextStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
        ? caption
        : subtitle2,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

TextStyle dataTableValueChangeTextStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
        ? overline
        : caption,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

TextStyle dataTableLabelTextStyle() {
  return TextStyle(
    fontSize: caption,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(.5),
  );
}

TextStyle dataTableFooterTextStyle() {
  return const TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}

TextStyle timeFrameChipTextStyle() {
  return const TextStyle(
    fontSize: caption,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

TextStyle chartCurrentTokenTitleTextStyle() {
  return const TextStyle(
    fontSize: subtitle1,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

TextStyle chartCurrentTokenSubtitleTextStyle() {
  return TextStyle(
    fontSize: caption,
    fontWeight: FontWeight.w600,
    color: Colors.white.withOpacity(.5),
  );
}

TextStyle chartFavoriteTokensNoteTextStyle() {
  return TextStyle(
    fontSize: caption,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(.5),
  );
}

TextStyle chartButtonTextStyle() {
  return const TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

TextStyle paginationTextStyle() {
  return const TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

TextStyle paginationPageNumberTextStyle() {
  return const TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

TextStyle tbcReservesLabelTextStyle() {
  return TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(.5),
  );
}

TextStyle tbcReservesInfoTextStyle() {
  return const TextStyle(
    fontSize: subtitle2,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

TextStyle bridgeTransferTextStyle() {
  return const TextStyle(
    fontSize: overline,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

TextStyle swapFiltersTextStyle() {
  return TextStyle(
    fontSize: overline,
    fontWeight: FontWeight.w600,
    color: Colors.white.withOpacity(.6),
  );
}

TextStyle inputLabelTextStyle() {
  return const TextStyle(
    fontSize: subtitle2,
    color: Colors.white,
  );
}

TextStyle tokenHolderLabelTextStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
        ? caption
        : subtitle1,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(.5),
  );
}

TextStyle tokenHolderTitleTextStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
        ? caption
        : subtitle1,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

TextStyle pairLiquidityChartTitleTextStyle(
    SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
        ? subtitle2
        : subtitle1,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

TextStyle tokenPriceConverterTitleTextStyle() {
  return const TextStyle(
    fontSize: subtitle1,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );
}

TextStyle tokenPriceConverterTokenTextStyle() {
  return const TextStyle(
    fontSize: caption,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );
}

TextStyle tokenPriceConverterPriceTextStyle() {
  return const TextStyle(
    fontSize: headline6,
    color: backgroundPink,
    fontWeight: FontWeight.w700,
  );
}

TextStyle burningInfoTextStyle(SizingInformation sizingInformation) {
  return TextStyle(
    fontSize: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
        ? overline
        : caption,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );
}

TextStyle swapsStatsLabel() {
  return TextStyle(
    fontSize: overline,
    color: Colors.white.withOpacity(.5),
    fontWeight: FontWeight.w500,
  );
}

TextStyle swapsStatsInfo() {
  return const TextStyle(
    fontSize: caption,
    color: Colors.white,
    fontWeight: FontWeight.w700,
  );
}

TextStyle tabBarTextStyle() {
  return const TextStyle(
    fontSize: caption,
    fontWeight: FontWeight.w700,
  );
}
