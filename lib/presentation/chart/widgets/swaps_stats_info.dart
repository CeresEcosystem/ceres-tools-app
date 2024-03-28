import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/widgets/empty_widget.dart';
import 'package:ceres_tools_app/domain/models/swaps_stats.dart';
import 'package:ceres_tools_app/presentation/chart/chart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwapsStatsInfo extends StatelessWidget {
  final SizingInformation sizingInformation;

  const SwapsStatsInfo({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChartController controller = Get.find<ChartController>();

    if (controller.swapsStats != null) {
      SwapsStats swapsStats = controller.swapsStats!;

      return Container(
        padding: const EdgeInsets.all(
          Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.1),
          borderRadius: BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
        ),
        child: Wrap(
          spacing: Dimensions.DEFAULT_MARGIN,
          runSpacing: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
          alignment: WrapAlignment.center,
          children: [
            renderStats(
              'Total:',
              formatToCurrency(
                swapsStats.buys + swapsStats.sells,
                showSymbol: false,
                decimalDigits: 0,
              ),
            ),
            renderStats(
              'Buys:',
              formatToCurrency(
                swapsStats.buys,
                showSymbol: false,
                decimalDigits: 0,
              ),
            ),
            renderStats(
              'Tokens Bought:',
              formatToCurrency(
                swapsStats.tokensBought,
                showSymbol: false,
              ),
            ),
            renderStats(
              'Sells:',
              formatToCurrency(
                swapsStats.sells,
                showSymbol: false,
                decimalDigits: 0,
              ),
            ),
            renderStats(
              'Tokens Sold:',
              formatToCurrency(
                swapsStats.tokensSold,
                showSymbol: false,
              ),
            ),
          ],
        ),
      );
    }

    return const EmptyWidget();
  }

  Widget renderStats(String label, String info) {
    return Column(
      children: [
        Text(
          label,
          style: swapsStatsLabel(),
        ),
        Text(
          info,
          style: swapsStatsInfo(),
        ),
      ],
    );
  }
}
