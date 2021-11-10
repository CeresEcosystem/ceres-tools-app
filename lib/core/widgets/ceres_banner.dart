import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CeresBanner extends StatelessWidget {
  const CeresBanner({Key? key}) : super(key: key);

  void _launchURL() async {
    if (await canLaunch(kCeresWebsite)) {
      await launch(kCeresWebsite);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return GestureDetector(
          onTap: _launchURL,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.DEFAULT_MARGIN),
            color: backgroundColorLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  kBannerTitle,
                  style: bannerTitleStyle(sizingInformation),
                  textAlign: TextAlign.center,
                ),
                UIHelper.verticalSpaceExtraSmall(),
                Text(
                  kBannerSubtitle,
                  style: bannerSubtitleStyle(sizingInformation),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
