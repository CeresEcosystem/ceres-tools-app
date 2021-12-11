import 'package:ceres_locker_app/core/assets/fonts/flaticon.dart';
import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/routes/app_routes.dart';

List<Map<String, dynamic>> sideMenuOptions = [
  {'icon': Flaticon.token, 'title': kSideMenuTokens, 'path': Routes.TOKENS, 'type': 'icon'},
  {'icon': Flaticon.ring, 'title': kSideMenuPairs, 'path': Routes.PAIRS, 'type': 'icon'},
  {'icon': Flaticon.sprout, 'title': kSideMenuFarming, 'path': Routes.FARMING, 'type': 'icon'},
  {'icon': Flaticon.flame, 'title': kSideMenuTracker, 'path': Routes.TRACKER, 'type': 'icon'},
  {'icon': kChartIcon, 'title': kSideMenuCharts, 'path': Routes.CHART, 'type': 'svg'},
];

List<Map<String, dynamic>> sideMenuSocials = [
  {'icon': 'lib/core/assets/images/telegram_icon.png', 'url': 'https://t.me/cerestoken'},
  {'icon': 'lib/core/assets/images/twitter_icon.png', 'url': 'https://twitter.com/TokenCeres'},
  {'icon': 'lib/core/assets/images/telegram_polka_icon.png', 'url': 'https://t.me/ceres_polkaswap_bot'},
];

List<Map<String, dynamic>> sideMenuTokens = [
  {'icon': 'lib/core/assets/images/ceres_icon.png', 'url': 'https://cerestoken.s3.eu-central-1.amazonaws.com/docs/Ceres+Token+-+Litepaper.pdf'},
  {'icon': 'lib/core/assets/images/demeter_icon.png', 'url': 'https://cerestoken.s3.eu-central-1.amazonaws.com/docs/Ceres+Token+-+Demeter+Litepaper+09.12.2021.pdf'},
  {'icon': 'lib/core/assets/images/hermes_icon.png', 'url': null},
  {'icon': 'lib/core/assets/images/apollo_icon.png', 'url': null},
];
