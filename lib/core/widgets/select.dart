import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:flutter/material.dart';

import '../style/app_text_style.dart';

class Select<T> extends StatelessWidget {
  final List<T> values;
  final T selectedValue;
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
        DropdownButtonFormField<T>(
          value: selectedValue,
          onChanged: (T? value) => onValueChange(value),
          selectedItemBuilder: (BuildContext context) {
            return values.map<Widget>((T value) {
              return Container(
                constraints: const BoxConstraints(maxWidth: 200.0),
                child: Text(
                  value.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            }).toList();
          },
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
          items: values.map<DropdownMenuItem<T>>((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(
                value.toString(),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
