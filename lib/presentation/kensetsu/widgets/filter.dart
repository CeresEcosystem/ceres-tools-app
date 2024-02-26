import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/presentation/kensetsu/kensetsu_controller.dart';
import 'package:ceres_tools_app/presentation/kensetsu/widgets/filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterKensetsu extends StatelessWidget {
  final SizingInformation sizingInformation;

  const FilterKensetsu({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final KensetsuController controller = Get.find<KensetsuController>();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: UIHelper.pagePadding(sizingInformation),
      ),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIHelper.verticalSpaceSmallMedium(),
            Text(
              'Kensetsu Burning',
              style: pageTitleStyle(sizingInformation),
            ),
            Wrap(
              spacing: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
              runSpacing: 4.0,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Total XOR Burned: ',
                    style: swapFiltersTextStyle().copyWith(fontSize: caption),
                    children: <TextSpan>[
                      TextSpan(
                        text: controller.summary['xorBurned'],
                        style: swapFiltersTextStyle()
                            .copyWith(color: Colors.white, fontSize: caption),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Total KEN Allocated: ',
                    style: swapFiltersTextStyle().copyWith(fontSize: caption),
                    children: <TextSpan>[
                      TextSpan(
                        text: controller.summary['kenAllocated'],
                        style: swapFiltersTextStyle()
                            .copyWith(color: Colors.white, fontSize: caption),
                      ),
                    ],
                  ),
                )
              ],
            ),
            UIHelper.verticalSpaceMediumLarge(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (() {
                  if (controller.kensetsuFilter.getActiveFilters().isNotEmpty) {
                    return Expanded(
                      child: Wrap(
                        spacing: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                        children: controller.kensetsuFilter
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
                      ),
                    );
                  }

                  return Text(
                    'No active filters',
                    style: swapFiltersTextStyle().copyWith(fontSize: caption),
                  );
                })(),
                UIHelper.horizontalSpaceSmall(),
                Row(
                  children: [
                    filterButton(
                      'Filter burns',
                      backgroundPink,
                      () => Get.dialog(
                        KensetsuFilterDialog(
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
      }),
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
