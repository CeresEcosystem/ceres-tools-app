import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/toast.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/center_loading.dart';
import 'package:ceres_tools_app/core/widgets/error_text.dart';
import 'package:ceres_tools_app/core/widgets/item_container.dart';
import 'package:ceres_tools_app/core/widgets/pagination.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/core/widgets/round_image.dart';
import 'package:ceres_tools_app/domain/models/token.dart';
import 'package:ceres_tools_app/domain/models/token_holder.dart';
import 'package:ceres_tools_app/presentation/token_holders/token_holders_controller.dart';
import 'package:ceres_tools_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TokenHoldersView extends GetView<TokenHoldersController> {
  const TokenHoldersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Token token = Get.arguments['token'];

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
                tokenHeaderTitle(token, sizingInformation),
                UIHelper.verticalSpaceExtraSmall(),
                Obx(() {
                  if (controller.loadingStatus == LoadingStatus.LOADING) {
                    return const CenterLoading();
                  }

                  if (controller.loadingStatus == LoadingStatus.ERROR) {
                    return ErrorText(
                      onButtonPress: () => controller.fetchHolders(),
                    );
                  }

                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: controller.tokenHolders.isEmpty
                              ? Text(
                                  'Token has no holders',
                                  style: emptyListTextStyle(sizingInformation),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        UIHelper.pagePadding(sizingInformation),
                                  ),
                                  itemBuilder: (context, index) {
                                    TokenHolder tokenHolder =
                                        controller.tokenHolders[index];

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
                                                'Holder:',
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
                                                              tokenHolder.holder
                                                        }),
                                                    child: Text(
                                                      tokenHolder
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
                                                      'Copied Holder AccountId: ',
                                                      tokenHolder.holder,
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
                                                'Balance:',
                                                style:
                                                    tokenHolderLabelTextStyle(
                                                        sizingInformation),
                                              ),
                                              Text(
                                                tokenHolder.balanceFormatted,
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
                                  itemCount: controller.tokenHolders.length),
                        ),
                        if (controller.pageMeta.pageCount > 1)
                          (Pagination(
                            pageMeta: controller.pageMeta,
                            goToFirstPage: controller.goToFirstPage,
                            goToPreviousPage: controller.goToPreviousPage,
                            goToNextPage: controller.goToNextPage,
                            goToLastPage: controller.goToLastPage,
                            label: 'Total holders',
                          )),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget tokenHeaderTitle(Token token, SizingInformation sizingInformation) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: UIHelper.pagePadding(sizingInformation)),
      child: Row(
        children: [
          RoundImage(
            image: '$kImageStorage${token.shortName}${token.imageExtension}',
            size: Dimensions.PAIRS_IMAGE_SIZE,
            extension: token.imageExtension,
          ),
          UIHelper.horizontalSpaceSmall(),
          Text(
            checkEmptyString(token.shortName),
            style: tokensTitleStyle(sizingInformation),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
