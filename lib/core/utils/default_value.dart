String? getDefaultStringValue(dynamic value, {String defaultValue = '', bool nullable = false}) {
  if (value != null) {
    if (value is String) {
      return value;
    } else {
      return value.toString();
    }
  }

  if (nullable) {
    return null;
  }

  return defaultValue;
}

int? getDefaultIntValue(dynamic value, {int defaultValue = 0, bool nullable = false}) {
  if (value != null) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      if (int.tryParse(value) != null) {
        return int.tryParse(value);
      }
    }
    if (value is double) {
      return value.toInt();
    }
  }

  if (nullable) {
    return null;
  }

  return defaultValue;
}

double? getDefaultDoubleValue(dynamic value, {double defaultValue = 0, bool nullable = false}) {
  if (value != null) {
    if (value is double) {
      return value;
    }
    if (value is String) {
      if (double.tryParse(value) != null) {
        return double.tryParse(value);
      }
    }
    if (value is int) {
      return value.toDouble();
    }
  }

  if (nullable) {
    return null;
  }

  return defaultValue;
}

bool? getDefaultBoolValue(dynamic value, {bool defaultValue = false, bool nullable = false}) {
  if (value != null) {
    if (value is bool) {
      return value;
    }
    if (value == '1' || value == 1) {
      return true;
    }

    if (value == '0' || value == 0) {
      return false;
    }
  }

  if (nullable) {
    return null;
  }

  return defaultValue;
}

Map<String, dynamic>? getDefaultMapValue(dynamic value, {bool nullable = false}) {
  if (value != null) {
    if (value is Map<String, dynamic>) {
      return value;
    }
  }

  if (nullable) {
    return null;
  }

  return {};
}

List? getDefaultListValue(dynamic value, {bool nullable = false}) {
  if (value != null) {
    if (value is List) {
      return value;
    } else {
      return [value];
    }
  }

  if (nullable) {
    return null;
  }

  return [];
}

String checkEmptyString(dynamic value) {
  if (value != null) {
    if (value is String) {
      return value;
    } else {
      return value.toString();
    }
  }

  return '';
}
