import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:ceres_locker_app/core/widgets/side_menu/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class ChartView extends StatelessWidget {
  const ChartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? token = Get.arguments;

    return Responsive(
      builder: (context, sizingInformation) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Image.asset('lib/core/assets/images/ceres_tools_logo.png',
                height: Dimensions.HEADER_LOGO),
          ),
          endDrawer: token == null ? SideMenu() : null,
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Container(
            height: sizingInformation.bottomSafeAreaSize,
            color: chartBackground,
          ),
          body: SafeArea(
            top: false,
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse('$kChartURL${token ?? kTokenName}'),
              ),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  transparentBackground: true,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
