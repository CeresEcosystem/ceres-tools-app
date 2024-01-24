import 'package:ceres_tools_app/core/enums/pair_liquidity_chart_type.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/item_container.dart';
import 'package:ceres_tools_app/core/widgets/line_chart.dart';
import 'package:ceres_tools_app/domain/models/pair.dart';
import 'package:ceres_tools_app/presentation/pairs_liquidity/pairs_liquidity_controller.dart';
import 'package:fl_chart/fl_chart.dart';
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

    Pair pair = Get.arguments;

    Widget chartWithTitle(String title, PairLiquidityChartType chartType) {
      Map<String, dynamic>? graphData = controller.getGraphData(chartType);

      return ItemContainer(
        sizingInformation: sizingInformation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: pairLiquidityChartTitleTextStyle(sizingInformation),
            ),
            UIHelper.verticalSpaceMediumLarge(),
            Chart(
              graphData: graphData,
              getTooltipData: (LineBarSpot touchedSpot) =>
                  controller.getSupplyTooltipData(touchedSpot, graphData),
              showFullValueX: true,
              showFullValueY: true,
            ),
          ],
        ),
      );
    }

    return Expanded(
      child: ListView(
        padding:
            const EdgeInsets.symmetric(vertical: Dimensions.DEFAULT_MARGIN),
        children: [
          chartWithTitle(
            'Pair Liquidity',
            PairLiquidityChartType.PairLiquidity,
          ),
          chartWithTitle(
            '${pair.baseToken} Liquidity',
            PairLiquidityChartType.BaseAssetLiquidity,
          ),
          chartWithTitle(
            '${pair.shortName} Liquidity',
            PairLiquidityChartType.TokenAssetLiquidity,
          ),
        ],
      ),
    );
  }
}
