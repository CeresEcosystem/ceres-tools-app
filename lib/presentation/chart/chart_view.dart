import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/widgets/center_loading.dart';
import 'package:ceres_locker_app/core/widgets/error_text.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:ceres_locker_app/core/widgets/side_menu/side_menu.dart';
import 'package:ceres_locker_app/presentation/chart/chart_controller.dart';
import 'package:ceres_locker_app/presentation/chart/widgets/current_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class ChartView extends GetView<ChartController> {
  const ChartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Image.asset('lib/core/assets/images/ceres_tools_logo.png',
                height: Dimensions.HEADER_LOGO),
          ),
          endDrawer: SideMenu(),
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Container(
            height: sizingInformation.bottomSafeAreaSize,
            color: chartBackground,
          ),
          body: SafeArea(
            top: false,
            child: Obx(() {
              if (controller.loadingStatus == LoadingStatus.LOADING) {
                return const CenterLoading();
              }

              if (controller.loadingStatus == LoadingStatus.ERROR) {
                return ErrorText(
                  onButtonPress: () => controller.fetchTokens(true),
                );
              }

              return Column(
                children: [
                  CurrentToken(
                    token: controller.token,
                  ),
                  Expanded(
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: Uri.parse('$kChartURL${controller.token}'),
                      ),
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          transparentBackground: true,
                        ),
                      ),
                      onWebViewCreated: (contrl) {
                        controller.setInAppWebViewController(contrl);
                        contrl.addJavaScriptHandler(
                          handlerName: 'tokenChange',
                          callback: (args) {
                            controller.changeToken(args.first);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
