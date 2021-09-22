import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/di/injector.dart';
import 'package:ceres_locker_app/domain/models/farm.dart';
import 'package:ceres_locker_app/domain/usecase/get_farming.dart';
import 'package:get/get.dart';

class FarmingController extends GetxController {
  final getFarming = Injector.resolve!<GetFarming>();

  final _loadingStatus = LoadingStatus.READY.obs;
  Farm? _farm;

  LoadingStatus get loadingStatus => _loadingStatus.value;
  Farm? get farm => _farm;

  @override
  void onInit() {
    fetchFarming();
    super.onInit();
  }

  void fetchFarming([bool refresh = false]) async {
    _loadingStatus.value = refresh ? LoadingStatus.IDLE : LoadingStatus.LOADING;

    final response = await getFarming.execute();

    if (response != null) {
      _farm = Farm.fromJson(response);
    }

    _loadingStatus.value = LoadingStatus.READY;
  }
}
