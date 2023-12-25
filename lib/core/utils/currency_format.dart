import 'package:ceres_tools_app/core/utils/default_value.dart';
import 'package:intl/intl.dart';

String formatToCurrency(dynamic value,
    {bool showSymbol = false,
    int decimalDigits = 2,
    bool formatOnlyFirstPart = false}) {
  try {
    if (value != null) {
      String stringValue = value.toString();
      String symbol = showSymbol ? '\$' : '';

      if (formatOnlyFirstPart) {
        List<String> parts = stringValue.split('.');
        final formatCurrency =
            NumberFormat.currency(symbol: symbol, decimalDigits: 0);
        String firstPart = formatCurrency.format(int.tryParse(parts[0]));
        if (parts[1] == '0') {
          return firstPart;
        }

        return '$firstPart.${parts[1]}';
      } else {
        final formatCurrency =
            NumberFormat.currency(symbol: symbol, decimalDigits: decimalDigits);
        return formatCurrency.format(value);
      }
    }

    return '';
  } catch (_) {
    return '\$$value';
  }
}

String formatDateToLocalTime(String date) {
  DateTime dateTime = DateTime.parse(date);
  dateTime = dateTime.toLocal();

  return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
}

String formatDateTimeToString(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
}

String formatDateToString(DateTime? date) {
  return date != null ? DateFormat('yyyy-MM-dd').format(date) : '';
}

String formatTimeToString(DateTime? time) {
  return time != null ? DateFormat('HH:mm').format(time) : '';
}

DateTime getDateFromString(String date) {
  return DateFormat('yyyy-MM-dd HH:mm').parse(date);
}

DateTime? combineDateAndTime(String date, String time) {
  if (date.isNotEmpty) {
    DateTime d = DateFormat('yyyy-MM-dd').parse(date);

    if (time.isNotEmpty) {
      DateTime t = DateFormat('HH:mm').parse(time);

      return DateTime(d.year, d.month, d.day, t.hour, t.minute);
    } else {
      return DateTime(d.year, d.month, d.day);
    }
  }

  return null;
}

String formatCurrencyGraph(dynamic value) {
  if (value != null) {
    final formatCurrency = NumberFormat.compactCurrency(symbol: '');
    return formatCurrency.format(value);
  }

  return '';
}

double dateStringToDouble(dynamic date) {
  if (date != null && date is String) {
    DateTime dt = DateTime.parse(date);
    double timestamp = dt.millisecondsSinceEpoch.toDouble();
    return timestamp;
  }

  return 0;
}

String formatDate(dynamic value,
    {bool formatFullDate = false, bool showDay = false}) {
  if (value != null && value.toString().length >= 8) {
    var dd =
        DateTime.fromMicrosecondsSinceEpoch(getDefaultIntValue(value)! * 1000);

    final month = dd.month;
    final day = dd.day;

    if (month > 12 || day > 31) {
      return '';
    }

    if (formatFullDate) {
      return DateFormat('yyyy-MM-dd').format(dd);
    }

    if (showDay) {
      return DateFormat.MMMd().format(dd);
    }

    return DateFormat.yMMM().format(dd);
  }

  return '';
}

String formatDateAndTime(dynamic value) {
  if (value != null && value.toString().length >= 8) {
    var dd =
        DateTime.fromMicrosecondsSinceEpoch(getDefaultIntValue(value)! * 1000);

    final month = dd.month;
    final day = dd.day;

    if (month > 12 || day > 31) {
      return '';
    }

    return DateFormat('yyyy-MM-dd HH:mm').format(dd);
  }

  return '';
}

bool checkNumberValue(dynamic number) {
  if (number != null && number != 0 && number != double.infinity) {
    return true;
  }

  return false;
}
