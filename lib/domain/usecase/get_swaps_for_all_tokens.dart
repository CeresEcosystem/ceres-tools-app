import 'package:ceres_tools_app/domain/models/swap_filter.dart';
import 'package:ceres_tools_app/domain/repository/swaps_repository.dart';

class GetSwapsForAllTokens {
  final SwapsRepository repository;

  GetSwapsForAllTokens({required this.repository});

  Future execute(
    int page,
    SwapFilter swapFilter,
  ) async {
    return repository.getSwapsForAllTokens(
      page,
      swapFilter,
    );
  }
}
