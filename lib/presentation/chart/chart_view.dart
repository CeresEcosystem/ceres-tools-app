import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartView extends StatelessWidget {
  const ChartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String token = Get.arguments;

    return Responsive(
      builder: (context, sizingInformation) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Image.asset('lib/core/assets/images/ceres_tools_logo.png', height: Dimensions.HEADER_LOGO),
          ),
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Container(
            height: sizingInformation.bottomSafeAreaSize,
            color: chartBackground,
          ),
          body: SafeArea(
            top: false,
            child: WebView(
              initialUrl: '$kChartURL$token',
              javascriptMode: JavascriptMode.unrestricted,
              backgroundColor: backgroundColor,
            ),
          ),
        );
      },
    );
  }
}
