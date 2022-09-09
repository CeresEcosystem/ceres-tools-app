import 'package:ceres_locker_app/core/constants/constants.dart';

String imageExtension(String? imageName) {
  if (imageName != null && imageName.isNotEmpty) {
    if (imageName.contains('COCO') || imageName.contains('NOIR')) return kImagePNGExtension;
    return kImageExtension;
  }

  return kImageExtension;
}
