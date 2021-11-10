import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
import 'package:ceres_locker_app/di/injector.dart';
import 'package:ceres_locker_app/domain/models/pair.dart';
import 'package:ceres_locker_app/domain/models/pair_list.dart';
import 'package:ceres_locker_app/domain/usecase/get_pairs.dart';
import 'package:get/get.dart';

class PairsController extends GetxController {
  final getPairs = Injector.resolve!<GetPairs>();

  final _loadingStatus = LoadingStatus.READY.obs;
  var searchQueary = ''.obs;

  LoadingStatus get loadingStatus => _loadingStatus.value;

  List<Pair>? _pairs;

  String? _totalLiquidity;
  String? _totalVolume;

  List<Pair> get pairs {
    if (_pairs != null && _pairs!.isNotEmpty) {
      return _pairs!.where((pair) {
        if (pair.fullName != null && pair.fullName!.isNotEmpty) {
          return pair.fullName!.toUpperCase().contains(searchQueary.value.toUpperCase());
        }

        return false;
      }).toList();
    }

    return [];
  }

  void onTyping(String text) {
    searchQueary.value = text;
  }

  String get totalLiquidity => _totalLiquidity ?? '0';
  String get totalVolume => _totalVolume ?? '0';

  @override
  void onInit() {
    fetchPairs();
    super.onInit();
  }

  void fetchPairs([bool refresh = false]) async {
    _loadingStatus.value = refresh ? LoadingStatus.IDLE : LoadingStatus.LOADING;

    final response = await getPairs.execute();

    if (response != null) {
      PairList pairList = PairList.fromJson(response);

      if (pairList.pairs != null && pairList.pairs!.isNotEmpty) {
        _pairs = pairList.pairs;
        _pairs!.sort((pair1, pair2) {
          if (pair1.liquidityOrder != null && pair2.liquidityOrder != null) {
            return pair1.liquidityOrder!.compareTo(pair2.liquidityOrder!);
          }

          return 0;
        });

        double liq = 0;
        double vol = 0;

        for (Pair pair in _pairs!) {
          if (pair.liquidity != null) {
            liq += pair.liquidity!;
          }
          if (pair.volume != null) {
            vol += pair.volume!;
          }
        }

        _totalLiquidity = formatToCurrency(liq, showSymbol: true, decimalDigits: 0);
        _totalVolume = formatToCurrency(vol, showSymbol: true, decimalDigits: 0);
      }

      _loadingStatus.value = LoadingStatus.READY;
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
    }
  }
}
