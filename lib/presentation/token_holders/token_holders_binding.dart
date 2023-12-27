import 'package:ceres_tools_app/presentation/token_holders/token_holders_controller.dart';
import 'package:get/get.dart';

class TokenHoldersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenHoldersController>(() => TokenHoldersController());
  }
}
