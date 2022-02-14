import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/di/injector.dart';
import 'package:ceres_locker_app/domain/models/locked_item.dart';
import 'package:ceres_locker_app/domain/models/locked_item_list.dart';
import 'package:ceres_locker_app/domain/models/pair.dart';
import 'package:ceres_locker_app/domain/models/token.dart';
import 'package:ceres_locker_app/domain/usecase/get_locked_pairs.dart';
import 'package:ceres_locker_app/domain/usecase/get_locked_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LockerController extends GetxController {
  final getLockedTokens = Injector.resolve!<GetLockedTokens>();
  final getLockedPairs = Injector.resolve!<GetLockedPairs>();

  final _loadingStatus = LoadingStatus.READY.obs;

  List<LockedItem>? _lockedItems;

  LoadingStatus get loadingStatus => _loadingStatus.value;
  List<LockedItem> get lockedItems => _lockedItems ?? [];

  @override
  void onInit() {
    fetchLockedItems();
    super.onInit();
  }

  void fetchLockedItems() async {
    final args = Get.arguments;
    bool isPair = args['isPair'];
    final item = args['lockerItem'];

    _loadingStatus.value = LoadingStatus.LOADING;

    Map<String, dynamic>? response;

    if (isPair) {
      Pair pair = item as Pair;
      response = await getLockedPairs.execute(pair.shortName!.toLowerCase());
    } else {
      Token token = item as Token;
      response = await getLockedTokens.execute(token.shortName!.toLowerCase());
    }

    if (response != null && response['data'] != null && response['data'] is List) {
      LockedItemList lockedItemList = LockedItemList.fromJson(response['data']);
      if (lockedItemList.lockedItems != null && lockedItemList.lockedItems!.isNotEmpty) {
        _lockedItems = lockedItemList.lockedItems;
      }
    }

    _loadingStatus.value = LoadingStatus.READY;
  }

  void copyAsset(String? assetId) {
    if (assetId != null && assetId.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: assetId));
      Get.snackbar(
        'Copied Account:',
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
}
