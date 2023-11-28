import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/address_format.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/toast.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/round_image.dart';
import 'package:ceres_tools_app/domain/models/transfer.dart';
import 'package:flutter/material.dart';

class TransferItem extends StatelessWidget {
  final SizingInformation sizingInformation;
  final Transfer transfer;

  const TransferItem({
    Key? key,
    required this.sizingInformation,
    required this.transfer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.DEFAULT_MARGIN,
        vertical: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
      ),
      decoration: BoxDecoration(
        color: backgroundColorDark,
        borderRadius: BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    RoundImage(
                      image:
                          '$kImageStorage${transfer.tokenFormatted}${transfer.tokenImageExtension}',
                      size: Dimensions.GRID_LODO,
                      extension: transfer.tokenImageExtension,
                    ),
                    UIHelper.horizontalSpaceSmall(),
                    Text(
                      '${transfer.tokenFormatted}',
                      style: dataTableTextStyle(sizingInformation),
                    )
                  ],
                ),
              ),
              Text(
                transfer.transferredAtFormatted ?? '',
                style: dataTableTextStyle(sizingInformation)
                    .copyWith(fontSize: overline),
              )
            ],
          ),
          UIHelper.verticalSpaceSmall(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sender',
                    style: dataTableLabelTextStyle(),
                  ),
                  Row(
                    children: [
                      Text(
                        formatAddress(transfer.sender, 5),
                        style: dataTableTextStyle(sizingInformation)
                            .copyWith(fontSize: overline),
                      ),
                      UIHelper.horizontalSpaceExtraSmall(),
                      GestureDetector(
                        onTap: () => showToastAndCopy(
                          'Copied Sender AccountId: ',
                          transfer.sender,
                          clipboardText: transfer.sender,
                        ),
                        child: const Icon(Icons.copy, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 25,
                child: VerticalDivider(
                  color: Colors.white.withOpacity(.1),
                  thickness: 2,
                  width: Dimensions.DEFAULT_MARGIN,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Receiver',
                    style: dataTableLabelTextStyle(),
                  ),
                  Row(
                    children: [
                      Text(
                        formatAddress(transfer.receiver, 5),
                        style: dataTableTextStyle(sizingInformation)
                            .copyWith(fontSize: overline),
                      ),
                      UIHelper.horizontalSpaceExtraSmall(),
                      GestureDetector(
                        onTap: () => showToastAndCopy(
                          'Copied Receiver AccountId: ',
                          transfer.receiver,
                          clipboardText: transfer.receiver,
                        ),
                        child: const Icon(Icons.copy, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 25,
                child: VerticalDivider(
                  color: Colors.white.withOpacity(.1),
                  thickness: 2,
                  width: Dimensions.DEFAULT_MARGIN,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount',
                    style: dataTableLabelTextStyle(),
                  ),
                  Text(
                    formatToCurrency(transfer.amount,
                        showSymbol: false, formatOnlyFirstPart: true),
                    style: dataTableTextStyle(sizingInformation),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
