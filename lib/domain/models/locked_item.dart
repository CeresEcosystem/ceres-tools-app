import 'package:ceres_locker_app/core/utils/default_value.dart';
import 'package:intl/intl.dart';

class LockedItem {
  final String? account;
  final double? locked;
  final String? date;
  final String? time;

  LockedItem({
    this.account,
    this.locked,
    this.date,
    this.time,
  });

  String get formattedDate {
    if (date != null) {
      DateFormat format = DateFormat("MMMM dd, yyyy");
      DateTime dateTime = DateFormat('yyyy-MM-dd').parse(date!);
      return format.format(dateTime);
    }

    return '';
  }

  String get formattedTime {
    if (time != null) {
      DateFormat format = DateFormat("HH:mm");
      DateTime dateTime = DateFormat('HH:mm:ss').parse(time!);
      return '${format.format(dateTime)}h';
    }

    return '';
  }

  factory LockedItem.fromJson(Map<String, dynamic> json) => LockedItem(
        account: getDefaultStringValue(json['account']),
        locked: getDefaultDoubleValue(json['locked']),
        date: getDefaultStringValue(json['date']),
        time: getDefaultStringValue(json['time']),
      );
}
