import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool enabledValidation;
  final bool enabled;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormatters;

  const InputField({
    Key? key,
    required this.hint,
    required this.controller,
    this.onChanged,
    this.enabledValidation = false,
    this.enabled = true,
    this.textInputType = TextInputType.text,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return TextFormField(
          controller: controller,
          enabled: enabled,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.DEFAULT_MARGIN_SMALL)),
              borderSide: BorderSide(color: backgroundColorDark, width: 1.0),
            ),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.DEFAULT_MARGIN_SMALL)),
              borderSide: BorderSide(color: backgroundColorDark, width: 1.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.DEFAULT_MARGIN_SMALL)),
              borderSide: BorderSide(color: backgroundPink, width: 1.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Dimensions.DEFAULT_MARGIN_SMALL,
            ),
            filled: true,
            hintText: hint,
            hintStyle: searchTextFieldHintStyle(sizingInformation),
            fillColor: backgroundColorDark,
          ),
          keyboardType: textInputType,
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
