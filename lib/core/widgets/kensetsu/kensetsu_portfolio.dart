import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/round_image.dart';
import 'package:ceres_tools_app/domain/models/kensetsu_position.dart';
import 'package:flutter/material.dart';

class KensetsuPositionItem extends StatelessWidget {
  final SizingInformation sizingInformation;
  final KensetsuPosition kp;

  const KensetsuPositionItem({
    Key? key,
    required this.sizingInformation,
    required this.kp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.DEFAULT_MARGIN,
        vertical: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
      ),
      decoration: BoxDecoration(
        color: backgroundColorDark,
        borderRadius: BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: Dimensions.GRID_LODO * 2,
                child: Stack(
                  children: [
                    Positioned(
                      left: Dimensions.GRID_LODO / 2,
                      child: RoundImage(
                        image: '$kImageStorage${kp.collateralToken?.shortName}',
                        size: Dimensions.GRID_LODO,
                      ),
                    ),
                    RoundImage(
                      image: '$kImageStorage${kp.stablecoinToken?.shortName}',
                      size: Dimensions.GRID_LODO,
                    ),
                  ],
                ),
              ),
              Text(
                '${kp.stablecoinToken?.shortName} / ${kp.collateralToken?.shortName}',
                style: dataTableTextStyle(sizingInformation),
              ),
            ],
          ),
          UIHelper.verticalSpaceSmall(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interest',
                    style: dataTableLabelTextStyle(),
                  ),
                  Text(
                    '${formatToCurrency(kp.interest, showSymbol: false)}%',
                    style: dataTableTextStyle(sizingInformation)
                        .copyWith(fontSize: overline),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
                child: VerticalDivider(
                  color: Colors.white.withOpacity(.1),
                  thickness: 2,
                  width: Dimensions.DEFAULT_MARGIN,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Collateral',
                    style: dataTableLabelTextStyle(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${formatToCurrency(kp.collateralAmount, showSymbol: false)} ${kp.collateralToken?.shortName}',
                        style: dataTableTextStyle(sizingInformation)
                            .copyWith(fontSize: overline),
                      ),
                      UIHelper.horizontalSpaceExtraSmall(),
                      Text(
                        formatToCurrency(
                          (kp.collateralToken?.price ?? 0) *
                              kp.collateralAmount,
                          decimalDigits: 3,
                          showSymbol: true,
                        ),
                        style: dataTableTextStyle(sizingInformation)
                            .copyWith(fontSize: overline),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 25,
                child: VerticalDivider(
                  color: Colors.white.withOpacity(.1),
                  thickness: 2,
                  width: Dimensions.DEFAULT_MARGIN,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Debt',
                    style: dataTableLabelTextStyle(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${formatToCurrency(kp.debt, showSymbol: false)} ${kp.stablecoinToken?.shortName}',
                        style: dataTableTextStyle(sizingInformation)
                            .copyWith(fontSize: overline),
                      ),
                      UIHelper.horizontalSpaceExtraSmall(),
                      Text(
                        formatToCurrency(
                          (kp.stablecoinToken?.price ?? 0) * kp.debt,
                          decimalDigits: 3,
                          showSymbol: true,
                        ),
                        style: dataTableTextStyle(sizingInformation)
                            .copyWith(fontSize: overline),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class KensetsuPortfolio extends StatelessWidget {
  final SizingInformation sizingInformation;
  final List<KensetsuPosition> kensetsuPositions;

  const KensetsuPortfolio({
    Key? key,
    required this.sizingInformation,
    required this.kensetsuPositions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: UIHelper.pagePadding(sizingInformation),
        right: UIHelper.pagePadding(sizingInformation),
        bottom: UIHelper.pagePadding(sizingInformation),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final KensetsuPosition kp = kensetsuPositions[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              child: KensetsuPositionItem(
                sizingInformation: sizingInformation,
                kp: kp,
              ),
            );
          },
          childCount: kensetsuPositions.length,
        ),
      ),
    );
  }
}
