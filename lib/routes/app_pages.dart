import 'package:ceres_locker_app/presentation/chart/chart_binding.dart';
import 'package:ceres_locker_app/presentation/chart/chart_view.dart';
import 'package:ceres_locker_app/presentation/farming/farming_binding.dart';
import 'package:ceres_locker_app/presentation/farming/farming_view.dart';
import 'package:ceres_locker_app/presentation/locker/locker_binding.dart';
import 'package:ceres_locker_app/presentation/locker/locker_view.dart';
import 'package:ceres_locker_app/presentation/pairs/pairs_binding.dart';
import 'package:ceres_locker_app/presentation/pairs/pairs_view.dart';
import 'package:ceres_locker_app/presentation/portfolio/portfolio_binding.dart';
import 'package:ceres_locker_app/presentation/portfolio/portfolio_view.dart';
import 'package:ceres_locker_app/presentation/tokens/tokens_binding.dart';
import 'package:ceres_locker_app/presentation/tokens/tokens_view.dart';
import 'package:ceres_locker_app/presentation/tracker/tracker_binding.dart';
import 'package:ceres_locker_app/presentation/tracker/tracker_view.dart';
import 'package:get/route_manager.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.TOKENS,
      page: () => TokensView(),
      binding: TokensBinding(),
    ),
    GetPage(
      name: Routes.PAIRS,
      page: () => PairsView(),
      binding: PairsBinding(),
    ),
    GetPage(
      name: Routes.FARMING,
      page: () => FarmingView(),
      binding: FarmingBinding(),
    ),
    GetPage(
      name: Routes.TRACKER,
      page: () => TrackerView(),
      binding: TrackerBinding(),
    ),
    GetPage(
      name: Routes.CHART,
      page: () => const ChartView(),
      binding: ChartBinding(),
    ),
    GetPage(
      name: Routes.LOCKER,
      page: () => const LockerView(),
      binding: LockerBinding(),
    ),
    GetPage(
      name: Routes.PORTFOLIO,
      page: () => PortfolioView(),
      binding: PortfolioBinding(),
    ),
  ];
}
