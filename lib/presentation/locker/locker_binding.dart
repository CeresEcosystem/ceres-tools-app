import 'package:ceres_tools_app/presentation/locker/locker_controller.dart';
import 'package:get/get.dart';

class LockerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LockerController>(() => LockerController());
  }
}
