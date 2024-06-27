import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/ceres_banner.dart';
import 'package:ceres_tools_app/core/widgets/ceres_header.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/core/widgets/side_menu/side_menu.dart';
import 'package:ceres_tools_app/core/widgets/status_bar.dart';
import 'package:ceres_tools_app/presentation/tokens/tokens_controller.dart';
// import 'package:ceres_tools_app/presentation/tokens/widgets/burning_info.dart';
import 'package:ceres_tools_app/presentation/tokens/widgets/token_list_container.dart';
import 'package:ceres_tools_app/presentation/tokens/widgets/token_price_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';

class TokensViewBody extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final SizingInformation sizingInformation;

  const TokensViewBody({
    Key? key,
    required this.scaffoldKey,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  State<TokensViewBody> createState() => _TokensViewBodyState();
}

class _TokensViewBodyState extends State<TokensViewBody> {
  bool showTokenPriceCalculator = false;

  final TokensController controller = Get.find<TokensController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async => controller.fetchTokens(true),
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                const CeresBanner(),
                UIHelper.verticalSpaceMediumLarge(),
                CeresHeader(
                  scaffoldKey: widget.scaffoldKey,
                ),
                // UIHelper.verticalSpaceMedium(),
                // BurningInfo(
                //   sizingInformation: widget.sizingInformation,
                //   info:
                //       'The initial \$KARMA tokens will be earned by a burn-drop, where you can burn 100 million XOR by block 16,056,666 to earn 1 \$KARMA. Click',
                //   tokenFullName: 'Karma',
                //   tokenShortName: 'KARMA',
                // ),
                // BurningInfo(
                //   sizingInformation: widget.sizingInformation,
                //   info:
                //       'KEN (Kensetsu) will be allocated to accounts on the SORA network that burned at least 1 million XOR before block 14,939,200, at a rate of 1 KEN per 1 million XOR burned. Click',
                //   tokenFullName: 'Kensetsu',
                //   tokenShortName: 'KEN',
                // ),
                UIHelper.verticalSpaceMedium(),
              ]),
            ),
            (() {
              if (!showTokenPriceCalculator) {
                return TokenListContainer(
                  sizingInformation: widget.sizingInformation,
                  setShowTokenPriceCalculator: () {
                    setState(() {
                      showTokenPriceCalculator = true;
                    });
                  },
                );
              }

              return TokenPriceCalculator(
                sizingInformation: widget.sizingInformation,
                setShowTokenPriceCalculator: () {
                  controller.clearSearch();
                  setState(() {
                    showTokenPriceCalculator = false;
                  });
                },
              );
            })(),
          ],
        ),
      ),
    );
  }
}

class TokensView extends GetView<TokensController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TokensView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Unfocuser(
      child: Responsive(
        builder: (context, sizingInformation) {
          return Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            endDrawer: SideMenu(),
            body: Column(
              children: [
                const StatusBar(),
                TokensViewBody(
                  scaffoldKey: _scaffoldKey,
                  sizingInformation: sizingInformation,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
