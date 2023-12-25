import 'package:ceres_tools_app/core/utils/currency_format.dart';

class SwapFilter {
  DateTime? _dateFrom;
  DateTime? _dateTo;
  String? _minAmount;
  String? _maxAmount;
  String? _assetId;
  String? _assetIdAddress;

  SwapFilter();

  SwapFilter.arguments(
    this._dateFrom,
    this._dateTo,
    this._minAmount,
    this._maxAmount,
    this._assetId,
    this._assetIdAddress,
  );

  DateTime? get dateFrom => _dateFrom;
  DateTime? get dateTo => _dateTo;
  String? get minAmount => _minAmount;
  String? get maxAmount => _maxAmount;
  String? get assetId => _assetId;
  String? get assetIdAddress => _assetIdAddress;

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

    if (_minAmount != null) {
      activeFilters.add({
        'label': 'Min amount: ',
        'filter': _minAmount!,
      });
    }

    if (_maxAmount != null) {
      activeFilters.add({
        'label': 'Max amount: ',
        'filter': _maxAmount!,
      });
    }

    if (_assetId != null) {
      activeFilters.add({
        'label': 'Token: ',
        'filter': _assetId!,
      });
    }

    return activeFilters;
  }

  bool isSet() {
    return _dateFrom != null ||
        _dateTo != null ||
        _minAmount != null ||
        _maxAmount != null ||
        _assetId != null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SwapFilter &&
        other._dateFrom == _dateFrom &&
        other._dateTo == _dateTo &&
        other._minAmount == _minAmount &&
        other._maxAmount == _maxAmount &&
        other._assetId == _assetId;
  }

  @override
  int get hashCode {
    return _dateFrom.hashCode ^
        _dateTo.hashCode ^
        _minAmount.hashCode ^
        _maxAmount.hashCode ^
        _assetId.hashCode;
  }
}
