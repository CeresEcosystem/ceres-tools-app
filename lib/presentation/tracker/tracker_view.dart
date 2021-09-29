import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/center_loading.dart';
import 'package:ceres_locker_app/core/widgets/ceres_banner.dart';
import 'package:ceres_locker_app/core/widgets/ceres_header.dart';
import 'package:ceres_locker_app/core/widgets/item_container.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:ceres_locker_app/core/widgets/side_menu/side_menu.dart';
import 'package:ceres_locker_app/core/widgets/status_bar.dart';
import 'package:ceres_locker_app/presentation/tracker/tracker_controller.dart';
import 'package:ceres_locker_app/presentation/tracker/widgets/faqs_item.dart';
import 'package:ceres_locker_app/presentation/tracker/widgets/tracker_chart.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class TrackerView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TrackerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TrackerController controller = Get.put(TrackerController());

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SideMenu(),
      body: Column(
        children: [
          const StatusBar(),
          renderBody(controller),
        ],
      ),
    );
  }

  Widget renderBody(TrackerController controller) {
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
                        child: Column(
                          children: [
                            Text(
                              kTrackCeresToken,
                              style: pageTitleStyle(sizingInformation),
                            ),
                            UIHelper.verticalSpaceExtraSmall(),
                            Text(
                              kTrackCeresTokenSubtitle,
                              style: pageSubtitleStyle(sizingInformation),
                            ),
                            UIHelper.verticalSpaceMedium(),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      firstBlock(controller, sizingInformation),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      UIHelper.verticalSpaceSmall(),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      secondBlock(controller, sizingInformation),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      UIHelper.verticalSpaceSmall(),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      thirdBlock(controller, sizingInformation),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      UIHelper.verticalSpaceLarge(),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      fourthBlock(sizingInformation),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      UIHelper.verticalSpaceLarge(),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      fifthBlock(sizingInformation),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      UIHelper.verticalSpaceLarge(),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      sixthBlock(controller, sizingInformation),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      UIHelper.verticalSpaceLarge(),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      seventhBlock(controller, sizingInformation),
                    ]),
                  ),
                ],
              ),
              onRefresh: () async {},
            ),
          );
        });
      },
    );
  }

  Widget buttons(TrackerController controller, SizingInformation sizingInformation, Function onPress, String selectedFilter, {MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
    double rightPadding = mainAxisAlignment == MainAxisAlignment.start ? Dimensions.DEFAULT_MARGIN_SMALL : 0;
    double leftPadding = mainAxisAlignment == MainAxisAlignment.end ? Dimensions.DEFAULT_MARGIN_SMALL : 0;

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
                color: selectedFilter == filter ? Colors.white : Colors.white.withOpacity(0.5),
                fontWeight: selectedFilter == filter ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget firstBlock(TrackerController controller, SizingInformation sizingInformation) {
    return ItemContainer(
      sizingInformation: sizingInformation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buttons(
            controller,
            sizingInformation,
            (filter) => controller.setFilter(filter),
            controller.selectedFilter,
          ),
          UIHelper.verticalSpaceMediumLarge(),
          Text(
            kPswapBurn,
            style: trackerBlockLabelTitleStyle(sizingInformation),
          ),
          UIHelper.verticalSpaceExtraSmall(),
          RichText(
            text: TextSpan(
              text: '138,782.98',
              style: trackerBlockPriceStyle(sizingInformation),
              children: <TextSpan>[
                TextSpan(
                  text: ' $kPswap',
                  style: trackerBlockPriceLabelStyle(sizingInformation),
                ),
              ],
            ),
          ),
          UIHelper.verticalSpaceMediumLarge(),
          Text(
            kPswapNetBurn,
            style: trackerBlockLabelTitleStyle(sizingInformation),
          ),
          UIHelper.verticalSpaceExtraSmall(),
          RichText(
            text: TextSpan(
              text: '32,810.21',
              style: trackerBlockPriceStyle(sizingInformation).copyWith(
                fontSize: subtitle1,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ' $kPswap',
                  style: trackerBlockPriceLabelStyle(sizingInformation).copyWith(
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

  Widget pagination(int currentPage, int lastPage, Function onPreviousClick, Function onNextClick, SizingInformation sizingInformation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => onPreviousClick(),
          icon: const Icon(
            Icons.chevron_left,
            size: Dimensions.ICON_SIZE,
          ),
        ),
        Text(
          '$currentPage/$lastPage',
          style: trackerBlockBlockStyle(sizingInformation),
        ),
        IconButton(
          onPressed: () => onNextClick(),
          icon: const Icon(
            Icons.chevron_right,
            size: Dimensions.ICON_SIZE,
          ),
        ),
      ],
    );
  }

  Widget secondBlock(TrackerController controller, SizingInformation sizingInformation) {
    return ItemContainer(
      sizingInformation: sizingInformation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                kXORSpent,
                style: trackerBlockLabelTitleStyle(sizingInformation),
              ),
              buttons(
                controller,
                sizingInformation,
                (filter) => controller.setFilter(filter),
                controller.selectedFilter,
                mainAxisAlignment: MainAxisAlignment.end,
              ),
            ],
          ),
          UIHelper.verticalSpaceMediumLarge(),
          Column(
            children: controller.xorSpent.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.DEFAULT_MARGIN_SMALL / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '$kBlock ${item['block']}',
                        style: trackerBlockBlockStyle(sizingInformation),
                      ),
                    ),
                    UIHelper.horizontalSpaceSmall(),
                    Expanded(
                      child: Text(
                        '${item['xor']} $kXOR',
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
            sizingInformation,
          ),
        ],
      ),
    );
  }

  Widget thirdBlock(TrackerController controller, SizingInformation sizingInformation) {
    return ItemContainer(
      sizingInformation: sizingInformation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                UIHelper.verticalSpaceMediumLarge(),
                ...controller.mainTableData.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.DEFAULT_MARGIN_SMALL / 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        rowItem(
                          Text(
                            item['block'],
                            style: trackerBlockBlockStyle(sizingInformation),
                          ),
                        ),
                        rowItem(
                          Text(
                            item['gross'],
                            style: trackerBlockBlockStyle(sizingInformation),
                          ),
                        ),
                        rowItem(
                          Text(
                            item['remintedlp'],
                            style: trackerBlockBlockStyle(sizingInformation),
                          ),
                        ),
                        rowItem(
                          Text(
                            item['remintedp'],
                            style: trackerBlockBlockStyle(sizingInformation),
                          ),
                        ),
                        rowItem(
                          Text(
                            item['pswap'],
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
            () => controller.setMainTablePage(controller.mainTablePagination - 1),
            () => controller.setMainTablePage(controller.mainTablePagination + 1),
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
          kTrackPSBurning,
          style: trackerTitleStyle(sizingInformation),
        ),
        UIHelper.verticalSpaceMedium(),
        ItemContainer(
          sizingInformation: sizingInformation,
          child: const TrackerChart(),
        ),
      ],
    );
  }

  Widget fifthBlock(SizingInformation sizingInformation) {
    return Column(
      children: [
        Text(
          kTrackPSSupply,
          style: trackerTitleStyle(sizingInformation),
        ),
        UIHelper.verticalSpaceMedium(),
        ItemContainer(
          sizingInformation: sizingInformation,
          child: const TrackerChart(),
        ),
      ],
    );
  }

  Widget sixthBlock(TrackerController controller, SizingInformation sizingInformation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.DEFAULT_MARGIN),
      child: Column(
        children: [
          Text(
            kContactTitle,
            style: trackerContactTitleStyle(sizingInformation),
          ),
          UIHelper.verticalSpaceExtraSmall(),
          Text(
            kContactSubtitle,
            style: trackerTitleStyle(sizingInformation),
          ),
          UIHelper.verticalSpaceMediumLarge(),
          socialsGroup(controller),
        ],
      ),
    );
  }

  Widget socialsGroup(TrackerController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 2,
            color: backgroundColorLight,
          ),
        ),
        ...controller.contactSocials.map((social) {
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _launchURL(social['url']!),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.DEFAULT_MARGIN / 2),
                padding: const EdgeInsets.all(Dimensions.DEFAULT_MARGIN),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(Dimensions.DEFAULT_MARGIN / 2)),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: Dimensions.SOCIAL_ICONS_SIZE * 1.2,
                  ),
                  child: Image.asset(social['icon']!),
                ),
              ),
            ),
          );
        }).toList(),
        Expanded(
          child: Container(
            height: 2,
            color: backgroundColorLight,
          ),
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Widget seventhBlock(TrackerController controller, SizingInformation sizingInformation) {
    return Padding(
      padding: EdgeInsets.only(bottom: sizingInformation.bottomSafeAreaSize + Dimensions.DEFAULT_MARGIN),
      child: Column(
        children: [
          Text(
            kFAQSTitle,
            style: trackerTitleStyle(sizingInformation),
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
      ),
    );
  }

  void _scrollToSelectedContent(GlobalKey expansionTileKey) {
    final keyContext = expansionTileKey.currentContext;
    if (keyContext != null) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext, duration: const Duration(milliseconds: 200));
      });
    }
  }
}
