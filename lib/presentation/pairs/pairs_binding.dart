import 'package:ceres_tools_app/presentation/pairs/pairs_controller.dart';
import 'package:get/get.dart';

class PairsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PairsController>(() => PairsController());
  }
}
