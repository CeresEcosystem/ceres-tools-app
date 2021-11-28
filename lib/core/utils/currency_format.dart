import 'package:ceres_locker_app/core/utils/default_value.dart';
import 'package:intl/intl.dart';

String formatToCurrency(dynamic value, {bool showSymbol = false, int decimalDigits = 2, bool formatOnlyFirstPart = false}) {
  if (value != null) {
    String stringValue = value.toString();
    String symbol = showSymbol ? '\$' : '';

    if (formatOnlyFirstPart) {
      List<String> parts = stringValue.split('.');
      final formatCurrency = NumberFormat.currency(symbol: symbol, decimalDigits: 0);
      String firstPart = formatCurrency.format(int.tryParse(parts[0]));
      return '$firstPart.${parts[1]}';
    } else {
      final formatCurrency = NumberFormat.currency(symbol: symbol, decimalDigits: decimalDigits);
      return formatCurrency.format(value);
    }
  }

  return '';
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
    String d = date.replaceAll('-', '');
    return getDefaultDoubleValue(d)!;
  }

  return 0;
}

String formatDate(dynamic value, {bool formatFullDate = false, bool showDay = false}) {
  if (value != null && value.toString().length >= 8) {
    final date = value.toString();

    final year = date.substring(0, 4);
    final month = date.substring(4, 6);
    final day = date.substring(6, 8);

    if ((int.tryParse(month) != null && int.tryParse(month)! > 12) || (int.tryParse(day) != null && int.tryParse(day)! > 31)) {
      return '';
    }

    final d = year + '-' + month + '-' + day;
    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(d);

    if (formatFullDate) {
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }

    if (showDay) {
      return DateFormat.MMMd().format(dateTime);
    }

    return DateFormat.yMMM().format(dateTime);
  }

  return '';
}
