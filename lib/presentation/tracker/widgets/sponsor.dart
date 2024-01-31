import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/launch_url.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/round_image.dart';
import 'package:flutter/material.dart';

class Sponsor extends StatelessWidget {
  final SizingInformation sizingInformation;

  const Sponsor({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.DEFAULT_MARGIN),
      child: Column(
        children: [
          Text(
            kSponsoredBy,
            style: trackerTitleStyle(sizingInformation),
          ),
          UIHelper.verticalSpaceMediumLarge(),
          GestureDetector(
            onTap: () => launchURL(kPSWAPCommunity),
            child: const RoundImage(
              image: 'lib/core/assets/images/pococo_icon.png',
              localImage: true,
              size: Dimensions.SPONSORS_IMAGE_SIZE,
            ),
          )
        ],
      ),
    );
  }
}
