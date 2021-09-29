import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TrackerChart extends StatelessWidget {
  const TrackerChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: LineChart(mainData()),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        //show: true,
        drawVerticalLine: false,
        drawHorizontalLine: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(showTitles: false),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0k';
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 25,
          margin: 10,
        ),
      ),
      borderData: FlBorderData(show: true, border: Border(left: BorderSide(width: 2, color: Colors.white.withOpacity(0.5)), bottom: BorderSide(width: 2, color: Colors.white.withOpacity(0.5)))),
      minX: 0,
      maxX: 8,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(3, 5),
            FlSpot(6, 6),
            FlSpot(8, 6),
          ],
          isCurved: false,
          colors: [Colors.white],
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: [backgroundColorLight],
          ),
        ),
      ],
    );
  }
}
