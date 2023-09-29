import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/center_loading.dart';
import 'package:ceres_locker_app/core/widgets/error_text.dart';
import 'package:ceres_locker_app/core/widgets/round_image.dart';
import 'package:ceres_locker_app/domain/models/swap.dart';
import 'package:ceres_locker_app/presentation/chart/chart_controller.dart';
import 'package:ceres_locker_app/presentation/chart/widgets/current_token.dart';
import 'package:ceres_locker_app/presentation/chart/widgets/pagination.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Swaps extends StatefulWidget {
  final SizingInformation sizingInformation;
  final Function goToChartPage;

  const Swaps({
    Key? key,
    required this.sizingInformation,
    required this.goToChartPage,
  }) : super(key: key);

  @override
  State<Swaps> createState() => _SwapsState();
}

class _SwapsState extends State<Swaps>
    with AutomaticKeepAliveClientMixin<Swaps> {
  final ChartController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Obx(() {
      if (controller.loadingStatus == LoadingStatus.LOADING) {
        return const CenterLoading();
      }

      if (controller.loadingStatus == LoadingStatus.ERROR) {
        return ErrorText(
          onButtonPress: () => controller.fetchTokens(true),
        );
      }

      return Column(
        children: [
          CurrentToken(
            token: controller.token,
            goToSwapPage: widget.goToChartPage,
            icon: Icons.trending_up,
            buttonLabel: 'Chart',
            bottomPadding: false,
          ),
          (() {
            if (controller.swapLoadingStatus == LoadingStatus.LOADING) {
              return const CenterLoading();
            } else {
              return controller.swaps.isEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: Dimensions.DEFAULT_MARGIN),
                      child: Text(
                        'No swaps for selected token',
                        style: chartCurrentTokenTitleTextStyle(),
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.all(
                          UIHelper.pagePadding(widget.sizingInformation),
                        ),
                        itemBuilder: (context, index) {
                          final Swap swap = controller.swaps[index];

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.DEFAULT_MARGIN,
                              vertical: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                            ),
                            decoration: BoxDecoration(
                              color: backgroundColorDark,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.DEFAULT_MARGIN_SMALL),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                      (Dimensions.GRID_LODO /
                                                          4),
                                                  child: RoundImage(
                                                    image:
                                                        '$kImageStorage${swap.outputAsset}${swap.outputImageExtension}',
                                                    size: Dimensions.GRID_LODO,
                                                  ),
                                                ),
                                                RoundImage(
                                                  image:
                                                      '$kImageStorage${swap.inputAsset}${swap.inputImageExtension}',
                                                  size: Dimensions.GRID_LODO,
                                                ),
                                              ],
                                            ),
                                          ),
                                          UIHelper.horizontalSpaceExtraSmall(),
                                          Text(
                                            '${swap.inputAsset} -> ${swap.outputAsset}',
                                            style: dataTableTextStyle(
                                                widget.sizingInformation),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      swap.swappedAt,
                                      style: dataTableTextStyle(
                                              widget.sizingInformation)
                                          .copyWith(fontSize: overline),
                                    )
                                  ],
                                ),
                                UIHelper.verticalSpaceSmall(),
                                GestureDetector(
                                  onTap: () =>
                                      controller.copyAsset(swap.accountId),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Account: ',
                                      style: dataTableLabelTextStyle(),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: swap.formattedAccountId,
                                          style: dataTableTextStyle(
                                              widget.sizingInformation),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                UIHelper.verticalSpaceSmall(),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sold Amount',
                                          style: dataTableLabelTextStyle(),
                                        ),
                                        Text(
                                          formatToCurrency(
                                              swap.assetInputAmount,
                                              showSymbol: false,
                                              formatOnlyFirstPart: true),
                                          style: dataTableTextStyle(
                                              widget.sizingInformation),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bought Amount',
                                          style: dataTableLabelTextStyle(),
                                        ),
                                        Text(
                                          formatToCurrency(
                                              swap.assetOutputAmount,
                                              showSymbol: false,
                                              formatOnlyFirstPart: true),
                                          style: dataTableTextStyle(
                                              widget.sizingInformation),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Type',
                                          style: dataTableLabelTextStyle(),
                                        ),
                                        Text(
                                          swap.type ?? '/',
                                          style: dataTableTextStyle(
                                                  widget.sizingInformation)
                                              .copyWith(
                                            color: swap.type == 'Buy'
                                                ? Colors.greenAccent
                                                : Colors.redAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            UIHelper.verticalSpaceExtraSmall(),
                        itemCount: controller.swaps.length,
                      ),
                    );
            }
          }()),
          if (controller.swapLoadingStatus == LoadingStatus.READY &&
              controller.pageMeta.pageCount > 1)
            (Pagination()),
        ],
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
