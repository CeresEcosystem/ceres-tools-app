import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/widgets/center_loading.dart';
import 'package:ceres_locker_app/core/widgets/error_text.dart';
import 'package:ceres_locker_app/presentation/chart/chart_controller.dart';
import 'package:ceres_locker_app/presentation/chart/widgets/current_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart>
    with AutomaticKeepAliveClientMixin<Chart> {
  final ChartController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Obx(() {
      if (controller.loadingStatus == LoadingStatus.LOADING) {
        return const CenterLoading();
      }

      if (controller.loadingStatus == LoadingStatus.ERROR) {
        return ErrorText(
          onButtonPress: () => controller.fetchTokens(false, true),
        );
      }

      return Column(
        children: [
          CurrentToken(
            token: controller.token,
            goToSwapPage: controller.goToSwapPage,
            icon: Icons.swap_horiz,
            buttonLabel: 'Swaps',
            showFavorites: controller.showFavoriteTokens,
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
    });
  }

  @override
  bool get wantKeepAlive => true;
}
