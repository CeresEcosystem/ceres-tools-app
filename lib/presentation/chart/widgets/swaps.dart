import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/center_loading.dart';
import 'package:ceres_tools_app/core/widgets/error_text.dart';
import 'package:ceres_tools_app/core/widgets/pagination.dart';
import 'package:ceres_tools_app/core/widgets/swap_item.dart';
import 'package:ceres_tools_app/domain/models/swap.dart';
import 'package:ceres_tools_app/presentation/chart/chart_controller.dart';
import 'package:ceres_tools_app/presentation/chart/widgets/current_token.dart';
import 'package:ceres_tools_app/presentation/chart/widgets/swap_filters.dart';
import 'package:ceres_tools_app/presentation/chart/widgets/swaps_stats_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Swaps extends StatefulWidget {
  final SizingInformation sizingInformation;

  const Swaps({
    Key? key,
    required this.sizingInformation,
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
            switchPage: controller.goToChartPage,
            icon: Icons.trending_up,
            buttonLabel: 'Chart',
            bottomPadding: false,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: UIHelper.pagePadding(widget.sizingInformation),
              ),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      const SwapFilters(),
                      UIHelper.verticalSpaceSmall(),
                      SwapsStatsInfo(
                        sizingInformation: widget.sizingInformation,
                      ),
                      UIHelper.verticalSpaceSmallMedium(),
                    ]),
                  ),
                  (() {
                    if (controller.swapLoadingStatus == LoadingStatus.LOADING) {
                      return const SliverFillRemaining(child: CenterLoading());
                    } else {
                      return controller.swaps.isEmpty
                          ? SliverFillRemaining(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: Dimensions.DEFAULT_MARGIN),
                                child: Text(
                                  'No swaps for selected token',
                                  style: chartCurrentTokenTitleTextStyle(),
                                ),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final Swap swap = controller.swaps[index];

                                  return SwapItem(
                                    sizingInformation: widget.sizingInformation,
                                    swap: swap,
                                    showType:
                                        controller.token != kFavoriteTokens &&
                                            controller.token != kAllTokens,
                                  );
                                },
                                childCount: controller.swaps.length,
                              ),
                            );
                    }
                  }()),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      UIHelper.verticalSpaceSmall(),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          if (controller.swapLoadingStatus == LoadingStatus.READY &&
              controller.pageMeta.pageCount > 1)
            (Pagination(
              pageMeta: controller.pageMeta,
              goToFirstPage: controller.goToFirstPage,
              goToPreviousPage: controller.goToPreviousPage,
              goToNextPage: controller.goToNextPage,
              goToLastPage: controller.goToLastPage,
              label: 'Total Swaps',
            )),
        ],
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
