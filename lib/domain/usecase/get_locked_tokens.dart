import 'package:ceres_tools_app/domain/repository/locker_repository.dart';

class GetLockedTokens {
  final LockerRepository repository;

  GetLockedTokens({required this.repository});

  Future execute(String token) async {
    return repository.getLockedTokens(token);
  }
}
