import 'package:ceres_locker_app/core/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoundImage extends StatelessWidget {
  final double? size;
  final String image;
  final BoxFit? boxFit;

  const RoundImage({
    Key? key,
    this.size = 64.0,
    required this.image,
    this.boxFit = BoxFit.cover,
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
                ? SvgPicture.network(
                    image,
                    fit: boxFit!,
                  )
                : const EmptyWidget(),
          ),
        ),
      ),
    );
  }
}
