import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/enums/loading_status.dart';
import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/center_loading.dart';
import 'package:ceres_locker_app/core/widgets/ceres_banner.dart';
import 'package:ceres_locker_app/core/widgets/ceres_header.dart';
import 'package:ceres_locker_app/core/widgets/empty_widget.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:ceres_locker_app/core/widgets/input_field.dart';
import 'package:ceres_locker_app/core/widgets/side_menu/side_menu.dart';
import 'package:ceres_locker_app/core/widgets/status_bar.dart';
import 'package:ceres_locker_app/presentation/portfolio/portfolio_controller.dart';
import 'package:ceres_locker_app/presentation/portfolio/widgets/portfolio_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortfolioView extends GetView<PortfolioController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PortfolioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          endDrawer: SideMenu(),
          body: Column(
            children: [
              const StatusBar(),
              Obx(() {
                if (controller.pageLoading == LoadingStatus.LOADING) {
                  return const Expanded(child: CenterLoading());
                }

                return Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          const CeresBanner(),
                          UIHelper.verticalSpaceMediumLarge(),
                          CeresHeader(
                            scaffoldKey: _scaffoldKey,
                          ),
                          UIHelper.verticalSpaceMediumLarge(),
                        ]),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    UIHelper.pagePadding(sizingInformation)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InputField(
                                    onChanged: (t) => controller.onTyping(t),
                                    hint: kWalletAddressTextFieldHint,
                                    showIcon: false,
                                    smallerFont: true,
                                    text: controller.searchQuery,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: Dimensions.DEFAULT_MARGIN_SMALL,
                                  ),
                                  width: 100.0,
                                  child: ElevatedButton(
                                    onPressed: controller.loadingStatus ==
                                            LoadingStatus.LOADING
                                        ? null
                                        : () =>
                                            controller.fetchPortfolioItems(),
                                    child: Text(
                                      controller.loadingStatus ==
                                              LoadingStatus.LOADING
                                          ? 'Loading'
                                          : 'Fetch',
                                      style: buttonLightTextStyle(
                                          sizingInformation),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          UIHelper.verticalSpaceMedium(),
                        ]),
                      ),
                      if (controller.searchQuery.isEmpty)
                        (SliverList(
                          delegate: SliverChildListDelegate([
                            const EmptyWidget(),
                          ]),
                        ))
                      else if (controller.loadingStatus ==
                          LoadingStatus.LOADING)
                        (SliverList(
                          delegate: SliverChildListDelegate([
                            const CenterLoading(),
                          ]),
                        ))
                      else if (controller.portfolioItems.isEmpty)
                        (SliverList(
                          delegate: SliverChildListDelegate([
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      UIHelper.pagePadding(sizingInformation)),
                              child: Text(
                                'No tokens in portfolio',
                                style: emptyListTextStyle(sizingInformation),
                              ),
                            ),
                          ]),
                        ))
                      else
                        (SliverToBoxAdapter(
                          child: PortfolioTable(
                            portfolioItems: controller.portfolioItems,
                            totalValue: controller.totalValue,
                          ),
                        ))
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
