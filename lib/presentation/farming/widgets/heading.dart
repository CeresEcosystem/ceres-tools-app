import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

import '../../../core/style/app_text_style.dart';
import '../../../core/theme/dimensions.dart';
import '../../../core/utils/sizing_information.dart';
import '../../../core/widgets/item_container.dart';
import '../../../core/widgets/select.dart';

class Heading extends StatelessWidget {
  final SizingInformation sizingInformation;
  final List<String> tabs;
  final String selectedTab;
  final Function onTabChange;
  final String tvl;
  final LoadingStatus loadingStatus;

  const Heading({
    Key? key,
    required this.sizingInformation,
    required this.tabs,
    required this.selectedTab,
    required this.onTabChange,
    required this.tvl,
    required this.loadingStatus,
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
            child: Column(
              children: [
                Select(
                  values: tabs,
                  selectedValue: selectedTab,
                  onValueChange: (String value) => onTabChange(value),
                ),
                UIHelper.verticalSpaceSmallMedium(),
                Text(
                  'TVL ${selectedTab.toUpperCase()}:',
                  style: tvlLabel(),
                ),
                Text(
                  loadingStatus == LoadingStatus.READY ? tvl : 'Loading...',
                  style: farmingTVL(),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
