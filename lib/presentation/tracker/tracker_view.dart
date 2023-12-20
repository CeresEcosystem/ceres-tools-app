import 'package:ceres_tools_app/core/assets/fonts/flaticon.dart';
import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
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
import 'package:ceres_tools_app/core/widgets/line_chart.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/core/widgets/round_image.dart';
import 'package:ceres_tools_app/core/widgets/side_menu/side_menu.dart';
import 'package:ceres_tools_app/core/widgets/status_bar.dart';
import 'package:ceres_tools_app/domain/models/block.dart';
import 'package:ceres_tools_app/presentation/tracker/tracker_controller.dart';
import 'package:ceres_tools_app/presentation/tracker/widgets/faqs_item.dart';
import 'package:ceres_tools_app/presentation/tracker/widgets/token_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackerView extends GetView<TrackerController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TrackerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return Scaffold(
          key: _scaffoldKey,
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
      if (controller.loadingStatus == LoadingStatus.ERROR) {
        return Expanded(
          child: ErrorText(
            onButtonPress: () =>
                controller.fetchTracker(controller.selectedToken),
          ),
        );
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
                    padding: const EdgeInsets.all(Dimensions.DEFAULT_MARGIN),
                    child: Column(
                      children: [
                        TokenTab(
                          tabs: controller.tabs,
                          selectedToken: controller.selectedToken,
                          changeToken: controller.changeToken,
                        ),
                        Text(
                          'Track ${controller.selectedToken}',
                          style: pageTitleStyle(sizingInformation),
                        ),
                        UIHelper.verticalSpaceExtraSmall(),
                        Text(
                          'Follow the progression of ${controller.selectedToken}.',
                          style: pageSubtitleStyle(sizingInformation),
                        ),
                        UIHelper.verticalSpaceMedium(),
                      ],
                    ),
                  ),
                ]),
              ),
              if (controller.loadingStatus == LoadingStatus.LOADING)
                (SliverList(
                  delegate: SliverChildListDelegate([
                    const CenterLoading(),
                  ]),
                ))
              else
                (SliverList(
                  delegate: SliverChildListDelegate([
                    if (controller.burnData != null)
                      (firstBlock(sizingInformation)),
                    if (controller.xorSpent != null &&
                        controller.xorSpent!.isNotEmpty)
                      (Column(
                        children: [
                          UIHelper.verticalSpaceSmall(),
                          secondBlock(sizingInformation)
                        ],
                      )),
                    if (controller.mainTableData != null &&
                        controller.mainTableData!.isNotEmpty)
                      (Column(
                        children: [
                          UIHelper.verticalSpaceSmall(),
                          thirdBlock(sizingInformation)
                        ],
                      )),
                    if (controller.pswapBurningGraphData != null &&
                        controller.pswapBurningGraphData!.isNotEmpty)
                      (Column(
                        children: [
                          UIHelper.verticalSpaceLarge(),
                          fourthBlock(sizingInformation)
                        ],
                      )),
                    if (controller.pswapSupplyGraphData != null &&
                        controller.pswapSupplyGraphData!.isNotEmpty)
                      (Column(
                        children: [
                          UIHelper.verticalSpaceLarge(),
                          fifthBlock(sizingInformation)
                        ],
                      )),
                    if (controller.selectedToken == 'PSWAP')
                      (Column(
                        children: [
                          UIHelper.verticalSpaceLarge(),
                          seventhBlock(sizingInformation),
                        ],
                      )),
                    if (controller.selectedToken == 'PSWAP')
                      (Column(
                        children: [
                          UIHelper.verticalSpaceLarge(),
                          eightBlock(sizingInformation),
                        ],
                      )),
                    UIHelper.verticalSpaceLarge(),
                  ]),
                ))
            ],
          ),
          onRefresh: () async =>
              controller.fetchTracker(controller.selectedToken),
        ),
      );
    });
  }

  Widget buttons(SizingInformation sizingInformation, Function onPress,
      String selectedFilter,
      {MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
    double rightPadding = mainAxisAlignment == MainAxisAlignment.start
        ? Dimensions.DEFAULT_MARGIN_SMALL
        : 0;
    double leftPadding = mainAxisAlignment == MainAxisAlignment.end
        ? Dimensions.DEFAULT_MARGIN_SMALL
        : 0;

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: controller.filterTimes.map((filter) {
        return GestureDetector(
          onTap: () => onPress(filter),
          child: Padding(
            padding: EdgeInsets.only(right: rightPadding, left: leftPadding),
            child: Text(
              filter,
              style: buttonFilterStyle(sizingInformation).copyWith(
                color: selectedFilter == filter
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                fontWeight: selectedFilter == filter
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget firstBlock(SizingInformation sizingInformation) {
    return ItemContainer(
      sizingInformation: sizingInformation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buttons(
            sizingInformation,
            (filter) => controller.setFilterPSWAPBurn(filter),
            controller.selectedFilterPSWAPBurn,
          ),
          UIHelper.verticalSpaceMediumLarge(),
          Text(
            '${controller.selectedToken} gross burn',
            style: trackerBlockLabelTitleStyle(sizingInformation),
          ),
          UIHelper.verticalSpaceExtraSmall(),
          RichText(
            text: TextSpan(
              text: formatToCurrency(controller.burnData?['gross']),
              style: trackerBlockPriceStyle(sizingInformation),
              children: <TextSpan>[
                TextSpan(
                  text: ' ${controller.selectedToken}',
                  style: trackerBlockPriceLabelStyle(sizingInformation),
                ),
              ],
            ),
          ),
          UIHelper.verticalSpaceMediumLarge(),
          Text(
            '${controller.selectedToken} net burn',
            style: trackerBlockLabelTitleStyle(sizingInformation),
          ),
          UIHelper.verticalSpaceExtraSmall(),
          RichText(
            text: TextSpan(
              text: formatToCurrency(controller.burnData?['net']),
              style: trackerBlockPriceStyle(sizingInformation).copyWith(
                fontSize: subtitle1,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ' ${controller.selectedToken}',
                  style:
                      trackerBlockPriceLabelStyle(sizingInformation).copyWith(
                    fontSize: subtitle1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget pagination(
      int currentPage,
      int lastPage,
      Function onPreviousClick,
      Function onNextClick,
      Function onFirstClick,
      Function onLastClick,
      SizingInformation sizingInformation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => onFirstClick(),
          icon: const Icon(
            Flaticon.arrowLeftDouble,
            size: Dimensions.ICON_SIZE_SMALL,
          ),
        ),
        IconButton(
          onPressed: () => onPreviousClick(),
          icon: const Icon(
            Flaticon.arrowLeft,
            size: Dimensions.ICON_SIZE_SMALL,
          ),
        ),
        Text(
          '$currentPage/$lastPage',
          style: trackerBlockBlockStyle(sizingInformation),
        ),
        IconButton(
          onPressed: () => onNextClick(),
          icon: const Icon(
            Flaticon.arrowRight,
            size: Dimensions.ICON_SIZE_SMALL,
          ),
        ),
        IconButton(
          onPressed: () => onLastClick(),
          icon: const Icon(
            Flaticon.arrowRightDouble,
            size: Dimensions.ICON_SIZE_SMALL,
          ),
        ),
      ],
    );
  }

  Widget secondBlock(SizingInformation sizingInformation) {
    return ItemContainer(
      sizingInformation: sizingInformation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.selectedToken == 'PSWAP' ? 'XOR spent' : 'TBC burns',
                style: trackerBlockLabelTitleStyle(sizingInformation),
              ),
              buttons(
                sizingInformation,
                (filter) => controller.setFilterXORSpent(filter),
                controller.selectedFilterXORSpent,
                mainAxisAlignment: MainAxisAlignment.end,
              ),
            ],
          ),
          UIHelper.verticalSpaceSmallMedium(),
          Column(
            children: controller.xorSpent!.map((Block block) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.DEFAULT_MARGIN_SMALL / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'block #${formatToCurrency(block.blockNumber, decimalDigits: 0)}',
                        style: trackerBlockBlockStyle(sizingInformation),
                      ),
                    ),
                    UIHelper.horizontalSpaceSmall(),
                    Expanded(
                      child: Text(
                        controller.selectedToken == 'VAL'
                            ? '${formatToCurrency(block.grossBurn, decimalDigits: 4)} VAL'
                            : '${formatToCurrency(block.xorSpent, decimalDigits: 4)} $kXOR',
                        style: trackerBlockBlockStyle(sizingInformation),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          UIHelper.verticalSpaceMedium(),
          pagination(
            controller.xorSpentPagination,
            controller.xorSpentTotalPages,
            () => controller.setXorSpentPage(controller.xorSpentPagination - 1),
            () => controller.setXorSpentPage(controller.xorSpentPagination + 1),
            () => controller.setXorSpentPage(1),
            () => controller.setXorSpentPage(controller.xorSpentTotalPages),
            sizingInformation,
          ),
        ],
      ),
    );
  }

  Widget thirdBlock(SizingInformation sizingInformation) {
    return ItemContainer(
      sizingInformation: sizingInformation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Burns by fees',
            style: trackerBlockHeaderStyle(sizingInformation)
                .copyWith(color: Colors.white),
          ),
          UIHelper.verticalSpaceSmallMedium(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: controller.mainTableDataHeader.map((item) {
                    return rowItem(
                      Text(
                        item,
                        style: trackerBlockHeaderStyle(sizingInformation),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
                UIHelper.verticalSpaceSmallMedium(),
                ...controller.mainTableData!.map((Block block) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.DEFAULT_MARGIN_SMALL / 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        rowItem(
                          Text(
                            '${controller.selectedToken == 'VAL' && block.blockNumber == kValLatestBlock ? 'until' : 'block'} #${formatToCurrency(block.blockNumber, decimalDigits: 0)}',
                            style: trackerBlockBlockStyle(sizingInformation),
                          ),
                        ),
                        if (controller.selectedToken == 'VAL')
                          (rowItem(
                            Text(
                              formatToCurrency(block.xorDedicatedForBuyBack,
                                  decimalDigits: 3),
                              style: trackerBlockBlockStyle(sizingInformation),
                            ),
                          )),
                        rowItem(
                          Text(
                            formatToCurrency(block.grossBurn, decimalDigits: 3),
                            style: trackerBlockBlockStyle(sizingInformation),
                          ),
                        ),
                        if (controller.selectedToken == 'PSWAP')
                          (rowItem(
                            Text(
                              formatToCurrency(block.remintedLp,
                                  decimalDigits: 3),
                              style: trackerBlockBlockStyle(sizingInformation),
                            ),
                          )),
                        rowItem(
                          Text(
                            formatToCurrency(block.remintedParliament,
                                decimalDigits: 3),
                            style: trackerBlockBlockStyle(sizingInformation),
                          ),
                        ),
                        rowItem(
                          Text(
                            formatToCurrency(block.netBurn, decimalDigits: 3),
                            style: trackerBlockBlockStyle(sizingInformation),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          UIHelper.verticalSpaceMedium(),
          pagination(
            controller.mainTablePagination,
            controller.mainTableTotalPages,
            () =>
                controller.setMainTablePage(controller.mainTablePagination - 1),
            () =>
                controller.setMainTablePage(controller.mainTablePagination + 1),
            () => controller.setMainTablePage(1),
            () => controller.setMainTablePage(controller.mainTableTotalPages),
            sizingInformation,
          ),
        ],
      ),
    );
  }

  Widget rowItem(Widget child) {
    return SizedBox(
      width: Dimensions.ROW_ITEM_WIDTH,
      child: child,
    );
  }

  Widget fourthBlock(SizingInformation sizingInformation) {
    return Column(
      children: [
        Text(
          'Track ${controller.selectedToken} burning',
          style: trackerTitleStyle(sizingInformation),
        ),
        UIHelper.verticalSpaceMedium(),
        ItemContainer(
          sizingInformation: sizingInformation,
          child: Chart(
            graphData: controller.pswapBurningGraphData!,
            getTooltipData: controller.getTooltipData,
          ),
        ),
      ],
    );
  }

  Widget fifthBlock(SizingInformation sizingInformation) {
    return Column(
      children: [
        Text(
          'Track ${controller.selectedToken} supply',
          style: trackerTitleStyle(sizingInformation),
        ),
        UIHelper.verticalSpaceMedium(),
        ItemContainer(
          sizingInformation: sizingInformation,
          child: Chart(
            graphData: controller.pswapSupplyGraphData!,
            getTooltipData: controller.getSupplyTooltipData,
            showFullValue: true,
          ),
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget seventhBlock(SizingInformation sizingInformation) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Dimensions.DEFAULT_MARGIN),
          child: Text(
            kFAQSTitle,
            style: trackerTitleStyle(sizingInformation),
            textAlign: TextAlign.center,
          ),
        ),
        UIHelper.verticalSpaceExtraSmall(),
        Text(
          kFAQSSubtitle,
          style: trackerSubtitleStyle(sizingInformation),
        ),
        UIHelper.verticalSpaceMediumLarge(),
        Column(
          children: controller.faqs.map((e) {
            return FaqsItem(
              item: e,
              scrollToSelectedContent: _scrollToSelectedContent,
            );
          }).toList(),
        ),
      ],
    );
  }

  void _scrollToSelectedContent(GlobalKey expansionTileKey) {
    final keyContext = expansionTileKey.currentContext;
    if (keyContext != null) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: const Duration(milliseconds: 200));
      });
    }
  }

  Widget eightBlock(SizingInformation sizingInformation) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.DEFAULT_MARGIN),
      child: Column(
        children: [
          Text(
            kSponsoredBy,
            style: trackerTitleStyle(sizingInformation),
          ),
          UIHelper.verticalSpaceMediumLarge(),
          GestureDetector(
            onTap: () => _launchURL(kPSWAPCommunity),
            child: const RoundImage(
              image: 'lib/core/assets/images/pococo_icon.png',
              localImage: true,
              size: Dimensions.SPONSORS_IMAGE_SIZE,
            ),
          )
        ],
      ),
    );
  }
}
