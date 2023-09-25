import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/image_extension.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:ceres_locker_app/core/widgets/round_image.dart';
import 'package:ceres_locker_app/presentation/chart/widgets/tokens_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurrentToken extends StatelessWidget {
  final String token;

  const CurrentToken({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String imgExtension = imageExtension(token);

    return Responsive(
      builder: (_, sizingInformation) {
        return Padding(
          padding: const EdgeInsets.all(Dimensions.DEFAULT_MARGIN_SMALL),
          child: Center(
            child: GestureDetector(
              onTap: () => Get.dialog(
                TokensDialog(
                  sizingInformation: sizingInformation,
                ),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300.0),
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.DEFAULT_MARGIN_SMALL,
                  horizontal: Dimensions.DEFAULT_MARGIN,
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
                  color: backgroundColorDark,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RoundImage(
                      image: '$kImageStorage$token$imgExtension',
                      extension: imgExtension,
                      size: Dimensions.TOKEN_ICONS_SIZE,
                    ),
                    UIHelper.horizontalSpaceSmall(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          token,
                          style: chartCurrentTokenTitleTextStyle(),
                        ),
                        UIHelper.verticalSpaceExtraSmall(),
                        Text(
                          'Show all tokens',
                          style: chartCurrentTokenSubtitleTextStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
