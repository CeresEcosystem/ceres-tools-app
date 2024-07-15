import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/toast.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/center_loading.dart';
import 'package:ceres_tools_app/core/widgets/error_text.dart';
import 'package:ceres_tools_app/core/widgets/item_container.dart';
import 'package:ceres_tools_app/core/widgets/pagination.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/core/widgets/round_image.dart';
import 'package:ceres_tools_app/domain/models/pair.dart';
import 'package:ceres_tools_app/domain/models/pair_liquidity_provider.dart';
import 'package:ceres_tools_app/presentation/pairs_providers/pairs_providers_controller.dart';
import 'package:ceres_tools_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PairsProvidersView extends GetView<PairsProvidersController> {
  const PairsProvidersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Pair pair = Get.arguments;

    return Responsive(
      builder: (context, sizingInformation) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Image.asset(
              'lib/core/assets/images/ceres_tools_logo.png',
              height: Dimensions.HEADER_LOGO,
            ),
          ),
          bottomNavigationBar: Container(
            height: sizingInformation.bottomSafeAreaSize,
            color: chartBackground,
          ),
          body: SafeArea(
            child: Column(
              children: [
                UIHelper.verticalSpaceMedium(),
                pairHeaderTitle(pair, sizingInformation),
                UIHelper.verticalSpaceMedium(),
                Obx(() {
                  if (controller.loadingStatus == LoadingStatus.LOADING) {
                    return const CenterLoading();
                  }

                  if (controller.loadingStatus == LoadingStatus.ERROR) {
                    return ErrorText(
                      onButtonPress: () {},
                    );
                  }

                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: controller.pairLiquidityProviders.isEmpty
                              ? Text(
                                  'Pair has no liquidity providers',
                                  style: emptyListTextStyle(sizingInformation),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        UIHelper.pagePadding(sizingInformation),
                                  ),
                                  itemBuilder: (context, index) {
                                    PairLiquidityProvider liquidityProvider =
                                        controller
                                            .pairLiquidityProviders[index];

                                    return ItemContainer(
                                      sizingInformation: sizingInformation,
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        runSpacing: Dimensions
                                            .DEFAULT_MARGIN_EXTRA_SMALL,
                                        spacing: Dimensions
                                            .DEFAULT_MARGIN_EXTRA_SMALL,
                                        alignment: WrapAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Account:',
                                                style:
                                                    tokenHolderLabelTextStyle(
                                                        sizingInformation),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => Get.toNamed(
                                                        Routes.PORTFOLIO,
                                                        arguments: {
                                                          'address':
                                                              liquidityProvider
                                                                  .address
                                                        }),
                                                    child: Text(
                                                      liquidityProvider
                                                          .accountIdFormatted!,
                                                      style:
                                                          tokenHolderTitleTextStyle(
                                                              sizingInformation),
                                                    ),
                                                  ),
                                                  UIHelper
                                                      .horizontalSpaceExtraSmall(),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        showToastAndCopy(
                                                      'Copied AccountId: ',
                                                      liquidityProvider.address,
                                                    ),
                                                    child: const Icon(
                                                      Icons.copy,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Liquidity:',
                                                style:
                                                    tokenHolderLabelTextStyle(
                                                        sizingInformation),
                                              ),
                                              Text(
                                                liquidityProvider
                                                    .liquidityFormatted,
                                                style:
                                                    tokenHolderTitleTextStyle(
                                                        sizingInformation),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount:
                                      controller.pairLiquidityProviders.length,
                                ),
                        ),
                        if (controller.pageMeta.pageCount > 1)
                          (Pagination(
                            pageMeta: controller.pageMeta,
                            goToFirstPage: controller.goToFirstPage,
                            goToPreviousPage: controller.goToPreviousPage,
                            goToNextPage: controller.goToNextPage,
                            goToLastPage: controller.goToLastPage,
                            label: 'Total providers',
                          )),
                      ],
                    ),
                  );
                })
              ],
            ),
          ),
        );
      },
    );
  }

  Widget pairHeaderTitle(Pair pair, SizingInformation sizingInformation) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: UIHelper.pagePadding(sizingInformation)),
      child: Row(
        children: [
          pairImage(pair),
          UIHelper.horizontalSpaceSmall(),
          Text(
            '${pair.baseToken} / ${pair.shortName}',
            style: tokensTitleStyle(sizingInformation),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget pairImage(Pair pair) {
    return SizedBox(
      width: Dimensions.PAIRS_IMAGE_SIZE * 2,
      child: Stack(
        children: [
          Positioned(
            left:
                Dimensions.PAIRS_IMAGE_SIZE - (Dimensions.PAIRS_IMAGE_SIZE / 4),
            child: RoundImage(
              image: '$kImageStorage${pair.shortName}',
              size: Dimensions.PAIRS_IMAGE_SIZE,
            ),
          ),
          RoundImage(
            image: '$kImageStorage${pair.baseToken}',
            size: Dimensions.PAIRS_IMAGE_SIZE,
          ),
        ],
      ),
    );
  }
}
