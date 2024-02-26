import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/presentation/kensetsu/kensetsu_controller.dart';
import 'package:ceres_tools_app/presentation/kensetsu/widgets/burns.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KensetsuView extends GetView<KensetsuController> {
  const KensetsuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Image.asset(
              'lib/core/assets/images/ceres_tools_logo.png',
              height: Dimensions.HEADER_LOGO,
            ),
          ),
          bottomNavigationBar: Container(
            height: sizingInformation.bottomSafeAreaSize,
            color: chartBackground,
          ),
          body: KensetsuBurns(
            sizingInformation: sizingInformation,
          ),
        );
      },
    );
  }
}
