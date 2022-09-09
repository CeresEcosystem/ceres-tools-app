import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/device_screen_type.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
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
import 'package:ceres_locker_app/domain/models/pair.dart';
import 'package:ceres_locker_app/presentation/pairs/pairs_controller.dart';
import 'package:ceres_locker_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PairsView extends GetView<PairsController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PairsView({Key? key}) : super(key: key);

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

      if (controller.loadingStatus == LoadingStatus.ERROR) return Expanded(child: ErrorText(onButtonPress: () => controller.fetchPairs(true)));

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
                      horizontal: UIHelper.pagePadding(sizingInformation),
                    ),
                    child: Row(
                      children: [
                        sumContainer(kTotalLiquidity, controller.totalLiquidity, sizingInformation),
                        UIHelper.horizontalSpaceSmall(),
                        sumContainer(kTotalVolume, controller.totalVolume, sizingInformation),
                      ],
                    ),
                  ),
                  UIHelper.verticalSpaceMediumLarge(),
                ]),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: UIHelper.pagePadding(sizingInformation),
                    ),
                    child: SearchTextField(
                      onChanged: controller.onTyping,
                      hint: kSearchTextFieldHintOnlyToken,
                    ),
                  ),
                  UIHelper.verticalSpaceMediumLarge(),
                ]),
              ),
              if (controller.pairs.isNotEmpty)
                (SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      Pair pair = controller.pairs[index];

                      if (pair.shortName == kXOR) return null;

                      return ItemContainer(
                        sizingInformation: sizingInformation,
                        child: pairItem(pair, sizingInformation),
                      );
                    },
                    childCount: controller.pairs.length,
                  ),
                )),
            ],
          ),
          onRefresh: () async => controller.fetchPairs(true),
        ),
      );
    });
  }

  Widget sumContainer(String label, String info, SizingInformation sizingInformation) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(sizingInformation.deviceScreenType == DeviceScreenType.Mobile ? Dimensions.DEFAULT_MARGIN_SMALL : Dimensions.DEFAULT_MARGIN),
        decoration: BoxDecoration(
          color: backgroundColorDark,
          borderRadius: BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: pairsSumContainerLabelStyle(sizingInformation),
            ),
            UIHelper.verticalSpaceSmall(),
            Text(
              info,
              style: pairsSumContainerInfoStyle(sizingInformation),
            ),
          ],
        ),
      ),
    );
  }

  Widget pairItem(Pair pair, SizingInformation sizingInformation) {
    return Column(
      children: [
        Row(
          children: [
            pairImage(pair),
            UIHelper.horizontalSpaceSmall(),
            Expanded(
              child: Text(
                '$kXOR / ${pair.shortName}',
                style: tokensTitleStyle(sizingInformation),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            UIHelper.horizontalSpaceExtraSmall(),
            IconButton(
              onPressed: () => Get.toNamed(Routes.LOCKER, arguments: {'isPair': true, 'lockerItem': pair}),
              icon: Icon(
                Icons.lock_outline_sharp,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
        UIHelper.verticalSpaceMedium(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                    formatToCurrency(pair.liquidity, showSymbol: true, decimalDigits: 0),
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
                  UIHelper.verticalSpaceSmall(),
                  Text(
                    kPairLockedLiquidity,
                    style: pairsInfoStyle(sizingInformation),
                  ),
                  Text(
                    '${formatToCurrency(pair.lockedLiquidity, showSymbol: false)}%',
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
    final String imgExtension = imageExtension(pair.shortName);

    return SizedBox(
      width: Dimensions.PAIRS_IMAGE_SIZE * 2,
      child: Stack(
        children: [
          Positioned(
            left: Dimensions.PAIRS_IMAGE_SIZE - (Dimensions.PAIRS_IMAGE_SIZE / 4),
            child: RoundImage(
              image: '$kImageStorage${pair.shortName}$imgExtension',
              size: Dimensions.PAIRS_IMAGE_SIZE,
              extension: imgExtension,
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
