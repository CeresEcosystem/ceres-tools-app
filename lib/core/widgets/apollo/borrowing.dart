import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/round_image.dart';
import 'package:ceres_tools_app/domain/models/apollo_dashboard.dart';
import 'package:flutter/material.dart';

class BorrowingItem extends StatefulWidget {
  final BorrowingInfo info;
  final SizingInformation sizingInformation;

  const BorrowingItem({
    Key? key,
    required this.info,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  State<BorrowingItem> createState() => _BorrowingItemState();
}

class _BorrowingItemState extends State<BorrowingItem> {
  bool showCollateral = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: UIHelper.pagePadding(widget.sizingInformation),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    RoundImage(
                      size: Dimensions.GRID_LODO,
                      image: '$kImageStorage${widget.info.poolAssetSymbol}',
                    ),
                    UIHelper.horizontalSpaceSmall(),
                    Text(
                      widget.info.poolAssetSymbol,
                      style: dataTableTextStyle(widget.sizingInformation),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showCollateral = !showCollateral;
                    });
                  },
                  child: Text(
                    showCollateral ? 'Hide collaterals' : 'Show collaterals',
                    style:
                        dataTableTextStyle(widget.sizingInformation).copyWith(
                      color: backgroundPink,
                    ),
                  ),
                )
              ],
            ),
            UIHelper.verticalSpaceExtraSmall(),
            Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: dataTableLabelTextStyle(),
                    ),
                    Text(
                      '${formatToCurrency(
                        widget.info.amount,
                        decimalDigits: 3,
                        showSymbol: false,
                      )} ${widget.info.poolAssetSymbol}',
                      style: dataTableTextStyle(widget.sizingInformation),
                    ),
                    Text(
                      formatToCurrency(
                        widget.info.amountPrice,
                        decimalDigits: 3,
                        showSymbol: true,
                      ),
                      style: dataTableTextStyle(widget.sizingInformation),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
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
                      'Interest',
                      style: dataTableLabelTextStyle(),
                    ),
                    Text(
                      '${formatToCurrency(
                        widget.info.interest,
                        decimalDigits: 3,
                        showSymbol: false,
                      )} ${widget.info.poolAssetSymbol}',
                      style: dataTableTextStyle(widget.sizingInformation),
                    ),
                    Text(
                      formatToCurrency(
                        widget.info.interestPrice,
                        decimalDigits: 3,
                        showSymbol: true,
                      ),
                      style: dataTableTextStyle(widget.sizingInformation),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
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
                      'Reward',
                      style: dataTableLabelTextStyle(),
                    ),
                    Text(
                      '${formatToCurrency(
                        widget.info.rewards,
                        decimalDigits: 3,
                        showSymbol: false,
                      )} APOLLO',
                      style: dataTableTextStyle(widget.sizingInformation),
                    ),
                    Text(
                      formatToCurrency(
                        widget.info.rewardPrice,
                        decimalDigits: 3,
                        showSymbol: true,
                      ),
                      style: dataTableTextStyle(widget.sizingInformation),
                    ),
                  ],
                ),
              ],
            ),
            if (showCollateral) ...[
              UIHelper.verticalSpaceSmall(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.DEFAULT_MARGIN_SMALL),
                decoration: BoxDecoration(
                  color: backgroundColorLight,
                  borderRadius:
                      BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      widget.info.collaterals.asMap().entries.map((collateral) {
                    int index = collateral.key;
                    Collateral collateralItem = collateral.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index > 0) ...[
                          const Divider(
                            color: Colors.white24,
                            height: Dimensions.DEFAULT_MARGIN,
                          ),
                        ],
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RoundImage(
                              size: Dimensions.GRID_LODO,
                              image:
                                  '$kImageStorage${collateralItem.collateralAssetSymbol}',
                            ),
                            UIHelper.horizontalSpaceSmall(),
                            Text(
                              collateralItem.collateralAssetSymbol,
                              style:
                                  dataTableTextStyle(widget.sizingInformation),
                            ),
                          ],
                        ),
                        UIHelper.verticalSpaceSmall(),
                        Wrap(
                          spacing: Dimensions.DEFAULT_MARGIN_SMALL,
                          runSpacing: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Collateral amount',
                                  style: dataTableLabelTextStyle(),
                                ),
                                Text(
                                  '${formatToCurrency(
                                    collateralItem.collateralAmount,
                                    decimalDigits: 3,
                                    showSymbol: false,
                                  )} ${collateralItem.collateralAssetSymbol}',
                                  style: dataTableTextStyle(
                                      widget.sizingInformation),
                                ),
                                Text(
                                  formatToCurrency(
                                    collateralItem.collateralAmountPrice,
                                    decimalDigits: 3,
                                    showSymbol: true,
                                  ),
                                  style: dataTableTextStyle(
                                      widget.sizingInformation),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Borrowed amount',
                                  style: dataTableLabelTextStyle(),
                                ),
                                Text(
                                  '${formatToCurrency(
                                    collateralItem.borrowedAmount,
                                    decimalDigits: 3,
                                    showSymbol: false,
                                  )} ${widget.info.poolAssetSymbol}',
                                  style: dataTableTextStyle(
                                      widget.sizingInformation),
                                ),
                                Text(
                                  formatToCurrency(
                                    collateralItem.borrowedAmountPrice,
                                    decimalDigits: 3,
                                    showSymbol: true,
                                  ),
                                  style: dataTableTextStyle(
                                      widget.sizingInformation),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Interest',
                                  style: dataTableLabelTextStyle(),
                                ),
                                Text(
                                  '${formatToCurrency(
                                    collateralItem.interest,
                                    decimalDigits: 3,
                                    showSymbol: false,
                                  )} ${widget.info.poolAssetSymbol}',
                                  style: dataTableTextStyle(
                                      widget.sizingInformation),
                                ),
                                Text(
                                  formatToCurrency(
                                    collateralItem.interestPrice,
                                    decimalDigits: 3,
                                    showSymbol: true,
                                  ),
                                  style: dataTableTextStyle(
                                      widget.sizingInformation),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rewards',
                                  style: dataTableLabelTextStyle(),
                                ),
                                Text(
                                  '${formatToCurrency(
                                    collateralItem.rewards,
                                    decimalDigits: 3,
                                    showSymbol: false,
                                  )} APOLLO',
                                  style: dataTableTextStyle(
                                      widget.sizingInformation),
                                ),
                                Text(
                                  formatToCurrency(
                                    collateralItem.rewardPrice,
                                    decimalDigits: 3,
                                    showSymbol: true,
                                  ),
                                  style: dataTableTextStyle(
                                      widget.sizingInformation),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class Borrowing extends StatelessWidget {
  final List<BorrowingInfo> borrowingInfo;
  final SizingInformation sizingInformation;

  const Borrowing({
    Key? key,
    required this.borrowingInfo,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: borrowingInfo.map((info) {
        return BorrowingItem(
          info: info,
          sizingInformation: sizingInformation,
        );
      }).toList(),
    );
  }
}
