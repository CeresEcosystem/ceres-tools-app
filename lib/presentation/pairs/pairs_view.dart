import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
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
import 'package:ceres_locker_app/domain/models/pair.dart';
import 'package:ceres_locker_app/presentation/pairs/pairs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PairsView extends GetView<PairsController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PairsView({Key? key}) : super(key: key);

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
                                hint: kSearchTextFieldHintOnlyToken,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  if (controller.pairs.isNotEmpty)
                    (SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          Pair pair = controller.pairs[index];

                          if (pair.shortName == kXOR) return null;

                          return ItemContainer(
                            child: pairItem(pair, sizingInformation),
                          );
                        },
                        childCount: controller.pairs.length,
                      ),
                    )),
                ],
              ),
              onRefresh: () async {},
            ),
          );
        });
      },
    );
  }

  Widget pairItem(Pair pair, SizingInformation sizingInformation) {
    return Column(
      children: [
        Row(
          children: [
            pairImage(pair),
            UIHelper.horizontalSpaceSmall(),
            Text(
              '$kXOR / ${pair.shortName}',
              style: tokensTitleStyle(sizingInformation),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        UIHelper.verticalSpaceMedium(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kPoolDetails,
                    style: pairsLabelStyle(sizingInformation),
                  ),
                  UIHelper.verticalSpaceSmall(),
                  RichText(
                    text: TextSpan(
                      text: '$kXOR: ',
                      style: pairsInfoStyle(sizingInformation),
                      children: <TextSpan>[
                        TextSpan(
                          text: formatToCurrency(pair.xorLiquidity),
                          style: pairsLabelStyle(sizingInformation),
                        ),
                      ],
                    ),
                  ),
                  UIHelper.verticalSpaceSmall(),
                  RichText(
                    text: TextSpan(
                      text: '${pair.shortName}: ',
                      style: pairsInfoStyle(sizingInformation),
                      children: <TextSpan>[
                        TextSpan(
                          text: formatToCurrency(pair.targetAssetLiquidity),
                          style: pairsLabelStyle(sizingInformation),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    kPairLiquidity,
                    style: pairsInfoStyle(sizingInformation),
                  ),
                  Text(
                    formatToCurrency(pair.liquidity, showSymbol: true),
                    style: pairsLiquidityStyle(sizingInformation),
                  ),
                  UIHelper.verticalSpaceSmall(),
                  Text(
                    kPairVolume,
                    style: pairsInfoStyle(sizingInformation),
                  ),
                  Text(
                    formatToCurrency(pair.volume, showSymbol: true),
                    style: pairsLiquidityStyle(sizingInformation),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget pairImage(Pair pair) {
    return SizedBox(
      width: Dimensions.PAIRS_IMAGE_SIZE * 2,
      child: Stack(
        children: [
          Positioned(
            left: Dimensions.PAIRS_IMAGE_SIZE - (Dimensions.PAIRS_IMAGE_SIZE / 4),
            child: RoundImage(
              image: '$kImageStorage${pair.shortName}$kImageExtension',
              size: Dimensions.PAIRS_IMAGE_SIZE,
            ),
          ),
          const RoundImage(
            image: '$kImageStorage$kXOR$kImageExtension',
            size: Dimensions.PAIRS_IMAGE_SIZE,
          ),
        ],
      ),
    );
  }
}
