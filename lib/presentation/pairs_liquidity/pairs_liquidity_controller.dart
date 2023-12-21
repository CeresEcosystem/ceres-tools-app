import 'dart:convert';

import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/utils/address_format.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:ceres_tools_app/domain/models/page_meta.dart';
import 'package:ceres_tools_app/domain/models/pair.dart';
import 'package:ceres_tools_app/domain/models/pair_liquidity.dart';
import 'package:ceres_tools_app/domain/models/pair_liquidity_list.dart';
import 'package:ceres_tools_app/domain/models/wallet.dart';
import 'package:ceres_tools_app/domain/usecase/get_pairs_liquidity.dart';
import 'package:ceres_tools_app/domain/usecase/get_pairs_liquidity_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _tabs = ['Liquidity Changes', 'Liquidity Chart'];

class PairsLiquidityController extends GetxController {
  final getPairLiquidity = Injector.resolve!<GetPairsLiquidity>();
  final getPairLiquidityChart = Injector.resolve!<GetPairsLiquidityChart>();

  final _loadingStatus = LoadingStatus.LOADING.obs;
  final _selectedTab = _tabs[0].obs;

  final List<Wallet> _wallets = [];
  List<PairLiquidity> _pairLiquidities = [];
  List _pairLiquidityChartData = [];
  PageMeta _pageMeta = PageMeta(0, 0, 0, 0, false, false);

  List<String> get tabs => _tabs;
  LoadingStatus get loadingStatus => _loadingStatus.value;
  String get selectedTab => _selectedTab.value;
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

  Future _fetchPairLiquidities([int page = 1]) async {
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

  Map<String, dynamic>? get graphData {
    if (_pairLiquidityChartData.isNotEmpty) {
      double maxY = 0;
      double minY = 0;
      double maxX = 0;
      double minX = 0;
      List<Map<String, dynamic>> data = [];

      for (var i = 0; i < _pairLiquidityChartData.length; i++) {
        Map<String, dynamic> item = _pairLiquidityChartData[i];

        double x = dateStringToDouble(item['updatedAt']);
        double y = getDefaultDoubleValueNotNullable(item['liquidity']);

        if (x > 0 && y > 0) {
          if (i == 0) {
            minY = y;
            minX = x;
          }
          if (y > maxY) {
            maxY = y;
          }
          if (y < minY) {
            minY = y;
          }
          if (i == _pairLiquidityChartData.length - 1) {
            maxX = x;
          }
          data.add({...item, 'y': y, 'x': x});
        }
      }

      final intervalY = (maxY - minY) / 4;
      final intervalX = (maxX - minX) / 2;

      return {
        'maxY': maxY,
        'minY': minY,
        'maxX': maxX,
        'minX': minX,
        'intervalY': intervalY > 0 ? intervalY : 1.0,
        'intervalX': intervalX > 0 ? intervalX : 1.0,
        'data': data
      };
    } else {
      return null;
    }
  }

  String getSupplyTooltipData(LineBarSpot touchedSpot) {
    if (graphData != null) {
      Map<String, dynamic> item = List.from(graphData!['data']).firstWhere(
          (spot) => spot['x'] == touchedSpot.x && spot['y'] == touchedSpot.y);
      return 'DATE: ${formatDateAndTime(item['x'])}\nLiquidity: ${formatToCurrency(item['y'])}';
    }

    return '';
  }

  Future _fetchPairLiquidityChart() async {
    Pair pair = Get.arguments;

    final response =
        await getPairLiquidityChart.execute(pair.baseToken!, pair.shortName!);

    if (response != null) {
      _pairLiquidityChartData = response;
      _loadingStatus.value = LoadingStatus.READY;
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
    }
  }

  void changeSelectedTab(String tab) {
    if (tab != _selectedTab.value) {
      _loadingStatus.value = LoadingStatus.LOADING;
      _selectedTab.value = tab;

      if (tab == _tabs[0]) {
        _fetchPairLiquidities();
      } else {
        _fetchPairLiquidityChart();
      }
    }
  }
}
