import 'package:ceres_tools_app/domain/repository/farming_repository.dart';

class GetDemeterFarms {
  final FarmingRepository repository;

  GetDemeterFarms({required this.repository});

  Future execute() async {
    return repository.getDemeterFarms();
  }
}
