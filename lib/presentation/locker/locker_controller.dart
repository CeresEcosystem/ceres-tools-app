import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:ceres_tools_app/domain/models/locked_item.dart';
import 'package:ceres_tools_app/domain/models/locked_item_list.dart';
import 'package:ceres_tools_app/domain/models/pair.dart';
import 'package:ceres_tools_app/domain/models/token.dart';
import 'package:ceres_tools_app/domain/usecase/get_locked_pairs.dart';
import 'package:ceres_tools_app/domain/usecase/get_locked_tokens.dart';
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
      response = await getLockedPairs.execute(
          pair.baseToken!.toLowerCase(), pair.shortName!.toLowerCase());
    } else {
      Token token = item as Token;
      response = await getLockedTokens.execute(token.shortName!.toLowerCase());
    }

    if (response != null &&
        response['data'] != null &&
        response['data'] is List) {
      LockedItemList lockedItemList = LockedItemList.fromJson(response['data']);
      if (lockedItemList.lockedItems != null &&
          lockedItemList.lockedItems!.isNotEmpty) {
        _lockedItems = lockedItemList.lockedItems;
      }
    }

    _loadingStatus.value = LoadingStatus.READY;
  }
}
