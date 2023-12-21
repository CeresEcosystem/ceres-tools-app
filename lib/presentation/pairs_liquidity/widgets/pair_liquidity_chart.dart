import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/item_container.dart';
import 'package:ceres_tools_app/core/widgets/line_chart.dart';
import 'package:ceres_tools_app/presentation/pairs_liquidity/pairs_liquidity_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PairLiquidityChart extends StatelessWidget {
  final SizingInformation sizingInformation;

  const PairLiquidityChart({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PairsLiquidityController>();

    return Column(
      children: [
        UIHelper.verticalSpaceMediumLarge(),
        ItemContainer(
          sizingInformation: sizingInformation,
          child: Chart(
            graphData: controller.graphData,
            getTooltipData: controller.getSupplyTooltipData,
            showFullValue: true,
          ),
        ),
      ],
    );
  }
}
