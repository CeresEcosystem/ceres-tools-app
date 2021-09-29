import 'package:ceres_locker_app/core/enums/device_screen_type.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:ceres_locker_app/core/widgets/side_menu/side_menu.dart';
import 'package:ceres_locker_app/presentation/main/main_controller.dart';
import 'package:ceres_locker_app/presentation/tokens/tokens_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        builder: (context, sizingInformation) {
          if (sizingInformation.deviceScreenType == DeviceScreenType.Mobile) {
            return TokensView();
          }
          return Obx(() {
            return Row(
              children: [
                SideMenu(
                  largeScreen: true,
                  onMenuItemPress: (String page) => controller.setSelectedPage(page),
                ),
                Expanded(
                  child: controller.getWidget(),
                ),
              ],
            );
          });
        },
      ),
    );
  }
}
