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

  @override
  Future getFarmingTVL(String farming) async {
    try {
      return await datasource.getFarmingTVL(farming);
    } on Exception catch (_) {}
  }

  @override
  Future getTokenInfos() async {
    try {
      return await datasource.getTokenInfos();
    } on Exception catch (_) {}
  }

  @override
  Future getDemeterFarms() async {
    try {
      return await datasource.getDemeterFarms();
    } on Exception catch (_) {}
  }

  @override
  Future getDemeterPools() async {
    try {
      return await datasource.getDemeterPools();
    } on Exception catch (_) {}
  }
}
