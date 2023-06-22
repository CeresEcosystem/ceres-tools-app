import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/address_format.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
import 'package:ceres_locker_app/core/utils/default_value.dart';
import 'package:ceres_locker_app/core/utils/image_extension.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/center_loading.dart';
import 'package:ceres_locker_app/core/widgets/ceres_banner.dart';
import 'package:ceres_locker_app/core/widgets/ceres_header.dart';
import 'package:ceres_locker_app/core/widgets/error_text.dart';
import 'package:ceres_locker_app/core/widgets/item_container.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:ceres_locker_app/core/widgets/round_image.dart';
import 'package:ceres_locker_app/core/widgets/search_text_field.dart';
import 'package:ceres_locker_app/core/widgets/side_menu/side_menu.dart';
import 'package:ceres_locker_app/core/widgets/status_bar.dart';
import 'package:ceres_locker_app/domain/models/token.dart';
import 'package:ceres_locker_app/presentation/tokens/tokens_controller.dart';
import 'package:ceres_locker_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TokensView extends GetView<TokensController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TokensView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          endDrawer: SideMenu(),
          body: Column(
            children: [
              const StatusBar(),
              renderBody(sizingInformation),
            ],
          ),
        );
      },
    );
  }

  Widget renderBody(SizingInformation sizingInformation) {
    return Obx(() {
      if (controller.loadingStatus == LoadingStatus.LOADING) {
        return const Expanded(child: CenterLoading());
      }

      if (controller.loadingStatus == LoadingStatus.ERROR) {
        return Expanded(
            child:
                ErrorText(onButtonPress: () => controller.fetchTokens(true)));
      }

      return Expanded(
        child: RefreshIndicator(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  const CeresBanner(),
                  UIHelper.verticalSpaceMediumLarge(),
                  CeresHeader(
                    scaffoldKey: _scaffoldKey,
                  ),
                  UIHelper.verticalSpaceMediumLarge(),
                ]),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: UIHelper.pagePadding(sizingInformation)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchTextField(
                          onChanged: (text) => controller.onTyping(text),
                          hint: kSearchTextFieldHint,
                        ),
                        UIHelper.verticalSpaceMediumLarge(),
                        Row(
                          children: [
                            ActionChip(
                              labelPadding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.zero,
                              label: SizedBox(
                                height: Dimensions.CHIP_SIZE,
                                width: Dimensions.CHIP_SIZE * 1.2,
                                child: Center(
                                  child: Opacity(
                                    opacity:
                                        controller.showOnlyFavorites ? 0.3 : 1,
                                    child: Text(
                                      kAll,
                                      style:
                                          allButtonTextStyle(sizingInformation),
                                    ),
                                  ),
                                ),
                              ),
                              visualDensity: VisualDensity.compact,
                              onPressed: () =>
                                  controller.setShowOnlyFavorites(false),
                            ),
                            UIHelper.horizontalSpaceSmall(),
                            ActionChip(
                              labelPadding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.zero,
                              label: SizedBox(
                                height: Dimensions.CHIP_SIZE,
                                width: Dimensions.CHIP_SIZE * 1.2,
                                child: Center(
                                  child: Opacity(
                                    opacity:
                                        !controller.showOnlyFavorites ? 0.3 : 1,
                                    child: const Icon(Icons.star),
                                  ),
                                ),
                              ),
                              visualDensity: VisualDensity.compact,
                              onPressed: () =>
                                  controller.setShowOnlyFavorites(true),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  UIHelper.verticalSpaceExtraSmall(),
                ]),
              ),
              if (controller.tokens.isNotEmpty)
                (SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    Token token = controller.tokens[index];

                    return ItemContainer(
                      sizingInformation: sizingInformation,
                      child: tokenItem(token, sizingInformation),
                      onPress: () =>
                          controller.openChartForToken(token.shortName),
                    );
                  }, childCount: controller.tokens.length),
                )),
            ],
          ),
          onRefresh: () async => controller.fetchTokens(true),
        ),
      );
    });
  }

  Widget tokenItem(Token token, SizingInformation sizingInformation) {
    final String imgExtension = imageExtension(token.shortName);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  RoundImage(
                    image: '$kImageStorage${token.shortName}$imgExtension',
                    extension: imgExtension,
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
                        UIHelper.verticalSpaceExtraSmall(),
                        GestureDetector(
                          onTap: () => controller.copyAsset(token.assetId!),
                          child: Text(
                            'AssetID: ${formatAddress(token.assetId)}',
                            style: tokensAssetIdStyle(sizingInformation),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        UIHelper.verticalSpaceExtraSmall(),
                        Text(
                          formatToCurrency(token.price,
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
                () => Get.toNamed(Routes.SUPPLY, arguments: {'token': token}),
                Icon(
                  Icons.bar_chart_outlined,
                  color: Colors.white.withOpacity(0.5),
                ),
                kShowSupply,
                sizingInformation),
            UIHelper.horizontalSpaceMedium(),
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
