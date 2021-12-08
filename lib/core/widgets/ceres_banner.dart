import 'package:carousel_slider/carousel_slider.dart';
import 'package:ceres_locker_app/core/widgets/empty_widget.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:ceres_locker_app/domain/models/banners.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CeresBanner extends StatelessWidget {
  const CeresBanner({Key? key}) : super(key: key);

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Banners.instance.banners.isNotEmpty) {
      return Responsive(
        builder: (context, sizingInformation) {
          final height = sizingInformation.screenSize.width / 3.54;

          return CarouselSlider(
            items: Banners.instance.banners
                .map(
                  (item) => GestureDetector(
                    onTap: () => _launchURL(item['link']),
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: item['lg'],
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
              autoPlayInterval: const Duration(seconds: 10),
              enableInfiniteScroll: Banners.instance.banners.length > 1
            ),
          );
        },
      );
    }

    return const EmptyWidget();
  }
}
