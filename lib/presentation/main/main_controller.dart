import 'package:ceres_locker_app/presentation/farming/farming_view.dart';
import 'package:ceres_locker_app/presentation/pairs/pairs_view.dart';
import 'package:ceres_locker_app/presentation/tokens/tokens_view.dart';
import 'package:ceres_locker_app/presentation/tracker/tracker_view.dart';
import 'package:ceres_locker_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  final List _pages = [Routes.TOKENS, Routes.PAIRS, Routes.FARMING, Routes.TRACKER];
  final _selectedPage = 0.obs;
  Widget currentWidget = TokensView();

  List get pages => _pages;
  int get selectedPage => _selectedPage.value;

  void setSelectedPage(String page) {
    int pageIndex = _pages.indexOf(page);

    if (pageIndex != -1 && pageIndex != _selectedPage.value) {
      _selectedPage.value = pageIndex;
    }
  }

  Widget getWidget() {
    String currentPage = _pages[_selectedPage.value];

    switch (currentPage) {
      case Routes.TOKENS: return TokensView();
      case Routes.PAIRS: return PairsView();
      case Routes.FARMING: return FarmingView();
      case Routes.TRACKER: return TrackerView();
      default: return TokensView();
    }
  }
}
