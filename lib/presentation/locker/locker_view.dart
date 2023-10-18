import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/address_format.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
import 'package:ceres_locker_app/core/utils/default_value.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:ceres_locker_app/core/utils/toast.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/center_loading.dart';
import 'package:ceres_locker_app/core/widgets/item_container.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:ceres_locker_app/core/widgets/round_image.dart';
import 'package:ceres_locker_app/domain/models/locked_item.dart';
import 'package:ceres_locker_app/domain/models/pair.dart';
import 'package:ceres_locker_app/domain/models/token.dart';
import 'package:ceres_locker_app/presentation/locker/locker_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LockerView extends GetView<LockerController> {
  const LockerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

    bool isPair = args['isPair'];
    final item = args['lockerItem'];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Image.asset('lib/core/assets/images/ceres_tools_logo.png',
            height: Dimensions.HEADER_LOGO),
      ),
      body: Responsive(
        builder: (context, sizingInformation) {
          return Obx(() {
            if (controller.loadingStatus == LoadingStatus.LOADING) {
              return const CenterLoading();
            }

            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    UIHelper.verticalSpaceMediumLarge(),
                    (() {
                      if (isPair) {
                        return pairHeaderTitle(item, sizingInformation);
                      } else {
                        return tokenHeaderTitle(item, sizingInformation);
                      }
                    }()),
                    UIHelper.verticalSpaceMediumLarge(),
                  ]),
                ),
                renderList(isPair, sizingInformation),
              ],
            );
          });
        },
      ),
    );
  }

  Widget renderList(bool isPair, SizingInformation sizingInformation) {
    if (controller.lockedItems.isNotEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = controller.lockedItems[index];

          return ItemContainer(
            sizingInformation: sizingInformation,
            child: lockerItem(item, sizingInformation, isPair),
          );
        }, childCount: controller.lockedItems.length),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: UIHelper.pagePadding(sizingInformation)),
          child: Text(
            isPair ? kEmptyLockedPairsList : kEmptyLockedTokensList,
            style: emptyListTextStyle(sizingInformation),
          ),
        ),
      ]),
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
              image: '$kImageStorage${pair.shortName}${pair.imageExtension}',
              size: Dimensions.PAIRS_IMAGE_SIZE,
              extension: pair.imageExtension,
            ),
          ),
          RoundImage(
            image: '$kImageStorage${pair.baseToken}$kImageExtension',
            size: Dimensions.PAIRS_IMAGE_SIZE,
          ),
        ],
      ),
    );
  }

  Widget lockerItem(
      LockedItem lockedItem, SizingInformation sizingInformation, bool isPair) {
    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => showToastAndCopy(
                  'Copied Account:', lockedItem.account,
                  clipboardText: lockedItem.account),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kAccount,
                    style: pairsInfoStyle(sizingInformation),
                  ),
                  Text(
                    formatAddress(lockedItem.account),
                    style: pairsLabelStyle(sizingInformation),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            UIHelper.verticalSpaceSmall(),
            Text(
              kLocked,
              style: pairsInfoStyle(sizingInformation),
            ),
            Text(
              '${formatToCurrency(lockedItem.locked, showSymbol: false)}${isPair ? '%' : ''}',
              style: pairsLabelStyle(sizingInformation),
            ),
          ],
        )),
        UIHelper.horizontalSpaceSmall(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kUnlockDate,
              style: pairsInfoStyle(sizingInformation),
            ),
            Text(
              checkEmptyString(lockedItem.formattedDate),
              style: pairsLabelStyle(sizingInformation),
            ),
            UIHelper.verticalSpaceSmall(),
            Text(
              kUnlockTime,
              style: pairsInfoStyle(sizingInformation),
            ),
            Text(
              checkEmptyString(lockedItem.formattedTime),
              style: pairsLabelStyle(sizingInformation),
            ),
          ],
        )
      ],
    );
  }
}
