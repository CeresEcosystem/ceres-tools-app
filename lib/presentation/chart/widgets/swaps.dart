import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/center_loading.dart';
import 'package:ceres_locker_app/core/widgets/error_text.dart';
import 'package:ceres_locker_app/core/widgets/pagination.dart';
import 'package:ceres_locker_app/core/widgets/swap_item.dart';
import 'package:ceres_locker_app/domain/models/swap.dart';
import 'package:ceres_locker_app/presentation/chart/chart_controller.dart';
import 'package:ceres_locker_app/presentation/chart/widgets/current_token.dart';
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
            token: controller.token,
            goToSwapPage: controller.goToChartPage,
            icon: Icons.trending_up,
            buttonLabel: 'Chart',
            bottomPadding: false,
            showFavorites: controller.showFavoriteTokens,
          ),
          (() {
            if (controller.swapLoadingStatus == LoadingStatus.LOADING) {
              return const Expanded(child: CenterLoading());
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

                          return SwapItem(
                            sizingInformation: widget.sizingInformation,
                            swap: swap,
                            showType: !controller.showFavoriteTokens,
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
