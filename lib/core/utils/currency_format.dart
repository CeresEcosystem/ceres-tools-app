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
