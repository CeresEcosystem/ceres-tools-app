import 'package:ceres_tools_app/presentation/kensetsu/kensetsu_controller.dart';
import 'package:get/get.dart';

class KensetsuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KensetsuController>(() => KensetsuController());
  }
}
