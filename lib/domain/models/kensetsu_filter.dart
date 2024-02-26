import 'package:ceres_tools_app/core/utils/currency_format.dart';

class KensetsuFilter {
  DateTime? _dateFrom;
  DateTime? _dateTo;
  String? _accountId;

  KensetsuFilter();

  KensetsuFilter.arguments(
    this._dateFrom,
    this._dateTo,
    this._accountId,
  );

  DateTime? get dateFrom => _dateFrom;
  DateTime? get dateTo => _dateTo;
  String? get accountId => _accountId;

  List<Map<String, String>> getActiveFilters() {
    List<Map<String, String>> activeFilters = [];

    if (_dateFrom != null) {
      activeFilters.add({
        'label': 'Date from: ',
        'filter': formatDateTimeToString(_dateFrom!),
      });
    }

    if (_dateTo != null) {
      activeFilters.add({
        'label': 'Date to: ',
        'filter': formatDateTimeToString(_dateTo!),
      });
    }

    if (_accountId != null && _accountId!.isNotEmpty) {
      activeFilters.add({
        'label': 'Account Id: ',
        'filter': _accountId!,
      });
    }

    return activeFilters;
  }

  bool isSet() {
    return _dateFrom != null || _dateTo != null || _accountId != null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KensetsuFilter &&
        other._dateFrom == _dateFrom &&
        other._dateTo == _dateTo &&
        other._accountId == _accountId;
  }

  @override
  int get hashCode {
    return _dateFrom.hashCode ^ _dateTo.hashCode ^ _accountId.hashCode;
  }
}
