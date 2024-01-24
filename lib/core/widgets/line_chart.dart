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
          tooltipBgColor: backgroundColorLight,
          maxContentWidth: sizingInformation.screenSize.width -
              Dimensions.DEFAULT_MARGIN_LARGE,
          fitInsideHorizontally: true,
        ),
      ),
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          rotateAngle: -45,
          showTitles: true,
          interval: graphData!['intervalX'],
          getTextStyles: (context, value) => graphTitleTextStyle(),
          getTitles: (value) =>
              formatDate(value, formatFullDate: showFullValueX),
          reservedSize: 30,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: graphData!['intervalY'],
          getTextStyles: (context, value) => graphTitleTextStyle(),
          getTitles: (value) => showFullValueY
              ? formatToCurrency(value, decimalDigits: 3)
              : formatCurrencyGraph(value),
          reservedSize: showFullValueY ? 80 : 30,
          margin: 10,
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
          colors: [Colors.white],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: [backgroundPink],
          ),
        ),
      ],
    );
  }
}
