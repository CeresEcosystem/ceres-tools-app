import 'package:ceres_tools_app/core/assets/fonts/flaticon.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:flutter/material.dart';

class TablePagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function onFirstClick;
  final Function onPreviousClick;
  final Function onNextClick;
  final Function onLastClick;
  final SizingInformation sizingInformation;

  const TablePagination({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onFirstClick,
    required this.onPreviousClick,
    required this.onNextClick,
    required this.onLastClick,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => onFirstClick(),
          icon: const Icon(
            Flaticon.arrowLeftDouble,
            size: Dimensions.ICON_SIZE_SMALL,
          ),
        ),
        IconButton(
          onPressed: () => onPreviousClick(),
          icon: const Icon(
            Flaticon.arrowLeft,
            size: Dimensions.ICON_SIZE_SMALL,
          ),
        ),
        Text(
          '$currentPage/$totalPages',
          style: trackerBlockBlockStyle(sizingInformation),
        ),
        IconButton(
          onPressed: () => onNextClick(),
          icon: const Icon(
            Flaticon.arrowRight,
            size: Dimensions.ICON_SIZE_SMALL,
          ),
        ),
        IconButton(
          onPressed: () => onLastClick(),
          icon: const Icon(
            Flaticon.arrowRightDouble,
            size: Dimensions.ICON_SIZE_SMALL,
          ),
        ),
      ],
    );
  }
}
