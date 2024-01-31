import 'package:ceres_tools_app/data/datasource/tracker_datasource.dart';
import 'package:ceres_tools_app/domain/repository/tracker_repository.dart';

class TrackerRepositoryImpl implements TrackerRepository {
  final TrackerDatasource datasource;

  TrackerRepositoryImpl({required this.datasource});

  @override
  Future getTracker(String token) async {
    try {
      return await datasource.getTracker(token);
    } on Exception catch (_) {}
  }

  @override
  Future getTrackerBlocks(String token, String type, int page) async {
    try {
      return await datasource.getTrackerBlocks(token, type, page);
    } on Exception catch (_) {}
  }
}
