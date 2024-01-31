import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/enums/tracker_table_type.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/center_loading.dart';
import 'package:ceres_tools_app/core/widgets/item_container.dart';
import 'package:ceres_tools_app/core/widgets/table_pagination.dart';
import 'package:ceres_tools_app/domain/models/block.dart';
import 'package:ceres_tools_app/presentation/tracker/tracker_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class XorSpent extends StatelessWidget {
  final SizingInformation sizingInformation;

  const XorSpent({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TrackerController controller = Get.find<TrackerController>();

    return ItemContainer(
      sizingInformation: sizingInformation,
      child: Obx(() {
        return Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.selectedToken == 'PSWAP'
                      ? 'XOR spent'
                      : 'TBC burns',
                  style: trackerBlockLabelTitleStyle(sizingInformation),
                ),
                UIHelper.verticalSpaceSmallMedium(),
                Column(
                  children: controller.blocksXorSpent.map((Block block) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.DEFAULT_MARGIN_SMALL / 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'block #${formatToCurrency(block.blockNumber, decimalDigits: 0)}',
                              style: trackerBlockBlockStyle(sizingInformation),
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall(),
                          Expanded(
                            child: Text(
                              controller.selectedToken == 'VAL'
                                  ? '${formatToCurrency(block.grossBurn, decimalDigits: 4)} VAL'
                                  : '${formatToCurrency(block.xorSpent, decimalDigits: 4)} $kXOR',
                              style: trackerBlockBlockStyle(sizingInformation),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                UIHelper.verticalSpaceMedium(),
                TablePagination(
                  currentPage: controller.pageMetaXorSpent.pageNumber,
                  totalPages: controller.pageMetaXorSpent.pageCount,
                  onFirstClick: () =>
                      controller.goToFirstPage(TrackerTableType.XOR_SPENT),
                  onPreviousClick: () =>
                      controller.goToPreviousPage(TrackerTableType.XOR_SPENT),
                  onNextClick: () =>
                      controller.goToNextPage(TrackerTableType.XOR_SPENT),
                  onLastClick: () =>
                      controller.goToLastPage(TrackerTableType.XOR_SPENT),
                  sizingInformation: sizingInformation,
                ),
              ],
            ),
            if (controller.loadingXorSpent == LoadingStatus.LOADING) ...[
              Positioned.fill(
                child: Container(
                  color: Colors.black12,
                  child: const CenterLoading(),
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}
