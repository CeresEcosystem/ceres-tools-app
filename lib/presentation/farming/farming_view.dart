import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/device_screen_type.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/default_value.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/center_loading.dart';
import 'package:ceres_locker_app/core/widgets/ceres_banner.dart';
import 'package:ceres_locker_app/core/widgets/ceres_header.dart';
import 'package:ceres_locker_app/core/widgets/error_text.dart';
import 'package:ceres_locker_app/core/widgets/item_container.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:ceres_locker_app/core/widgets/scroll_bar_container.dart';
import 'package:ceres_locker_app/core/widgets/side_menu/side_menu.dart';
import 'package:ceres_locker_app/core/widgets/status_bar.dart';
import 'package:ceres_locker_app/presentation/farming/farming_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FarmingView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FarmingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FarmingController controller = Get.put(FarmingController());

    return Responsive(
      builder: (context, sizingInformation) {
        return Scaffold(
          key: _scaffoldKey,
          endDrawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile ? SideMenu() : null,
          body: Column(
            children: [
              const StatusBar(),
              renderBody(controller, sizingInformation),
            ],
          ),
        );
      },
    );
  }

  Widget renderBody(FarmingController controller, SizingInformation sizingInformation) {
    return Obx(() {
      if (controller.loadingStatus == LoadingStatus.LOADING) return const Expanded(child: CenterLoading());

      if (controller.loadingStatus == LoadingStatus.ERROR) return Expanded(child: ErrorText(onButtonPress: () => controller.fetchFarming(true)));

      return Expanded(
        child: RefreshIndicator(
          child: ScrollBarContainer(
            isAlwaysShown: false,
            sizingInformation: sizingInformation,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    const CeresBanner(),
                    UIHelper.verticalSpaceMediumLarge(),
                    if (sizingInformation.deviceScreenType == DeviceScreenType.Mobile)
                      (CeresHeader(
                        scaffoldKey: _scaffoldKey,
                      )),
                  ]),
                ),
                if (controller.farm != null)
                  (SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.only(top: Dimensions.DEFAULT_MARGIN_LARGE),
                        child: ItemContainer(
                          sizingInformation: sizingInformation,
                          backgroundColor: backgroundColorLight,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: kFarmingPart1,
                              style: farmingLabelStyle(sizingInformation),
                              children: <TextSpan>[
                                TextSpan(
                                  text: checkEmptyString(controller.farm!.rewardsDouble),
                                  style: farmingInfoStyle(sizingInformation),
                                ),
                                const TextSpan(
                                  text: kFarmingPart2,
                                ),
                                TextSpan(
                                  text: checkEmptyString(controller.farm!.aprDouble),
                                  style: farmingInfoStyle(sizingInformation),
                                ),
                                const TextSpan(
                                  text: kFarmingPart3,
                                ),
                                const TextSpan(
                                  text: kFarmingPart4,
                                ),
                                TextSpan(
                                  text: checkEmptyString(controller.farm!.rewards),
                                  style: farmingInfoStyle(sizingInformation),
                                ),
                                const TextSpan(
                                  text: kFarmingPart5,
                                ),
                                TextSpan(
                                  text: checkEmptyString(controller.farm!.apr),
                                  style: farmingInfoStyle(sizingInformation),
                                ),
                                const TextSpan(
                                  text: kFarmingPart6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  )),
              ],
            ),
          ),
          onRefresh: () async => controller.fetchFarming(true),
        ),
      );
    });
  }
}
