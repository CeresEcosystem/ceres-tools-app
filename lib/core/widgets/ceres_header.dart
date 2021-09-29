import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CeresHeader extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CeresHeader({Key? key, required this.scaffoldKey}) : super(key: key);

  void _launchURL() async {
    if (await canLaunch(kCeresWebsite)) {
      await launch(kCeresWebsite);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.DEFAULT_MARGIN,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _launchURL,
              child: LimitedBox(
                maxWidth: Dimensions.HEADER_LOGO_WIDTH,
                child: Image.asset('lib/core/assets/images/ceres_logo.png'),
              ),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => scaffoldKey.currentState?.openEndDrawer(),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.DEFAULT_MARGIN),
                child: Icon(Icons.menu_sharp, size: Dimensions.ICON_SIZE),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
