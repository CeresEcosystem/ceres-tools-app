import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
import 'package:ceres_locker_app/core/utils/image_extension.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/round_image.dart';
import 'package:ceres_locker_app/domain/models/portfolio_item.dart';
import 'package:flutter/material.dart';

final columns = [
  'Coin',
  'Price',
  '1h',
  '24h',
  '7d',
  '30d',
  'Balance',
  'Value',
];

class PortfolioTable extends StatelessWidget {
  final List<PortfolioItem> portfolioItems;
  final double totalValue;

  const PortfolioTable({
    Key? key,
    required this.portfolioItems,
    required this.totalValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: backgroundColorDark,
              borderRadius:
                  BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
            ),
            child: DataTable(
              columnSpacing: Dimensions.DEFAULT_MARGIN_LARGE,
              headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.white.withOpacity(0.05)),
              columns: columns.map((column) {
                return DataColumn(
                  label: Expanded(
                    child: Container(
                      alignment: column == 'Coin'
                          ? Alignment.centerLeft
                          : Alignment.center,
                      child: Text(
                        column,
                        style: dataTableFooterTextStyle(),
                      ),
                    ),
                  ),
                );
              }).toList(),
              rows: portfolioItems.map((portfolioItem) {
                final String imgExtension = imageExtension(portfolioItem.token);

                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          RoundImage(
                            size: Dimensions.ICON_SIZE,
                            image:
                                '$kImageStorage${portfolioItem.token}$imgExtension',
                            extension: imgExtension,
                          ),
                          UIHelper.horizontalSpaceSmall(),
                          Text(
                            portfolioItem.fullName!,
                            style: dataTableTextStyle(),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          formatToCurrency(portfolioItem.price,
                              showSymbol: true, formatOnlyFirstPart: true),
                          style: dataTableTextStyle(),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          '${portfolioItem.oneHour}%',
                          style: portfolioItem.oneHour! >= 0
                              ? dataTableTextStyle()
                                  .copyWith(color: Colors.greenAccent)
                              : dataTableTextStyle()
                                  .copyWith(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          '${portfolioItem.oneDay}%',
                          style: portfolioItem.oneDay! >= 0
                              ? dataTableTextStyle()
                                  .copyWith(color: Colors.greenAccent)
                              : dataTableTextStyle()
                                  .copyWith(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          '${portfolioItem.oneWeek}%',
                          style: portfolioItem.oneWeek! >= 0
                              ? dataTableTextStyle()
                                  .copyWith(color: Colors.greenAccent)
                              : dataTableTextStyle()
                                  .copyWith(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          '${portfolioItem.oneMonth}%',
                          style: portfolioItem.oneMonth! >= 0
                              ? dataTableTextStyle()
                                  .copyWith(color: Colors.greenAccent)
                              : dataTableTextStyle()
                                  .copyWith(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          formatToCurrency(portfolioItem.balance,
                              showSymbol: true),
                          style: dataTableTextStyle(),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          formatToCurrency(portfolioItem.value,
                              showSymbol: true),
                          style: dataTableTextStyle(),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.DEFAULT_MARGIN_SMALL,
            horizontal: 30.0,
          ),
          color: Colors.white.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Total Value',
                style: dataTableFooterTextStyle(),
              ),
              Text(
                formatToCurrency(totalValue, showSymbol: true),
                style:
                    dataTableFooterTextStyle().copyWith(color: backgroundPink),
              )
            ],
          ),
        ),
      ],
    );
  }
}
