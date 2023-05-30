import 'package:ceres_locker_app/domain/repository/farming_repository.dart';

class GetDemeterPools {
  final FarmingRepository repository;

  GetDemeterPools({required this.repository});

  Future execute() async {
    return repository.getDemeterPools();
  }
}
