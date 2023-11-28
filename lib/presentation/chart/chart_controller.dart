import 'dart:async';
import 'dart:convert';

import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/services/global_service.dart';
import 'package:ceres_tools_app/core/utils/address_format.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/image_extension.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:ceres_tools_app/domain/models/favorite_token.dart';
import 'package:ceres_tools_app/domain/models/page_meta.dart';
import 'package:ceres_tools_app/domain/models/swap.dart';
import 'package:ceres_tools_app/domain/models/swap_list.dart';
import 'package:ceres_tools_app/domain/models/token.dart';
import 'package:ceres_tools_app/domain/models/token_list.dart';
import 'package:ceres_tools_app/domain/models/wallet.dart';
import 'package:ceres_tools_app/domain/usecase/get_swaps.dart';
import 'package:ceres_tools_app/domain/usecase/get_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

const kChartToken = 'CHART_TOKEN';

class ChartController extends GetxController {
  final GlobalService _globalService = Get.find<GlobalService>();
  final getTokens = Injector.resolve!<GetTokens>();
  final getSwaps = Injector.resolve!<GetSwaps>();

  final PageController _pageController = PageController();

  final _loadingStatus = LoadingStatus.LOADING.obs;
  final _swapLoadingStatus = LoadingStatus.LOADING.obs;
  final _token = ''.obs;
  final _searchQuery = ''.obs;
  final _showFavoriteTokens = false.obs;

  Timer? _timer;
  io.Socket? _socket;

  InAppWebViewController? _webViewController;

  List<Token> _tokens = [];
  List<String> _addresses = [];

  final _swaps = <Swap>[].obs;
  PageMeta _pageMeta = PageMeta(0, 0, 0, 0, false, false);
  final List<Wallet> _wallets = [];

  PageController get pageController => _pageController;
  LoadingStatus get loadingStatus => _loadingStatus.value;
  LoadingStatus get swapLoadingStatus => _swapLoadingStatus.value;
  String get token => _token.value;
  bool get showFavoriteTokens => _showFavoriteTokens.value;
  List<FavoriteToken> get favoriteTokens => _globalService.favoriteTokens;
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

  PageMeta get pageMeta => _pageMeta;
  List<Swap> get swaps => _swaps;

  void goToSwapPage() {
    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 350), curve: Curves.ease);
  }

  void goToChartPage() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 350), curve: Curves.ease);
  }

  void closeDialog() {
    Get.back();

    if (_searchQuery.value.isNotEmpty) {
      Future.delayed(const Duration(seconds: 1), () {
        _searchQuery.value = '';
      });
    }
  }

  setInAppWebViewController(InAppWebViewController contrl) {
    _webViewController ??= contrl;
  }

  offSocketForAddresses() {
    if (_addresses.isNotEmpty) {
      for (String address in _addresses) {
        _socket?.off(address);
      }
    }
  }

  switchFavoriteTokens() {
    if (!_showFavoriteTokens.value) {
      offSocketForAddresses();

      _token.value = '';
      _showFavoriteTokens.value = true;

      _addresses =
          _globalService.favoriteTokens.map((ft) => ft.assetId).toList();

      if (pageController.page == 0) {
        goToSwapPage();
      }

      _swapLoadingStatus.value = LoadingStatus.LOADING;
      _fetchSwaps();
    }
  }

  Future changeToken(String t, [bool reloadWebView = false]) async {
    if (t != _token.value) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (reloadWebView) {
        _webViewController?.loadUrl(
            urlRequest: URLRequest(
          url: Uri.parse('$kChartURL$t'),
        ));
      }

      _token.value = t;
      prefs.setString(kChartToken, t);

      offSocketForAddresses();

      if (_showFavoriteTokens.value) {
        _showFavoriteTokens.value = false;
      }

      _addresses = [
        _tokens.firstWhere((token) => token.shortName == t).assetId ?? ''
      ];

      _swapLoadingStatus.value = LoadingStatus.LOADING;
      _fetchSwaps();
    }
  }

  onSearch(String text) {
    _searchQuery.value = text;
  }

  bool checkIfFavorite(Token t) {
    return _globalService.checkIfFavorite(t);
  }

  connectSocket() {
    _socket = io.io(
        kSwapsSocketURL,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    _socket?.connect();
  }

  connectToASocketEvent() {
    if (_addresses.isNotEmpty) {
      _socket?.connect();

      for (String address in _addresses) {
        _socket?.on(address, (data) {
          Swap s = Swap.fromJson(data);

          s.inputAsset = _tokens
                  .firstWhereOrNull((t) => t.assetId == s.inputAssetId)
                  ?.shortName ??
              '';
          s.outputAsset = _tokens
                  .firstWhereOrNull((t) => t.assetId == s.outputAssetId)
                  ?.shortName ??
              '';
          s.type = address == s.inputAssetId ? 'Sell' : 'Buy';
          s.inputImageExtension = imageExtension(s.inputAsset);
          s.outputImageExtension = imageExtension(s.outputAsset);
          s.swappedAt = formatDateToLocalTime(s.swappedAt);
          s.formattedAccountId = _wallets
                  .firstWhereOrNull((w) => w.address == s.accountId)
                  ?.name ??
              formatAddress(s.accountId);

          if (_swaps.length == pageMeta.pageSize && !pageMeta.hasNextPage) {
            pageMeta.hasNextPage = true;
          }

          pageMeta.totalCount++;

          _swaps.value = [s, ..._swaps].take(10).toList();
        });
      }
    }
  }

  disconnectSocket() {
    offSocketForAddresses();

    _socket?.disconnect();
  }

  Future _setToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? storedToken = prefs.getString(kChartToken);

    if (Get.arguments != null) {
      _token.value = Get.arguments['token'];

      if (Get.arguments['token'] != storedToken) {
        prefs.setString(kChartToken, Get.arguments['token']);
      }
    } else {
      _token.value = storedToken ?? kTokenName;
    }
  }

  @override
  void onInit() async {
    await _setToken();

    connectSocket();

    fetchTokens();

    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      fetchTokens(true);
    });
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();

    _socket?.dispose();

    super.onClose();
  }

  void _fetchSwaps([int page = 1]) async {
    if (_addresses.isNotEmpty) {
      final response = await getSwaps.execute(_addresses, page);

      if (response != null) {
        SwapList swapList = SwapList.fromJson(response['data']);
        _pageMeta = PageMeta.fromJson(response['meta']);

        if (swapList.swaps.isNotEmpty) {
          List<Swap> swapFormatted = [];

          for (final swap in swapList.swaps) {
            Swap s = swap;
            s.inputAsset = _tokens
                    .firstWhereOrNull((t) => t.assetId == s.inputAssetId)
                    ?.shortName ??
                '';
            s.outputAsset = _tokens
                    .firstWhereOrNull((t) => t.assetId == s.outputAssetId)
                    ?.shortName ??
                '';
            s.type = _addresses[0] == s.inputAssetId ? 'Sell' : 'Buy';
            s.inputImageExtension = imageExtension(s.inputAsset);
            s.outputImageExtension = imageExtension(s.outputAsset);
            s.swappedAt = formatDateToLocalTime(s.swappedAt);
            s.formattedAccountId = _wallets
                    .firstWhereOrNull((w) => w.address == s.accountId)
                    ?.name ??
                formatAddress(s.accountId);
            swapFormatted.add(s);
          }

          _swaps.value = swapFormatted;
        } else {
          _swaps.value = [];
        }

        if (page > 1) {
          disconnectSocket();
        } else {
          connectToASocketEvent();
        }

        _swapLoadingStatus.value = LoadingStatus.READY;
      }
    } else {
      _pageMeta = PageMeta(0, 0, 0, 0, false, false);
      _swaps.value = [];
      _swapLoadingStatus.value = LoadingStatus.READY;
    }
  }

  void goToFirstPage() {
    if (_pageMeta.hasPreviousPage) {
      _swapLoadingStatus.value = LoadingStatus.LOADING;
      _fetchSwaps();
    }
  }

  void goToPreviousPage() {
    if (_pageMeta.hasPreviousPage) {
      _swapLoadingStatus.value = LoadingStatus.LOADING;
      _fetchSwaps(_pageMeta.pageNumber - 1);
    }
  }

  void goToNextPage() {
    if (_pageMeta.hasNextPage) {
      _swapLoadingStatus.value = LoadingStatus.LOADING;
      _fetchSwaps(_pageMeta.pageNumber + 1);
    }
  }

  void goToLastPage() {
    if (_pageMeta.hasNextPage) {
      _swapLoadingStatus.value = LoadingStatus.LOADING;
      _fetchSwaps(_pageMeta.pageCount);
    }
  }

  Future _getWalletsFromDatabase() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? walletsJSON = prefs.getStringList(kWallets);

    if (walletsJSON != null && walletsJSON.isNotEmpty) {
      for (String wallet in walletsJSON) {
        _wallets.add(Wallet.fromJson(jsonDecode(wallet)));
      }

      _fetchSwaps();
    } else {
      _fetchSwaps();
    }
  }

  void fetchTokens([bool refresh = false, bool reloadFromError = false]) async {
    _loadingStatus.value =
        refresh || reloadFromError ? LoadingStatus.IDLE : LoadingStatus.LOADING;

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

        if (!refresh || reloadFromError) {
          _addresses = [
            _tokens
                    .firstWhere((token) => token.shortName == _token.value)
                    .assetId ??
                ''
          ];
          _getWalletsFromDatabase();
        }
      }

      _loadingStatus.value = LoadingStatus.READY;
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
    }
  }
}
