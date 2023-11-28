import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/db/database_helper.dart';
import 'package:ceres_tools_app/data/datasource/banner_datasource.dart';
import 'package:ceres_tools_app/data/datasource/price_alert_datasource.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:ceres_tools_app/domain/models/banners.dart';
import 'package:ceres_tools_app/domain/models/favorite_token.dart';
import 'package:ceres_tools_app/domain/models/favorite_token_json.dart';
import 'package:ceres_tools_app/domain/models/initial_favs.dart';
import 'package:ceres_tools_app/domain/models/side_menu_page.dart';
import 'package:ceres_tools_app/domain/models/token.dart';
import 'package:ceres_tools_app/routes/app_routes.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class GlobalService extends GetxService {
  final datasource = Injector.resolve!<BannerDatasource>();
  final priceAlertDatasource = Injector.resolve!<PriceAlertDatasource>();

  final _favoriteTokens = <FavoriteToken>[].obs;

  String? _oneSignalId;

  List<FavoriteToken> get favoriteTokens => _favoriteTokens;

  Future _postInitialFavs() async {
    if (_oneSignalId != null) {
      InitialFavs initialFavs = InitialFavs(
        deviceId: _oneSignalId,
        tokens: _favoriteTokens.map((ft) => ft.assetId).toList(),
      );

      try {
        await priceAlertDatasource.postInitialFavs(initialFavs);
      } on DioException catch (_) {}
    }
  }

  Future getFavoriteTokens() async {
    List<FavoriteToken> favs = [];

    DatabaseHelper.instance.queryAllRows().then((favorites) {
      for (final token in favorites) {
        favs.add(FavoriteToken(assetId: token['assetId']));
      }
    });

    _favoriteTokens.value = favs;
  }

  void addTokenToFavorites(Token t) async {
    if (t.assetId != null) {
      FavoriteToken favToken = FavoriteToken(assetId: t.assetId!);
      int success = await DatabaseHelper.instance.insert(favToken);

      if (success != 0) {
        _favoriteTokens.add(favToken);
        if (_oneSignalId != null) {
          FavoriteTokenJSON favoriteToken =
              FavoriteTokenJSON(deviceId: _oneSignalId, token: t.assetId);
          await priceAlertDatasource.addTokenToFavorites(favoriteToken);
        }
      }
    }
  }

  void removeTokenFromFavorites(Token t) async {
    if (t.assetId != null) {
      await DatabaseHelper.instance.delete(t.assetId!);

      _favoriteTokens.removeWhere((element) => element.assetId == t.assetId);

      if (_oneSignalId != null) {
        await priceAlertDatasource.removeTokenFromFavorites(
            _oneSignalId!, t.assetId!);
      }
    }
  }

  bool checkIfFavorite(Token t) {
    FavoriteToken fToken = _favoriteTokens.firstWhere(
        (FavoriteToken token) => token.assetId == t.assetId,
        orElse: () => FavoriteToken(assetId: ''));
    return fToken.assetId.isNotEmpty;
  }

  Future setOneSignal() async {
    _oneSignalId = OneSignal.User.pushSubscription.id;

    if (_oneSignalId != null) {
      await OneSignal.login(_oneSignalId!);

      OneSignal.Notifications.addClickListener((event) {
        if (event.notification.additionalData != null &&
            event.notification.additionalData!['symbol'] != null) {
          SideMenuPage.sideMenuPage.setActivePage(kSideMenuCharts);
          Get.offAllNamed(
            Routes.CHART,
            arguments: {
              'token': event.notification.additionalData!['symbol'],
              'replace': true
            },
          );
        }
      });

      _postInitialFavs();
    }
  }

  Future<GlobalService> init() async {
    try {
      await getFavoriteTokens();
      final response = await datasource.getBanners();

      if (response != null) {
        Banners.instance.setBanners(response);
      }
    } on DioException catch (_) {}

    return this;
  }
}
