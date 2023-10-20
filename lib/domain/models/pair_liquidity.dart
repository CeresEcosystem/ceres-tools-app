import 'package:intl/intl.dart';

class PairLiquidity {
  final String signerId;
  final String firstAssetId;
  final String secondAssetId;
  final String firstAssetAmount;
  final String secondAssetAmount;
  final String transactionType;
  final int timestamp;
  String firstAssetAmountFormatted = '0';
  String secondAssetAmountFormatted = '0';
  String? transactionTypeFormatted;
  String? accountIdFormatted;

  PairLiquidity(
    this.signerId,
    this.firstAssetId,
    this.secondAssetId,
    this.firstAssetAmount,
    this.secondAssetAmount,
    this.transactionType,
    this.timestamp,
  );

  factory PairLiquidity.fromJson(Map<String, dynamic> json) => PairLiquidity(
        json['signerId'],
        json['firstAssetId'],
        json['secondAssetId'],
        json['firstAssetAmount'],
        json['secondAssetAmount'],
        json['transactionType'],
        json['timestamp'],
      );

  String get formattedDate {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm");
    return format.format(date);
  }
}
