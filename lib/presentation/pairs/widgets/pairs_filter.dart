import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/round_image.dart';
import 'package:ceres_tools_app/presentation/pairs/pairs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PairsFilter extends StatelessWidget {
  final SizingInformation sizingInformation;
  const PairsFilter({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PairsController controller = Get.find<PairsController>();

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(
          top: Dimensions.DEFAULT_MARGIN_SMALL,
          bottom: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: UIHelper.pagePadding(sizingInformation),
        ),
        height: 35,
        child: ListView.separated(
          itemBuilder: (_, index) {
            String item = controller.baseAssets[index];
            bool showIcon = item == 'All';
            String icon = item == 'Synthetics' ? 'XST' : item;
            bool isActive = item == 'Synthetics'
                ? controller.syntheticsFilter
                : item == controller.baseAsset
                    ? true
                    : false;

            return GestureDetector(
              onTap: () {
                if (item == 'Synthetics') {
                  controller.setSyntheticsFilter();
                } else {
                  controller.setBaseAsset(item);
                }
              },
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: Dimensions.PAIRS_IMAGE_SIZE,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(Dimensions.DEFAULT_MARGIN),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL / 2,
                  horizontal: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                ),
                child: Opacity(
                  opacity: isActive ? 1 : 0.7,
                  child: Center(
                    child: Row(
                      children: [
                        if (!showIcon) ...[
                          RoundImage(
                            image: '$kImageStorage$icon',
                            size: Dimensions.SOCIAL_ICONS_SIZE,
                          ),
                          UIHelper.horizontalSpaceExtraSmall(),
                        ],
                        Text(
                          item,
                          style: allButtonTextStyle(sizingInformation),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => UIHelper.horizontalSpaceExtraSmall(),
          itemCount: controller.baseAssets.length,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
