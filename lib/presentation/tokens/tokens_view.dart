import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
import 'package:ceres_locker_app/core/utils/default_value.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/center_loading.dart';
import 'package:ceres_locker_app/core/widgets/ceres_banner.dart';
import 'package:ceres_locker_app/core/widgets/ceres_header.dart';
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
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const SideMenu(),
      body: Column(
        children: [
          const StatusBar(),
          renderBody(),
        ],
      ),
    );
  }

  Widget renderBody() {
    return Responsive(
      builder: (context, sizingInformation) {
        return Obx(() {
          if (controller.loadingStatus == LoadingStatus.LOADING) return const Expanded(child: CenterLoading());

          return Expanded(
            child: RefreshIndicator(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      const CeresBanner(),
                      CeresHeader(
                        scaffoldKey: _scaffoldKey,
                      ),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(Dimensions.DEFAULT_MARGIN),
                        child: Row(
                          children: [
                            Expanded(
                              child: SearchTextField(
                                onChanged: controller.onTyping,
                                hint: kSearchTextFieldHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  if (controller.tokens.isNotEmpty)
                    (SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        Token token = controller.tokens[index];

                        return ItemContainer(
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
      },
    );
  }

  Widget tokenItem(Token token, SizingInformation sizingInformation) {
    return Row(
      children: [
        RoundImage(image: '$kImageStorage${token.shortName}$kImageExtension'),
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
                formatToCurrency(token.price, showSymbol: true, decimalDigits: 4),
                style: tokensPriceStyle(sizingInformation),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
