import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/center_loading.dart';
import 'package:ceres_tools_app/core/widgets/ceres_banner.dart';
import 'package:ceres_tools_app/core/widgets/ceres_header.dart';
import 'package:ceres_tools_app/core/widgets/error_text.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/core/widgets/side_menu/side_menu.dart';
import 'package:ceres_tools_app/core/widgets/status_bar.dart';
import 'package:ceres_tools_app/presentation/farming/farming_controller.dart';
import 'package:ceres_tools_app/presentation/farming/widgets/demeter_farming.dart';
import 'package:ceres_tools_app/presentation/farming/widgets/heading.dart';
import 'package:ceres_tools_app/presentation/farming/widgets/pswap_farming.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FarmingView extends GetView<FarmingController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FarmingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
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
      if (controller.loadingStatus == LoadingStatus.LOADING) {
        return const Expanded(child: CenterLoading());
      }

      if (controller.loadingStatus == LoadingStatus.ERROR) {
        return Expanded(
            child:
                ErrorText(onButtonPress: () => controller.fetchFarming(true)));
      }

      return Expanded(
        child: RefreshIndicator(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  const CeresBanner(),
                  UIHelper.verticalSpaceMediumLarge(),
                  CeresHeader(
                    scaffoldKey: _scaffoldKey,
                  ),
                ]),
              ),
              Heading(
                sizingInformation: sizingInformation,
                tabs: controller.tabs,
                selectedTab: controller.selectedTab,
                onTabChange: controller.onTabChange,
                tvl: controller.tvl,
                loadingStatus: controller.loadingStatus,
              ),
              renderFarmBody(sizingInformation, controller)
            ],
          ),
          onRefresh: () async => controller.fetchFarming(true),
        ),
      );
    });
  }

  Widget renderFarmBody(
      SizingInformation sizingInformation, FarmingController controller) {
    if (controller.loadingStatus == LoadingStatus.LOADING ||
        controller.loadingStatus == LoadingStatus.IDLE) {
      return SliverList(
        delegate: SliverChildListDelegate([
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Center(child: CircularProgressIndicator()),
          ),
        ]),
      );
    }

    switch (controller.selectedTab) {
      case 'Demeter':
        return DemeterFarming(
          farms: controller.demeterFarmsAndPools['farms']!,
          pools: controller.demeterFarmsAndPools['pools']!,
          sizingInformation: sizingInformation,
        );
      case 'Hermes':
        return DemeterFarming(
          farms: controller.demeterFarmsAndPools['farms']!,
          pools: controller.demeterFarmsAndPools['pools']!,
          sizingInformation: sizingInformation,
        );
      case 'PSWAP':
        return PSWAPFarming(
          sizingInformation: sizingInformation,
          farm: controller.farm!,
        );
    }

    return Container();
  }
}
