import 'package:ceres_tools_app/core/assets/fonts/flaticon.dart';
import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:heroicons/heroicons.dart';

List<Map<String, dynamic>> sideMenuOptions = [
  {
    'icon': Flaticon.token,
    'title': kSideMenuTokens,
    'path': Routes.TOKENS,
    'type': 'icon'
  },
  {
    'icon': Flaticon.ring,
    'title': kSideMenuPairs,
    'path': Routes.PAIRS,
    'type': 'icon'
  },
  {
    'icon': Flaticon.sprout,
    'title': kSideMenuFarming,
    'path': Routes.FARMING,
    'type': 'icon'
  },
  {
    'icon': Flaticon.flame,
    'title': kSideMenuTracker,
    'path': Routes.TRACKER,
    'type': 'icon'
  },
  {
    'icon': HeroIcons.chartBar,
    'title': kSideMenuCharts,
    'path': Routes.CHART,
    'type': 'heroicon'
  },
  {
    'icon': Icons.star,
    'title': kSideMenuPortfolio,
    'path': Routes.PORTFOLIO,
    'type': 'icon'
  },
  {
    'icon': FontAwesome5Solid.coins,
    'title': kSideMenuReserves,
    'path': Routes.TBC_RESERVES,
    'type': 'icon'
  },
];

List<Map<String, dynamic>> sideMenuSocials = [
  {
    'icon': 'lib/core/assets/images/telegram_icon.png',
    'url': 'https://t.me/cerestoken'
  },
  {
    'icon': 'lib/core/assets/images/twitter_icon.png',
    'url': 'https://twitter.com/TokenCeres'
  },
  {
    'icon': 'lib/core/assets/images/telegram_polka_icon.png',
    'url': 'https://t.me/ceres_polkaswap_bot'
  },
];

List<Map<String, dynamic>> sideMenuTokens = [
  {
    'icon': 'lib/core/assets/images/ceres_icon.png',
    'url':
        'https://ceres-token.s3.eu-central-1.amazonaws.com/docs/Ceres%2BToken%2B-%2BLitepaper.pdf'
  },
  {
    'icon': 'lib/core/assets/images/demeter_icon.png',
    'url':
        'https://ceres-token.s3.eu-central-1.amazonaws.com/docs/Ceres%2BToken%2B-%2BDemeter%2BLitepaper%2B09.12.2021.pdf'
  },
  {
    'icon': 'lib/core/assets/images/hermes_icon.png',
    'url':
        'https://ceres-token.s3.eu-central-1.amazonaws.com/docs/Hermes+Litepaper.pdf'
  },
  {
    'icon': 'lib/core/assets/images/apollo_icon.png',
    'url': 'https://apollo-protocol.gitbook.io/apollo-protocol'
  },
];
