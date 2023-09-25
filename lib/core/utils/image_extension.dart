import 'package:ceres_locker_app/core/constants/constants.dart';

const pngIcons = [
  'COCO',
  'NOIR',
  'XSTAVAX',
  'XSTBTC',
  'XSTBRL',
  'XSTCNY',
  'XSTDOGE',
  'XSTEUR',
  'XSTGBP',
  'XSTXAU',
  'XSTHKD',
  'XSTJPY',
  'XSTLTC',
  'XSTXMR',
  'XSTTWD',
  'XSTRUB',
  'XSTSAR',
  'XSTSHIB',
  'XSTXAG',
  'XSTCHF',
  'XSTTHB',
  'XSTTRX',
  'XSTTRY'
];

String imageExtension(String? imageName) {
  if (imageName != null && imageName.isNotEmpty) {
    if (pngIcons.contains(imageName)) {
      return kImagePNGExtension;
    }
    return kImageExtension;
  }

  return kImageExtension;
}
