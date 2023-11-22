import 'dart:convert';

import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/utils/address_format.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
import 'package:ceres_locker_app/di/injector.dart';
import 'package:ceres_locker_app/domain/models/page_meta.dart';
import 'package:ceres_locker_app/domain/models/pair.dart';
import 'package:ceres_locker_app/domain/models/pair_liquidity.dart';
import 'package:ceres_locker_app/domain/models/pair_liquidity_list.dart';
import 'package:ceres_locker_app/domain/models/wallet.dart';
import 'package:ceres_locker_app/domain/usecase/get_pairs_liquidity.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PairsLiquidityController extends GetxController {
  final getPairLiquidity = Injector.resolve!<GetPairsLiquidity>();

  final _loadingStatus = LoadingStatus.LOADING.obs;

  final List<Wallet> _wallets = [];
  List<PairLiquidity> _pairLiquidities = [];
  PageMeta _pageMeta = PageMeta(0, 0, 0, 0, false, false);

  LoadingStatus get loadingStatus => _loadingStatus.value;
  List<PairLiquidity> get pairLiquidities => _pairLiquidities;
  PageMeta get pageMeta => _pageMeta;

  @override
  void onInit() {
    _getWalletsFromDatabase();
    super.onInit();
  }

  Future _getWalletsFromDatabase() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? walletsJSON = prefs.getStringList(kWallets);

    if (walletsJSON != null && walletsJSON.isNotEmpty) {
      for (String wallet in walletsJSON) {
        _wallets.add(Wallet.fromJson(jsonDecode(wallet)));
      }
    }

    _fetchPairLiquidities();
  }

  void _fetchPairLiquidities([int page = 1]) async {
    Pair pair = Get.arguments;

    final response = await getPairLiquidity.execute(
        pair.baseAssetId!, pair.tokenAssetId!, page);

    if (response != null) {
      PairLiquidityList pairLiquidityList =
          PairLiquidityList.fromJson(response['data']);
      _pageMeta = PageMeta.fromJson(response['meta']);

      if (pairLiquidityList.pairLiquidities.isNotEmpty) {
        List<PairLiquidity> pairLiquiditiesFormatted = [];

        for (final pairLiquidity in pairLiquidityList.pairLiquidities) {
          PairLiquidity pl = pairLiquidity;

          int divisor = 1000000000000000000;
          double firstAssetNumber = double.parse(pl.firstAssetAmount);
          double firstAssetNumberDouble = firstAssetNumber / divisor;
          double secondAssetNumber = double.parse(pl.secondAssetAmount);
          double secondAssetNumberDouble = secondAssetNumber / divisor;

          pl.firstAssetAmountFormatted = formatToCurrency(
              firstAssetNumberDouble,
              showSymbol: false,
              decimalDigits: 2);
          pl.secondAssetAmountFormatted = formatToCurrency(
              secondAssetNumberDouble,
              showSymbol: false,
              decimalDigits: 2);
          pl.transactionTypeFormatted =
              pl.transactionType == 'withdrawLiquidity'
                  ? 'Withdraw'
                  : 'Deposit';
          pl.accountIdFormatted = _wallets
                  .firstWhereOrNull((w) => w.address == pl.signerId)
                  ?.name ??
              formatAddress(pl.signerId);

          pairLiquiditiesFormatted.add(pl);
        }

        _pairLiquidities = pairLiquiditiesFormatted;
      }
    }

    _loadingStatus.value = LoadingStatus.READY;
  }

  void goToFirstPage() {
    if (_pageMeta.hasPreviousPage) {
      _loadingStatus.value = LoadingStatus.LOADING;
      _fetchPairLiquidities();
    }
  }

  void goToPreviousPage() {
    if (_pageMeta.hasPreviousPage) {
      _loadingStatus.value = LoadingStatus.LOADING;
      _fetchPairLiquidities(_pageMeta.pageNumber - 1);
    }
  }

  void goToNextPage() {
    if (_pageMeta.hasNextPage) {
      _loadingStatus.value = LoadingStatus.LOADING;
      _fetchPairLiquidities(_pageMeta.pageNumber + 1);
    }
  }

  void goToLastPage() {
    if (_pageMeta.hasNextPage) {
      _loadingStatus.value = LoadingStatus.LOADING;
      _fetchPairLiquidities(_pageMeta.pageCount);
    }
  }
}
