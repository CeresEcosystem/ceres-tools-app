import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class ItemContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final bool smallMargin;
  final SizingInformation sizingInformation;

  const ItemContainer({
    Key? key,
    required this.child,
    this.backgroundColor = backgroundColorDark,
    this.smallMargin = false,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: UIHelper.pagePadding(sizingInformation), vertical: Dimensions.DEFAULT_MARGIN / 4),
      padding: EdgeInsets.all(smallMargin ? Dimensions.DEFAULT_MARGIN_SMALL : Dimensions.DEFAULT_MARGIN),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
      ),
      child: child,
    );
  }
}
