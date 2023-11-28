import 'package:ceres_tools_app/domain/repository/tracker_repository.dart';

class GetTracker {
  final TrackerRepository repository;

  GetTracker({required this.repository});

  Future execute(String token) async {
    return repository.getTracker(token);
  }
}
