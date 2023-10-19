import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:ceres_locker_app/core/utils/toast.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/round_image.dart';
import 'package:ceres_locker_app/domain/models/swap.dart';
import 'package:ceres_locker_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwapItem extends StatelessWidget {
  final SizingInformation sizingInformation;
  final Swap swap;
  final bool showAccount;
  final bool showType;

  const SwapItem({
    Key? key,
    required this.sizingInformation,
    required this.swap,
    this.showAccount = true,
    this.showType = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.DEFAULT_MARGIN,
        vertical: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
      ),
      decoration: BoxDecoration(
        color: backgroundColorDark,
        borderRadius: BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: Dimensions.GRID_LODO * 2,
                      child: Stack(
                        children: [
                          Positioned(
                            left: Dimensions.GRID_LODO -
                                (Dimensions.GRID_LODO / 4),
                            child: RoundImage(
                              image:
                                  '$kImageStorage${swap.outputAsset}${swap.outputImageExtension}',
                              size: Dimensions.GRID_LODO,
                              extension: swap.outputImageExtension,
                            ),
                          ),
                          RoundImage(
                            image:
                                '$kImageStorage${swap.inputAsset}${swap.inputImageExtension}',
                            size: Dimensions.GRID_LODO,
                            extension: swap.inputImageExtension,
                          ),
                        ],
                      ),
                    ),
                    UIHelper.horizontalSpaceExtraSmall(),
                    Text(
                      '${swap.inputAsset} -> ${swap.outputAsset}',
                      style: dataTableTextStyle(sizingInformation),
                    )
                  ],
                ),
              ),
              Text(
                swap.swappedAt,
                style: dataTableTextStyle(sizingInformation)
                    .copyWith(fontSize: overline),
              )
            ],
          ),
          if (showAccount)
            (Column(
              children: [
                UIHelper.verticalSpaceSmall(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.PORTFOLIO,
                            arguments: {'address': swap.accountId});
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Account: ',
                          style: dataTableLabelTextStyle(),
                          children: <TextSpan>[
                            TextSpan(
                              text: swap.formattedAccountId,
                              style: dataTableTextStyle(sizingInformation),
                            ),
                          ],
                        ),
                      ),
                    ),
                    UIHelper.horizontalSpaceSmall(),
                    GestureDetector(
                      onTap: () => showToastAndCopy(
                        'Copied Account: ',
                        swap.accountId,
                        clipboardText: swap.accountId,
                      ),
                      child: const Icon(Icons.copy, size: 16),
                    ),
                  ],
                ),
              ],
            )),
          UIHelper.verticalSpaceSmall(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sold Amount',
                    style: dataTableLabelTextStyle(),
                  ),
                  Text(
                    formatToCurrency(swap.assetInputAmount,
                        showSymbol: false, formatOnlyFirstPart: true),
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
                    'Bought Amount',
                    style: dataTableLabelTextStyle(),
                  ),
                  Text(
                    formatToCurrency(swap.assetOutputAmount,
                        showSymbol: false, formatOnlyFirstPart: true),
                    style: dataTableTextStyle(sizingInformation),
                  ),
                ],
              ),
              if (showType)
                (Row(
                  children: [
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
                          'Type',
                          style: dataTableLabelTextStyle(),
                        ),
                        Text(
                          swap.type ?? '/',
                          style: dataTableTextStyle(sizingInformation).copyWith(
                            color: swap.type == 'Buy'
                                ? Colors.greenAccent
                                : Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            ],
          )
        ],
      ),
    );
  }
}
