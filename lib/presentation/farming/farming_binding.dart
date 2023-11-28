import 'package:ceres_tools_app/presentation/farming/farming_controller.dart';
import 'package:get/get.dart';

class FarmingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmingController>(() => FarmingController());
  }
}
