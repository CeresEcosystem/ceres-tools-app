import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/device_screen_type.dart';
import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/currency_format.dart';
import 'package:ceres_locker_app/core/utils/sizing_information.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/round_image.dart';
import 'package:flutter/material.dart';

class DemeterFarming extends StatelessWidget {
  final List<Map<String, dynamic>> farms;
  final List<Map<String, dynamic>> pools;
  final SizingInformation sizingInformation;

  const DemeterFarming({
    Key? key,
    required this.farms,
    required this.pools,
    required this.sizingInformation,
  }) : super(key: key);

  Widget header(String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: UIHelper.pagePadding(sizingInformation),
        right: UIHelper.pagePadding(sizingInformation),
        top: Dimensions.DEFAULT_MARGIN_LARGE,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
            width: 2.0,
            color: Colors.white.withOpacity(0.1),
          )),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            title,
            style: gridHeadingTextStyle(),
          ),
        ),
      ),
    );
  }

  Widget renderImages(Map<String, dynamic> item, {bool isFarm = true}) {
    if (isFarm) {
      return SizedBox(
        width: Dimensions.GRID_LODO * 2,
        child: Stack(
          children: [
            Positioned(
              left: Dimensions.GRID_LODO - (Dimensions.GRID_LODO / 4),
              child: RoundImage(
                image:
                    '$kImageStorage${item["token"]}${item['imageExtension']}',
                size: Dimensions.GRID_LODO,
                extension: item['imageExtension'],
              ),
            ),
            RoundImage(
              image: '$kImageStorage${item["baseAsset"]}$kImageExtension',
              size: Dimensions.GRID_LODO,
            ),
          ],
        ),
      );
    }

    return RoundImage(
      image: '$kImageStorage${item["token"]}${item['imageExtension']}',
      size: Dimensions.GRID_LODO,
      extension: item['imageExtension'],
    );
  }

  Widget farmInfo(String label, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: gridItemTitleTextStyle()
                  .copyWith(color: Colors.white.withOpacity(0.5)),
            ),
          ),
          Text(
            info,
            style: gridItemTitleTextStyle(),
          ),
        ],
      ),
    );
  }

  String getTitle(Map<String, dynamic> item, {bool isFarm = true}) {
    if (isFarm) return '${item["baseAsset"]} / ${item["token"]}';

    return item['token'];
  }

  Widget renderFarmDetails(Map<String, dynamic> item, {bool isFarm = true}) {
    if (isFarm) {
      return farmInfo(
          'Liquidity:',
          checkNumberValue(item['totalLiquidity'])
              ? formatToCurrency(item["totalLiquidity"], showSymbol: true)
              : 'Calculating...');
    }

    return farmInfo(
        'Staked:',
        checkNumberValue(item['stakedTotal'])
            ? formatToCurrency(item["stakedTotal"], showSymbol: true)
            : 'Calculating...');
  }

  Widget grid(List<Map<String, dynamic>> list, {bool isFarm = true}) {
    return Padding(
      padding: EdgeInsets.only(
        left: UIHelper.pagePadding(sizingInformation),
        right: UIHelper.pagePadding(sizingInformation),
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              sizingInformation.deviceScreenType == DeviceScreenType.Mobile
                  ? 2
                  : 3,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio:
              sizingInformation.deviceScreenType == DeviceScreenType.Mobile
                  ? 0.85
                  : 1.05,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          final item = list[index];

          return Container(
            padding:
                const EdgeInsets.all(Dimensions.DEFAULT_MARGIN_EXTRA_SMALL),
            decoration: BoxDecoration(
              color: backgroundColorDark,
              borderRadius:
                  BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    renderImages(item, isFarm: isFarm),
                    Expanded(
                      child: Text(
                        getTitle(item, isFarm: isFarm),
                        style: gridItemTitleTextStyle(),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
                UIHelper.verticalSpaceSmall(),
                farmInfo(
                    'APR:',
                    checkNumberValue(item['apr'])
                        ? '${formatToCurrency(item["apr"], showSymbol: false)}%'
                        : 'Calculating...'),
                Divider(
                  height: 1,
                  color: Colors.white.withOpacity(0.1),
                ),
                farmInfo('Earn:', item['earn']),
                Divider(
                  height: 1,
                  color: Colors.white.withOpacity(0.1),
                ),
                farmInfo('Fee:',
                    '${formatToCurrency(item["depositFee"], showSymbol: false)}%'),
                Divider(
                  height: 1,
                  color: Colors.white.withOpacity(0.1),
                ),
                renderFarmDetails(item, isFarm: isFarm),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          header('Farming'),
          grid(farms),
          header('Staking'),
          grid(pools, isFarm: false),
        ],
      ),
    );
  }
}
