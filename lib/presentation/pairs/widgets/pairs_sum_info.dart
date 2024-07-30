import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/device_screen_type.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/presentation/pairs/pairs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PairsSumInfo extends StatelessWidget {
  final SizingInformation sizingInformation;
  const PairsSumInfo({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PairsController controller = Get.find<PairsController>();

    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: UIHelper.pagePadding(sizingInformation),
          ),
          child: Row(
            children: [
              sumContainer(
                kTotalLiquidity,
                controller.totalLiquidity,
                sizingInformation,
              ),
              UIHelper.horizontalSpaceSmall(),
              sumContainer(
                kTotalVolume,
                controller.totalVolume,
                sizingInformation,
              ),
            ],
          ),
        ),
        UIHelper.verticalSpaceMedium(),
      ]),
    );
  }

  Widget sumContainer(
      String label, String info, SizingInformation sizingInformation) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(
          sizingInformation.deviceScreenType == DeviceScreenType.Mobile
              ? Dimensions.DEFAULT_MARGIN_SMALL
              : Dimensions.DEFAULT_MARGIN,
        ),
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
              style: pairsSumContainerInfoStyle(sizingInformation),
            ),
          ],
        ),
      ),
    );
  }
}
