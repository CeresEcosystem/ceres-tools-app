import 'package:ceres_tools_app/domain/repository/tracker_repository.dart';

class GetTrackerBlocks {
  final TrackerRepository repository;

  GetTrackerBlocks({required this.repository});

  Future execute(String token, String type, int page) async {
    return repository.getTrackerBlocks(token, type, page);
  }
}
