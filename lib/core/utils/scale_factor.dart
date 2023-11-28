import 'package:ceres_tools_app/core/utils/sizing_information.dart';

double scale(SizingInformation sizingInformation, double size,
    [double factor = 0.5]) {
  const int guidelineBaseWidth = 350;

  double scale(double size) {
    return ((sizingInformation.screenSize.width / guidelineBaseWidth) * size)
        .roundToDouble();
  }

  return (size + (scale(size) - size) * factor).roundToDouble();
}
