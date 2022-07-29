import 'package:ceres_locker_app/core/utils/default_value.dart';
import 'package:intl/intl.dart';

class LockedItem {
  final String? account;
  final double? locked;
  final int? dateTimestamp;

  LockedItem({
    this.account,
    this.locked,
    this.dateTimestamp,
  });

  String get formattedDate {
    if (dateTimestamp != null) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(dateTimestamp!);
      DateFormat format = DateFormat("MMMM dd, yyyy");
      return format.format(date);
    }

    return '';
  }

  String get formattedTime {
    if (dateTimestamp != null) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(dateTimestamp!);
      DateFormat format = DateFormat("HH:mm");
      return format.format(date);
    }

    return '';
  }

  factory LockedItem.fromJson(Map<String, dynamic> json) => LockedItem(
        account: getDefaultStringValue(json['account']),
        locked: getDefaultDoubleValue(json['locked']),
        dateTimestamp: getDefaultIntValue(json['timestamp']),
      );
}
