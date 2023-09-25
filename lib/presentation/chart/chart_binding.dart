import 'package:ceres_locker_app/presentation/chart/chart_controller.dart';
import 'package:get/get.dart';

class ChartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChartController>(() => ChartController());
  }
}
