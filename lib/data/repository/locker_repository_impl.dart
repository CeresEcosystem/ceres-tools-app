import 'package:ceres_locker_app/data/datasource/locker_datasource.dart';
import 'package:ceres_locker_app/domain/repository/locker_repository.dart';

class LockerRepositoryImpl implements LockerRepository {
  final LockerDatasource datasource;

  LockerRepositoryImpl({required this.datasource});

  @override
  Future getLockedPairs(String baseToken, String token) async {
    try {
      return await datasource.getLockedPairs(baseToken, token);
    } on Exception catch (_) {}
  }

  @override
  Future getLockedTokens(String token) async {
    try {
      return await datasource.getLockedTokens(token);
    } on Exception catch (_) {}
  }
}
