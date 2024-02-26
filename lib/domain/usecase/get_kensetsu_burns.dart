import 'package:ceres_tools_app/domain/models/kensetsu_filter.dart';
import 'package:ceres_tools_app/domain/repository/kensetsu_repository.dart';

class GetKensetsuBurns {
  final KensetsuRepository repository;

  GetKensetsuBurns({required this.repository});

  Future execute(
    int page,
    KensetsuFilter kensetsuFilter,
  ) async {
    return repository.getKensetsuBurns(
      page,
      kensetsuFilter,
    );
  }
}
