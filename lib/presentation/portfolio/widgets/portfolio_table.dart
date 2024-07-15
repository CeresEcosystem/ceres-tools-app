import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/apollo/apollo.dart';
import 'package:ceres_tools_app/core/widgets/round_image.dart';
import 'package:ceres_tools_app/core/widgets/swap_item.dart';
import 'package:ceres_tools_app/core/widgets/transfer_item.dart';
import 'package:ceres_tools_app/domain/models/portfolio_item.dart';
import 'package:ceres_tools_app/domain/models/swap.dart';
import 'package:ceres_tools_app/domain/models/transfer.dart';
import 'package:ceres_tools_app/presentation/portfolio/portfolio_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortfolioItemWidget extends StatelessWidget {
  final PortfolioItem portfolioItem;
  final int selectedTab;
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
      case 3:
        return Row(
          children: [
            SizedBox(
              width: Dimensions.GRID_LODO * 2,
              child: Stack(
                children: [
                  Positioned(
                    left: Dimensions.GRID_LODO / 2,
                    child: RoundImage(
                      image: '$kImageStorage${portfolioItem.token}',
                      size: Dimensions.GRID_LODO,
                    ),
                  ),
                  RoundImage(
                    image: '$kImageStorage${portfolioItem.baseAsset}',
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
              image: '$kImageStorage${portfolioItem.token}',
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
                    if (selectedTab == 0)
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
            UIHelper.verticalSpaceExtraSmall(),
            if (selectedTab != 3)
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
                  if (selectedTab == 0)
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
              )),
            if (selectedTab == 3) ...[
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Base asset',
                        style: dataTableLabelTextStyle(),
                      ),
                      Text(
                        '${formatToCurrency(portfolioItem.baseAssetLiqHolding, decimalDigits: 3)} ${portfolioItem.baseAsset}',
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
                        'Target asset',
                        style: dataTableLabelTextStyle(),
                      ),
                      Text(
                        '${formatToCurrency(portfolioItem.tokenLiqHolding, decimalDigits: 3)} ${portfolioItem.token}',
                        style: dataTableTextStyle(sizingInformation),
                      ),
                    ],
                  ),
                ],
              )
            ],
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

class TransferTable extends StatelessWidget {
  final SizingInformation sizingInformation;
  final List<Transfer> transfers;

  const TransferTable({
    Key? key,
    required this.sizingInformation,
    required this.transfers,
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
            final Transfer transfer = transfers[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              child: TransferItem(
                sizingInformation: sizingInformation,
                transfer: transfer,
              ),
            );
          },
          childCount: transfers.length,
        ),
      ),
    );
  }
}

class EmptyArray extends StatelessWidget {
  final SizingInformation sizingInformation;
  final List<Map<String, dynamic>> tabs;
  final int selectedTab;

  const EmptyArray({
    Key? key,
    required this.sizingInformation,
    required this.tabs,
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
            'No items in ${tabs.firstWhere((t) => t['index'] == selectedTab)['label']}.',
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
      if (controller.selectedTab == 4) {
        if (controller.swaps.isEmpty) {
          return EmptyArray(
            sizingInformation: sizingInformation,
            tabs: controller.tabs,
            selectedTab: controller.selectedTab,
          );
        }

        return SwapsTable(
          sizingInformation: sizingInformation,
          swaps: controller.swaps,
        );
      }

      if (controller.selectedTab == 5) {
        if (controller.transfers.isEmpty) {
          return EmptyArray(
            sizingInformation: sizingInformation,
            tabs: controller.tabs,
            selectedTab: controller.selectedTab,
          );
        }

        return TransferTable(
          sizingInformation: sizingInformation,
          transfers: controller.transfers,
        );
      }

      if (controller.selectedTab == 6) {
        return Apollo(sizingInformation: sizingInformation);
      }

      if (controller.portfolioItems.isEmpty) {
        return EmptyArray(
          sizingInformation: sizingInformation,
          tabs: controller.tabs,
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
                        if (controller.selectedTab == 0)
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
              if (controller.selectedTab == 0) (UIHelper.verticalSpaceSmall()),
              if (controller.selectedTab == 0)
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
                          side: BorderSide.none,
                          checkmarkColor: Colors.white,
                          backgroundColor: Colors.white.withOpacity(.1),
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
