import 'package:ceres_tools_app/presentation/tbc_reserves/tbc_reserves_controller.dart';
import 'package:get/get.dart';

class TBCReservesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TBCReservesController>(() => TBCReservesController());
  }
}
