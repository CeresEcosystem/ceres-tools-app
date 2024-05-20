import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/toast.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/center_loading.dart';
import 'package:ceres_tools_app/core/widgets/pagination.dart';
import 'package:ceres_tools_app/domain/models/burn.dart';
import 'package:ceres_tools_app/presentation/burning/burning_controller.dart';
import 'package:ceres_tools_app/presentation/burning/widgets/filter.dart';
import 'package:ceres_tools_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BurnItem extends StatelessWidget {
  final SizingInformation sizingInformation;
  final Burn burn;
  final Map<String, String> token;

  const BurnItem({
    Key? key,
    required this.sizingInformation,
    required this.burn,
    required this.token,
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
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.PORTFOLIO,
                            arguments: {'address': burn.accountId});
                      },
                      child: Text(
                        checkEmptyString(burn.formattedAccountId),
                        style: dataTableTextStyle(sizingInformation),
                      ),
                    ),
                    UIHelper.horizontalSpaceSmall(),
                    GestureDetector(
                      onTap: () => showToastAndCopy(
                        'Copied Account: ',
                        burn.accountId,
                        clipboardText: burn.accountId,
                      ),
                      child: const Icon(Icons.copy, size: 16),
                    ),
                  ],
                ),
              ),
              Text(
                burn.createdAt,
                style: dataTableTextStyle(sizingInformation)
                    .copyWith(fontSize: overline),
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
                    'Burned XOR',
                    style: dataTableLabelTextStyle(),
                  ),
                  Text(
                    formatToCurrency(
                      burn.amountBurned,
                      showSymbol: false,
                      formatOnlyFirstPart: true,
                    ),
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
                    '${token['tokenShortName']} Allocated',
                    style: dataTableLabelTextStyle(),
                  ),
                  Text(
                    formatToCurrency(
                      burn.tokenAllocated,
                      showSymbol: false,
                      formatOnlyFirstPart: true,
                    ),
                    style: dataTableTextStyle(sizingInformation),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class BurnsList extends StatelessWidget {
  final SizingInformation sizingInformation;

  const BurnsList({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BurningController controller = Get.find();
    final Map<String, String> token = Get.arguments;

    return Obx(() {
      if (controller.loadingStatus == LoadingStatus.LOADING) {
        return const CenterLoading();
      }

      return Column(
        children: [
          BurningFilter(
            sizingInformation: sizingInformation,
            token: token,
          ),
          (() {
            if (controller.pageLoadingStatus == LoadingStatus.LOADING) {
              return const Expanded(child: CenterLoading());
            } else {
              return controller.burns.isEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: Dimensions.DEFAULT_MARGIN),
                      child: Text(
                        'No data',
                        style: chartCurrentTokenTitleTextStyle(),
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.all(
                          UIHelper.pagePadding(sizingInformation),
                        ),
                        itemBuilder: (context, index) {
                          final Burn burn = controller.burns[index];

                          return BurnItem(
                            sizingInformation: sizingInformation,
                            burn: burn,
                            token: token,
                          );
                        },
                        separatorBuilder: (context, index) =>
                            UIHelper.verticalSpaceExtraSmall(),
                        itemCount: controller.burns.length,
                      ),
                    );
            }
          }()),
          if (controller.pageLoadingStatus == LoadingStatus.READY &&
              controller.pageMeta.pageCount > 1)
            (Pagination(
              pageMeta: controller.pageMeta,
              goToFirstPage: controller.goToFirstPage,
              goToPreviousPage: controller.goToPreviousPage,
              goToNextPage: controller.goToNextPage,
              goToLastPage: controller.goToLastPage,
              label: 'Total burns',
            )),
        ],
      );
    });
  }
}
