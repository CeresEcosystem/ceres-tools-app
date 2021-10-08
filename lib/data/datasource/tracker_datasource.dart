import 'package:ceres_locker_app/data/api/api.dart';
import 'package:dio/dio.dart';

class TrackerDatasource {
  final RestClient client;

  TrackerDatasource({required this.client});

  Future getTracker() async {
    try {
      return await client.getTracker();
    } on DioError catch (_) {}
  }
}
