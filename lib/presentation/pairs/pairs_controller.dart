import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/di/injector.dart';
import 'package:ceres_tools_app/domain/models/pair.dart';
import 'package:ceres_tools_app/domain/models/pair_list.dart';
import 'package:ceres_tools_app/domain/usecase/get_pairs.dart';
import 'package:get/get.dart';

class PairsController extends GetxController {
  final getPairs = Injector.resolve!<GetPairs>();

  final List<String> _volumeIntervals = ['24h', '7d', '1M', '3M'];

  final _loadingStatus = LoadingStatus.READY.obs;
  var searchQueary = ''.obs;
  final _baseAsset = 'All'.obs;
  final _syntheticsFilter = false.obs;
  final _volumeInterval = '24h'.obs;

  List<String> get volumeIntervals => _volumeIntervals;
  String get volumeInterval => _volumeInterval.value;
  LoadingStatus get loadingStatus => _loadingStatus.value;

  List<Pair>? _pairs;
  final Set<String> _baseAssets = {'All'};

  String? _totalLiquidity;
  String? _totalVolume;

  void setVolumeInterval(String vi) {
    if (vi != _volumeInterval.value) {
      _volumeInterval.value = vi;
    }
  }

  List<Pair> get pairs {
    if (_pairs != null && _pairs!.isNotEmpty) {
      List<Pair> pairsFiltered = _pairs!;

      if (_baseAsset.value != '' && _baseAsset.value != 'All') {
        pairsFiltered = pairsFiltered
            .where((Pair p) => p.baseToken == _baseAsset.value)
            .toList();
      }

      if (_syntheticsFilter.value) {
        pairsFiltered = pairsFiltered
            .where((Pair p) => p.tokenAssetId!.startsWith(kSyntheticsAddress))
            .toList();
      }

      return pairsFiltered.where((pair) {
        if (pair.fullName != null && pair.fullName!.isNotEmpty) {
          return pair.fullName!
              .toUpperCase()
              .contains(searchQueary.value.toUpperCase());
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
  List<String> get baseAssets => _baseAssets.toList();
  String get baseAsset => _baseAsset.value;
  bool get syntheticsFilter => _syntheticsFilter.value;

  @override
  void onInit() {
    fetchPairs();
    super.onInit();
  }

  void setBaseAsset(String asset) {
    bool synthFilter = _syntheticsFilter.value;

    if (asset == 'All' && synthFilter) {
      synthFilter = false;
      _syntheticsFilter.value = false;
    }

    if (asset != _baseAsset.value) {
      _baseAsset.value = asset;
    } else {
      if (synthFilter) {
        _baseAsset.value = '';
      }
    }
  }

  void setSyntheticsFilter() {
    bool synthFilter = !_syntheticsFilter.value;

    if (synthFilter) {
      if (_baseAsset.value == 'All') {
        _baseAsset.value = '';
      }
    } else {
      if (_baseAsset.value == '') {
        _baseAsset.value = 'All';
      }
    }

    _syntheticsFilter.value = synthFilter;
  }

  void fetchPairs([bool refresh = false]) async {
    _loadingStatus.value = refresh ? LoadingStatus.IDLE : LoadingStatus.LOADING;

    final response = await getPairs.execute();

    if (response != null) {
      PairList pairList = PairList.fromJson(response);

      if (pairList.pairs != null && pairList.pairs!.isNotEmpty) {
        _pairs = pairList.pairs;

        _pairs!.where((Pair p) => _baseAssets.add(p.baseToken!)).toList();
        _baseAssets.add('Synthetics');

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

        _totalLiquidity =
            formatToCurrency(liq, showSymbol: true, decimalDigits: 0);
        _totalVolume =
            formatToCurrency(vol, showSymbol: true, decimalDigits: 0);
      }

      _loadingStatus.value = LoadingStatus.READY;
    } else {
      _loadingStatus.value = LoadingStatus.ERROR;
    }
  }
}
