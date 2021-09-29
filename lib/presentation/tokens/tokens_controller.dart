import 'dart:async';

import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/di/injector.dart';
import 'package:ceres_locker_app/domain/models/token.dart';
import 'package:ceres_locker_app/domain/models/token_list.dart';
import 'package:ceres_locker_app/domain/usecase/get_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TokensController extends GetxController {
  final getTokens = Injector.resolve!<GetTokens>();

  Timer? _timer;

  final _loadingStatus = LoadingStatus.READY.obs;
  List<Token>? _tokens;
  var searchQueary = ''.obs;

  LoadingStatus get loadingStatus => _loadingStatus.value;
  List<Token> get tokens {
    if (_tokens != null && _tokens!.isNotEmpty) {
      return _tokens!.where((token) {
        if (token.price != null && token.price! <= 0) return false;
        if (token.fullName != null && token.assetId != null) {
          return token.fullName!.toUpperCase().contains(searchQueary.value.toUpperCase()) || token.assetId!.toUpperCase().contains(searchQueary.value.toUpperCase());
        }

        return false;
      }).toList();
    }

    return [];
  }

  @override
  void onInit() {
    _timer = Timer.periodic(const Duration(minutes: 2), (timer) {
      fetchTokens(true);
    });

    fetchTokens();
    super.onInit();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
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
        _tokens = tokenList.tokens;
        _tokens!.sort((token1, token2) {
          if (token1.priceOrder != null && token2.priceOrder != null) {
            return token1.priceOrder!.compareTo(token2.priceOrder!);
          }

          return 0;
        });
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
}
