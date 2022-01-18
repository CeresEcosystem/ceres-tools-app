import 'package:ceres_locker_app/domain/models/locked_item.dart';

class LockedItemList {
  final List<LockedItem>? _lockedItems;

  const LockedItemList(this._lockedItems);

  List<LockedItem>? get lockedItems => _lockedItems;

  factory LockedItemList.fromJson(List<dynamic> json) {
    return LockedItemList(
      json.map((e) => LockedItem.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
