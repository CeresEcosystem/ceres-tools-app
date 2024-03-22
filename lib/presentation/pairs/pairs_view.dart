import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/device_screen_type.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/center_loading.dart';
import 'package:ceres_tools_app/core/widgets/ceres_banner.dart';
import 'package:ceres_tools_app/core/widgets/ceres_header.dart';
import 'package:ceres_tools_app/core/widgets/error_text.dart';
import 'package:ceres_tools_app/core/widgets/item_container.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/core/widgets/round_image.dart';
import 'package:ceres_tools_app/core/widgets/search_text_field.dart';
import 'package:ceres_tools_app/core/widgets/side_menu/side_menu.dart';
import 'package:ceres_tools_app/core/widgets/status_bar.dart';
import 'package:ceres_tools_app/domain/models/pair.dart';
import 'package:ceres_tools_app/presentation/pairs/pairs_controller.dart';
import 'package:ceres_tools_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

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
      if (controller.loadingStatus == LoadingStatus.LOADING) {
        return const Expanded(child: CenterLoading());
      }

      if (controller.loadingStatus == LoadingStatus.ERROR) {
        return Expanded(
            child: ErrorText(onButtonPress: () => controller.fetchPairs(true)));
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
                      horizontal: UIHelper.pagePadding(sizingInformation),
                    ),
                    child: Row(
                      children: [
                        sumContainer(kTotalLiquidity, controller.totalLiquidity,
                            sizingInformation),
                        UIHelper.horizontalSpaceSmall(),
                        sumContainer(kTotalVolume, controller.totalVolume,
                            sizingInformation),
                      ],
                    ),
                  ),
                  UIHelper.verticalSpaceMedium(),
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
                ]),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(
                    top: Dimensions.DEFAULT_MARGIN_SMALL,
                    bottom: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: UIHelper.pagePadding(sizingInformation),
                  ),
                  height: 35,
                  child: ListView.separated(
                    itemBuilder: (_, index) {
                      String item = controller.baseAssets[index];
                      bool showIcon = item == 'All';
                      String icon = item == 'Synthetics' ? 'XST' : item;
                      bool isActive = item == 'Synthetics'
                          ? controller.syntheticsFilter
                          : item == controller.baseAsset
                              ? true
                              : false;

                      return GestureDetector(
                        onTap: () {
                          if (item == 'Synthetics') {
                            controller.setSyntheticsFilter();
                          } else {
                            controller.setBaseAsset(item);
                          }
                        },
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: Dimensions.PAIRS_IMAGE_SIZE,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                                Dimensions.DEFAULT_MARGIN),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL / 2,
                            horizontal: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                          ),
                          child: Opacity(
                            opacity: isActive ? 1 : 0.7,
                            child: Center(
                              child: Row(
                                children: [
                                  if (!showIcon) ...[
                                    RoundImage(
                                      image:
                                          '$kImageStorage$icon$kImageExtension',
                                      size: Dimensions.SOCIAL_ICONS_SIZE,
                                    ),
                                    UIHelper.horizontalSpaceExtraSmall(),
                                  ],
                                  Text(
                                    item,
                                    style:
                                        allButtonTextStyle(sizingInformation),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) =>
                        UIHelper.horizontalSpaceExtraSmall(),
                    itemCount: controller.baseAssets.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: UIHelper.pagePadding(sizingInformation),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Volume interval',
                          style: pairsInfoStyle(sizingInformation),
                        ),
                        UIHelper.horizontalSpaceSmall(),
                        Wrap(
                          spacing: 4.0,
                          children: controller.volumeIntervals.map((timeFrame) {
                            return ChoiceChip(
                              label: Text(
                                timeFrame,
                                style: timeFrameChipTextStyle(),
                              ),
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.all(4.0),
                              showCheckmark: false,
                              selected: timeFrame == controller.volumeInterval,
                              onSelected: (_) =>
                                  controller.setVolumeInterval(timeFrame),
                              selectedColor: backgroundPink,
                              side: BorderSide.none,
                              backgroundColor: Colors.white.withOpacity(.1),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
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

  Widget sumContainer(
      String label, String info, SizingInformation sizingInformation) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(
            sizingInformation.deviceScreenType == DeviceScreenType.Mobile
                ? Dimensions.DEFAULT_MARGIN_SMALL
                : Dimensions.DEFAULT_MARGIN),
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
                '${pair.baseToken} / ${pair.shortName}',
                style: tokensTitleStyle(sizingInformation),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                      text: '${pair.baseToken}: ',
                      style: pairsInfoStyle(sizingInformation),
                      children: <TextSpan>[
                        TextSpan(
                          text: formatToCurrency(pair.baseAssetLiquidity),
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
                    formatToCurrency(pair.liquidity,
                        showSymbol: true, decimalDigits: 0),
                    style: pairsLiquidityStyle(sizingInformation),
                  ),
                  UIHelper.verticalSpaceSmall(),
                  if (pair.volumes != null) ...[
                    Text(
                      kPairVolume,
                      style: pairsInfoStyle(sizingInformation),
                    ),
                    Text(
                      formatToCurrency(pair.volumes![controller.volumeInterval],
                          showSymbol: true),
                      style: pairsLiquidityStyle(sizingInformation),
                    ),
                    UIHelper.verticalSpaceSmall(),
                  ],
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
        UIHelper.verticalSpaceMedium(),
        Row(
          children: [
            actionButton(
              () => Get.toNamed(Routes.LOCKER,
                  arguments: {'isPair': true, 'lockerItem': pair}),
              Icon(
                Icons.lock_outline_sharp,
                color: Colors.white.withOpacity(0.5),
                size: 22,
              ),
              kShowLocks,
              sizingInformation,
            ),
            UIHelper.horizontalSpaceExtraSmall(),
            actionButton(
              () => Get.toNamed(
                Routes.PAIRS_LIQUIDITY,
                arguments: pair,
              ),
              HeroIcon(
                HeroIcons.circleStack,
                color: Colors.white.withOpacity(0.5),
                size: 22,
              ),
              kShowLiquidity,
              sizingInformation,
            ),
            UIHelper.horizontalSpaceExtraSmall(),
            actionButton(
              () => Get.toNamed(
                Routes.PAIRS_PROVIDERS,
                arguments: pair,
              ),
              HeroIcon(
                HeroIcons.userGroup,
                color: Colors.white.withOpacity(0.5),
                size: 22,
              ),
              kShowProviders,
              sizingInformation,
            ),
          ],
        )
      ],
    );
  }

  Widget pairImage(Pair pair) {
    return SizedBox(
      width: Dimensions.PAIRS_IMAGE_SIZE * 2,
      child: Stack(
        children: [
          Positioned(
            left:
                Dimensions.PAIRS_IMAGE_SIZE - (Dimensions.PAIRS_IMAGE_SIZE / 4),
            child: RoundImage(
              image: '$kImageStorage${pair.shortName}${pair.imageExtension}',
              size: Dimensions.PAIRS_IMAGE_SIZE,
              extension: pair.imageExtension,
            ),
          ),
          RoundImage(
            image: '$kImageStorage${pair.baseToken}$kImageExtension',
            size: Dimensions.PAIRS_IMAGE_SIZE,
          ),
        ],
      ),
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
