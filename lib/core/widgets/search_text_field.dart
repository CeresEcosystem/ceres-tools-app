import 'package:ceres_tools_app/core/assets/fonts/flaticon.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final String hint;
  final Function onChanged;
  final bool showIcon;
  final bool smallerFont;

  const SearchTextField({
    Key? key,
    required this.hint,
    required this.onChanged,
    this.showIcon = true,
    this.smallerFont = false,
  }) : super(key: key);

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField>
    with AutomaticKeepAliveClientMixin<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Responsive(
      builder: (context, sizingInformation) {
        return TextField(
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
            contentPadding: EdgeInsets.symmetric(
              vertical: Dimensions.DEFAULT_MARGIN_SMALL,
              horizontal: widget.showIcon
                  ? Dimensions.DEFAULT_MARGIN_SMALL / 2
                  : Dimensions.DEFAULT_MARGIN_SMALL,
            ),
            filled: true,
            hintText: widget.hint,
            hintStyle: widget.smallerFont
                ? searchTextFieldHintStyle(sizingInformation)
                    .copyWith(fontSize: subtitle2)
                : searchTextFieldHintStyle(sizingInformation),
            fillColor: backgroundColorDark,
            prefixIcon: widget.showIcon
                ? const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.DEFAULT_MARGIN_SMALL,
                    ),
                    child: Icon(
                      Flaticon.magnifier,
                      size: Dimensions.ICON_SIZE,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          onChanged: (text) => widget.onChanged(text),
          autocorrect: false,
          autofocus: false,
          style: widget.smallerFont
              ? searchTextFieldTextStyle(sizingInformation)
                  .copyWith(fontSize: subtitle2)
              : searchTextFieldTextStyle(sizingInformation),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
