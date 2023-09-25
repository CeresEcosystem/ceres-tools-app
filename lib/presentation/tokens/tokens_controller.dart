import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/db/database_helper.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/utils/image_extension.dart';
import 'package:ceres_locker_app/di/injector.dart';
import 'package:ceres_locker_app/domain/models/favorite_token.dart';
import 'package:ceres_locker_app/domain/models/token.dart';
import 'package:ceres_locker_app/domain/models/token_list.dart';
import 'package:ceres_locker_app/domain/usecase/get_tokens.dart';
import 'package:ceres_locker_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TokensController extends GetxController {
  final getTokens = Injector.resolve!<GetTokens>();

  final _loadingStatus = LoadingStatus.READY.obs;
  List<Token>? _tokens;
  var searchQueary = ''.obs;

  var favoriteTokens = <FavoriteToken>[].obs;
  final _showOnlyFavorites = false.obs;

  bool get showOnlyFavorites => _showOnlyFavorites.value;

  LoadingStatus get loadingStatus => _loadingStatus.value;
  List<Token> get tokens {
    if (_tokens != null && _tokens!.isNotEmpty) {
      return _tokens!.where((token) {
        token.isFavorite = checkIfFavorite(token);
        if (token.price != null && token.price! <= 0) return false;
        if (token.fullName != null && token.assetId != null) {
          return (token.fullName!
                      .toUpperCase()
                      .contains(searchQueary.value.toUpperCase()) ||
                  token.assetId!
                      .toUpperCase()
                      .contains(searchQueary.value.toUpperCase())) &&
              (!_showOnlyFavorites.value || token.isFavorite);
        }

        return false;
      }).toList();
    }

    return [];
  }

  Future favorites() async {
    DatabaseHelper.instance.queryAllRows().then((favorites) {
      for (var token in favorites) {
        favoriteTokens.add(FavoriteToken(assetId: token['assetId']));
      }
    });
  }

  void setShowOnlyFavorites(bool show) {
    if (show != _showOnlyFavorites.value) {
      _showOnlyFavorites.value = show;
    }
  }

  @override
  void onInit() {
    favorites();
    fetchTokens();
    super.onInit();
  }

  bool checkIfFavorite(Token t) {
    FavoriteToken fToken = favoriteTokens.firstWhere(
        (FavoriteToken token) => token.assetId == t.assetId,
        orElse: () => FavoriteToken(assetId: ''));
    return fToken.assetId.isNotEmpty;
  }

  void addTokenToFavorites(Token t) async {
    if (t.assetId != null) {
      int success = await DatabaseHelper.instance
          .insert(FavoriteToken(assetId: t.assetId!));

      if (success != 0) {
        favoriteTokens.add(FavoriteToken(assetId: t.assetId!));
      }
    }
  }

  void removeTokenFromFavorites(Token t) async {
    if (t.assetId != null) {
      await DatabaseHelper.instance.delete(t.assetId!);

      favoriteTokens.removeWhere((element) => element.assetId == t.assetId);
    }
  }

  void onTyping(String text) {
    searchQueary.value = text;
  }

  void fetchTokens([bool refresh = false]) async {
    _loadingStatus.value = refresh ? LoadingStatus.IDLE : LoadingStatus.LOADING;

    final response = await getTokens.execute();

    if (response != null) {
      TokenList tokenList = TokenList.fromJson(response);

      if (tokenList.tokens != null && tokenList.tokens!.isNotEmpty) {
        for (Token t in tokenList.tokens!) {
          if (pngIcons.contains(t.shortName)) {
            t.imageExtension = kImagePNGExtension;
          }
        }
        _tokens = tokenList.tokens;
      }

      if (favoriteTokens.isNotEmpty) {
        _showOnlyFavorites.value = true;
      }

      _loadingStatus.value = LoadingStatus.READY;
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
    }
  }

  void copyAsset(String assetId) {
    Clipboard.setData(ClipboardData(text: assetId));
    Get.snackbar(
      'Copied assetID:',
      assetId,
      backgroundColor: backgroundColorLight,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 500),
      isDismissible: false,
      margin: const EdgeInsets.all(0),
      snackStyle: SnackStyle.GROUNDED,
    );
  }

  void openChartForToken(String? token) {
    if (token != null) {
      Get.toNamed(Routes.CHART, arguments: token);
    }
  }
}
