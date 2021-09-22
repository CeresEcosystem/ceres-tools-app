import 'package:intl/intl.dart';

String formatToCurrency(dynamic value, {bool showSymbol = false, int decimalDigits = 2}) {
  if (value != null) {
    String symbol = showSymbol ? '\$' : '';
    final formatCurrency = NumberFormat.currency(symbol: symbol, decimalDigits: decimalDigits);
    return formatCurrency.format(value);
  }

  return '';
}
