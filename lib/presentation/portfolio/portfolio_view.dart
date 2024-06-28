import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/toast.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/center_loading.dart';
import 'package:ceres_tools_app/core/widgets/ceres_header.dart';
import 'package:ceres_tools_app/core/widgets/empty_widget.dart';
import 'package:ceres_tools_app/core/widgets/pagination.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/core/widgets/select.dart';
import 'package:ceres_tools_app/core/widgets/side_menu/side_menu.dart';
import 'package:ceres_tools_app/core/widgets/status_bar.dart';
import 'package:ceres_tools_app/domain/models/wallet.dart';
import 'package:ceres_tools_app/presentation/portfolio/portfolio_controller.dart';
import 'package:ceres_tools_app/presentation/portfolio/widgets/portfolio_modal.dart';
import 'package:ceres_tools_app/presentation/portfolio/widgets/portfolio_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortfolioView extends StatefulWidget {
  const PortfolioView({Key? key}) : super(key: key);

  @override
  State<PortfolioView> createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<PortfolioView>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final controller = Get.find<PortfolioController>();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: controller.tabs.length,
        initialIndex: controller.selectedTab,
        vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String address = Get.arguments != null ? Get.arguments['address'] : '';

    return Responsive(
      builder: (context, sizingInformation) {
        return Obx(() {
          return Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            endDrawer: address.isEmpty ? SideMenu() : null,
            body: Column(
              children: [
                const StatusBar(),
                CeresHeader(
                  scaffoldKey: _scaffoldKey,
                  backgroundColor: backgroundColorDark,
                  verticalSpace: true,
                  showBackButton: address.isNotEmpty,
                  showDrawerButton: address.isEmpty,
                ),
                Container(
                  color: backgroundColorDark,
                  child: TabBar(
                    tabs: controller.tabs.map((tab) {
                      return Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            tab['icon'],
                            UIHelper.horizontalSpaceExtraSmall(),
                            Text(
                              tab['label'],
                              style: tabBarTextStyle(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    onTap: (index) => controller.changeSelectedTab(index),
                  ),
                ),
                (() {
                  if (controller.pageLoading == LoadingStatus.LOADING) {
                    return const Expanded(child: CenterLoading());
                  }

                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: CustomScrollView(
                            slivers: [
                              SliverList(
                                delegate: SliverChildListDelegate([
                                  Column(
                                    children: [
                                      UIHelper.verticalSpaceMedium(),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: UIHelper.pagePadding(
                                              sizingInformation),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: controller
                                                      .wallets.isNotEmpty
                                                  ? Select<Wallet>(
                                                      values:
                                                          controller.wallets,
                                                      selectedValue: controller
                                                          .selectedWallet,
                                                      onValueChange:
                                                          (Wallet w) {
                                                        controller
                                                            .handleWalletChange(
                                                                w);
                                                      },
                                                      showCopyButton: true,
                                                      onCopy: () =>
                                                          showToastAndCopy(
                                                        'Copied Account: ',
                                                        controller
                                                            .selectedWallet
                                                            .address,
                                                        clipboardText:
                                                            controller
                                                                .selectedWallet
                                                                .address,
                                                      ),
                                                    )
                                                  : Text(
                                                      'No added wallets. Please, add one.',
                                                      style: emptyListTextStyle(
                                                        sizingInformation,
                                                      ),
                                                    ),
                                            ),
                                            if (controller.wallets.isNotEmpty &&
                                                controller.selectedWallet.name
                                                    .isNotEmpty)
                                              (Container(
                                                margin: const EdgeInsets.only(
                                                  left: Dimensions
                                                      .DEFAULT_MARGIN_SMALL,
                                                ),
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .all(
                                                  Dimensions
                                                      .DEFAULT_MARGIN_EXTRA_SMALL,
                                                ),
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(Dimensions
                                                        .DEFAULT_MARGIN_SMALL),
                                                  ),
                                                  color: backgroundPink,
                                                ),
                                                child: GestureDetector(
                                                  onTap: controller
                                                              .loadingStatus ==
                                                          LoadingStatus.LOADING
                                                      ? null
                                                      : () => showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return PortfolioModal(
                                                                wallet: controller
                                                                    .selectedWallet,
                                                                addEditWallet:
                                                                    controller
                                                                        .addEditWallet,
                                                                removeWallet:
                                                                    controller
                                                                        .removeWallet,
                                                              );
                                                            },
                                                          ),
                                                  child: const Icon(
                                                    Icons.edit_outlined,
                                                  ),
                                                ),
                                              )),
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: controller.wallets.isEmpty
                                                    ? Dimensions
                                                        .DEFAULT_MARGIN_SMALL
                                                    : Dimensions
                                                        .DEFAULT_MARGIN_EXTRA_SMALL,
                                              ),
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .all(
                                                Dimensions
                                                    .DEFAULT_MARGIN_EXTRA_SMALL,
                                              ),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(Dimensions
                                                      .DEFAULT_MARGIN_SMALL),
                                                ),
                                                color: backgroundPink,
                                              ),
                                              child: GestureDetector(
                                                onTap: controller
                                                            .loadingStatus ==
                                                        LoadingStatus.LOADING
                                                    ? null
                                                    : () => showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return PortfolioModal(
                                                              wallet: Wallet('',
                                                                  '', false),
                                                              addEditWallet:
                                                                  controller
                                                                      .addEditWallet,
                                                              removeWallet:
                                                                  controller
                                                                      .removeWallet,
                                                            );
                                                          },
                                                        ),
                                                child: const Icon(
                                                  Icons.person_add_alt,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  UIHelper.verticalSpaceMedium(),
                                ]),
                              ),
                              if (controller.wallets.isEmpty)
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
                              else
                                (PortfolioTable(
                                  sizingInformation: sizingInformation,
                                ))
                            ],
                          ),
                        ),
                        if ((controller.selectedTab == 4 ||
                                controller.selectedTab == 5) &&
                            controller.pageMeta.pageCount > 1)
                          (Pagination(
                            pageMeta: controller.pageMeta,
                            goToFirstPage: controller.goToFirstPage,
                            goToPreviousPage: controller.goToPreviousPage,
                            goToNextPage: controller.goToNextPage,
                            goToLastPage: controller.goToLastPage,
                            label: 'Total',
                          )),
                      ],
                    ),
                  );
                }()),
              ],
            ),
          );
        });
      },
    );
  }
}
