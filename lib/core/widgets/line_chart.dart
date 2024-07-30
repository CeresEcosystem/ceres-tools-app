import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/widgets/empty_widget.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  final Function getTooltipData;
  final Map<String, dynamic>? graphData;
  final bool showFullValueY;
  final bool showFullValueX;

  const Chart({
    Key? key,
    required this.getTooltipData,
    required this.graphData,
    this.showFullValueY = false,
    this.showFullValueX = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (graphData == null) {
      return const EmptyWidget();
    }

    return Responsive(
      builder: (context, sizingInformation) {
        return AspectRatio(
          aspectRatio: 1.70,
          child: LineChart(
            mainData(sizingInformation),
          ),
        );
      },
    );
  }

  List<LineTooltipItem> defaultTooltipItem(List<LineBarSpot> touchedSpots) {
    return touchedSpots.map((LineBarSpot touchedSpot) {
      return LineTooltipItem(
          getTooltipData(touchedSpot), graphTooltipTextStyle(),
          textAlign: TextAlign.left);
    }).toList();
  }

  LineChartData mainData(SizingInformation sizingInformation) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: defaultTooltipItem,
          fitInsideVertically: true,
          getTooltipColor: (touchedSpot) => backgroundColorLight,
          maxContentWidth: sizingInformation.screenSize.width -
              Dimensions.DEFAULT_MARGIN_LARGE,
          fitInsideHorizontally: true,
        ),
      ),
      gridData: const FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: graphData!['intervalX'],
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                angle: -1.04719755,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    formatDate(value),
                    style: graphTitleTextStyle(),
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: graphData!['intervalY'],
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  formatCurrencyGraph(value),
                  style: graphTitleTextStyle(),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          left: BorderSide(
            width: 2,
            color: Colors.white.withOpacity(0.5),
          ),
          bottom: BorderSide(
            width: 2,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ),
      minX: graphData!['minX'] ?? 0,
      maxX: graphData!['maxX'],
      minY: graphData!['minY'] ?? 0,
      maxY: graphData!['maxY'],
      lineBarsData: [
        LineChartBarData(
          spots: List.from(graphData!['data']).map((spot) {
            return FlSpot(spot['x'], spot['y']);
          }).toList(),
          isCurved: false,
          color: Colors.white,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: backgroundPink,
          ),
        ),
      ],
    );
  }
}
