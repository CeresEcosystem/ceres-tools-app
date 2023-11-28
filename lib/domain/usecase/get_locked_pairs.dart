import 'package:ceres_tools_app/domain/repository/locker_repository.dart';

class GetLockedPairs {
  final LockerRepository repository;

  GetLockedPairs({required this.repository});

  Future execute(String baseToken, String token) async {
    return repository.getLockedPairs(baseToken, token);
  }
}
