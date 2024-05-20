import 'package:ceres_tools_app/presentation/burning/burning_controller.dart';
import 'package:get/get.dart';

class BurningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BurningController>(() => BurningController());
  }
}
