import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/domain/models/page_meta.dart';
import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  final PageMeta pageMeta;
  final Function goToFirstPage;
  final Function goToPreviousPage;
  final Function goToNextPage;
  final Function goToLastPage;
  final String label;

  const Pagination({
    Key? key,
    required this.pageMeta,
    required this.goToFirstPage,
    required this.goToPreviousPage,
    required this.goToNextPage,
    required this.goToLastPage,
    required this.label,
  }) : super(key: key);

  Widget button(IconData icon, Function paginate) {
    return GestureDetector(
      onTap: () => paginate(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
          color: Colors.white.withOpacity(.1),
        ),
        child: Center(child: Icon(icon)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return Container(
          color: chartBackground,
          width: double.infinity,
          padding: const EdgeInsets.all(Dimensions.DEFAULT_MARGIN_SMALL),
          child: Padding(
            padding:
                EdgeInsets.only(bottom: sizingInformation.bottomSafeAreaSize),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
              children: [
                Text(
                  '$label: ${pageMeta.totalCount}',
                  style: paginationTextStyle(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    button(Icons.keyboard_double_arrow_left, goToFirstPage),
                    button(Icons.keyboard_arrow_left, goToPreviousPage),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 150,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            Dimensions.DEFAULT_MARGIN_SMALL),
                        color: backgroundPink,
                      ),
                      child: Text(
                        '${pageMeta.pageNumber}/${pageMeta.pageCount}',
                        style: paginationPageNumberTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    button(Icons.keyboard_arrow_right, goToNextPage),
                    button(Icons.keyboard_double_arrow_right, goToLastPage),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
