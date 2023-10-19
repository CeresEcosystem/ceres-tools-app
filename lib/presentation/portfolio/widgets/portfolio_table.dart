import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/round_image.dart';
import 'package:ceres_locker_app/core/widgets/swap_item.dart';
import 'package:ceres_locker_app/domain/models/portfolio_item.dart';
import 'package:ceres_locker_app/domain/models/swap.dart';
import 'package:ceres_locker_app/presentation/portfolio/portfolio_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortfolioItemWidget extends StatelessWidget {
  final PortfolioItem portfolioItem;
  final String selectedTab;
  final SizingInformation sizingInformation;
  final String selectedTimeFrame;

  const PortfolioItemWidget({
    Key? key,
    required this.portfolioItem,
    required this.selectedTab,
    required this.sizingInformation,
    required this.selectedTimeFrame,
  }) : super(key: key);

  Widget getHeader(PortfolioItem portfolioItem) {
    switch (selectedTab) {
      case 'Liquidity':
        return Row(
          children: [
            SizedBox(
              width: Dimensions.GRID_LODO * 2,
              child: Stack(
                children: [
                  Positioned(
                    left: Dimensions.GRID_LODO / 2,
                    child: RoundImage(
                      image:
                          '$kImageStorage${portfolioItem.token}${portfolioItem.imageExtension}',
                      size: Dimensions.GRID_LODO,
                      extension: portfolioItem.imageExtension,
                    ),
                  ),
                  RoundImage(
                    image:
                        '$kImageStorage${portfolioItem.baseAsset}$kImageExtension',
                    size: Dimensions.GRID_LODO,
                  ),
                ],
              ),
            ),
            Text(
              '${portfolioItem.baseAsset} / ${portfolioItem.token}',
              style: dataTableTextStyle(sizingInformation),
            ),
          ],
        );
      default:
        return Row(
          children: [
            RoundImage(
              size: Dimensions.GRID_LODO,
              image:
                  '$kImageStorage${portfolioItem.token}${portfolioItem.imageExtension}',
              extension: portfolioItem.imageExtension,
            ),
            UIHelper.horizontalSpaceSmall(),
            Text(
              portfolioItem.fullName!,
              style: dataTableTextStyle(sizingInformation),
            ),
          ],
        );
    }
  }

  List<double> getTextForSelectedTimeFrame() {
    double valueForTimeFrame = 0;
    double valueChangeForTimeFrame = 0;

    switch (selectedTimeFrame) {
      case '1h':
        valueForTimeFrame = portfolioItem.oneHour ?? 0;
        valueChangeForTimeFrame = portfolioItem.oneHourValueDifference ?? 0;
        break;
      case '24h':
        valueForTimeFrame = portfolioItem.oneDay ?? 0;
        valueChangeForTimeFrame = portfolioItem.oneDayValueDifference ?? 0;
        break;
      case '7d':
        valueForTimeFrame = portfolioItem.oneWeek ?? 0;
        valueChangeForTimeFrame = portfolioItem.oneWeekValueDifference ?? 0;
        break;
      case '30d':
        valueForTimeFrame = portfolioItem.oneMonth ?? 0;
        valueChangeForTimeFrame = portfolioItem.oneMonthValueDifference ?? 0;
        break;
    }

    return [valueForTimeFrame, valueChangeForTimeFrame];
  }

  @override
  Widget build(BuildContext context) {
    double valueForTimeFrame = getTextForSelectedTimeFrame()[0];
    double valueChangeForTimeFrame = getTextForSelectedTimeFrame()[1];

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: UIHelper.pagePadding(sizingInformation),
        vertical: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL / 2,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColorDark,
        borderRadius: BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.DEFAULT_MARGIN,
          vertical: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
        ),
        color: backgroundColorDark,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getHeader(portfolioItem),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatToCurrency(portfolioItem.value,
                          showSymbol: true, decimalDigits: 3),
                      style: dataTableTextStyle(sizingInformation),
                    ),
                    if (selectedTab == 'Portfolio')
                      (Text(
                        valueChangeForTimeFrame == 0
                            ? '\$0'
                            : valueChangeForTimeFrame > 0
                                ? '+${formatToCurrency(valueChangeForTimeFrame, showSymbol: true, decimalDigits: 2)}'
                                : formatToCurrency(valueChangeForTimeFrame,
                                    showSymbol: true, decimalDigits: 2),
                        style: valueChangeForTimeFrame == 0
                            ? dataTableValueChangeTextStyle(sizingInformation)
                                .copyWith(color: Colors.white.withOpacity(.5))
                            : valueChangeForTimeFrame >= 0
                                ? dataTableValueChangeTextStyle(
                                        sizingInformation)
                                    .copyWith(color: Colors.greenAccent)
                                : dataTableValueChangeTextStyle(
                                        sizingInformation)
                                    .copyWith(color: Colors.redAccent),
                      )),
                  ],
                ),
              ],
            ),
            if (selectedTab != 'Liquidity')
              (UIHelper.verticalSpaceExtraSmall()),
            if (selectedTab != 'Liquidity')
              (Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: dataTableLabelTextStyle(),
                          ),
                          Text(
                            formatToCurrency(portfolioItem.price,
                                showSymbol: true, formatOnlyFirstPart: true),
                            style: dataTableTextStyle(sizingInformation),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                        child: VerticalDivider(
                          color: Colors.white.withOpacity(.1),
                          thickness: 2,
                          width: Dimensions.DEFAULT_MARGIN,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Balance',
                            style: dataTableLabelTextStyle(),
                          ),
                          Text(
                            formatToCurrency(portfolioItem.balance,
                                showSymbol: false, decimalDigits: 3),
                            style: dataTableTextStyle(sizingInformation),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (selectedTab == 'Portfolio')
                    (Text(
                      valueForTimeFrame == 0
                          ? '0%'
                          : '${formatToCurrency(valueForTimeFrame, showSymbol: false, decimalDigits: 2)}%',
                      style: valueForTimeFrame == 0
                          ? dataTableTextStyle(sizingInformation)
                              .copyWith(color: Colors.white.withOpacity(.5))
                          : valueForTimeFrame >= 0
                              ? dataTableTextStyle(sizingInformation)
                                  .copyWith(color: Colors.greenAccent)
                              : dataTableTextStyle(sizingInformation)
                                  .copyWith(color: Colors.redAccent),
                    ))
                ],
              ))
          ],
        ),
      ),
    );
  }
}

class SwapsTable extends StatelessWidget {
  final SizingInformation sizingInformation;
  final List<Swap> swaps;

  const SwapsTable({
    Key? key,
    required this.sizingInformation,
    required this.swaps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: UIHelper.pagePadding(sizingInformation),
        right: UIHelper.pagePadding(sizingInformation),
        bottom: UIHelper.pagePadding(sizingInformation),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final Swap swap = swaps[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              child: SwapItem(
                sizingInformation: sizingInformation,
                swap: swap,
                showAccount: false,
                showType: false,
              ),
            );
          },
          childCount: swaps.length,
        ),
      ),
    );
  }
}

class EmptyArray extends StatelessWidget {
  final SizingInformation sizingInformation;
  final String selectedTab;

  const EmptyArray({
    Key? key,
    required this.sizingInformation,
    required this.selectedTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: UIHelper.pagePadding(sizingInformation)),
          child: Text(
            'No items in $selectedTab.',
            style: emptyListTextStyle(sizingInformation),
          ),
        ),
      ]),
    );
  }
}

class PortfolioTable extends StatelessWidget {
  final PortfolioController controller = Get.find();
  final SizingInformation sizingInformation;

  PortfolioTable({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.selectedTab == 'Swaps') {
        if (controller.swaps.isEmpty) {
          return EmptyArray(
            sizingInformation: sizingInformation,
            selectedTab: controller.selectedTab,
          );
        }

        return SwapsTable(
          sizingInformation: sizingInformation,
          swaps: controller.swaps,
        );
      }

      if (controller.portfolioItems.isEmpty) {
        return EmptyArray(
          sizingInformation: sizingInformation,
          selectedTab: controller.selectedTab,
        );
      }

      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: Dimensions.DEFAULT_MARGIN_LARGE,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: UIHelper.pagePadding(sizingInformation),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.DEFAULT_MARGIN_SMALL,
                  horizontal: Dimensions.DEFAULT_MARGIN,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Total Value',
                      style: dataTableFooterTextStyle(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatToCurrency(controller.totalValue,
                              showSymbol: true, decimalDigits: 2),
                          style: dataTableFooterTextStyle()
                              .copyWith(fontSize: title),
                        ),
                        if (controller.selectedTab == 'Portfolio')
                          (Text(
                            controller.totalValueChangeForTimeFrame == 0
                                ? '\$0'
                                : controller.totalValueChangeForTimeFrame > 0
                                    ? '+${formatToCurrency(controller.totalValueChangeForTimeFrame, showSymbol: true, decimalDigits: 2)}'
                                    : formatToCurrency(
                                        controller.totalValueChangeForTimeFrame,
                                        showSymbol: true,
                                        decimalDigits: 2),
                            style: controller.totalValueChangeForTimeFrame == 0
                                ? dataTableTextStyle(sizingInformation)
                                    .copyWith(
                                        color: Colors.white.withOpacity(.5))
                                : controller.totalValueChangeForTimeFrame >= 0
                                    ? dataTableTextStyle(sizingInformation)
                                        .copyWith(color: Colors.greenAccent)
                                    : dataTableTextStyle(sizingInformation)
                                        .copyWith(color: Colors.redAccent),
                          )),
                      ],
                    ),
                  ],
                ),
              ),
              if (controller.selectedTab == 'Portfolio')
                (UIHelper.verticalSpaceSmall()),
              if (controller.selectedTab == 'Portfolio')
                (Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: UIHelper.pagePadding(sizingInformation),
                  ),
                  child: Row(
                    children: controller.timeFrames.map((timeFrame) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          right: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                        ),
                        child: ChoiceChip(
                          label: Text(
                            timeFrame,
                            style: timeFrameChipTextStyle(),
                          ),
                          visualDensity: VisualDensity.compact,
                          selected: controller.selectedTimeFrame == timeFrame,
                          onSelected: (value) =>
                              controller.changeSelectedTimeFrame(timeFrame),
                          selectedColor: backgroundPink,
                        ),
                      );
                    }).toList(),
                  ),
                )),
              UIHelper.verticalSpaceMedium(),
              Column(
                children: controller.portfolioItems.map((portfolioItem) {
                  return PortfolioItemWidget(
                    portfolioItem: portfolioItem,
                    selectedTab: controller.selectedTab,
                    sizingInformation: sizingInformation,
                    selectedTimeFrame: controller.selectedTimeFrame,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    });
  }
}
