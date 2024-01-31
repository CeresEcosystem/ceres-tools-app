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

class GrossTable extends StatelessWidget {
  final SizingInformation sizingInformation;

  const GrossTable({
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
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Burns by fees',
                  style: trackerBlockHeaderStyle(sizingInformation)
                      .copyWith(color: Colors.white),
                ),
                UIHelper.verticalSpaceSmallMedium(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children:
                            controller.getGrossTableDataHeader.map((item) {
                          return rowItem(
                            Text(
                              item,
                              style: trackerBlockHeaderStyle(sizingInformation),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                      UIHelper.verticalSpaceSmallMedium(),
                      ...controller.blocksGrossTable.map((Block block) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.DEFAULT_MARGIN_SMALL / 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              rowItem(
                                Text(
                                  '${controller.selectedToken == 'VAL' && block.blockNumber == kValLatestBlock ? 'until' : 'block'} #${formatToCurrency(block.blockNumber, decimalDigits: 0)}',
                                  style:
                                      trackerBlockBlockStyle(sizingInformation),
                                ),
                              ),
                              if (controller.selectedToken == 'VAL')
                                (rowItem(
                                  Text(
                                    formatToCurrency(
                                        block.xorDedicatedForBuyBack,
                                        decimalDigits: 3),
                                    style: trackerBlockBlockStyle(
                                        sizingInformation),
                                  ),
                                )),
                              rowItem(
                                Text(
                                  formatToCurrency(block.grossBurn,
                                      decimalDigits: 3),
                                  style:
                                      trackerBlockBlockStyle(sizingInformation),
                                ),
                              ),
                              if (controller.selectedToken == 'PSWAP')
                                (rowItem(
                                  Text(
                                    formatToCurrency(block.remintedLp,
                                        decimalDigits: 3),
                                    style: trackerBlockBlockStyle(
                                        sizingInformation),
                                  ),
                                )),
                              rowItem(
                                Text(
                                  formatToCurrency(block.remintedParliament,
                                      decimalDigits: 3),
                                  style:
                                      trackerBlockBlockStyle(sizingInformation),
                                ),
                              ),
                              rowItem(
                                Text(
                                  formatToCurrency(block.netBurn,
                                      decimalDigits: 3),
                                  style:
                                      trackerBlockBlockStyle(sizingInformation),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                UIHelper.verticalSpaceMedium(),
                TablePagination(
                  currentPage: controller.pageMetaGrossTable.pageNumber,
                  totalPages: controller.pageMetaGrossTable.pageCount,
                  onFirstClick: () =>
                      controller.goToFirstPage(TrackerTableType.GROSS_TABLE),
                  onPreviousClick: () =>
                      controller.goToPreviousPage(TrackerTableType.GROSS_TABLE),
                  onNextClick: () =>
                      controller.goToNextPage(TrackerTableType.GROSS_TABLE),
                  onLastClick: () =>
                      controller.goToLastPage(TrackerTableType.GROSS_TABLE),
                  sizingInformation: sizingInformation,
                ),
              ],
            ),
            if (controller.loadingGrossTable == LoadingStatus.LOADING) ...[
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

  Widget rowItem(Widget child) {
    return SizedBox(
      width: Dimensions.ROW_ITEM_WIDTH,
      child: child,
    );
  }
}
