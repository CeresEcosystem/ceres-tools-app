import 'package:ceres_tools_app/core/utils/default_value.dart';

class PortfolioItem {
  final String? fullName;
  final String? token;
  final String? baseAsset;
  final double? price;
  final double? balance;
  final double? value;
  final double? oneHour;
  final double? oneHourValueDifference;
  final double? oneDay;
  final double? oneDayValueDifference;
  final double? oneWeek;
  final double? oneWeekValueDifference;
  final double? oneMonth;
  final double? oneMonthValueDifference;
  final double? baseAssetLiqHolding;
  final double? tokenLiqHolding;

  PortfolioItem({
    this.fullName,
    this.token,
    this.baseAsset,
    this.price,
    this.balance,
    this.value,
    this.oneHour,
    this.oneHourValueDifference,
    this.oneDay,
    this.oneDayValueDifference,
    this.oneWeek,
    this.oneWeekValueDifference,
    this.oneMonth,
    this.oneMonthValueDifference,
    this.baseAssetLiqHolding,
    this.tokenLiqHolding,
  });

  factory PortfolioItem.fromJson(Map<String, dynamic> json) => PortfolioItem(
        fullName: getDefaultStringValue(json['fullName']),
        token: getDefaultStringValue(json['token']),
        baseAsset: getDefaultStringValue(json['baseAsset']),
        price: getDefaultDoubleValue(json['price']),
        balance: getDefaultDoubleValue(json['balance']),
        value: getDefaultDoubleValue(json['value']),
        oneHour: getDefaultDoubleValue(json['oneHour']),
        oneHourValueDifference:
            getDefaultDoubleValue(json['oneHourValueDifference']),
        oneDay: getDefaultDoubleValue(json['oneDay']),
        oneDayValueDifference:
            getDefaultDoubleValue(json['oneDayValueDifference']),
        oneWeek: getDefaultDoubleValue(json['oneWeek']),
        oneWeekValueDifference:
            getDefaultDoubleValue(json['oneWeekValueDifference']),
        oneMonth: getDefaultDoubleValue(json['oneMonth']),
        oneMonthValueDifference:
            getDefaultDoubleValue(json['oneMonthValueDifference']),
        baseAssetLiqHolding: getDefaultDoubleValue(json['baseAssetLiqHolding']),
        tokenLiqHolding: getDefaultDoubleValue(json['tokenLiqHolding']),
      );
}
