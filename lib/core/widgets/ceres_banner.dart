import 'package:carousel_slider/carousel_slider.dart';
import 'package:ceres_tools_app/core/enums/device_screen_type.dart';
import 'package:ceres_tools_app/core/utils/launch_url.dart';
import 'package:ceres_tools_app/core/widgets/empty_widget.dart';
import 'package:ceres_tools_app/core/widgets/responsive.dart';
import 'package:ceres_tools_app/domain/models/banners.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CeresBanner extends StatelessWidget {
  const CeresBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Banners.instance.banners.isNotEmpty) {
      return Responsive(
        builder: (context, sizingInformation) {
          final height =
              sizingInformation.deviceScreenType == DeviceScreenType.Mobile
                  ? sizingInformation.screenSize.width / 5
                  : sizingInformation.screenSize.width / 6;

          return CarouselSlider(
            items: Banners.instance.banners
                .map(
                  (item) => GestureDetector(
                    onTap: () => launchURL(item['link']),
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: sizingInformation.deviceScreenType ==
                                DeviceScreenType.Mobile
                            ? item['sm']
                            : item['lg'],
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            options: CarouselOptions(
                height: height,
                aspectRatio: 1,
                viewportFraction: 1,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 7),
                enableInfiniteScroll: Banners.instance.banners.length > 1),
          );
        },
      );
    }

    return const EmptyWidget();
  }
}
