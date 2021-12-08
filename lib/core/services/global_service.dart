import 'package:ceres_locker_app/data/datasource/banner_datasource.dart';
import 'package:ceres_locker_app/di/injector.dart';
import 'package:ceres_locker_app/domain/models/banners.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class GlobalService extends GetxService {
  final datasource = Injector.resolve!<BannerDatasource>();

  Future<bool> init() async {
    try {
      final response = await datasource.getBanners();

      if (response != null) {
        Banners.instance.setBanners(response);
      }
    } on DioError catch (_) {}

    return Future.value(true);
  }
}