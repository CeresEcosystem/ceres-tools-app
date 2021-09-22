import 'package:ceres_locker_app/presentation/tokens/tokens_controller.dart';
import 'package:get/get.dart';

class TokensBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokensController>(() => TokensController());
  }
}
