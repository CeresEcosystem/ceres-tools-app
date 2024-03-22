import 'package:ceres_tools_app/presentation/pairs_providers/pairs_providers_controller.dart';
import 'package:get/get.dart';

class PairsProvidersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PairsProvidersController>(() => PairsProvidersController());
  }
}
