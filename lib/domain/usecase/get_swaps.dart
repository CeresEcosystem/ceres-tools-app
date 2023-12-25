import 'package:ceres_tools_app/domain/models/swap_filter.dart';
import 'package:ceres_tools_app/domain/repository/swaps_repository.dart';

class GetSwaps {
  final SwapsRepository repository;

  GetSwaps({required this.repository});

  Future execute(
    List<String> tokens,
    int page,
    SwapFilter swapFilter,
  ) async {
    return repository.getSwaps(
      tokens,
      page,
      swapFilter,
    );
  }
}
