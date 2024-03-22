import 'dart:convert';
import 'dart:math';

import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/utils/address_format.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:ceres_tools_app/domain/models/page_meta.dart';
import 'package:ceres_tools_app/domain/models/pair.dart';
import 'package:ceres_tools_app/domain/models/pair_liquidity_provider.dart';
import 'package:ceres_tools_app/domain/models/pair_liquidity_provider_list.dart';
import 'package:ceres_tools_app/domain/models/wallet.dart';
import 'package:ceres_tools_app/domain/usecase/get_pairs_liquidity_providers.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const pageLimiter = 10;

class PairsProvidersController extends GetxController {
  final getPairsLiquidityProviders =
      Injector.resolve!<GetPairsLiquidityProviders>();

  final _loadingStatus = LoadingStatus.LOADING.obs;

  final List<Wallet> _wallets = [];
  List<PairLiquidityProvider> _allPairLiquidityProviders = [];
  final _pageMeta = PageMeta(0, 0, 0, 0, false, false).obs;

  LoadingStatus get loadingStatus => _loadingStatus.value;
  List<PairLiquidityProvider> get pairLiquidityProviders {
    int startIndex = (_pageMeta.value.pageNumber - 1) * pageLimiter;
    int endIndex =
        min(startIndex + pageLimiter, _allPairLiquidityProviders.length);

    return _allPairLiquidityProviders.sublist(startIndex, endIndex);
  }

  PageMeta get pageMeta => _pageMeta.value;

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

    _fetchPairLiquidityProviders();
  }

  void _setPageMeta(int pageNumber) {
    int pageCount = (_allPairLiquidityProviders.length / pageLimiter).ceil();

    _pageMeta.value = PageMeta(
      pageNumber,
      pageLimiter,
      _allPairLiquidityProviders.length,
      pageCount,
      pageNumber > 1,
      pageNumber < pageCount,
    );
  }

  Future _fetchPairLiquidityProviders() async {
    Pair pair = Get.arguments;

    final response = await getPairsLiquidityProviders.execute(
        pair.baseAssetId!, pair.tokenAssetId!);

    if (response != null) {
      PairLiquidityProviderList pairLiquidityProviderList =
          PairLiquidityProviderList.fromJson(response);

      if (pairLiquidityProviderList.pairLiquidityProviders.isNotEmpty) {
        List<PairLiquidityProvider> pairLiquidityProvidersFormatted = [];

        for (final pairLiquidityProvider
            in pairLiquidityProviderList.pairLiquidityProviders) {
          PairLiquidityProvider plp = pairLiquidityProvider;
          plp.liquidityFormatted = formatToCurrency(
            plp.liquidity,
            showSymbol: false,
            decimalDigits: 2,
          );
          plp.accountIdFormatted = _wallets
                  .firstWhereOrNull((w) => w.address == plp.address)
                  ?.name ??
              formatAddress(plp.address);

          pairLiquidityProvidersFormatted.add(plp);
        }

        _allPairLiquidityProviders = pairLiquidityProvidersFormatted;
        _setPageMeta(1);
      }
    }

    _loadingStatus.value = LoadingStatus.READY;
  }

  void goToFirstPage() {
    if (_pageMeta.value.hasPreviousPage) {
      _setPageMeta(1);
    }
  }

  void goToPreviousPage() {
    if (_pageMeta.value.hasPreviousPage) {
      _setPageMeta(_pageMeta.value.pageNumber - 1);
    }
  }

  void goToNextPage() {
    if (_pageMeta.value.hasNextPage) {
      _setPageMeta(_pageMeta.value.pageNumber + 1);
    }
  }

  void goToLastPage() {
    if (_pageMeta.value.hasNextPage) {
      _setPageMeta(_pageMeta.value.pageCount);
    }
  }
}
