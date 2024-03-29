import 'package:ceres_tools_app/domain/repository/farming_repository.dart';

class GetFarming {
  final FarmingRepository repository;

  GetFarming({required this.repository});

  Future execute() async {
    return repository.getFarming();
  }
}
