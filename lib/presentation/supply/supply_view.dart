import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
import 'package:ceres_locker_app/core/utils/default_value.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/center_loading.dart';
import 'package:ceres_locker_app/core/widgets/error_text.dart';
import 'package:ceres_locker_app/core/widgets/item_container.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:ceres_locker_app/core/widgets/round_image.dart';
import 'package:ceres_locker_app/domain/models/token.dart';
import 'package:ceres_locker_app/presentation/supply/supply_controller.dart';
import 'package:ceres_locker_app/presentation/tracker/widgets/tracker_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupplyView extends GetView<SupplyController> {
  const SupplyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    Token token = args['token'];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'lib/core/assets/images/ceres_tools_logo.png',
          height: Dimensions.HEADER_LOGO,
        ),
      ),
      body: Responsive(
        builder: (_, sizingInformation) {
          return Obx(() {
            if (controller.loadingStatus == LoadingStatus.LOADING) {
              return const CenterLoading();
            }

            if (controller.loadingStatus == LoadingStatus.ERROR) {
              return ErrorText(
                onButtonPress: () => controller.fetchTracker(),
              );
            }

            return Column(
              children: [
                tokenHeaderTitle(token, sizingInformation),
                UIHelper.verticalSpaceMedium(),
                Center(
                  child: Text(
                    'Current supply: ${formatToCurrency(controller.currentSupply, decimalDigits: 2)}',
                    style: currentSupplyTextStyle(),
                  ),
                ),
                UIHelper.verticalSpaceMedium(),
                if (controller.pswapSupplyGraphData != null)
                  (ItemContainer(
                    sizingInformation: sizingInformation,
                    child: TrackerChart(
                      graphData: controller.pswapSupplyGraphData!,
                      getTooltipData: controller.getSupplyTooltipData,
                      showFullValue: true,
                    ),
                  )),
              ],
            );
          });
        },
      ),
    );
  }

  Widget tokenHeaderTitle(Token token, SizingInformation sizingInformation) {
    return Padding(
      padding: EdgeInsets.all(UIHelper.pagePadding(sizingInformation)),
      child: Row(
        children: [
          RoundImage(
            image: '$kImageStorage${token.shortName}${token.imageExtension}',
            size: Dimensions.PAIRS_IMAGE_SIZE,
            extension: token.imageExtension,
          ),
          UIHelper.horizontalSpaceSmall(),
          Text(
            checkEmptyString(token.shortName),
            style: tokensTitleStyle(sizingInformation),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
