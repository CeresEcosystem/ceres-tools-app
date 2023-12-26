import 'package:ceres_tools_app/data/datasource/swaps_datasource.dart';
import 'package:ceres_tools_app/domain/models/swap_filter.dart';
import 'package:ceres_tools_app/domain/models/swap_tokens_json.dart';
import 'package:ceres_tools_app/domain/repository/swaps_repository.dart';

class SwapsRepositoryImpl implements SwapsRepository {
  final SwapsDatasource datasource;

  SwapsRepositoryImpl({required this.datasource});

  @override
  Future getSwaps(
    SwapTokensJSON swapTokensJSON,
    int page,
    SwapFilter swapFilter,
  ) async {
    try {
      return await datasource.getSwaps(
        swapTokensJSON,
        page,
        swapFilter,
      );
    } on Exception catch (_) {}
  }

  @override
  Future getSwapsForAllTokens(
    int page,
    SwapFilter swapFilter,
  ) async {
    try {
      return await datasource.getSwapsForAllTokens(
        page,
        swapFilter,
      );
    } on Exception catch (_) {}
  }
}
