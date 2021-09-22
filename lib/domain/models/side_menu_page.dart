import 'package:ceres_locker_app/core/constants/constants.dart';

class SideMenuPage {
  static final SideMenuPage sideMenuPage = SideMenuPage._internal();
  String _activePage = kSideMenuTokens;

  factory SideMenuPage() {
    return sideMenuPage;
  }

  SideMenuPage._internal();

  String get activePage => _activePage;

  void setActivePage(String page) {
    _activePage = page;
  }
}
