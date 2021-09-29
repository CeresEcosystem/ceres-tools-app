import 'package:ceres_locker_app/presentation/farming/farming_view.dart';
import 'package:ceres_locker_app/presentation/main/main_binding.dart';
import 'package:ceres_locker_app/presentation/main/main_view.dart';
import 'package:ceres_locker_app/presentation/pairs/pairs_view.dart';
import 'package:ceres_locker_app/presentation/tokens/tokens_view.dart';
import 'package:ceres_locker_app/presentation/tracker/tracker_view.dart';
import 'package:get/route_manager.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.TOKENS,
      page: () => TokensView(),
    ),
    GetPage(
      name: Routes.PAIRS,
      page: () => PairsView(),
    ),
    GetPage(
      name: Routes.FARMING,
      page: () => FarmingView(),
    ),
    GetPage(
      name: Routes.TRACKER,
      page: () => TrackerView(),
    ),
  ];
}
