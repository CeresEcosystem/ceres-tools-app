import 'package:ceres_tools_app/domain/repository/swaps_repository.dart';

class GetSwaps {
  final SwapsRepository repository;

  GetSwaps({required this.repository});

  Future execute(List<String> tokens, int page) async {
    return repository.getSwaps(tokens, page);
  }
}
