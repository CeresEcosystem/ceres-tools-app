import 'package:ceres_tools_app/core/enums/device_screen_type.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/datepicker/date_input.dart';
import 'package:ceres_tools_app/core/widgets/input_field.dart';
import 'package:ceres_tools_app/core/widgets/select.dart';
import 'package:ceres_tools_app/presentation/chart/chart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwapFiltersDialog extends StatefulWidget {
  final SizingInformation sizingInformation;

  const SwapFiltersDialog({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  State<SwapFiltersDialog> createState() => _SwapFiltersDialogState();
}

class _SwapFiltersDialogState extends State<SwapFiltersDialog> {
  final ChartController chartController = Get.find<ChartController>();

  String assetId = 'Show all tokens';

  TextEditingController dateFromController = TextEditingController();
  TextEditingController timeFromController = TextEditingController();
  TextEditingController dateToController = TextEditingController();
  TextEditingController timeToController = TextEditingController();
  TextEditingController minAmount = TextEditingController();
  TextEditingController maxAmount = TextEditingController();

  @override
  void initState() {
    setState(() {
      dateFromController.text =
          formatDateToString(chartController.swapFilter.dateFrom);
      timeFromController.text =
          formatTimeToString(chartController.swapFilter.dateFrom);
      dateToController.text =
          formatDateToString(chartController.swapFilter.dateTo);
      timeToController.text =
          formatTimeToString(chartController.swapFilter.dateTo);
      assetId = chartController.swapFilter.assetId ?? 'Show all tokens';
      minAmount.text = chartController.swapFilter.minAmount ?? '';
      maxAmount.text = chartController.swapFilter.maxAmount ?? '';
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
    minAmount.dispose();
    maxAmount.dispose();
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
                  'Filter swaps',
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
                    'Min amount',
                    style: inputLabelTextStyle(),
                  ),
                  UIHelper.verticalSpaceExtraSmall(),
                  InputField(
                    hint: 'Enter min amount',
                    controller: minAmount,
                    textInputType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  UIHelper.verticalSpaceMedium(),
                  Text(
                    'Max amount',
                    style: inputLabelTextStyle(),
                  ),
                  UIHelper.verticalSpaceExtraSmall(),
                  InputField(
                    hint: 'Enter max amount',
                    controller: maxAmount,
                    textInputType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  UIHelper.verticalSpaceMedium(),
                  Text(
                    'Token',
                    style: inputLabelTextStyle(),
                  ),
                  UIHelper.verticalSpaceExtraSmall(),
                  Select(
                    values: chartController.filterTokens,
                    selectedValue: assetId,
                    onValueChange: (String value) {
                      setState(() {
                        assetId = value;
                      });
                    },
                    bg: backgroundColorDark,
                    padding: const EdgeInsets.all(
                      Dimensions.DEFAULT_MARGIN_SMALL,
                    ),
                    showAllValue: 'Show all tokens',
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
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
                  ),
                ),
                child: Text(
                  'Filter',
                  style: buttonLightTextStyle(widget.sizingInformation),
                ),
                onPressed: () => chartController.filterSwaps(
                  dateFromController.text,
                  timeFromController.text,
                  dateToController.text,
                  timeToController.text,
                  minAmount.text,
                  maxAmount.text,
                  assetId,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
