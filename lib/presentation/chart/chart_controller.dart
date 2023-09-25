import 'dart:async';

import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/db/database_helper.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/utils/image_extension.dart';
import 'package:ceres_locker_app/di/injector.dart';
import 'package:ceres_locker_app/domain/models/favorite_token.dart';
import 'package:ceres_locker_app/domain/models/token.dart';
import 'package:ceres_locker_app/domain/models/token_list.dart';
import 'package:ceres_locker_app/domain/usecase/get_tokens.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class ChartController extends GetxController {
  final getTokens = Injector.resolve!<GetTokens>();

  final _loadingStatus = LoadingStatus.READY.obs;
  final _token = ''.obs;
  final _searchQuery = ''.obs;

  Timer? _timer;

  InAppWebViewController? _webViewController;

  List<Token> _tokens = [];
  final List<FavoriteToken> _favoriteTokens = [];

  LoadingStatus get loadingStatus => _loadingStatus.value;
  String get token => _token.value;
  InAppWebViewController? get webViewController => _webViewController;
  List<Token> get tokens {
    return _tokens.where((token) {
      if (token.price != null && token.price! <= 0) return false;
      if (token.fullName != null && token.assetId != null) {
        return (token.fullName!
                .toUpperCase()
                .contains(_searchQuery.value.toUpperCase()) ||
            token.assetId!
                .toUpperCase()
                .contains(_searchQuery.value.toUpperCase()));
      }

      return false;
    }).toList();
  }

  setInAppWebViewController(InAppWebViewController contrl) {
    _webViewController ??= contrl;
  }

  changeToken(String t, [bool reloadWebView = false]) {
    if (t != _token.value) {
      _token.value = t;
      if (reloadWebView) {
        _webViewController?.loadUrl(
            urlRequest: URLRequest(
          url: Uri.parse('$kChartURL$t'),
        ));
      }
    }
  }

  onSearch(String text) {
    _searchQuery.value = text;
  }

  bool checkIfFavorite(Token t) {
    FavoriteToken fToken = _favoriteTokens.firstWhere(
        (FavoriteToken token) => token.assetId == t.assetId,
        orElse: () => FavoriteToken(assetId: ''));
    return fToken.assetId.isNotEmpty;
  }

  @override
  void onInit() {
    String t = Get.arguments ?? kTokenName;
    _token.value = t;
    _fetchFavoriteTokens();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      fetchTokens(true);
    });
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future _fetchFavoriteTokens() async {
    DatabaseHelper.instance.queryAllRows().then((favorites) {
      for (final token in favorites) {
        _favoriteTokens.add(FavoriteToken(assetId: token['assetId']));
      }
      fetchTokens();
    });
  }

  void fetchTokens([bool refresh = false]) async {
    _loadingStatus.value = refresh ? LoadingStatus.IDLE : LoadingStatus.LOADING;

    final response = await getTokens.execute();

    if (response != null) {
      TokenList tokenList = TokenList.fromJson(response);

      if (tokenList.tokens != null && tokenList.tokens!.isNotEmpty) {
        List<Token> favoriteTokens = [];
        List<Token> otherTokens = [];

        for (final t in tokenList.tokens!) {
          bool isFavorite = checkIfFavorite(t);

          if (pngIcons.contains(t.shortName)) {
            t.imageExtension = kImagePNGExtension;
          }

          if (isFavorite) {
            t.isFavorite = true;
            favoriteTokens.add(t);
          } else {
            otherTokens.add(t);
          }
        }

        _tokens = [...favoriteTokens, ...otherTokens];
      }

      _loadingStatus.value = LoadingStatus.READY;
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
    }
  }
}
