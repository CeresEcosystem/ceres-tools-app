import 'package:ceres_locker_app/data/api/api.dart';
import 'package:dio/dio.dart';

class BannerDatasource {
  final RestClient client;

  BannerDatasource({required this.client});

  Future getBanners() async {
    try {
      return await client.getBanners();
    } on DioException catch (_) {}
  }
}
