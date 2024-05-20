import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/item_container.dart';
import 'package:ceres_tools_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class BurningInfo extends StatelessWidget {
  final SizingInformation sizingInformation;
  final String info;
  final String tokenFullName;
  final String tokenShortName;

  const BurningInfo({
    Key? key,
    required this.sizingInformation,
    required this.info,
    required this.tokenFullName,
    required this.tokenShortName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        Routes.BURNING,
        arguments: {
          'tokenFullName': tokenFullName,
          'tokenShortName': tokenShortName,
        },
      ),
      child: ItemContainer(
        sizingInformation: sizingInformation,
        smallMargin: true,
        backgroundColor: Colors.white.withOpacity(0.1),
        child: Row(
          children: [
            const HeroIcon(
              HeroIcons.fire,
              style: HeroIconStyle.solid,
              color: backgroundOrange,
              size: Dimensions.ICON_SIZE,
            ),
            UIHelper.horizontalSpaceSmall(),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: info,
                  style: burningInfoTextStyle(sizingInformation),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' here ',
                      style: burningInfoTextStyle(sizingInformation).copyWith(
                        color: backgroundPink,
                      ),
                    ),
                    const TextSpan(
                      text: 'to track XOR burning.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
