import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/routes/app_routes.dart';

List<Map<String, dynamic>> sideMenuOptions = [
  {'icon': 'lib/core/assets/images/tokens_icon.png', 'title': kSideMenuTokens, 'path': Routes.TOKENS, 'disabled': false},
  {'icon': 'lib/core/assets/images/pairs_icon.png', 'title': kSideMenuPairs, 'path': Routes.PAIRS, 'disabled': false},
  {'icon': 'lib/core/assets/images/farming_icon.png', 'title': kSideMenuFarming, 'path': Routes.FARMING, 'disabled': false},
  {'icon': 'lib/core/assets/images/tracker_icon.png', 'title': kSideMenuTracker, 'path': Routes.TRACKER, 'disabled': true},
];

List<Map<String, dynamic>> sideMenuSocials = [
  {'icon': 'lib/core/assets/images/telegram_icon.png', 'url': 'https://t.me/cerestoken'},
  {'icon': 'lib/core/assets/images/twitter_icon.png', 'url': 'https://twitter.com/TokenCeres'},
  {'icon': 'lib/core/assets/images/telegram_polka_icon.png', 'url': 'https://t.me/ceres_polkaswap_bot'},
];

List<Map<String, dynamic>> sideMenuTokens = [
  {'icon': 'lib/core/assets/images/ceres_icon.png', 'url': 'https://04990320fa84123c2e4f-10907fb2d518f3940ba5c7cf5313918e.ssl.cf5.rackcdn.com/docs/CeresToken%20Litepaper.pdf'},
  {'icon': 'lib/core/assets/images/demeter_icon.png', 'url': null},
  {'icon': 'lib/core/assets/images/hermes_icon.png', 'url': null},
  {'icon': 'lib/core/assets/images/apollo_icon.png', 'url': null},
];
