import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final Function onButtonPress;

  const ErrorText({Key? key, required this.onButtonPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return Padding(
          padding: const EdgeInsets.all(Dimensions.DEFAULT_MARGIN),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                kErrorTitle,
                style: errorTitleStyle(sizingInformation),
                textAlign: TextAlign.center,
              ),
              UIHelper.verticalSpaceMedium(),
              TextButton(
                onPressed: () => onButtonPress(),
                child: Text(
                  kTryAgain,
                  style: buttonTextStyle(sizingInformation),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
