import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
import 'package:ceres_locker_app/core/utils/image_extension.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/round_image.dart';
import 'package:ceres_locker_app/domain/models/portfolio_item.dart';
import 'package:flutter/material.dart';

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
    final String imgExtension = imageExtension(portfolioItem.token);

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
                          '$kImageStorage${portfolioItem.token}$imgExtension',
                      size: Dimensions.GRID_LODO,
                      extension: imgExtension,
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
              image: '$kImageStorage${portfolioItem.token}$imgExtension',
              extension: imgExtension,
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

  Widget getTextForSelectedTimeFrame() {
    double? valueForTimeFrame = 0;

    switch (selectedTimeFrame) {
      case '1h':
        valueForTimeFrame = portfolioItem.oneHour;
        break;
      case '24h':
        valueForTimeFrame = portfolioItem.oneDay;
        break;
      case '7d':
        valueForTimeFrame = portfolioItem.oneWeek;
        break;
      case '30d':
        valueForTimeFrame = portfolioItem.oneMonth;
        break;
    }

    return Text(
      '$valueForTimeFrame%',
      style: valueForTimeFrame != null && valueForTimeFrame >= 0
          ? dataTableTextStyle(sizingInformation)
              .copyWith(color: Colors.greenAccent)
          : dataTableTextStyle(sizingInformation)
              .copyWith(color: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                Text(
                  formatToCurrency(portfolioItem.value,
                      showSymbol: true, decimalDigits: 3),
                  style: dataTableTextStyle(sizingInformation),
                ),
              ],
            ),
            if (selectedTab != 'Liquidity')
              (UIHelper.verticalSpaceExtraSmall()),
            if (selectedTab != 'Liquidity')
              (Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    (getTextForSelectedTimeFrame())
                ],
              ))
          ],
        ),
      ),
    );
  }
}

class PortfolioTable extends StatelessWidget {
  final List<PortfolioItem> portfolioItems;
  final double totalValue;
  final String selectedTab;
  final SizingInformation sizingInformation;
  final List<String> timeFrames;
  final String selectedTimeFrame;
  final Function onChangeSelectedTimeFrame;

  const PortfolioTable({
    Key? key,
    required this.portfolioItems,
    required this.totalValue,
    required this.selectedTab,
    required this.sizingInformation,
    required this.timeFrames,
    required this.selectedTimeFrame,
    required this.onChangeSelectedTimeFrame,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    formatToCurrency(totalValue,
                        showSymbol: true, decimalDigits: 3),
                    style: dataTableFooterTextStyle()
                        .copyWith(color: backgroundPink),
                  )
                ],
              ),
            ),
            if (selectedTab == 'Portfolio') (UIHelper.verticalSpaceSmall()),
            if (selectedTab == 'Portfolio')
              (Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UIHelper.pagePadding(sizingInformation),
                ),
                child: Row(
                  children: timeFrames.map((timeFrame) {
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
                        selected: selectedTimeFrame == timeFrame,
                        onSelected: (value) =>
                            onChangeSelectedTimeFrame(timeFrame),
                        selectedColor: backgroundPink,
                      ),
                    );
                  }).toList(),
                ),
              )),
            UIHelper.verticalSpaceMedium(),
            Column(
              children: portfolioItems.map((portfolioItem) {
                return PortfolioItemWidget(
                  portfolioItem: portfolioItem,
                  selectedTab: selectedTab,
                  sizingInformation: sizingInformation,
                  selectedTimeFrame: selectedTimeFrame,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
