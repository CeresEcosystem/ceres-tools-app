import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
import 'package:ceres_locker_app/core/utils/default_value.dart';
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
      if (controller.loadingStatus == LoadingStatus.LOADING) return const Expanded(child: CenterLoading());

      if (controller.loadingStatus == LoadingStatus.ERROR) return Expanded(child: ErrorText(onButtonPress: () => controller.fetchTokens(true)));

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
                    padding: EdgeInsets.symmetric(horizontal: UIHelper.pagePadding(sizingInformation)),
                    child: SearchTextField(
                      onChanged: (text) => controller.onTyping(text),
                      hint: kSearchTextFieldHint,
                    ),
                  ),
                  UIHelper.verticalSpaceMediumLarge(),
                ]),
              ),
              if (controller.tokens.isNotEmpty)
                (SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    Token token = controller.tokens[index];

                    return ItemContainer(
                      sizingInformation: sizingInformation,
                      child: tokenItem(token, sizingInformation),
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
    final String imageExtension = token.shortName != null && token.shortName!.isNotEmpty && token.shortName!.contains('COCO') ? kImagePNGExtension : kImageExtension;

    return Row(
      children: [
        RoundImage(
          image: '$kImageStorage${token.shortName}$imageExtension',
          extension: imageExtension,
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
                  'AssetID: ${token.assetId}',
                  style: tokensAssetIdStyle(sizingInformation),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              UIHelper.verticalSpaceExtraSmall(),
              Text(
                formatToCurrency(token.price, showSymbol: true, formatOnlyFirstPart: true),
                style: tokensPriceStyle(sizingInformation),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => print('dosao'),
          icon: const Icon(Icons.star),
        ),
      ],
    );
  }
}
