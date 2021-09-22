import 'package:ceres_locker_app/data/datasource/farming_datasource.dart';
import 'package:ceres_locker_app/domain/repository/farming_repository.dart';

class FarmingRepositoryImpl implements FarmingRepository {
  final FarmingDatasource datasource;

  FarmingRepositoryImpl({required this.datasource});

  @override
  Future getFarming() async {
    try {
      return await datasource.getFarming();
    } on Exception catch (_) {}
  }
}
