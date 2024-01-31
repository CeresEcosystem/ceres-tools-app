import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/item_container.dart';
import 'package:ceres_tools_app/core/widgets/line_chart.dart';
import 'package:ceres_tools_app/presentation/tracker/tracker_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupplyGraph extends StatelessWidget {
  final SizingInformation sizingInformation;

  const SupplyGraph({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TrackerController controller = Get.find<TrackerController>();

    return Column(
      children: [
        Text(
          'Track ${controller.selectedToken} supply',
          style: trackerTitleStyle(sizingInformation),
        ),
        UIHelper.verticalSpaceMedium(),
        ItemContainer(
          sizingInformation: sizingInformation,
          child: Chart(
            graphData: controller.supplyGraphData!,
            getTooltipData: controller.getSupplyTooltipData,
            showFullValueY: true,
          ),
        ),
      ],
    );
  }
}
