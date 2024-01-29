import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DecimalFormatter extends TextInputFormatter {
  final int decimalDigits;

  DecimalFormatter({this.decimalDigits = 10}) : assert(decimalDigits >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    try {
      String newText;

      if (decimalDigits == 0) {
        newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
      } else {
        newText = newValue.text.replaceAll(RegExp('[^0-9.]'), '');
      }

      if (newText.contains('.')) {
        if (newText.trim() == '.') {
          return newValue.copyWith(
            text: '0.',
            selection: const TextSelection.collapsed(offset: 2),
          );
        } else if ((newText.split(".").length > 2) ||
            (newText.split(".")[1].length > decimalDigits)) {
          return oldValue;
        } else {
          return newValue;
        }
      }

      if (newText.trim() == '' || newText.trim() == '0') {
        return newValue.copyWith(text: '');
      } else if (int.parse(newText) < 1) {
        return newValue.copyWith(text: '');
      }

      double newDouble = double.parse(newText);
      var selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;

      String newString = NumberFormat("#,##0.##").format(newDouble);

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } catch (_) {
      return oldValue;
    }
  }
}
