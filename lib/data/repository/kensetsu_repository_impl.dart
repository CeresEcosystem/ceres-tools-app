import 'package:ceres_tools_app/data/datasource/kensetsu_datasource.dart';
import 'package:ceres_tools_app/domain/models/kensetsu_filter.dart';
import 'package:ceres_tools_app/domain/repository/kensetsu_repository.dart';

class KensetsuRepositoryImpl implements KensetsuRepository {
  final KensetsuDatasource datasource;

  KensetsuRepositoryImpl({required this.datasource});

  @override
  Future getKensetsuBurns(
    int page,
    KensetsuFilter kensetsuFilter,
  ) async {
    try {
      return await datasource.getKensetsuBurns(
        page,
        kensetsuFilter,
      );
    } on Exception catch (_) {}
  }
}
