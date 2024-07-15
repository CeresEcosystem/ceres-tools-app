import 'package:ceres_tools_app/core/assets/fonts/flaticon.dart';
import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/device_screen_type.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/empty_widget.dart';
import 'package:ceres_tools_app/core/widgets/round_image.dart';
import 'package:ceres_tools_app/core/widgets/search_text_field.dart';
import 'package:ceres_tools_app/domain/models/favorite_token.dart';
import 'package:ceres_tools_app/domain/models/token.dart';
import 'package:ceres_tools_app/presentation/chart/chart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TokensDialog extends StatefulWidget {
  final List<Token> tokens;
  final List<FavoriteToken>? favoriteTokens;
  final Function changeToken;
  final bool showFavoriteTokensOptions;
  final bool showAllTokensOption;
  final SizingInformation sizingInformation;

  const TokensDialog({
    Key? key,
    required this.tokens,
    this.favoriteTokens,
    required this.changeToken,
    this.showFavoriteTokensOptions = true,
    this.showAllTokensOption = true,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  State<TokensDialog> createState() => _TokensDialogState();
}

class _TokensDialogState extends State<TokensDialog> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    List<Token> filteredTokens = widget.tokens
        .where((t) =>
            t.fullName!.toUpperCase().contains(searchQuery.toUpperCase()) ||
            t.assetId!.toUpperCase().contains(searchQuery.toUpperCase()))
        .toList();
    final int optionsCount = (widget.showFavoriteTokensOptions &&
                widget.favoriteTokens != null &&
                widget.favoriteTokens!.isNotEmpty
            ? 1
            : 0) +
        (widget.showAllTokensOption ? 1 : 0);
    final int itemCount = filteredTokens.length + optionsCount;

    return AlertDialog(
      contentPadding: const EdgeInsets.only(
        left: Dimensions.DEFAULT_MARGIN,
        right: Dimensions.DEFAULT_MARGIN,
      ),
      content: SizedBox(
        width:
            widget.sizingInformation.deviceScreenType == DeviceScreenType.Mobile
                ? widget.sizingInformation.screenSize.width * 0.9
                : widget.sizingInformation.screenSize.width * 0.5,
        height:
            widget.sizingInformation.deviceScreenType == DeviceScreenType.Mobile
                ? widget.sizingInformation.screenSize.height * 0.9
                : widget.sizingInformation.screenSize.height * 0.7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(top: Dimensions.DEFAULT_MARGIN),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchTextField(
                    onChanged: (text) {
                      setState(() {
                        searchQuery = text;
                      });
                    },
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
                itemBuilder: (context, index) {
                  if (index == 0 &&
                      widget.showFavoriteTokensOptions &&
                      widget.favoriteTokens != null) {
                    if (widget.favoriteTokens!.isNotEmpty) {
                      return tokenOptionItem(
                        backgroundPink,
                        Icons.favorite,
                        'Favorite tokens',
                        () {
                          widget.changeToken(kFavoriteTokens);
                          Get.back();
                        },
                      );
                    } else {
                      return const EmptyWidget();
                    }
                  } else if (index == 1 && widget.showAllTokensOption) {
                    return tokenOptionItem(
                      Colors.white.withOpacity(.2),
                      Flaticon.token,
                      'All tokens',
                      () {
                        widget.changeToken(kAllTokens);
                        Get.back();
                      },
                      backgroundOrange,
                    );
                  } else {
                    final token = filteredTokens[index - optionsCount];

                    return Container(
                      margin: const EdgeInsets.only(
                          bottom: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL),
                      child: ListTile(
                        tileColor: backgroundColorDark,
                        visualDensity: VisualDensity.compact,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                        ),
                        horizontalTitleGap:
                            Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                        leading: RoundImage(
                          image: '$kImageStorage${token.shortName}',
                          size: Dimensions.ICON_SIZE,
                        ),
                        title: Row(
                          children: [
                            ConstrainedBox(
                              constraints:
                                  const BoxConstraints(maxWidth: 100.0),
                              child: Text(
                                checkEmptyString(token.shortName),
                                style:
                                    tokensTitleStyle(widget.sizingInformation)
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
                          formatToCurrency(token.priceString,
                              showSymbol: true, formatOnlyFirstPart: true),
                          style: tokensPriceStyle(widget.sizingInformation)
                              .copyWith(fontSize: caption),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          widget.changeToken(token.shortName!, true);
                          Get.back();
                        },
                      ),
                    );
                  }
                },
                separatorBuilder: (_, __) => UIHelper.verticalSpaceExtraSmall(),
                itemCount: itemCount,
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
                  backgroundColor: backgroundPink,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
                  ),
                ),
                child: Text(
                  'Close',
                  style: buttonLightTextStyle(widget.sizingInformation),
                ),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tokenOptionItem(Color bg, IconData icon, String title, Function onTap,
      [Color iconColor = Colors.white]) {
    return Column(
      children: [
        ListTile(
          tileColor: backgroundColorDark,
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
          ),
          horizontalTitleGap: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
          leading: Container(
            height: Dimensions.ICON_SIZE,
            width: Dimensions.ICON_SIZE,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                size: Dimensions.ICON_SIZE_SMALL,
                color: iconColor,
              ),
            ),
          ),
          title: Text(
            title,
            style: tokensTitleStyle(widget.sizingInformation)
                .copyWith(fontSize: subtitle2),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => onTap(),
        ),
        UIHelper.verticalSpaceSmall(),
      ],
    );
  }
}
