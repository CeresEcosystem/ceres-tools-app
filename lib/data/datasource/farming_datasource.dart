import 'package:ceres_locker_app/data/api/api.dart';
import 'package:dio/dio.dart';

class FarmingDatasource {
  final RestClient client;

  FarmingDatasource({required this.client});

  Future getFarming() async {
    try {
      return await client.getFarming();
    } on DioError catch (_) {}
  }
}
