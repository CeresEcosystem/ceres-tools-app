import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/presentation/chart/chart_controller.dart';
import 'package:ceres_tools_app/presentation/chart/widgets/swap_filters_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwapFilters extends StatelessWidget {
  const SwapFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChartController controller = Get.find<ChartController>();

    return Responsive(
      builder: (context, sizingInformation) {
        return Obx(() {
          return Column(
            children: [
              UIHelper.verticalSpaceSmall(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Swaps',
                          style: pageTitleStyle(sizingInformation),
                        ),
                        (() {
                          if (controller.swapFilter
                              .getActiveFilters()
                              .isNotEmpty) {
                            return Wrap(
                              spacing: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                              children: controller.swapFilter
                                  .getActiveFilters()
                                  .map((activeFilter) {
                                return RichText(
                                  text: TextSpan(
                                    text: activeFilter['label'],
                                    style: swapFiltersTextStyle(),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: activeFilter['filter'],
                                        style: swapFiltersTextStyle()
                                            .copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          }

                          return Text(
                            'No active filters',
                            style: swapFiltersTextStyle()
                                .copyWith(fontSize: caption),
                          );
                        })(),
                      ],
                    ),
                  ),
                  UIHelper.horizontalSpaceExtraSmall(),
                  Row(
                    children: [
                      filterButton(
                        'Filter swaps',
                        backgroundPink,
                        () => Get.dialog(
                          SwapFiltersDialog(
                            sizingInformation: sizingInformation,
                          ),
                          barrierDismissible: false,
                        ),
                      ),
                      UIHelper.horizontalSpaceExtraSmall(),
                      filterButton(
                        'Clear filters',
                        Colors.white.withOpacity(.1),
                        () => controller.clearFilters(),
                      ),
                    ],
                  ),
                ],
              ),
              UIHelper.verticalSpaceSmall(),
            ],
          );
        });
      },
    );
  }

  Widget filterButton(String title, Color bg, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(
          Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(
            Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
          ),
        ),
        child: Text(
          title,
          style: chartButtonTextStyle().copyWith(fontSize: caption),
        ),
      ),
    );
  }
}
