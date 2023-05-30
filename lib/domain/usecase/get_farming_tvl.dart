import 'package:ceres_locker_app/domain/repository/farming_repository.dart';

class GetFarmingTVL {
  final FarmingRepository repository;

  GetFarmingTVL({required this.repository});

  Future execute(String farming) async {
    return repository.getFarmingTVL(farming);
  }
}
