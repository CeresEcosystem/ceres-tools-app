String formatAddress(dynamic value) {
  if (value != null && value is String && value.length > 14) {
    return '${value.substring(0, 7)}-${value.substring(value.length - 7, value.length)}';
  }

  return '';
}