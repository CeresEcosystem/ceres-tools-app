import 'package:ceres_tools_app/domain/models/swap_filter.dart';
import 'package:ceres_tools_app/domain/models/swap_tokens_json.dart';
import 'package:ceres_tools_app/domain/repository/swaps_repository.dart';

class GetSwaps {
  final SwapsRepository repository;

  GetSwaps({required this.repository});

  Future execute(
    SwapTokensJSON swapTokensJSON,
    int page,
    SwapFilter swapFilter,
  ) async {
    return repository.getSwaps(
      swapTokensJSON,
      page,
      swapFilter,
    );
  }
}
