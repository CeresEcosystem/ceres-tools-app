import 'package:ceres_tools_app/presentation/pairs_liquidity/pairs_liquidity_controller.dart';
import 'package:get/get.dart';

class PairsLiquidityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PairsLiquidityController>(() => PairsLiquidityController());
  }
}
