import 'package:ceres_tools_app/data/api/api.dart';
import 'package:dio/dio.dart';

class TrackerDatasource {
  final RestClient client;

  TrackerDatasource({required this.client});

  Future getTracker(String token) async {
    try {
      return await client.getTracker(token);
    } on DioException catch (_) {}
  }

  Future getTrackerBlocks(String token, String type, int page,
      [int size = 5]) async {
    try {
      return await client.getTrackerBlocks(token, type, page, size);
    } on DioException catch (_) {}
  }
}
