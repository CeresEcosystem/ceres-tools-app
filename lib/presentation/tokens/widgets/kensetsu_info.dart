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

class KensetsuInfo extends StatelessWidget {
  final SizingInformation sizingInformation;

  const KensetsuInfo({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.KENSETSU),
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
              size: Dimensions.CHIP_SIZE,
            ),
            UIHelper.horizontalSpaceSmall(),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text:
                      'KEN (Kensetsu) will be allocated to accounts on the SORA network that burn at least 1 million XOR before block 14,939,200, at a rate of 1 KEN per 1 million XOR burned. Click',
                  style: kensetsuInfoTextStyle(sizingInformation),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' here ',
                      style: kensetsuInfoTextStyle(sizingInformation).copyWith(
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
