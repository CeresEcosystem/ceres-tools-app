import 'package:ceres_locker_app/presentation/portfolio/portfolio_controller.dart';
import 'package:get/get.dart';

class PortfolioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PortfolioController>(() => PortfolioController());
  }
}
