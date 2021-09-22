import 'package:ceres_locker_app/core/enums/loading_status.dart';
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
      }
    }

    _loadingStatus.value = LoadingStatus.READY;
  }
}
