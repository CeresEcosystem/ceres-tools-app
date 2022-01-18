import 'package:ceres_locker_app/domain/repository/locker_repository.dart';

class GetLockedPairs {
  final LockerRepository repository;

  GetLockedPairs({required this.repository});

  Future execute(String token) async {
    return repository.getLockedPairs(token);
  }
}
