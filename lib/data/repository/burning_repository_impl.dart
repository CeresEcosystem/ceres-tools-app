import 'package:ceres_tools_app/data/datasource/burning_datasource.dart';
import 'package:ceres_tools_app/domain/models/burn_filter.dart';
import 'package:ceres_tools_app/domain/repository/burning_repository.dart';

class BurningRepositoryImpl implements BurningRepository {
  final BurningDatasource datasource;

  BurningRepositoryImpl({required this.datasource});

  @override
  Future getBurns(
    String token,
    int page,
    BurnFilter burnFilter,
  ) async {
    try {
      return await datasource.getBurns(
        token,
        page,
        burnFilter,
      );
    } on Exception catch (_) {}
  }
}
