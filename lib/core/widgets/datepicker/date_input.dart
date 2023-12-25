// ignore_for_file: constant_identifier_names

import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/datepicker/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DateInputType { Date, DateTime }

class DateInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final bool enabledValidation;
  final String title;
  final DateInputType dateInputType;

  const DateInput({
    Key? key,
    required this.controller,
    this.hintText = 'Enter date',
    this.textInputType = TextInputType.text,
    this.enabledValidation = true,
    required this.title,
    this.dateInputType = DateInputType.Date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final format = dateInputType == DateInputType.Date
        ? DateFormat('yyyy-MM-dd')
        : DateFormat('HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title${enabledValidation ? " *" : ""}',
          style: inputLabelTextStyle(),
        ),
        UIHelper.verticalSpaceExtraSmall(),
        DateTimeField(
          format: format,
          controller: controller,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.DEFAULT_MARGIN_SMALL)),
              borderSide: BorderSide(color: Colors.transparent, width: 1),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.DEFAULT_MARGIN_SMALL)),
              borderSide: BorderSide(color: Colors.white, width: 1.0),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.DEFAULT_MARGIN_SMALL)),
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.DEFAULT_MARGIN_SMALL)),
              borderSide: BorderSide(color: Colors.white, width: 1.0),
            ),
            contentPadding: const EdgeInsets.all(
              Dimensions.DEFAULT_MARGIN_SMALL,
            ),
            filled: true,
            fillColor: backgroundColorDark,
            hintText: hintText,
            errorStyle: const TextStyle(color: Colors.red),
          ),
          autocorrect: false,
          autovalidateMode: AutovalidateMode.disabled,
          autofocus: false,
          keyboardType: textInputType,
          resetIcon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 18.0,
          ),
          style: dateTimeFieldTextStyle(),
          cursorRadius: const Radius.circular(10.0),
          validator: (value) {
            if (enabledValidation && value == null) {
              return 'This field is required!';
            }
            return null;
          },
          onShowPicker: (_, currentValue) async {
            if (dateInputType == DateInputType.Date) {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                lastDate: DateTime.now(),
                initialDate: currentValue ?? DateTime.now(),
              );
              return date;
            } else {
              final time = await showTimePicker(
                context: context,
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: Localizations.override(
                      context: context,
                      locale: const Locale('en'),
                      child: child,
                    ),
                  );
                },
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.combine(DateTime.now(), time);
            }
          },
        ),
      ],
    );
  }
}
