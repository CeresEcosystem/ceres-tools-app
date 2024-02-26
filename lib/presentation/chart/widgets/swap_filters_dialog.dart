import 'package:ceres_tools_app/core/enums/device_screen_type.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/address_format.dart';
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
  List<String> excludedAccounts = [];
  String errorAddress = '';

  TextEditingController dateFromController = TextEditingController();
  TextEditingController timeFromController = TextEditingController();
  TextEditingController dateToController = TextEditingController();
  TextEditingController timeToController = TextEditingController();
  TextEditingController minAmount = TextEditingController();
  TextEditingController maxAmount = TextEditingController();
  TextEditingController excludedAccount = TextEditingController();

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

      if (chartController.swapFilter.excludedAccounts != null &&
          chartController.swapFilter.excludedAccounts!.isNotEmpty) {
        excludedAccounts = chartController.swapFilter.excludedAccounts!;
      }
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

  void addExcludedAccount() {
    if (validWalletAddress(excludedAccount.text)) {
      if (!excludedAccounts.contains(excludedAccount.text)) {
        setState(() {
          errorAddress = '';
          excludedAccounts = [...excludedAccounts, excludedAccount.text];
        });
        excludedAccount.text = '';
      } else {
        setState(() {
          errorAddress = 'This account address is already added.';
        });
      }
    } else {
      setState(() {
        errorAddress = 'Invalid account address.';
      });
    }
  }

  void removeExcludedAccount(String accToRemove) {
    setState(() {
      excludedAccounts =
          excludedAccounts.where((acc) => acc != accToRemove).toList();
    });
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
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                      horizontal: Dimensions.DEFAULT_MARGIN,
                    ),
                    showAllValue: 'Show all tokens',
                  ),
                  UIHelper.verticalSpaceMedium(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exclude accounts',
                        style: inputLabelTextStyle(),
                      ),
                      UIHelper.verticalSpaceExtraSmall(),
                      Wrap(
                        spacing: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                        children: excludedAccounts.map((acc) {
                          return ActionChip(
                            labelPadding: const EdgeInsets.symmetric(
                              horizontal: 2,
                            ),
                            visualDensity: VisualDensity.compact,
                            label: Text(formatAddress(acc, 5)),
                            labelStyle: const TextStyle(
                              fontSize: overline2,
                            ),
                            avatar: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            backgroundColor: backgroundColorLight,
                            side: BorderSide.none,
                            onPressed: () => removeExcludedAccount(acc),
                          );
                        }).toList(),
                      ),
                      if (errorAddress.isNotEmpty) ...[
                        Text(
                          errorAddress,
                          style: TextStyle(
                            fontSize: overline,
                            color: Colors.red[500],
                          ),
                        )
                      ],
                      UIHelper.verticalSpaceExtraSmall(),
                      Row(
                        children: [
                          Expanded(
                            child: InputField(
                              hint: 'Enter account id',
                              controller: excludedAccount,
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall(),
                          Container(
                            padding: const EdgeInsetsDirectional.all(
                              Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                    Dimensions.DEFAULT_MARGIN_SMALL),
                              ),
                              color: backgroundPink,
                            ),
                            child: GestureDetector(
                              onTap: () => addExcludedAccount(),
                              child: const Icon(
                                Icons.person_add_alt,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
                onPressed: () => chartController.filterSwaps(
                  dateFromController.text,
                  timeFromController.text,
                  dateToController.text,
                  timeToController.text,
                  minAmount.text,
                  maxAmount.text,
                  assetId,
                  excludedAccounts,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
