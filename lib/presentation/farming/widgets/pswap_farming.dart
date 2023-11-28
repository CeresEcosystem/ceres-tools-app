import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';
import 'package:ceres_tools_app/domain/models/farm.dart';
import 'package:flutter/material.dart';

import '../../../core/style/app_text_style.dart';
import '../../../core/theme/dimensions.dart';
import '../../../core/utils/sizing_information.dart';
import '../../../core/widgets/item_container.dart';

class PSWAPFarming extends StatelessWidget {
  final SizingInformation sizingInformation;
  final Farm farm;

  const PSWAPFarming({
    Key? key,
    required this.sizingInformation,
    required this.farm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.only(
            top: Dimensions.DEFAULT_MARGIN_LARGE,
          ),
          child: ItemContainer(
            sizingInformation: sizingInformation,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: kFarmingPart1,
                style: farmingLabelStyle(sizingInformation),
                children: <TextSpan>[
                  TextSpan(
                    text: checkEmptyString(farm.rewardsDouble),
                    style: farmingInfoStyle(sizingInformation),
                  ),
                  const TextSpan(
                    text: kFarmingPart2,
                  ),
                  TextSpan(
                    text: '${checkEmptyString(farm.aprDouble)}%',
                    style: farmingInfoStyle(sizingInformation),
                  ),
                  const TextSpan(
                    text: kFarmingPart3,
                  ),
                  const TextSpan(
                    text: kFarmingPart4,
                  ),
                  TextSpan(
                    text: checkEmptyString(farm.rewards),
                    style: farmingInfoStyle(sizingInformation),
                  ),
                  const TextSpan(
                    text: kFarmingPart5,
                  ),
                  TextSpan(
                    text: '${checkEmptyString(farm.apr)}%',
                    style: farmingInfoStyle(sizingInformation),
                  ),
                  const TextSpan(
                    text: kFarmingPart6,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
