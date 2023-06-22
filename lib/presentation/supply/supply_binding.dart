import 'package:ceres_locker_app/presentation/supply/supply_controller.dart';
import 'package:get/get.dart';

class SupplyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupplyController>(() => SupplyController());
  }
}
