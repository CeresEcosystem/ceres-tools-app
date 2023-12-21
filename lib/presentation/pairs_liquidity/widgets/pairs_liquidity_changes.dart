import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/toast.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/pagination.dart';
import 'package:ceres_tools_app/domain/models/pair.dart';
import 'package:ceres_tools_app/domain/models/pair_liquidity.dart';
import 'package:ceres_tools_app/presentation/pairs_liquidity/pairs_liquidity_controller.dart';
import 'package:ceres_tools_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PairsLiquidityChanges extends StatelessWidget {
  final Pair pair;
  final SizingInformation sizingInformation;

  const PairsLiquidityChanges({
    Key? key,
    required this.pair,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PairsLiquidityController>();

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: controller.pairLiquidities.isEmpty
                ? Text(
                    'Pair has no liquidity transactions.',
                    style: emptyListTextStyle(sizingInformation),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(
                      UIHelper.pagePadding(
                        sizingInformation,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      final PairLiquidity pl =
                          controller.pairLiquidities[index];

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.DEFAULT_MARGIN,
                          vertical: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                        ),
                        decoration: BoxDecoration(
                          color: backgroundColorDark,
                          borderRadius: BorderRadius.circular(
                            Dimensions.DEFAULT_MARGIN_SMALL,
                          ),
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
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(Routes.PORTFOLIO,
                                              arguments: {
                                                'address': pl.signerId
                                              });
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Account: ',
                                            style: dataTableLabelTextStyle(),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: pl.accountIdFormatted,
                                                style: dataTableTextStyle(
                                                    sizingInformation),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      UIHelper.horizontalSpaceExtraSmall(),
                                      GestureDetector(
                                        onTap: () => showToastAndCopy(
                                          'Copied Account: ',
                                          pl.signerId,
                                          clipboardText: pl.signerId,
                                        ),
                                        child: const Icon(
                                          Icons.copy,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  pl.formattedDate,
                                  style: dataTableTextStyle(
                                    sizingInformation,
                                  ).copyWith(fontSize: overline),
                                )
                              ],
                            ),
                            UIHelper.verticalSpaceSmall(),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${pair.baseToken} Amount',
                                      style: dataTableLabelTextStyle(),
                                    ),
                                    Text(
                                      pl.firstAssetAmountFormatted,
                                      style:
                                          dataTableTextStyle(sizingInformation),
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
                                      '${pair.shortName} Amount',
                                      style: dataTableLabelTextStyle(),
                                    ),
                                    Text(
                                      pl.secondAssetAmountFormatted,
                                      style:
                                          dataTableTextStyle(sizingInformation),
                                    ),
                                  ],
                                ),
                                Row(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Type',
                                          style: dataTableLabelTextStyle(),
                                        ),
                                        Text(
                                          pl.transactionTypeFormatted ?? '/',
                                          style: dataTableTextStyle(
                                                  sizingInformation)
                                              .copyWith(
                                            color:
                                                pl.transactionTypeFormatted ==
                                                        'Deposit'
                                                    ? Colors.greenAccent
                                                    : Colors.redAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) =>
                        UIHelper.verticalSpaceExtraSmall(),
                    itemCount: controller.pairLiquidities.length,
                  ),
          ),
          if (controller.pageMeta.pageCount > 1)
            (Pagination(
              pageMeta: controller.pageMeta,
              goToFirstPage: controller.goToFirstPage,
              goToPreviousPage: controller.goToPreviousPage,
              goToNextPage: controller.goToNextPage,
              goToLastPage: controller.goToLastPage,
              label: 'Total',
            )),
        ],
      ),
    );
  }
}
