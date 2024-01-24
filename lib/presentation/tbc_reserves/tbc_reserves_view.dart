import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/device_screen_type.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/center_loading.dart';
import 'package:ceres_tools_app/core/widgets/ceres_banner.dart';
import 'package:ceres_tools_app/core/widgets/ceres_header.dart';
import 'package:ceres_tools_app/core/widgets/item_container.dart';
import 'package:ceres_tools_app/core/widgets/line_chart.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/core/widgets/side_menu/side_menu.dart';
import 'package:ceres_tools_app/core/widgets/status_bar.dart';
import 'package:ceres_tools_app/presentation/tbc_reserves/tbc_reserves_controller.dart';
import 'package:ceres_tools_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TBCReservesView extends GetView<TBCReservesController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TBCReservesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      endDrawer: SideMenu(),
      body: Responsive(
        builder: (context, sizingInformation) {
          return Column(
            children: [
              const StatusBar(),
              const CeresBanner(),
              UIHelper.verticalSpaceMediumLarge(),
              CeresHeader(
                scaffoldKey: _scaffoldKey,
              ),
              Obx(() {
                if (controller.loadingStatus == LoadingStatus.LOADING) {
                  return const Expanded(child: CenterLoading());
                }

                return Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          UIHelper.verticalSpaceMediumLarge(),
                          ItemContainer(
                            sizingInformation: sizingInformation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'TBC Reserves Address:',
                                  style: tbcReservesLabelTextStyle(),
                                ),
                                UIHelper.verticalSpaceExtraSmall(),
                                GestureDetector(
                                  onTap: () => Get.toNamed(Routes.PORTFOLIO,
                                      arguments: {
                                        'address': kTBCReservesAddress
                                      }),
                                  child: Text(
                                    kTBCReservesAddress,
                                    style: tbcReservesInfoTextStyle(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          UIHelper.verticalSpaceMediumLarge(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  UIHelper.pagePadding(sizingInformation),
                            ),
                            child: Center(
                              child: Text(
                                'TBCD Reserves',
                                style: trackerTitleStyle(sizingInformation),
                              ),
                            ),
                          ),
                          UIHelper.verticalSpaceMedium(),
                        ]),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  UIHelper.pagePadding(sizingInformation),
                            ),
                            child: Row(
                              children: [
                                sumContainer(
                                    'Total balance',
                                    controller.currentBalance,
                                    sizingInformation),
                                UIHelper.horizontalSpaceSmall(),
                                sumContainer('Total value',
                                    controller.currentValue, sizingInformation),
                              ],
                            ),
                          ),
                          UIHelper.verticalSpaceMediumLarge(),
                        ]),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          ItemContainer(
                            sizingInformation: sizingInformation,
                            child: Chart(
                              graphData: controller.graphData,
                              getTooltipData: controller.getSupplyTooltipData,
                              showFullValueX: true,
                              showFullValueY: true,
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                );
              })
            ],
          );
        },
      ),
    );
  }

  Widget sumContainer(
      String label, String info, SizingInformation sizingInformation) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(
            sizingInformation.deviceScreenType == DeviceScreenType.Mobile
                ? Dimensions.DEFAULT_MARGIN_SMALL
                : Dimensions.DEFAULT_MARGIN),
        decoration: BoxDecoration(
          color: backgroundColorDark,
          borderRadius: BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: pairsSumContainerLabelStyle(sizingInformation),
            ),
            UIHelper.verticalSpaceSmall(),
            Text(
              info,
              style: tbcReservesSumContainerInfoStyle(sizingInformation),
            ),
          ],
        ),
      ),
    );
  }
}
