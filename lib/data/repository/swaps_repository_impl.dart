import 'package:ceres_tools_app/data/datasource/swaps_datasource.dart';
import 'package:ceres_tools_app/domain/repository/swaps_repository.dart';

class SwapsRepositoryImpl implements SwapsRepository {
  final SwapsDatasource datasource;

  SwapsRepositoryImpl({required this.datasource});

  @override
  Future getSwaps(List<String> tokens, int page) async {
    try {
      return await datasource.getSwaps(tokens, page);
    } on Exception catch (_) {}
  }

  @override
  Future getSwapsForAllTokens(int page) async {
    try {
      return await datasource.getSwapsForAllTokens(page);
    } on Exception catch (_) {}
  }
}
