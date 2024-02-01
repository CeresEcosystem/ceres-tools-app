import 'package:ceres_tools_app/domain/repository/tracker_repository.dart';

class GetTrackerSupply {
  final TrackerRepository repository;

  GetTrackerSupply({required this.repository});

  Future execute(String token) async {
    return repository.getTrackerSupply(token);
  }
}
