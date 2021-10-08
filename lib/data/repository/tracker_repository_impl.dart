import 'package:ceres_locker_app/data/datasource/tracker_datasource.dart';
import 'package:ceres_locker_app/domain/repository/tracker_repository.dart';

class TrackerRepositoryImpl implements TrackerRepository {
  final TrackerDatasource datasource;

  TrackerRepositoryImpl({required this.datasource});

  @override
  Future getTracker() async {
    try {
      return await datasource.getTracker();
    } on Exception catch (_) {}
  }
}
