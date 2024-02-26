import 'package:ceres_tools_app/core/enums/device_screen_type.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/datepicker/date_input.dart';
import 'package:ceres_tools_app/core/widgets/input_field.dart';
import 'package:ceres_tools_app/presentation/kensetsu/kensetsu_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KensetsuFilterDialog extends StatefulWidget {
  final SizingInformation sizingInformation;

  const KensetsuFilterDialog({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  State<KensetsuFilterDialog> createState() => _KensetsuFilterDialogState();
}

class _KensetsuFilterDialogState extends State<KensetsuFilterDialog> {
  final KensetsuController kensetsuController = Get.find<KensetsuController>();

  TextEditingController dateFromController = TextEditingController();
  TextEditingController timeFromController = TextEditingController();
  TextEditingController dateToController = TextEditingController();
  TextEditingController timeToController = TextEditingController();
  TextEditingController accountId = TextEditingController();

  @override
  void initState() {
    setState(() {
      dateFromController.text =
          formatDateToString(kensetsuController.kensetsuFilter.dateFrom);
      timeFromController.text =
          formatTimeToString(kensetsuController.kensetsuFilter.dateFrom);
      dateToController.text =
          formatDateToString(kensetsuController.kensetsuFilter.dateTo);
      timeToController.text =
          formatTimeToString(kensetsuController.kensetsuFilter.dateTo);
      accountId.text = kensetsuController.kensetsuFilter.accountId ?? '';
    });

    dateFromController.addListener(() {
      if (dateFromController.text.isEmpty) {
        timeFromController.text = '';
      }
    });

    dateToController.addListener(() {
      if (dateToController.text.isEmpty) {
        timeToController.text = '';
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    dateFromController.dispose();
    timeFromController.dispose();
    dateToController.dispose();
    timeToController.dispose();
    accountId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(
        Dimensions.DEFAULT_MARGIN,
      ),
      content: SizedBox(
        width:
            widget.sizingInformation.deviceScreenType == DeviceScreenType.Mobile
                ? widget.sizingInformation.screenSize.width * 0.9
                : widget.sizingInformation.screenSize.width * 0.5,
        height:
            widget.sizingInformation.deviceScreenType == DeviceScreenType.Mobile
                ? widget.sizingInformation.screenSize.height * 0.9
                : widget.sizingInformation.screenSize.height * 0.7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter burns',
                  style: pageTitleStyle(widget.sizingInformation)
                      .copyWith(fontSize: headline5),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            UIHelper.verticalSpaceMedium(),
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: DateInput(
                          controller: dateFromController,
                          title: 'Date from',
                          hintText: 'Pick a date',
                          enabledValidation: false,
                        ),
                      ),
                      UIHelper.horizontalSpaceExtraSmall(),
                      Flexible(
                        flex: 2,
                        child: DateInput(
                          controller: timeFromController,
                          dateInputType: DateInputType.DateTime,
                          title: '',
                          hintText: 'Time',
                          enabledValidation: false,
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpaceMedium(),
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: DateInput(
                          controller: dateToController,
                          title: 'Date to',
                          hintText: 'Pick a date',
                          enabledValidation: false,
                        ),
                      ),
                      UIHelper.horizontalSpaceExtraSmall(),
                      Flexible(
                        flex: 2,
                        child: DateInput(
                          controller: timeToController,
                          dateInputType: DateInputType.DateTime,
                          title: '',
                          hintText: 'Time',
                          enabledValidation: false,
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpaceMedium(),
                  Text(
                    'Account Id',
                    style: inputLabelTextStyle(),
                  ),
                  UIHelper.verticalSpaceExtraSmall(),
                  InputField(
                    hint: 'Enter Account Id',
                    controller: accountId,
                  ),
                ],
              ),
            ),
            UIHelper.verticalSpaceMedium(),
            Container(
              width: double.infinity,
              color: backgroundColor,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundPink,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
                  ),
                ),
                child: Text(
                  'Filter',
                  style: buttonLightTextStyle(widget.sizingInformation),
                ),
                onPressed: () => kensetsuController.filterKensetsuBurns(
                  dateFromController.text,
                  timeFromController.text,
                  dateToController.text,
                  timeToController.text,
                  accountId.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
