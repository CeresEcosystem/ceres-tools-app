import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/utils/default_value.dart';

class Transfer {
  final String? sender;
  final double? amount;
  final String? asset;
  final String? receiver;
  final String transferredAt;
  String? tokenFormatted;
  String tokenImageExtension = kImageExtension;
  String? transferredAtFormatted;

  Transfer(
    this.sender,
    this.amount,
    this.asset,
    this.receiver,
    this.transferredAt,
  );

  factory Transfer.fromJson(Map<String, dynamic> json) => Transfer(
        getDefaultStringValue(json['sender']),
        getDefaultDoubleValue(json['amount']),
        getDefaultStringValue(json['asset']),
        getDefaultStringValue(json['receiver']),
        json['transferredAt'],
      );
}
