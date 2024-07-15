import 'dart:math';

import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:ceres_tools_app/domain/models/demeter_farm.dart';
import 'package:ceres_tools_app/domain/models/demeter_farm_list.dart';
import 'package:ceres_tools_app/domain/models/demeter_pool.dart';
import 'package:ceres_tools_app/domain/models/demeter_pool_list.dart';
import 'package:ceres_tools_app/domain/models/farm.dart';
import 'package:ceres_tools_app/domain/models/pair.dart';
import 'package:ceres_tools_app/domain/models/pair_list.dart';
import 'package:ceres_tools_app/domain/models/token.dart';
import 'package:ceres_tools_app/domain/models/token_list.dart';
import 'package:ceres_tools_app/domain/models/tvl.dart';
import 'package:ceres_tools_app/domain/usecase/get_demeter_farms.dart';
import 'package:ceres_tools_app/domain/usecase/get_demeter_pools.dart';
import 'package:ceres_tools_app/domain/usecase/get_farming.dart';
import 'package:ceres_tools_app/domain/usecase/get_farming_tvl.dart';
import 'package:ceres_tools_app/domain/usecase/get_pairs.dart';
import 'package:ceres_tools_app/domain/usecase/get_token_infos.dart';
import 'package:ceres_tools_app/domain/usecase/get_tokens.dart';
import 'package:get/get.dart';

final _tabs = ['Demeter', 'Hermes', 'PSWAP'];

class FarmingController extends GetxController {
  final getFarming = Injector.resolve!<GetFarming>();
  final getFarmingTVL = Injector.resolve!<GetFarmingTVL>();
  final getPairs = Injector.resolve!<GetPairs>();
  final getTokens = Injector.resolve!<GetTokens>();
  final getTokenInfos = Injector.resolve!<GetTokenInfos>();
  final getDemeterFarms = Injector.resolve!<GetDemeterFarms>();
  final getDemeterPools = Injector.resolve!<GetDemeterPools>();

  final _loadingStatus = LoadingStatus.READY.obs;
  final _selectedTab = _tabs[0].obs;

  late Farm? _farm;
  Map<String, List<Map<String, dynamic>>> _demeterFarmsAndPools = {
    'farms': [],
    'pools': []
  };
  String _tvl = '\$0';

  LoadingStatus get loadingStatus => _loadingStatus.value;
  List<String> get tabs => _tabs;
  String get selectedTab => _selectedTab.value;
  Farm? get farm => _farm;
  Map<String, List<Map<String, dynamic>>> get demeterFarmsAndPools =>
      _demeterFarmsAndPools;
  String get tvl => _tvl;

  void onTabChange(String tab) {
    if (tab != _selectedTab.value) {
      _selectedTab.value = tab;
      fetchFarming(true);
    }
  }

  @override
  void onInit() {
    fetchFarming();
    super.onInit();
  }

  Future fetchPSWAPFarming() async {
    final response = await getFarming.execute();

    if (response != null) {
      _farm = Farm.fromJson(response);
      _loadingStatus.value = LoadingStatus.READY;
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
    }
  }

  Future<List<Map<String, dynamic>>> fetchDemeterFarms(
      PairList pairs, TokenList tokens, Map<String, dynamic> tokenInfos) async {
    final response = await getDemeterFarms.execute();

    if (response != null) {
      DemeterFarmList demeterFarmList = DemeterFarmList.fromJson(response);
      List<DemeterFarm>? demeterFarms = demeterFarmList.demeterFarms;

      if (demeterFarms != null && demeterFarms.isNotEmpty) {
        if (_selectedTab.value == 'Hermes') {
          demeterFarms =
              demeterFarms.where((f) => f.poolAsset == kHMXAddress).toList();
        }

        final List<Map<String, dynamic>> farmsArray = [];

        for (DemeterFarm farm in demeterFarms) {
          if (!farm.isRemoved) {
            final Pair pair = pairs.pairs!.firstWhere((p) =>
                p.baseAssetId == farm.baseAssetId &&
                p.tokenAssetId == farm.poolAsset);
            final Token rewardToken =
                tokens.tokens!.firstWhere((t) => t.assetId == farm.rewardAsset);
            final double totalLiquidity =
                double.parse(farm.tvlPercent) * (pair.liquidity! / 100);
            final Map<String, dynamic> tokenInfo =
                tokenInfos[rewardToken.assetId]!;
            final tokenPerBlock =
                BigInt.parse(tokenInfo['tokenPerBlock']!.replaceAll(',', '')) /
                    BigInt.from(pow(10, 18));
            final farmsAllocation = BigInt.parse(
                    tokenInfo['farmsAllocation']!.replaceAll(',', '')) /
                BigInt.from(pow(10, 18));
            final apr = ((tokenPerBlock *
                        farmsAllocation *
                        5256000 *
                        (farm.multiplierPercent / 100) *
                        rewardToken.price!) /
                    totalLiquidity) *
                100;

            final Map<String, dynamic> data = {
              'token': pair.shortName,
              'earn': rewardToken.shortName,
              'totalLiquidity': totalLiquidity,
              'apr': apr,
              ...farm.toJson(),
            };

            farmsArray.add(data);
          }
        }

        farmsArray.sort((item1, item2) =>
            (item2['apr'] as double).compareTo(item1['apr'] as double));

        return farmsArray;
      } else {
        return [];
      }
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchDemeterPools(
      TokenList tokens, Map<String, dynamic> tokenInfos) async {
    final response = await getDemeterPools.execute();

    if (response != null) {
      DemeterPoolList demeterPoolList = DemeterPoolList.fromJson(response);
      List<DemeterPool>? demeterPools = demeterPoolList.demeterPools;

      if (demeterPools != null && demeterPools.isNotEmpty) {
        if (_selectedTab.value == 'Hermes') {
          demeterPools =
              demeterPools.where((f) => f.poolAsset == kHMXAddress).toList();
        }

        final List<Map<String, dynamic>> poolsArray = [];

        for (DemeterPool pool in demeterPools) {
          if (!pool.isRemoved) {
            final Token token =
                tokens.tokens!.firstWhere((t) => t.assetId == pool.poolAsset);
            final Token rewardToken =
                tokens.tokens!.firstWhere((t) => t.assetId == pool.rewardAsset);
            final double stakedTotal = pool.totalStaked * token.price!;
            final Map<String, dynamic> tokenInfo =
                tokenInfos[rewardToken.assetId]!;
            final tokenPerBlock =
                BigInt.parse(tokenInfo['tokenPerBlock']!.replaceAll(',', '')) /
                    BigInt.from(pow(10, 18));
            final stakingAllocation = BigInt.parse(
                    tokenInfo['stakingAllocation']!.replaceAll(',', '')) /
                BigInt.from(pow(10, 18));
            final apr = ((tokenPerBlock *
                        stakingAllocation *
                        5256000 *
                        (pool.multiplierPercent / 100) *
                        rewardToken.price!) /
                    stakedTotal) *
                100;

            final Map<String, dynamic> data = {
              'token': token.shortName,
              'earn': rewardToken.shortName,
              'stakedTotal': stakedTotal,
              'apr': apr,
              ...pool.toJson(),
            };

            poolsArray.add(data);
          }
        }

        poolsArray.sort((item1, item2) =>
            (item2['apr'] as double).compareTo(item1['apr'] as double));

        return poolsArray;
      } else {
        return [];
      }
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
      return [];
    }
  }

  Future fetchFarmsAndPools() async {
    Future.wait([
      getPairs.execute(),
      getTokens.execute(),
      getTokenInfos.execute(),
    ]).then((response) {
      PairList pairList = PairList.fromJson(response[0]);
      TokenList tokenList = TokenList.fromJson(response[1]);
      Map<String, dynamic> tokenInfo = response[2];

      Future.wait([
        fetchDemeterFarms(pairList, tokenList, tokenInfo),
        fetchDemeterPools(tokenList, tokenInfo),
      ]).then((farmsAndPoolsResponse) {
        _demeterFarmsAndPools = {
          'farms': farmsAndPoolsResponse[0],
          'pools': farmsAndPoolsResponse[1],
        };
        _loadingStatus.value = LoadingStatus.READY;
      }).catchError((_) {
        _loadingStatus.value = LoadingStatus.ERROR;
      });
    }).catchError((_) {
      _loadingStatus.value = LoadingStatus.ERROR;
    });
  }

  Future fetchFarming([bool refresh = false]) async {
    _loadingStatus.value = refresh ? LoadingStatus.IDLE : LoadingStatus.LOADING;

    final response = await getFarmingTVL.execute(_selectedTab.value);

    if (response != null) {
      if (_selectedTab.value == 'PSWAP') {
        double? tvlNumber = getDefaultDoubleValue(response);
        _tvl = formatToCurrency(tvlNumber, showSymbol: true, decimalDigits: 2);
        fetchPSWAPFarming();
      } else {
        TVL tvlResponse = TVL.fromJson(response);
        _tvl = formatToCurrency(tvlResponse.tvl,
            showSymbol: true, decimalDigits: 2);
        fetchFarmsAndPools();
      }
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
    }
  }
}
