import 'package:ceres_locker_app/core/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void showToastAndCopy(String snackbarTitle, String? snackbarMessage,
    {bool shouldCopy = true, String? clipboardText = ''}) {
  if (shouldCopy) {
    Clipboard.setData(ClipboardData(text: clipboardText ?? ''));
  }

  Get.snackbar(
    snackbarTitle,
    snackbarMessage ?? '',
    backgroundColor: backgroundColorLight,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 2),
    animationDuration: const Duration(milliseconds: 500),
    isDismissible: false,
    margin: const EdgeInsets.all(0),
    snackStyle: SnackStyle.GROUNDED,
  );
}
