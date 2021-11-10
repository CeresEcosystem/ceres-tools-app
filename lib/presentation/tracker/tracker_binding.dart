import 'package:ceres_locker_app/presentation/tracker/tracker_controller.dart';
import 'package:get/get.dart';

class TrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackerController>(() => TrackerController());
  }
}
