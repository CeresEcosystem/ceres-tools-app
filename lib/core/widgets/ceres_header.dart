import 'dart:io';

import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CeresHeader extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Color backgroundColor;
  final bool verticalSpace;
  final bool showBackButton;
  final bool showDrawerButton;

  const CeresHeader({
    Key? key,
    required this.scaffoldKey,
    this.backgroundColor = Colors.transparent,
    this.verticalSpace = false,
    this.showBackButton = false,
    this.showDrawerButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: Dimensions.DEFAULT_MARGIN,
        top: verticalSpace ? Dimensions.DEFAULT_MARGIN_SMALL : 0,
        bottom: verticalSpace ? Dimensions.DEFAULT_MARGIN_EXTRA_SMALL : 0,
      ),
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (showBackButton)
                (GestureDetector(
                  onTap: () => Get.back(),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: Dimensions.DEFAULT_MARGIN),
                    child: Icon(
                        Platform.isAndroid
                            ? Icons.arrow_back
                            : Icons.arrow_back_ios,
                        size: Dimensions.ICON_SIZE),
                  ),
                )),
              LimitedBox(
                maxWidth: Dimensions.HEADER_LOGO_WIDTH,
                child:
                    Image.asset('lib/core/assets/images/ceres_tools_logo.png'),
              ),
            ],
          ),
          if (showDrawerButton)
            (GestureDetector(
              onTap: () => scaffoldKey.currentState?.openEndDrawer(),
              child: const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Dimensions.DEFAULT_MARGIN),
                child: Icon(Icons.menu_sharp, size: Dimensions.ICON_SIZE),
              ),
            )),
        ],
      ),
    );
  }
}
