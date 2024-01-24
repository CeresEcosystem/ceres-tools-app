import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/center_loading.dart';
import 'package:ceres_tools_app/core/widgets/horizontal_tab.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/core/widgets/round_image.dart';
import 'package:ceres_tools_app/domain/models/pair.dart';
import 'package:ceres_tools_app/presentation/pairs_liquidity/pairs_liquidity_controller.dart';
import 'package:ceres_tools_app/presentation/pairs_liquidity/widgets/pair_liquidity_chart.dart';
import 'package:ceres_tools_app/presentation/pairs_liquidity/widgets/pairs_liquidity_changes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PairsLiquidityView extends GetView<PairsLiquidityController> {
  const PairsLiquidityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Pair pair = Get.arguments;

    return Responsive(
      builder: (context, sizingInformation) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Image.asset(
              'lib/core/assets/images/ceres_tools_logo.png',
              height: Dimensions.HEADER_LOGO,
            ),
          ),
          bottomNavigationBar: Container(
            height: sizingInformation.bottomSafeAreaSize,
            color: chartBackground,
          ),
          body: SafeArea(
            child: Column(
              children: [
                UIHelper.verticalSpaceMedium(),
                pairHeaderTitle(pair, sizingInformation),
                UIHelper.verticalSpaceMedium(),
                Obx(() {
                  return Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: UIHelper.pagePadding(sizingInformation),
                          ),
                          child: HorizontalTab(
                            tabs: controller.tabs,
                            selectedTab: controller.selectedTab,
                            changeTab: (String tab) =>
                                controller.changeSelectedTab(tab),
                            bottomMargin: false,
                          ),
                        ),
                        (() {
                          if (controller.loadingStatus ==
                              LoadingStatus.LOADING) {
                            return const CenterLoading();
                          }

                          if (controller.selectedTab == controller.tabs[0]) {
                            return PairsLiquidityChanges(
                              pair: pair,
                              sizingInformation: sizingInformation,
                            );
                          }

                          return PairLiquidityChart(
                            sizingInformation: sizingInformation,
                          );
                        })(),
                      ],
                    ),
                  );
                })
              ],
            ),
          ),
        );
      },
    );
  }

  Widget pairHeaderTitle(Pair pair, SizingInformation sizingInformation) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: UIHelper.pagePadding(sizingInformation)),
      child: Row(
        children: [
          pairImage(pair),
          UIHelper.horizontalSpaceSmall(),
          Text(
            '${pair.baseToken} / ${pair.shortName}',
            style: tokensTitleStyle(sizingInformation),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget pairImage(Pair pair) {
    return SizedBox(
      width: Dimensions.PAIRS_IMAGE_SIZE * 2,
      child: Stack(
        children: [
          Positioned(
            left:
                Dimensions.PAIRS_IMAGE_SIZE - (Dimensions.PAIRS_IMAGE_SIZE / 4),
            child: RoundImage(
              image: '$kImageStorage${pair.shortName}${pair.imageExtension}',
              size: Dimensions.PAIRS_IMAGE_SIZE,
              extension: pair.imageExtension,
            ),
          ),
          RoundImage(
            image: '$kImageStorage${pair.baseToken}$kImageExtension',
            size: Dimensions.PAIRS_IMAGE_SIZE,
          ),
        ],
      ),
    );
  }
}
