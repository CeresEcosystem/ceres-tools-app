import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool enabledValidation;
  final bool enabled;

  const InputField({
    Key? key,
    required this.hint,
    required this.controller,
    this.enabledValidation = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return TextFormField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.DEFAULT_MARGIN_SMALL)),
              borderSide: BorderSide(color: backgroundColorDark, width: 1.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.DEFAULT_MARGIN_SMALL)),
              borderSide: BorderSide(color: backgroundPink, width: 1.0),
            ),
            contentPadding: const EdgeInsets.all(
              Dimensions.DEFAULT_MARGIN_SMALL,
            ),
            filled: true,
            hintText: hint,
            hintStyle: searchTextFieldHintStyle(sizingInformation),
            fillColor: backgroundColorDark,
          ),
          autocorrect: false,
          autofocus: false,
          style: searchTextFieldTextStyle(sizingInformation),
          validator: (value) {
            if (enabledValidation && (value == null || value.isEmpty)) {
              return 'This field is required!';
            }
            return null;
          },
        );
      },
    );
  }
}
