import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/presentation/chart/chart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Pagination extends StatelessWidget {
  final ChartController controller = Get.find();

  Pagination({Key? key}) : super(key: key);

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
    return Container(
      color: chartBackground,
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.DEFAULT_MARGIN_SMALL),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
        children: [
          Text(
            'Total Swaps: ${controller.pageMeta.totalCount}',
            style: paginationTextStyle(),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              button(
                  Icons.keyboard_double_arrow_left, controller.goToFirstPage),
              button(Icons.keyboard_arrow_left, controller.goToPreviousPage),
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
                  borderRadius:
                      BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
                  color: backgroundPink,
                ),
                child: Text(
                  '${controller.pageMeta.pageNumber}/${controller.pageMeta.pageCount}',
                  style: paginationPageNumberTextStyle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              button(Icons.keyboard_arrow_right, controller.goToNextPage),
              button(
                  Icons.keyboard_double_arrow_right, controller.goToLastPage),
            ],
          ),
        ],
      ),
    );
  }
}
