import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/domain/models/apollo_dashboard.dart';
import 'package:flutter/material.dart';

class ApolloStats extends StatelessWidget {
  final Stats stats;
  final SizingInformation sizingInformation;

  const ApolloStats({
    Key? key,
    required this.stats,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: UIHelper.pagePadding(sizingInformation),
      ),
      padding: const EdgeInsets.all(
        Dimensions.DEFAULT_MARGIN_SMALL,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.1),
        borderRadius: BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
      ),
      child: Wrap(
        spacing: Dimensions.DEFAULT_MARGIN,
        runSpacing: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
        children: [
          renderStats(
            'Total Value Locked:',
            formatToCurrency(
              stats.tvl,
              showSymbol: true,
              decimalDigits: 3,
            ),
          ),
          renderStats(
            'Lent:',
            formatToCurrency(
              stats.totalLent,
              showSymbol: true,
              decimalDigits: 3,
            ),
          ),
          renderStats(
            'Borrowed:',
            formatToCurrency(
              stats.totalBorrowed,
              showSymbol: true,
              decimalDigits: 3,
            ),
          ),
          renderStats(
              'Total Rewards:',
              '${formatToCurrency(
                stats.totalRewards,
                showSymbol: false,
                decimalDigits: 3,
              )} APOLLO'),
        ],
      ),
    );
  }

  Widget renderStats(String label, String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
