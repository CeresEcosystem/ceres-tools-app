import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:flutter/material.dart';

class CeresHeader extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CeresHeader({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.DEFAULT_MARGIN,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LimitedBox(
            maxWidth: Dimensions.HEADER_LOGO_WIDTH,
            child: Image.asset('lib/core/assets/images/ceres_tools_logo.png'),
          ),
          GestureDetector(
            onTap: () => scaffoldKey.currentState?.openEndDrawer(),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.DEFAULT_MARGIN),
              child: Icon(Icons.menu_sharp, size: Dimensions.ICON_SIZE),
            ),
          ),
        ],
      ),
    );
  }
}
