import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final String hint;
  final Function onChanged;

  const SearchTextField({
    Key? key,
    required this.hint,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return TextField(
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(Dimensions.DEFAULT_MARGIN_SMALL)),
              borderSide: BorderSide(color: backgroundColorDark, width: 1.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(Dimensions.DEFAULT_MARGIN_SMALL)),
              borderSide: BorderSide(color: backgroundPink, width: 1.0),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.DEFAULT_MARGIN_SMALL, horizontal: Dimensions.DEFAULT_MARGIN_SMALL),
            filled: true,
            hintText: hint,
            hintStyle: searchTextFieldHintStyle(sizingInformation),
            fillColor: backgroundColorDark,
            prefixIcon: const Icon(
              Icons.search,
              size: Dimensions.ICON_SIZE,
              color: Colors.white,
            ),
          ),
          onChanged: (text) => onChanged(text),
          autocorrect: false,
          autofocus: false,
          style: searchTextFieldTextStyle(sizingInformation),
        );
      },
    );
  }
}
