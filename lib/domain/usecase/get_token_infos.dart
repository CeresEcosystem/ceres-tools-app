import 'package:ceres_locker_app/domain/repository/farming_repository.dart';

class GetTokenInfos {
  final FarmingRepository repository;

  GetTokenInfos({required this.repository});

  Future execute() async {
    return repository.getTokenInfos();
  }
}
