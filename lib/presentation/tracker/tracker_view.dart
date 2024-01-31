import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/center_loading.dart';
import 'package:ceres_tools_app/core/widgets/ceres_banner.dart';
import 'package:ceres_tools_app/core/widgets/ceres_header.dart';
import 'package:ceres_tools_app/core/widgets/error_text.dart';
import 'package:ceres_tools_app/core/widgets/horizontal_tab.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/core/widgets/side_menu/side_menu.dart';
import 'package:ceres_tools_app/core/widgets/status_bar.dart';
import 'package:ceres_tools_app/presentation/tracker/tracker_controller.dart';
import 'package:ceres_tools_app/presentation/tracker/widgets/burning.dart';
import 'package:ceres_tools_app/presentation/tracker/widgets/burning_graph.dart';
import 'package:ceres_tools_app/presentation/tracker/widgets/faqs.dart';
import 'package:ceres_tools_app/presentation/tracker/widgets/gross_table.dart';
import 'package:ceres_tools_app/presentation/tracker/widgets/sponsor.dart';
import 'package:ceres_tools_app/presentation/tracker/widgets/supply_graph.dart';
import 'package:ceres_tools_app/presentation/tracker/widgets/xor_spent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrackerView extends GetView<TrackerController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TrackerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return Scaffold(
          key: _scaffoldKey,
          endDrawer: SideMenu(),
          body: Column(
            children: [
              const StatusBar(),
              renderBody(sizingInformation),
            ],
          ),
        );
      },
    );
  }

  Widget renderBody(SizingInformation sizingInformation) {
    return Obx(() {
      if (controller.loadingStatus == LoadingStatus.ERROR) {
        return Expanded(
          child: ErrorText(
            onButtonPress: () =>
                controller.fetchTracker(controller.selectedToken),
          ),
        );
      }

      return Expanded(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                const CeresBanner(),
                UIHelper.verticalSpaceMediumLarge(),
                CeresHeader(
                  scaffoldKey: _scaffoldKey,
                ),
                UIHelper.verticalSpaceMediumLarge(),
              ]),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(Dimensions.DEFAULT_MARGIN),
                  child: Column(
                    children: [
                      HorizontalTab(
                        tabs: controller.tabs,
                        selectedTab: controller.selectedToken,
                        changeTab: controller.changeToken,
                      ),
                      Text(
                        'Track ${controller.selectedToken}',
                        style: pageTitleStyle(sizingInformation),
                      ),
                      UIHelper.verticalSpaceExtraSmall(),
                      Text(
                        'Follow the progression of ${controller.selectedToken}.',
                        style: pageSubtitleStyle(sizingInformation),
                      ),
                      UIHelper.verticalSpaceMedium(),
                    ],
                  ),
                ),
              ]),
            ),
            if (controller.loadingStatus == LoadingStatus.LOADING) ...[
              (SliverList(
                delegate: SliverChildListDelegate([
                  const CenterLoading(),
                ]),
              ))
            ] else ...[
              SliverList(
                delegate: SliverChildListDelegate([
                  if (controller.burnData != null) ...[
                    Burning(
                      sizingInformation: sizingInformation,
                    )
                  ],
                  if (controller.blocksXorSpent.isNotEmpty) ...[
                    UIHelper.verticalSpaceSmall(),
                    XorSpent(
                      sizingInformation: sizingInformation,
                    ),
                  ],
                  if (controller.blocksGrossTable.isNotEmpty) ...[
                    UIHelper.verticalSpaceSmall(),
                    GrossTable(
                      sizingInformation: sizingInformation,
                    ),
                  ],
                  if (controller.burningGraphData != null &&
                      controller.burningGraphData!.isNotEmpty) ...[
                    UIHelper.verticalSpaceLarge(),
                    BurningGraph(sizingInformation: sizingInformation),
                  ],
                  if (controller.supplyGraphData != null &&
                      controller.supplyGraphData!.isNotEmpty) ...[
                    UIHelper.verticalSpaceLarge(),
                    SupplyGraph(sizingInformation: sizingInformation),
                  ],
                  if (controller.selectedToken == 'PSWAP') ...[
                    UIHelper.verticalSpaceLarge(),
                    Faqs(
                      sizingInformation: sizingInformation,
                    ),
                  ],
                  if (controller.selectedToken == 'PSWAP') ...[
                    UIHelper.verticalSpaceLarge(),
                    Sponsor(sizingInformation: sizingInformation),
                  ],
                  UIHelper.verticalSpaceLarge(),
                ]),
              )
            ]
          ],
        ),
      );
    });
  }
}
