import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/device_screen_type.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
import 'package:ceres_locker_app/core/utils/default_value.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/round_image.dart';
import 'package:ceres_locker_app/core/widgets/search_text_field.dart';
import 'package:ceres_locker_app/presentation/chart/chart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TokensDialog extends StatelessWidget {
  final SizingInformation sizingInformation;

  const TokensDialog({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(
        left: Dimensions.DEFAULT_MARGIN,
        right: Dimensions.DEFAULT_MARGIN,
      ),
      content: SizedBox(
        width: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
            ? sizingInformation.screenSize.width * 0.9
            : sizingInformation.screenSize.width * 0.5,
        height: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
            ? sizingInformation.screenSize.height * 0.9
            : sizingInformation.screenSize.height * 0.7,
        child: GetBuilder<ChartController>(
          builder: (chartController) {
            return Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(top: Dimensions.DEFAULT_MARGIN),
                    color: backgroundColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchTextField(
                          onChanged: (text) => chartController.onSearch(text),
                          hint: kSearchTextFieldHint,
                          smallerFont: true,
                        ),
                        UIHelper.verticalSpaceSmall(),
                        Text(
                          'Your Favorites tokens from Tokens section are displayed first',
                          style: chartFavoriteTokensNoteTextStyle(),
                        ),
                        UIHelper.verticalSpaceSmallMedium(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: chartController.tokens.length,
                      separatorBuilder: (_, __) =>
                          UIHelper.verticalSpaceSmall(),
                      itemBuilder: (_, index) {
                        final token = chartController.tokens[index];

                        return ListTile(
                          tileColor: backgroundColorDark,
                          visualDensity: VisualDensity.compact,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                          ),
                          horizontalTitleGap:
                              Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                          leading: RoundImage(
                            image:
                                '$kImageStorage${token.shortName}${token.imageExtension}',
                            extension: token.imageExtension,
                            size: Dimensions.ICON_SIZE,
                          ),
                          title: Row(
                            children: [
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 100.0),
                                child: Text(
                                  checkEmptyString(token.shortName),
                                  style: tokensTitleStyle(sizingInformation)
                                      .copyWith(fontSize: subtitle2),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              UIHelper.horizontalSpaceExtraSmall(),
                              if (token.isFavorite)
                                (const Icon(
                                  Icons.star,
                                  color: backgroundOrange,
                                )),
                            ],
                          ),
                          trailing: Text(
                            formatToCurrency(token.price,
                                showSymbol: true, formatOnlyFirstPart: true),
                            style: tokensPriceStyle(sizingInformation)
                                .copyWith(fontSize: caption),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            chartController.changeToken(token.shortName!, true);
                            chartController.closeDialog();
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.DEFAULT_MARGIN,
                    ),
                    width: double.infinity,
                    color: backgroundColor,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              Dimensions.DEFAULT_MARGIN_SMALL),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: buttonLightTextStyle(sizingInformation),
                      ),
                      onPressed: () => chartController.closeDialog(),
                    ),
                  ),
                ],
              );
            });
          },
        ),
      ),
    );
  }
}
