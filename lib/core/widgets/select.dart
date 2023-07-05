import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:flutter/material.dart';

import '../style/app_text_style.dart';

class Select<T> extends StatelessWidget {
  final List<String> values;
  final String selectedValue;
  final Function onValueChange;

  const Select({
    Key? key,
    required this.values,
    required this.selectedValue,
    required this.onValueChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField(
          value: selectedValue,
          onChanged: (value) => onValueChange(value),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 0.0),
              borderRadius:
                  BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 0.0),
              borderRadius:
                  BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 10.0,
            ),
            filled: true,
          ),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          style: selectTextStyle(),
          items: values.map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
      ],
    );
  }
}
