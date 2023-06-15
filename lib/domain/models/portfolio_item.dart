import 'package:ceres_locker_app/core/utils/default_value.dart';

class PortfolioItem {
  final String? fullName;
  final String? token;
  final double? price;
  final double? balance;
  final double? value;
  final double? oneHour;
  final double? oneDay;
  final double? oneWeek;
  final double? oneMonth;

  PortfolioItem({
    this.fullName,
    this.token,
    this.price,
    this.balance,
    this.value,
    this.oneHour,
    this.oneDay,
    this.oneWeek,
    this.oneMonth,
  });

  factory PortfolioItem.fromJson(Map<String, dynamic> json) => PortfolioItem(
        fullName: getDefaultStringValue(json['fullName']),
        token: getDefaultStringValue(json['token']),
        price: getDefaultDoubleValue(json['price']),
        balance: getDefaultDoubleValue(json['balance']),
        value: getDefaultDoubleValue(json['value']),
        oneHour: getDefaultDoubleValue(json['oneHour']),
        oneDay: getDefaultDoubleValue(json['oneDay']),
        oneWeek: getDefaultDoubleValue(json['oneWeek']),
        oneMonth: getDefaultDoubleValue(json['oneMonth']),
      );
}
