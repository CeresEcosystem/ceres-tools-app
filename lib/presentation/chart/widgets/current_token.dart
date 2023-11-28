import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/image_extension.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/core/widgets/round_image.dart';
import 'package:ceres_tools_app/presentation/chart/widgets/tokens_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurrentToken extends StatelessWidget {
  final String token;
  final Function goToSwapPage;
  final IconData icon;
  final String buttonLabel;
  final bool bottomPadding;
  final bool showFavorites;

  const CurrentToken({
    Key? key,
    required this.token,
    required this.goToSwapPage,
    required this.icon,
    required this.buttonLabel,
    this.bottomPadding = true,
    required this.showFavorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String imgExtension = imageExtension(token);

    return Responsive(
      builder: (_, sizingInformation) {
        return Padding(
          padding: EdgeInsets.only(
            top: Dimensions.DEFAULT_MARGIN_SMALL,
            left: Dimensions.DEFAULT_MARGIN_SMALL,
            right: Dimensions.DEFAULT_MARGIN_SMALL,
            bottom: bottomPadding ? Dimensions.DEFAULT_MARGIN_SMALL : 0,
          ),
          child: Center(
            child: GestureDetector(
              onTap: () => Get.dialog(
                TokensDialog(
                  sizingInformation: sizingInformation,
                ),
                barrierDismissible: false,
              ),
              child: Container(
                padding: const EdgeInsets.all(Dimensions.DEFAULT_MARGIN_SMALL),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
                  color: backgroundColorDark,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (() {
                      if (showFavorites) {
                        return Container(
                          height: Dimensions.TOKEN_ICONS_SIZE,
                          width: Dimensions.TOKEN_ICONS_SIZE,
                          decoration: const BoxDecoration(
                            color: backgroundPink,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.favorite),
                          ),
                        );
                      } else {
                        return RoundImage(
                          image: '$kImageStorage$token$imgExtension',
                          extension: imgExtension,
                          size: Dimensions.TOKEN_ICONS_SIZE,
                        );
                      }
                    }()),
                    UIHelper.horizontalSpaceSmall(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          showFavorites ? 'Favorite tokens' : token,
                          style: chartCurrentTokenTitleTextStyle(),
                        ),
                        UIHelper.verticalSpaceExtraSmall(),
                        Text(
                          'Show all tokens',
                          style: chartCurrentTokenSubtitleTextStyle(),
                        ),
                      ],
                    ),
                    if (!showFavorites)
                      (Row(
                        children: [
                          UIHelper.horizontalSpaceMedium(),
                          GestureDetector(
                            onTap: () => goToSwapPage(),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(
                                Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                                ),
                                color: Colors.white.withOpacity(0.1),
                              ),
                              child: Row(
                                children: [
                                  Icon(icon),
                                  UIHelper.horizontalSpaceExtraSmall(),
                                  Text(
                                    buttonLabel,
                                    style: chartButtonTextStyle(),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
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
