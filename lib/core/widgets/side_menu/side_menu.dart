import 'dart:io';

import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/enums/device_screen_type.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/launch_url.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/core/widgets/scroll_bar_container.dart';
import 'package:ceres_tools_app/core/widgets/side_menu/side_menu_content.dart';
import 'package:ceres_tools_app/domain/models/side_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jovial_svg/jovial_svg.dart';

class SideMenu extends StatelessWidget {
  final bool largeScreen;
  final Function? onMenuItemPress;

  final ScrollController controller = ScrollController();

  SideMenu({Key? key, this.largeScreen = false, this.onMenuItemPress})
      : super(key: key);

  void _navigate(Map<String, dynamic> option) {
    SideMenuPage.sideMenuPage.setActivePage(option['title']);

    if (onMenuItemPress != null) {
      onMenuItemPress!(option['path']);
    } else {
      Get.offNamed(option['path']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return SizedBox(
          width: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
              ? sizingInformation.screenSize.width * 0.85
              : sizingInformation.deviceScreenType == DeviceScreenType.Tablet
                  ? sizingInformation.screenSize.width * 0.4
                  : sizingInformation.screenSize.width * 0.25,
          child: Drawer(
            child: Column(
              children: [
                drawerHeader(sizingInformation),
                UIHelper.verticalSpaceMedium(),
                drawerOptions(sizingInformation),
                UIHelper.verticalSpaceMedium(),
                drawerFooter(sizingInformation),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget drawerHeader(SizingInformation sizingInformation) {
    return Padding(
      padding: EdgeInsets.only(
        top: sizingInformation.topSafeAreaSize + Dimensions.DEFAULT_MARGIN,
        left: Dimensions.DEFAULT_MARGIN,
        bottom: Dimensions.DEFAULT_MARGIN,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LimitedBox(
            maxWidth: Dimensions.HEADER_LOGO_WIDTH,
            child: Image.asset('lib/core/assets/images/ceres_tools_logo.png'),
          ),
          if (!largeScreen)
            (GestureDetector(
              onTap: () => Get.back(),
              child: const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Dimensions.DEFAULT_MARGIN),
                child: Icon(Icons.close, size: Dimensions.ICON_SIZE),
              ),
            )),
        ],
      ),
    );
  }

  Widget drawerOptions(SizingInformation sizingInformation) {
    return Expanded(
      child: ScrollBarContainer(
        controller: controller,
        isAlwaysShown: true,
        sizingInformation: sizingInformation,
        child: drawerScroll(sizingInformation),
      ),
    );
  }

  Widget drawerScroll(SizingInformation sizingInformation) {
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: sideMenuOptions.map((option) {
          return drawerOptionitem(option, sizingInformation);
        }).toList(),
      ),
    );
  }

  Widget drawerOptionitem(
      Map<String, dynamic> option, SizingInformation sizingInformation) {
    bool selected = option['title'] == SideMenuPage.sideMenuPage.activePage;

    return InkWell(
      onTap: () => _navigate(option),
      child: Opacity(
        opacity: selected ? 1 : 0.5,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: sizingInformation.screenSize.height > 600.0
                  ? Dimensions.DEFAULT_MARGIN / 3
                  : Dimensions.DEFAULT_MARGIN / 4),
          child: Row(
            children: [
              Container(
                height: Dimensions.DEFAULT_MARGIN * 2,
                width: Dimensions.DEFAULT_MARGIN / 2,
                color: selected ? backgroundPink : Colors.transparent,
              ),
              UIHelper.horizontalSpace(Dimensions.DEFAULT_MARGIN),
              (() {
                if (option['type'] == 'icon') {
                  return Icon(
                    option['icon'],
                    size: Dimensions.SIDE_MENU_ICON_SIZE,
                  );
                }

                return ScalableImageWidget.fromSISource(
                  si: ScalableImageSource.fromSvgHttpUrl(
                    Uri.parse(option['icon']),
                    warnF: (_) {},
                  ),
                );
              })(),
              UIHelper.horizontalSpaceMedium(),
              Text(
                option['title'],
                style: sideMenuTitleStyle(sizingInformation),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerFooter(SizingInformation sizingInformation) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.DEFAULT_MARGIN,
        right: Dimensions.DEFAULT_MARGIN,
        bottom:
            sizingInformation.bottomSafeAreaSize + Dimensions.DEFAULT_MARGIN,
      ),
      child: Column(
        children: [
          if (Platform.isAndroid &&
              sizingInformation.screenSize.height > 600.0) ...[
            GestureDetector(
              onTap: () => launchURL(kPolkaswapWebsite),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: Dimensions.POLKASWAP_LOGO_SIZE,
                ),
                child: Image.asset('lib/core/assets/images/polkaswap_logo.png'),
              ),
            )
          ],
          Divider(
            height: Dimensions.DEFAULT_MARGIN * 2,
            thickness: Dimensions.DIVIDER_THICKNESS_SIZE,
            color: Colors.white.withOpacity(0.1),
          ),
          if (sizingInformation.screenSize.height > 600.0)
            (Column(
              children: [
                socialsGroup(),
                UIHelper.verticalSpace(Dimensions.DEFAULT_MARGIN),
              ],
            )),
          tokensGroup(),
          UIHelper.verticalSpace(Dimensions.DEFAULT_MARGIN),
          Text(
            kCeresFooter,
            style: footerTextStyle(sizingInformation),
          )
        ],
      ),
    );
  }

  Widget socialsGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: sideMenuSocials.map((social) {
        return GestureDetector(
          onTap: () => launchURL(social['url']!),
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: Dimensions.DEFAULT_MARGIN / 2),
            padding: const EdgeInsets.all(Dimensions.DEFAULT_MARGIN / 1.5),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(Dimensions.DEFAULT_MARGIN / 2)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: Dimensions.SOCIAL_ICONS_SIZE,
              ),
              child: Image.asset(social['icon']!),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget tokensGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: sideMenuTokens.map((token) {
        String? url = token['url'];

        return GestureDetector(
          onTap: () {
            if (url != null) {
              launchURL(url);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: Dimensions.DEFAULT_MARGIN_SMALL / 2),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: Dimensions.TOKEN_ICONS_SIZE,
              ),
              child: Image.asset(token['icon']!),
            ),
          ),
        );
      }).toList(),
    );
  }
}
