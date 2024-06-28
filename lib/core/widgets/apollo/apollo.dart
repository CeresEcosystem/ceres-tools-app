import 'package:ceres_tools_app/core/enums/loading_status.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/apollo/borrowing.dart';
import 'package:ceres_tools_app/core/widgets/apollo/lending.dart';
import 'package:ceres_tools_app/core/widgets/apollo/stats.dart';
import 'package:ceres_tools_app/core/widgets/empty_widget.dart';
import 'package:ceres_tools_app/presentation/portfolio/portfolio_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final SizingInformation sizingInformation;

  const SectionTitle({
    Key? key,
    required this.title,
    required this.sizingInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: UIHelper.pagePadding(sizingInformation),
        vertical: Dimensions.DEFAULT_MARGIN_SMALL,
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
            style: gridHeadingTextStyle().copyWith(fontSize: headline6),
          ),
        ),
      ),
    );
  }
}

class Apollo extends StatelessWidget {
  final SizingInformation sizingInformation;

  const Apollo({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  Widget noData() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: UIHelper.pagePadding(sizingInformation)),
      child: Text(
        'No data',
        style: emptyListTextStyle(sizingInformation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PortfolioController>();

    return Obx(() {
      if (controller.loadingStatus == LoadingStatus.LOADING) {
        return const SliverToBoxAdapter(
          child: EmptyWidget(),
        );
      }

      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: Dimensions.DEFAULT_MARGIN_LARGE,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ApolloStats(
                stats: controller.apolloDashboard.stats,
                sizingInformation: sizingInformation,
              ),
              SectionTitle(
                title: 'Lending',
                sizingInformation: sizingInformation,
              ),
              if (controller.apolloDashboard.lendingInfo.isEmpty) ...[
                noData(),
              ] else ...[
                Lending(
                  lendingInfo: controller.apolloDashboard.lendingInfo,
                  sizingInformation: sizingInformation,
                ),
              ],
              SectionTitle(
                title: 'Borrowing',
                sizingInformation: sizingInformation,
              ),
              if (controller.apolloDashboard.borrowingInfo.isEmpty) ...[
                noData(),
              ] else ...[
                Borrowing(
                  borrowingInfo: controller.apolloDashboard.borrowingInfo,
                  sizingInformation: sizingInformation,
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
