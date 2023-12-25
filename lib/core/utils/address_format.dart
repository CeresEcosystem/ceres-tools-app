String formatAddress(dynamic value, [int lenght = 7]) {
  if (value != null && value is String && value.length > lenght * 2) {
    return '${value.substring(0, lenght)}-${value.substring(value.length - lenght, value.length)}';
  }

  return '';
}

bool validWalletAddress(String address) {
  if (address.isNotEmpty && address.length == 49 && address.startsWith('cn')) {
    return true;
  }

  return false;
}
