String formatAddress(dynamic value, [int lenght = 7]) {
  if (value != null && value is String && value.length > lenght * 2) {
    return '${value.substring(0, lenght)}-${value.substring(value.length - lenght, value.length)}';
  }

  return '';
}

bool containsOnlyAlphaNumeric(String str) {
  RegExp alphaNumeric = RegExp(r'^[a-zA-Z0-9]+$');
  return alphaNumeric.hasMatch(str);
}

bool validWalletAddress(String address) {
  if (address.isNotEmpty &&
      address.length == 49 &&
      address.startsWith('cn') &&
      containsOnlyAlphaNumeric(address)) {
    return true;
  }

  return false;
}
