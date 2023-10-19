import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:flutter/material.dart';

import '../style/app_text_style.dart';

class Select<T> extends StatelessWidget {
  final List<T> values;
  final T selectedValue;
  final Function onValueChange;
  final bool showCopyButton;
  final Function? onCopy;

  const Select({
    Key? key,
    required this.values,
    required this.selectedValue,
    required this.onValueChange,
    this.showCopyButton = false,
    this.onCopy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius:
                BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
          ),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<T>(
                  value: selectedValue,
                  onChanged: (T? value) => onValueChange(value),
                  selectedItemBuilder: (BuildContext context) {
                    return values.map<Widget>((T value) {
                      return SizedBox(
                        width: sizingInformation.localWidgetSize.width * 0.65,
                        child: Text(
                          value.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    }).toList();
                  },
                  elevation: 0,
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 10.0,
                    ),
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
                ),
              ),
              if (showCopyButton)
                GestureDetector(
                  onTap: onCopy != null ? () => onCopy!() : () {},
                  child: (const Padding(
                    padding: EdgeInsets.only(
                        right: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL),
                    child: Icon(
                      Icons.copy,
                    ),
                  )),
                ),
            ],
          ),
        );
      },
    );
  }
}
