import 'package:ceres_tools_app/domain/models/swap_filter.dart';
import 'package:ceres_tools_app/domain/models/swap_tokens_json.dart';

abstract class SwapsRepository {
  Future getSwaps(
    SwapTokensJSON swapTokensJSON,
    int page,
    SwapFilter swapFilter,
  );
  Future getSwapsForAllTokens(
    int page,
    SwapFilter swapFilter,
  );
}
