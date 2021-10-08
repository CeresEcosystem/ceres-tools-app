import 'package:ceres_locker_app/core/constants/constants.dart';
import 'package:ceres_locker_app/core/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoundImage extends StatelessWidget {
  final double? size;
  final String image;
  final BoxFit? boxFit;
  final String extension;
  final bool localImage;

  const RoundImage({
    Key? key,
    this.size = 64.0,
    required this.image,
    this.boxFit = BoxFit.cover,
    this.extension = kImageExtension,
    this.localImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: size! / 2,
        child: ClipOval(
          child: SizedBox(
            width: size,
            height: size,
            child: image.isNotEmpty
                ? localImage
                    ? Image.asset(
                        image,
                        fit: boxFit,
                      )
                    : extension == kImageExtension
                        ? SvgPicture.network(
                            image,
                            fit: boxFit!,
                          )
                        : Image.network(
                            image,
                            fit: boxFit,
                          )
                : const EmptyWidget(),
          ),
        ),
      ),
    );
  }
}
