import 'package:ceres_tools_app/domain/models/swap_filter.dart';

abstract class SwapsRepository {
  Future getSwaps(
    List<String> tokens,
    int page,
    SwapFilter swapFilter,
  );
  Future getSwapsForAllTokens(
    int page,
    SwapFilter swapFilter,
  );
}
