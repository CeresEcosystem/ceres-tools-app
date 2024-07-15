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

class Lending extends StatelessWidget {
  final List<LendingInfo> lendingInfo;
  final SizingInformation sizingInformation;

  const Lending({
    Key? key,
    required this.lendingInfo,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: lendingInfo.map((info) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: UIHelper.pagePadding(sizingInformation),
            vertical: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL / 2,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: backgroundColorDark,
            borderRadius:
                BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
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
                  children: [
                    RoundImage(
                      size: Dimensions.GRID_LODO,
                      image: '$kImageStorage${info.poolAssetSymbol}',
                    ),
                    UIHelper.horizontalSpaceSmall(),
                    Text(
                      info.poolAssetSymbol,
                      style: dataTableTextStyle(sizingInformation),
                    ),
                  ],
                ),
                UIHelper.verticalSpaceExtraSmall(),
                Row(
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
                            info.amount,
                            decimalDigits: 3,
                            showSymbol: false,
                          )} ${info.poolAssetSymbol}',
                          style: dataTableTextStyle(sizingInformation),
                        ),
                        Text(
                          formatToCurrency(
                            info.amountPrice,
                            decimalDigits: 3,
                            showSymbol: true,
                          ),
                          style: dataTableTextStyle(sizingInformation),
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
                            info.rewards,
                            decimalDigits: 3,
                            showSymbol: false,
                          )} APOLLO',
                          style: dataTableTextStyle(sizingInformation),
                        ),
                        Text(
                          formatToCurrency(
                            info.rewardPrice,
                            decimalDigits: 3,
                            showSymbol: true,
                          ),
                          style: dataTableTextStyle(sizingInformation),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
