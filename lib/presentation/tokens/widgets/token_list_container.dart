import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/address_format.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/toast.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/center_loading.dart';
import 'package:ceres_tools_app/core/widgets/error_text.dart';
import 'package:ceres_tools_app/core/widgets/item_container.dart';
import 'package:ceres_tools_app/core/widgets/round_image.dart';
import 'package:ceres_tools_app/domain/models/token.dart';
import 'package:ceres_tools_app/presentation/tokens/tokens_controller.dart';
import 'package:ceres_tools_app/presentation/tokens/widgets/token_filters.dart';
import 'package:ceres_tools_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class TokenListContainer extends StatelessWidget {
  final SizingInformation sizingInformation;
  final Function setShowTokenPriceCalculator;

  const TokenListContainer({
    Key? key,
    required this.sizingInformation,
    required this.setShowTokenPriceCalculator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TokensController controller = Get.find<TokensController>();

    return Obx(() {
      if (controller.loadingStatus == LoadingStatus.LOADING) {
        return const SliverFillRemaining(child: CenterLoading());
      }

      if (controller.loadingStatus == LoadingStatus.ERROR) {
        return SliverFillRemaining(
            child:
                ErrorText(onButtonPress: () => controller.fetchTokens(true)));
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) {
              return TokenFilters(
                sizingInformation: sizingInformation,
                setShowTokenPriceCalculator: setShowTokenPriceCalculator,
              );
            }

            Token token = controller.tokens[index - 1];

            return ItemContainer(
              sizingInformation: sizingInformation,
              child: tokenItem(token, sizingInformation, controller),
              onPress: () => controller.openChartForToken(token.shortName),
            );
          },
          childCount: controller.tokens.length + 1,
        ),
      );
    });
  }

  Widget tokenItem(Token token, SizingInformation sizingInformation,
      TokensController controller) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  RoundImage(
                    image:
                        '$kImageStorage${token.shortName}${token.imageExtension}',
                    extension: token.imageExtension,
                  ),
                  UIHelper.horizontalSpaceSmall(),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          checkEmptyString(token.fullName),
                          style: tokensTitleStyle(sizingInformation),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        GestureDetector(
                          onTap: () => showToastAndCopy(
                            'Copied assetID:',
                            token.assetId,
                            clipboardText: token.assetId,
                          ),
                          child: Text(
                            formatAddress(token.assetId, 8),
                            style: tokensAssetIdStyle(sizingInformation),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        UIHelper.verticalSpaceSmall(),
                        RichText(
                          text: TextSpan(
                            text: 'Market Cap: ',
                            style: tokensAssetIdStyle(sizingInformation),
                            children: <TextSpan>[
                              TextSpan(
                                text: formatToCurrency(
                                  token.marketCap,
                                  showSymbol: true,
                                  decimalDigits: 0,
                                ),
                                style: tokensAssetIdStyle(sizingInformation)
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        UIHelper.verticalSpaceExtraSmall(),
                        Text(
                          formatToCurrency(token.priceString,
                              showSymbol: true, formatOnlyFirstPart: true),
                          style: tokensPriceStyle(sizingInformation),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                if (token.isFavorite) {
                  controller.removeTokenFromFavorites(token);
                } else {
                  controller.addTokenToFavorites(token);
                }
              },
              icon: Icon(
                token.isFavorite ? Icons.star : Icons.star_border,
                color: backgroundOrange,
              ),
            ),
          ],
        ),
        UIHelper.verticalSpaceMedium(),
        Row(
          children: [
            actionButton(
                () => Get.toNamed(Routes.TOKEN_HOLDERS,
                    arguments: {'token': token}),
                HeroIcon(
                  HeroIcons.userGroup,
                  color: Colors.white.withOpacity(0.5),
                ),
                'Holders',
                sizingInformation),
            UIHelper.horizontalSpaceExtraSmall(),
            actionButton(
                () => Get.toNamed(Routes.SUPPLY, arguments: {'token': token}),
                HeroIcon(
                  HeroIcons.chartBar,
                  color: Colors.white.withOpacity(0.5),
                ),
                kShowSupply,
                sizingInformation),
            UIHelper.horizontalSpaceExtraSmall(),
            actionButton(
                () => Get.toNamed(Routes.LOCKER,
                    arguments: {'isPair': false, 'lockerItem': token}),
                Icon(
                  Icons.lock_outline_sharp,
                  color: Colors.white.withOpacity(0.5),
                ),
                kShowLocks,
                sizingInformation),
          ],
        )
      ],
    );
  }

  Widget actionButton(Function onTap, Widget icon, String text,
      SizingInformation sizingInformation) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius:
                BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              UIHelper.horizontalSpaceExtraSmall(),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 100.0,
                ),
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tokenButtonTextStyle(sizingInformation),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
